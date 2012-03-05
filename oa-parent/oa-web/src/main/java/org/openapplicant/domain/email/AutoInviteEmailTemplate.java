package org.openapplicant.domain.email;

import static org.openapplicant.domain.email.PlaceHolder.CANDIDATE_FIRST_NAME;
import static org.openapplicant.domain.email.PlaceHolder.COMPANY_NAME;
import static org.openapplicant.domain.email.PlaceHolder.EXAM_LINK;

import javax.persistence.Entity;
import javax.persistence.Transient;

@Entity
public class AutoInviteEmailTemplate extends ExamInviteEmailTemplate {

	@Override
	@Transient
	public String getName() {
		return "Auto Invite";
	}
	
	@Override
	protected String defaultSubject() {
		return "Open Applicant Exam Invitation";
	}
	
	@Override
	protected String defaultBody() {
		return "Dear " +CANDIDATE_FIRST_NAME +
		",\n\nThank you for taking the time to submit your resume with "+COMPANY_NAME+ 
		" which is the first step in the employment process.\n\nThe next step in the process is to complete an online assessment, which can be accessed at the following link:\n\n"+ 
		EXAM_LINK + "\n\nFollowing your completion of the assessment, we will notify you and outline the remaining steps in the employment process.\n\nSincerely,\n\n" 
		+ COMPANY_NAME;
	}
}
