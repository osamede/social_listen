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
	
	@Resource
	private MailClient mailClient;
	@Test
	public void processMail(){
		mailClient.setDebug(true);
		mailClient.processMail();
		
	}
}