<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>

<%@ taglib prefix="tt" uri="/WEB-INF/tlds/ttTagLibrary.tld"%>
<%@ page import="static org.openapplicant.domain.User.Role.ROLE_ADMIN"%>

<div id="sidebar">
	<div class="group">
		<h3 class="${settingsSidebar? 'selected':''}">
			<img src="<c:url value='/img/sidebar/settings.gif' />" />
			<a href="<c:url value='/admin/settings/index' />">
				Settings
			</a>
		</h3>
		<ul>
			<li class="exam ${examsSidebar?'selected':''}">
				<a href="<c:url value='/admin/exams/index' />">
					Exams
				</a>
				<tiles:insertAttribute name="exams"/>
			</li>
			<security:authorize ifAllGranted="<%=ROLE_ADMIN.name()%>">
				<li class="email ${emailSidebar?'selected':''}">
					<a href="<c:url value='/admin/email/index' />">
						Email
					</a>
					<tiles:insertAttribute name="email"/>
				</li>
				<li class="screening ${screeningSidebar?'selected':''}">
					<a href="<c:url value='/admin/screening/index' />">
						Screening
					</a>
					<tiles:insertAttribute name="screening"/>
				</li>
				<li class="users ${usersSidebar?'selected':''}">
					<a href="<c:url value='/admin/users/index' />">
						Users
					</a>
					<tiles:insertAttribute name="users"/>
				</li>
			</security:authorize>
		</ul>
	</div>
</div>