package org.openapplicant.domain;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.sql.Blob;
import java.sql.Clob;
import javax.sql.rowset.serial.SerialClob;
import java.sql.SQLException;
import java.util.zip.DataFormatException;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Transient;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hwpf.HWPFDocument;
import org.hibernate.Hibernate;
import org.hibernate.validator.NotEmpty;
import org.hibernate.validator.NotNull;
import org.pdfbox.pdmodel.PDDocument;
import org.pdfbox.util.PDFTextStripper;
import org.springframework.dao.DataRetrievalFailureException;

@Entity
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="type")
public abstract class FileAttachment extends DomainObject {
	
	public static final String DOC = "doc";
	
	public static final String PDF = "pdf";
	
	public static final String TXT = "txt";
	
	public static final String HTML="html";
	
	private String fileType;
	
	private Blob content;
	
	private Clob stringContent;
	
	//FIXME: add a filename to the constructor
	/**
	 * Creates a new file attachment.
	 * 
	 * @param bytes the files binary content
	 * @param fileType the file extension type ("txt", "pdf", "doc")
	 * @throws IOException if there is an error reading the byte content
	 * @throws FileTypeNotSupportedException if fileType is unsupported
	 */
	public FileAttachment(byte[] bytes, String fileType) 
		throws IOException, FileTypeNotSupportedException {
		fileType = StringUtils.trimToEmpty(fileType);
		fileType = StringUtils.removeStart(fileType, ".");
		
		this.stringContent = parseContent(bytes, fileType);
		this.content = Hibernate.createBlob(bytes);
		this.fileType = fileType;
	}
	
	protected FileAttachment(){}
	
	/**
	 * @return the attachment's content type.  Excludes leading "."
	 * (eg. txt, pdf, doc)
	 * 
	 */
	@NotEmpty
	@Column(nullable=false)
	public String getFileType() {
		return fileType;
	}

	private void setFileType(String fileType) {
		this.fileType = fileType;
	}
	
	/**
	 * @return the attachment's content type
	 */
	@Transient
	public String getContentType() {
		if(TXT.equals(fileType)) {
			return "text/plain";
		}else if(HTML.equals(fileType)){
			return "text/html";
		}		
		else if(DOC.equals(fileType)) {
			return "application/msword";
		} else if(PDF.equals(fileType)) {
			return "application/pdf";
		} else {
			throw new IllegalStateException("unsupported file type " + fileType);
		}
	}

	/**
	 * @return the attachment's byte content
	 */
	@Transient
	public byte[] getContent() {
		InputStream input = null;
		try {
			input = content.getBinaryStream();
			return IOUtils.toByteArray(input);
		} catch(SQLException e) {
			throw new DataRetrievalFailureException("could not read content",e);
		} catch(IOException e) {
			throw new DataRetrievalFailureException("could not read content", e);
		} finally {
			IOUtils.closeQuietly(input);
		}
	}
	
	@NotNull
	@Column(columnDefinition="longblob", nullable=false)
	private Blob getContentInternal() {
		return content;
	}
	
	private void setContentInternal(Blob value) {
		content = value;
	}
	
	/**
	 * @return the attachment's content as a string.
	 */
	@Transient
	public String getStringContent() {
		Reader input = null;
		try {
			input = stringContent.getCharacterStream();
			return IOUtils.toString(input);
			//return stringContent.getSubString(0,(int)stringContent.length());
		} catch (SQLException e) {
			throw new DataRetrievalFailureException("error reading content",e);
		} catch (IOException e) {
			throw new DataRetrievalFailureException("error reading content", e);
		} 
		finally {
			IOUtils.closeQuietly(input);
		}
	}
	
	@NotNull
	@Column(columnDefinition="longtext", nullable=false)
	private Clob getStringContentInternal() {
		return stringContent;
	}
	
	private void setStringContentInternal(Clob clob) {
		this.stringContent = clob;
	}
	
	private Clob parseContent(byte[] content, String fileType) 
		throws IOException, FileTypeNotSupportedException {
		if (StringUtils.equalsIgnoreCase(fileType, TXT)||StringUtils.equalsIgnoreCase(fileType, HTML)) {
			//return Hibernate.createClob(new String(content,"UTF-8"));
			try{
				return new SerialClob((new String(content,"UTF-8")).toCharArray());
			}catch (SQLException e) {
				throw new IOException("error create serial clob");
			}
		}
		else if(StringUtils.equalsIgnoreCase(fileType, DOC)) {
			int pad = 512 - (content.length % 512);
			byte[] newString = new byte[content.length + pad];
			for(int i = 0; i < content.length; i++) {
				newString[i] = content[i];
			}
			for(int i = 0; i < pad; i++) {
				newString[content.length + i] = 0;
			}			
			ByteArrayInputStream attachmentStream = new ByteArrayInputStream(newString);
			HWPFDocument doc = new HWPFDocument(attachmentStream);
			return Hibernate.createClob(doc.getRange().text());
		}
		else if(StringUtils.equalsIgnoreCase(fileType, PDF)) {
			ByteArrayInputStream attachmentStream = new ByteArrayInputStream(content);
			PDFTextStripper pdf = new PDFTextStripper();
			PDDocument pdDoc = PDDocument.load(attachmentStream);			
			Clob result = Hibernate.createClob(pdf.getText(pdDoc));
			pdDoc.close();
			return result;
		}
		else {
			throw new FileTypeNotSupportedException("unsupported document type: " + fileType);
		}
	}
}
