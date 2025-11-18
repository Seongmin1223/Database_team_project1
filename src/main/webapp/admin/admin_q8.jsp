<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q8: 낙찰된 아이템의 셀러 조회</title>
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
    String itemNameParam = request.getParameter("item_name");
    String searchItemName = (itemNameParam != null) ? itemNameParam : "";
%>
    <h2>Q8: 특정 아이템을 판매(낙찰)한 셀러 목록</h2>
    
    <div class="search-box">
        <form action="admin_q8.jsp" method="get">
            아이템 명: 
            <input type="text" name="item_name" value="<%=searchItemName%>" placeholder="아이템 이름 포함 검색">
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Seller ID</th>
                <th>Seller Name</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT DISTINCT U.UserID, U.Name "
               + "FROM USERS U "
               + "WHERE U.UserID IN ( "
               + "  SELECT T.SellerID "
               + "  FROM TRANSACTION T "
               + "  JOIN AUCTION A ON T.AuctionID = A.AuctionID "
               + "  JOIN ITEM I ON A.ItemID = I.ItemID "
               + "  WHERE I.Name LIKE ? "
               + ")";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + searchItemName + "%");
        
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