package com.bit.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bit.app.dao.TwoDAO;
import com.bit.app.vo.ChildVO;
import com.bit.app.vo.GraphsVO;
import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.PolyGonVO;
import com.bit.app.vo.ServiceVO;
import com.bit.app.vo.TableVO;
import com.bit.app.vo.TestVO;
import com.bit.app.vo.WordCloudVO;
@Service
public class TwoServiceImpl implements TwoService {
	
	@Autowired
	TwoDAO tdao;
	
	
	
	@Override
	public List<HomeVO> select(HomeVO vo) {
		// TODO Auto-generated method stub
		return tdao.selectAll(vo);
	}

	@Override
	public List<TableVO> selectTableSearch(String city, String district, int start, int end, String range, String value) {
		// TODO Auto-generated method stub
		return tdao.selectTableSearch(city,district,start,end,range,value);
	} 

	@Override
	public int selectSearchCount(TestVO vo) {
		// TODO Auto-generated method stub
		return tdao.selectSearchCount(vo);
	}

//	@Override
//	public List<PolyGonVO> selectPolygon(String district) {
//		// TODO Auto-generated method stub
//		return tdao.selectPolygon(district);
//	}
//
//	@Override
//	public List<PolyGonVO> selectList(PolyGonVO vo) {
//		// TODO Auto-generated method stub
//		return tdao.PolyGonList(vo);
//	}

	@Override
	public WordCloudVO getWC(String city) {
		// TODO Auto-generated method stub
		System.out.println("서비스 온 city"+ city);		
		
		return tdao.getWC(city);	
	}
	
	@Override
	public List<ServiceVO> getGraph(ServiceVO vo) {
		// TODO Auto-generated method stub
		 return tdao.selectService(vo);
	}

	@Override
	public List<HomeVO> selectCity() {
		// TODO Auto-generated method stub
		return tdao.selectCity();
	}

	@Override
	public List<ChildVO> childSelect(ChildVO vo) {
		// TODO Auto-generated method stub
		return tdao.childSelect(vo);
	}

	@Override
	public GraphsVO getGp(String city) {
		// TODO Auto-generated method stub
		return tdao.getGp(city);
	}

//	@Override
//	public List<LineGraphsVO> getLineGraph(LineGraphsVO vo) {
//		// TODO Auto-generated method stub
//		return tdao.selectLineGraphs(vo);
//	}

}
