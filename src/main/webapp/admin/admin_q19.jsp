<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q19: 전체 거래 참여자 목록</title>
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
    String userIdParam = request.getParameter("user_id");
    String searchUserId = (userIdParam != null) ? userIdParam : "";
%>
    <h2>Q19: 거래 내역이 있는 사용자 (UNION)</h2>
    <p>구매자 또는 판매자로 활동한 적이 있는 모든 사용자 목록입니다.</p>
    
    <div class="search-box">
        <form action="admin_q19.jsp" method="get">
            사용자 ID 검색: 
            <input type="text" name="user_id" value="<%=searchUserId%>" placeholder="ID 포함 검색">
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>User ID (Buyer or Seller)</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT BuyerID AS UserID FROM TRANSACTION WHERE BuyerID LIKE ? "
               + "UNION "
               + "SELECT SellerID AS UserID FROM TRANSACTION WHERE SellerID LIKE ?";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, "%" + searchUserId + "%");
        pstmt.setString(2, "%" + searchUserId + "%");
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("UserID") %></td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='1'>DB 오류: " + e.getMessage() + "</td></tr>");
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