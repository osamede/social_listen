package org.openapplicant.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openapplicant.domain.AccountCreationToken;
import org.openapplicant.domain.Candidate;
import org.openapplicant.domain.CandidateSearch;
import org.openapplicant.domain.Company;
import org.openapplicant.domain.CoverLetter;
import org.openapplicant.domain.Exam;
import org.openapplicant.domain.FileAttachment;
import org.openapplicant.domain.Grade;
import org.openapplicant.domain.Note;
import org.openapplicant.domain.PasswordRecoveryToken;
import org.openapplicant.domain.Profile;
import org.openapplicant.domain.PropertyCandidateSearch;
import org.openapplicant.domain.QuestionStatistics;
import org.openapplicant.domain.ResponseSummary;
import org.openapplicant.domain.Resume;
import org.openapplicant.domain.SimpleStringCandidateSearch;
import org.openapplicant.domain.Sitting;
import org.openapplicant.domain.User;
import org.openapplicant.domain.email.EmailTemplate;
import org.openapplicant.domain.event.AddNoteToCandidateEvent;
import org.openapplicant.domain.event.CandidateCreatedByUserEvent;
import org.openapplicant.domain.event.CandidateStatusChangedEvent;
import org.openapplicant.domain.event.CandidateWorkFlowEvent;
import org.openapplicant.domain.event.CreateExamLinkForCandidateEvent;
import org.openapplicant.domain.event.SittingGradedEvent;
import org.openapplicant.domain.event.UserAttachedCoverLetterEvent;
import org.openapplicant.domain.event.UserAttachedResumeEvent;
import org.openapplicant.domain.event.UserSentExamLinkEvent;
import org.openapplicant.domain.link.CandidateExamLink;
import org.openapplicant.domain.link.ExamLink;
import org.openapplicant.domain.link.StaticExamsStrategy;
import org.openapplicant.domain.question.CodeQuestion;
import org.openapplicant.domain.question.EssayQuestion;
import org.openapplicant.domain.question.MultipleChoiceQuestion;
import org.openapplicant.domain.question.Question;
import org.openapplicant.util.CalendarUtils;
import org.openapplicant.util.Pagination;
import org.openapplicant.util.Verify;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;


@Service
@Transactional
public class AdminService extends ApplicationService {

	private static final Log log = LogFactory.getLog(AdminService.class);
	
	/**
	 * Retrieves a user with the given email.
	 * 
	 * @param email
	 *            the user's email address
	 * @return the user with the given email
	 * @throws DataRetrievalFailureException
	 *             if no user exists for the given email.
	 */
	public User findUserByEmail(String email) {
		return getUserDao().findByEmail(email);
	}
	
	/**
	 * Retrieves a user with the given email, returning null if 
	 * that user does not exist.
	 * 
	 * @param email the user's email address
	 * @return the retrieved user or null
	 */
	public User findUserByEmailOrNull(String email) {
		return getUserDao().findByEmailOrNull(email);
	}

	/**
	 * Retrieves a user with the given id.
	 * 
	 * @param id
	 *            the user's id
	 * @return the user with the given id
	 * @throws DataRetrievalFailureException
	 *             if no user exists for the given id.
	 */
	public User findUserById(Long id){
		return getUserDao().find(id);
	}
	
	/*
	public Company findCompanyById(Long id){
		return getCompanyDao().find(id);
	}
	*/
	
	public CandidateExamLink findCandidateExamLinkById(Long id){
		return getCandidateExamLinkDao().find(id);
	}
	
	/**
	 * Retrieves a candidate with the given id
	 * 
	 * @param candidateId
	 *            the candidate's database identifier
	 * @return a candidate with id equal to candidateId
	 * @throws DataRetrievalFailureException
	 *             if no candidate matches candidateId.
	 */
	public Candidate findCandidateById(Long candidateId) {
		return getCandidateDao().find(candidateId);
	}

	/**
	 * Finds all candidates for a given company
	 * 
	 * @param company the company who's candidates to find
	 * @param pagination the pagination to apply
	 * @return candidates
	 */
	public List<Candidate> findAllCandidatesByCompany(Company company, Pagination pagination) {
		return getCandidateDao().findAllByCompanyId(
				company.getId(), 
				pagination
		);
	}
	
	/**
	 * Finds all active candidates for a given company
	 */
	public List<Candidate> findAllActiveCandidatesByCompany(Company company, Pagination pagination) {
		return getCandidateDao().findAllActiveCandidatesByCompanyId(company.getId(), pagination);
	}
	
	/**
	 * Finds all archived candidates for a given company
	 */
	public List<Candidate> findAllArchivedCandidatesByCompany(Company company, Pagination pagination) {
		return getCandidateDao().findAllArchivedCandidatesByCompanyId(company.getId(), pagination);
	}

	/**
	 * Finds all candidates in a company with the given status.
	 * 
	 * @param company the company who's candidates to find
	 * @param the status to search for
	 * @param pagination the pagination to apply
	 * @return candidates
	 */
	public List<Candidate> findAllCandidatesByCompanyAndStatus(
			Company company, 
			Candidate.Status status, 
			Pagination pagination) {
		
		return getCandidateDao().findAllByCompanyIdAndStatus(
				company.getId(), 
				status, 
				pagination
		);
	}
	
	/**
	 * Finds all candidates for a given user's company who match the given
	 * search string.
	 * 
	 * @param user 
	 * 			the user issuing the search
	 * @param searchString
	 *            a string specifying the candidates to find.
	 * @param pagination
	 * 			  the pagination to apply
	 * @return all candidates matching the search string.
	 */
	public CandidateSearch createTextCandidateSearch(User user, String searchString) {
		CandidateSearch search = new SimpleStringCandidateSearch(searchString, user);
		return getCandidateSearchDao().save(search);
	}
	
	/**
	 * Finds all candidate searches performed by the given user.
	 * 
	 * @param user
	 * 			the user who's searches to find.
	 * @param pagination
	 *   		the pagination to apply
	 * @return a list of recent searches.
	 */
	public List<CandidateSearch> findAllCandidateSearchesByUser(User user,
			Pagination pagination) {
		
		return getCandidateSearchDao().findAllByUserId(user.getId(), pagination);
	}

	/**
	 * Finds all candidates for a user's company who match the given 
	 * criteria.
	 * 
	 * @param user the user issuing the search.
	 * @param name a string representing the candidates name.
	 * 		(eg. "joe bob briggs")
	 * @param skills a string representing candidate skills
	 * 		(eg. "java javascript ruby")
	 * @param dates a string representing a candidate date range.
	 * 		(eg. "12/21/2001 1/3/2004")
	 * @param pagination 
	 * 			the pagination to apply
	 * @return all candidates matching the given criteria.
	 */
	public CandidateSearch createPropertyCandidateSearch(
			User user, 
			String name, 
			String skills, 
			String dates) {
		
		CandidateSearch search = new PropertyCandidateSearch.Builder(user)
									.name(name)
									.skills(skills)
									.dateRange(dates)
									.build();
		return getCandidateSearchDao().save(search);
	}
	
	/**
	 * Finds all candidates by executing a persisted search with the given id.
	 * 
	 * @param candidateSearchId the id of the candidate search to replay.
	 * @param pagination the pagination to apply
	 * @return a list of candidates matching the search.
	 */
	public List<Candidate> findAllCandidatesBySearchId(Long candidateSearchId,
			Pagination pagination) {
		CandidateSearch search = getCandidateSearchDao().find(candidateSearchId);
		return search.execute(pagination);
	}
	
	/**
	 * Saves the given candidate.
	 * @param candidate the candidate to save.
	 * @return the saved candidate
	 */
	public Candidate saveCandidate(Candidate candidate) {
		return getCandidateDao().save(candidate);
	}
	
	/**
	 * Adds a note to the given candidate.
	 * @param candidateId the id of the candidate to add a note to.
	 * @param note the note to add
	 * @return the updated candidate
	 */
	public Candidate addNoteToCandidate(Long candidateId, Note note) {
		Candidate candidate = getCandidateDao().find(candidateId);
		candidate.addNote(note);
		candidate = getCandidateDao().save(candidate);
		getCandidateWorkFlowEventDao().save(new AddNoteToCandidateEvent(candidate, note));
		return candidate;
	}
	
	/**
	 * Attaches a resume to a candidate.
	 * @param user the user who attached the resume
	 * @param candidateId the id of the candidate to attach a resume to
	 * @param resume the resume to attach
	 * @return the updated candidate.
	 */
	public Candidate attachResumeToCandidate(User user, long candidateId, Resume resume) {
		Assert.notNull(user);
		Assert.notNull(resume);
		
		Candidate candidate = getCandidateDao().find(candidateId);
		candidate.setResume(resume);
		candidate = getCandidateDao().save(candidate);
		getCandidateWorkFlowEventDao().save(new UserAttachedResumeEvent(user, candidate, resume));
		return candidate;
	}
	
	/**
	 * Attaches a cover letter to a candidate
	 * @param user the use who attached the cover letter
	 * @param candidateId the id of the candidate to attach a cover letter to
	 * @param coverLetter the cover letter to attach
	 * @return the updated candidate.
	 */
	public Candidate attachCoverLetterToCandidate(User user, long candidateId, CoverLetter coverLetter) {
		Assert.notNull(user);
		Assert.notNull(coverLetter);
		
		Candidate candidate = getCandidateDao().find(candidateId);
		candidate.setCoverLetter(coverLetter);
		candidate = getCandidateDao().save(candidate);
		getCandidateWorkFlowEventDao().save(new UserAttachedCoverLetterEvent(user, candidate, coverLetter));
		return candidate;
	}
	
	/**
	 * Reverts a candidate to their last active state.
	 * 
	 * @param candidsateId the id of the candidate to unarchve
	 * @param user the user who unarchived the candidate.
	 * @return the unarchived candidate
	 */
	public Candidate unarchiveCandidate(long candidateId, User user) {
		Candidate candidate = getCandidateDao().find(candidateId);
		candidate.unarchive();
		getCandidateDao().save(candidate);
		getCandidateWorkFlowEventDao().save(new CandidateStatusChangedEvent(candidate, user));
		return candidate;
	}
	
	/**
	 * Updates a candidate's status
	 * 
	 * @param candidateId the id of the candidate to update
	 * @param status the candidate's status
	 * @param user the user who performed the update
	 * @return the updated candidate
	 */
	public Candidate updateCandidateStatus(Long candidateId, Candidate.Status status, User user) {
		Candidate candidate = getCandidateDao().find(candidateId);
		candidate.setStatus(status);
		candidate = getCandidateDao().save(candidate);
		getCandidateWorkFlowEventDao().save(new CandidateStatusChangedEvent(candidate, user));
		return candidate;
	}
	
	/**
	 * Finds all work flow events for a candidate with the given id.
	 * @param candidateId the id of the candidate who's events to find.
	 */
	public List<CandidateWorkFlowEvent> findAllCandidateWorkFlowEventsByCandidateId(Long candidateId) {
		return getCandidateWorkFlowEventDao().findAllByCandidateId(candidateId);
	}
	
	/**
	 * Creates a new candidate
	 * @param user the user who created the candidate
	 * @return the created candidate
	 */
	public Candidate createCandidate(User user) {
		Candidate candidate = new Candidate();
		candidate.setCompany(user.getCompany());
		candidate.setStatus(Candidate.Status.INCOMPLETE);
		candidate = saveCandidate(candidate);
		
		getCandidateWorkFlowEventDao().save(new CandidateCreatedByUserEvent(candidate, user));
		
		return candidate;
	}
	
	/**
	 * Saves the given sitting.
	 * @param sitting the sitting to save
	 * @return the saved sitting
	 */
	/*
	public Sitting saveSitting(Sitting sitting) {
		return getSittingDao().save(sitting);
	}
	*/
	
	/**
	 * @param company the company to add the user to
	 * @param user the user to create
	 * @return the created user
	 */
	public User createUser(Company company, User user) {
		company.addUser(user);
		getCompanyDao().save(company);
		return user;
	}
	
	/**
	 * Creates an exam link for a candidate
	 * @param user the user who created the exam link
	 * @param candidate the candidate who is being linked to
	 * @param exams a list of exams to link to
	 * @return
	 */
	public ExamLink createExamLink(User user, Candidate candidate, List<Exam> exams) {
		CandidateExamLink examLink = new CandidateExamLink(
				user.getCompany(), 
				candidate, 
				new StaticExamsStrategy(exams)
		);
		getCandidateExamLinkDao().save(examLink);
		
		getCandidateWorkFlowEventDao().save(
				new CreateExamLinkForCandidateEvent(candidate, examLink, user)
		);
		return examLink;
	}

	/**
	 * Updates or Saves an exam's editable information
	 * 
	 * @param src
	 *            the exam who's info to save
	 * @return the updated exam
	 */
	public Exam saveExam(Exam exam) {
		return getExamDao().save(exam);
	}

	/**
	 * Retrieves a sitting with the given id
	 * 
	 * @param sittingId
	 * @return Sitting
	 * @throws DataRetrievalFailureException
	 *             if no sitting has sittingId
	 */
	public Sitting findSittingById(Long sittingId) {
		return getSittingDao().find(sittingId);
	}

	/**
	 * @param question
	 * @return QuestionStatistics
	 */
	public QuestionStatistics getTotalTimeStatistics(Question question) {
		return getQuestionDao().getTotalTimeStatistics(question);
	}

	public QuestionStatistics getWordsPerMinuteStatistics(Question question) {
		return getQuestionDao().getWordsPerMinuteStatistics(question);
	}
	
	public QuestionStatistics getKeyCharsStatistics(Question question) {
		return getQuestionDao().getKeyCharsStatistics(question);
	}
	
	public QuestionStatistics getCorrectnessStatistics(Question question) {
		return getQuestionDao().getCorrectnessStatistics(question);
	}
	
	public QuestionStatistics getStyleStatistics(Question question) {
		return getQuestionDao().getStyleStatistics(question);
	}

	/**
	 * Grades a candidate's response, if the candidate has grades for all
	 * it's questions it sets the candidate to graded.
	 * 
	 * @param user the response's grader
	 * @param sittingId the id of the response's sitting
	 * @param responseId the id of the response to grade
	 * @param Grade the grade to assign
	 * @return the graded sitting
	 */
	public Sitting updateResponseGrade(User user, long sittingId, long responseId, Grade grade) {
		Sitting sitting = getSittingDao().find(sittingId);
		
		sitting.gradeResponse(responseId, grade);
		getSittingDao().save(sitting);
		
		if(sitting.isEachResponseGraded()) {
			getCandidateWorkFlowEventDao().save(new SittingGradedEvent(user, sitting));
			
			computeMatchScore(sitting.getCandidate());
			getCandidateDao().save(sitting.getCandidate());
		
		}
		
		return sitting;
	}

	/**
	 * @param companyId the id of the company who's users to find.
	 * @return a set of users
	 */
	public Set<User> findAllUsersByCompanyId(Long companyId) {
		return getCompanyDao().find(companyId).getUsers();
	}
	
	/**
	 * Saves the company profile.
	 * 
	 * @param profile the profile to save
	 * @return the saved profile.
	 * @throws IllegalArgumentException if profile is new
	 */
	public Profile saveProfile(Profile profile) {
		Assert.isTrue(!profile.isNew());
		return getProfileDao().save(profile);
	}
	
	/**
	 * @param id the id of the EmailTemplate to find
	 * @return the template with the given id
	 */
	public EmailTemplate findEmailTemplateById(long id) {
		return getEmailTemplateDao().find(id);
	}
	
	public EmailTemplate saveEmailTemplate(EmailTemplate template) {
		return getEmailTemplateDao().save(template);
	}
	
	/**
	 * @param emailTemplateId the id of the email template to revert
	 * @return the reverted email template
	 */
	public EmailTemplate revertEmailTemplate(long emailTemplateId) {
		EmailTemplate template = getEmailTemplateDao().find(emailTemplateId);
		template.revert();
		return getEmailTemplateDao().save(template);
	}
	
	public User saveUser(User user) {
		return getUserDao().save(user);
	}

	public List<CandidateExamLink> getExamLinksForCandidate(Candidate candidate){
		return getCandidateExamLinkDao().findAllByCandidateId(candidate.getId());
	}
	
	/**
	 * @param the guid of the file attachment to find
	 * @return the file attachment with the given guid.
	 */
	public FileAttachment findFileAttachmentByGuid(String guid) {
		return getFileAttachmentDao().findByGuid(guid);
	}
	
	/**
	 * Updates a user's last login time to the current time.
	 * @param userId the id of the user who's last login time to update
	 */
	public void updateUserLastLoginTime(long userId) {
		User user = getUserDao().find(userId);
		user.setLastLoginTime(CalendarUtils.now());
		getUserDao().save(user);
	}
	
	/**
	 * Sends a confirmation email allowing a user to recover their password.
	 * @param token a token used to validate email confirmation.
	 */
	public void sendPasswordRecoveryEmail(PasswordRecoveryToken token) {
		Assert.isTrue(token.isNew());
		
		SimpleMailMessage msg = new SimpleMailMessage();
		msg.setTo(token.getUser().getEmail());
		msg.setFrom("notify@openapplicant.com");
		msg.setSubject("Your Account");
		msg.setText(
				"You have requested to change your Open Applicant password.  " +
				"To reset your password, please visit\n" + token.getUrl()
		);
		getMailSender().send(msg);
		getPasswordRecoveryTokenDao().save(token);
	}
	
	/**
	 * @param the token's guid
	 */
	public PasswordRecoveryToken findPasswordRecoveryTokenByGuid(String guid) {
		return getPasswordRecoveryTokenDao().findByGuid(guid);
	}
	
	/**
	 * Delete's all password recovery tokens for a given user
	 * @param user the user who's tokens to delete
	 */
	public void deleteAllPasswordRecoveryTokensForUser(User user) {
		getPasswordRecoveryTokenDao().deleteAllQuietlyByUserId(user.getId());
	}
	
	/**
	 * Updates an exam with the given artifactId
	 * 
	 * @param examArtifactId
	 * @param name
	 * @param genre
	 * @param description
	 * @param isActive
	 */
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public void updateExamInfo(
			String examArtifactId,
			String name,
			String genre,
			String description,
			boolean isActive) {
		Exam exam = findOrCreateExamSnapshotByArtifactId(examArtifactId);
		exam.setName(name);
		exam.setGenre(genre);
		exam.setDescription(description);
		exam.setActive(isActive);
		getExamDao().save(exam);
	}
	
	/**
	 * Adds a coding question to an exam with the given artifactId
	 * @param examArtifactId the artifactId of the exam to add a question to
	 * @return the added question
	 */
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public Question addQuestionToExam(String examArtifactId, Question question) {
		Exam exam = findOrCreateExamSnapshotByArtifactId(examArtifactId);
		exam.addQuestion(question);
		exam = getExamDao().save(exam);
		return question;
	}
	
	/**
	 * Adds a coding question to an exam with the given artifactId
	 * @param examArtifactId the artifactId of the exam to add a question to
	 * @return the added question
	 */
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public Question addMultipleChoiceQuestionToExam(String examArtifactId) {
		Exam exam = findOrCreateExamSnapshotByArtifactId(examArtifactId);
		Question question = new MultipleChoiceQuestion();
		exam.addQuestion(question);
		exam = getExamDao().save(exam);
		return question;
	}
	
	/**
	 * @param examArtifactId
	 * @param question
	 */
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public void updateExamQuestion(String examArtifactId, Question question) {
		Exam exam = findOrCreateExamSnapshotByArtifactId(examArtifactId);
		exam.updateQuestion(question);
		getExamDao().save(exam);
	}

	/**
	 * Retrieves the latest exam snapshot for the given artifactId.  
	 * If the artifact does not have a latest snapshot, this method
	 * creates one.
	 * 
	 * @param artifactId the artifactId of the exam to retrieve
	 * @return the artifact's latest snapshot
	 */
	private Exam findOrCreateExamSnapshotByArtifactId(String artifactId) {
		Exam exam = findLatestExamVersionByArtifactId(artifactId);
		if(exam.isSnapshot()) {
			return exam;
		} else {
			log.info("creating snapshot for exam.id:" + exam.getId());
			Exam snapshot = exam.createSnapshot();
			getExamDao().save(exam);
			getExamDao().save(snapshot);
			return snapshot;
		}
	}
	
	/**
	 * @param user the user who wishes to send an email
	 * @param candidateId the id of the candidate to receive the email
	 * @param exasmLink id the id of the exam link
	 * @param message the message to send
	 */
	public void sendExamInviteEmail(User user, long examLinkId, SimpleMailMessage message) {
		CandidateExamLink examLink = getCandidateExamLinkDao().find(examLinkId);
		
		Verify.contains(message.getTo(), examLink.getCandidate().getEmail(), "candidate should be the recipient of message");
		
		getMailSender().send(message);
		examLink.getCandidate().setStatus(Candidate.Status.SENT_EXAM);
		getCandidateDao().save(examLink.getCandidate());
		getCandidateWorkFlowEventDao().save(new UserSentExamLinkEvent(user, examLink));
	}
	
	/**
	 * @param accountCreationToken account creation token
	 */
	public void saveAccountCreationToken(AccountCreationToken accountCreationToken) {
		getAccountCreationTokenDao().save(accountCreationToken);
	}

	/**
	 * 
	 * @param token the Account Creation Token to send e-mail about
	 */
	public void sendAccountCreationEmail(SimpleMailMessage message) {
		getMailSender().send(message);
	}

	public AccountCreationToken findAccountCreationTokenByGuid(String guid) {
		return getAccountCreationTokenDao().findByGuid(guid);
	}
	
	
	
	public void computeMatchScore(Candidate candidate) {

		
		try {
		
		// get the most recent sitting
		Sitting sitting = candidate.getLastSitting();
		if (sitting == null) {
			candidate.setMatchScore(null);
			// can't compute a matching score if we have no sitting.
			return;
		}
		
		ResponseSummary summary = sitting.getResponseSummary();

		Map<String,Integer> elements = new HashMap<String,Integer>();
		Map<String,Double> values    = new HashMap<String,Double>();

		elements.put("total_time",1);
		values.put("total_time", new Double(summary.getTotalTime()));

		elements.put("key_chars",1);
		values.put("key_chars",new Double(summary.getKeyChars()));

		elements.put("hesitation_time", 1);
		values.put("hesitation_time",new Double(summary.getHesitationTime()));
		
		elements.put("focus_changes", -1);
		values.put("focus_changes",new Double(summary.getFocusChanges()));
		
		elements.put("paste_presses", -1);
		values.put("paste_presses", new Double(summary.getPastePresses()));

		
		QuestionStatistics qs_style = getExamDao().findSittingStatisticsBySittingId(sitting.getId(),"style");
		elements.put("style",1);
		values.put("style",new Double(qs_style.getMean().doubleValue()));
		
		QuestionStatistics qs_correct = getExamDao().findSittingStatisticsBySittingId(sitting.getId(),"correctness");
		elements.put("correctness", 1);
		values.put("correctness",new Double(qs_correct.getMean().doubleValue()));
		
		// resume screening score
		
		double score = 0.0;
		double max_score = 0.0;
		for (String item : elements.keySet()) {
			//FIXME: refactor this so the column doesn't leak
			QuestionStatistics qs = getExamDao().findExamStatisticsByArtifactIdAndColumn(sitting.getExam().getArtifactId(),item);
			double item_score = simpleScoreFunction(values.get(item), qs.getHiredMean().doubleValue(),qs.getStddev().doubleValue());
			score += (elements.get(item) * item_score);
			if (elements.get(item) > 0)
				max_score += (elements.get(item) * 5.0);
		}
		
		double computed_score = (100.0 * score) / max_score;
		if (score < 0) 
			score=0;
		candidate.setMatchScore(new BigDecimal(computed_score));
		
		} catch (Exception e) {
			// FIXME maybe set the score to 0 instead of null
			candidate.setMatchScore(null);
		}
		
		
		
	}

	public Company findCompanyByEmailAlias(
			String alias) {
		// TODO Auto-generated method stub
		return getCompanyDao().findByEmailAlias(alias);
	}

	public void saveCompany(Company company) {
		getCompanyDao().save(company);
	}
	
	
	
	private double simpleScoreFunction(double value, double mean, double stddev) {	
		double total_diff = value - mean;
		if (total_diff < (0.0 - stddev) )
			return 0;
		else if (total_diff > stddev)
			return 4;
		else if (total_diff < 0) 
			return 1;
		else if (total_diff > 0) 
			return 3;
		else
			return 2;
	}

}
