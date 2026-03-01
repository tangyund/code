package com.qidian.mespro.service.lmpl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.ProcessStepMapper;
import com.qidian.mespro.service.ProcessService;
import com.qidian.mespro.service.ProcessStepService;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.ProcessStep;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午4:37
 */
@Service
public class ProcessStepServicelmpl implements ProcessStepService {

    @Autowired
    ProcessStepMapper processStepMapper;

    @Override
    public Result<PageInfo<ProcessStep>> selectByProcessId(ProcessStep processStep, int pageNum, int size) {

        PageHelper.startPage(pageNum,size);
        List<ProcessStep> step =processStepMapper.selectByProcessId(processStep);
        return Result.success(new PageInfo<>(step));
    }

    @Override
    public Result selectById(Long id) {
        return Result.success(processStepMapper.selectById(id));
    }

    @Override
    public Result updateById(ProcessStep processStep) {

        return processStepMapper.updateById(processStep)==1 ? Result.success():Result.error("编辑失败");

    }

    @Override
    public Result deleteById(Long id) {
        return processStepMapper.deleteById(id)==1 ? Result.success():Result.error("编辑失败");
    }
}
