<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 기본 기능  -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- 포맷  -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!-- 함수 기능  -->

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=XsuGaqmxx6Ksoma69peg&submodules=geocoder"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/style.css" />
	    <!-- Bootstrap core CSS -->
    <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css">
    <!-- Custom styles for this template -->
    <link href="${pageContext.request.contextPath}/resources/css/scrolling-nav.css" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet">
</head>

<!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">지역별 사각지대 서비스</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
       
        </div>
      </div>
    </nav>

 <style>
 p{
 font-family: 'Jeju Gothic', sans-serif;
 }
 div{
 	font-family: 'Jeju Gothic', sans-serif;
 }
 	
 ul,li {margin:0px; padding :10px; list-style:none;font-family: 'Jeju Gothic', sans-serif; }

li{width:100%;height:40px; border-bottom:1px}

div.nav-left {
	height: 100%;
	float : left;
	width : 250px;
	border-right: solid;
	border-right-width: 0.2px;
}

div.nav-contents{
/* 	float : left; */
	height: 100%;
	font-family: 'Jeju Gothic', sans-serif;
}


body{
	font-family:jejugothic;
}

 </style>     
<body>
<br>
<br><br>
			<div class ="nav-left">
			
			<form>
			<ul class="item">
			<li></li>
            <li class="nav-item" style="">
            <p>작업선택</p>
            </li>
            <li class="nav-item" style="">
			<c:choose>
				<c:when test = "${'전국' eq sessionScope.city}">
					<label><input type="radio" checked="checked" value="전국" id="전국" name="sele"/>전국
           			</label>
           			<label><input type="radio" value="시도" id="시도" name="sele"/>시도</label>
				</c:when>
				<c:otherwise>
					<label><input type="radio" value="전국" id="전국" name="sele"/>전국
           			</label>
           			<label><input type="radio" checked="checked" value="시도" id="시도" name="sele"/>시도</label>
				</c:otherwise>
			</c:choose>
			</li>
            
            <li class="nav-item" style="">
              <input class ="hide" type="text"  value="${sessionScope.city}" hidden="true">
              <input class ="hideGra" type="text"  value="${sessionScope.graphs}" hidden = "true">
              <select class="citySel" id="citySel">
              <c:set var = "sCity" value="${sessionScope.city}" />
        	<c:forEach var="city" items="${citylist}">
			<c:choose>
				<c:when test ="${sCity eq city.city}">
					<option value="${city.city}" selected="selected">${city.city}</option>
				</c:when>
				<c:otherwise>
					<option value="${city.city}">${city.city}</option>
				</c:otherwise>
			</c:choose>
			</c:forEach>
			</select>
		</li>
	
<!--             </li> -->
			
            <form>
            <li class="nav-item">
            <p>데이터 타입</p>
            </li>
            <li>
            <c:choose>
				<c:when test = "${'충원률' eq sessionScope.graphs}">
           			 <label><input type="radio" checked="checked" value="충원률" id="birth" name="graphs">충원률</label>
           			 <label><input type="radio" value="재산세" id="money" name="graphs"/>재산세</label>
          			 <label><input type="radio" value="영유아" id="child" name="graphs"/>영유아</label>
            	</c:when>
            	<c:when test = "${'재산세' eq sessionScope.graphs}">
          			  <label><input type="radio" value="충원률" id="birth" name="graphs">충원률</label>
          			  <label><input type="radio" checked="checked" value="재산세" id="money" name="graphs"/>재산세</label>
          			  <label><input type="radio" value="영유아" id="child" name="graphs"/>영유아</label>
            	</c:when>
            	<c:otherwise>
            	      <label><input type="radio" value="충원률" id="birth" name="graphs">충원률</label>
          			  <label><input type="radio" value="재산세" id="money" name="graphs"/>재산세</label>
          			  <label><input type="radio" checked="checked" value="영유아" id="child" name="graphs"/>영유아</label>
            	</c:otherwise>
            </c:choose>
            </li>
            <li>
            <input type="button" value="검색" id='selBtn'/>
            </li>
            </form>
          </ul>
          </div>
          <div class="nav-contents">
          <Table>
          <tr>
          <td>
	<iframe id="a"src="${pageContext.request.contextPath}/resources/data/${city}.svg" width="600" height="750" scrolling="no"
    marginheight="0" marginwidth="0" style="border: 0px solid;">
    
    <br>
    
    </iframe> 
    <p align="center">
    <g class="siHide">시/도<input type="text"  value="" size="8px" class="siHideText"></g>
   시/군/구<input class="si" type="text" value="" size="5px">&nbsp;&nbsp;비율<input class="bi" type="text" value="" size="4px"><br>	
    	부족
    <c:choose>
				<c:when test = "${'충원률' eq sessionScope.graphs}">
           			 <img src="${pageContext.request.contextPath}/resources/img/충원률.jpg" width="200" height="30">
            	</c:when>
            	<c:when test = "${'재산세' eq sessionScope.graphs}">
          			   <img src="${pageContext.request.contextPath}/resources/img/재산세.jpg" width="200" height="30">
            	</c:when>
            	<c:otherwise>
            	       <img src="${pageContext.request.contextPath}/resources/img/영유아.jpg" width="200" height="30">
            	</c:otherwise>
    </c:choose>
   
    충족</p>
    	
    
   			</td>
   			<td>
   				<ul>
   					<li><p align="center">분석그래프</p><div id="Graphs_div"></div>
   					</li>
   					<br><br>
   					
   					<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
   					<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
   					<li><p align="center">워드클라우드</p><div id="Graphs_div"><div id="wc_div"></div></li>
   				</ul>
   			</td>
   			</tr>
   			
<!--    			</td> -->
	
<!--    		</tr> -->
   </table>
</div>
	<script>
// 	window.addEventListener("load", findSVGElements, false);
	var city;
	var graphs;
	var local = [];
	var test = [];
	var map
	
	
	$(window).load(function() {
		
		
		if($(".hide").val() == "전국"){
			$(".citySel").hide();
			}else{
				$(".citySel").show();
			}
			
			$('#selBtn').click(function() {
				if($(".hide").val() == "전국"){
					city ="전국"
				}else{
					city = $('#citySel option:selected').val();
				}
				source = {"city":city,"graphs":graphs};
				
				$.ajax({
					url : "http://localhost:8080/app/two/setSession",
					method : "post",
					dateType : "json",
					data : source,
					success : function(data) {
						var url = "http://localhost:8080/app/two?city=" + city;
						window.location = url;
					},
					error : function(err) {
						console.log(err);
					}

				});
				
//	 				FillMap(city)
			})
			function setSession(source) {
				
				
			}
			$("input[name=sele]").click(function(){
				if($(this).val()=="전국"){
					$(".citySel").hide();
					$(".siHide").show();
					$(".hide").val("전국") ;
					
				}else{
					$(".citySel").show();
					$(".siHide").hide();
					$(".hide").val($('#citySel option:selected').val());
				}
			})
			
			$("input[name=graphs]").click(function(){
				if($(this).val()=='충원률'){
					$(".hideGra").val("충원률")
					graphs = $(".hideGra").val();
					
				}else if($(this).val()=="재산세"){
					$(".hideGra").val("재산세")
					graphs = $(".hideGra").val();
				}else{
					$(".hideGra").val("영유아")
					graphs = $(".hideGra").val();
				}
			})
			
						$.ajax({
							url : "http://localhost:8080/app/two/fillMap",
							method : "post",
							success : function(data) {
								
								if(data.graphs == "충원률"){
									var colorArray = ["#937800","#B79C00","#EDD200","#FFF612","#FFFF36","#FFFF6C","#FFFFC6"]
								$.each(data.list, function(key, val) {
									local[key] = val.localnum
									console.log(val.city)
									findSVGElements(val.localnum, val.childfull, colorArray,val.district,val.city);
								})
								}else if(data.graphs == "재산세"){
									var colorArray = ["#005D00","#009300","#0BC904","#41FF3A","#77FF70","#ADFFA6","#D1FFCA"]		
									$.each(data.list, function(key, val) {
										local[key] = val.localnum
										findSVGElements(val.localnum, val.tax_p, colorArray,val.district,val.city);
									})
								}else{
									var colorArray = ["#007EA5","#00A2C9","#00C6ED","#12EAFF","#6CFFFF","#90FFFF","#C6FFFF"]
									$.each(data.list, function(key, val) {
										local[key] = val.localnum
										findSVGElements(val.localnum, val.four_p, colorArray,val.district,val.city);
									})
								}
								
								wordCloud();
								Graphs();
							},
							error : function(err) {
								console.log(err);
							}

						});
			
						
			
						function wordCloud(){
							$.ajax({
				                url: "http://localhost:8080/app/two/getWC",
				                type:"post",
				                success: function(data){
				                   var img =  $('<img id="wc" width="600" height="350"/>');
				                   var s = data.img;
				                   img.attr('src','data:image/png;base64,'+s);
				                   img.appendTo("#wc_div");
				                   
				                    
				                },
				                error: function(xhr, message, errorThrown){
				                    var msg = xhr.status + " / " + message + " / " + errorThrown;
				                    alert("실패") 
				                }
				            });
						}
						function Graphs(){
							$.ajax({
				                url: "http://localhost:8080/app/two/getGraphs",
				                type:"post",
				                success: function(data){
				                   var img =  $('<img id="wc" width="600" height="600"/>');
				                   var s = data.img;
				                   img.attr('src','data:image/png;base64,'+s);
				                   img.appendTo("#Graphs_div");
				                   
				                    
				                },
				                error: function(xhr, message, errorThrown){
				                    var msg = xhr.status + " / " + message + " / " + errorThrown;
				                    console.log(err);
				                }
				            });
						}
						
						
							

						// 	fetches the document for the given embedding_element
						function getSubDocument(embedding_element) {
							if (embedding_element.contentDocument) {
								return embedding_element.contentDocument;
							} else {
								var subdoc = null;
								try {
									subdoc = embedding_element.getSVGDocument();
									console.log(subdoc)
								} catch (e) {
								}
								return subdoc;
							}
						}
						
						function findSVGElements(localnum, childfull, colorArray, district, city) {
							var color;
							var elms = document.querySelectorAll("#a");
							console.log(elms.length)
							for (var i = 0; i < elms.length; i++) {
								var subdoc = getSubDocument(elms[i])
								if (subdoc) {
									// 				subdoc.getElementById("21010").setAttribute("fill", "lime");
//	 								console.log(subdoc.getElementById(localnum))
									if(childfull>=85){
										color = colorArray[0]
									}else if(childfull>=80){
										color = colorArray[1]
									}else if(childfull>=75){
										color = colorArray[2]
									}else if(childfull>=70){
										color = colorArray[3]
									}else if(childfull>=65){
										color = colorArray[4]
									}else if(childfull>=60){
										color = colorArray[5]
									}else{
										color = colorArray[6]
									}
									
									subdoc.getElementById(localnum).setAttribute(
											"fill", color);
									subdoc.getElementById(localnum).addEventListener("mouseover",function(){
										$(".siHideText").val(city);
										$(".si").val(district);
										$(".bi").val(childfull+"%");
									})
									
									
									
								}
								
							}
							
							
						}

	
	
			
		});
	</script>

</body>
</html>