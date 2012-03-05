<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="tt" uri="/WEB-INF/tlds/ttTagLibrary.tld"%>

<ul class="tests">
<c:forEach var="e" items="${exams}">
	<li class="${e.artifactId eq exam.artifactId && question eq null ?'selected':''}">
		<a href="<c:url value='view?e=${e.artifactId}'/>">
			<c:out value="${tt:abbreviate(e.name)}"/>
		</a>
	</li>
	<c:if test="${e.artifactId eq exam.artifactId}">
		<ul class="questions">
		<c:forEach var="q" items="${e.questions}" >
			<li class="${q.artifactId eq question.artifactId ? 'selected':''}">
				<a href="<c:out value='question?e=${e.artifactId}&q=${q.artifactId}'/>" >
					<c:out value="${tt:abbreviate(q.name)}"/>								
				</a>
			</li>
		</c:forEach>
		</ul>
	</c:if>
</c:forEach>
</ul>
