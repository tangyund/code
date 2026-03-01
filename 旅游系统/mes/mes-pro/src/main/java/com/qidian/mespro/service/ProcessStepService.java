package com.qidian.mespro.service;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.ProcessStep;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午4:37
 */
public interface ProcessStepService {

    Result<PageInfo<ProcessStep>> selectByProcessId(ProcessStep processStep, int pageNum, int size);

    Result selectById(Long id);

    Result updateById(ProcessStep processStep);

    Result deleteById(Long id);
}
