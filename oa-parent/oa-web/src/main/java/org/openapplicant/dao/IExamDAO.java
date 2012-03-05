package org.openapplicant.dao;

import java.util.List;

import org.openapplicant.domain.Company;
import org.openapplicant.domain.Exam;
import org.openapplicant.domain.QuestionStatistics;


public interface IExamDAO extends IDomainObjectDAO<Exam> {
	
	/**
	 * Find all latest versions in each exam artifact for the a company with
	 * the given id
	 * 
	 * @param companyId the id of the company who's exams to find
	 * @return a list of the latest exam versions.
	 */
	List<Exam> findLatestVersionsByCompanyId(long companyId);
	
	/**
	 * Finds all latest active versions of each exam artifact for the 
	 * company with the given id
	 * 
	 * @param companyId the id of the company who's active exams to find
	 * @return a list of the latests exam versions
	 */
	List<Exam> findLatestActiveVersionsByCompanyId(long companyId);
	
	/**
	 * Find the latest version of an exam with the given group id
	 * 
	 * @param groupId the id of the exam group
	 * @return the latest version.
	 */
	Exam findLatestVersionByArtifactId(String groupId);

	
	/**
	 * find the latest version of an exam with the specified company and name
	 */
	Exam findLatestVersionByCompanyAndName(Company company,String name);
	
	/**
	 * return the question statistics for the specified exam and column
	 * @param artifactId
	 * @param column
	 * @return
	 */
	QuestionStatistics findExamStatisticsByArtifactIdAndColumn(final String artifactId, String column);
	
	
	// TODO move me to sittingDAO?
	QuestionStatistics findSittingStatisticsBySittingId(final Long sittingId, String column);
	
}
