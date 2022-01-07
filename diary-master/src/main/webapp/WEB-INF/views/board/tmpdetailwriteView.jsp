<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" >
<script src="https://code.jquery.com/jquery-3.2.1.js"></script>
<script type="text/javascript" src="/resources/js/canvas/html2canvas.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/canvas/html2canvas.min.js"></script>
<script src="https://unpkg.com/gijgo@1.9.13/js/gijgo.min.js" type="text/javascript"></script>
<link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />

<head>
	<title>일기장</title>
</head>
<style type="text/css">
#inputs1 {
  background-attachment: local;
  background-image:
    linear-gradient(to right, white 10px, transparent 10px),
    linear-gradient(to left, white 10px, transparent 10px),
    repeating-linear-gradient(white, white 30px, #ccc 30px, #ccc 31px, white 31px);
  line-height: 31px;
  padding: 6px 8px;
}
#inputs2 {
  background-attachment: local;
  background-image:
    linear-gradient(to right, white 10px, transparent 10px),
    linear-gradient(to left, white 10px, transparent 10px),
    repeating-linear-gradient(white, white 30px, #ccc 30px, #ccc 31px, white 31px);
  line-height: 31px;
  padding: 6px 8px;
}
</style>	
<style>
    div.leftroot {
        width: 20%;
        height: 100%;
        float: left;
        box-sizing: border-box;
    }
    div.rightroot {
        width: 80%;
        height: 100%;
        float: right;
        box-sizing: border-box;
    }  
	#styledatepicker {
		float: right;
	}
</style>
<script>  
	$(function() {});//jquery 준비함수
	
	/* ---------------------------------------------게시글 작성 관련 함수 --------------------------------------*/
  	
    function imgSrcMake(){//화면캡쳐 url 담기
    	html2canvas($("#alertalert").get(0)).then(function(canvas) {
    	imgSource = $("#imgSrc").val(canvas.toDataURL("image/png"));
    	});
    	return imgSource;
    }        
  	
   	function sumcontent(){//게시글수정 함수   
   		
		var imgSourceChk = imgSrcMake();		

		if(imgSourceChk != ""){
   			var contentValue1 = $('#inputs1').val();
   			var contentValue2 = $('#inputs2').val();
   			var addString = '`\\';
   			var contentValue = contentValue1 + contentValue2;
   			var contentTotal = contentValue1 + addString+ contentValue2;
   			var bno = $('#bno').val();
   			
   			var fontsize = $('select[name=fontsize]').val();
   			var fontcolor = $('select[name=fontcolor]').val();
   			var font = $('select[name=font]').val();   
   						
   			if(contentValue == ""){
   				alert("내용을 적어주세요.");
   				return false;
   			}   			
   			
   			$.ajax({//ajax 데이터 통신
   				type: 'POST',
   				url : 'updateTmp',
   				data: {
					   "content" 	 : contentTotal,	
					   "bno" : bno,
					   "filepathurl" : $("#imgSrc").val(),
					   "fontsize":fontsize,
   					   "fontcolor":fontcolor,
   					   "font":font
   				},
   				success : function(data) { 
   					console.log(data);
   					alert('수정되었습니다.');
   				}
   			});
		}
   	}
   	
  	//목록 선택하면 불러오기
   	function detailwriteView(bno){
   		//ajax 데이터 통신
		$.ajax({ 
			type: 'POST',
			url : 'tmpdetailwriteView',
			data: {
				   "bno"    	 : bno	   
			},
			success : function(data) { 
				console.log(data);
			}
		});
   	}  	
   	
   	function deleteBoard(bno){
   		var delchk = confirm('삭제하시겠습니까?');
   		if(delchk == true){
   			$.ajax({ 
   				type: 'POST',
   				url : 'deleteTmp',
   				data: {
   					   "bno"    	 : bno
   				},
   				success : function(data) { 
   					console.log(data);
   					alert("삭제되었습니다.");
   					location.reload();   					
   				}
   			});
   		}
   	}   	
   	/* 로그인 관련 함수 */
   	
   	function layer_popup(el){//로그인 창 팝업
   		var $el = $(el);        
        var isDim = $el.prev().hasClass('dimBg');//dimmed 레이어를 감지하기 위한 boolean 변수		
        isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();

        var $elWidth = ~~($el.outerWidth()),
            $elHeight = ~~($el.outerHeight()),
            docWidth = $(document).width(),
            docHeight = $(document).height();

        // 화면의 중앙에 레이어를 띄운다.
        if ($elHeight < docHeight || $elWidth < docWidth) {
            $el.css({
                marginTop: -$elHeight /2,
                marginLeft: -$elWidth/2
            })
        } else {
            $el.css({top: 0, left: 0});
        }

        $el.find('#btn-layerClose').click(function(){
            isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
            return false;
        });

        $('.layer .dimBg').click(function(){
            $('.dim-layer').fadeOut();
            return false;
        });
    }   	
   	
   	function login(){//로그인 함수, ajax를 사용하기 때문에 required 적용이 어렵다.
   		var idchk = $("#inputEmail3").val();
   		var passchk = $("#inputPassword3").val();

   		if(idchk==''){
   			alert('ID를 입력해주세요');
   			return false;
   		}
   		if(passchk==''){
   			alert('비밀번호를 입력해주세요');
   			return false;
   		}
   		
   		$.ajax({ 
			type: 'POST',
			url : 'login',
			data: {
				   "member_id"    	 : idchk,
				   "password"		: passchk
			},
			success : function(data) { 
				console.log(data);
				$('.dim-layer').fadeOut();	
				sumcontent;
				location.reload();				
			} 			
		});
   	}
   	
   	/* ---------------------------------------------본문 꾸미기 관련 함수 --------------------------------------*/
	function changeSize(){
   		var text1 =  document.getElementById("inputs1");
   		var text2 =  document.getElementById("inputs2");
   		var fontS = document.getElementById("font-size");   		
   		
   		text1.style.fontSize =  fontS.value+"px";
   		text2.style.fontSize =  fontS.value+"px"; 		

   	}
   	function changeColor(){   		
   		var text1 =  document.getElementById("inputs1");
   		var text2 =  document.getElementById("inputs2");
   		var fontC = document.getElementById("font-color");   		
   		
   		text1.style.color =  fontC.value;
   		text2.style.color =  fontC.value; 		

   	}
   	function changeFont(){   		
   		var text1 =  document.getElementById("inputs1");
   		var text2 =  document.getElementById("inputs2");
   		var font1 = document.getElementById("font1");   		
   		
   		text1.style.fontFamily =  font1.value;
   		text2.style.fontFamily =  font1.value;

   	}
   	window.onload = function(){
   		changeSize();
   		changeColor();
   		changeFont();
   	}
</script>
	<body>
		<c:forEach items="${list2}" var = "list2">
		<c:set var="bno2" value="${list2.bno }"/>
		</c:forEach>
		<div class="leftroot">
			<div class="alert alert-warning" role="alert">
				<section id = "container">
					<table>					
						<c:forEach items="${list}" var = "list">
						<c:set var="bno1" value="${list.bno }"/>												
							<tr>
								<td <c:if test="${bno1==bno2 }">style="border:1px red solid;"</c:if>>
									<a href="detailwriteView?bno=${list.bno}">
										<img onclick="detailwriteView(${list.bno});" style="cursor:hand" 
										src="${pageContext.request.contextPath}/resources/image/${list.filepath}" width="100%" height="30%"/>
									</a><hr />
								</td>
							</tr>						
						</c:forEach>
					</table>
				</section>
			</div>
		</div>
		<div class="rightroot">
			<input type="hidden" name="imgSrc" id="imgSrc" />
			<div id="alertalert" class="alert alert-primary" role="alert">
				<header>
					<h1> 일기장 </h1>
				</header>
				<div align="right">		
						<a href="#layer2" id="loginbtn" class="btn btn-primary" >로그인</a>
				</div>				
				<hr />
				<hr />
				<section id="container">
					<form role="form">					 
						<table style="width: 100%">
							<tbody>							
								<tr>
									<td>
										<label for="content">내용</label>
									</td>
									<td>
										<div id="styledatepicker">
											<c:forEach items="${list2}" var = "list2">
											<c:set var="content1" value="${list2.content }"/>
											<c:set var="font" value="${list2.font }"/>
											<c:set var="fontsize" value="${list2.fontsize }"/>
											<c:set var="fontcolor" value="${list2.fontcolor }"/>
											<input type="text" value="작성일 : ${list2.write_date }" readonly/>
											<input type="hidden" id="bno" name="bno" value="${list2.bno }"/>
											</c:forEach> 											
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<textarea id="inputs1" class="form-control"  cols = "70" rows = "10" name="content1" maxlength="410">${fn:split(content1,'`\\')[0] }</textarea>
									</td>
									<td>										
										<textarea id="inputs2" class="form-control" cols = "70" rows = "10" name="content2" maxlength="410" >${fn:split(content1,'`\\')[1] }</textarea>
									</td>				
								</tr>
								<tr><!-- 게시글 꾸미기 -->
									<td>
									<input type="hidden" id="writer" name="writer" value="${sessionScope.userid }"/>
										<select id="font-size" onchange="changeSize()" name="fontsize">
											<option value="10" ${fontsize==Null ? "selected" : ""}>기본값</option>
											<option value="15" ${fontsize==15 ? "selected" : ""}>15</option>
											<option value="25" ${fontsize==25 ? "selected" : ""}>25</option>
											<option value="35" ${fontsize==35 ? "selected" : ""}>35</option>
										</select>																		
										<select id="font-color" onchange="changeColor()" name="fontcolor">
											<option value="black" ${fontsize==Null ? "selected" : ""}>검정</option>
											<option value="red" ${fontcolor=="red" ? "selected" : ""}>빨강</option>
											<option value="blue" ${fontcolor=="blue" ? "selected" : ""}>파랑</option>
											<option value="yellow" ${fontcolor=="yellow" ? "selected" : ""}>노랑</option>
										</select>																		
										<select id="font1" onchange="changeFont()" name="font">
											<option value="Serif" ${fontsize==Null ? "selected" : ""}>기본값</option>
											<option value="Serif" ${font=="Serif" ? "selected" : ""}>돋움체</option>
											<option value="Arial" ${font=="Arial" ? "selected" : ""}>바탕체</option>
											<option value="Courier" ${font=="Courier" ? "selected" : ""}>고딕체</option>
										</select>												
									</td>
									<td align="right">
										<button class="btn btn-primary" type="button" onclick="sumcontent()">수정완료</button>					
										<button class="btn btn-danger" type="button" onclick="deleteBoard(${bno2})">삭제하기</button>
									</td>
								</tr>			
							</tbody>			
						</table>						 
					</form>
				</section>
				<hr />
			</div>
		</div>
	</body>
</html>