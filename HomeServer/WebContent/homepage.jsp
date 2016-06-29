<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dbconnectionlib.User" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<link href="css/homepage.css" rel="stylesheet" type="text/css" /> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Learn in 60 Seconds</title>
<link rel="stylesheet" type="text/css" href="css/organicfoodicons.css" />
	<!-- demo styles -->
<link rel="stylesheet" type="text/css" href="css/default.css">
<!-- menu styles -->
<link rel="stylesheet" type="text/css" href="css/component.css" />
<script src="js/modernizr-custom.js"></script>

</head>
<body>
	 
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
	 
	<div class="container">
		<!-- Blueprint header -->
		<header class="bp-header cf">
			<div class="dummy-logo">
				<div class="dummy-icon foodicon foodicon--coconut"></div>
				<h2 class="dummy-heading">学一手</h2>
			</div>
			<div class="bp-header__main">
				
			</div>
		</header>
		<button class="action action--open" aria-label="Open Menu"><span class="icon icon--menu"></span></button>
		<nav id="ml-menu" class="menu">
			<button class="action action--close" aria-label="Close Menu"><span class="icon icon--cross"></span></button>
			<div class="menu__wrap">
				<ul data-menu="main" class="menu__level">
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-1" href="#">类别1</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-2" href="#">类别2</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-3" href="#">类别3</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-4" href="#">类别4</a></li>
				</ul>
				<!-- Submenu 1 -->
				<ul data-menu="submenu-1" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Stalk Vegetables</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Roots &amp; Seeds</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Cabbages</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Salad Greens</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Mushrooms</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-1-1" href="#">Sale %</a></li>
				</ul>
				<!-- Submenu 1-1 -->
				<ul data-menu="submenu-1-1" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Fair Trade Roots</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Dried Veggies</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Our Brand</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Homemade</a></li>
				</ul>
				<!-- Submenu 2 -->
				<ul data-menu="submenu-2" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Citrus Fruits</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Berries</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-2-1" href="#">Special Selection</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Tropical Fruits</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Melons</a></li>
				</ul>
				<!-- Submenu 2-1 -->
				<ul data-menu="submenu-2-1" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Exotic Mixes</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Wild Pick</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Vitamin Boosters</a></li>
				</ul>
				<!-- Submenu 3 -->
				<ul data-menu="submenu-3" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Buckwheat</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Millet</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Quinoa</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Wild Rice</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Durum Wheat</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-3-1" href="#">Promo Packs</a></li>
				</ul>
				<!-- Submenu 3-1 -->
				<ul data-menu="submenu-3-1" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Starter Kit</a></li>
					<li class="menu__item"><a class="menu__link" href="#">The Essential 8</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Bolivian Secrets</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Flour Packs</a></li>
				</ul>
				<!-- Submenu 4 -->
				<ul data-menu="submenu-4" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Grain Mylks</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Seed Mylks</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Nut Mylks</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Nutri Drinks</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-4-1" href="#">Selection</a></li>
				</ul>
				<!-- Submenu 4-1 -->
				<ul data-menu="submenu-4-1" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="#">Nut Mylk Packs</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Amino Acid Heaven</a></li>
					<li class="menu__item"><a class="menu__link" href="#">Allergy Free</a></li>
				</ul>
			</div>
		</nav>
		<div>
			<ul id="nav">
			    <li><a href="http://localhost:8080/HomeServer/homepage.jsp">首页</a></li> 
			    <li><a href="Upload.jsp">视频上传</a></li>
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
			    <li><a href="UserPage.jsp"><%=showName%></a></li> 
				<% } %> 
				
			    <li><input type="text">搜索</li>
			</ul>
		</div>
		<div class="content">
		
			<p class="info">热门视频</p>
			<ul class="products">
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
				<li class="product">
					<div class="foodicon foodicon--broccoli"></div>
				</li>
			</ul>
			<!-- Ajax loaded content here -->
		</div>
	</div>
	
	<br>
	
	<a href="#">links</a>
	<form action="sqltest" method="post">
	<input type="submit" value="测试数据库连接" />
	</form>
	<button>联系站长</button>
	
	<!-- /view -->
	<script src="js/classie.js"></script>
	<script src="js/dummydata.js"></script>
	<script src="js/main.js"></script>
	<script>
	(function() {
		var menuEl = document.getElementById('ml-menu'),
			mlmenu = new MLMenu(menuEl, {
				// breadcrumbsCtrl : true, // show breadcrumbs
				// initialBreadcrumb : 'all', // initial breadcrumb text
				backCtrl : false, // show back button
				// itemsDelayInterval : 60, // delay between each menu item sliding animation
				onItemClick: loadDummyData // callback: item that doesn´t have a submenu gets clicked - onItemClick([event], [inner HTML of the clicked item])
			});
		
		// mobile menu toggle
		var openMenuCtrl = document.querySelector('.action--open'),
			closeMenuCtrl = document.querySelector('.action--close');

		openMenuCtrl.addEventListener('click', openMenu);
		closeMenuCtrl.addEventListener('click', closeMenu);

		function openMenu() {
			classie.add(menuEl, 'menu--open');
		}

		function closeMenu() {
			classie.remove(menuEl, 'menu--open');
		}

		// simulate grid content loading
		var gridWrapper = document.querySelector('.content');

		function loadDummyData(ev, itemName) {
			ev.preventDefault();

			closeMenu();
			gridWrapper.innerHTML = '';
			classie.add(gridWrapper, 'content--loading');
			setTimeout(function() {
				classie.remove(gridWrapper, 'content--loading');
				gridWrapper.innerHTML = '<ul class="products">' + dummyData[itemName] + '<ul>';
			}, 700);
		}
	})();
	</script>
	
</body>
</html>