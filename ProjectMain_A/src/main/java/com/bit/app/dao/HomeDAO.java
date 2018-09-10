package com.bit.app.dao;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.ServiceVO;
import com.bit.app.vo.TestVO;

@Repository
public class HomeDAO {
	
	@Inject
	SqlSession sqlSession;
	
	public List<LineGraphsVO> selectLineGraphs(LineGraphsVO vo){
		if(vo.getDistrict().contains("시"))
		System.out.println(vo.getDistrict().substring(0, vo.getDistrict().indexOf("시")));
		
		return sqlSession.selectList("selectLineGraph", vo);
	}
	
	public List<ServiceVO> selectGraph(ServiceVO vo){
	      
	      
	      
	      System.out.println("dao까지 온 vo"+vo.getCity()+vo.getDistrict());
	      
	      return sqlSession.selectList("selectGraph" , vo);
	   }
	
	public List<HomeVO> selectAll(HomeVO vo){
		Map map = new HashMap();
		map.put("city", vo.getCity());
		map.put("district", vo.getDistrict());
		return sqlSession.selectList("selectAll", map);
	}
	
	public List<HomeVO> select(HomeVO vo){
		List<HomeVO> list = null;
		if(vo.getDistrict().equals(null)||vo.getDistrict().equals("")){
		list = sqlSession.selectList("CityHomeSelect",vo);	
		}else{
		list =  sqlSession.selectList("HomeSelect",vo);
		}
		return list;
	}
	public List<HomeVO> selectCity(){
		List<HomeVO> list =  sqlSession.selectList("CitySelect");
		
		return list;
	}
	public List<HomeVO> selectDistrict(){
		List<HomeVO> list =  sqlSession.selectList("DistrictSelect");
		
		return list;
	}
	public List<HomeVO> selectSearch(String city,String district,int start,int end, String range, String value){
		System.out.println("dao"+value);
		Map map = new HashMap();
		map.put("city", city);
		map.put("district", district);
		map.put("start", start);
		map.put("end", end); 
		map.put("range", range);
		map.put("value", value);
		System.out.println("value:"+map.get("range"));
		List<HomeVO> list = null;
		if(!map.get("city").equals(null)||!map.get("city").equals("")) {
			if(map.get("district").equals(null)||map.get("district").equals("")) {
				list = sqlSession.selectList("SearchCity",map);
			}else {
				list = sqlSession.selectList("Searchdistrict",map);
			}
		}
		
		return list;
	}
	public int selectSearchCount(TestVO vo) {
		int count = 0;
		if(!vo.getCity().equals(null)||!vo.getCity().equals("")) {
			if(vo.getDistrict().equals(null)||vo.getDistrict().equals("")) {
				count = sqlSession.selectOne("SearchCityCount",vo);
			}else {
				count = sqlSession.selectOne("SearchdistrictCount",vo);
			}
		}
		
		return count;
	}
}
