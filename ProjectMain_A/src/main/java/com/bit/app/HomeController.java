package com.bit.app;

import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.bit.app.service.HomeServiceImpl;
import com.bit.app.service.SearchPage;
import com.bit.app.service.TwoServiceImpl;
import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.ServiceVO;
import com.bit.app.vo.TestVO;
import com.fasterxml.jackson.core.JsonParser;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Inject
	HomeServiceImpl HomeService;
	
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */

	
	
		@ResponseBody
	   @RequestMapping(value = "/line_Graphs", method = RequestMethod.GET)
	   public List<LineGraphsVO> line_Graphs( Model model, @ModelAttribute LineGraphsVO vo, HttpSession session) {

	      
	    
			String city = vo.getCity();
			String district = vo.getDistrict();
	      
	      if(city.equals("제주특별자치도")){
	         city = "제주도";
	      }
	      
	      System.out.println(city+", 실험중 "+ district);
	      vo.setCity(city);
	      vo.setDistrict(district);

	      List<LineGraphsVO> list =  HomeService.getLineGraph(vo);      
	      
	      for(LineGraphsVO a : list){
	    	  System.out.println(a.getBirth_15());
	    	  System.out.println(a.getBirth_16());
	    	  System.out.println(a.getBirth_17());
	      }
	      
	      return list;
	   }
	
	
	
	@ResponseBody
	@RequestMapping(value = "/graphs", method = RequestMethod.GET)
	public List<ServiceVO> search(Model model, @ModelAttribute ServiceVO vo, HttpSession session) {

		String city = vo.getCity();
		String district = vo.getDistrict();

		if (city.equals("제주특별자치도")) {
			city = "제주도";
		}

		System.out.println(city + ", 실험중 " + district);

		List<ServiceVO> list = HomeService.getGraph(vo);
//		for(ServiceVO a : list){
//			System.out.println(a.getTime_extension());
//		}
		return list;
	}
	
	@ResponseBody
	@RequestMapping(value = "/search", method = RequestMethod.POST)
	public JSON serach(Locale locale, Model model, @ModelAttribute TestVO vo, HttpSession session) {
		
		String range = vo.getRange();
		String value = vo.getValue();
		int count = HomeService.selectSearchCount(vo);
		
		
		int curPage = vo.getCurpage();
		 
	
		if(curPage==0) {
			curPage = 1;
		}
		
		
		SearchPage sp = new SearchPage(count,curPage);
		int start = sp.getPageBegin();
		int end = sp.getPageEnd();
		
		String city = vo.getCity();
		String district = vo.getDistrict();
		
	
		
		
	
		List<HomeVO> list = HomeService.selectSearch(city,district,start,end,range,value); 
		
		
		
		JSONObject jobj = new JSONObject();
		jobj.put("list", list);
		jobj.put("count", count);
		jobj.put("sp", sp);
		
		
	
		
		return jobj;
		
	}
	

	@ResponseBody
	@RequestMapping(value = "/city", method = RequestMethod.GET)
	public JSON city(Locale locale, Model model, @ModelAttribute HomeVO vo) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		List<HomeVO> cityList =  HomeService.selectCity();
		//model.addAttribute("datalist",list);
		List<HomeVO> districtList =  HomeService.selectDistrict();
		
		
		JSONObject jobj = new JSONObject();
		jobj.put("citylist", cityList);
		jobj.put("districtlist", districtList);
		
		return jobj;
	}
	
	@ResponseBody
	@RequestMapping(value = "/searchMarker", method = RequestMethod.POST)
	public List<HomeVO> serach(Locale locale, Model model, @ModelAttribute HomeVO vo, HttpSession session) {
		
		
		System.out.println("마커찾자");		
		List<HomeVO> list =  HomeService.selectMarker(vo);
		
		System.out.println("이거못갖고오냐?");
		return list;
		
		
		
	}
	
//	@ResponseBody
//	@RequestMapping(value = "/marker", method = RequestMethod.POST)
//	public JSON getLatLon(Locale locale, Model model, @ModelAttribute HomeVO vo) {
//		logger.info("Welcome home! The client locale is {}.", locale);
//		List<HomeVO> list =  HomeService.select(vo);
//		JSONObject jobj = new JSONObject();
//		
//		for(HomeVO e : list){
//			jobj.put("lat", e.getLat());
//			jobj.put("lon", e.getLon());
//			jobj.put("childcare_name", e.getChildcare_name());
//			
//		}
//		return jobj;
//	}
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, @ModelAttribute HomeVO vo) {
		
		List<HomeVO> cityList =  HomeService.selectCity(); 
		model.addAttribute("citylist",cityList);
		
		
		return "home";
	}
	
}
