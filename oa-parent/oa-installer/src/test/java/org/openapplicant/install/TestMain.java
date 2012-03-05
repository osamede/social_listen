package org.openapplicant.install;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.net.URISyntaxException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.tools.ant.Project;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

public class TestMain {

	protected static Project p;
	
	@BeforeClass
	public static void setup() {
		p = new Project();
		p.init();
		Main.p = p;
	}
	
	@Test
	public void testConfigDB() {
		String input = "\n\n\n\n\n";
		BufferedReader reader = new BufferedReader(new StringReader(input));
		Main.input = reader;
		Map<String,String> testValue = Main.configDB();
		assertEquals(5,testValue.size());
		assertEquals("localhost",testValue.get("datasource.server"));
	}
	
	@Test
	public void testExtractFile() throws IOException {
		File tmpFile = Main.extractFile("/build.xml", "build", "xml");
		assertTrue(tmpFile.exists());
		assertEquals(134,tmpFile.length());
		tmpFile.delete();
	}
	
	@Test
	public void testExpandZip() {
		// TODO something!
		assertTrue(true);
	}
	
	@Test
	public void testMakeWar() throws URISyntaxException, IOException {
		File sourceDir = new File(TestMain.class.getResource("/testdir").toURI());
		File targetWar = Main.makeWar(sourceDir);
		System.err.println("Test war is "+targetWar.getAbsolutePath());
	}
	
	@Test
	public void testFilter() throws IOException, URISyntaxException {
		p.getGlobalFilterSet().addFilter("noun", "filter");
		File file = new File(TestMain.class.getResource("/filterTest.txt").toURI());
		System.err.println("Filter test file is "+file.length()+" bytes long.");
		File result = Main.filterFile(file);
	}
	
	@Test
	public void testDBCreate() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		Main.createDB("jdbc:mysql://localhost:3306", "root", "", "mrwtest", true, "mrw", "mrw");
	}
	
	@Ignore
	@Test
	public void testLoadSchema() throws URISyntaxException, IOException {
		Map<String,String> dbOpts = new HashMap<String, String>();
		dbOpts.put("datasource.server", "localhost");
		dbOpts.put("datasource.user", "mrw");
		dbOpts.put("datasource.password", "mrw");
		dbOpts.put("datasource.dbname", "mrwtest");
		dbOpts.put("datasource.port", "3306");
		File file = new File(TestMain.class.getResource("/schematest.sql").toURI());
		Main.loadSchema("/usr/local/bin/mysql", dbOpts, file);
	}
}
