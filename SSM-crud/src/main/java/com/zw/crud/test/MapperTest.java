package com.zw.crud.test;

import com.zw.crud.bean.Department;
import com.zw.crud.bean.Employee;
import com.zw.crud.bean.EmployeeExample;
import com.zw.crud.dao.DepartmentMapper;
import com.zw.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;

    //可执行批量操作的sqlSession
    @Autowired
    SqlSession sqlSession;

    @Test
    public void springTest(){

        departmentMapper.insertSelective(new Department(null,"技术部"));
        departmentMapper.insertSelective(new Department(null,"销售部"));
        EmployeeMapper sqlSessionMapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i=0;i<30;i++){
            String uuid = UUID.randomUUID().toString().substring(0, 5)+i;
            sqlSessionMapper.insertSelective(new Employee(null,uuid,"G",uuid+"@emp.com",1));
        }
//        EmployeeExample employeeExample = new EmployeeExample();
//        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
//        criteria.andEmpNameEqualTo("哈哈asd");
//        List<Employee> employees = employeeMapper.selectByExample(employeeExample);
//        System.out.println("================================");
//        System.out.println(employees.size());
    }
}
