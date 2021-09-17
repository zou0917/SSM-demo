package com.zw.crud.controller;

import com.zw.crud.bean.Department;
import com.zw.crud.bean.Msg;
import com.zw.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;

    @ResponseBody
    @RequestMapping("/deps")
    public Msg getDept(){
        List<Department> departments = departmentService.getDeps();
        return Msg.success().add("deps",departments);
    }
}
