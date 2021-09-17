package com.zw.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zw.crud.bean.Employee;
import com.zw.crud.bean.EmployeeExample;
import com.zw.crud.bean.Msg;
import com.zw.crud.dao.EmployeeMapper;
import com.zw.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;

    //保存
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            Map<String,String> errorMap = new HashMap<>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError e:fieldErrors) {
                //getField获取错误的字段名，getDefaultMessage获取错误的信息
                errorMap.put(e.getField(),e.getDefaultMessage());
            }
            return Msg.fail().add("error",errorMap);
        }else {
            employeeService.saveEmployee(employee);
            return Msg.success();
        }
    }
    //查询所有
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getAll(@RequestParam(value = "pn",defaultValue = "1")Integer page, Model model){
        //设置分页的当前页码及每页显示条目数
        PageHelper.startPage(page,5);
        //查询所有信息
        List<Employee> employees = employeeService.selectAll();
        //封装employees
        PageInfo<Employee> pageInfo = new PageInfo<>(employees, 5);
        return Msg.success().add("pageInfo",pageInfo);
    }

    //按照名称校验
    @RequestMapping("/check/{name}")
    @ResponseBody
    public Msg checkUser(@PathVariable("name") String name){
        boolean flag = employeeService.checkUser(name);
        if(flag){
            return Msg.success();
        }else {
            return Msg.fail();
        }
    }
    //根据ID查询
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee emp = employeeService.getEmp(id);
        return Msg.success().add("emp",emp);
    }
    //修改员工
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        if (employeeService.update(employee)){
            return Msg.success();
        }else {
            return Msg.fail();
        }
    }
    //根据id删除
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteById(@PathVariable("ids") String ids){
        if(ids.contains("-")){//批量删除
            List<Integer> empIds =new ArrayList<>();
            String[] split = ids.split("-");
            for (String s:split) {
                empIds.add(Integer.parseInt(s));
            }
            return employeeService.delEmps(empIds)==true? Msg.success():Msg.fail();
        }else {
            Integer id = Integer.parseInt(ids);
            return employeeService.deleteById(id)==true? Msg.success():Msg.fail();
        }
    }
}
