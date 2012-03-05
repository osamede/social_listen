package org.openapplicant.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.Collection;
import java.util.Map;

import org.openapplicant.domain.Exam;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class ExamsController extends AdminController {
	
	@RequestMapping(method=GET)
	public String index(Map<String, Object> model) {
		Collection<Exam> exams = getAdminService().findLatestExamVersionsByCompany(currentUser().getCompany());
		model.put("exams", exams);
	    model.put("examsSidebar", true);
		return "exams/index";
	}
	
	@RequestMapping(method=GET)
	public String site(Map<String,Object> model) {
		Collection<Exam> exams = getAdminService().findLatestExamVersionsByCompany(currentUser().getCompany());
		model.put("welcomeText", currentUser().getCompany().getWelcomeText());
		model.put("completionText", currentUser().getCompany().getCompletionText());
		model.put("exams", exams);
		model.put("examsSidebar", true);
		return "exams/site";
	}
	
	@RequestMapping(method=POST)
	public String updateSite(
			@RequestParam("welcomeText") String welcomeText,
			@RequestParam("completionText")String  completionText,
			Map<String,Object> model) {
		
		currentUser().getCompany().setWelcomeText(welcomeText);
		currentUser().getCompany().setCompletionText(completionText);
		getAdminService().saveCompany(currentUser().getCompany());
		
		return "redirect:site";
	}
}
