<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script
	src="${pageContext.request.contextPath}/resources/js/d3.v3.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/topojson.v1.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/d3-scale-chromatic.v1.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/code2density.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/code2title.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/palette-linear_kryw_0_100_c71.js"></script>
<style>
@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);

text, div, h1, h3, span {
	font-family: 'Nanum Gothic', sans-serif;
	font-size: 13px;
}

body {
	background-color: #fff;
}

.background {
	fill: #fff;
}

.province {
	fill: #eee;
	stroke: #555;
	stroke-width: 1;
	fill-opacity: 0.1;
	stroke-opacity: 0.5;
	cursor: pointer;
}

.precinct {
	stroke: #555;
	stroke-width: 0.5;
	opacity: 0.7;
}

.province-label {
	font-size: 10px;
	text-anchor: middle;
	fill: #333;
}

.precinct-label {
	font-size: 3px;
	text-anchor: middle;
	visibility: hidden;
}

.g_precincts {
	pointer-events: all;
}

.province.highlighted {
	fill-opacity: 0.01;
	stroke-opacity: 0.9;
}

.precinct.highlighted {
	opacity: 0.8;
}

.province.notselected {
	fill-opacity: 0.5;
}

.province.selected {
	fill: none;
	stroke: #555;
	stroke-opacity: 1.0;
	opacity: 1.0;
}

.precinct.selected {
	stroke: #555;
	stroke-opacity: 1.0;
	opacity: 0.7;
}

#info {
	position: absolute;
	top: 0;
	left: 0;
	padding: 5px;
	width: 160px;
	height: 35px;
	background-color: #333;
	color: white;
	visibility: hidden;
}

#info h3 {
	margin: 0 0 8px 0;
	padding: 0 0 1px 0;
	font-size: 14px;
	border-bottom: 1px solid #eee;
}

#info div {
	float: left;
}

img {
	height: 65px;
	margin: 0 5px 0 0;
	float: left;
}

path:hover {
  transform: scale(1.2);
}
</style>



</head>
<body>


<%-- <iframe id="a"src="${pageContext.request.contextPath}/resources/data/busan.svg" width="800" height="800" scrolling="no" --%>
<!--     marginheight="0" marginwidth="0" frameborder=0></iframe>  -->
     
<%--     <object id ="a" type="image/svg+xml" data="${pageContext.request.contextPath}/resources/data/busan.svg">현재 브라우저는 iframe을 지원하지 않습니다.</object> --%>
<!-- 	<div id="info"></div> -->

<!-- 	<svg></svg> -->
	<script>

	
	
// 	window.addEventListener("load", findSVGElements, false);
	
// 	// fetches the document for the given embedding_element
// 	function getSubDocument(embedding_element)
// 	{
// 		if (embedding_element.contentDocument) 
// 		{
// 			return embedding_element.contentDocument;
// 		} 
// 		else 
// 		{
// 			var subdoc = null;
// 			try {
// 				subdoc = embedding_element.getSVGDocument();
// 			} catch(e) {}
// 			return subdoc;
// 		}
// 	}
			
// 	function findSVGElements()
// 	{
// 		var elms = document.querySelectorAll("#a");
// 		for (var i = 0; i < elms.length; i++)
// 		{
// 			var subdoc = getSubDocument(elms[i])
// 			if (subdoc)2
// 				subdoc.getElementById("26140").setAttribute("fill", "lime");
// 		}
// 	}  
	     
var width = window.innerWidth*0.98, height = window.innerHeight*0.97;

//https://github.com/bokeh/colorcet
//fire
//17.785343, 26065.406407
// var colorScale = d3.scale.quantize().domain([2.87837469, 10.168364]).range(linear_kryw_0_100_c71);
var colorScale = d3.scaleThreshold().domain([16, 70, 316, 1412, 6309, 28183]).range(["#f2f0f7", "#dadaeb", "#bcbddc", "#9e9ac8", "#756bb1", "#54278f"]);

var proj = d3.geoMercator()
 .center([128.0, 35.9])
 .scale(6000)
 .translate([width/2, height/2]);

var path = d3.geoPath()
 .projection(proj);

var svg = d3.select("svg")
 .attr("width",  width)
 .attr("height", height);

var x = d3.scaleLog().domain([15, 30000]).rangeRound([width*0.7, width*0.85]);

var g = svg.append("g");

var gm = g.append("g");
// var gt = g.append("g");

// gt.selectAll("rect")
// .data(colorScale.range().map(function(d) {
//    d = colorScale.invertExtent(d);
//    if (d[0] == null) d[0] = x.domain()[0];
//    if (d[1] == null) d[1] = x.domain()[1];
//    return d;
//  }))
// .enter().append("rect")
//  .attr("height", 10)
//  .attr("x", function(d) { return x(d[0]); })
//  .attr("y", function(d) { return 0; })
//  .attr("width", function(d) { return (Math.log(d[1]) - Math.log(d[0]))*40; })
//  .attr("fill", function(d) { return colorScale(d[0]); });

// gt.append("text")
//  .attr("class", "caption")
//  .attr("x", x.range()[0])
//  .attr("y", -10)
//  .attr("fill", "#000")
//  .attr("text-anchor", "start")
//  .attr("font-weight", "bold")
//  .text("Population density (log scale, in/m²)");

// gt.call(d3.axisBottom(x)
//  .tickSize(13)
//  .tickFormat(d3.format("2.2"))
//  .tickValues(x.domain()))
// .select(".domain")
//  .remove();

// gt.attr("transform", "translate(0,500)");

d3.queue()
//  .defer(d3.json, "${pageContext.request.contextPath}/resources/data/data.json")
.defer(d3.json, "${pageContext.request.contextPath}/resources/data/seoul2.json")
 .await(ready);

function ready(error, kor) {
if (error) throw error;

var precincts = topojson.feature(kor, kor.objects.seoul);
// var precincts = topojson.feature(kor, kor.objects["TL_SCCO_SIG_crs84-m2s"]);
// var precincts = topojson.feature(kor, kor.objects["Tskorea-municipalities-geo"]);
console.log(precincts)

var g_precincts = gm.select('g')
// 	.data(precincts.features, function(d) {return 	d.properties.SIG_CD; })
.data(precincts.geometries, precincts.geometries.coordinates; )
// 	.enter() 
// 	.append('g')
// 	.attr('class', 'g_precinct'); 
console.log(g_precincts)

g_precincts
	.append('path')
	.attr('d', path)
	.attr('class', 'precinct')
	.append("title")
// 	.text(function(d) { if(d.properties.SIG_CD=='42150'){var s = d.properties.SIG_CD;}return code2title[s]; });
	.text(function(d) { return code2title[d.properties.SIG_CD]; });

// console.log(g_precincts)

g_precincts.select("path.precinct")
	.style("fill", function(d) { 
		if(d.properties.SIG_CD){var s = d.properties.SIG_CD;}
   return colorScale(code2density[s]);
	
   //return colorScale(Math.log(code2density[d.properties.SIG_CD]));
 });
}


</script>
</body>
</html>