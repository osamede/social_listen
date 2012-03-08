<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tt" uri="/WEB-INF/tlds/ttTagLibrary.tld" %>

<label>Choices:</label>
<div>
	<ul class="multiple_choice">
		<c:forEach var="choice" items="${question.choices}" varStatus="row">
		<li>
			<input type="radio" class="radio" name="answerIndex" value="${row.index}"
				<c:if test="${row.index eq question.answerIndex}">checked="checked"</c:if> />
			<input type="text" class="prompt" name="choices" value="${choice}"/>
		</li>
		</c:forEach>
		<c:if test="${not empty choicesValidError}">
		<li>
			<span class="error"><c:out value="${choicesValidError}"/></span>
		</li>
		</c:if>
		<%--
		<li class="save">
			<input type="submit" class="offset" value="add"/>
			<input type="submit" value="remove"/>	
		</li>
		--%>
	</ul>
</div>