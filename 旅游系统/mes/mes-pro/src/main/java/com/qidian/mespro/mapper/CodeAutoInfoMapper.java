package com.qidian.mespro.mapper;

import com.qidianit.mes.pojo.CodeAutoInfo;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午2:11
 */
public interface CodeAutoInfoMapper {

    List<CodeAutoInfo> selectlist();

    CodeAutoInfo selectByType(String type);

    int save(CodeAutoInfo codeAutoInfo);

    int update(CodeAutoInfo codeAutoInfo);


}
