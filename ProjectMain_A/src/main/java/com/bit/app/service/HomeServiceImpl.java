package com.bit.app.service;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bit.app.dao.HomeDAO;
import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.ServiceVO;
import com.bit.app.vo.TestVO;


@Service

public class HomeServiceImpl implements HomeService {

	@Autowired
	HomeDAO dao;
	@Override
	public List<ServiceVO> getGraph(ServiceVO vo) {
		// TODO Auto-generated method stub
		 return dao.selectGraph(vo);
	}

	@Override
	public List<HomeVO> select(HomeVO vo) {
		// TODO Auto-generated method stub
		return dao.select(vo);
	}

	@Override
	public List<HomeVO> selectCity() {
		// TODO Auto-generated method stub
		return dao.selectCity();
	}

	@Override
	public List<HomeVO> selectSearch(String city,String district,int start,int end,String range, String value) {
		// TODO Auto-generated method stub
		System.out.println(value);
		return dao.selectSearch(city,district,start,end,range,value);
	}

	@Override
	public int selectSearchCount(TestVO vo) {
		// TODO Auto-generated method stub 
		return dao.selectSearchCount(vo);
	}

	@Override
	public List<HomeVO> selectDistrict() {
		// TODO Auto-generated method stub
		return dao.selectDistrict();
	}

	@Override
	public List<HomeVO> selectMarker(HomeVO vo) {
		// TODO Auto-generated method stub
		return dao.selectAll(vo);
	}

	@Override
	public List<LineGraphsVO> getLineGraph(LineGraphsVO vo) {
		// TODO Auto-generated method stub
		return dao.selectLineGraphs(vo);
	}

}
