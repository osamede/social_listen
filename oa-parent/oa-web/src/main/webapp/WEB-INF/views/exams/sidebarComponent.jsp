<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="tt" uri="/WEB-INF/tlds/ttTagLibrary.tld"%>

<ul class="tests">
<c:forEach var="e" items="${exams}">
	<li class="${e.artifactId eq exam.artifactId ? 'selected':''}">
		<a href="<c:url value='/admin/exam/view?e=${e.artifactId}'/>">
			<c:out value="${tt:abbreviate(e.name)}"/>
		</a>
	</li>
</c:forEach>
</ul>