<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="admin_check.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
    String tier = (String) session.getAttribute("userTier");
    if (tier == null || !tier.equals("ADMIN")) {
        response.sendRedirect("../login.html");
        return;
    }
%>

<title>관리자 메뉴</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 800px; margin: auto; }
    .query-list { list-style: none; padding: 0; }
    .query-list li { background-color: #f4f4f4; border: 1px solid #ddd; padding: 10px; margin-bottom: 5px; }
    .query-list a { text-decoration: none; color: #007bff; font-weight: bold; }
    .query-list span { color: #555; display: block; font-size: 0.9em; margin-top: 4px; }
    h2 { margin-top: 30px; font-size: 1.2em; color: #333; border-bottom: 2px solid #ddd; padding-bottom: 5px;}
</style>
</head>
<body>

    <div class="container">
        <h1>관리자 메뉴 - Phase 2 쿼리</h1>
        
        <ul class="query-list">
            
            <li class="management">
                <a href="admin_user_manage.jsp">사용자 종합 관리 (추가/검색/변경/삭제)</a>
                <span>(동적 입력) USERS 테이블을 직접 관리합니다.</span>
            </li>

            <h2>검색 및 필터링</h2>
            <li>
                <a href="admin_q1.jsp">Q1: 잔액 N원 이상 사용자 조회</a>
                <span>(동적) 'Balance' 값을 입력받아 조회 (비교 연산)</span>
            </li>
            <li>
                <a href="admin_q2.jsp">Q2: 특정 키워드가 포함된 물품 검색</a>
                <span>(동적) 물품 이름/설명에 키워드 포함 (LIKE 검색)</span>
            </li>
            <li>
                <a href="admin_q3.jsp">Q3: 가격대별 물품 조회</a>
                <span>(동적) 최소~최대 가격 사이의 물품 조회 (BETWEEN)</span>
            </li>
            <li>
                <a href="admin_q4.jsp">Q4: 특정 날짜 이후 가입한 회원 조회</a>
                <span>(동적) 날짜 입력받아 조회 (Date 비교)</span>
            </li>

            <h2>조인 (Information Retrieval)</h2>
            <li>
                <a href="admin_q5.jsp">Q5: 물품별 판매자 정보 상세 조회</a>
                <span>(정적) ITEM과 USERS 테이블 조인</span>
            </li>
            <li>
                <a href="admin_q6.jsp">Q6: 특정 카테고리의 물품 목록 조회</a>
                <span>(동적) 카테고리 입력 -> 해당 카테고리 물품들 (Join)</span>
            </li>
            <li>
                <a href="admin_q7.jsp">Q7: 모든 입찰 기록과 입찰자명 조회</a>
                <span>(정적) BID, ITEM, USERS 3중 조인</span>
            </li>
            <li>
                <a href="admin_q8.jsp">Q8: 입찰 내역이 없는 사용자 목록 (Outer Join)</a>
                <span>(정적) 활동하지 않는 유령 회원 조회</span>
            </li>

            <h2>통계 및 집계 (Group By)</h2>
            <li>
                <a href="admin_q9.jsp">Q9: 카테고리별 등록된 물품 개수</a>
                <span>(정적) GROUP BY Category, COUNT(*)</span>
            </li>
            <li>
                <a href="admin_q10.jsp">Q10: 사용자별 총 입찰 횟수 및 평균 입찰가</a>
                <span>(정적) GROUP BY UserID (AVG, COUNT)</span>
            </li>
            <li>
                <a href="admin_q11.jsp">Q11: 가장 비싼 물품 TOP 5</a>
                <span>(정적) ORDER BY Price DESC, ROWNUM <= 5</span>
            </li>
            <li>
                <a href="admin_q12.jsp">Q12: 입찰자가 3명 이상인 인기 물품</a>
                <span>(정적) GROUP BY Item -> HAVING Count >= 3</span>
            </li>

            <h2>심화 검색 (Subquery)</h2>
            <li>
                <a href="admin_q13.jsp">Q13: 전체 평균 가격보다 비싼 물품</a>
                <span>(정적) WHERE Price > (SELECT AVG(Price)...)</span>
            </li>
            <li>
                <a href="admin_q14.jsp">Q14: 최고가 입찰을 한 사용자 정보</a>
                <span>(정적) 가장 비싼 입찰 금액을 쓴 유저 찾기</span>
            </li>
            <li>
                <a href="admin_q15.jsp">Q15: 특정 판매자의 물품에 입찰한 사람 목록</a>
                <span>(동적) 판매자 ID 입력 -> 관련 입찰자 조회 (IN 절)</span>
            </li>

            <h2>데이터 관리 (Action)</h2>
            <li>
                <a href="admin_q16.jsp">Q16: 물품 설명(Description) 수정</a>
                <span>(동적) ItemID 입력 -> 내용 수정 (UPDATE)</span>
            </li>
            <li>
                <a href="admin_q17.jsp">Q17: 회원의 등급(Tier) 변경</a>
                <span>(동적) UserID, 등급 입력 -> 등급 수정 (UPDATE)</span>
            </li>
            <li>
                <a href="admin_q18.jsp">Q18: 특정 카테고리 물품 일괄 가격 인상</a>
                <span>(동적) 카테고리, 인상률 입력 -> 가격 변경 (UPDATE)</span>
            </li>
            <li>
                <a href="admin_q19.jsp">Q19: 특정 입찰 내역 삭제 (입찰 취소)</a>
                <span>(동적) BidID 입력 -> 삭제 (DELETE)</span>
            </li>
            <li>
                <a href="admin_q20.jsp">Q20: 마감 기한이 지난 물품 삭제/종료 처리</a>
                <span>(동적) 날짜 기준 종료 처리 (DELETE or UPDATE)</span>
            </li>
            
        </ul>
        
        <br>
        <a href="../index.jsp">메인 메뉴로 돌아가기</a>
    </div>

</body>
</html>