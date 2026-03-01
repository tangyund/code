package com.qidianit.mes.sys.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @ Description:
 * @ Author: ZhangLi
 * @ Date: 2025/9/2 - 19:15
 */
public class JSONTools {

    private static ObjectMapper objectMapper = new ObjectMapper();

    public static String obj2json(Object obj){
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}
