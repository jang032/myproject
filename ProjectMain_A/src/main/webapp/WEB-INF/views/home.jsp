<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %> <!-- 기본 기능  -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %> <!-- 포맷  -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"  %> <!-- 함수 기능  -->

<!DOCTYPE html>

<html lang="en">
<style>
	table {
		font-family: 'Jeju Gothic', sans-serif;
	}
	
	.citySel {
		font-family: 'Jeju Gothic', sans-serif;
	}
	
	.districtSel{
		font-family: 'Jeju Gothic', sans-serif;
	}
	a {
		font-family: 'Jeju Gothic', sans-serif;
	}
	
	div{
		font-family: 'Jeju Gothic', sans-serif;
	}
</style>
  <head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=XsuGaqmxx6Ksoma69peg&submodules=geocoder"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js"></script>
	<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/style.css"/>
	
    <title>Scrolling Nav - Start Bootstrap Template</title>

    <!-- Bootstrap core CSS -->
    <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template -->
    <link href="${pageContext.request.contextPath}/resources/css/scrolling-nav.css" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet">
  </head>

  <body id="page-top">

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">지역별 사각지대 서비스</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#Service">Service</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#chart">chart</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#chart2">linechart</a>
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

    <section id="Service">
      <div class="container-fluid ">
        <div class="row">
			<div class="col-auto mx-auto">
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
									<div id="map" style="width: 60%; height: 400px;"></div>
								</td>
								<td valign="top" >
									<table id="th" class="table-striped">
										<tr>
										
											<th colspan="5" align="right">총 검색 결과 : 0건</th>
										</tr>
										<tr>
											<th width="200px">어린이집<a href="javascript:;">▼</a></th>
											<th width="100px">시군구</th>
											<th width="150px">유형<a href="javascript:;">▼</a></th>
											<th width="80px">정원수</th>
											<th width="60px">현원</th>
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
    zoom: 8
};

var map = new naver.maps.Map('map', mapOptions);

var size = new naver.maps.Size(512, 384),
sizeObject = {
    width: 600,
    height:600
};

map.setSize(sizeObject); 

var trC;

var ctx;
var myChart1
var ctx2;
var myChart2
		
$(document).ready(function() {
	var cn; 	
	var cm = 0;
	var infowindow; 
	var range;
	var value;
	var tmp;
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
		
		
		
		
		function markerSet(city, district){
			
			
			var source={"city": city, "district":district};
			
			$.ajax({ 
		        type:"post", 
		        url:"http://localhost:8080/app/searchMarker", 
		        dataType:'json',
		        data:source,
		        success : function(data) {
		        	
		        	
		        	var address = '';
					address +=city+district;
					
// 					graph1();
					
					var infowindow
		        	var markers =[];
					var infowindow2;
		        	$.each(data, function(key,val){
		        		var positiones = new naver.maps.LatLng(val.lat, val.lon);	
		        		var markerOptions = {
		        				
		        				position: positiones,
		      					map: map,
		        				icon: {
		        				   url: '<%=request.getContextPath()%>/resources/img/',
		         				   size: new naver.maps.Size(50, 52),
		        				   origin: new naver.maps.Point(0, 0),
		          				   anchor: new naver.maps.Point(25, 26)
		      				  	}
		    					};
		    				
		    					var marker = new naver.maps.Marker(markerOptions);
		    					markers.push(marker);
		    					
		    					
		    					
		    					
		    					infowindow = new naver.maps.InfoWindow({
		    					    content: null
		    					});
	    						
		    					naver.maps.Event.addListener(marker, "click", function(e) {
		    						//마커 클릭시 어린이집 명 표시하기
			    					
// 		    						if (infowindow.getMap()) {
// 				    					selectedOut(val.childcare_name);
// 				     					infowindow.close();
// 				     					cm = 0;
// 				  					 } else {
// 				     					infowindow.open(map, marker);
// 				      					selected(val.childcare_name);
// 				      					cm = 1;
// 				 					}
		    						infow(infowindow, val.childcare_name, marker);
		    					});
		    					
		        	});
		        	

		        	
					
					//지도가 보이는 곳에 마커 표시
					
						
						naver.maps.Event.addListener(map, 'idle', function() {
	    					
							
    					    updateMarkers(map, markers);
    					    
    						
    						
    					});
					
						
						 
						 
						
					
						geoCode(address);	
					
					function updateMarkers(map, markers) {

					    var mapBounds = map.getBounds();
					    var marker, position;

					    for (var i = 0; i < markers.length; i++) {

					        marker = markers[i]
					        position = marker.getPosition();
							
												        
					        if (mapBounds.hasLatLng(position)) {
					        	if(map.getZoom()>4){
					            showMarker(map, marker);
					            
					            
					        	}else{
					        	selectedOut(cn); 
					        	hideMarker(map, marker);
					        	infowindow.close();
					        	}
					        	
					        } else {
					            hideMarker(map, marker);
					             
					        }
					    }
					
					}
					
					
				
					
					
					
					
					function showMarker(map, marker) {
						
					    if (marker.getMap()) return;
					    marker.setMap(map);
					    
					  
					}

					function hideMarker(map, marker) {

					    if (!marker.getMap()) return;
					    marker.setMap(null);
					  
					}
		        	
		        	
					
					
					search(city,district,0,range,value);
					
		        },
					
				error : function(err) {
					console.log(err);
				}
				
				
			});
		}
		
		
		
		function infow(infowindow, childcare_name, marker){
			
			    if (infowindow.getMap()) {
			    	selectedOut(childcare_name);
			        infowindow.close();
			        cm = 0;
			    } else {
			    	var contentString = [
				        '<div class="iw_inner">',
				        '   <h3>'+childcare_name+'</h3>',
				        '</div>'
				    ].join('');
			    	
			    	infowindow.setContent(contentString);
			        infowindow.open(map, marker);
			        selected(childcare_name);
			        cm = 1;
			    }
			
		}
		
		
		$('#selBtn').click(function(){
			var address = '';
			var city = $('#citySel option:selected').val();
			var district = $('#districtSel option:selected').val();
			address +=city+district;
			
			geoCode(address); 
			range = "asc";
			value = "childcare_name"
			
			markerSet(city, district);
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
		        	var tableCount = '<table id="th" table-striped><tr><th colspan="5" align="right">총 검색 결과 : '+data.count+'건</th></tr>';
		        	if(range == "desc" && value=="childcare_name"){
			        	tableCount += '<tr><th width="200px" table-striped>어린이집<a href="javascript:;" class="childcare">▲</a></th><th width="100px">시군구</th><th width="150px">유형<a href="javascript:;" class="service_type">▼</a></th><th width="80px">정원수</th><th width="60px">현원</th></tr>';
			        	}else if(range =="desc" && value =="service_type"){
			        	tableCount += '<tr><th width="200px" table-striped>어린이집<a href="javascript:;" class="childcare">▼</a></th><th width="100px">시군구</th><th width="150px">유형<a href="javascript:;" class="service_type">▲</a></th><th width="80px">정원수</th><th width="60px">현원</th></tr>';
			        	}else{
			        	tableCount += '<tr><th width="200px" table-striped>어린이집<a href="javascript:;" class="childcare">▼</a></th><th width="100px">시군구</th><th width="150px">유형<a href="javascript:;" class="service_type">▼</a></th><th width="80px">정원수</th><th width="60px">현원</th></tr>';
			        	}
					var table = '';
		     		$.each(data.list,function(key,val){
		     			table += '<tr id="'+val.childcare_name+'">';
		     			 table += '<td align="left">'+val.childcare_name +'</td>';
		     			 table += '<td align="left" >'+val.district+'</td>';
		     			 table += '<td align="right" >'+val.service_type+'</td>';
		     		  	 table += '<td align="right" >'+val.a_limit +'</td>';
		     		  	 table += '<td align="right" >'+val.a_status +'</td>'; 
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
		     			graph1(city, district);
		     			line_Graph(city, district);
	                  
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
			cm = 1; 
			cn = ch;
			for(var i = 0 ; i<x.length;i++){  
				if(x[i]!=document.getElementById(ch)){
					x[i].style.fontSize = "16px";
					x[i].style.fontWeight = "normal";
				}else{
					x[i].style.fontSize = "18px";
					x[i].style.fontWeight = "bold";
				}
			}
			 
			
			if(document.getElementById(ch)!= null){ 
				
				document.getElementById(ch).style.fontSize = "18px";
				document.getElementById(ch).style.fontWeight = "bold";
				
				
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
			
			if(!$('#citySel option:selected').val()==""){
				
				var url ="http://localhost:8080/app/two?city="+city;
				window.open(url);
			
			}
			//
			})	
			
			function line_Graph(city, district){
			   var linelables = ["14년도", "15년도", "16년도"];
			   var source={"city": city, "district":district};
			   
			   $.ajax({ 
	               url:"http://localhost:8080/app/line_Graphs", 
	               method: "get",
	               dataType:'json',
			       data:source, 
	               success : function(data) {
//		                 alert("읽음");
	                  
	                 
	                  $.each(data, function(key,val){
	                     
	                    
	                     var birth_15 = val.birth_15*1;
	                     var birth_16 = val.birth_16*1;
	                     var birth_17 = val.birth_17*1;
	                     linedata = [birth_15, birth_16, birth_17];
						 if(myChart2 == null){
	                     data = {
	    	                     
	     	                    labels: linelables,
	     	                     datasets: [{
	     	                             label: '년도별 출산율',
	     	           				     borderColor: "#8BBDFF",
	     	           					 fill: false,
	     	                             data: linedata
	       		         	             
	     	                      }] 
	     	                     }; 
	                    
	                     ctx2 = document.getElementById("myChart2").getContext('2d');
	                     myChart2 = new Chart.Line(ctx2, {
	                    	 data: data, 
	 						 options:  {}
	 						 
	                    	 
	                     
	                     });
						 }else{
							 myChart2.data.datasets[0].data = linedata;
						 }
						  myChart2.update()
	                  });
	                  
	               },
	           
	                  error : function(err) {
	                   console.log(err);
	               }
	          
	          });               
		   }
			
			
			function graph1(city, district){
			   
			var source={"city": city, "district":district};
	          $.ajax({ 
	               url:"http://localhost:8080/app/graphs", 
	               method: "get",
	               dataType:'json',
			       data:source, 
	               success : function(data) {
//	                 alert("읽음");
	                  
	                
	                  $.each(data, function(key,val){
	                     
	                     var general = val.general*1;
	                     var baby = val.baby*1;
	                     var dsd_pro = val.dsd_pro*1;
	                     var dsd_com = val.dsd_com*1;
	                     var after_pro = val.after_pro*1;
	                     var after_com = val.after_com*1;
	                     var time_extention = val.time_extension*1;
	                     var holiday = val.holiday*1;
	                     var time24 = val.time24*1;
	                     var data_and_time = val.data_and_time*1;
	                     
	                     var sum = general+baby+dsd_pro+dsd_com+after_pro+after_com+time_extention+holiday+time24+data_and_time;
//	                     alert("data and time"+data_and_time);
	                    
	                     
	                     general = val.general/sum;
	                     baby = val.baby/sum;
	                     dsd_pro = val.dsd_pro/sum;
	                     dsd_com = val.dsd_com/sum;
	                     after_pro = val.after_pro/sum;
	                     after_com = val.after_com/sum;
	                     time_extention = val.time_extension/sum;
	                     holiday = val.holiday/sum;
	                     time24 = val.time24/sum;
	                     data_and_time = val.data_and_time/sum;
//	                     alert("퍼센트값으로 나올 값"+data_and_time );
//	                     alert("다시 더하면?"+ sum);
	                     ctx = document.getElementById("myChart1").getContext('2d');
// 	                     myChart1.setData(null)
						 
						 datas = [baby, dsd_pro, dsd_com, after_pro+after_com, time_extention, holiday, time24];
						 if(myChart1 == null){
	                     myChart1 = new Chart(ctx, {
	                     type: 'pie',
	                     data: {
	                         labels: ["영아전담", "장애아전문", "장애아통합", "방과후통합", "시간연장형", "휴일보육", "24시간"],
	                         datasets: [{
	                             label: '# of Votes',
	                             data: datas,
	                             backgroundColor: [
	                                 'rgba(255, 150, 132, 0.2)',
	                                 'rgba(54, 162, 100, 0.2)',
	                                 'rgba(200, 200, 86, 0.2)',
	                                 'rgba(75, 192, 80, 0.2)',
	                                 'rgba(100, 102, 200, 0.2)',
	                                 'rgba(255, 70, 100, 0.2)',
	                                 'rgba(54, 162, 235, 0.2)',
	                                 'rgba(255, 206, 86, 0.2)',
	                                 'rgba(75, 192, 192, 0.2)'
	                             ],
	                             borderColor: [
	                                'rgba(255, 150, 132, 0.2)',
	                                 'rgba(54, 162, 100, 0.2)',
	                                 'rgba(200, 200, 86, 0.2)',
	                                 'rgba(75, 192, 80, 0.2)',
	                                 'rgba(100, 102, 200, 0.2)',
	                                 'rgba(255,99,132,1)',
	                                 'rgba(54, 162, 235, 1)',
	                                 'rgba(255, 206, 86, 1)',
	                                 'rgba(75, 192, 192, 1)'
	                             ],
	                             borderWidth: 1,
	                             
	                         }]
	                     },
	                     options: {
	                         scales: {
	                             yAxes: [{
	                                 ticks: {
	                                     beginAtZero:false
	                                 }
	                             }]
	                         }
	                     }
	                     
	                 });
	                 
	                  }else{
						myChart1.data.datasets[0].data = datas	 
	                  }
						 
						 myChart1.update()
	                  });
	               },
	           
	                  error : function(err) {
	                   console.log(err);
	               }
	          
	          });               
	    };
	
	});


</script>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <section id="chart" class="bg-light">
      <div class="container">
        <div class="row">
          <div class="col-lg-8 mx-auto">
            <canvas id="myChart1" style="width:600px;height:500px;"></canvas>
            </div>
        </div>
      </div>
    </section>

    <section id="chart2">
      <div class="container">
        <div class="row">
          <div class="col-lg-8 mx-auto">
          <canvas id="myChart2" style="width:600px;height:500px;"></canvas>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="py-5 bg-dark">
      <div class="container">
        <p class="m-0 text-center text-white">Copyright &copy; Your Website 2018</p>
      </div>
      <!-- /.container -->
    </footer>

    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom JavaScript for this theme -->
    <script src="js/scrolling-nav.js"></script>
  </body>

</html>
