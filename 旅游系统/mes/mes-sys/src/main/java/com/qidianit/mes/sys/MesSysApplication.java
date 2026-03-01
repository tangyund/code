package com.qidianit.mes.sys;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * @author
 * @time 2025/9/2 10:31
 * @description
 */
@SpringBootApplication
@MapperScan("com.qidianit.mes.sys.mapper")
@EnableTransactionManagement
public class MesSysApplication {
    public static void main(String[] args) {
        org.springframework.boot.SpringApplication.run(MesSysApplication.class, args);
    }
}
