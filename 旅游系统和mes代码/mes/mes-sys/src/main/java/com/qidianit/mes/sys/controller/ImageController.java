package com.qidianit.mes.sys.controller;

import com.qidianit.mes.sys.util.JSONTools;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import com.qidianit.mes.pojo.*;
/**
 * @ Description:
 * @ Author: ZhangLi
 * @ Date: 2025/9/2 - 19:12
 */
@Controller
public class ImageController {

    @Value("${imagePath}")
    private String imagePath;

    @RequestMapping("/image/{fileName}")
    public void getImage(@PathVariable String fileName, HttpServletResponse response) throws IOException {
        File file = new File(imagePath + "\\" + fileName);
        if(file.exists() && file.isFile()) {
            if(fileName.endsWith("jpg")){
                response.setContentType("image/jpg");
            }else if(fileName.endsWith("png")){
                response.setContentType("image/png");
            }else if(fileName.endsWith("gif")){
                response.setContentType("image/gif");
            }
            response.setHeader("Content-Disposition","filename=\"" + fileName + "\"");
            OutputStream out = response.getOutputStream();
            FileInputStream in = new FileInputStream(file);
            int len = -1;
            byte [] buff = new byte[1024];
            while ((len = in.read(buff)) != 1){
                out.write(buff,0,len);
                out.flush();
            }
            in.close();
        }
        response.getWriter().write(JSONTools.obj2json(Result.error("你要找的图片不存在")));
    }
}
