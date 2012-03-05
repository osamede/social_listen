<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<div id="toolbar">
	<div class="toolbar_item" id="candidates_button">
		<div>
			<a href="<c:url value='/admin/candidates/index'/>">
				<img src="<c:url value='/img/candidates_list.png'/>"/>
			</a>
			<a href="<c:url value='/admin/candidates/create'/>">
				<img src="<c:url value='/img/candidates_new.png'/>"/>
			</a>
		</div>
		<div class="label">Candidates</div>
	</div>
	<div class="toolbar_item">
		<div>
			<a href="<c:url value='/admin/settings/index'/>">
				<img src="<c:url value='/img/settings.png'/>"/>
			</a>
		</div>
		<div class="label">Settings</div>
	</div>
	<div class="toolbar_item">
		<div>
			<a href="<c:url value='/admin/help/index'/>">
				<img src="<c:url value='/img/help.png'/>"/>
			</a>
		</div>
		<div class="label">Help</div>
	</div>
	<div class="toolbar_item">
		<div>
			<a href="<c:url value='/j_spring_security_logout'/>">
				<img src="<c:url value='/img/logout.png'/>"/>
			</a>
		</div>
		<div class="label">Logout</div>
	</div>
</div>
<form action="<c:url value='/admin/candidates/search'/>">
	<input class="search" id="search" type="text" name="q" value="<c:out value="${fullTextQuery}"/>"/>
	<input class="search" id="search_placeholder" type="text" value="search candidates" />
</form>
<script type="text/javascript">
	$(document).ready(function() {
	/* Press enter to submit search form in IE. */
	$('#search').bind("keydown", function(e){
		if (e.keyCode == 13) {
			this.form.submit();
			return false;
		}
	});

	/* Disappearing placeholder text in search field (cross-browser compatible). */
	$("#search_placeholder").bind("focus", function(e){
		$("#search_placeholder").hide();
		$("#search").show().focus();
	});
	$("#search").bind("blur", function(e){
		if ($("#search").val().length == 0) {
			$("#search").hide();
			$("#search_placeholder").show();
		}
	});
	<c:if test="${!empty fullTextQuery}">
		$("#search_placeholder").focus();
	</c:if>
});
</script>