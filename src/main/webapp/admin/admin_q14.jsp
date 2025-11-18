<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q14: 카테고리별 아이템 수 TOP N</title>
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
    String topNParam = request.getParameter("top_n");
    int topN = 5;
    if (topNParam != null && !topNParam.isEmpty()) {
        try {
            topN = Integer.parseInt(topNParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q14: 카테고리별 아이템 수 TOP <%=topN%></h2>
    
    <div class="search-box">
        <form action="admin_q14.jsp" method="get">
            상위 
            <input type="number" name="top_n" value="<%=topN%>" style="width: 50px;" min="1">
            개 카테고리 조회
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Rank</th>
                <th>Category Name</th>
                <th>Number of Items</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT * FROM ( "
               + "  SELECT C.Name AS CategoryName, COUNT(*) AS NumItems "
               + "  FROM CATEGORY C "
               + "  JOIN ITEM I ON I.CategoryID = C.CategoryID "
               + "  GROUP BY C.Name "
               + "  ORDER BY COUNT(*) DESC "
               + ") "
               + "WHERE ROWNUM <= ?";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, topN);
        
        rs = pstmt.executeQuery();
        
        int rank = 1;
        while(rs.next()) {
%>
            <tr>
                <td><%= rank++ %></td>
                <td><%= rs.getString("CategoryName") %></td>
                <td><%= rs.getInt("NumItems") %></td>
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