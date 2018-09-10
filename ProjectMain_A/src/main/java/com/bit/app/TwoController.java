package com.bit.app;

import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.bit.app.service.SearchPage;
import com.bit.app.service.TwoServiceImpl;
import com.bit.app.vo.ChildVO;
import com.bit.app.vo.GraphsVO;
import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.TableVO;
import com.bit.app.vo.TestVO;
import com.bit.app.vo.WordCloudVO;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;
import com.bit.app.vo.PolyGonVO;
import com.bit.app.vo.ServiceVO;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping(value = "/two", method = RequestMethod.GET)
public class TwoController {
	
	@Inject
	TwoServiceImpl TwoService;

//	@ResponseBody
//	   @RequestMapping(value = "/line_Graphs", method = RequestMethod.GET)
//	   public List<LineGraphsVO> line_Graphs( Model model, @ModelAttribute LineGraphsVO vo, HttpSession session) {
//
//	      
//	    
//	      String city = (String)session.getAttribute("city");
//	      String district = (String)session.getAttribute("district");
//	      
//	      if(city.equals("제주특별자치도")){
//	         city = "제주도";
//	      }
//	      
//	      System.out.println(city+", 실험중 "+ district);
//	      vo.setCity(city);
//	      vo.setDistrict(district);
//
//	      List<LineGraphsVO> list =  TwoService.getLineGraph(vo);      
//	      
//	      for(LineGraphsVO a : list){
//	    	  System.out.println(a.getBirth_15());
//	    	  System.out.println(a.getBirth_16());
//	    	  System.out.println(a.getBirth_17());
//	      }
//	      
//	      return list;
//	   }

	
//	@ResponseBody
//	   @RequestMapping(value = "/graphs", method = RequestMethod.GET)
//	   public List<ServiceVO> search( Model model, @ModelAttribute ServiceVO vo, HttpSession session) {
//
//	      
//	    
//	      String city = (String)session.getAttribute("city");
//	      String district = (String)session.getAttribute("district");
//	      
//	      if(city.equals("제주특별자치도")){
//	         city = "제주도";
//	      }
//	      
//	      System.out.println(city+", 실험중 "+ district);
//	      vo.setCity(city);
//	      vo.setDistrict(district);
//
//	      List<ServiceVO> list =  TwoService.getGraph(vo);      
//	      
//	      
//	      return list;
//	   }
	
//	@ResponseBody
//	@RequestMapping(value = "/polygon", method = RequestMethod.POST)
//	public JSON polygon(Locale locale, Model model, @ModelAttribute PolyGonVO vo, HttpSession session) {
//		
//		
//		List<PolyGonVO> list = TwoService.selectList(vo);
//		
//		JSONObject jobj = new JSONObject();
//		
//		Map<String, String> map = new HashMap();
//		int i=0;
//		int j=0;
//		for(PolyGonVO li : list){
//			
//			List<PolyGonVO> PolyGon = TwoService.selectPolygon(li.getDistrict());
//			 
//			
//			jobj.put("PolyGon"+j, PolyGon);
//		
//			j++;
//			
//		}
//		System.out.println(jobj);
//		return jobj;
//		
//	}
	@ResponseBody
	@RequestMapping(value="/getGraphs", method= RequestMethod.POST)
	public JSON getGraphs(Locale locale, @ModelAttribute GraphsVO vo, Model model, HttpSession session) {
		String city = (String) session.getAttribute("city");
//		System.out.println("getWC에 온 city"+ vo.getCity());
		
	
		GraphsVO wvo = TwoService.getGp(city);
	    
//	    System.out.println("돌아온 객체: "+wvo.getCity());
	    
//	    if(wvo.getWc()!=null) {
//	    	System.out.println("돌아온 객체: "+wvo.getWc().toString());
//	    }
	    
	    byte[] imageContent = wvo.getGp();
	    String s = Base64.encode(imageContent);
	    JSONObject a = new JSONObject();
	    
	    a.put("img", s);
//	    final HttpHeaders headers = new HttpHeaders();
//	    headers.setContentType(MediaType.IMAGE_PNG);
//	    return new ResponseEntity<byte[]>(imageContent, headers, HttpStatus.OK);
	    return a;
	     
	}	
	
	
	@ResponseBody
	@RequestMapping(value="/getWC", method= RequestMethod.POST)
	public JSON getWC(Locale locale, @ModelAttribute WordCloudVO vo, Model model, HttpSession session) {
		
		String city = (String) session.getAttribute("city");
//		System.out.println("getWC에 온 city"+ vo.getCity());
		
	
	    WordCloudVO wvo = TwoService.getWC(city);
	    
//	    System.out.println("돌아온 객체: "+wvo.getCity());
	    
//	    if(wvo.getWc()!=null) {
//	    	System.out.println("돌아온 객체: "+wvo.getWc().toString());
//	    }
	    
	    byte[] imageContent = wvo.getWc();
	    String s = Base64.encode(imageContent);
	    JSONObject a = new JSONObject();
	    
	    a.put("img", s);
//	    final HttpHeaders headers = new HttpHeaders();
//	    headers.setContentType(MediaType.IMAGE_PNG);
//	    return new ResponseEntity<byte[]>(imageContent, headers, HttpStatus.OK);
	    return a;
	     
	}		
	@ResponseBody
	@RequestMapping(value = "/setSession", method = RequestMethod.POST)
	public Map<String, String> setSession(Locale locale, Model model, @ModelAttribute ChildVO vo, HttpSession session) {
		System.out.println(vo.getCity());
		session.setAttribute("city", vo.getCity());
		session.setAttribute("graphs", vo.getGraphs());
		System.out.println(session.getAttribute("city"));
		
		Map<String, String> map = new HashMap();
		map.put("city", (String)session.getAttribute("city"));
		map.put("graphs", (String)session.getAttribute("graphs"));
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/fillMap", method = RequestMethod.POST)
	public JSON fillMap(Locale locale, Model model, @ModelAttribute ChildVO vo, HttpSession session) {
		System.out.println((String)session.getAttribute("graphs"));
		vo.setCity((String)session.getAttribute("city"));
		vo.setGraphs((String)session.getAttribute("graphs"));
		session.setAttribute("city", vo.getCity());
		session.setAttribute("graphs", vo.getGraphs());
		List<ChildVO> list = TwoService.childSelect(vo);
		JSONObject jobj = new JSONObject();
		jobj.put("list", list);
		jobj.put("graphs", vo.getGraphs());
		return jobj;
		
	}
	
	
		/**
	 * Simply selects the home view to render by returning its name.
	 */


	
	
	@RequestMapping(method = RequestMethod.GET)
	public String two(@RequestParam(value="city", required=false) String city,HttpServletResponse response, HttpServletRequest request, Model model, @ModelAttribute HomeVO vo ) {

		HttpSession session = request.getSession();
		session.setAttribute("city", city);
		if(session.getAttribute("graphs")==null){
		String graphs = "충원률";
		
		session.setAttribute("graphs", graphs);
		}
		List<HomeVO> cityList =  TwoService.selectCity(); 
		model.addAttribute("citylist",cityList);
		
		
		return "two";
	}
	
}
