package com.qidian.mespro.service;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午2:21
 */
public interface ProcessService {

    Result<String> autoCode();

    Result<PageInfo<Process>> selectList(Process process, int pageNum, int pageSize);

    Result addProcess(Process process);

    Result selectByCode(String code);


    Result updateById(Process process);

    Result deleteById(Long id);

    Result batchDelete(Long [] ids);
}
