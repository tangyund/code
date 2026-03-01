package com.qidian.mespro;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.qidian.mespro.mapper")
public class MesProApplication {

    public static void main(String[] args) {
        SpringApplication.run(MesProApplication.class, args);
    }

}
