package org.openapplicant.domain;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.IndexColumn;
import org.hibernate.validator.NotEmpty;
import org.hibernate.validator.NotNull;
import org.openapplicant.domain.question.Question;
import org.openapplicant.policy.AssertNotFrozen;
import org.openapplicant.policy.IFreezable;
import org.openapplicant.policy.NeverCall;
import org.springframework.util.Assert;


@Entity
public class Exam extends DomainObject implements IFreezable {

	private Company company;
	
	private String name = "";
	
	private String description = "";
	
	private String genre = "";
	
	private boolean isFrozen = false;
	
	private boolean active = false;
	
	private boolean facilitateEmail = false;
	
	private List<Question> questions = new ArrayList<Question>();
	
	private String artifactId = UUID.randomUUID().toString();
	
	private Exam nextVersion;
	
	private Exam previousVersion;

	/**
	 * @return the artifactId of this exam.
	 */
	@Column(nullable=false, name="artifact_id")
	public String getArtifactId() {
		return artifactId;
	}
	
	@NeverCall
	public void setArtifactId(String value) {
		artifactId = value;
	}
	
	/**
	 * @return the exam's description
	 */
	@NotNull
	@Column(nullable=false)
	public String getDescription() {
		return description;
	}
	
	@AssertNotFrozen
	public void setDescription(String value) {
		description = StringUtils.trimToEmpty(value);
	}
	
	/**
	 * @return the exam's genre
	 */
	@NotNull
	@Column(nullable = false)
	public String getGenre() {
		return genre;
	}
	
	@AssertNotFrozen
	public void setGenre(String value) {
		genre = StringUtils.trimToEmpty(value);
	}
	
	@NotEmpty
	@Column(nullable=false)
	public String getName() {
		return name;
	}
	
	@AssertNotFrozen
	public void setName(String name) {
		this.name = StringUtils.trim(name);
	}
	
	/**
	 * @return true if this exam's state is frozen and must not be edited.
	 */
	@Column(nullable= false) 
	public boolean isFrozen() {
		return isFrozen;
	}
	
	private void setFrozen(boolean value) {
		isFrozen = value;
	}
	
	/**
	 * @return true if this exam is not frozen and may be edited.
	 */
	@Transient
	public boolean isNotFrozen() {
		return !isFrozen;
	}
	
	/**
	 * freeze this exam's state and mark it as non-editable
	 */
	public void freeze() {
		isFrozen = true;
		for(Question each : questions) {
			each.freeze();
		}
	}
	
	@OneToOne(cascade=CascadeType.ALL, fetch=FetchType.LAZY)
	@JoinColumn(nullable=true)
	public Exam getNextVersion() {
		return nextVersion;
	}
	
	private void setNextVersion(Exam exam) {
		nextVersion = exam;
	}
	
	@OneToOne(cascade=CascadeType.ALL, fetch=FetchType.LAZY)
	@JoinColumn(nullable=true)
	public Exam getPreviousVersion() {
		return previousVersion;
	}
	
	private void setPreviousVersion(Exam exam) {
		previousVersion = exam;
	}
	
	@Transient
	public boolean isLatestVersion() {
		return nextVersion == null;
	}
	
	@Transient
	public boolean isOldestVersion() {
		return previousVersion == null;
	}
	
	@Transient
	public boolean isSnapshot() {
		return isLatestVersion() && isNotFrozen();
	}
	
	/**
	 * Creates a snapshot of the latest exam version and locks this version.
	 * @return the created snapshot
	 * @throws IllegalStateException if this exam is not the latest
	 * version.
	 */
	public Exam createSnapshot() {
		Assert.state(this.isLatestVersion(), "snapshot may only be created from the latest version");
		freeze();
		
		Exam snapshot = new Exam();
		nextVersion = snapshot;
		snapshot.setPreviousVersion(this);
		snapshot.artifactId = getArtifactId();
		snapshot.setCompany(getCompany());
		snapshot.setName(getName());
		snapshot.setDescription(getDescription());
		snapshot.setGenre(getGenre());
		snapshot.setFacilitateEmail(isFacilitateEmail());
		for(Question each: questions) {
			snapshot.addQuestion(each);
		}
		snapshot.setActive(active);
		return snapshot;
	}
	
	/**
	 * @return an unmodifiable list of qustion objects.
	 */
	@Transient
	public List<Question> getQuestions() {
		return Collections.unmodifiableList(questions);
	}
	
	/**
	 * @param questionId the id of the question to find.
	 * @return a question with the given id
	 * @throws IllegalArgumentException if no question exists for the given
	 * id, or if id is null.
	 */
	public Question getQuestionById(Long questionId) {
		Assert.notNull(questionId);
		for(Question each : questions) {
			if(ObjectUtils.equals(each.getId(), questionId)) {
				return each;
			}
		}
		throw new IllegalArgumentException("No question for id " + questionId);
	}
	
	/**
	 * Retrieves a question with the given artifactId
	 * @return the question with the given artifactId or null if no question
	 * can be found
	 */
	public Question getQuestionByArtifactId(String artifactId) {
		Assert.notNull(artifactId);
		for(Question each : questions) {
			if(artifactId.equals(each.getArtifactId())) {
				return each;
			}
		}
		return null;
	}
	
	/**
	 * Adds a question to the exam.
	 * @param question the question to add.
	 * @throws IllegalStateException if a question exists with the same 
	 * artifactId.
	 */
	@AssertNotFrozen
	public void addQuestion(Question question) {
		assertUniqueQuestionArtifact(question.getArtifactId());
		questions.add(question);
	}
	
	private void assertUniqueQuestionArtifact(String artifactId) {
		Assert.state(getQuestionByArtifactId(artifactId) == null);
	}
	
	/**
	 * Updates a question by it's artifactId
	 * 
	 * @param updatedValue the updated question
	 */
	@AssertNotFrozen
	public void updateQuestion(Question updatedValue) {
		Question question = getQuestionByArtifactId(updatedValue.getArtifactId());
		if(question.isFrozen()) {
			Question snapshot = question.createSnapshot();
			snapshot.merge(updatedValue);
			int index = questions.indexOf(question);
			questions.set(index, snapshot);
		} else {
			question.merge(updatedValue);
		}
	}
	
	@ManyToMany(cascade={CascadeType.ALL})
	@JoinTable
	@IndexColumn(name="ordinal",base=1, nullable=false)
	private List<Question> getQuestionsInternal() {
		return questions;
	}
	
	private void setQuestionsInternal(List<Question> value) {
		if(value == null) {
			value = new ArrayList<Question>();
		}
		questions = value;
	}
	
	/**
	 * @return the company owning the exam.
	 */
	@ManyToOne(
			cascade={CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH},
			fetch=FetchType.LAZY
	)
	@Cascade(org.hibernate.annotations.CascadeType.SAVE_UPDATE)
	@JoinColumn(nullable=false)
	public Company getCompany() {
		return company;
	}
	
	@AssertNotFrozen
	public void setCompany(Company company) {
		this.company = company;
	}
	
	/**
	 * @return true if this exam is available to candidates.
	 */
	@Column(nullable=false,columnDefinition="bit(1) default 1")
	public boolean isActive() {
		return active;
	}
	
	@AssertNotFrozen
	public void setActive(boolean value) {
		active = value;
	}

	/**
	 * @return true if this exam should be available for email facilitation.
	 */
	@Column(columnDefinition="bit(1) default 0", nullable=false)
	public boolean isFacilitateEmail() {
		return facilitateEmail;
	}
	
	@AssertNotFrozen
	public void setFacilitateEmail(boolean value) {
		facilitateEmail = value;
	}
}
