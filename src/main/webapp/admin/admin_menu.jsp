<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="admin_check.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메뉴</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { max-width: 800px; margin: auto; }
    .query-list { list-style: none; padding: 0; }
    .query-list li { background-color: #f4f4f4; border: 1px solid #ddd; padding: 10px; margin-bottom: 8px; }
    .query-list a { text-decoration: none; color: #007bff; font-weight: bold; font-size: 1.1em; }
    .query-list a:hover { text-decoration: underline; }
    .query-list span { color: #555; display: block; font-size: 0.9em; margin-top: 5px; line-height: 1.4; }
    h1 { border-bottom: 2px solid #333; padding-bottom: 10px; }
</style>
</head>
<body>

    <div class="container">
        <h1>관리자 메뉴 - Phase 2 쿼리</h1>
        
        <ul class="query-list">
            
            <li class="management" style="background-color: #e8f0fe; border-color: #b3d7ff;">
                <a href="admin_user_manage.jsp">사용자 종합 관리 (추가/검색/변경/삭제)</a>
                <span>(테이블 조작) USERS 테이블의 데이터를 직접 관리합니다.</span>
            </li>
            
            <li>
                <a href="admin_q1.jsp">Q1: 잔액 기준 사용자 조회</a>
                <span>(검색) 잔액(Balance)이 N원 이상인 사용자를 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q2.jsp">Q2: 날짜별 종료 경매 조회</a>
                <span>(날짜 선택) 특정 날짜에 종료되는 경매 목록을 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q3.jsp">Q3: 입찰 내역 상세 검색</a>
                <span>(복합 검색) 입찰자명, 아이템명, 최소 입찰가를 조건으로 내역을 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q4.jsp">Q4: 사용자 인벤토리 조회</a>
                <span>(검색) 사용자 ID와 아이템명을 입력하여 보유 아이템을 확인합니다.</span>
            </li>
            <li>
                <a href="admin_q5.jsp">Q5: 경매별 통계 (입찰 횟수/최고가)</a>
                <span>(검색) Auction ID를 입력하여 해당 경매의 통계 정보를 조회합니다.</span>
            </li>

            <li>
                <a href="admin_q6.jsp">Q6: 카테고리별 평균 거래가</a>
                <span>(검색) 카테고리 이름을 입력하여 평균 거래가를 확인합니다.</span>
            </li>
            <li>
                <a href="admin_q7.jsp">Q7: 평균가보다 비싼 아이템</a>
                <span>(서브쿼리) 특정 카테고리 내에서 평균 가격보다 비싼 아이템을 찾습니다.</span>
            </li>
            <li>
                <a href="admin_q8.jsp">Q8: 낙찰(판매) 경험 셀러 조회</a>
                <span>(서브쿼리) 특정 아이템을 판매하여 낙찰된 기록이 있는 셀러를 찾습니다.</span>
            </li>
            <li>
                <a href="admin_q9.jsp">Q9: 입찰 경험 사용자 (금액 기준)</a>
                <span>(EXISTS) 일정 금액 이상 입찰을 시도한 적이 있는 사용자를 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q10.jsp">Q10: 즐겨찾기된 경매 조회</a>
                <span>(EXISTS) 즐겨찾기가 하나 이상 등록된 경매를 판매자 ID로 검색합니다.</span>
            </li>

            <li>
                <a href="admin_q11.jsp">Q11: 카테고리별 아이템</a>
                <span>(다중 입력) 'Spear, Mace' 처럼 쉼표로 구분하여 여러 카테고리를 한 번에 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q12.jsp">Q12: 등급(Tier)별 즐겨찾기</a>
                <span>(IN 연산) Diamond, Gold 등 특정 등급 유저들이 즐겨찾기한 목록을 봅니다.</span>
            </li>
            <li>
                <a href="admin_q13.jsp">Q13: 경매 최고 입찰가 현황</a>
                <span>(인라인 뷰) 현재 최고 입찰가가 일정 금액 이상인 경매를 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q14.jsp">Q14: 카테고리 아이템 수</a>
                <span>(TOP-N) 아이템이 가장 많은 카테고리 순위를 N등까지 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q15.jsp">Q15: 고액 입찰 랭킹</a>
                <span>(정렬) 아이템별 입찰 금액 순위를 원하는 개수만큼 조회합니다.</span>
            </li>

            <li>
                <a href="admin_q16.jsp">Q16: 최신 즐겨찾기 목록</a>
                <span>(정렬) 사용자 ID나 아이템명으로 필터링하여 최신 즐겨찾기 내역을 봅니다.</span>
            </li>
            <li>
                <a href="admin_q17.jsp">Q17: 판매자 매출 랭킹</a>
                <span>(집계/정렬) 판매자 이름 검색 및 매출 상위 N명을 조회합니다.</span>
            </li>
            <li>
                <a href="admin_q18.jsp">Q18: 카테고리 평균 입찰가 순위</a>
                <span>(집계) 카테고리별 평균 입찰가를 구하고, 일정 금액 이상인 건만 필터링합니다.</span>
            </li>
            <li>
                <a href="admin_q19.jsp">Q19: 전체 거래 참여자</a>
                <span>(집합 연산) 구매 또는 판매 기록이 있는 모든 사용자를 검색합니다.</span>
            </li>
            <li>
                <a href="admin_q20.jsp">Q20: 순수 구매 시도자</a>
                <span>(집합 연산) 입찰 기록은 있으나 판매 기록은 없는 사용자를 검색합니다.</span>
            </li>

        </ul>
        
        <br>
        <a href="../index.jsp" style="display:inline-block; padding:10px; background:#333; color:white; text-decoration:none; border-radius:5px;">메인 메뉴로 돌아가기</a>
    </div>

</body>
</html>