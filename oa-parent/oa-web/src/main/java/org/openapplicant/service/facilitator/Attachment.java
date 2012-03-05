package org.openapplicant.service.facilitator;

import java.io.IOException;

import javax.mail.MessagingException;
import javax.mail.Part;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;

/**
 * Helper class for normalizing a message attachment.
 */
class Attachment {
	
	private String fileName;
	
	private byte[] content;
	
	public Attachment(Part part) throws IOException, MessagingException {
		this(IOUtils.toByteArray(part.getInputStream()), part.getFileName());
	}
	
	public Attachment(byte[] content, String fileName) {
		this.fileName = StringUtils.trimToEmpty(fileName);
		if(ArrayUtils.isEmpty(content)) {
			this.content = ArrayUtils.EMPTY_BYTE_ARRAY;
		}
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public byte[] getContent() {
		return content;
	}

}
