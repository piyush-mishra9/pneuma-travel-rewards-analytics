-- ============================================================
-- PNEUMA TRAVEL REWARDS & PRODUCT ANALYTICS
-- PostgreSQL Analysis
-- Synthetic Portfolio Dataset
-- ============================================================


-- ============================================================
-- STEP 1: CREATE TABLES
-- ============================================================


-- ------------------------------------------------------------
-- 1. USERS TABLE
-- ------------------------------------------------------------

CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    signup_date DATE,
    city VARCHAR(50),
    user_type VARCHAR(50),
    age_group VARCHAR(20)
);


-- Check users table
SELECT * FROM users;


-- ------------------------------------------------------------
-- 2. POINTS_ACCOUNTS TABLE
-- ------------------------------------------------------------

CREATE TABLE points_accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    program VARCHAR(50),
    points_balance INTEGER,
    account_type VARCHAR(30),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- ------------------------------------------------------------
-- 3. SEARCHES TABLE
-- ------------------------------------------------------------

CREATE TABLE searches (
    search_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    origin VARCHAR(50),
    destination VARCHAR(50),
    search_date DATE,
    travel_date DATE,
    cabin VARCHAR(20),
    device VARCHAR(20),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- ------------------------------------------------------------
-- 4. AWARD_RESULTS TABLE
-- ------------------------------------------------------------

CREATE TABLE award_results (
    result_id VARCHAR(20) PRIMARY KEY,
    search_id VARCHAR(20),
    airline VARCHAR(50),
    loyalty_program VARCHAR(50),
    cabin VARCHAR(20),
    miles_required INTEGER,
    taxes_inr NUMERIC(12,2),
    cash_ticket_price_inr NUMERIC(12,2),
    availability VARCHAR(30),

    FOREIGN KEY (search_id)
        REFERENCES searches(search_id)
);


-- ------------------------------------------------------------
-- 5. CLICKS TABLE
-- ------------------------------------------------------------

CREATE TABLE clicks (
    click_id VARCHAR(20) PRIMARY KEY,
    result_id VARCHAR(20),
    search_id VARCHAR(20),
    user_id VARCHAR(20),
    click_date DATE,

    FOREIGN KEY (result_id)
        REFERENCES award_results(result_id),

    FOREIGN KEY (search_id)
        REFERENCES searches(search_id),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- ------------------------------------------------------------
-- 6. BOOKING_ATTEMPTS TABLE
-- ------------------------------------------------------------

CREATE TABLE booking_attempts (
    attempt_id VARCHAR(20) PRIMARY KEY,
    click_id VARCHAR(20),
    user_id VARCHAR(20),
    result_id VARCHAR(20),
    search_id VARCHAR(20),
    attempt_date DATE,

    FOREIGN KEY (click_id)
        REFERENCES clicks(click_id),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (result_id)
        REFERENCES award_results(result_id),

    FOREIGN KEY (search_id)
        REFERENCES searches(search_id)
);


-- ------------------------------------------------------------
-- 7. BOOKINGS TABLE
-- ------------------------------------------------------------

CREATE TABLE bookings (
    booking_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    search_id VARCHAR(20),
    result_id VARCHAR(20),
    booking_date DATE,
    status VARCHAR(30),
    miles_used INTEGER,
    taxes_paid_inr NUMERIC(12,2),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (search_id)
        REFERENCES searches(search_id),

    FOREIGN KEY (result_id)
        REFERENCES award_results(result_id)
);


-- ------------------------------------------------------------
-- 8. SUBSCRIPTIONS TABLE
-- ------------------------------------------------------------

CREATE TABLE subscriptions (
    subscription_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    plan VARCHAR(20),
    start_date DATE,
    end_date DATE,
    status VARCHAR(30),
    revenue_inr NUMERIC(12,2),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- ============================================================
-- STEP 2: IMPORT CSV FILES
-- ============================================================


-- ------------------------------------------------------------
-- 1. IMPORT USERS
-- ------------------------------------------------------------

COPY users
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\users.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 2. IMPORT POINTS_ACCOUNTS
-- ------------------------------------------------------------

COPY points_accounts
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\points_accounts.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 3. IMPORT SEARCHES
-- ------------------------------------------------------------

COPY searches
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\searches.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 4. IMPORT AWARD_RESULTS
-- ------------------------------------------------------------

COPY award_results
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\award_results.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 5. IMPORT CLICKS
-- ------------------------------------------------------------

COPY clicks
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\clicks.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 6. IMPORT BOOKING_ATTEMPTS
-- ------------------------------------------------------------

COPY booking_attempts
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\booking_attempts.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 7. IMPORT BOOKINGS
-- ------------------------------------------------------------

COPY bookings
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\bookings.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- 8. IMPORT SUBSCRIPTIONS
-- ------------------------------------------------------------

COPY subscriptions
FROM 'D:\pneuma\Pneuma_Travel_Rewards_Analytics_Dataset\subscriptions.csv'
DELIMITER ','
CSV HEADER;


-- ============================================================
-- STEP 3: CHECK TABLE ROW COUNTS
-- ============================================================

SELECT 'users' AS table_name, COUNT(*) AS total_rows
FROM users

UNION ALL

SELECT 'points_accounts', COUNT(*)
FROM points_accounts

UNION ALL

SELECT 'searches', COUNT(*)
FROM searches

UNION ALL

SELECT 'award_results', COUNT(*)
FROM award_results

UNION ALL

SELECT 'clicks', COUNT(*)
FROM clicks

UNION ALL

SELECT 'booking_attempts', COUNT(*)
FROM booking_attempts

UNION ALL

SELECT 'bookings', COUNT(*)
FROM bookings

UNION ALL

SELECT 'subscriptions', COUNT(*)
FROM subscriptions;


-- ============================================================
-- STEP 4: 20 BUSINESS ANALYSIS QUESTIONS
-- ============================================================


-- ============================================================
-- Q1. What are the top 10 most searched routes?
-- ============================================================

SELECT
    origin,
    destination,
    COUNT(*) AS total_searches
FROM searches
GROUP BY origin, destination
ORDER BY total_searches DESC
LIMIT 10;


-- ============================================================
-- Q2. Which destinations have the highest number of searches?
-- ============================================================

SELECT
    destination,
    COUNT(*) AS total_searches
FROM searches
GROUP BY destination
ORDER BY total_searches DESC;


-- ============================================================
-- Q3. Which origins generate the most searches?
-- ============================================================

SELECT
    origin,
    COUNT(*) AS total_searches
FROM searches
GROUP BY origin
ORDER BY total_searches DESC;


-- ============================================================
-- Q4. Which cabin class is searched the most?
-- ============================================================

SELECT
    cabin,
    COUNT(*) AS total_searches
FROM searches
GROUP BY cabin
ORDER BY total_searches DESC;


-- ============================================================
-- Q5. Which device is used most for searches?
-- ============================================================

SELECT
    device,
    COUNT(*) AS total_searches
FROM searches
GROUP BY device
ORDER BY total_searches DESC;


-- ============================================================
-- Q6. Which airlines have the highest number of award results?
-- ============================================================

SELECT
    airline,
    COUNT(*) AS total_results
FROM award_results
GROUP BY airline
ORDER BY total_results DESC;


-- ============================================================
-- Q7. Which loyalty programs have the highest number of
--     award results?
-- ============================================================

SELECT
    loyalty_program,
    COUNT(*) AS total_results
FROM award_results
GROUP BY loyalty_program
ORDER BY total_results DESC;


-- ============================================================
-- Q8. What is the average number of miles required by airline?
-- ============================================================

SELECT
    airline,
    ROUND(AVG(miles_required), 0) AS avg_miles_required
FROM award_results
GROUP BY airline
ORDER BY avg_miles_required DESC;


-- ============================================================
-- Q9. What is the average tax amount by airline?
-- ============================================================

SELECT
    airline,
    ROUND(AVG(taxes_inr), 2) AS avg_taxes
FROM award_results
GROUP BY airline
ORDER BY avg_taxes DESC;


-- ============================================================
-- Q10. Which are the top 10 most active users based on
--      number of searches?
-- ============================================================

SELECT
    user_id,
    COUNT(*) AS total_searches
FROM searches
GROUP BY user_id
ORDER BY total_searches DESC
LIMIT 10;


-- ============================================================
-- Q11. How many searches were made by each user?
-- ============================================================

SELECT
    user_id,
    COUNT(*) AS total_searches
FROM searches
GROUP BY user_id
ORDER BY total_searches DESC;


-- ============================================================
-- Q12. What is the Search-to-Booking conversion rate?
-- ============================================================

SELECT
    ROUND(
        COUNT(DISTINCT booking.search_id)::NUMERIC
        / COUNT(DISTINCT search.search_id) * 100,
        2
    ) AS search_to_booking_conversion
FROM searches AS search
LEFT JOIN bookings AS booking
    ON search.search_id = booking.search_id;


-- ============================================================
-- Q13. What are the top 10 routes based on completed bookings?
-- ============================================================

SELECT
    s.origin,
    s.destination,
    COUNT(*) AS total_bookings
FROM bookings AS b
JOIN searches AS s
    ON b.search_id = s.search_id
GROUP BY s.origin, s.destination
ORDER BY total_bookings DESC
LIMIT 10;


-- ============================================================
-- Q14. Which airlines have the highest number of bookings?
-- ============================================================

SELECT
    ar.airline,
    COUNT(*) AS total_bookings
FROM bookings AS b
JOIN award_results AS ar
    ON b.result_id = ar.result_id
GROUP BY ar.airline
ORDER BY total_bookings DESC;


-- ============================================================
-- Q15. What is the total number of miles redeemed?
-- ============================================================

SELECT
    SUM(miles_used) AS total_miles_redeemed
FROM bookings;


-- ============================================================
-- Q16. How many miles were redeemed through each airline?
-- ============================================================

SELECT
    ar.airline,
    SUM(b.miles_used) AS total_miles_redeemed
FROM bookings AS b
JOIN award_results AS ar
    ON b.result_id = ar.result_id
GROUP BY ar.airline
ORDER BY total_miles_redeemed DESC;


-- ============================================================
-- Q17. What is the total amount of taxes paid?
-- ============================================================

SELECT
    SUM(taxes_paid_inr) AS total_taxes_paid
FROM bookings;


-- ============================================================
-- Q18. How much subscription revenue was generated by each plan?
-- ============================================================

SELECT
    plan,
    SUM(revenue_inr) AS total_revenue
FROM subscriptions
GROUP BY plan
ORDER BY total_revenue DESC;


-- ============================================================
-- Q19. What is the subscription rate by user type?
-- ============================================================

SELECT
    u.user_type,

    COUNT(DISTINCT s.user_id) AS subscribed_users,

    COUNT(DISTINCT u.user_id) AS total_users,

    ROUND(
        COUNT(DISTINCT s.user_id)::NUMERIC
        / COUNT(DISTINCT u.user_id) * 100,
        2
    ) AS subscription_rate

FROM users AS u

LEFT JOIN subscriptions AS s
    ON u.user_id = s.user_id

GROUP BY u.user_type
ORDER BY subscription_rate DESC;


-- ============================================================
-- Q20. What is the monthly search trend?
-- ============================================================

SELECT
    DATE_TRUNC('month', search_date) AS month,
    COUNT(*) AS total_searches
FROM searches
GROUP BY DATE_TRUNC('month', search_date)
ORDER BY month;