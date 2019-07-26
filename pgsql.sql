CREATE TABLE CUSTOMERS(
	CustomerID int NOT NULL,
	Name char(25) NOT NULL,
	Street char(30) NULL,
	City char(35) NULL,
	State char(2) NULL,
	ZipPostalCode char(6) NULL,
	Country varchar(50) NULL,
	AreaCode char(3) NULL,
	PhoneNumber char(10) NULL,
	Email varchar(100) NULL,
	CONSTRAINT CustomerPK PRIMARY KEY (CustomerID)
);

CREATE TABLE ARTISTS(
	ArtistID int NOT NULL,
	Name char(25) NOT NULL,
	Nationality varchar(30) NULL,
	BirthYear numeric(4,0) NULL,
	DeceasedYear numeric(4,0) NULL,
	CONSTRAINT ArtistPK PRIMARY KEY (ArtistID),
	CONSTRAINT ArtistAK1 UNIQUE (Name),
	CONSTRAINT NationalityValues CHECK 
		Nationality IN ('Canadian', 'English', 'French', 'German',	'Mexican', 'Russian', 'Spanish', 'US'),
	CONSTRAINT BirthValuesCheck CHECK BirthYear < DeceasedYear,
	CONSTRAINT ValidBirthYear CHECK ((BirthYear > 1000) AND (BirthYear < 2000)),
	CONSTRAINT ValidDeathYear CHECK ((DeceasedYear > 1000) AND (DeceasedYear < 2000))
);

CREATE TABLE CUSTOMER_ARTIST_INT(
	ArtistID int NOT NULL, 
	CustomerID int NOT NULL, 
	CONSTRAINT CustomerArtistPK PRIMARY KEY (ArtistID, CustomerID), 
	CONSTRAINT Customer_Artist_Int_ArtistFK FOREIGN KEY (ArtistID) 
		REFERENCES ARTISTS (ArtistID) 
		ON DELETE CASCADE, 
	CONSTRAINT Customer_Artist_Int_CustomerFK FOREIGN KEY (CustomerID) 
		REFERENCES CUSTOMERS (CustomerID) 
		ON DELETE CASCADE
);

CREATE TABLE WORKS( 
	WorkID int NOT NULL, 
	Title varchar(50) NOT NULL, 
	Description varchar(1000) NULL, 
	Copy varchar(8) NOT NULL, 
	ArtistID int NOT NULL, 
	CONSTRAINT WorkPK PRIMARY KEY (WorkID), 
	CONSTRAINT WorkAK1 UNIQUE (Title, Copy), 
	CONSTRAINT ArtistFK FOREIGN KEY (ArtistID) REFERENCES ARTISTS (ArtistID)
);

CREATE TABLE TRANSACTIONS( 
	TransactionID int NOT NULL, 
	DateAcquired date NOT NULL, 
	AcquisitionPrice numeric(8,2) NULL,
	PurchaseDate date NULL, 
	SalesPrice numeric(8,2) NULL, 
	AskingPrice numeric(8,2) NULL, 
	CustomerID int NULL, 
	WorkID int NOT NULL, 
	CONSTRAINT TransactionPK PRIMARY KEY (TransactionID), 
	CONSTRAINT SalesPriceRange CHECK ((SalesPrice > 1000) AND (SalesPrice <= 200000)), 
	CONSTRAINT ValidTransDate CHECK (DateAcquired <= PurchaseDate), 
	CONSTRAINT TransactionWorkFK FOREIGN KEY (WorkID) 
		REFERENCES WORKS (WorkID), 
	CONSTRAINT TransactionCustomerFK FOREIGN KEY (CustomerID) 
		REFERENCES CUSTOMERS (CustomerID)
); 

/*Создаем последовательности для таблиц */
CREATE SEQUENCE SEQ_ARTISTS 
	INCREMENT BY 1 START WITH 101 MINVALUE 100;
CREATE SEQUENCE seq_customersS 
	INCREMENT BY 1 START WITH 201 MINVALUE 200;
CREATE SEQUENCE seq_worksS 
	INCREMENT BY 1 START WITH 301 MINVALUE 300;
CREATE SEQUENCE seq_transactionss
	INCREMENT BY 1 START WITH 401 MINVALUE 400;

INSERT INTO ARTISTS VALUES 
(nextval('seq_artists'), 'Miro', 'Spanish', 1870, 1950), 
(nextval('seq_artists'), 'Kandinsky', 'Russian', 1854, 1900),
(nextval('seq_artists'), 'Frings', 'US', 1700, 1800),
(nextval('seq_artists'), 'Klee', 'German', 1900, NULL),
(nextval('seq_artists'), 'Moos', 'US', NULL, NULL),
(nextval('seq_artists'), 'Tobey', 'US', NULL, NULL),
(nextval('seq_artists'), 'Matisse', 'French', NULL, NULL),
(nextval('seq_artists'), 'Chagall', 'French', NULL, NULL);

INSERT INTO CUSTOMERS VALUES 
(nextval('seq_customers'), 'Jeffrey Janes', '123 W. Elm St', 'Renton', 'WA', '98123', 'USA', '206', '555-1345', 'Customer1000@somewhere.com'), 
(nextval('seq_customers'), 'David Smith', '813 Tumbleweed Lane', 'Loveland', 'CO', '80345', 'USA', '303', '555-5434', 'Customer1001@somewhere.com'),
(nextval('seq_customers'), 'Tiffany Twilight', '88 - First Avenue', 'Langley', 'WA', '98114', 'USA', '206', '555-1000', 'Customer1015@somewhere.com'),
(nextval('seq_customers'), 'Fred Smathers', '10899-88th Ave', 'Bainbridge Island', 'WA', '98108', 'USA', '206', '555-1234','Customer1033@somewhere.com'),
(nextval('seq_customers'), 'Mary Beth Frederickson', '25 South Lafayette','Denver', 'CO', '80210', 'USA', '303', '555-1000', 'Customer1034@somewhere.com'), 
(nextval('seq_customers'), 'Selma Warning', '205 Burnaby', 'Vancouver', 'BC', 'VON1B', 'Canada', '253', '555-1234', 'Customer1036@somewhere.com'),
(nextval('seq_customers'), 'Susan Wu', '105 Locust Ave', 'Atlanta', 'GA', '23224', 'USA', '721', '555-1234', 'Customer1037@somewhere.com'),
(nextval('seq_customers'), 'Donald G. Gray', '55 Bodega Ave', 'Bodega Bay', 'CA', '92114', 'USA', '705', '555-1345', 'Customer1040@somewhere.com'),
(nextval('seq_customers'), 'Lynda Johnson', '117 C Street', 'Washington', 'DC', '11345', 'USA', '703', '555-1000', ''),
(nextval('seq_customers'), 'Chris Wilkens', '87 Highland Drive', 'Olympia', 'WA', '98008', 'USA', '206', '555-1234', '');

INSERT INTO WORKS VALUES 
(nextval('seq_works'), 'Mystic Fabric', 'One of the only pr', '99/135', 106),
(nextval('seq_works'), 'Mi Vida', 'Very black, but ve', '7/100', 101),
(nextval('seq_works'), 'Slow Embers', 'From the artists', 'HC', 106),
(nextval('seq_works'), 'Mystic Fabric', 'Some water damage', '105/135', 106),
(nextval('seq_works'), 'Northwest by Night', 'Wonderful, moody', '37/50', 108);

INSERT INTO TRANSACTIONS VALUES 
(nextval('seq_transactions'), '1974-2-27', 8750, '1974-3-18', 18500, 20000, 203, 301),
(nextval('seq_transactions'), '1989-7-17', 28900, '1989-10-14', 46700, 47000, 202, 301),
(nextval('seq_transactions'), '1989-11-17', 4500, '2000-11-21', 9750, 10000, 208, 304),
(nextval('seq_transactions'), '1999-2-27', 8000, '2000-3-15', 17500, 17500, 206, 302),
(nextval('seq_transactions'), '2000-4-7', 38700, '2001-8-17', 73500, 75000, 206, 302),
(nextval('seq_transactions'), '2001-11-21', 6750, '2002-3-18', 14500, 15000, 208, 303),
(nextval('seq_transactions'), '2001-11-21', 21500, NULL, NULL, NULL, NULL, 304),
(nextval('seq_transactions'), '2002-7-17', 47000, '2002-10-2', 71500, 72500, 203, 305);

INSERT INTO CUSTOMER_ARTIST_INT VALUES 
(101, 206),(103, 203),(103, 205),(103, 209),(103, 210),(105, 205),(105, 209),(106, 202),
(106, 203),(106, 204),(106, 205),(106, 206),(106, 208),(106, 209),(106, 210),(108, 203);

/*Создаем индексы двух типов*/
CREATE INDEX ARTIST_NAME 
	ON ARTISTS USING hash (Name); 
CREATE INDEX TRANSACTION_DATEACQUIRED 
	ON TRANSACTIONS USING btree (DateAcquired); 

/*Задание 1. Простые запросы*/
SELECT Name, Nationality 
FROM ARTISTS
WHERE Nationality NOT IN ('Russian', 'German') AND  BirthYear IS NULL
ORDER BY Name DESC, Nationality ASC; 

SELECT Nationality, COUNT(*) as Count_Nat
FROM ARTISTS 
GROUP BY Nationality
ORDER BY Count_Nat;

SELECT Nationality, COUNT(*) 
FROM ARTISTs GROUP BY Nationality 
HAVING COUNT(*) > 1;  	

SELECT Nationality, COUNT(*) 
FROM ARTISTS 
WHERE ArtistID < 106 
GROUP BY Nationality
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

SELECT * 
FROM ARTISTS 
WHERE Nationality LIKE 'S_anish'; 

SELECT * 
FROM ARTISTS 
WHERE Nationality LIKE 'M%'; 

SELECT MIN(SalesPrice), MAX(SalesPrice), SUM(SalesPrice) 
FROM TRANSACTIONS
WHERE TransactionID < 406; 

/*Задание 2. Оконные функции*/
SELECT Title, ArtistID, COUNT(*) 
OVER (PARTITION BY ArtistID) 
FROM WORKS 
ORDER BY ArtistID;

/*Задание 3. Составные запросы к нескольким таблицам, отношения*/
SELECT Title 
FROM WORKS 
WHERE WorkID IN (
	SELECT DISTINCT WorkID 
	FROM TRANSACTIONS
	WHERE SalesPrice > 20000); 

SELECT Title, SUM(SalesPrice)
FROM WORKS, TRANSACTIONS 
WHERE WORKS.WorkID = TRANSACTIONS.WorkID
GROUP BY Title; 

/*из трех таблиц*/
SELECT W.Title, SalesPrice, A.Name 
FROM WORKS W JOIN TRANSACTIONS T 
ON W.WorkID = T.WorkID 
JOIN ARTISTS A ON W.ArtistID = A.ArtistID;

SELECT DISTINCT Name 
FROM ARTISTS
WHERE ArtistID IN (
	SELECT ArtistID 
	FROM WORKS
	WHERE WorkID IN (
		Select WorkID 
		FROM TRANSACTIONS 
		WHERE SalesPrice > 20000 
		)
    );

/*Объединения*/
SELECT SalesPrice, AskingPrice
FROM TRANSACTIONS
WHERE WorkID = 301 
UNION 
	SELECT SalesPrice, AskingPrice 
	FROM TRANSACTIONS 
	WHERE CustomerID = 203; 

UPDATE WORKS 
SET Copy = '99/100', Description = 'Very Nice' 
WHERE WorkID = 302;

/*Представления*/
CREATE VIEW ArtistNameView AS 
SELECT Name AS ArtistName 
FROM ARTISTS 
ORDER BY Name; 

SELECT * FROM ArtistNameView;

CREATE VIEW BasicCustomerDataWa AS 
SELECT Name, PhoneNumber 
FROM CUSTOMERS 
WHERE State = 'WA'; 

SELECT * FROM BasicCustomerDataWa;

CREATE VIEW CustomerInterests AS 
SELECT C.Name AS Customer, A.Name AS Artist 
FROM CUSTOMERS C 
JOIN CUSTOMER_ARTIST_INT CI ON C.CustomerID = CI.CustomerID 
JOIN ARTISTS A ON CI.ArtistID = A.ArtistID; 

CREATE VIEW ArtistWorkNet AS 
SELECT W.WorkID, Name, Title, Copy, AcquisitionPrice, SalesPrice, (SalesPrice - AcquisitionPrice) AS NetPrice 
FROM TRANSACTIONS T 
JOIN WORKS W ON T.WorkID = W.WorkID 
JOIN ARTISTS A ON W.ArtistID = A.ArtistID; 

/*Транзакции*/
BEGIN TRANSACTION; 
	UPDATE WORKS 
	SET Copy = '99/100', Description = 'Very Nice' 
	WHERE WorkID = 302;
COMMIT TRANSACTION;
SELECT * FROM WORKS; 


/*Хранимые процедуры*/
CREATE OR REPLACE FUNCTION customer_insert(
	newname IN char, 
	newareacode IN char,
	newphone IN char,
	artistnationality IN char)
	RETURNS int AS $customer_insert$
DECLARE 
	artistcursor CURSOR FOR 
		SELECT ArtistID 
		FROM ARTISTS 
		WHERE Nationality = artistnationality; 
	rowcount int;
BEGIN 
	SELECT Count(*) INTO rowcount 
	FROM CUSTOMERS 
	WHERE Name = newname AND AreaCode = newareacode AND PhoneNumber = newphone;

	IF rowcount > 0 THEN 
		RAISE EXCEPTION 'There is client in DB! Count is %!', 
			rowcount; 
	END IF;

	INSERT INTO CUSTOMERS (CustomerID, Name, AreaCode, PhoneNumber) VALUES 
	(nextval('seq_customers'), newname, newareacode, newphone);

	FOR artist IN artistcursor LOOP INSERT INTO CUSTOMER_ARTIST_INT (CustomerID, ArtistID) VALUES 
	(currval('seq_customers'), artist.ArtistID); 
		
		RAISE INFO 'Artist %; Customer %', 
			currval('seq_customers'), artist.ArtistID; 

	END LOOP;

	RAISE INFO 'Client is added!';

	RETURN 1;
END; 
$customer_insert$ LANGUAGE plpgsql; 


/*Триггер. Условие: ни одна работа не может быть продана менее, чем за 90% от запрошенной цены*/
/* триггер обновления для таблицы TRANSACTIONS, сравнивающий значения AskingPrice и SalesPrice.Если правило нарушается,встолбец SalesPrice ставится значение столбца AskingPrice, а в столбец AskingPrice исходное значение
*/
CREATE OR REPLACE FUNCTION sales_price_check() 
	RETURNS trigger AS $sales_price_check$ 
BEGIN 
	IF NEW.SalesPrice < 0.9 * OLD.AskingPrice THEN 
		NEW.SalesPrice = OLD.AskingPrice; 
		NEW.AskingPrice = OLD.AskingPrice; 
	END IF;
	
	RETURN NEW;
END;
$sales_price_check$ LANGUAGE plpgsql;

CREATE TRIGGER sales_price_check 
	BEFORE UPDATE ON TRANSACTIONS 
	FOR EACH ROW EXECUTE PROCEDURE sales_price_check(); 