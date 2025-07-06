-- 1.Create a Reusable Function
-- Function to calculate total order cost for a given order

DELIMITER //

CREATE FUNCTION GetOrderTotal(orderId INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(b.Price * o.Quantity)
    INTO total
    FROM Orders o
    JOIN Books b ON o.Book_ID = b.Book_ID
    WHERE o.Order_ID = orderId;
    
    RETURN IFNULL(total, 0.00);
END;
//

DELIMITER ;

-- 2. Create a Stored Procedure
-- Procedure to show all orders by a customer

DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN custId INT)
BEGIN
    SELECT 
        o.Order_ID,
        o.Order_Date,
        b.Title AS Book_Title,
        o.Quantity,
        b.Price,
        (b.Price * o.Quantity) AS Total_Cost
    FROM Orders o
    JOIN Books b ON o.Book_ID = b.Book_ID
    WHERE o.Customer_ID = custId;
END;
//

DELIMITER ;

-- 3. Another Procedure: Insert a New Order
-- Encapsulate logic for placing an order:

DELIMITER //

CREATE PROCEDURE PlaceOrder(
    IN p_customer_id INT,
    IN p_book_id INT,
    IN p_quantity INT
)
BEGIN
    INSERT INTO Orders (Customer_ID, Book_ID, Quantity, Order_Date)
    VALUES (p_customer_id, p_book_id, p_quantity, CURDATE());
    
    SELECT 'Order Placed Successfully' AS Message;
END;
//

DELIMITER ;

-- 4. Use the Procedures and Function

 -- Call procedure to place order
CALL PlaceOrder(1, 2, 3);

-- Call procedure to view customer orders
CALL GetCustomerOrders(1);

-- Call function to get total for an order
SELECT GetOrderTotal(1) AS Order_Total;
