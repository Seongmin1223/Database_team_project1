<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q15: 고액 입찰 랭킹</title>
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
    String itemParam = request.getParameter("item_name");
    String limitParam = request.getParameter("limit_n");

    String searchItem = (itemParam != null) ? itemParam : "";
    int limitN = 20;
    
    if (limitParam != null && !limitParam.isEmpty()) {
        try {
            limitN = Integer.parseInt(limitParam);
        } catch (NumberFormatException e) {}
    }
%>
    <h2>Q15: 입찰 금액 랭킹 (TOP <%=limitN%>)</h2>
    
    <div class="search-box">
        <form action="admin_q15.jsp" method="get">
            <div class="form-row">
                아이템 이름 필터: 
                <input type="text" name="item_name" value="<%=searchItem%>" placeholder="전체 조회">
            </div>
            <div class="form-row">
                조회할 개수: 
                <input type="number" name="limit_n" value="<%=limitN%>" min="1" max="1000"> 개
                <input type="submit" value="랭킹 조회">
            </div>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Rank</th>
                <th>Item Name</th>
                <th>Bidder Name</th>
                <th>Bid Amount</th>
                <th>Bid Time</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT I.Name AS ItemName, U.Name AS BidderName, BR.BidAmount, BR.BidTime "
               + "FROM BIDDING_RECORD BR, AUCTION A, ITEM I, USERS U "
               + "WHERE BR.AuctionID = A.AuctionID "
               + "  AND A.ItemID     = I.ItemID "
               + "  AND BR.BidderID  = U.UserID "
               + "  AND I.Name LIKE ? "
               + "ORDER BY BR.BidAmount DESC, BR.BidTime DESC "
               + "FETCH FIRST ? ROWS ONLY";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, "%" + searchItem + "%");
        pstmt.setInt(2, limitN);
        
        rs = pstmt.executeQuery();
        
        int rank = 1;
        while(rs.next()) {
%>
            <tr>
                <td><%= rank++ %></td>
                <td><%= rs.getString("ItemName") %></td>
                <td><%= rs.getString("BidderName") %></td>
                <td><%= rs.getLong("BidAmount") %></td>
                <td><%= rs.getString("BidTime") %></td>
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