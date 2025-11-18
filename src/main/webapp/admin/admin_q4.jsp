<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q4: 인벤토리 검색</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 900px; margin: auto; }
    table { border-collapse: collapse; width: 100%; margin-top: 15px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
    .search-box { margin-bottom: 20px; padding: 15px; border: 1px solid #ccc; background-color: #f9f9f9; }
    .form-row { margin-bottom: 10px; }
    label { display: inline-block; width: 100px; font-weight: bold; }
</style>
</head>
<body>
<div class="container">
<%
    String userIdParam = request.getParameter("user_id");
    String itemNameParam = request.getParameter("item_name");

    String searchUserId = (userIdParam != null) ? userIdParam : "";
    String searchItemName = (itemNameParam != null) ? itemNameParam : "";
%>
    <h2>Q4: 사용자 인벤토리 검색</h2>
    
    <div class="search-box">
        <form action="admin_q4.jsp" method="get">
            <div class="form-row">
                <label>사용자 ID:</label>
                <input type="text" name="user_id" value="<%=searchUserId%>" placeholder="ID 포함 검색">
            </div>
            <div class="form-row">
                <label>아이템명:</label>
                <input type="text" name="item_name" value="<%=searchItemName%>" placeholder="아이템명 포함 검색">
            </div>
            <div class="form-row">
                <input type="submit" value="검색하기">
            </div>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>Item Name</th>
                <th>Category Name</th>
                <th>Quantity</th>
                <th>Conditions</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT INV.UserID, I.Name AS ItemName, C.Name AS CategoryName, INV.Quantity, INV.Conditions "
               + "FROM INVENTORY INV, ITEM I, CATEGORY C "
               + "WHERE INV.ItemID = I.ItemID "
               + "  AND I.CategoryID = C.CategoryID "
               + "  AND INV.UserID LIKE ? "
               + "  AND I.Name LIKE ?";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, "%" + searchUserId + "%");
        pstmt.setString(2, "%" + searchItemName + "%");
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("UserID") %></td>
                <td><%= rs.getString("ItemName") %></td>
                <td><%= rs.getString("CategoryName") %></td>
                <td><%= rs.getInt("Quantity") %></td>
                <td><%= rs.getString("Conditions") %></td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='5'>DB 오류: " + e.getMessage() + "</td></tr>");
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