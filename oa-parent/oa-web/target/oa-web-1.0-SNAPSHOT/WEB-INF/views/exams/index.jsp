<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>
<%@ page import="static org.openapplicant.domain.User.Role.ROLE_ADMIN" %>

<style type="text/css">
	th.name {
		width: 37.5%;
	}
	
	th.genre {
		width: 12.5%;
	}
	
	th.desc {
		width: 37.5%;
	}
	
	th.state {
		width: 12.5%;
	}
	.action {
		display:inline;
		margin-right:10px;
	}
</style>

<div id="content">
	<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
	<div>
		<h1 class="action">
			<img src="<c:url value='/img/settings/new-test.png' />" />
			<a href="<c:url value='/admin/exam/add' />">Create New Exam</a>
		</h1>
		<h1 class="action">
			<img src="<c:url value="/img/settings/settings.png"/>"/>
			<a href="<c:url value="/admin/exams/site"/>">Configure Portal</a>
		</h1>
	</div>
	</security:authorize>
	<table class="sortable" id="openapplicant_exams_list">
		<thead>
			<tr>
				<th class="name">Name</th>
				<th class="genre">Genre</th>	
				<th class="desc">Description</th>
				<th class="state">State</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="e" items="${exams}">
			<tr>
				<td>
					<a href="<c:url value='/admin/exam/view?e=${e.artifactId}'/>">
						<c:out value="${tt:abbreviateTo(e.name, 45)}"/>
					</a>
				</td>
				<td><c:out value="${e.genre}" /></td>	
				<td><c:out value="${e.description}" /></td>
				<td>
					<c:choose>
						<c:when test="${e.active}">Active</c:when>
						<c:otherwise>Disabled</c:otherwise>
					</c:choose></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>	
</div>

<script type="text/javascript">
	oltk.include('openapplicant/admin/helper/jquery.tablesorter.min.js');
	
	$(document).ready(function() {
		if($("#openapplicant_exams_list").find("tr").length < 2)
			return;
		
		$("#openapplicant_exams_list").tablesorter({
			widgets: ['zebra'] //alternating row styles
		});
	});	
</script>
