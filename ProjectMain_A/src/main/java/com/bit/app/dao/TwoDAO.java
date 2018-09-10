package com.bit.app.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.bit.app.vo.ChildVO;
import com.bit.app.vo.GraphsVO;
import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.PolyGonVO;
import com.bit.app.vo.ServiceVO;
import com.bit.app.vo.TableVO;
import com.bit.app.vo.TestVO;
import com.bit.app.vo.WordCloudVO;

@Repository
public class TwoDAO {
	@Inject
	SqlSession sqlSession;
	 
//	public List<LineGraphsVO> selectLineGraphs(LineGraphsVO vo){
//		if(vo.getDistrict().contains("시"))
//		System.out.println(vo.getDistrict().substring(0, vo.getDistrict().indexOf("시")));
//		
//		return sqlSession.selectList("selectLineGraph", vo);
//	}
	public GraphsVO getGp(String city){
		return sqlSession.selectOne("selectGp", city);
	}
	
	public WordCloudVO getWC(String city) {
		System.out.println("dao온 city"+ city);
	
		return sqlSession.selectOne("selectWC", city);
	}
	
	public List<ChildVO> childSelect(ChildVO vo){
		if(vo.getGraphs().equals("충원률")){
			if(vo.getCity().equals("전국")){
				return sqlSession.selectList("childSelectAll",vo);
			}else{
				return sqlSession.selectList("childSelect",vo);
			}
		}else if(vo.getGraphs().equals("재산세")){
			if(vo.getCity().equals("전국")){
				return sqlSession.selectList("childSelectAll2",vo);
			}else{
				return sqlSession.selectList("childSelect2",vo);
			}
		}else{
			if(vo.getCity().equals("전국")){
				return sqlSession.selectList("childSelectAll3",vo);
			}else{
				return sqlSession.selectList("childSelect3",vo);
			}
		}
	}
	
	public List<HomeVO> selectCity(){
		List<HomeVO> list =  sqlSession.selectList("TwoCitySelect");
		
		return list;
	}
	
	public List<ServiceVO> selectService(ServiceVO vo){
	      
	      
	      
	      System.out.println("dao까지 온 vo"+vo.getCity()+vo.getDistrict());
	      
	      return sqlSession.selectList("selectService" , vo);
	   }

	
//	public List<PolyGonVO> PolyGonList(PolyGonVO vo){
//		
//		Map map = new HashMap();
//		map.put("city", vo.getCity());
//		map.put("district", vo.getDistrict());
//		
//		return sqlSession.selectList("PolyGonList", map);
//		
//	}
//	
//	public List<PolyGonVO> selectPolygon(String district){
//		
//		Map map = new HashMap();
//		map.put("district", district);
//		return sqlSession.selectList("selectPolygon", map);
//		
//	}
	
	public List<HomeVO> selectAll(HomeVO vo){
		Map map = new HashMap();
		map.put("city", vo.getCity());
		map.put("district", vo.getDistrict());
		return sqlSession.selectList("selectAll", map);
	}
	
	public List<TableVO> selectTableSearch(String city,String district,int start,int end, String range, String value){
		
		Map map = new HashMap();
		map.put("city", city);
		map.put("district", district);
		map.put("start", start);
		map.put("end", end);
		map.put("range", range);
		map.put("value", value);
		
		List<TableVO> list = sqlSession.selectList("SearchTable",map);
	
			
		
		return list;
	}
	
	public int selectSearchCount(TestVO vo) {
		Map map = new HashMap();
		
		if(vo.getCity().equals("제주특별자치도")){
			map.put("city", "제주도");
		}else{
			map.put("city", vo.getCity());
		}
		
		map.put("district", vo.getDistrict());
		int count = sqlSession.selectOne("SearchCount",map);

		
		return count;
	}
}
