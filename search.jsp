<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
	//由于以后常用，故定义全局
	var XHR;
	function getKeyContent() {
		//得到输入值
		var content = document.getElementById("keyword");
		if (content.value == "") {
			clearContents();
			return;
		}
		//通过获取浏览器中xmlhttprequest对象实现ajax异步处理
		XHR = creatXHR();
		//通过XHR向服务器发送信息

		var url = "search?keyword=" + content.value;
		/* var url = "search"; */

		var words = "keyword=" + content.value;
		//true标示为异步处理，即 sent()方法后依然可以执行
		XHR.open("get", url, true);
		/* XHR.setRequestHeader("Content-Type",
				"application/x-www-form-urlencoded"); */
		//通过XHR状态码（0-4）确定服务器可以响应时执行回调
		//绑定回调函数
		XHR.onreadystatechange = callBack;

		XHR.send();
	}
	//获取到回调函数
	function callBack() {
		//标示请求成功可以响应
		if (XHR.readyState == 4) {
			//服务器连接成功
			if (XHR.status == 200) {
				//获取响应文本
				var result = XHR.responseText;
				//解析文本获取数据
				var json = eval("(" + result + ")");
				//获取数据后动态展示
				setContents(json);
			}
		}
	}
	//设置动态显示的页面数据
	function setContents(contents) {
		//清空原来的内容
		clearContents();
		//定位确定popDiv位置，并使其宽度与输入框一致
		setLocation();
		//获取内容的长度
		var size = contents.length;
		for (var i = 0; i < size; i++) {
			//获取到内容
			var nextNode = contents[i];
			var tr = document.createElement("tr");
			var td = document.createElement("td");

			//鼠标滑入的动作
			td.onmouseover = function() {
				this.className = 'mouseOver';
			};
			//鼠标滑出的动作
			td.onmouseout = function() {
				this.className = 'mouseOut';
			};
			//将td中的字段放入文本框
			td.onmousedown = function() {
				var content = this.innerText;
				var keyword = document.getElementById("keyword").value;
				keyword = content;
				//点击并跳转
				window.location.href = "https://www.baidu.com/s?wd=" + keyword;
			};

			//一层一层将数据放入节点容器
			//创建文本内容
			var text = document.createTextNode(nextNode);
			//将文本内容放入列中
			td.appendChild(text);
			//将列内容放入行中
			tr.appendChild(td);
			//将行内容放入tbody中
			document.getElementById("table_content_body").appendChild(tr);
		}
	}
	//定位并一致的具体操作
	function setLocation() {
		//获取输入框的位置和宽度，并确认所需相应材料
		var keyword = document.getElementById("keyword");
		var width = keyword.offsetWidth;
		//将popDiv调整
		var popDiv = document.getElementById("popDiv");
		popDiv.style.border = "black 1px solid";
		popDiv.style.width = width - 2 + "px";

		document.getElementById("table_content").style.width = width - 2 + "px";
	}
	//获取到XHR
	function creatXHR() {
		var XHR;
		if (window.XMLHttpRequest) {
			XHR = new XMLHttpRequest();
		}
		return XHR;
	}

	function clearContents() {
		var contents = document.getElementById("table_content_body");
		var size = contents.childNodes.length;
		for (var i = size - 1; i >= 0; i--) {
			contents.removeChild(contents.childNodes[i]);
		}
	}
	//失去焦点时清空
	function keyBlur() {
		clearContents();
	}
	function redirect() {
		var kvalue = document.getElementById("keyword").value;
		window.location.href = "https://www.baidu.com/s?wd=" + kvalue;
	}
</script>
<style type="text/css">
#xjDiv {
	position: relative;
	top: 50%;
	left: 50%;
	margin-top: 200px;
}

#popDiv {
	margin-top: -4px;
}

#popDiv table_content {
	position: relative;
	margin-top: -4px;
}

.mouseOver {
	background: #FFAFAF;
}

.mouseOut {
	background: #00000;
}
</style>

<title>智能搜索</title>
</head>
<body>
	<div id="xjDiv">
		<input type="text" id="keyword" name="keyword"
			onkeyup="getKeyContent()" onblur="keyBlur()"
			onfocus="getKeyContent()"> <input type="button"
			onclick="redirect()" value="xjSearch">
		<!-- 动态展示区域 -->
		<div id="popDiv">
			<table id="table_content" border="0" cellpadding="0" cellspacing="0">
				<tbody id="table_content_body">
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>