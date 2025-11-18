<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q10: 즐겨찾기된 경매 조회</title>
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
    String sellerIdParam = request.getParameter("seller_id");
    String searchSellerId = (sellerIdParam != null) ? sellerIdParam : "";
%>
    <h2>Q10: 즐겨찾기가 등록된 경매 조회</h2>
    
    <div class="search-box">
        <form action="admin_q10.jsp" method="get">
            판매자 ID: 
            <input type="text" name="seller_id" value="<%=searchSellerId%>" placeholder="판매자 ID 포함 검색">
            <input type="submit" value="검색">
        </form>
        <p><small>* 아무것도 입력하지 않으면 즐겨찾기가 있는 모든 경매가 조회됩니다.</small></p>
    </div>

    <table>
        <thead>
            <tr>
                <th>Auction ID</th>
                <th>Item ID</th>
                <th>Seller ID</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT A.AuctionID, A.ItemID, A.SellerID "
               + "FROM AUCTION A "
               + "WHERE EXISTS ( "
               + "  SELECT 1 "
               + "  FROM FAVORITE F "
               + "  WHERE F.AuctionID = A.AuctionID "
               + ") "
               + "AND A.SellerID LIKE ?";

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + searchSellerId + "%");
        
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("AuctionID") %></td>
                <td><%= rs.getString("ItemID") %></td>
                <td><%= rs.getString("SellerID") %></td>
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