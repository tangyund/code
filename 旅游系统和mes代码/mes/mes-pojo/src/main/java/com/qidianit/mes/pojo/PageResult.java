package com.qidianit.mes.pojo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 分页结果封装类
 * 用于统一封装分页查询的结果，包含数据列表和分页信息
 */
@Data
public class PageResult<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 状态码：成功=200，失败=500
     */
    private int code;

    /**
     * 返回消息
     */
    private String msg;

    /**
     * 当前页的数据列表
     */
    private List<T> data;

    /**
     * 总记录数
     */
    private long total;

    /**
     * 总页数
     */
    private long pages;

    /**
     * 当前页码
     */
    private long current;

    /**
     * 每页显示条数
     */
    private long size;

    /**
     * 时间戳
     */
    private long timestamp;

    /**
     * 私有化构造方法，防止直接实例化
     */
    private PageResult() {
        this.timestamp = System.currentTimeMillis();
    }

    /**
     * 创建成功的分页结果
     *
     * @param data  当前页数据
     * @param total 总记录数
     * @param pages 总页数
     * @param current 当前页码
     * @param size  每页条数
     * @param <T>   数据类型
     * @return 分页结果对象
     */
    public static <T> PageResult<T> success(List<T> data, long total, long pages, long current, long size) {
        PageResult<T> result = new PageResult<>();
        result.setCode(Result.SUCCESS_CODE);
        result.setMsg("查询成功");
        result.setData(data);
        result.setTotal(total);
        result.setPages(pages);
        result.setCurrent(current);
        result.setSize(size);
        return result;
    }

    /**
     * 创建失败的分页结果
     *
     * @param msg 错误消息
     * @param <T> 数据类型
     * @return 分页结果对象
     */
    public static <T> PageResult<T> error(String msg) {
        PageResult<T> result = new PageResult<>();
        result.setCode(Result.ERROR_CODE);
        result.setMsg(msg);
        result.setData(null);
        result.setTotal(0);
        result.setPages(0);
        result.setCurrent(1);
        result.setSize(0);
        return result;
    }

    /**
     * 判断分页结果是否成功
     *
     * @return 是否成功
     */
    public boolean isSuccess() {
        return this.code == Result.SUCCESS_CODE;
    }
}
