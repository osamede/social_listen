<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="/WEB-INF/tlds/DefaultCandidateWorkFlowEventVisitorTag.tld" prefix="events" %>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>

<style type="text/css">
	 @import "<c:url value='/css/layout/candidate_details.css'/>";
     @import "<c:url value='/css/vendor/jquery-ui-themeroller.css'/>";
</style>

<div id="content">
	<div class="row">
		<div class="group left" id="openapplicant_candidate_contact_info" style="width: 420px;">
			<h1>Candidate Details</h1>
			<form:form action="update" commandName="candidate">
				<form:hidden path="id"/>
				<ul class="half left">
					<li>
						<label>First Name:</label>
						<div>
							<form:input path="name.first"/>
							<form:errors path="name.first" cssClass="error"/>
							<form:hidden path="name.middle"/>
						</div>
					</li>
					<li>
						<label>Last Name:</label>
						<div>
							<form:input path="name.last"/>
							<form:errors path="name.last" cssClass="error"/>
						</div>
					</li>
					<li>
						<label>Email:</label>
						<div>
							<form:input path="email"/>
							<form:errors path="email" cssClass="error"/>
						</div>
					</li>
				</ul>
				<ul class="half right">
					<li>
						<label>Work:</label>
						<div>
							<form:input path="workPhoneNumber.number"/>
							<form:errors path="workPhoneNumber.number" cssClass="error"/>
						</div>
					</li>
					<li>
						<label>Cell:</label>
						<div>
							<form:input path="cellPhoneNumber.number"/>
							<form:errors path="cellPhoneNumber.number" cssClass="error"/>
						</div>
					</li>
					<li>
						<label>Home:</label>
						<div>
							<form:input path="homePhoneNumber.number"/>
							<form:errors path="homePhoneNumber.number" cssClass="error"/>
						</div>
					</li>
				</ul>
				<ul>
					<li>
						<label>Address:</label>
						<div>
							<form:textarea path="address" cssStyle="height:52px;"/>
						</div>
					</li>
					<li class="actions">
						<input type="submit" class="submit" name="save" value="Save"/>
						<input type="submit" class="submit" name="cancel" value="Cancel"/>
					</li>
				</ul>
			</form:form>
		</div>
			
		<!--Add note form-->
		<c:if test="${not candidate.incomplete }">
			<div class="group right" id="openapplicant_candidate_note_form" style="width:286px;">
				<span class="error"><c:out value="${noteError}"/></span>
				<form action="<c:url value='/admin/candidates/add_note'/>"  method="post">
					<input name="id" type="hidden" value="<c:out value='${candidate.id}'/>" />
					<ul>
						<li>
							<label>Notes:</label>
							<div>
								<textarea name="note" style="height:139px;"></textarea>
							</div>
						</li>
						<li class="actions">
							<input type="submit" value="Add" />
						</li>
					</ul>
				</form>
			</div>
		</c:if>
	</div>
	
	<div class="row">
		<!--Cover letter form-->
		<div class="file_form" id="openapplicant_candidate_coverletter_form">
			Cover Letter
			<c:choose>
				<c:when test="${!empty candidate.coverLetter}">
					<a href="<c:url value='/admin/file?guid=${candidate.coverLetter.guid}' />" target="_blank">
						<img src="<c:url value='/img/candidate_icons/file.png'/>"/>
					</a>
				</c:when>
				<c:otherwise>
					<img src="<c:url value='/img/candidate_icons/file_missing.png'/>"/>
				</c:otherwise>
			</c:choose>
			<input type="submit" class="upload_new" value="Upload New"/>
			<div class="upload_modal">
				<h2>Upload New Cover Letter</h2>
				<form action="<c:url value='/admin/upload'/>" method="post" enctype="multipart/form-data">
					<input name="id" type="hidden" value="<c:out value='${candidate.id}'/>" />
					<input name="type" type="hidden" value="coverletter" />
					<div class="file"><input type="file" name="file" class="file" /></div>
					<div class="submit"><input type="submit" class="submit" value="Upload"/></div>
				</form>
			</div>
		</div>
	
		<!--Resume form-->
		<div class="file_form" id="openapplicant_candidate_resume_form">
			Resume
			<c:if test="${!empty candidate.resume.screeningScore}">
				(${candidate.resume.screeningScore})
			</c:if>
			<c:choose>
				<c:when test="${!empty candidate.resume}">
					<a href="<c:url value='/admin/file?guid=${candidate.resume.guid}' />" target="_blank">
						<img src="<c:url value='/img/candidate_icons/file.png'/>"/>
					</a>
				</c:when>
				<c:otherwise>
					<img src="<c:url value='/img/candidate_icons/file_missing.png'/>"/>
				</c:otherwise>
			</c:choose>
			<input type="submit" class="upload_new" value="Upload New"/>
			<div class="upload_modal">
				<h2>Upload New Resume</h2>
				<form action="<c:url value='/admin/upload'/>" method="post" enctype="multipart/form-data">
					<input name="id" type="hidden" value="<c:out value='${candidate.id}'/>" />
					<input name="type" type="hidden" value="resume" />
					<div class="file"><input type="file" name="file" class="file" /></div>
					<div class="submit"><input type="submit" class="submit" value="Upload"/></div>
				</form>
			</div>
		</div>
	</div>
	
	<c:if test="${not candidate.incomplete }">
		<div class="group" style="width:716px;">
			<h2>Exam Invitations</h2>
			<select id="exam_selector">
			</select>
			<div id="exam_list">
				<c:forEach var="exam" items="${exams}">
					<div class="exam" id="exam_<c:out value='${exam.id}'/>">
						<div class="name"><c:out value="${tt:abbreviateTo(exam.name,45)}"/></div>
						<c:choose>
							<c:when test="${!empty linkForExam[exam]}">
								<div>
									<img src="<c:url value='/img/exam_link.png' />" />
									<a href="<c:out value='${linkForExam[exam].url}'/>" target="_blank">
										<strong><c:out value='${linkForExam[exam].url}'/></strong>
									</a>
								</div>
								<c:if test="${not empty candidate.email }">
									<div>
										<a class="candidate_exam_link_email" 
											href="<c:url value='mailto:${candidate.email}?subject=Your openapplicant Exam'>
												<c:param name='body' value='${linkForExam[exam].url}'/>
											</c:url> ">
											<img src="<c:url value='/img/email_exam_link.png' />" />
											E-Mail exam invitation to a candidate
											<input type="hidden" value="${linkForExam[exam].id}"/>
										</a>
									</div>
									<div>
										<a href="<c:url value='create_link?id=${candidate.id}&exam_id=${exam.id}' />">
											<img src="<c:url value='/img/exam_link.png' />" />
											Create new exam link
										</a>
									</div>
								</c:if>
							</c:when>
							<c:otherwise>
								<div>
									<a href="<c:url value='create_link?id=${candidate.id}&exam_id=${exam.id}'/>">
										<img src="<c:url value='/img/exam_link.png' />" />
										Create a new exam link for this candidate
									</a>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</c:forEach>
			</div>
		</div>
	</c:if>
	
	<div class="group" style="width:716px;">
		<h2>History</h2>
		<div id="history_list">
			<events:render events="${events}"/>
		</div>
	</div>
</div>


<script type="text/javascript">
	oltk.include('openapplicant/admin/helper/jquery.simplemodal.min.js');

	$(document).ready(function() {
	
		$("#exam_list .exam").each(function(i) {
			var option = $("<option></option>");
			option.val($(this).attr("id"));
			option.text($(this).find(".name").text());
			if ($(this).attr("id") == "exam_${examId}") {
				option.attr("selected", "selected");
			}
			$("#exam_selector").append(option);
		});
		
		$("#exam_selector").bind("change", function(e){
			$("#exam_list .exam").hide();
			$("#" + $("#exam_selector").val()).show();
		});
		$("#exam_selector").change();
	
		$("div.file_form").each(function(i) {
			var form = $(this);
			$(this).find("input.upload_new").bind("click", function(e){
				form.find("div.upload_modal").modal();
		        return false; //prevent form from submitting
		    });
	    });
	    
	    $('.candidate_exam_link_email').click(function() {
	    	var examLinkId = $(':hidden:first', this).val();
	    	$.ajax({
	    		type:'POST',
	    		url: '<c:url value="emailTemplate"/>',
	    		data:{id:examLinkId},
	    		success:function(html) {
	    			$(html).modal({
	    				containerId:'modalContainerExamLinkEmail'
	    			});
	    		}
	    	});
	    	return false;
	    });
	});
</script>