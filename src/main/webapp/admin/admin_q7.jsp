<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q7: 카테고리 평균 이상 아이템</title>
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
    String categoryParam = request.getParameter("category_name");
    String searchCategory = (categoryParam != null) ? categoryParam : "";
%>
    <h2>Q7: 카테고리 평균가보다 비싼 아이템</h2>
    
    <div class="search-box">
        <form action="admin_q7.jsp" method="get">
            카테고리 명: 
            <input type="text" name="category_name" value="<%=searchCategory%>" placeholder="카테고리 이름 입력">
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Item ID</th>
                <th>Item Name</th>
                <th>Base Price</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT I.ItemID, I.Name, I.BasePrice "
               + "FROM ITEM I "
               + "JOIN CATEGORY C ON I.CategoryID = C.CategoryID "
               + "WHERE C.Name LIKE ? "
               + "  AND I.BasePrice > ("
               + "      SELECT AVG(I2.BasePrice) "
               + "      FROM ITEM I2 "
               + "      WHERE I2.CategoryID = I.CategoryID"
               + "  )";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + searchCategory + "%");
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("ItemID") %></td>
                <td><%= rs.getString("Name") %></td>
                <td><%= rs.getLong("BasePrice") %></td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='3'>DB 오류: " + e.getMessage() + "</td></tr>");
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