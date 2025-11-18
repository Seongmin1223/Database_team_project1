<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q12: 등급별 즐겨찾기 조회</title>
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
    String tierParam = request.getParameter("tier_name");
    String searchTier = (tierParam != null) ? tierParam : "Diamond"; 
%>
    <h2>Q12: 특정 등급(Tier) 사용자의 즐겨찾기 목록</h2>
    
    <div class="search-box">
        <form action="admin_q12.jsp" method="get">
            등급(Tier) 입력: 
            <input type="text" name="tier_name" value="<%=searchTier%>" placeholder="예: Diamond, Gold">
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>Auction ID</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT DISTINCT F.UserID, F.AuctionID "
               + "FROM FAVORITE F "
               + "WHERE F.UserID IN ( "
               + "    SELECT U.UserID "
               + "    FROM USERS U "
               + "    WHERE U.Tier = ? "
               + ")";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, searchTier);
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("UserID") %></td>
                <td><%= rs.getString("AuctionID") %></td>
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