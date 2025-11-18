<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.util.ArrayList" %>
<%@ include file="admin_check.jsp" %>
<%@ page language="java" import="TeamPrj.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q11: 카테고리별 아이템 조회</title>
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
    String categoryParam = request.getParameter("category_list");
    String inputStr = (categoryParam != null) ? categoryParam : "Spear, Mace"; // 기본값 설정
    
    String[] rawCategories = inputStr.split(",");
    ArrayList<String> categoryList = new ArrayList<>();
    for(String s : rawCategories) {
        if(!s.trim().isEmpty()) {
            categoryList.add(s.trim());
        }
    }
%>
    <h2>Q11: 특정 카테고리 아이템 조회 (IN 연산)</h2>
    
    <div class="search-box">
        <form action="admin_q11.jsp" method="get">
            검색할 카테고리 (콤마로 구분): <br>
            <input type="text" name="category_list" value="<%=inputStr%>" style="width: 300px;" placeholder="예: Spear, Mace, Sword">
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
    if (categoryList.size() > 0) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT I.ItemID, I.Name, I.BasePrice ");
        sqlBuilder.append("FROM ITEM I ");
        sqlBuilder.append("WHERE I.CategoryID IN ( ");
        sqlBuilder.append("  SELECT C.CategoryID ");
        sqlBuilder.append("  FROM CATEGORY C ");
        sqlBuilder.append("  WHERE C.Name IN (");
        
        for(int i=0; i<categoryList.size(); i++) {
            sqlBuilder.append("?");
            if(i < categoryList.size() - 1) {
                sqlBuilder.append(", ");
            }
        }
        sqlBuilder.append("  ) ");
        sqlBuilder.append(")");

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            
            for(int i=0; i<categoryList.size(); i++) {
                pstmt.setString(i+1, categoryList.get(i));
            }
            
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
    } else {
        out.println("<tr><td colspan='3'>카테고리를 입력해주세요.</td></tr>");
    }
%>
        </tbody>
    </table>
    <br>
    <a href="admin_menu.jsp">관리자 메뉴로 돌아가기</a>
</div>
</body>
</html>