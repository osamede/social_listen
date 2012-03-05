<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="static org.openapplicant.domain.User.Role.ROLE_ADMIN"%>

<div id="content">
	<h1>Settings</h1>
	<div class="group">
	
		<ul id="menu">
			<li>
				<a href="<c:url value='/admin/exams/index' />">
					<img src="<c:url value='/img/settings/exams.jpg' />" />
				</a>
				<h2>Exams:</h2>
				<p>Edit existing exams and create new ones to make available to candidates.</p>
			</li>
			<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
			<li>
				<a href="<c:url value='/admin/email/index' />">
					<img src="<c:url value='/img/settings/email.jpg' />" />
				</a>
				<h2>Email:</h2>
				<p>Control what information is communicated from Open Applicant.</p>
			</li>
			<li>
				<a href="<c:url value='/admin/screening/index' />">
					<img src="<c:url value='/img/settings/screening.jpg' />" />
				</a>
				<h2>Screening:</h2> 
				<p>Open Applicant can screen resumes for specific keywords and automatically send exam invitations.</p>
			</li>
			<li>
				<a href="<c:url value='/admin/users/index' />">
					<img src="<c:url value='/img/settings/users.jpg' />" />
				</a>
				<h2>Users:</h2>
				<p>Add and edit users or reset passwords.</p>
			</li>
			</security:authorize>
		</ul>
			
		<hr/>
		
		<div class="row">
			<h2>Company Info:</h2>
		
			<div class="half left">
				<p>
					Please create your job postings with responses sent to:
					<input type="text" readonly="readonly" style="width: 95%;" value="<c:out value="${facilitatorEmailAddress}"/>"
						onclick="this.select();"/>
				</p>
				<p>
					To manually administer tests, please use the following link:
					<input type="text" readonly="readonly" style="width: 95%;" value="<c:out value="${examsUrl}"/>"
						onclick="this.select();"/>
				</p>
			</div>
			
			<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
			<div class="half right">
				<form:form commandName="company" action="update">
					<form:hidden path="id"/>
					<ul class="smaller">
						<li>
							<label>Company Name:</label>
							<div>
								<form:input path="name" cssClass="required"/>
								<form:errors path="name" cssClass="error"/>
							</div>
						</li>
						<li>
							<label>Virtual Host Name:</label>
							<div>
								<form:input path="hostName" cssClass="required"/>
								<form:errors path="hostPort" cssClass="error"/>
							</div>
						</li>
						<li>
							<label>Virtual Host port:</label>
							<div>
								<form:input path="hostPort" cssClass="required number"/>
								<form:errors path="hostPort" cssClass="error"/>
							</div>
						</li>
						<li class="actions">
							<input type="submit" class="submit" value="Save"/>
						</li>
					</ul>
				</form:form>
				<script type="text/javascript">
					oltk.include('jquery/validate/jquery.validate.js');
					$('#company').validate();
				</script>
			</div>
			</security:authorize>
		</div>
		
	</div>
</div>
