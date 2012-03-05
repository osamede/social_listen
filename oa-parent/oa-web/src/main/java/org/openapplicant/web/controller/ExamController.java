package org.openapplicant.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.openapplicant.domain.Exam;
import org.openapplicant.domain.question.CodeQuestion;
import org.openapplicant.domain.question.EssayQuestion;
import org.openapplicant.domain.question.IQuestionVisitor;
import org.openapplicant.domain.question.MultipleChoiceQuestion;
import org.openapplicant.domain.question.Question;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;



@Controller
public class ExamController extends AdminController {
	
	@ModelAttribute("exams")
	public Collection<Exam> populateExams() {
		return getAdminService().findLatestExamVersionsByCompany(currentUser().getCompany());
	}
	
	@RequestMapping(method=GET)
	public String view(
			@RequestParam("e") String examArtifactId, 
			Map<String,Object> model) {
		
		Exam exam = getAdminService().findLatestExamVersionByArtifactId(examArtifactId);
		model.put("exam", exam);
		return "exam/view";
	}
	
	@RequestMapping(method=POST)
	public String update(
			@ModelAttribute("exam") Exam cmd, 
			BindingResult binding,
			Map<String, Object> model) {
		
		Errors errors = cmd.validate();
		if(errors.hasErrors()) {
			binding.addAllErrors(errors);
			return "exam/view";
		}
		getAdminService().updateExamInfo(
				cmd.getArtifactId(), 
				cmd.getName(), 
				cmd.getGenre(), 
				cmd.getDescription(), 
				cmd.isActive()
		);
		return "redirect:view?e="+cmd.getArtifactId();
	}

	@RequestMapping(method=GET)
	public String add(Map<String, Object> model) {
		model.put("exam", new Exam());
		return "exam/add";
	}
	
	@RequestMapping(method=POST)
	public String doAdd(
			@ModelAttribute("exam") Exam exam,
			BindingResult binding) {
		
		Errors errors = exam.validate();
		if(errors.hasErrors()) {
			binding.addAllErrors(errors);
			return "exam/add";
		} else {
			exam.setCompany(currentUser().getCompany());
			getAdminService().saveExam(exam);
			return "redirect:view?e="+exam.getArtifactId();
		}
	}

	@RequestMapping(method=GET)
	public String addEssayQuestion(@RequestParam("e") String examArtifactId) {
		Question question = getAdminService().addQuestionToExam(
					examArtifactId,
					new EssayQuestion()
		);
		return "redirect:question?e="+examArtifactId+"&q="+question.getArtifactId();
	}
	
	@RequestMapping(method=GET)
	public String addCodeQuestion(@RequestParam("e") String examArtifactId) {
		Question question = getAdminService().addQuestionToExam(
					examArtifactId,
					new CodeQuestion()
		);
		return "redirect:question?e="+examArtifactId+"&q="+question.getArtifactId();
	}
	
	@RequestMapping(method=GET)
	public String addMultipleChoiceQuestion(@RequestParam("e") String examArtifactId) {
		Question question = getAdminService().addQuestionToExam(
					examArtifactId,
					new MultipleChoiceQuestion()
		);
		return "redirect:question?e="+examArtifactId+"&q="+question.getArtifactId();
	}

	@RequestMapping(method=GET)
	public String question(
			@RequestParam("e") String examArtifactId, 
			@RequestParam("q") String questionArtifactId, 
			Map<String, Object> model) {
		
		Exam exam = getAdminService().findLatestExamVersionByArtifactId(examArtifactId);
		Question question = exam.getQuestionByArtifactId(questionArtifactId);
		
		model.put("exam", exam);
		model.put("question", question);
				
		return new AdminQuestionViewVisitor(question).getView();
	}

	/**
	 * This method will be less empty when its strongly bound
	 * to the view and it shows errors
	 * 
	 * @param examArtifactId
	 * @param questionArtifactId
	 * @param timeAllowed
	 * @param name
	 * @param prompt
	 * @param answer
	 * @param model
	 * @return redirects to question
	 */
	@RequestMapping(method=POST)
	public String updateEssayQuestion(
			@RequestParam("e") String examArtifactId,
			@RequestParam("q") String questionArtifactId,
			@RequestParam("timeAllowed") Integer timeAllowed,
			@RequestParam("name") String name,
			@RequestParam("prompt") String prompt,
			@RequestParam("answer") String answer,
			Map<String, Object> model) {
		
		EssayQuestion essayQuestion = new EssayQuestion();
		essayQuestion.setArtifactId(questionArtifactId);
		essayQuestion.setTimeAllowed(timeAllowed);
		essayQuestion.setName(name);
		essayQuestion.setPrompt(prompt);
		essayQuestion.setAnswer(answer);
		
		Errors errors = populateErrorsQuestion(model, essayQuestion);
		if(errors.hasFieldErrors("answer")) {
			model.put("answerError", errors.getFieldError("answer").getDefaultMessage());
		}
		if(errors.hasErrors()) {
			Exam exam = getAdminService().findLatestExamVersionByArtifactId(examArtifactId);
			model.put("exam", exam);
			model.put("question", essayQuestion);
			return "exam/essayQuestion";
		}

		getAdminService().updateExamQuestion(examArtifactId, essayQuestion);
		return "redirect:question?e="+examArtifactId+"&q="+questionArtifactId;
	}
	
	private Errors populateErrorsQuestion(Map<String, Object> model, Question question) {
		Errors errors = question.validate();
		if(errors.hasFieldErrors("timeAllowed")) {
			model.put("timeAllowedError", errors.getFieldError("timeAllowed").getDefaultMessage());
		}
		if(errors.hasFieldErrors("name")) {
			model.put("nameError", errors.getFieldError("name").getDefaultMessage());
		}
		if(errors.hasFieldErrors("prompt")) {
			model.put("promptError", errors.getFieldError("prompt").getDefaultMessage());
		}
		return errors;
	}
	
	/**
	 * This method will be less empty when its strongly bound
	 * to the view and it shows errors
	 * 
	 * @param examArtifactId
	 * @param questionArtifactId
	 * @param timeAllowed
	 * @param name
	 * @param prompt
	 * @param answer
	 * @param model
	 * @return redirects to question
	 */
	@RequestMapping(method=POST)
	public String updateCodeQuestion(
			@RequestParam("e") String examArtifactId,
			@RequestParam("q") String questionArtifactId,
			@RequestParam("timeAllowed") Integer timeAllowed,
			@RequestParam("name") String name,
			@RequestParam("prompt") String prompt,
			@RequestParam("answer") String answer,
			Map<String, Object> model) {
		
		CodeQuestion codeQuestion = new CodeQuestion();
		codeQuestion.setArtifactId(questionArtifactId);
		codeQuestion.setTimeAllowed(timeAllowed);
		codeQuestion.setName(name);
		codeQuestion.setPrompt(prompt);
		codeQuestion.setAnswer(answer);

		Errors errors = populateErrorsQuestion(model, codeQuestion);
		if(errors.hasFieldErrors("answer")) {
			model.put("answerError", errors.getFieldError("answer").getDefaultMessage());
		}
		if(errors.hasErrors()) {
			Exam exam = getAdminService().findLatestExamVersionByArtifactId(examArtifactId);
			model.put("exam", exam);
			model.put("question", codeQuestion);
			return "exam/codeQuestion";
		}
		
		getAdminService().updateExamQuestion(examArtifactId, codeQuestion);
		return "redirect:question?e="+examArtifactId+"&q="+questionArtifactId;
	}
	
	/**
	 * This method will be less empty when its tightly
	 * bound to the view and shows errors
	 * 
	 * @param examArtifactId
	 * @param questionArtifactId
	 * @param timeAllowed
	 * @param name
	 * @param prompt
	 * @param answerIndex
	 * @param choices
	 * @param model
	 * @return redirects to question
	 */
	@RequestMapping(method=POST)
	public String updateMultipleChoiceQuestion(
			@RequestParam("e") String examArtifactId,
			@RequestParam("q") String questionArtifactId,
			@RequestParam("timeAllowed") Integer timeAllowed,
			@RequestParam("name") String name,
			@RequestParam("prompt") String prompt,
			@RequestParam(value="answerIndex", required=false) Integer answerIndex,
			@RequestParam("choices") List<String> choices,
			Map<String, Object> model) {
		
		
		MultipleChoiceQuestion multipleChoiceQuestion = new MultipleChoiceQuestion();
		multipleChoiceQuestion.setArtifactId(questionArtifactId);
		multipleChoiceQuestion.setTimeAllowed(timeAllowed);
		multipleChoiceQuestion.setName(name);
		multipleChoiceQuestion.setPrompt(prompt);
		multipleChoiceQuestion.setAnswerIndex(answerIndex);
		multipleChoiceQuestion.setChoicesText(choices);
		
		Errors errors = populateErrorsQuestion(model, multipleChoiceQuestion);
		if(errors.hasFieldErrors("choicesValid")) {
			model.put("choicesValidError", errors.getFieldError("choicesValid").getDefaultMessage());
		}
		if(errors.hasErrors()) {
			Exam exam = getAdminService().findLatestExamVersionByArtifactId(examArtifactId);
			model.put("exam", exam);
			model.put("question", multipleChoiceQuestion);
			return "exam/multipleChoiceQuestion";
		}
		

		getAdminService().updateExamQuestion(examArtifactId, multipleChoiceQuestion);
		return "redirect:question?e="+examArtifactId+"&q="+questionArtifactId;
	}
	
	
	private static class AdminQuestionViewVisitor implements IQuestionVisitor {
		private String view;

		public AdminQuestionViewVisitor(Question question) {
			question.accept(this);
		}
		
		public String getView() {
			return view;
		}
		
		public void visit(CodeQuestion question) {
			this.view = "exam/codeQuestion";
		}

		public void visit(EssayQuestion question) {
			this.view = "exam/essayQuestion";
		}

		public void visit(MultipleChoiceQuestion question) {
			this.view = "exam/multipleChoiceQuestion";
		}
	}

}
