package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import com.qidianit.mes.pojo.*;

import java.util.List;

@Mapper
public interface WorkstationMapper extends BaseMapper<Workstation> {

    List<Workstation> selectProcessAndWorkshopByProcessId(Workstation workstation);

    List<Workstation> selectALLStation(Workstation workstation);
}