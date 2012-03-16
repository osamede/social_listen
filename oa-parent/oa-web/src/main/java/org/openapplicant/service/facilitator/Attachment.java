package org.openapplicant.service.facilitator;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.mail.MessagingException;
import javax.mail.Part;
import javax.mail.internet.MimeUtility;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
/**
 * Helper class for normalizing a message attachment.
 */
class Attachment {
	private static final Log log = LogFactory.getLog(DocumentResolver.class);
	
	private String fileName;
	
	private byte[] content;
	
	public Attachment(Part part) throws IOException, MessagingException {
		this(IOUtils.toString(part.getInputStream(),DetectChareSet(part)).getBytes("UTF-8"), part.getFileName());
	}
	
	private static String DetectChareSet(Part part) throws IOException,MessagingException{
		String charset="GB2312";
		if(FilenameUtils.getExtension(part.getFileName())=="html"){
			Pattern phonePattern = Pattern.compile("<meta[^>]+charset=(['\"]?(.*?))['\"]?[\\/\\s>]");
			String content=IOUtils.toString(part.getInputStream());
			Matcher matcher = phonePattern.matcher(content);
			if(matcher.find()){
				charset=matcher.group(1);
			}
		}
		return charset;
		
	}
	
	public Attachment(byte[] content, String fileName) {
		this.fileName = StringUtils.trimToEmpty(fileName);
		this.content=content;
		if(ArrayUtils.isEmpty(content)) {
			this.content = ArrayUtils.EMPTY_BYTE_ARRAY;
			log.info("ArrayUtils.EMPTY_BYTE_ARRAY");
		}
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public byte[] getContent() {
		return content;
	}

}
