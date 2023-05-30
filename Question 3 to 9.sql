-- 3)	Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
SELECT CUS_GENDER, COUNT(*) AS Total_Customers
FROM customer c
INNER JOIN orders o ON c.CUS_ID = o.CUS_ID
WHERE ORD_AMOUNT >= 3000
GROUP BY CUS_GENDER;
-- 4)	Display all the orders along with product name ordered by a customer having Customer_Id=2
SELECT o.ORD_ID, p.PRO_NAME
FROM orderS o
INNER JOIN product p ON o.PRICING_ID = p.PRO_ID
WHERE o.CUS_ID = 2;

-- 5)	Display the Supplier details who can supply more than one product.
SELECT s.*
FROM supplier s
INNER JOIN supplier_pricing sp ON s.SUPP_ID = sp.SUPP_ID
GROUP BY s.SUPP_ID, s.SUPP_NAME, s.SUPP_CITY, s.SUPP_PHONE
HAVING COUNT(DISTINCT sp.PRO_ID) > 1;
-- 6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product
SELECT c.CAT_ID, c.CAT_NAME, p.PRO_NAME, sp.SUPP_PRICE
FROM category c
INNER JOIN product p ON c.CAT_ID = p.CAT_ID
INNER JOIN supplier_pricing sp ON p.PRO_ID = sp.PRO_ID
WHERE sp.SUPP_PRICE = (
    SELECT MIN(SUPP_PRICE)
    FROM supplier_pricing
    WHERE PRO_ID = p.PRO_ID
)
ORDER BY c.CAT_ID;

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT p.PRO_ID, p.PRO_NAME
FROM product p
INNER JOIN supplier_pricing sp ON p.PRO_ID = sp.PRO_ID
INNER JOIN orders o ON sp.PRICING_ID = o.PRICING_ID
WHERE o.ORD_DATE > '2021-10-05';

-- 8)	Display customer name and gender whose names start or end with character 'A'.
SELECT CUS_NAME, CUS_GENDER
FROM customer
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

-- 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

DELIMITER //

CREATE PROCEDURE GetSupplierDetails()
BEGIN
    SELECT s.SUPP_ID, s.SUPP_NAME, r.RAT_RATSTARS,
        CASE
            WHEN r.RAT_RATSTARS = 5 THEN 'Excellent Service'
            WHEN r.RAT_RATSTARS > 4 THEN 'Good Service'
            WHEN r.RAT_RATSTARS > 2 THEN 'Average Service'
            ELSE 'Poor Service'
        END AS Type_of_Service
    FROM supplier s
    INNER JOIN rating r ON s.SUPP_ID = r.SUPP_ID;
END //

DELIMITER ;
