<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %> <!-- 기본 기능  -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %> <!-- 포맷  -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"  %> <!-- 함수 기능  -->
<!DOCTYPE html>
<html>
<head>
	
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>간단한 지도 표시하기</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=XsuGaqmxx6Ksoma69peg&submodules=geocoder"></script>
    <link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/style.css"/>

    <title>Scrolling Nav - Start Bootstrap Template</title>

    <!-- Bootstrap core CSS -->
    <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template -->
    <link href="${pageContext.request.contextPath}/resources/css/scrolling-nav.css" rel="stylesheet" type="text/css">
</head>
<body id="page-top"> 
 <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">Start Bootstrap</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#about">About</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#services">Services</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#contact">Contact</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

       <header class="bg-primary text-white">
      <div class="container text-center">
        <h1>지역별 사각지대 검출 서비스</h1>
        <p2 class="lead">by 어린이집</p2>
      </div>
    </header>

	<section id="about">
		<div class="container">
			<div class="row">
				<div class="col-lg-15 mx-auto">
					<ul>
						<p align="center">
							시/도 <select class="citySel" id="citySel">
								<option value="">전체</option>
								<c:forEach var="city" items="${citylist}">
									<option value="${city.city}">${city.city}</option>
								</c:forEach>
							</select> 시/군/구 <select class="districtSel" id='districtSel'>
								<option value="">전체</option>
							</select> <input type="button" value="검색" id='selBtn'> <input
								type="button" value="분석" id='Btn'>
						</p>

						<table border='1px' align="center">
							<tr>
								<td rowspan="2">
									<div id="map" style="width: 50%; height: 400px;"></div>
								</td>
								<td valign="top">
									<table id="th" class="table-striped">
										<tr>
											<th colspan="3" align="right">총 검색 결과 : 0건</th>
										</tr>
										<tr>
											<th width="200px">어린이집<a href="javascript:;">▼</a></th>
											<th width="60px">유형<a href="javascript:;">▼</a></th>
											<th width="60px">정원수</th>
										</tr>
									</table>
								</td>
							</tr>
							<tr height="35px" align="center">
								<td id="page"></td>
							</tr>
						</table>

						<script>



// 지도 표시
var HOME_PATH = window.HOME_PATH || '.';
//var position = new naver.maps.LatLng(37.3595704, 127.105399);
var mapOptions = {
    center: new naver.maps.LatLng(37.3595316, 127.1052133),
    zoom: 10
};

var map = new naver.maps.Map('map', mapOptions);

var size = new naver.maps.Size(512, 384),
sizeObject = {
    width: 600,
    height:600
};

map.setSize(sizeObject); 

var trC;

		
$(document).ready(function() {
	var cn; 	
	var cm = 0;
	var infowindow; 
	var range;
	var value;
	
	// 도 /시 선택시 시/군/구 내용 표시 
		$('.citySel').on('change',function(){
			
			var value = this.value;
			
		   
			$.ajax({
				url : "http://localhost:8080/app/city",
				method : "get",
				dataType:'json',
				success : function(data) {
				
					var districtout = '<select class="districtSel" id="districtSel"><option value="">전체</option>';		
					$.each(data.districtlist, function(key,val){
						
						if(value==val.city){
						districtout += '<option value="'+val.district+'">'+val.district+'</option>';
						}
					})
					
					
					districtout += '</select>';
					var select = document.getElementById('districtSel');
					select.innerHTML = districtout;
					
				},
				error : function(err) {
					console.log(err);
				}
				
				
			});
		});
		
		var marker = new naver.maps.Marker(null)
		$(document).on("click",".marker",function(){
			childcare_name = $(this).find(".childcare_name").val();
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			var lat = $(this).find(".lat").val();
			
			var markerOptions = {
					 
					position: null,
						map: map,
					icon: {
						   url: '<%=request.getContextPath()%>/resources/img/',
						   size: new naver.maps.Size(50, 52), 
					   origin: new naver.maps.Point(0, 0),
						   anchor: new naver.maps.Point(25, 26)
					  	}
					};
			 
					
					if(marker.getMap()){
						marker.setMap(null);
						 	
						cm = 0;
						if(cn!=null){
							document.getElementById(cn).style.fontSize = "16px";
							document.getElementById(cn).style.fontWeight = "normal";
				        infowindow.close();
						}
					}
			
					marker = new naver.maps.Marker(markerOptions);
			
			markerSet(childcare_name, city, district, marker, lat);
			
		})
		
		
		function markerSet(childcare_name, city, district, marker, lat){
			
			
			var source={"city": city, "district":district, "childcare_name":childcare_name,"lat":lat};
			
			$.ajax({ 
				  type:"post", 
			        url:"http://localhost:8080/app/marker", 
			        dataType:'json',
			        data:source,
		        success : function(data) {
					 
		        	
		        	var positiones = new naver.maps.LatLng(data.lat, data.lon);	
					
					
					
					map.setCenter(positiones); 
					
					marker.setPosition(positiones)
					
					//마커 클릭시 어린이집 명 표시하기
					var contentString = [
				        '<div class="iw_inner">', 
				        '   <h3>'+data.childcare_name+'</h3>',
				        '</div>'
				    ].join('');
					infowindow = new naver.maps.InfoWindow({
					    content: contentString
					});

					infow(infowindow, data.childcare_name);
					
		        }, 
			       error : function(err) {
						console.log(err);
						alert("에러");
					} 
			    });
		}
		
		function infow(infowindow, childcare_name){
			naver.maps.Event.addListener(marker, "click", function(e) {
			    if (infowindow.getMap()) {
			    	selectedOut(childcare_name);
			        infowindow.close();
			        cm = 0;
			    } else {
			        infowindow.open(map, marker);
			        selected(childcare_name);
			        cm = 1;
			    }
			});
		}
		
		
		$('#selBtn').click(function(){
			var address = '';
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			address +=city+district;
			
			geoCode(address); 
			range = "asc";
			value = "childcare_name"
			
			
			search(city, district,0,range,value);
		})
	
		function geoCode(address){
			naver.maps.Service.geocode({
				address: address
			},function(status, response) {
		        if (status === naver.maps.Service.Status.ERROR) {
		            address = $('#districtSel option:selected').val();
		            geoCode(address);
		        }

		        var item = response.result.items[0],
		            point = new naver.maps.Point(item.point.x, item.point.y);
		        map.setCenter(point);
			});
		}
		$(document).on("click",".paging",function(){
			
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			
			page = $(this).find(".text").val();
			
			search(city,district,page, range, value);
		})
		function pageging(pageData){
			
			
			
			
			
    		var page = '<td id ="page">';
    		
    		
    		if(pageData.curPage > 1){
    			page += '<a href=\"javascript:;';
    			page += '\" class="paging">';
    			
    			page += '<input type="text" class="text" value="1" hidden="true">[처음]</a>';
    			

    		}

    		
    		if(pageData.curPage > 1){
    			page += '<a href=\"javascript:;';
    			page += '\" class="paging">';
    			page += '<input type="text" class="text" value="'+pageData.prevPage+'" hidden="true">[이전]</a>';
    			

    		}
    	
    		for(var i=pageData.blockBegin ; i<=pageData.blockEnd ; i++ ){
    			if(i == pageData.curPage){
    				page += '<span style="color: red">'+i+'</span>&nbsp;'
    			}else{
    				
    				page += '<a href=\"javascript:;';
        			page += '\" class="paging" >';
        			page += '<input type="text" class="text" value="'+i+'" hidden="true" target="">'+i+'</a>&nbsp;';
        			
    			}
    		}
    		
    		
    		if(pageData.curBlock <= pageData.totalBlock){
    			page += '<a href=\"javascript:;';
    			page += '\" class="paging" >'; 
    			page += '<input type="text" class="text" value="'+pageData.nextPage+'" hidden="true">[다음]</a>';
    		}
    		if(pageData.curPage <= pageData.totalPage){
    			page += '<a href=\"javascript:;';
    			page += '\" class="paging" >';
    			page += '<input type="text" class="text" value="'+pageData.totalPage+'" hidden="true">[끝]</a>';
    	
    		}
    		page += '</td>';
    		var tab = document.getElementById('page');
 			
    		
    		tab.innerHTML = page;
		}
		$(document).on("click",".childcare",function(){
			
			
			if(range == "asc"){
				 range = "desc";
			}else{
				 range = "asc";
				
			}
			value = "childcare_name";
			
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			
			page = 1;
			
			search(city,district,page, range, value);
			
			
		})
		$(document).on("click",".service_type",function(){
			
			
			if(range == "asc"){
				 range = "desc";
			}else{
				 range = "asc";
				
			}
			value = "service_type";
			
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			
			page = 1;
			
			search(city,district,page, range, value);
			
			
		})
		
		function search(city, district,page, range, value){
			
			var curPage = page;
			
			var source={"city": city, "district":district, "curpage":curPage, "range":range,"value":value};
			
			
			$.ajax({ 
		        type:"post", 
		        url:"http://localhost:8080/app/search", 
		        dataType:'json',
		        data:source, 
		        success : function(data) {
		        	if(range == "desc" && value=="childcare_name"){
		        		var tableCount = '<table id="th" class="table-striped"><tr><th colspan="3" align="right">총 검색 결과 : '+data.count+'건</th></tr><tr><th width="200px">어린이집<a href="javascript:;" class="childcare">▲</a></th><th width="60px">유형<a href="javascript:;" class="service_type">▼</a></th><th width="60px">정원수</th></tr>';
		        	}else if(range =="desc" && value=="service_type"){
		        		var tableCount = '<table id="th" class="table-striped"><tr><th colspan="3" align="right">총 검색 결과 : '+data.count+'건</th></tr><tr><th width="200px">어린이집<a href="javascript:;" class="childcare">▼</a></th><th width="60px">유형<a href="javascript:;" class="service_type">▲</a></th><th width="60px">정원수</th></tr>';
		        	}else{
		        		var tableCount = '<table id="th" class="table-striped"><tr><th colspan="3" align="right">총 검색 결과 : '+data.count+'건</th></tr><tr><th width="200px">어린이집<a href="javascript:;" class="childcare">▼</a></th><th width="60px">유형<a href="javascript:;" class="service_type">▼</a></th><th width="60px">정원수</th></tr>';
		        	
			        		
		        	}
					var table = '';
		     		$.each(data.list,function(key,val){
		     			 table += '<tr id="'+val.childcare_name+'">';
		     			 table += '<td align="left"><a href="javascript:;" class="marker"><input type="text" class="childcare_name" value="'+val.childcare_name+'" hidden="true"><input type="text" class="lat" value="'+val.lat+'" hidden="true"><input type="text" class="lon" value="'+val.lon+'" hidden="true">'+val.childcare_name +'</a></td>';
		     			 table += '<td align="left" >'+val.service_type +'</td>';
		     			 table += '<td align="right" >'+val.a_limit +'</td>';
		     			 table += '</tr>'
		     			 
		     			
		     			
		     		})	
		     			var pageData={"curPage":data.sp.curPage,"prevPage": data.sp.prevPage, "nextPage":data.sp.nextPage, 
		     			"totalPage":data.sp.totalPage, "totalBlock":data.sp.totalBlock, 
		     			"curBlock":data.sp.curBlock, "prevBlock":data.sp.prevBlock, 
		     			"nextBlock":data.sp.nextBlock, "pageBegin":data.sp.pageBegin, 
		     			"pageEnd":data.sp.pageEnd, "blockBegin":data.sp.blockBegin, "blockEnd":data.sp.blockEnd,"firstPage":data.sp.firstPage};  
						
		     			
		     			pageging(pageData);
		     			
		     			tableCount+=table+'</table>';
		     			
		     			var tab = document.getElementById('th');
		     			tab.innerHTML = tableCount;
		     			marker_selected();
	                  
		       }, 
		       error : function(err) {
					console.log(err);
					alert("에러");
				} 
		    });


		}
		function marker_selected(){
			if(cm==1){
				selected(cn);
			}else{
				selectedOut(cn);
			}
		}
		
		function selected(childcare_name){
			var ch = childcare_name;	
			var x = document.getElementsByTagName('tr');
			
			for(var i = 0 ; i<x.length;i++){  
				
// 				x[i].style.style.fontSize = "16px";
// 				x[i].style.fontWeight = "normal";
			}
			cn = ch; 
			
			if(document.getElementById(ch)!= null){ 
				
				document.getElementById(ch).style.fontSize = "18px";
				document.getElementById(ch).style.fontWeight = "bold";
				cm = 1; 
				
			}
			   
		} 
		
		function selectedOut(childcare_name){
			var ch = childcare_name;
			cn = null;
			
			
			if(document.getElementById(ch)!= null ){
				
				document.getElementById(ch).style.fontSize = "16px";
				document.getElementById(ch).style.fontWeight = "normal";
			cm = 0;
			} 
		}
		
		$('#Btn').click(function(){
						
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			
			if(!$('#districtSel option:selected').val()==""){
				
				var url ="http://localhost:8080/app/two?city="+city+"&district="+district;
				window.open(url);
			
			}
			//
			})	
			
			
		
		
	
	});


</script>
</body>
