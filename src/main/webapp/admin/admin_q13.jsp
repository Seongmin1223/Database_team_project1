<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q13: 경매별 최고 입찰가 현황</title>
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
    String minBidParam = request.getParameter("min_bid");
    long minBid = 0;
    if (minBidParam != null && !minBidParam.isEmpty()) {
        try {
            minBid = Long.parseLong(minBidParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q13: 경매별 최고 입찰가 조회 (인라인 뷰)</h2>
    
    <div class="search-box">
        <form action="admin_q13.jsp" method="get">
            현재 최고 입찰가가 
            <input type="number" name="min_bid" value="<%=minBid%>" placeholder="0">
            원 이상인 경매 조회
            <input type="submit" value="검색">
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Auction ID</th>
                <th>Item ID</th>
                <th>Max Bid Amount</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT A.AuctionID, A.ItemID, M.MaxBid "
               + "FROM AUCTION A "
               + "JOIN ( "
               + "  SELECT AuctionID, MAX(BidAmount) AS MaxBid "
               + "  FROM BIDDING_RECORD "
               + "  GROUP BY AuctionID "
               + ") M ON M.AuctionID = A.AuctionID "
               + "WHERE M.MaxBid >= ?";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setLong(1, minBid);
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("AuctionID") %></td>
                <td><%= rs.getString("ItemID") %></td>
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