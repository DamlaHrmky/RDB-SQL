

/*
Question: By creating a new column, label the orders according to the instructions below:

Label the products as 'Not Shipped' if they were NOT shipped.
Label the products as 'Fast' if they were shipped on the day of order.
Label the products as 'Normal' if they were shipped within two days of the order date.
Label the products as 'Slow' if they were shipped later than two days after the order date.
*/


SELECT	order_id, order_date, shipped_date,
		CASE WHEN shipped_date IS NULL THEN 'Not Shipped'
			WHEN shipped_date = order_date THEN 'Fast'
			WHEN DATEDIFF(day, order_date, shipped_date) IN (1,2) THEN 'Normal'
			WHEN DATEDIFF(day, order_date, shipped_date) > 2 THEN 'Slow'
		END AS order_label
FROM	sale.orders




--Write a query that returns the product_names and list price that were made in 2021. 
--(Exclude the categories that match Game, gps, or Home Theater )

-- Game, gps veya Home Theater haricindeki kategorilere ait 2021 model �r�nleri listeleyin.


SELECT	product_name, list_price
FROM	product.product
WHERE	category_id NOT IN (	SELECT	category_id
								FROM	product.category
								WHERE	category_name IN ('Game', 'gps', 'Home Theater')
							)
AND		model_year = 2021



---//////

--Write a query that returns the list of product names that were made in 2020 
--and whose prices are higher than maximum product list price of Receivers Amplifiers category.

-- 2020 model olup Receivers Amplifiers kategorisindeki en pahal� �r�nden daha pahal� �r�nleri listeleyin.
-- �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z.


SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > (
						SELECT	TOP 1 list_price
						FROM	product.product AS A 
								INNER JOIN
								product.category AS B
								ON A.category_id = B.category_id
						WHERE	B.category_name = 'Receivers Amplifiers'
						ORDER BY list_price DESC
						)
ORDER BY 
		list_price DESC


---2. YOL

SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > ALL (
						SELECT	list_price
						FROM	product.product AS A 
								INNER JOIN
								product.category AS B
								ON A.category_id = B.category_id
						WHERE	B.category_name = 'Receivers Amplifiers'
						)
ORDER BY 
		list_price DESC



--///////

-- Write a query that returns the list of product names that were made in 2020 
-- and whose prices are higher than minimum product list price of Receivers Amplifiers category.

-- Receivers Amplifiers kategorisindeki �r�nlerin herhangi birinden y�ksek fiyatl� �r�nleri listeleyin.
-- �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z.


SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > (
						SELECT	TOP 1 list_price
						FROM	product.product AS A 
								INNER JOIN
								product.category AS B
								ON A.category_id = B.category_id
						WHERE	B.category_name = 'Receivers Amplifiers'
						ORDER BY list_price ASC
						)
ORDER BY 
		list_price DESC


--2. YOL

SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > (
						SELECT	MIN (list_price)
						FROM	product.product AS A 
								INNER JOIN
								product.category AS B
								ON A.category_id = B.category_id
						WHERE	B.category_name = 'Receivers Amplifiers'
						)
ORDER BY 
		list_price DESC


--3. YOL

SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > ANY (
						SELECT	list_price
						FROM	product.product AS A 
								INNER JOIN
								product.category AS B
								ON A.category_id = B.category_id
						WHERE	B.category_name = 'Receivers Amplifiers'
						)
ORDER BY 
		list_price DESC


--------


---CORRELATED SUBQUERIES

SELECT *
FROM	sale.customer
WHERE	EXISTS (SELECT 1)



SELECT *
FROM	sale.customer
WHERE	EXISTS (
				SELECT *
				FROM	sale.orders
				WHERE	order_date > '2020-01-01'
				)


---kontrol fonksiyonu. subquery herhangi bir de�er d�nd�rmedi�i i�in sonu� bo� k�me.
SELECT *
FROM	sale.customer
WHERE	EXISTS (
				SELECT *
				FROM	sale.orders
				WHERE	order_date > '2022-01-01'
				)

--subquery ile outor query' nin e�le�en de�eri olmad��� i�in sonu� bo� k�me.

SELECT *
FROM	sale.customer AS A
WHERE	EXISTS (
				SELECT *
				FROM	sale.orders AS B
				WHERE	order_date > '2022-01-01'
				AND		A.customer_id = B.customer_id
				)

---Select' e bakmaz e�itlik �nemli. E�er e�itlik belirtilmi�se subquery ve outor query' nin ortak de�erlerini d�nd�r�r.

SELECT *
FROM	sale.customer AS A
WHERE	EXISTS (
				SELECT	1
				FROM	sale.orders AS B
				WHERE	order_date > '2020-01-01'
				AND		A.customer_id = B.customer_id
				)



----NOT EXISTS 


SELECT *
FROM sale.customer
WHERE NOT EXISTS (SELECT 1)

---e�er subquery sonu� d�nd�rm��se not exists i�in ko�ul sa�lanmam�� demektir ve outor query' den sonu� d�nmez.
SELECT *
FROM sale.customer
WHERE	NOT EXISTS (
						SELECT *
						FROM	sale.orders
						WHERE	order_date > '2020-01-01'						
					)

---e�er subquery sonu� d�nd�rmemi�se not exists i�in ko�ul sa�lanm�� demektir ve outor query' den sonu� d�ner.
SELECT	*
FROM	sale.customer
WHERE	NOT EXISTS (
						SELECT *
						FROM	sale.orders
						WHERE	order_date > '2022-01-01'						
					)



SELECT	*
FROM	sale.customer AS A
WHERE	NOT EXISTS (
						SELECT *
						FROM	sale.orders AS B
						WHERE	order_date > '2020-01-01'		
						AND		A.customer_id = B.customer_id
					)


--Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered
-- 'Apple - Pre-Owned iPad 3 - 32GB - White' isimli �r�n�n sipari� verilmedi�i state' leri d�nd�ren bir sorgu yaz�n�z. (m��terilerin state' leri �zerinden)


--T�m state' lerden �r�n� sipari� verenleri ��karaca��m.

SELECT	 [state]
FROM	sale.customer

EXCEPT

SELECT	 D.[state]
FROM	product.product AS A
		INNER JOIN
		sale.order_item AS B
		ON A.product_id = B.product_id
		INNER JOIN
		sale.orders AS C
		ON B.order_id = C.order_id
		INNER JOIN
		sale.customer AS D 
		ON C.customer_id = D.customer_id
WHERE	A.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'


--NOT IN
SELECT	DISTINCT [state]
FROM	sale.customer
WHERE	[state] NOT IN (
						SELECT	 D.[state]
						FROM	product.product AS A
								INNER JOIN
								sale.order_item AS B
								ON A.product_id = B.product_id
								INNER JOIN
								sale.orders AS C
								ON B.order_id = C.order_id
								INNER JOIN
								sale.customer AS D 
								ON C.customer_id = D.customer_id
						WHERE	A.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
						)


---NOT EXISTS
SELECT	DISTINCT [state]
FROM	sale.customer AS X
WHERE	NOT EXISTS (
						SELECT	*
						FROM	product.product AS A
								INNER JOIN
								sale.order_item AS B
								ON A.product_id = B.product_id
								INNER JOIN
								sale.orders AS C
								ON B.order_id = C.order_id
								INNER JOIN
								sale.customer AS D 
								ON C.customer_id = D.customer_id
						WHERE	A.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
						AND		X.[state] = D.[state]
						)


----///////////////////////////


--Write a query that returns stock information of the products in Davi techno Retail store. 
--The BFLO Store hasn't  got any stock of that products.

--Davi techno ma�azas�ndaki �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n. 
--Bu �r�nlerin The BFLO Store ma�azas�nda sto�u bulunmuyor.


SELECT	DISTINCT a.product_id
FROM	product.stock As A
		INNER JOIN
		sale.store AS B
		ON A.store_id = B.store_id
WHERE	B.store_name = 'Davi Techno Retail'
AND		NOT EXISTS	(
						SELECT	DISTINCT X.product_id
						FROM	product.stock As X
								INNER JOIN
								sale.store AS Y
								ON X.store_id = Y.store_id
						WHERE	Y.store_name = 'The BFLO Store'
						AND		quantity > 0
						AND		A.product_id = X.product_id
					)

-----



SELECT	DISTINCT a.product_id
FROM	product.stock As A
		INNER JOIN
		sale.store AS B
		ON A.store_id = B.store_id
WHERE	B.store_name = 'Davi Techno Retail'
AND		EXISTS	(
						SELECT	DISTINCT X.product_id
						FROM	product.stock As X
								INNER JOIN
								sale.store AS Y
								ON X.store_id = Y.store_id
						WHERE	Y.store_name = 'The BFLO Store'
						AND		quantity = 0
						AND		A.product_id = X.product_id
					)




--Subquery in SELECT Statement

--Write a query that creates a new column named "total_price" calculating the total prices of the products on each order.
--order id' lere g�re toplam list price lar� hesaplay�n.


SELECT	order_id, SUM(quantity*list_price)
FROM	sale.order_item
GROUP BY order_id



SELECT	order_id, (SELECT SUM(quantity*list_price) FROM sale.order_item) AS total_price
FROM	sale.order_item


SELECT	DISTINCT order_id, 
		(	
			SELECT SUM(quantity*list_price) 
			FROM sale.order_item AS A 
			WHERE A.order_id = B.order_id
		) AS total_price
FROM	sale.order_item AS B



----------////////////////////------------

------ CTE's ------

--ORDINARY CTE's

-- Query Time


--List customers who have an order prior to the last order date of a customer named Jerald Berray and are residents of the city of Austin. 

-- Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi� 
--ve Austin �ehrinde ikamet eden m��terileri listeleyin.


WITH T1 AS (
			SELECT	MAX(order_date) last_order_date
			FROM	sale.customer AS A
					INNER JOIN
					sale.orders AS B
					ON A.customer_id = B.customer_id
			WHERE	first_name = 'Jerald'
			AND		last_name = 'Berray'
			)

SELECT	X.order_date, Y.customer_id, Y.first_name, Y.last_name
FROM	sale.orders AS X
		INNER JOIN
		sale.customer AS Y
		ON X.customer_id = Y.customer_id
		INNER JOIN
		T1 
		ON X.order_date < T1.last_order_date
WHERE	city = 'Austin'

/*
CREATE VIEW V_T1 AS
SELECT	MAX(order_date) last_order_date
FROM	sale.customer AS A
		INNER JOIN
		sale.orders AS B
		ON A.customer_id = B.customer_id
WHERE	first_name = 'Jerald'
AND		last_name = 'Berray'



SELECT	X.order_date, Y.customer_id, Y.first_name, Y.last_name
FROM	sale.orders AS X
		INNER JOIN
		sale.customer AS Y
		ON X.customer_id = Y.customer_id
		INNER JOIN
		V_T1 
		ON X.order_date < V_T1.last_order_date
WHERE	city = 'Austin'

DROP VIEW V_T1
*/


---///////////


-- List all customers their orders are on the same dates with Laurel Goldammer.

-- Laurel Goldammer isimli m��terinin al��veri� yapt��� tarihte/tarihlerde al��veri� yapan t�m m��terileri listeleyin.
-- M��teri ad�, soyad� ve sipari� tarihi bilgilerini listeleyin.

WITH T1 AS (
			SELECT	order_date
			FROM	sale.customer AS A
					INNER JOIN
					sale.orders AS B
					ON A.customer_id = B.customer_id
			WHERE	first_name = 'Laurel'
			AND		last_name = 'Goldammer'
			)
SELECT	X.customer_id, X.first_name, X.last_name, Y.order_date, T1.order_date AS L_ORDER
FROM	sale.customer AS X
		INNER JOIN
		sale.orders AS Y
		ON X.customer_id = Y.customer_id
		INNER JOIN
		T1 
		ON Y.order_date = T1.order_date


-- //////

--List products their model year are 2021 and their categories other than Game, gps, or Home Theater.
-- Game, gps, or Home Theater haricindeki kategorilere ait �r�nlerden sadece 2021 model y�l�na ait 
--�r�nlerin isim ve fiyat bilgilerini listeleyin.

WITH T1 AS (
			SELECT *
			FROM	product.category
			WHERE	category_name NOT IN ('Game', 'gps', 'Home Theater')
			)
SELECT	*
FROM	product.product AS A 
		INNER JOIN
		T1
		ON T1.category_id = A.category_id
WHERE	model_year = 2021



/*
E�itsizlik oldu�u i�in hatal� sonu� verdi.

WITH T1 AS (
			SELECT *
			FROM	product.category
			WHERE	category_name IN ('Game', 'gps', 'Home Theater')
			)
SELECT *
FROM	product.product AS A 
		INNER JOIN
		T1
		ON T1.category_id <> A.category_id
WHERE	model_year = 2021
*/


-----////////////////////-------


--RECURSIVE CTE's 


-- Create a table with a number in each row in ascending order from 0 to 9.

-- 0'dan 9'a kadar herbir rakam bir sat�rda olacak �ekide bir tablo olu�turun.

WITH T1 AS 
			(
				SELECT 0 AS NUM
				UNION ALL
				SELECT NUM + 1
				FROM	T1
				WHERE	NUM < 9
			)
SELECT *
FROM	T1












