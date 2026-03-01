package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import com.qidianit.mes.pojo.*;

import java.util.List;

@Mapper
public interface MaterialMapper extends BaseMapper<Material> {
    List<Material> selectList(Material material);
    Material selectByCode(String code);

}