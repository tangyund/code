package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.SysLoginLogMapper;
import com.qidianit.mes.sys.service.LoginLogService;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import com.qidianit.mes.pojo.*;
/**
 * 登录日志Service实现类
 */
@Service
public class LoginLogServiceImpl extends ServiceImpl<SysLoginLogMapper, SysLoginLog> implements LoginLogService {

    @Override
    public PageResult<SysLoginLog> selectLoginLogPage(Page<SysLoginLog> page, SysLoginLog loginLog) {
        IPage<SysLoginLog> iPage = baseMapper.selectLoginLogPage(page, loginLog);
        return PageResult.success(
            iPage.getRecords(),
            iPage.getTotal(),
            iPage.getPages(),
            iPage.getCurrent(),
            iPage.getSize()
        );
    }

    @Override
    public PageResult<SysLoginLog> selectLoginLogByUserId(Page<SysLoginLog> page, Long userId) {
        IPage<SysLoginLog> iPage = baseMapper.selectLoginLogByUserId(page, userId);
        return PageResult.success(
            iPage.getRecords(),
            iPage.getTotal(),
            iPage.getPages(),
            iPage.getCurrent(),
            iPage.getSize()
        );
    }

    @Override
    public void recordLoginLog(String username, Long userId, String ipAddress, Integer loginStatus, String msg) {
        SysLoginLog loginLog = new SysLoginLog();
        loginLog.setUserId(userId);
        loginLog.setUsername(username);
        loginLog.setIpAddress(ipAddress);
        loginLog.setLoginStatus(loginStatus);
        loginLog.setMsg(msg);
        loginLog.setLoginTime(new Date());
        
        // 可以通过IP解析工具获取登录地点，这里简化处理
        loginLog.setLoginLocation("未知");
        
        baseMapper.insert(loginLog);
    }

    /**
     * 从请求中获取IP地址
     */
    public String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多个代理的情况，第一个IP为客户端真实IP
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0];
        }
        return ip;
    }

//    /**
//     * 解析用户代理信息
//     */
//    public void parseUserAgent(SysLoginLog loginLog, String userAgentStr) {
//        UserAgent userAgent = UserAgent.parseUserAgentString(userAgentStr);
//        // 获取浏览器信息
//        loginLog.setBrowser(userAgent.getBrowser().getName() + " " + userAgent.getBrowserVersion());
//        // 获取操作系统信息
//        loginLog.setOs(userAgent.getOperatingSystem().getName());
//    }
}
