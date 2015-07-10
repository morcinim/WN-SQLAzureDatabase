-- list all logins
SELECT * FROM sys.sql_logins;
--list databases
SELECT * FROM sys.databases; 
CREATE USER dev WITH PASSWORD = '######';
EXEC sp_addrolemember 'db_owner', 'dev';

-- Note: dev is database user
-- For demo to work you must to use secure connection string
-- create db contained user assign him to dbo
-- for example gpsesv12.database.secure.windows.net,1433
--  database user has to indicate database when loggin here: AdventureWorks2012



-- list products logged as dev to show maked results
Select * from SalesLT.Product


--open new connection as morcinim service admin