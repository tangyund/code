package com.qidianit.mes.pojo;

import lombok.Data;

import java.io.Serializable;
import java.util.Map;

/**
 * 统一返回结果封装类
 */
@Data
public class Result<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 成功状态码
     */
    public static final int SUCCESS_CODE = 200;

    /**
     * 失败状态码
     */
    public static final int ERROR_CODE = 500;

    /**
     * 未授权状态码
     */
    public static final int UNAUTHORIZED_CODE = 401;

    /**
     * 禁止访问状态码
     */
    public static final int FORBIDDEN_CODE = 403;

    /**
     * 资源不存在状态码
     */
    public static final int NOT_FOUND_CODE = 404;

    /**
     * 状态码
     */
    private int code;

    /**
     * 返回消息
     */
    private String msg;

    /**
     * 返回数据
     */
    private T data;

    /**
     * 时间戳
     */
    private long timestamp;

    /**
     * 私有化构造方法，防止直接实例化
     */
    private Result() {
        this.timestamp = System.currentTimeMillis();
    }


    /**
     * 成功返回结果
     *
     * @param data 返回数据
     * @param <T>  数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> success(T data) {
        return success("操作成功", data);
    }

    public static <T> Result<T> success(int code, String msg, T data) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMsg(msg);
        result.setData(data);
        return result;
    }
    /**
     * 成功返回结果
     *
     * @param msg  消息
     * @param data 返回数据
     * @param <T>  数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> success(String msg, T data) {
        Result<T> result = new Result<>();
        result.setCode(SUCCESS_CODE);
        result.setMsg(msg);
        result.setData(data);
        return result;
    }

    /**
     * 成功返回结果（无数据）
     *
     * @return 统一返回结果
     */
    public static <T> Result<T> success() {
        return success(null);
    }

    /**
     * 错误返回结果
     *
     * @param msg 错误消息
     * @param <T> 数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> error(String msg) {
        return error(ERROR_CODE, msg);
    }

    /**
     * 错误返回结果
     *
     * @param code 错误码
     * @param msg  错误消息
     * @param <T>  数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> error(int code, String msg) {
        return error(code, msg, null);
    }

    /**
     * 错误返回结果
     *
     * @param code 错误码
     * @param msg  错误消息
     * @param data 错误数据
     * @param <T>  数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> error(int code, String msg, T data) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMsg(msg);
        result.setData(data);
        return result;
    }

    /**
     * 未授权返回结果
     *
     * @param msg 提示消息
     * @param <T> 数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> unauthorized(String msg) {
        return error(UNAUTHORIZED_CODE, msg);
    }

    /**
     * 禁止访问返回结果
     *
     * @param msg 提示消息
     * @param <T> 数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> forbidden(String msg) {
        return error(FORBIDDEN_CODE, msg);
    }

    /**
     * 资源不存在返回结果
     *
     * @param msg 提示消息
     * @param <T> 数据类型
     * @return 统一返回结果
     */
    public static <T> Result<T> notFound(String msg) {
        return error(NOT_FOUND_CODE, msg);
    }



    /**
     * 判断是否成功
     *
     * @return 是否成功
     */
    public boolean isSuccess() {
        return this.code == SUCCESS_CODE;
    }
}
