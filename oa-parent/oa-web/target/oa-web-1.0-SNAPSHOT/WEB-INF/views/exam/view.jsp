<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>
<%@ page import="static org.openapplicant.domain.User.Role.ROLE_ADMIN" %>

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
	
	<form:form commandName="exam" action="update" cssClass="group" cssStyle="clear:both;">
		<form:hidden path="artifactId"/>
		<ul>
			<li>
				<label>Name:</label>
				<div>
					<form:input path="name"/>
					<form:errors cssClass="error" path="name"/>
				</div>
			</li>
			<li>
				<label>Genre:</label>
				<div>
					<form:input path="genre"/>
					<form:errors cssClass="error" path="genre"/>
				</div>
			</li>
			<li>
				<label>Description:</label>
				<div>
					<form:textarea path="description"/>
					<form:errors cssClass="error" path="description"/>
				</div>
			</li>
			<li>
				<label>Exam Status:</label>
				<div>
					<label>
					    <form:radiobutton path="active" value="true"/> Enabled
				    </label>
					<label>
					    <form:radiobutton path="active" value="false"/> Disabled
				    </label>
				</div>
			</li>
			<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
			<li class="actions">
				<input type="submit" value="Save" />
			</li>
			</security:authorize>
		</ul>
	</form:form>	
</div>
<security:authorize ifNotGranted="<%=ROLE_ADMIN.name()%>">
<script type="text/javascript">
	jQuery(function() {
		jQuery('#content :input').each(function() {
			this.disabled=true;
		});
	});
</script>
</security:authorize>
