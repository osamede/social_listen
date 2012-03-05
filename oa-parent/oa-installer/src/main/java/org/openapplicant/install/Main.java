package org.openapplicant.install;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.taskdefs.Copy;
import org.apache.tools.ant.taskdefs.ExecTask;
import org.apache.tools.ant.taskdefs.War;
import org.codehaus.plexus.util.Expand;
import org.jasypt.digest.StandardStringDigester;


/**
 * Hello world!
 *
 */
public class Main {

	public static BufferedReader input;
	
	private static final StandardStringDigester stringDigester = new StandardStringDigester();
	
	static {
		stringDigester.setAlgorithm("SHA-1");
		stringDigester.setIterations(1000);
	}
		
	public static enum VALIDATION {
		SERVER_EXISTS, NONE, INTEGER, NOT_NULL, EMAIL, YES_NO, FILE_EXISTS
	};
	
	protected static Project p;
	
	public static void main(String[] args) throws Exception {
		p = new Project();
		p.init();
		
		// TODO:  allow stdin to be redirected
		input = new BufferedReader(new InputStreamReader(System.in));
			
		// introductory material
		System.out.println("This installer will configure Open Applicant for your environment\n"+
				"and prepare a war file to deploy to your server.  You will need to\n"+
				"enter information about your Tomcat server, MySQL server, \noutgoing mail server," +
				"and (optional) incoming mail server.\n\n");
		
		System.out.println("Please enter the following information (or hit return to keep defaults):\n");
		
		// gather config data
		
		Map<String,String> dbOpts = null;
		String url = null;
		do {
			dbOpts = configDB();
			url = makeUrl(dbOpts);
			System.out.println("To create the database, you'll need administrative access to your");
			System.out.println("MySQL Server.");
			String shouldWe = prompt("Should we drop and create the database?","yes",VALIDATION.YES_NO);
			if (shouldWe.equals("yes")) {
				String adminUser = prompt("Admin user","root",VALIDATION.NOT_NULL);
				String adminPass = prompt("Admin password","",VALIDATION.NONE);

				boolean grant = false;
				String shouldGrant = prompt("Should we grant access to the configured user?","yes",VALIDATION.YES_NO);
				if (shouldGrant.equals("yes")) {
					grant = true;
				}
				
				String adminUrl = "jdbc:mysql://"+dbOpts.get("datasource.server")+":"+dbOpts.get("datasource.port");
				createDB(adminUrl, adminUser, adminPass, dbOpts.get("datasource.dbname"), grant, 
							dbOpts.get("datasource.username"),dbOpts.get("datasource.password"));
			}
		} while (!checkDB(url, dbOpts.get("datasource.username"),dbOpts.get("datasource.password")));
		
		Map<String,String> mailSenderOpts = configMailSender();
		Map<String,String> emailConnectorOpts = configFacilitator();
		Map<String,String> setupOpts = configSetup();
		
		propHelper(dbOpts,mailSenderOpts,emailConnectorOpts,setupOpts);
		
		// extract the war from the jar
		System.out.println("Extracting war from .jar; Please be patient, this is a slow process.");
		File warFile = extractFile("/openapplicant.war","openapplicant","war");

		System.out.println("Unzipping warfile.");
		File warDir = File.createTempFile("openapplicant","dir");
		warDir.delete();
		warDir.mkdir();
		expandZip(warFile,warDir);
		
		System.out.println("filtering application properties.");
		File propFile = new File(warDir.getAbsolutePath()+"/WEB-INF/classes/application.properties");
		File newPropFile = filterFile(propFile);
		propFile.delete();
		newPropFile.renameTo(propFile);
		
		System.out.println("generating tomcat deployment descriptor");
		File contextXml = new File(warDir.getAbsolutePath() + "/META-INF/context.xml");
		FileUtils.forceDelete(contextXml);
		FileUtils.writeStringToFile(
				contextXml, 
				IOUtils.toString(Main.class.getResourceAsStream("/context.xml")),
				"utf-8"
		);
		FileUtils.copyFile(filterFile(contextXml), contextXml);
		
		System.out.println("making new war file.");
		File newWarFile = makeWar(warDir);
		warFile.delete();
		newWarFile.renameTo(warFile);
		warDir.delete();
		
		
		// confirm database connection
		// attempt to create the database if it doesn't exist
		
		
		// extract the schema file from the jar
		String installSchema = prompt("Should we install the schema?","yes",VALIDATION.YES_NO);
		if (installSchema.equals("yes")) {
			System.out.println("Extracting schema from .jar");
			File schemaFile = extractFile("/schema.sql", "schema", "sql");
	
			System.out.println("Filtering schema file");
			File filteredSchemaFile = filterFile(schemaFile);
			String mysql = prompt("Path to MySQL binary?","/usr/local/bin/mysql",VALIDATION.FILE_EXISTS);
			loadSchema(mysql,dbOpts,filteredSchemaFile);
		}
		
		// copy JSTL and MySQL jars into tomcat lib directory
		String installJars = prompt("Should we install jarfiles?","yes",VALIDATION.YES_NO);
		if (installJars.equals("yes")) {
			String tomcat = prompt("Tomcat Home Directory","",VALIDATION.FILE_EXISTS);

			System.out.print("Copying JSTL-1.2 jar to tomcat home directory.");
			File jstlJar = extractFile("/jstl-1.2.jar", "jstl", "jar");
			jstlJar.renameTo(new File(tomcat + "/lib/jstl-1.2.jar"));

			System.out.print("Copying mysql.jar to tomcat home directory.");
			File mysqlJar = extractFile("/mysql.jar", "mysql", "jar");
			mysqlJar.renameTo(new File(tomcat + "/lib/mysql.jar"));
		}
		
		
		// print the results
		String destFile = prompt("Write the completed .war file to?","openapplicant.war",VALIDATION.NONE);
		File newDestFile = new File(destFile);
		newDestFile.delete();
		warFile.renameTo(newDestFile);
		// delete the turd files
		System.out.println("The .war file has been written to "+destFile);
		System.out.println("You may deploy it to your application server and log in as "+setupOpts.get("oa.adminUser")+" with the password "+setupOpts.get("oa.rawPassword"));
	}
	
	
	private static String makeUrl(Map<String, String> dbOpts) {
		return "jdbc:mysql://"+dbOpts.get("datasource.server")+":"+dbOpts.get("datasource.port")+"/"+dbOpts.get("datasource.dbname");
	}


	private static void propHelper(Map<String, String>... files) {
		for(Map<String,String> map : files) {
			for(String key : map.keySet()) {
				p.getGlobalFilterSet().addFilter(key,map.get(key));
			}
		}
	}


	/**
	 * prompt prompts the user for a value and performs the specified type of validation
	 * @param prompt
	 * @param defaultValue
	 * @param validation
	 * @return the validated response
	 */
	protected static String prompt(String prompt, String defaultValue, VALIDATION validation) {		
		String response = null;
		do {
			System.out.print(prompt + " [default:"+defaultValue+"]: ");
			try {
				response = input.readLine();
				if (response.equals(""))
					response = defaultValue;
			} catch (IOException e) {
				System.err.println("IOException prevents further consideration.");
				e.printStackTrace();
				System.exit(-1);
			}
			
		} while (isInvalid(response,validation));
		return response;
		
	}

	/**
	 * Performs the validation type on the specified response
	 * @param response
	 * @param validation
	 * @return
	 */
	private static boolean isInvalid(String response, VALIDATION validation) {
		
		switch (validation) {
		case NONE:
			return false;
		case INTEGER:
			try {
				int i = Integer.parseInt(response);
			} catch (NumberFormatException e) {
				e.printStackTrace();
				System.err.println("Please enter a valid integer.");
				return true;
			}
			return false;
		case NOT_NULL:
			if (response.equals("")) {
				System.err.println("Please enter a value.\n");
				return true;
			}
			return false;
		case YES_NO:
			if (response.equals("yes"))
				return false;
			if (response.equals("no"))
				return false;
			System.err.println("Please enter \"yes\" or \"no\".");
			return true;
		case FILE_EXISTS:
			return false;
			//EMAIL, SERVER_EXISTS
		default:
			return false;		
		}
		
		
	}

	
	
	/** 
	 * configures the database
	 * @return a newly-allocated map of <String,String> containing database properties
	 */
	protected static Map<String,String> configDB() {
		Map<String,String> returnValue = new HashMap<String, String>();
		
		System.out.println("----------------------------------------");
		System.out.println("Database Configuration");
		System.out.println("Enter the values to connect to the MySQL database\n");
		
		returnValue.put("datasource.server",prompt("MySQL server hostname","localhost",VALIDATION.SERVER_EXISTS));
		returnValue.put("datasource.port",prompt("MySQL port","3306",VALIDATION.NONE));
		returnValue.put("datasource.dbname",prompt("MySQL database name","openapplicant",VALIDATION.NONE));
		returnValue.put("datasource.username",prompt("MySQL login","root",VALIDATION.NONE));
		returnValue.put("datasource.password",prompt("MySQL password","",VALIDATION.NONE));
		
		return returnValue;
	}
	
	/**
	 * configures the mailSender
	 * @return a newly-allocated map of <String,String> containing mailsender properties
	 */
	protected static Map<String,String> configMailSender() {
		Map<String,String> returnValue = new HashMap<String,String>();
		
		System.out.println("----------------------------------------");
		System.out.println("Mail Sender Configuration");
		System.out.println("Enter the values to enable Open Applicant to send e-mail\n");
		
		returnValue.put("smtp.host",prompt("Outgoing SMTP Server","localhost",VALIDATION.SERVER_EXISTS));
		returnValue.put("smtp.port",prompt("Outgoing SMTP Port","25",VALIDATION.INTEGER));
		returnValue.put("smtp.username",prompt("SMTP username (if authentication is used)","",VALIDATION.NONE));
		if (!returnValue.get("smtp.username").equals(""))
			returnValue.put("smtp.password",prompt("SMTP password","",VALIDATION.NONE));
		else
			returnValue.put("smtp.password","");
		return returnValue;
		
	}

	/**
	 * configures the email connector
	 * @return a newly-allocated map of <String,String> containing facilitator properties
	 */
	protected static Map<String,String> configFacilitator() {
		Map<String,String> returnValue = new HashMap<String,String>();
		
		System.out.println("----------------------------------------");
		System.out.println("Email Connector Configuration");
		System.out.println("Enter values for a mailbox which will receive resumes\n");
		
		returnValue.put("facilitator.mail.host",prompt("Incoming Email Connector Server","localhost",VALIDATION.NONE));
		returnValue.put("facilitator.mail.protocol",prompt("Protocol","imaps",VALIDATION.NONE));
		returnValue.put("facilitator.mail.user",prompt("Username","",VALIDATION.NONE));
		returnValue.put("facilitator.mail.password",prompt("Password","",VALIDATION.NONE));
		returnValue.put("facilitator.mail.folderName",prompt("Folder Name","INBOX",VALIDATION.NONE));
		returnValue.put("facilitator.mail.interval", prompt("Refresh Interval (in milliseconds)","60000",VALIDATION.INTEGER));
				
		return returnValue;
	}
	
	
	protected static File extractFile(String path, String filename, String ext) throws IOException {
		File returnValue = null;
		returnValue = File.createTempFile(filename, ext);
		FileOutputStream outStream = new FileOutputStream(returnValue);
    	InputStream inStream = Main.class.getResourceAsStream(path);
    	int intRead;
    	int lcv = 0;
    	while ( (intRead = inStream.read()) != -1 ) {
    		outStream.write(intRead);
    	}
    	inStream.close();
        outStream.close();
    	
		return returnValue;
	}
	
	protected static void expandZip(File src, File dest) throws Exception {
		Expand expander = new Expand();
    	expander.setSrc(src.getAbsoluteFile());
    	expander.setDest(dest.getAbsoluteFile());
		expander.execute();
	}
	
	protected static File filterFile(File file) throws IOException {
		Copy copyTask = (Copy) p.createTask("copy");
		File tempFile = File.createTempFile("filter", "file");
		copyTask.setFiltering(true);
		copyTask.setOverwrite(true);
		copyTask.setFile(file);
		copyTask.setTofile(tempFile);
		copyTask.execute();
		return tempFile;
	}
	
	protected static File makeWar(File sourceDir) throws IOException {
		War warTask = (War) p.createTask("war");
		File warFile = File.createTempFile("created","war");
		warTask.setDestFile(warFile.getAbsoluteFile());
		warTask.setBasedir(sourceDir.getAbsoluteFile());
		warTask.execute();
		return warFile;
	}
	
	protected static boolean checkDB(String url, String adminUser, String adminPass) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection conn = DriverManager.getConnection(url,adminUser,adminPass);
			Statement ping = conn.createStatement();
			ping.execute("select 1");
		} catch (Exception e) {
			System.err.println("Error connecting to database "+url+" as "+adminUser+"/"+adminPass);
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	protected static void createDB(String url, String adminUser, String adminPass, String database, boolean grant,
										String clientUser, String clientPass) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Connection conn = DriverManager.getConnection(url,adminUser,adminPass);
		Statement drop = conn.createStatement();
		drop.execute("drop database if exists "+database);
		drop.execute("create database "+database);
		if ( (!clientUser.equals("root")) && grant )  {
			String identifiedBy = (clientPass.equals("")) ? "" : "identified by '"+clientPass+"'";
			drop.execute("grant all privileges on "+database+".* to "+clientUser+"@localhost "+identifiedBy);
			drop.execute("grant all privileges on "+database+".* to "+clientUser+"@'%' "+identifiedBy);
		}
		conn.close();
	}
	
	protected static void loadSchema(String mysql, Map<String,String> dbOpts, File schema) throws IOException {
		ExecTask execTask = (ExecTask) p.createTask("exec");
		//execTask.setOs("Mac OS X");
		execTask.setLogError(true);
		execTask.setError(File.createTempFile("loadSchema", "error"));
		execTask.setFailonerror(true);
		execTask.setFailIfExecutionFails(true);
		execTask.setExecutable(mysql);
		execTask.createArg().setValue("-u");
		execTask.createArg().setValue(dbOpts.get("datasource.username"));
		String password = dbOpts.get("datasource.password");
		if (!password.equals("")) {
			execTask.createArg().setValue("-p"+password);
		}
		execTask.createArg().setValue("-h");
		execTask.createArg().setValue(dbOpts.get("datasource.server"));
		execTask.createArg().setValue("-P");
		execTask.createArg().setValue(dbOpts.get("datasource.port"));
		execTask.createArg().setValue(dbOpts.get("datasource.dbname"));
		execTask.setInput(schema);
		execTask.execute();
	}
	
	protected static Map<String,String> configSetup() {
		Map<String,String> returnValue = new HashMap<String,String>();
		
		System.out.println("----------------------------------------");
		System.out.println("Company Configuration");
		System.out.println("Enter values for the server name, host name, and administrative user\n");
		
		returnValue.put("oa.server",prompt("Deployment server name","",VALIDATION.NOT_NULL));
		returnValue.put("oa.email",prompt("Resumes e-mail address","",VALIDATION.NONE));
		returnValue.put("oa.port", prompt("Port","8080",VALIDATION.INTEGER));
		returnValue.put("oa.companyName",prompt("Company name","",VALIDATION.NOT_NULL));
		returnValue.put("oa.adminUser",prompt("Admin user","admin@"+returnValue.get("oa.server"),VALIDATION.EMAIL));
		
		String password = prompt("Password","install",VALIDATION.NOT_NULL);
		returnValue.put("oa.password",stringDigester.digest(password));		
		returnValue.put("oa.rawPassword", password);
		
		return returnValue;
	}
}
