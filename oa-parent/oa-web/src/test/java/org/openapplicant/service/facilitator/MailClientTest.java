package org.openapplicant.service.facilitator;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Arrays;
import java.util.List;
import javax.annotation.Resource;

import org.junit.Before;
import org.junit.Test;

import org.openapplicant.service.facilitator.MailClient;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

@ContextConfiguration(locations="/applicationContext-test.xml")
public class MailClientTest extends AbstractTransactionalJUnit4SpringContextTests {
	
	//@Resource
	//private MailClient mailClient;
	@Test
	public void processMail(){
	//	MailClient client=new MailClient();
	//	mailClient.setDebug(true);
	//	mailClient.processMail();
	Pattern phonePattern = Pattern.compile("((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})))");
			Matcher matcher = phonePattern.matcher("15727384532µç»°");
			assertTrue(matcher.find());
			logger.info(matcher.group());
		
	}
}