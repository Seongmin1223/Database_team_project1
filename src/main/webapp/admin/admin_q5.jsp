<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q5: 경매 통계 검색</title>
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
    String auctionIdParam = request.getParameter("auction_id");
    String searchAuctionId = (auctionIdParam != null) ? auctionIdParam : "";
%>
    <h2>Q5: 경매별 통계 검색</h2>
    
    <div class="search-box">
        <form action="admin_q5.jsp" method="get">
            <div class="form-row">
                Auction ID: 
                <input type="text" name="auction_id" value="<%=searchAuctionId%>" placeholder="ID 포함 검색">
                <input type="submit" value="검색">
            </div>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Auction ID</th>
                <th>Bid Count</th>
                <th>Max Bid</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT A.AuctionID, COUNT(*) AS BidCount, MAX(BR.BidAmount) AS MaxBid "
               + "FROM AUCTION A "
               + "JOIN BIDDING_RECORD BR ON BR.AuctionID = A.AuctionID "
               + "WHERE A.AuctionID LIKE ? "
               + "GROUP BY A.AuctionID";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + searchAuctionId + "%");
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("AuctionID") %></td>
                <td><%= rs.getInt("BidCount") %></td>
                <td><%= rs.getLong("MaxBid") %></td>
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