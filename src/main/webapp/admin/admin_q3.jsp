<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q3: 입찰 내역 검색</title>
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
    String bidderNameParam = request.getParameter("bidder_name");
    String itemNameParam = request.getParameter("item_name");
    String minBidParam = request.getParameter("min_bid");

    String searchBidder = (bidderNameParam != null) ? bidderNameParam : "";
    String searchItem = (itemNameParam != null) ? itemNameParam : "";
    long minBid = 0;
    
    if (minBidParam != null && !minBidParam.isEmpty()) {
        try {
            minBid = Long.parseLong(minBidParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q3: 입찰 내역 상세 검색</h2>
    
    <div class="search-box">
        <form action="admin_q3.jsp" method="get">
            <div class="form-row">
                <label>입찰자명:</label>
                <input type="text" name="bidder_name" value="<%=searchBidder%>" placeholder="이름 포함 검색">
            </div>
            <div class="form-row">
                <label>아이템명:</label>
                <input type="text" name="item_name" value="<%=searchItem%>" placeholder="아이템명 포함 검색">
            </div>
            <div class="form-row">
                <label>최소입찰가:</label>
                <input type="number" name="min_bid" value="<%=minBid%>" placeholder="0"> 원 이상
            </div>
            <div class="form-row">
                <input type="submit" value="검색하기">
            </div>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Bidder Name</th>
                <th>Item Name</th>
                <th>Bid Amount</th>
                <th>Bid Time</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT U.Name AS BidderName, I.Name AS ItemName, BR.BidAmount, BR.BidTime "
               + "FROM BIDDING_RECORD BR, AUCTION A, ITEM I, USERS U "
               + "WHERE BR.AuctionID = A.AuctionID "
               + "  AND A.ItemID = I.ItemID "
               + "  AND BR.BidderID = U.UserID "
               + "  AND U.Name LIKE ? "
               + "  AND I.Name LIKE ? "
               + "  AND BR.BidAmount >= ?";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, "%" + searchBidder + "%");
        pstmt.setString(2, "%" + searchItem + "%");
        pstmt.setLong(3, minBid);
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("BidderName") %></td>
                <td><%= rs.getString("ItemName") %></td>
                <td><%= rs.getLong("BidAmount") %></td>
                <td><%= rs.getString("BidTime") %></td>
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