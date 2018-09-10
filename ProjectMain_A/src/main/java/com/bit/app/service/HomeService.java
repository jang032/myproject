package com.bit.app.service;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import com.bit.app.vo.HomeVO;
import com.bit.app.vo.LineGraphsVO;
import com.bit.app.vo.ServiceVO;
import com.bit.app.vo.TestVO;

public interface HomeService {
	List<HomeVO> select(HomeVO vo);
	List<HomeVO> selectCity();
	List<HomeVO> selectDistrict();
	List<HomeVO> selectSearch(String city,String district,int start,int end,String range, String value);
	int selectSearchCount(TestVO vo);
	List<HomeVO> selectMarker(HomeVO vo);
	List<ServiceVO> getGraph(ServiceVO vo);
	List<LineGraphsVO> getLineGraph(LineGraphsVO vo);
}

