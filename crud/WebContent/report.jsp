<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="checkLogin.jsp" %>
<%@ page import="com.newsclan.crud.*,java.sql.*"%>
<html>
<link rel=stylesheet href='../bootstrap/css/bootstrap.min.css' type='text/css'>

<body background="bg2.jpg" >
<div width=80%>

<%
	int user_id=(Integer)session.getAttribute("user_id");
	if (!(
			Auth.isAdmin(user_id)||
			Auth.checkPrivilegeForRightOfTable(user_id, "", "report")
		))
		return;

	String sql = (String) session.getAttribute("sql");
	String spage=request.getParameter("page");
	if (spage==null) spage="0";
	int ipage=Integer.parseInt(spage);
	%>
	<a class='btn btn-success' target=_blank href="export.jsp">导出</a> 
	<%if(ipage>0){ %>
		<a class='btn' href="#" onclick="$('#main').load('report.jsp?page=<%=(ipage-1)%>');">上一页</a>
	<%} %>
	<a class='btn' href="#" onclick="$('#main').load('report.jsp?page=<%=(ipage+1)%>');">下一页</a>
	<a class='btn' href="#" onclick="$('#main').load('report.jsp?page=<%=(ipage)%>');">刷新</a>
	
	<table class="table table-striped"  >
	
	<% 
	if(sql.contains("order by")){
		sql +=" limit "+(ipage*16)+",16";
	}else{
		sql +=" order by id desc limit "+(ipage*16)+",16";
	}
	Field[] fds = DAO.getFields(sql);
	Connection conn = DB.getConnection();
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	out.print("<tr>");
	for (int i = 0; i < fds.length&&i<10; i++) {
		out.print("<th>");
		out.print(fds[i].label);
		out.println("</th>");
		
	}
	String value="";
	out.println("</tr>");
	while (rs.next()) {
		out.print("<tr>");
		
		for (int i = 0; i < fds.length&&i<10; i++) {
			out.println("<td>");
			value=rs.getString(i + 1);
			if(value!=null)out.print(value);
			out.println("</td>");
		}
		out.println("</tr>");
		out.println();

	}
	
	DB.close(conn);
%>
</table>
</div>

</body></html>
