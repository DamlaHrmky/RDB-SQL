

--session 12

---SQL Programming

--Begin ve End zorunlu de�il ancak procedure' un nerede ba�lay�p nerede bitti�ini g�rebilmek i�in �nemli.

CREATE PROCEDURE sp_sample_1
AS
BEGIN
		SELECT 'HELLO WORLD' AS [MESSAGE]


END;


sp_sample_1

EXEC sp_sample_1 -- sadece proc ismiyle �a��rmak pek tercih edilmez.

EXECUTE sp_sample_1

----

ALTER PROCEDURE sp_sample_1
AS
BEGIN
		PRINT 'HELLO WORLD' -- sonucu print veya select ile al�r�z. print ile mesaj olarak sonu�lar g�r�necektir.


END;


EXECUTE sp_sample_1


----------

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);


INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )




CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- ger�ekle�en delivery date
);




INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )


SELECT *
FROM ORDER_DELIVERY


----


CREATE PROC sp_order_cnt 
AS
BEGIN
		SELECT	COUNT(ORDER_ID)
		FROM	ORDER_TBL
END;
	

EXEC sp_order_cnt


--proc i�erisinde kullan�lan tablo g�ncellendik�e sonu� de�i�ecektir.

INSERT ORDER_TBL VALUES	(9,9, 'Sam', getdate(), getdate()+2)


SELECT *
FROM ORDER_TBL



EXEC sp_order_cnt

----------------


---parametre yazarken @ karakteri ve veri tipini yazmak zorunday�z.
CREATE PROC sp_order_by_date (@ord_date DATE)
AS
BEGIN
		SELECT	COUNT(ORDER_ID) cnt_order
		FROM	ORDER_TBL
		WHERE	order_date = @ord_date
END;

--proc parametre ald���nda bu �ekilde yaz�l�r. Tarih ve string de�erler t�rnak i�inde, numeric de�erler t�rnaks�z yaz�l�r.
EXEC sp_order_by_date '2024-05-10'



--iki parametreli proc
CREATE PROC sp_order_by_date_by_customer (@ord_date DATE , @cust_name VARCHAR(15))
AS
BEGIN
		SELECT	COUNT(ORDER_ID) cnt_order
		FROM	ORDER_TBL
		WHERE	order_date = @ord_date
		AND		customer_name = @cust_name
END;


EXEC sp_order_by_date_by_customer '2024-05-10', 'Sam'



--proc alter komutuyla g�ncellenir. parametre tan�mland���nda atan�lan de�er default de�er olarak kabul edilir.

ALTER PROC sp_order_by_date_by_customer (@cust_name VARCHAR(15) , @ord_date DATE = '2024-05-10')
AS
BEGIN
		SELECT	COUNT(ORDER_ID) cnt_order
		FROM	ORDER_TBL
		WHERE	order_date = @ord_date
		AND		customer_name = @cust_name
END;



EXEC sp_order_by_date_by_customer 'Sam', '2024-05-10'

--default de�er tan�mlanm�� parametre, proc �a��r�l�rken yaz�lmayabilir.

EXEC sp_order_by_date_by_customer 'Sam'


-----------------------

DECLARE @v1 int, @v2 int, @result int --de�i�kenleri tan�mla

SET @v1 = 5  --de�er ata

SET @v2 = 6

SET @result = @v1 * @v2 -- kullan

SELECT @result -- �a��r

---------------------------

DECLARE @v1 int, @v2 int, @result int

SELECT @v1 = 5 , @v2 = 6

SET @result = @v1 * @v2

PRINT @result


-----

DECLARE @v1 int = 5 , @v2 int = 6 
DECLARE @result int = @v1 * @v2

SELECT @result




DECLARE @cust_id int = 5

SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_ID = @cust_id



DECLARE @CUST_NAME VARCHAR(10)


--set ile sorgu sonucundaki de�eri de�i�kene atama

SET @CUST_NAME = (SELECT	CUSTOMER_NAME
					FROM	ORDER_TBL
					WHERE	ORDER_DATE = '2024-05-07'
					)


SELECT @CUST_NAME

-------------



DECLARE @CUST_NAME VARCHAR(10)

--select ile sorgu sonucundaki de�eri de�i�kene atama

SELECT	@CUST_NAME = CUSTOMER_NAME
		FROM	ORDER_TBL
		WHERE	ORDER_DATE = '2024-05-07'
		


SELECT @CUST_NAME

------


---IF ELSE

DECLARE @CUST_ID INT = 4

IF @CUST_ID = 5
	SELECT 'This is the customer'

ELSE IF @CUST_ID = 3
	SELECT 'The wrong customer'
		
ELSE PRINT 'No Customer'


------------

--IF EXISTS

DECLARE @CUST_ID INT = 10

IF EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUST_ID)
		SELECT COUNT(ORDER_ID) AS CNT_ORDER
		FROM ORDER_TBL
		WHERE CUSTOMER_ID = @CUST_ID


ELSE PRINT 'There is no such a customer!'


------------------

--iki de�i�ken tan�mlay�n
--1. de�i�ken ikincisinden b�y�k ise iki de�i�keni toplay�n
--2. de�i�ken birincisinden b�y�k ise 2. de�i�kenden 1. de�i�keni ��kar�n
--1. de�i�ken 2. de�i�kene e�it ise iki de�i�keni �arp�n


DECLARE @v1 int, @v2 int

SET @v1 = 5

SET @v2 = 5

IF @v1 > @v2
	SELECT @v1 + @v2 AS TOPLAM

ELSE IF @v1 < @v2
	SELECT @v2 - @v1 AS FARK

ELSE IF @v1 = @v2
	SELECT @v1 * @v2 CARPIM


----///////////////////////


---�stenilen tarihte verilen sipari� say�s� 2 ten k���kse 'lower than 2',
-- 2 ile 5 aras�ndaysa sipari� say�s�, 5' den b�y�kse 'upper than 5' yazd�ran bir sorgu yaz�n�z.

SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = '2024-05-7' ; 




--(SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day) bu sorgu de�i�kene tan�mlanabilirdi
--proc olu�tururken bunu yapaca��z


DECLARE @ord_day DATE

SET @ord_day = '2024-05-7'

IF 2 > (SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day)
	PRINT 'lower than 2'

ELSE IF (SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day) BETWEEN 2 AND 5
	SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day

ELSE IF 5 < (SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day)
	PRINT 'Upper than 5'



--(SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day) bu sorgu de�i�kene tan�mlanabilirdi
--proc olu�tururken bunu yapaca��z


exec sp_sample_ord_cnt '2024-05-10'


---yukar�daki sorguyu procedure haline d�n��t�relim

CREATE PROC sp_sample_ord_cnt (@ord_date DATE)
AS
BEGIN
		DECLARE @ORD_CNT INT
	
		SELECT	@ORD_CNT = COUNT(ORDER_ID)	
		FROM	ORDER_TBL 
		WHERE	ORDER_DATE = @ord_date

IF @ORD_CNT < 2 
	PRINT 'lower than 2'

ELSE IF @ORD_CNT BETWEEN 2 AND 5
	SELECT @ORD_CNT AS count_of_order

ELSE IF @ORD_CNT > 5
	PRINT 'upper than 5'

END;

exec sp_sample_ord_cnt '2024-05-7'

---------------

----WHILE

--ba�lang�� ve biti� de�eri belirlenmeli
--d�ng�y� sa�layacak i�lem yaz�lmal�


DECLARE @NUM INT = 1 , @ENDPOINT INT = 50

WHILE @NUM <= @ENDPOINT
BEGIN
	PRINT @NUM
	SET @NUM = @NUM +1 -- @NUM+=1
END;


---- bir tabloya otomatik olarak de�er girilmesi

DECLARE @START_ID INT = 10

WHILE @START_ID <= 20
BEGIN
	INSERT ORDER_TBL 
	VALUES (@START_ID, @START_ID, NULL, NULL, NULL)

	SET @START_ID += 1
END;


SELECT *
FROM ORDER_TBL


---------------



----FUNCTIONS


--SCALAR-VALUED FUNCTIONS

--Fonksiyonlarda parametre olmasa da parantez yaz�l�r. Parametre varsa i�ine tan�mlan�r.

CREATE FUNCTION fn_sample_1() 
RETURNS VARCHAR(MAX) -- d�necek de�erin veri tipini ba�tan belirliyoruz.
AS
BEGIN
		RETURN UPPER('clarusway') -- return fonksiyonlarda sonucu d�nd�recek komut. Mutlaka yaz�lmal�
END;


SELECT dbo.fn_sample_1()

------


CREATE FUNCTION fn_title (@string VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
		RETURN UPPER (LEFT (@string, 1)) + LOWER (RIGHT (@string, len (@string)-1))
END;


SELECT dbo.fn_title('commands complETED successfully.')



SELECT dbo.fn_title(CUSTOMER_NAME)
FROM	ORDER_TBL

--------------------


--Sipari�leri, tahmini teslim tarihleri ve ger�ekle�en teslim tarihlerini k�yaslayarak
--'Late','Early' veya 'On Time' olarak s�n�fland�rmak istiyorum.
--E�er sipari�in ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (ger�ekle�en teslimat tarihi) k���kse
--Bu sipari�i 'LATE' olarak etiketlemek,
--E�er EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipari�i 'EARLY' olarak etiketlemek,
--E�er iki tarih birbirine e�itse de bu sipari�i 'ON TIME' olarak etiketlemek istiyorum.


ALTER FUNCTION fn_order_delivery_status (@order_id INT )
RETURNS VARCHAR(10)
AS
BEGIN
		DECLARE @DEL_DAY DATE
		DECLARE @EST_DEL_DAY DATE
		DECLARE @STATUS VARCHAR(10)

		SELECT @DEL_DAY = DELIVERY_DATE
		FROM	ORDER_DELIVERY
		WHERE	ORDER_ID = @order_id

		SELECT @EST_DEL_DAY = EST_DELIVERY_DATE
		FROM	ORDER_TBL
		WHERE	ORDER_ID = @order_id

		IF @EST_DEL_DAY < @DEL_DAY
			SET @STATUS = 'LATE'
		ELSE IF @EST_DEL_DAY = @DEL_DAY
			SET @STATUS = 'ON TIME'
		ELSE IF @EST_DEL_DAY > @DEL_DAY
			SET @STATUS = 'EARLY'

RETURN @STATUS
END;


SELECT dbo.fn_order_delivery_status(3)


SELECT *, dbo.fn_order_delivery_status(ORDER_ID) AS ORD_STATUS
FROM	ORDER_TBL


SELECT *, dbo.fn_order_delivery_status(A.ORDER_ID) AS ORD_STATUS
FROM	ORDER_TBL AS A
		INNER JOIN
		ORDER_DELIVERY AS B
		ON A.ORDER_ID = B.ORDER_ID
WHERE	dbo.fn_order_delivery_status(A.ORDER_ID) = 'ON TIME'



--------------//////////////


---TABLE-VALUED FUNCTIONS

CREATE FUNCTION fn_table_1 ()
RETURNS TABLE -- table valued fonksiyonlarda d�necek de�erin veri tipi table olarak belirtilir
AS 

-- table valued fonksiyonlarda d�necek tablo fonksiyonda de�i�ken olarak tan�mlanan tablo de�ilse
-- yani a�a��daki gibi mevcut bir tablonun belirli de�erlerini d�nd�ren bir sorgu sonucunda olu�an tablo d�nd�r�lecekse
-- begin ve end yaz�lmaz. sonucu d�nd�recek sorgu a�a��daki gibi RETURN komutu sonras�nda yaz�l�r.

RETURN	SELECT *
		FROM	ORDER_TBL
		WHERE	ORDER_DATE < '2024-05-07'
;


SELECT *
FROM	dbo.fn_table_1()


------

CREATE FUNCTION fn_table_2 (@day DATE)
RETURNS TABLE
AS 
RETURN	SELECT *
		FROM	ORDER_TBL
		WHERE	ORDER_DATE < @day


-- table valued fonksiyonlar tablo gibi kullan�l�r.
SELECT *
FROM	dbo.fn_table_2('2024-05-09')


-------------


-- Tablo de�i�kenini a�a��daki gibi olu�turup kullanabiliriz.

DECLARE @TBL1 TABLE (ID INT , NAME VARCHAR(10))

INSERT @TBL1 VALUES (10, 'Charlie')

SELECT *
FROM	@TBL1



----

--statusu on time olan sipari�lerin m��terilerinin id ve ismini d�nd�ren bir fonksiyon olu�turun.

CREATE FUNCTION fn_ontime_orders(@ORDER_ID INT)
RETURNS @CUSTOMER TABLE (ID INT, [NAME] VARCHAR(25)) -- @customer isimli bir tablo de�i�keni olu�turuyoruz, s�tunlar�n� belirliyoruz
AS
BEGIN -- yukar�daki gibi fonksiyon sonucunda d�necek tablo de�i�ken olarak tan�mlanm��sa  fonksiyon i�indeki komutlar begin ve end aras�na yaz�l�r.


		INSERT @CUSTOMER
		SELECT CUSTOMER_ID, CUSTOMER_NAME
		FROM	ORDER_TBL
		WHERE	ORDER_ID = @ORDER_ID
		AND		dbo.fn_order_delivery_status(@ORDER_ID) = 'ON TIME'

RETURN
END;


SELECT *
FROM	dbo.fn_ontime_orders(7)






