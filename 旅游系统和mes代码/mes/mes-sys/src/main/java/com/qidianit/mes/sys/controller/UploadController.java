package com.qidianit.mes.sys.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import com.qidianit.mes.pojo.*;
/**
 * @ Description:
 * @ Author: ZhangLi
 * @ Date: 2025/9/2 - 19:01
 */
@RestController
@RequestMapping("/upload")
public class UploadController {

    @Value("${imagePath}")
    private String imagePath;
    @Value("${server.port}")
    private String serverPort;

    @RequestMapping("/image")
    public Result<?> uploadImage(@RequestParam("uploadFile") MultipartFile uploadFile){
        String fileName = uploadFile.getOriginalFilename();
        String ext = fileName.substring(fileName.lastIndexOf("."));
        fileName = UUID.randomUUID().toString() + ext;
        try {
            uploadFile.transferTo(new File(imagePath + "\\" + fileName));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return Result.success("http://localhost:" + serverPort + "/image/" + fileName);
    }
}
