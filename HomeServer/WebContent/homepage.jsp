<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dbconnectionlib.User" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<link href="css/homepage.css" rel="stylesheet" type="text/css" /> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Learn in 60 Seconds</title>
</head>
<body>
	<h1 align="center">学一手</h1><li align="center">利用碎片时间学习生活小技能</li><br>
	
	<ul id="nav"> 
	
	<%
		User currentUser = (User)session.getAttribute("User"); 
		String name = "please login";
		int auth = 0;
		int state = 0;
		String showName = " ";
		String welcomeInfo = "";
		
		if(currentUser!=null){
			name= currentUser.getUserName();
			auth= currentUser.getauth();
			showName = name;
			welcomeInfo="Welcome!";
		}
						
	%>
    <li><a href="#">首页</a></li> 
    <li><a href="http://">视频上传</a></li>
    <% if(currentUser==null){%>
    <li><a href="#">
    <form action="login" method="post">
		用户名<input type="text" name="username">
		密码<input type="text" name="password" />
	<input type="submit" value="登录" />
	</form>
	<li><a href="#">注册</a></li>
    </a></li>
    <% }else{ %>
    <li><a href="#"><%=showName%></a></li> 
	<% } %> 
	
    <li><input type="text">搜索</li>
	</ul> 
	
	
	<br>
	<div>
		<h2>视频列表</h2>
	</div>
	
	<a href="#">links</a>
	<form action="sqltest" method="post">
	<input type="submit" value="测试数据库连接" />
	</form>
	<button>联系站长</button>
	
</body>
</html>