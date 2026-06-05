-- QA SQL Lab practice tasks
-- Write queries for each task before checking solutions.sql.

-- 1. Show all active users.

-- 2. Show users from USA or Canada.

-- 3. Show orders created after 2026-03-01.

-- 4. Count users by status.

-- 5. Calculate total order amount by order status.

-- 6. Show users with their primary address.

-- 7. Show orders with user email and payment status.

-- 8. Find duplicate user emails.

-- 9. Find orders that reference a missing user.

-- 10. Find payments that reference a missing order.

-- 11. Find orders with negative amount.

-- 12. Find paid orders that do not have a successful payment.

-- 13. Find users who do not have any orders.

-- 14. Find orders above the average order amount.

-- 15. Classify users into age groups: UNKNOWN, UNDER_18, ADULT, SENIOR.

-- 16. Classify orders into QA risk levels based on amount and status.

-- 17. Number each user's orders by creation date.

-- 18. Rank orders by amount within each order status.

-- 19. Calculate a running total of order amounts by creation date.

-- 20. Write an assertion query that returns active users without primary addresses.

-- 21. Write an assertion query that returns successful payments where amount differs from the order amount.

-- 22. Write a safe transaction that updates one order status, verifies it, and rolls it back.

-- 23. Use a CTE to calculate order count and total order amount for each user.

-- 24. Use multiple CTEs to return only orders with missing or inconsistent payments.

-- 25. Use a recursive CTE to generate dates from 2026-06-01 through 2026-06-07.

-- 26. Query active_user_order_summary for active users without orders.

-- 27. Query order_payment_validation for all rows where qa_status is not CONSISTENT.

-- 28. Count validation results by qa_status using order_payment_validation.
