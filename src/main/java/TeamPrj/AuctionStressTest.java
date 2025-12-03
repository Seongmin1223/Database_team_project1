package TeamPrj;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

public class AuctionStressTest {

    private static final String BASE_URL = "http://localhost:8080/Database_team_project";
    
    private static final String LOGIN_ACTION_URL = BASE_URL + "/loginAction.jsp"; 
    private static final String BID_ACTION_URL = BASE_URL + "/auction_bid.jsp";

    private static final String PASSWORD = "1234"; 
    private static final String AUCTION_ID = "4";    

    private static final int THREAD_COUNT = 100;
    private static final int START_BID_AMOUNT = 210;

    private static AtomicInteger bidCounter = new AtomicInteger(START_BID_AMOUNT - 1);

    public static void main(String[] args) {
        System.out.println(">>> 동시성 테스트 시작 [Target: " + AUCTION_ID + "번 경매] <<<");
        System.out.println(">>> 설정: 총 " + THREAD_COUNT + "명, 시작가 " + START_BID_AMOUNT + "원 부터 <<<");
        
        List<String> cookies = new ArrayList<>();
        List<String> loggedInUsers = new ArrayList<>();

        System.out.println("\n[단계 1] 로그인 및 세션 쿠키 수집 중...");

        for (int i = 1; i <= THREAD_COUNT; i++) {
            String userId = "user" + i;
            String cookie = loginAndGetCookie(userId, PASSWORD);
            if (cookie != null) {
                cookies.add(cookie);
                loggedInUsers.add(userId);
                System.out.println(" - " + userId + " 로그인 성공 (JSESSIONID 획득)");
            } else {
                System.err.println(" - " + userId + " 로그인 실패 (설정이나 계정 정보를 확인하세요)");
            }
        }

        if (cookies.isEmpty()) {
            System.out.println("로그인에 성공한 계정이 없어 테스트를 종료합니다.");
            return;
        }

        System.out.println("\n[단계 2] 동시 입찰 공격 시작 (Thread Pool 실행)");
        ExecutorService executor = Executors.newFixedThreadPool(cookies.size());

        for (int i = 0; i < cookies.size(); i++) {
            String cookie = cookies.get(i);
            final String currentUser = loggedInUsers.get(i);

            executor.execute(() -> {
                int individualAmount = bidCounter.incrementAndGet(); 
                
                System.out.printf(" >> [%s] %d원 입찰 시도 중... (선착순 배정)\n", currentUser, individualAmount);

                sendBidRequest(cookie, AUCTION_ID, String.valueOf(individualAmount));
            });
        }

        executor.shutdown();
        while (!executor.isTerminated()) {
        }

        System.out.println("\n>>> 모든 요청 완료. DB에서 최종 낙찰자와 잔액 차감을 확인하세요. <<<");
    }

    private static String loginAndGetCookie(String id, String pwd) {
        try {
            URL url = URI.create(LOGIN_ACTION_URL).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setInstanceFollowRedirects(false); // 리다이렉트 방지
            conn.setDoOutput(true);
            
            String params = "userID=" + id + "&password=" + pwd;
            
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = params.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            List<String> cookies = conn.getHeaderFields().get("Set-Cookie");
            if (cookies != null) {
                for (String cookie : cookies) {
                    if (cookie.startsWith("JSESSIONID")) {
                        return cookie.split(";")[0];
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("로그인 요청 중 에러: " + e.getMessage());
        }
        return null;
    }

    private static void sendBidRequest(String cookie, String auctionId, String amount) {
        try {
            URL url = URI.create(BID_ACTION_URL).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            
            conn.setRequestProperty("Cookie", cookie);
            
            String params = "auctionId=" + auctionId + "&amount=" + amount;
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = params.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            
            String responseBody = content.toString();
            String resultMsg = parseResult(responseBody);
            
            System.out.printf("[%s] 응답코드: %d, 결과: %s\n", Thread.currentThread().getName(), responseCode, resultMsg);

        } catch (Exception e) {
            System.err.printf("[%s] 요청 에러: %s\n", Thread.currentThread().getName(), e.getMessage());
        }
    }

    private static String parseResult(String responseBody) {
        if (responseBody.contains("입찰 성공")) return "[성공] 입찰되었습니다!";
        if (responseBody.contains("잔액이 부족")) return "[실패] 잔액 부족";
        if (responseBody.contains("최소") && responseBody.contains("이상이어야")) return "[실패] 금액 낮음 (갱신됨)";
        if (responseBody.contains("마감")) return "[실패] 경매 마감";
        return "알 수 없음";
    }
}