package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.apache.ibatis.annotations.Param;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.regex.Pattern;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/16 - 下午7:40
 */
@Data
@TableName("supplier")
public class Supplier {

    private BigInteger id;
    private String code;
    private String name;
    private String address;
    private String contactPerson;
    private String phone;
    private String fax;
    private String email;
    private String description;
    private Integer status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    private Integer deleteFlag;


}
