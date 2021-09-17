package com.zw.crud.service;

import com.zw.crud.bean.Employee;
import com.zw.crud.bean.EmployeeExample;
import com.zw.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 实现查询所有员工。
     */
    public List<Employee> selectAll(){
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
        return employees;
    }
    //保存
    public void saveEmployee(Employee employee){
        employeeMapper.insertSelective(employee);
    }
    //按名称查询员工 return true 表示用户名可以用
    public boolean checkUser(String name){
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(name);
        return employeeMapper.countByExample(example)==0;
    }
    //根据id查询员工
    public Employee getEmp(Integer id){
        return employeeMapper.selectByPrimaryKey(id);
    }
    //修改员工
    public boolean update(Employee employee){
        int i = employeeMapper.updateByPrimaryKeySelective(employee);
        return i!=0 ? true:false;
    }
    //根据id删除
    public boolean deleteById(Integer id){
        int i = employeeMapper.deleteByPrimaryKey(id);
        return i != 0 ? true:false;
    }
    //根据ID批量删除
    public boolean delEmps(List<Integer> ids){
        EmployeeExample example=new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        int i = employeeMapper.deleteByExample(example);
        return  i !=0 ? true:false;
    }
}
