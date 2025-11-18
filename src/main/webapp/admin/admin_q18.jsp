<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q18: 카테고리별 평균 입찰가</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 800px; margin: auto; }
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
    String catParam = request.getParameter("category_name");
    String minAvgParam = request.getParameter("min_avg");

    String searchCat = (catParam != null) ? catParam : "";
    long minAvg = 0;
    
    if (minAvgParam != null && !minAvgParam.isEmpty()) {
        try {
            minAvg = Long.parseLong(minAvgParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q18: 카테고리별 평균 입찰가 순위</h2>
    
    <div class="search-box">
        <form action="admin_q18.jsp" method="get">
            <div class="form-row">
                카테고리명: 
                <input type="text" name="category_name" value="<%=searchCat%>" placeholder="이름 포함 검색">
            </div>
            <div class="form-row">
                평균 입찰가: 
                <input type="number" name="min_avg" value="<%=minAvg%>" placeholder="0"> 원 이상
                <input type="submit" value="조회">
            </div>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Rank</th>
                <th>Category ID</th>
                <th>Category Name</th>
                <th>Avg Bid Amount</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT C.CategoryID, C.Name AS CategoryName, ROUND(AVG(BR.BidAmount), 2) AS AvgBid "
               + "FROM BIDDING_RECORD BR "
               + "JOIN AUCTION A  ON A.AuctionID = BR.AuctionID "
               + "JOIN ITEM I     ON I.ItemID = A.ItemID "
               + "JOIN CATEGORY C ON C.CategoryID = I.CategoryID "
               + "WHERE C.Name LIKE ? "
               + "GROUP BY C.CategoryID, C.Name "
               + "HAVING AVG(BR.BidAmount) >= ? "
               + "ORDER BY AvgBid DESC";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, "%" + searchCat + "%");
        pstmt.setLong(2, minAvg);
        
        rs = pstmt.executeQuery();
        
        int rank = 1;
        while(rs.next()) {
%>
            <tr>
                <td><%= rank++ %></td>
                <td><%= rs.getString("CategoryID") %></td>
                <td><%= rs.getString("CategoryName") %></td>
                <td><%= rs.getDouble("AvgBid") %></td>
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