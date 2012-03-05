<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tt" uri="/WEB-INF/tlds/ttTagLibrary.tld" %>
<%@ page import="static org.openapplicant.domain.User.Role.ROLE_ADMIN" %>


<%@ page import="org.openapplicant.domain.question.CodeQuestion" %>
<%@ page import="org.openapplicant.domain.question.MultipleChoiceQuestion" %>

<div id="content">

	<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
		<h1 style="display: inline;">
			<img src="<c:url value='/img/settings/new-test.png' />" />
			<a id="addQuestionLink">Add Question of Type:</a>
		</h1>
		<select id="questionType" style="position: relative; top: -2px; left: 4px;">
			<option value="" selected="selected"></option>
			<option value="<c:url value='addEssayQuestion?e=${exam.artifactId}'/>">Essay</option>
			<option value="<c:url value='addCodeQuestion?e=${exam.artifactId}'/>">Code</option>
			<option value="<c:url value='addMultipleChoiceQuestion?e=${exam.artifactId}'/>">Multiple Choice</option>
		</select>
		<script type="text/javascript">
			$('#questionType').change( function() {
				$('#addQuestionLink').attr('href', $(this).val());
			});
		</script>
	</security:authorize>
	
	<!-- it's lame that a tile cant insert this into a spring form... i could have used the binding -->
	<form action="<tiles:insertAttribute name="action"/>" method="POST" class="group" style="clear:both;">
		<input type="hidden" name="e" value="<c:out value='${exam.artifactId}' />"/>
		<input type="hidden" name="q" value="<c:out value='${question.artifactId}' />"/>
		<ul>
			<li>
				<label>Name:</label>
				<div>
					<input type="text" name="name" value="<c:out value='${question.name}'/>"/>
				</div>
			</li>
			<li>
				<label>Prompt:</label>
				<div>
					<textarea name="prompt" class="required"><c:out value="${question.prompt}"/></textarea>
				</div>
			</li>
			<li>
				<tiles:insertAttribute name="questionKind"/>
			</li>
			<li>
				<label>Time allowed:</label>
				<div>
					<input type="text" id="timeAllowed" name="timeAllowed" value="<c:out value='${question.timeAllowed}'/>" class="half number"/>
					<br/>
					<span>(seconds, blank is untimed)</span>
				</div>
			</li>
			<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
			<li class="actions">
				<input type="submit" name="save" value="Save"/>
			</li>
			</security:authorize>
		</ul>
	</form>
	
	<security:authorize ifNotGranted="<%=ROLE_ADMIN.name()%>">
		<script type="text/javascript">
			$('#content input, #content textarea, #content select').each(function() {
				this.disabled=true;
			});
		</script>
	</security:authorize>
	
	<script type="text/javascript">
		oltk.include('jquery/validate/jquery.validate.js');
		$('#content form').validate();
		$('#content #timeAllowed').rules("add",{
			min: 0
		});
	</script>
</div>