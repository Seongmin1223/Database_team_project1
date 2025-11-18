<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q9: 입찰 경험 사용자 조회</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 800px; margin: auto; }
    table { border-collapse: collapse; width: 100%; margin-top: 15px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
    .search-box { margin-bottom: 20px; padding: 15px; border: 1px solid #ccc; background-color: #f9f9f9; }
</style>
</head>
<body>
<div class="container">
<%
    String minAmountParam = request.getParameter("min_amount");
    long minAmount = 0;
    if (minAmountParam != null && !minAmountParam.isEmpty()) {
        try {
            minAmount = Long.parseLong(minAmountParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q9: 입찰 경험이 있는 사용자 조회</h2>
    
    <div class="search-box">
        <form action="admin_q9.jsp" method="get">
            한 번이라도 
            <input type="number" name="min_amount" value="<%=minAmount%>" placeholder="0">
            원 이상 입찰한 사용자 찾기
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>User Name</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT U.UserID, U.Name "
               + "FROM USERS U "
               + "WHERE EXISTS ( "
               + "  SELECT 1 "
               + "  FROM BIDDING_RECORD BR "
               + "  WHERE BR.BidderID = U.UserID "
               + "    AND BR.BidAmount >= ? "
               + ")";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setLong(1, minAmount);
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("UserID") %></td>
                <td><%= rs.getString("Name") %></td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='2'>DB 오류: " + e.getMessage() + "</td></tr>");
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