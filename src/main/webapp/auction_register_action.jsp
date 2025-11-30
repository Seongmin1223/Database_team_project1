<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, TeamPrj.DBConnection" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) { response.sendRedirect("login.html"); return; }

    int invenId = Integer.parseInt(request.getParameter("invenId"));
    int itemId = Integer.parseInt(request.getParameter("itemId"));
    long startPrice = Long.parseLong(request.getParameter("startPrice"));
    int duration = Integer.parseInt(request.getParameter("durationHours"));

    Connection conn = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    PreparedStatement ps3 = null;
    PreparedStatement ps4 = null;
    ResultSet rs = null;

    int deleted = 0;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        String sqlUpdate = "UPDATE INVENTORY SET Quantity = Quantity - 1 WHERE InventoryID = ? AND UserID = ? AND Quantity > 0";
        pstmt = conn.prepareStatement(sqlUpdate);
        pstmt.setInt(1, invenId);
        pstmt.setInt(2, userId);
        int updated = pstmt.executeUpdate();

        // 존재하지 않는 경우
        if (updated == 0){
            conn.rollback();
            out.println("<script>alert('아이템 수량이 부족합니다.'); history.back();</script>");
            return;
        }

        String sqlInsert = "INSERT INTO AUCTION (AUCTIONID, START_PRICE, STARTTIME, ENDTIME, CURRENTHIGHESTPRICE, ITEMID, SELLERID, REGISTERINVENTORYID) " +
                        "VALUES (AUCTION_SEQ.NEXTVAL, ?, SYSDATE, SYSDATE + (?/24), ?, ?, ?, ?)";

        pstmt = conn.prepareStatement(sqlInsert);
        pstmt.setLong(1, startPrice);
        pstmt.setInt(2, duration);
        pstmt.setLong(3, startPrice);
        pstmt.setInt(4, itemId);
        pstmt.setString(5, userId);
        pstmt.setInt(6, invenId);
        pstmt.executeUpdate();
        pstmt.close();
        
        String sqlDeleteZero =
            "DELETE FROM INVENTORY " +
            " WHERE InventoryID = ? " +
            "   AND UserID = ? " +
            "   AND Quantity = 0";

        pstmt = conn.prepareStatement(sqlDeleteZero);
        pstmt.setInt(1, invenId);
        pstmt.setString(2, userId);
        pstmt.executeUpdate();
        pstmt.close();

        conn.commit();

        out.println("<script>alert('경매 등록이 완료되었습니다!'); location.href='show_my_registered_item_list_action.jsp';</script>");

    } catch(Exception e) {
        e.printStackTrace();
        try{if (conn != null) conn.rollback();} catch(Exception ignore) {}
        out.println("<script>alert('등록 중 오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        try{if(rs!=null) rs.close();} catch(Exception ignore){}
        try{if(pstmt!=null) pstmt.close(); } catch(Exception ignore){}
        try{if(conn!=null) conn.setAutoCommit(true); conn.close(); } catch(Exception ignore){}
    }
%>