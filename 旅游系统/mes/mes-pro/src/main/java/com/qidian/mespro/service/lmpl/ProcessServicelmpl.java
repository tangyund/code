package com.qidian.mespro.service.lmpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.CodeAutoInfoMapper;
import com.qidian.mespro.mapper.ProcessMapper;
import com.qidian.mespro.service.ProcessService;
import com.qidianit.mes.pojo.CodeAutoInfo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午2:21
 */
@Service
public class ProcessServicelmpl implements ProcessService {

    @Autowired
    ProcessMapper processMapper;
    @Autowired
    private CodeAutoInfoMapper codeAutoInfoMapper;

    @Value("${process_code_type}")
    private String processCodeType;

    @Override
    public Result<String> autoCode() {
        CodeAutoInfo codeAutoInfo = codeAutoInfoMapper.selectByType(processCodeType);
        // 放入前缀
        StringBuilder sb = new StringBuilder(codeAutoInfo.getPre());
        // 日期
        sb.append(new SimpleDateFormat("YYMMdd").format(new Date()));
        // 序列号
        Integer sequence = codeAutoInfo.getSequence(); //
        // 在序列号前面补0
        for (int i = 0;i < 4 - sequence.toString().length();i++){
            sb.append("0");
        }
        sb.append(sequence.toString());
        // 将序列号+1，再保存回去
        codeAutoInfo.setSequence(codeAutoInfo.getSequence() + 1);
        codeAutoInfoMapper.update(codeAutoInfo);
        return Result.success(sb.toString());
    }
    @Override
    public Result<PageInfo<Process>> selectList(Process process, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        List<Process> processeslists=processMapper.selectList(process);

        return Result.success(new PageInfo<>(processeslists));
    }

    @Override
    public Result addProcess(Process process) {
        return processMapper.addProcess(process) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result selectByCode(String code) {
        return Result.success(processMapper.selectByCode(code));
    }


    @Override
    public Result updateById(Process process) {
        return processMapper.updateById(process)==1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result deleteById(Long id) {
        return processMapper.deleteById(id)==1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result batchDelete(Long[] ids) {
        return processMapper.batchDelete(ids)>0? Result.success():Result.error("编辑失败");
    }
}
