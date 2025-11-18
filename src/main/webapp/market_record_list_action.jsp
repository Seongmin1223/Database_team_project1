<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page language = "java" import = "java.sql.*, java.text.*, TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	Connection conn = DBConnection.getConnection();

	String item_id_4_2 = request.getParameter("item_id_4_2");
	String final_price_4_2 = request.getParameter("final_price_4_2");
	
	StringBuffer buf = new StringBuffer();
	buf.append("select IT.name, INV.conditions, MAR.TradeTime, MAR.FinalPrice ");
	buf.append("from market_history MAR join auction A on MAR.auctionid = A.auctionid join inventory INV on A.registerinventoryid = INV.inventoryid join Item IT on A.itemid = IT.itemid ");
	buf.append("where A.itemid = ? ");

	if("DEFAULT".equals(final_price_4_2)){
		
	}else{
		buf.append("order by MAR.FinalPrice ");
		buf.append(final_price_4_2);
	}
	
	PreparedStatement pstmt = conn.prepareStatement(buf.toString());
	pstmt.setString(1, item_id_4_2);
	
	ResultSet rs = pstmt.executeQuery();
	boolean hasTable = false;
	
	out.println("<table border = 1><th>ITEM_NAME</th><th>ITEM_CONDITION</th><th>TRADE_TIME</th><th>FINAL_PRICE</th>");
	while(rs.next()){
		hasTable = true;
		out.println("<tr>");
		out.println("<td>"+ rs.getString(1) + "</td>");
		out.println("<td>"+ rs.getString(2) + "</td>");
		out.println("<td>"+ rs.getString(3) + "</td>");	
		out.println("<td>"+ rs.getString(4) + "</td>");
		out.println("</tr>");
	}
	if (!hasTable){
		out.println("<tr><td>cannot found auction history</td></tr>");
	}
	out.println("</table>");
	conn.close();
	pstmt.close();
	rs.close();

%>

	
	
	
</body>
</html>
