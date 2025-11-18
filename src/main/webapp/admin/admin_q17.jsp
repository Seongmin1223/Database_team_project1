<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q17: 셀러 매출 랭킹</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 900px; margin: auto; }
    table { border-collapse: collapse; width: 100%; margin-top: 15px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
    .search-box { margin-bottom: 20px; padding: 15px; border: 1px solid #ccc; background-color: #f9f9f9; }
    .form-row { margin-bottom: 10px; }
</style>
</head>
<body>
<div class="container">
<%
    String nameParam = request.getParameter("seller_name");
    String limitParam = request.getParameter("limit_n");

    String searchName = (nameParam != null) ? nameParam : "";
    int limitN = 10;
    
    if (limitParam != null && !limitParam.isEmpty()) {
        try {
            limitN = Integer.parseInt(limitParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q17: 셀러별 총 매출 랭킹 (TOP <%=limitN%>)</h2>
    
    <div class="search-box">
        <form action="admin_q17.jsp" method="get">
            <div class="form-row">
                판매자 이름: 
                <input type="text" name="seller_name" value="<%=searchName%>" placeholder="이름 포함 검색">
            </div>
            <div class="form-row">
                출력 인원수: 
                <input type="number" name="limit_n" value="<%=limitN%>" min="1" max="100"> 명
                <input type="submit" value="랭킹 조회">
            </div>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Rank</th>
                <th>Seller ID</th>
                <th>Seller Name</th>
                <th>Total Revenue</th>
                <th>Num Trades</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT U.UserID AS SellerID, U.Name, SUM(T.Final_Price) AS TotalRevenue, COUNT(*) AS NumTrades "
               + "FROM TRANSACTION T "
               + "JOIN USERS U ON U.UserID = T.SellerID "
               + "WHERE U.Name LIKE ? "
               + "GROUP BY U.UserID, U.Name "
               + "ORDER BY TotalRevenue DESC "
               + "FETCH FIRST ? ROWS ONLY";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, "%" + searchName + "%");
        pstmt.setInt(2, limitN);
        
        rs = pstmt.executeQuery();
        
        int rank = 1;
        while(rs.next()) {
%>
            <tr>
                <td><%= rank++ %></td>
                <td><%= rs.getString("SellerID") %></td>
                <td><%= rs.getString("Name") %></td>
                <td><%= rs.getLong("TotalRevenue") %></td>
                <td><%= rs.getInt("NumTrades") %></td>
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