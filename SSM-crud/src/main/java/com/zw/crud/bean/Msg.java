package com.zw.crud.bean;

import java.util.HashMap;
import java.util.Map;

public class Msg {
    //状态码 这里定义100为成功，200为失败
    private int code;
    //提示信息
    private String msg;
    //返回浏览器的数据
    private Map<String,Object> extend = new HashMap<String,Object>();
    //快速返回成功或失败的msg
    public static Msg success(){
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMsg("操作成功");
        return msg;
    }
    public static Msg fail(){
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setMsg("操作失败");
        return msg;
    }
    //提供链式添加返回浏览器的数据
    public Msg add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }
    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
