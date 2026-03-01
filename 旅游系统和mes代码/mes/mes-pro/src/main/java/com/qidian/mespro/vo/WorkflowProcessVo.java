package com.qidian.mespro.vo;

import com.qidianit.mes.pojo.SysDictData;
import com.qidianit.mes.pojo.SysDictType;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午4:28
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WorkflowProcessVo extends WorkflowProcess {
    private Process process;
    private Process nextProcess;
    private SysDictData relationNextDict;
}
