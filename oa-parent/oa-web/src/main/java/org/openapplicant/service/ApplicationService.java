package org.openapplicant.service;

import java.util.List;

import org.openapplicant.dao.IAccountCreationTokenDAO;
import org.openapplicant.dao.ICandidateDAO;
import org.openapplicant.dao.ICandidateExamLinkDAO;
import org.openapplicant.dao.ICandidateSearchDAO;
import org.openapplicant.dao.ICandidateWorkFlowEventDAO;
import org.openapplicant.dao.ICompanyDAO;
import org.openapplicant.dao.IEmailTemplateDAO;
import org.openapplicant.dao.IExamDAO;
import org.openapplicant.dao.IExamLinkDAO;
import org.openapplicant.dao.IFileAttachmentDAO;
import org.openapplicant.dao.IGradeDAO;
import org.openapplicant.dao.IPasswordRecoveryTokenDAO;
import org.openapplicant.dao.IProfileDAO;
import org.openapplicant.dao.IQuestionDAO;
import org.openapplicant.dao.IResponseDAO;
import org.openapplicant.dao.ISittingDAO;
import org.openapplicant.dao.IUserDAO;
import org.openapplicant.domain.Company;
import org.openapplicant.domain.Exam;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.mail.MailSender;
import org.springframework.stereotype.Service;


/**
 * Provides common methods for service layer subclasses.
 */
@Service
public abstract class ApplicationService {
	
	private IFileAttachmentDAO fileAttachmentDao;
	
	private ICandidateDAO candidateDao;
	
	private ICandidateExamLinkDAO candidateExamLinkDao;
	
	private ICandidateSearchDAO candidateSearchDao;
	
	private ICandidateWorkFlowEventDAO candidateWorkFlowEventDao;
	
	private ICompanyDAO companyDao;
	
	private IEmailTemplateDAO emailTemplateDao;
	
	private IExamDAO examDao;
	
	private IExamLinkDAO examLinkDao;
	
	private IGradeDAO gradeDao;
	
	private IPasswordRecoveryTokenDAO passwordRecoveryTokenDao;
	
	private IProfileDAO profileDao;
	
	private IQuestionDAO questionDao;
	
	private IResponseDAO responseDao;
	
	private ISittingDAO sittingDao;
	
	private IUserDAO userDao;
	
	private IAccountCreationTokenDAO accountCreationTokenDao;
	
	private MailSender mailSender;
	
	//========================================================================
	// PROPERTIES
	//========================================================================
	protected IFileAttachmentDAO getFileAttachmentDao() {
		return fileAttachmentDao;
	}
	
	@Required
	public void setFileAttachmentDao(IFileAttachmentDAO value) {
		fileAttachmentDao = value;
	}
	
	protected ICandidateDAO getCandidateDao() {
		return candidateDao;
	}
	
	@Required
	public void setCandidateDao(ICandidateDAO value) {
		candidateDao = value;
	}
	
	protected ICandidateExamLinkDAO getCandidateExamLinkDao() {
		return candidateExamLinkDao;
	}
	
	@Required
	public void setCandidateExamLinkDao(ICandidateExamLinkDAO value) {
		candidateExamLinkDao = value;
	}
	
	protected ICandidateSearchDAO getCandidateSearchDao() {
		return candidateSearchDao;
	}
	
	@Required
	public void setCandidateSearchDao(ICandidateSearchDAO value) {
		candidateSearchDao = value;
	}
	
	protected ICandidateWorkFlowEventDAO getCandidateWorkFlowEventDao() {
		return candidateWorkFlowEventDao;
	}
	
	@Required
	public void setCandidateWorkFlowEventDao(ICandidateWorkFlowEventDAO value) {
		candidateWorkFlowEventDao = value;
	}
	
	protected ICompanyDAO getCompanyDao() {
		return companyDao;
	}
	
	@Required
	public void setCompanyDao(ICompanyDAO value) {
		companyDao = value;
	}

	protected IEmailTemplateDAO getEmailTemplateDao() {
		return emailTemplateDao;
	}
	
	@Required
	public void setEmailTemplateDao(IEmailTemplateDAO value) {
		emailTemplateDao = value;
	}

	protected IExamDAO getExamDao() {
		return examDao;
	}
	
	@Required
	public void setExamDao(IExamDAO value) {
		examDao = value;
	}

	protected IExamLinkDAO getExamLinkDao() {
		return examLinkDao;
	}
	
	@Required
	public void setExamLinkDao(IExamLinkDAO value) {
		examLinkDao = value;
	}

	protected IGradeDAO getGradeDao() {
		return gradeDao;
	}
	
	@Required
	public void setGradeDao(IGradeDAO value) {
		gradeDao = value;
	}
	
	protected IPasswordRecoveryTokenDAO getPasswordRecoveryTokenDao() {
		return passwordRecoveryTokenDao;
	}
	
	@Required
	public void setPasswordRecoveryTokenDao(IPasswordRecoveryTokenDAO value) {
		passwordRecoveryTokenDao = value;
	}
	
	protected IProfileDAO getProfileDao() {
		return profileDao;
	}
	
	@Required
	public void setProfileDao(IProfileDAO value) {
		profileDao = value;
	}

	protected IQuestionDAO getQuestionDao() {
		return questionDao;
	}
	
	@Required
	public void setQuestionDao(IQuestionDAO value) {
		questionDao = value;
	}

	protected IResponseDAO getResponseDao() {
		return responseDao;
	}
	
	@Required
	public void setResponseDao(IResponseDAO value) {
		responseDao = value;
	}

	protected ISittingDAO getSittingDao() {
		return sittingDao;
	}
	
	@Required
	public void setSittingDao(ISittingDAO value) {
		sittingDao = value;
	}

	protected IUserDAO getUserDao() {
		return userDao;
	}
	
	@Required
	public void setUserDao(IUserDAO value) {
		userDao = value;
	}
	
	protected MailSender getMailSender() {
		return mailSender;
	}
	
	@Required
	public void setMailSender(MailSender value) {
		mailSender = value;
	}
	
	public void setAccountCreationTokenDao(IAccountCreationTokenDAO accountCreationTokenDao) {
		this.accountCreationTokenDao = accountCreationTokenDao;
	}
	
	public IAccountCreationTokenDAO getAccountCreationTokenDao() {
		return accountCreationTokenDao;
	}
	
	/**
	 * Finds an exam with the given id.
	 * 
	 * @param examId the id of the exam to find
	 * @return the exam with the given id
	 * @throws DataRetrievalFailurException if the exam cannot be found.
	 */
	public Exam findExamById(Long examId) {
		return examDao.find(examId);
	}
	
	/**
	 * Retrieves the latest versions of each exam artifact for the given company
	 * 
	 * @param the company who's exams to retrieve
	 * @return a list of the latest exam versions.
	 */
	public List<Exam> findLatestExamVersionsByCompany(Company company) {
		return getExamDao().findLatestVersionsByCompanyId(company.getId());
	}
	
	/**
	 * Retrieves the latest active versions of each exam artifact for the given company
	 * 
	 * @param the company who's exams to retrieve
	 * @return a list of the latest active exam versions.
	 */
	public List<Exam> findLatestActiveExamVersionsByCompany(Company company) {
		return getExamDao().findLatestActiveVersionsByCompanyId(company.getId());
	}
	
	/**
	 * Retrieves the latest version of an exam with the given artifact id
	 * 
	 * @param artifactId the artifact id of the exam to retrieve.
	 * @return the latest exam version
	 */
	public Exam findLatestExamVersionByArtifactId(String artifactId) {
		return getExamDao().findLatestVersionByArtifactId(artifactId);
	}

}
