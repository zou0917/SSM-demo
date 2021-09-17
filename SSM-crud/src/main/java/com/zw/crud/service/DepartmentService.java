package com.zw.crud.service;

import com.zw.crud.bean.Department;
import com.zw.crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    DepartmentMapper departmentMapper;

    public List<Department> getDeps(){
        return departmentMapper.selectByExample(null);
    }
}
