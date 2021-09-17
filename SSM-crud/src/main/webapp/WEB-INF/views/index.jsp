<%@ page import="com.github.pagehelper.PageInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>index</title>
    <%
        session.setAttribute("APP_PATH",request.getContextPath());
    %>
<%--    引入jquety--%>
    <script src="webjars/jquery/3.3.1-1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">
    <script type="text/javascript">
        var total, currentPage;
        //页面加载完成
        $(function (){
            //第一页员工数据
            to_page_num(1);
            //添加按钮绑定事件
            $("#add_emp").click(function (){
                //给按钮绑定调用模态窗事件
                $("#add_emp_modal").modal({
                    backdrop:"static"
                });
                //清空表单事件
                clean_form();
                //给新增按钮绑定获取部门信息事件
                to_deps();
            });
            //给保存按钮绑定单击事件
            $("#save_emp_btn").click(function (){
                to_sava_emp();
            });
            //用户名绑定事件
            $("#empName").change(function (){
                to_isExist_name();
            });
            //保存修改按钮绑定单击事件
            $("#update_emp_btn").click(function (){
                if(email_check("#update_email","#update_email_errorMsg") == false){return false};
                to_update_emp($(this).attr("edit_id"));
            });
            //清除状态
            $("#checkAll").prop("checked",false);
            //全选
            $("#checkAll").click(function () {
                $(".check").prop("checked",$("#checkAll").prop("checked"));
            });
            //批量删除按钮绑定事件
            $("#del_emps").click(function () {
                //要删除的员工名字
                var del_names="";
                //要删除的员工ID
                var del_ids="";
                $.each($(".check:checked"),function (index,item){
                    del_names += $(item).parents("tr").find("td:eq(2)").text()+",";
                    del_ids += $(item).parents("tr").find("td:eq(1)").text()+"-";
                });
                del_names=del_names.substring(0,del_names.length-1);
                del_ids=del_ids.substring(0,del_ids.length-1);
                if(confirm("确定要删除【"+del_names+"】 吗？")){
                    $.ajax({
                        url:"${APP_PATH}/emp/"+del_ids,
                        type:"DELETE",
                        success:function (result) {
                            if( result.code == "100"){//删除成功
                                //隐藏模态框
                                $("#update_emp_modal").modal('hide');
                                //跳转到当前页
                                to_page_num(currentPage);
                            }else {return false}
                        }
                    });
                }else {return false}
            });
        });
        //给表单中的每个单选绑定事件，若表单中被选中的单选框个数=表单中全部的单选框，则表示全选
        $(document).on("click",".check",function (){
            var flag= $(".check:checked").length == $(".check").length ;
            $("#checkAll").prop("checked",flag);
        });
        //给删除按钮动态绑定事件
        $(document).on("click",".delete_btn",function (){
            var ale_name = $(this).parents("tr").find("td:eq(2)").text();
            if(confirm("确定要删除：【"+ale_name+"】吗?")){
                $.ajax({
                    url:"${APP_PATH}/emp/"+$(this).prev().attr("edit_id"),
                    type:"DELETE",
                    success:function (result) {
                        if(result.code == "100"){//删除成功
                            //隐藏模态框
                            $("#update_emp_modal").modal('hide');
                            //跳转到当前页
                            to_page_num(currentPage);
                        }else {
                            alert("删除失败");
                        }
                    }
                });
            }else {
                return false;
            }
        });
        //发送请求获取员工信息、解析数据
        function to_page_num(pn){
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn="+pn,
                type:"GET",
                success:function (result){
                    //1解析显示员工信息
                    buildEmpTable(result);
                    //2解析显示分页信息
                    build_page_info(result);
                    build_page_num(result);
                }
            });
        }
        //发送请求获取部门
        function to_deps(){
            $.ajax({
               url:"${APP_PATH}/deps",
                type:"GET",
                success:function (result){
                    build_dep(result);
                }
            });
        }
        //发送请求，保存员工
        function to_sava_emp(){
            //进行校验
            if(!emp_check()){ //不合法 直接结束方法阻止发起请求
                return false;
            }
            //发送请求保存员工
            $.ajax({
                url:"${APP_PATH}/emp",
                type:"POST",
                data: $("#add_emp_modal form").serialize(),
                success:function (result){
                    if(result.code == "100"){//jsr303校验成功
                        //隐藏模态框
                        $("#add_emp_modal").modal('hide');
                        //跳转到最后一页
                        to_page_num(total);
                    }else {//校验失败显示错误信息
                        $(".modal-body form div span").text("");
                        $(".modal-body form div").removeClass("has-success has-warning  has-error");
                        if(result.extend.error.empName != undefined){
                            show_check_msg("#empName","false","#name_errorMsg",result.extend.error.empName);
                        }
                        if(result.extend.error.email != undefined){
                            show_check_msg("#email","false","#email_errorMsg",result.extend.error.email);
                        }

                    }

                }
            });
        }
        function to_update_emp(edit_id){
            $.ajax({
                url:"${APP_PATH}/emp/"+edit_id,
                type:"PUT",
                data:$("#update_emp_modal form").serialize(),
                success:function (result){
                    if(result.code == "100"){//修改成功
                        //隐藏模态框
                        $("#update_emp_modal").modal('hide');
                        //跳转到当前页
                        to_page_num(currentPage);
                    }else {
                        alert("修改失败");
                    }
                }
            });
        }
        //发送请求，校验用户名是否存在
        function to_isExist_name(){
            $.ajax({
                url:"${APP_PATH}/check/"+$("#empName").val(),
                type:"GET",
                success:function (result){
                    if(result.code =="200"){//表示用户名不可用
                        $("#empName").attr("name_flag","false");
                        show_check_msg("#empName","false","#name_errorMsg","用户名已经存在");
                    }else if(result.code =="100"){//表示用户名可用
                         $("#empName").attr("name_flag","true");
                        show_check_msg("#empName","true","#name_errorMsg","");
                    }
                }
            });
        }
        //清空表单
        function clean_form(){
            $(".modal-body form div > input").val("");
            $(".modal-body form div span").text("");
            $(".modal-body form div").removeClass("has-success has-warning  has-error");
            $("#empName").removeAttr("name_flag");

        }
        //构建员工信息
        function buildEmpTable (result){
            //清空表格数据
            $("#emps_table tbody").empty();
            var emps=result.extend.pageInfo.list;
            $.each(emps,function (index,item){
                var checkItem = $("<td><input type='checkbox' class='check'></td>");
                var empId = $("<td>"+item.empId+"</td>");
                var empName = $("<td></td>").append(item.empName);
                var email = $("<td></td>").append(item.email);
                var gender=$("<td></td>").append(item.gender == "G"? "女" :"男");
                var deprName = $("<td></td>").append(item.department.deprName);
                var ebutton=$("<button class='btn btn-primary btn-sm update_btn'>" +
                    "<span class='glyphicon glyphicon glyphicon-pencil' aria-hidden='true'></span>" +
                    " 修改</button>").attr("edit_id",item.empId);
                var delButton=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append("<span class='glyphicon glyphicon glyphicon-trash' aria-hidden=true></span>").append(" 删除");
                var button =$("<td></td>").append($("<div></div>").append(ebutton).append(" ").append(delButton));
                $("<tr></tr>").addClass("success")
                                .append(checkItem)
                                .append(empId)
                                .append(empName)
                                .append(email)
                                .append(gender)
                                .append(deprName)
                                .append(button)
                                .appendTo("#emps_table tbody");

            });

            //给修改按钮绑定事件
            $(".update_btn").click(function () {
                //显示部门信息
                to_deps();
                $("#update_emp_btn").attr("edit_id",$(this).attr("edit_id"));
                $.ajax({
                    url:"${APP_PATH}/emp/"+$(this).attr("edit_id"),
                    type:"GET",
                    success:function (result){
                        //回显用户信息
                        show_edit_emp(result);
                        //调用模态窗
                        $("#update_emp_modal").modal({
                            backdrop:"static"
                        });
                    }
                });

            });
        };
        //回显修改模态窗的员工信息
        function show_edit_emp(result){
            // 回显用户名
            $("#update_empName").text(result.extend.emp.empName);
            // 邮箱回显
            $("#update_email").val(result.extend.emp.email);
            // 性别回显 匹配修改模态框下的input标签，并且type属性为radio的 元素
            $("#update_emp_modal input[type=radio]").val([result.extend.emp.gender]);
            //部门回显
            $("#update_emp_modal select").val([result.extend.emp.dId]);
        }
        //构建分页信息
        function build_page_info(result){
            //清空分页信息
            $("#page_info_area").empty();
            var pi=result.extend.pageInfo;
            //记录总条数
            total=pi.total;
            currentPage=pi.pageNum;
            $("#page_info_area")
                .append("当前"+pi.pageNum+"页, ")
                .append("总"+pi.pages+"页, ")
                .append("共"+pi.total+"条记录");
        }
        //构建分页条

        //分页页码  data-toggle="modal" data-target="#model"
        function  build_page_num(result){
            //清空分页条
            $("#page_info_nums").empty();
            var previous_page = $("<li> <a href='#' aria-label='Previous'> <span aria-hidden='true'>&laquo;</span> </a> </li>")
                .click(function (){to_page_num(result.extend.pageInfo.pageNum - 1)});
            var next_page = $("<li> <a href='#' aria-label='Next'> <span aria-hidden='true'>&raquo;</span> </a></li>")
                .click(function (){to_page_num(result.extend.pageInfo.pageNum + 1)});
            var first_page = $("<li><a href='#'>首页</a></li>")
                .click(function (){to_page_num(1)});
            var last_page = $("<li><a href='#'>尾页</a></li>")
                .click(function (){to_page_num(result.extend.pageInfo.pages)});
            var navigatepageNums = result.extend.pageInfo.navigatepageNums;
            var $nav = $("<nav aria-label='Page navigation'>");
            var $ul = $("<ul class='pagination'></ul>");
            if( ! result.extend.pageInfo.hasPreviousPage){
                first_page.addClass("disabled").unbind("click");
                previous_page.addClass("disabled").unbind("click");
            }
            $ul.append(first_page).append(previous_page);
            $.each(navigatepageNums,function (index,page_number){
                var $li = $("<li><a href='#'>"+page_number+"</a></li>");
                if(page_number == result.extend.pageInfo.pageNum){
                    $li.addClass("active");
                }
                $li.click(function (){
                   to_page_num(page_number);
                });
                $ul.append($li);
            });
            if( ! result.extend.pageInfo.hasNextPage){
                last_page.addClass("disabled").unbind("click");
                next_page.addClass("disabled").unbind("click");
            }
            $ul.append(next_page).append(last_page);
            $nav.append($ul).appendTo("#page_info_nums");
        }
        //构建部门信息
        function build_dep(result){
            $(".department").empty();
            var deps = result.extend.deps;
            if (deps==null){
                $(".department").append($("<option>暂时还没有部门</option>"));
            }else {
                $.each(deps, function (index, item) {
                    $(".department").append($("<option>" + item.deprName + "</option>").attr("value",item.deptId));
                });
            }
        }
        //显示校验信息
        function show_check_msg(ele,status,ele_err,msg){
            //ele表示要设置的标签，status表示状态，成功或失败，msg表示要显示的信息 ele_err表示要显示错误信息的标签
                $(ele).parent().removeClass("has-success has-warning  has-error");
                status == "false" ?
                    $(ele).parent().addClass(" has-error")
                    : $(ele).parent().addClass(" has-success");
                $(ele_err).text(msg);
        }
        function email_check(ele,err_ele){
            var email = $(ele).val();
            var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){//不合法
                show_check_msg(ele,"false",err_ele,"邮箱不合法");
                return false;
            }else {
                show_check_msg(ele,"true",err_ele,"");
            }
        }
        function name_check(ele,err_ele){
            if($(ele).attr("name_flag")=="false"){return false;}
            var name = $("#empName").val();
            //可以为5-16位的a-zA-Z0-9_-，也可以为2-5个中文
            var regName=/(^[a-zA-Z0-9_-]{5,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            if(!regName.test(name)){//不合法
                show_check_msg(ele,"false",err_ele,"用户名不合法");
                return false;
            }else {
                show_check_msg(ele,"true",err_ele,"");
            }
        }
        //校验员工信息
        function emp_check(){
            if (name_check("#empName","#name_errorMsg") == false){
                return false;
            }
            if (email_check("#email","#email_errorMsg")== false){
                return false;
            }
            return true;
        }

    </script>
</head>
<body>
<!-- 修改员工模态框 -->
<div class="modal fade" id="update_emp_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >修改员工</h4>
            </div>
            <div class="modal-body">
                <%--                添加员工表单--%>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名：</label>
                        <div class="col-sm-10">
                            <label  class="control-label" id="update_empName" ></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">邮箱：</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="update_email" placeholder="Email">
                            <span id='update_email_errorMsg' style=" color:#595959"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别：</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="boy_radio" value="B"  > 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="girl_radio" value="G"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门：</label>
                        <div class="col-sm-4">
                            <%--                            提交dId即可，后台根据dId查询--%>
                            <select class="form-control department" id="deps" name="dId" ></select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>
                <button type="button" class="btn btn-primary" id="update_emp_btn">保存修改</button>
            </div>
        </div>
    </div>
</div>
<!-- 添加员工模态框 -->
<div class="modal fade" id="add_emp_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
<%--                添加员工表单--%>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名：</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="empName" id="empName" placeholder="姓名">
                            <span id='name_errorMsg' style=" color:#595959"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">邮箱：</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="email" placeholder="Email">
                            <span id='email_errorMsg' style=" color:#595959"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别：</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="B" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender"  value="G"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门：</label>
                        <div class="col-sm-4">
<%--                            提交dId即可，后台根据dId查询--%>
                            <select class="form-control department" name="dId" ></select>
                        </div>
                    </div>

            </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>
                <button type="button" class="btn btn-primary" id="save_emp_btn">保存</button>
            </div>
        </div>
    </div>
</div>
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
            <button class="btn btn-primary" id="add_emp"  >
                <span class="glyphicon glyphicon glyphicon-plus " aria-hidden="true"></span>
                新增
            </button>
            <button class="btn btn-danger" id="del_emps" >
                <span class="glyphicon glyphicon glyphicon-trash" aria-hidden="true"></span>
                删除
            </button>
        </div>
    </div>
    <%--    显示信息--%>
    <div class="row">
        <table class="table table-hover" id="emps_table">
            <thead>
            <tr class="success">
                <th>
                    <input type="checkbox" id="checkAll">
                </th>
                <th>#</th>
                <th>empName</th>
                <th>Gender</th>
                <th>Email</th>
                <th>DeptName</th>
                <th>操作</th>
            </tr>
            </thead>
            </tbody>

            <tbody>

        </table>
    </div>
    <%--    分页--%>
    <div class="row">
        <%--            文字信息--%>
        <div class="col-md-6" id="page_info_area">
<%--            当前${pageInfo.pageNum}页.总${pageInfo.pages}页.总${pageInfo.total}条记录--%>
        </div>
        <%--    分页条信息--%>
        <div class="col-md-6" id="page_info_nums">

        </div>

    </div>
</div>
</body>
</html>
