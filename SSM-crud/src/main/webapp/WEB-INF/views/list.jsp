<%@ page import="com.github.pagehelper.PageInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>list</title>
    <%
        session.setAttribute("APP_PATH",request.getContextPath());
    %>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>
</head>
<body>
    <div class="container">
<%--        标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>
<%--    按钮--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-10">
                <button class="btn btn-primary">
                    <span class="glyphicon glyphicon glyphicon-plus " aria-hidden="true"></span>
                    新增
                </button>
                <button class="btn btn-danger">
                    <span class="glyphicon glyphicon glyphicon-trash" aria-hidden="true"></span>
                    删除
                </button>
            </div>
        </div>
<%--    显示信息--%>
        <div class="row">
            <table class="table table-hover">
                <tr class="success">
                    <th>#</th>
                    <th>empName</th>
                    <th>Gender</th>
                    <th>Email</th>
                    <th>DeptName</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                <tr class="success">
                    <td>${emp.empId}</td>
                    <td>${emp.empName}</td>
                    <td>${emp.gender == "G" ?"女" : "男"}</td>
                    <td>${emp.email}</td>
                    <td>${emp.department.deprName}</td>
                    <td align="center">
                        <div>
                            <button class="btn btn-primary">
                                <span class="glyphicon glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                修改</button>
                            <button class="btn btn-danger">
                                <span class="glyphicon glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除</button>
                        </div>
                    </td>
                </tr>
                </c:forEach>
            </table>
        </div>
<%--    分页--%>
        <div class="row">
<%--            文字信息--%>
            <div class="col-md-6">
                当前${pageInfo.pageNum}页.总${pageInfo.pages}页.总${pageInfo.total}条记录
            </div>
<%--    分页条信息--%>
            <div col-md-6>
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <c:if test="${pageInfo.pageNum != 1}">
                            <li><a href="${APP_PATH}/emps">首页</a></li>
                            <li>
                                <a href="${APP_PATH}/emps?pn= ${ pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_number">
                            <c:if test="${page_number == pageInfo.pageNum}">
                                <li class="active"><a >${page_number}</a></li>
                            </c:if>
                            <c:if test="${page_number != pageInfo.pageNum}">
                                <li ><a href="${APP_PATH}/emps?pn=${page_number}">${page_number}</a></li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.pageNum != pageInfo.pages}">
                            <li>
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                            <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">尾页</a></li>
                        </c:if>
                    </ul>
                </nav>
            </div>

        </div>
    </div>
</body>
</html>
