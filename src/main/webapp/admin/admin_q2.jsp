<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.text.SimpleDateFormat" %>
<%@ page language="java" import="java.util.Date" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q2: 날짜별 종료 경매</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 800px; margin: auto; }
    table { border-collapse: collapse; width: 100%; margin-top: 15px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
    .form-input { padding: 5px; }
</style>
</head>
<body>
<div class="container">
<%
    String dateParam = request.getParameter("target_date");
    String targetDate = dateParam;

    if (targetDate == null || targetDate.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        targetDate = sdf.format(new Date());
    }
%>

    <h2>Q2: 날짜별 종료 경매 리스트</h2>
    
    <form action="admin_q2.jsp" method="get">
        종료 날짜 선택: 
        <input type="date" name="target_date" value="<%=targetDate%>" class="form-input">
        <input type="submit" value="조회">
    </form>
    <p>선택한 날짜: <strong><%= targetDate %></strong></p>

    <table>
        <thead>
            <tr>
                <th>AuctionID</th>
                <th>ItemID</th>
                <th>SellerID</th>
                <th>EndTime</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT AuctionID, ItemID, SellerID, EndTime "
               + "FROM AUCTION "
               + "WHERE TRUNC(EndTime) = TO_DATE(?, 'YYYY-MM-DD')";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, targetDate);
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("AuctionID") %></td>
                <td><%= rs.getString("ItemID") %></td>
                <td><%= rs.getString("SellerID") %></td>
                <td><%= rs.getString("EndTime") %></td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='4'>DB 오류: " + e.getMessage() + "</td></tr>");
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e){}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if(conn != null) try { conn.close(); } catch(Exception e){}
    }
%>
        </tbody>
    </table>
    <br>
    <a href="admin_menu.jsp">관리자 메뉴로 돌아가기</a>
</div>
</body>
</html>