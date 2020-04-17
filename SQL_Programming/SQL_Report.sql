-- #1 total orders and sales from 2017-present
Select
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales',
	sum(OrderValue)/Count(OrderId) Average_Order_Value
From
	Orders

-- #2 total orders and sales by year
Select
	Year([Date]) AS Year,
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Group By
	Year([Date])
Order By
	Year([Date])

Select * From Country

-- #3 total orders and sales by quarter
Select
	C.[Quarter],
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders O
Inner Join
	Calendar C ON C.[Date] = O.[Date]
Where
	Quarter <> '2019-Q2'
Group By
	C.[Quarter]
Order By
	C.[Quarter]

-- #4 total sales by week
Select
	CONCAT(Year([Date]), CONCAT('-', DATEPART(wk, [Date]))) AS Year,
	Year([Date]),
	DATEPART(wk, [Date]),
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Group By
	CONCAT(Year([Date]), CONCAT('-', DATEPART(wk, [Date]))), Year([Date]),	DATEPART(wk, [Date])
Order By
	Year([Date]), DATEPART(wk, [Date])

Select
	Year([Date]),
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Group By
	[Date]
Order By
	[Date]


Select
	Quarter,
	Count(OrderId)/2 AS 'Total Orders',
	Format(sum(OrderValue)/2, 'C', 'en-us') AS 'Total Sales'
From
	Orders

Where
	Year([Date]) <> 2019
Group By
	Month([Date]) 
Order By
	Month([Date])



-- #6 Sales by month to see monthly trends, not including 2019
Select
	Month([Date]) AS Month,
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Where
	Year([Date]) <> 2019
Group By
	Month([Date]) 
Order By
	sum(OrderValue) desc

-- #7 all orders, grouped by size (sums to 175M ***)
Select
	max(Customer.CompanyName) Company_Name,
	max(Industry) Industry,
	Orders.OrderID,
	max(Orders.[Date]) Order_Date,
	Format(sum(OrderValue), 'C', 'en-us') Order_Value
FROM
	Orders
Inner Join 
	Customer ON Customer.CompanyId = Orders.CompanyId
Group By
	Orders.OrderId
Order By
	sum(Orders.OrderValue) desc


	



-- #8 Sales by Region
Select
	Region,
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Inner Join
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	Country ON Country.CountryId = Customer.Country
Group By
	Region
Order By
	sum(OrderValue) desc

-- #9 Sales by Country (add sales by country per quarter)
Select
	CountryName,
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Inner Join
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	Country ON Country.CountryId = Customer.Country
Group By
	CountryName
Order By
	sum(OrderValue) desc

-- #10 sales by state in US
Select
	ShipToState,
	Count(OrderId) AS 'Total Orders',
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Inner Join
	Customer ON Customer.CompanyId = Orders.CompanyId
Where
	Country = 'US'
Group By
	ShipToState
Order By
	sum(OrderValue) desc

-- #11 Sales by State per Quarter
Select
	ShipToState,
	Quarter,
	Format(sum(OrderValue), 'C', 'en-us') AS 'Total Sales'
From
	Orders
Inner Join
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	Calendar ON Calendar.[Date] = Orders.[Date]
Where
	[Quarter] <> '2019-Q2'
	AND Country = 'US'
	AND ShipToState in ('CA', 'TX', 'NY', 'FL', 'IL', 'PA', 'NJ', 'MA', 'GA',
					'MD', 'OH', 'VA', 'MI', 'WA', 'NC', 'CO')
Group By
	ShipToState, Quarter
Having 
	sum(OrderValue) > 25000
Order By
	ShipToState, Quarter



-- #12 Sales by Product (not right yet-- sums to 175M)
Select
	OrderLine.ProductId,
	sum(Quantity) AS Amount_Sold,
	Format(avg(ListPrice), 'C', 'en-us') AS List_Price,
	Format(sum(Quantity * ListPrice), 'C', 'en-us') AS 'Total Sales'
From
	OrderLine
Inner Join
	Orders ON Orders.OrderId = OrderLine.OrderId
Group By
	ProductId
Order By
	sum(Quantity*ListPrice) desc

-- #13 Product Sales by Quarter
Select
	Quarter,
	OrderLine.ProductId,
	Format(sum(Quantity * ListPrice), 'C', 'en-us') AS 'Total Sales'
From
	OrderLine
Inner Join
	Orders ON Orders.OrderId = OrderLine.OrderId
Inner Join
	Calendar ON Calendar.[Date] = Orders.[Date]
Where
	[Quarter] <> '2019-Q2'
Group By
	ProductId, Quarter
Order By
	ProductId, Quarter

-- #14 Sales by LoB
Select
	LineOfBusiness,
	sum(Quantity) AS Amount_Sold,
	Format(avg(ListPrice), 'C', 'en-us') AS List_Price,
	Format(sum(Quantity * ListPrice), 'C', 'en-us') AS 'Total Sales'
From
	OrderLine
Inner Join
	Product ON OrderLine.ProductId = Product.ProductId
Group By
	LineOfBusiness
Order By
	sum(Quantity*ListPrice) desc

-- #15 Sales of LoB by Quarter (useful for YoY variance of LoB, shows where company is suffering/thriving)
Select
	LineOfBusiness,
	[Quarter],
	Format(sum(Quantity * ListPrice), 'C', 'en-us') AS 'Total Sales'
From
	OrderLine
Inner Join
	Product ON OrderLine.ProductId = Product.ProductId
Inner Join
	Orders ON Orders.OrderId = OrderLine.OrderId
Inner Join
	Calendar ON Calendar.[Date] = Orders.[Date]
Where
	[Quarter] <> '2019-Q2'
Group By
	LineOfBusiness, [Quarter]
Order By
	LineOfBusiness, [Quarter]

-- #16 By Product By Region (sums to $175M)
Select
	OrderLine.ProductId,
	Region,
	sum(Quantity) AS Amount_Sold,
	Format(avg(ListPrice), 'C', 'en-us') AS List_Price,
	Format(sum(Quantity * ListPrice), 'C', 'en-us') AS 'Total Sales'
From
	OrderLine
Inner Join
	Orders ON Orders.OrderId = OrderLine.OrderId
Inner Join
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	Country ON Country.CountryId = Customer.Country
Group By
	ProductId, Region
Order By
	ProductId



-- #17 sales by each customer (sums to 175M ***)
Select
	Customer.CompanyName,
	Country.CountryName,
	count(DISTINCT Orders.OrderId) Order_count,
	Format(sum(OrderValue), 'C', 'en-us') Total_Purchases
FROM
	Orders
	Inner Join Customer ON Customer.CompanyId = Orders.CompanyId
	Inner Join Country ON Country.CountryId = Customer.Country
Group By
	Customer.CompanyName, Country.CountryName
Order BY
	sum(Orders.OrderValue) desc


-- #17.5 Sales by customer industry
Select
	Customer.Industry,
	count(DISTINCT Orders.OrderId) Order_Count,
	Format(sum(OrderValue), 'C', 'en-us') Total_Purchases
FROM
	Orders
Inner Join 
	Customer ON Customer.CompanyId = Orders.CompanyId
Group By
	Customer.Industry
Order BY
	sum(OrderValue) desc

-- #18 Sales by customer industry by quarter
Select
	Customer.Industry,
	Calendar.[Quarter],
	count(DISTINCT Orders.OrderId) Order_Count,
	Format(sum(OrderValue), 'C', 'en-us') Total_Purchases
FROM
	Orders
Inner Join 
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	Calendar ON Calendar.[Date] = Orders.[Date]
Where
	Quarter <> '2019-Q2'
	AND Industry in ('Services', 'Computer Services', 'Manufacturing', 'Wholesale & Distribution',
					 'Retail', 'Healthcare', 'Construction', 'Financial Services', 'Media & Publishing',
					 'Nonprofit', 'Legal Services')
Group By
	Customer.Industry, Calendar.[Quarter]
Order BY
	Industry, Quarter

-- #18.5 # of Customers by each Country
Select
	CountryName,
	Count(Distinct Orders.CompanyId) AS Customer_Count
From 
	Country
Inner Join
	Customer ON Customer.Country = Country.CountryId
Inner Join
	Orders ON Orders.CompanyId = Customer.CompanyId
Group By
	CountryName
Order By
	Count(Orders.CompanyId) desc

-- #18.75 # of Customer per country per year, shows customer retention and new customer growth ( need subqueries and set operators i.e. intersect and minus)
Select
	CountryName,
	Year([Date]),
	Count(Distinct Orders.CompanyId) AS Customer_Count
From 
	Country
Inner Join
	Customer ON Customer.Country = Country.CountryId
Inner Join
	Orders ON Orders.CompanyId = Customer.CompanyId
Where
	Year([Date]) <> 2019
Group By
	CountryName, Year([Date])
Order By
	Count(Orders.CompanyId) desc


-- #19 Sales by Customer Industry for lob (not right yet, somethign wrong with order/orderline join)
Select
	Customer.Industry,
	LineOfBusiness,
	count(DISTINCT Orders.OrderId) Order_Count,
	Format(sum(Quantity*ListPrice), 'C', 'en-us') Total_Purchases_OL
FROM
	Orders
Inner Join 
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	OrderLine ON OrderLine.OrderId = Orders.OrderId
Inner Join
	Product ON Product.ProductId = OrderLine.ProductId
Where
	Industry in ('Services', 'Computer Services', 'Manufacturing', 'Wholesale & Distribution',
					 'Retail', 'Healthcare', 'Construction', 'Financial Services', 'Media & Publishing',
					 'Nonprofit', 'Legal Services')
Group By
	Industry, LineOfBusiness
Order BY
	Industry, LineOfBusiness

Select
	LineOfBusiness,
	Year(Orders.[Date]),
	count(DISTINCT OrderLine.OrderLineId) Purchase_Count,
	Format(sum(Quantity*ListPrice), 'C', 'en-us') Value_Sold
From
	OrderLine
Inner Join
	Product ON Product.ProductId = OrderLine.ProductId
Inner Join
	Orders ON Orders.OrderId = OrderLine.OrderId
Inner Join
	Calendar ON Calendar.[Date]  = Orders.[Date]
Group By
	LineOfBusiness, Year(Orders.[Date])
Order By
	sum(Quantity*ListPrice) desc
	



-- #20 Sales by Customer Industry for lob per quarter (not right yet, somethign wrong with order/orderline join)
Select
	Customer.Industry,
	Calendar.[Quarter],
	LineOfBusiness,
	count(DISTINCT Orders.OrderId) Order_Count,
	Format(sum(OrderValue), 'C', 'en-us') Total_Purchases
FROM
	Orders
Inner Join 
	Customer ON Customer.CompanyId = Orders.CompanyId
Inner Join
	Calendar ON Calendar.[Date] = Orders.[Date]
Inner Join
	OrderLine ON OrderLine.OrderId = Orders.OrderId
Inner Join
	Product ON Product.ProductId = OrderLine.ProductId
Where
	Quarter <> '2019-Q2'
Group By
	Customer.Industry, LineOfBusiness, Calendar.[Quarter]
Order BY
	Industry, LineOfBusiness, Quarter

-- Main Questions
	-- OrderLine 2 Order joins create incorrect totals
	-- WHat is the best way to analyze growth, quarter to quarter or the YoY variance, is there a way to show both?

SELECT
       CompanyId
FROM
       ORDERS
WHERE
   ORDERDATE between  '1/1/2017'  and '12/31/2017'
INTERSECT
SELECT
       CompanyId
FROM
       ORDERS
WHERE
   ORDERDATE  between  '1/1/2018'  and '12/31/2018'



-- Fixes
Select 
	OrderId
From 
	Orders 
where not exists 
	(select OrderId from OrderLine where Orders.OrderId = OrderLine.OrderId)

Delete Orders where OrderId in (2155695, 2151181, 2097484, 2153982)

UPDATE ORDERS

SET ORDERVALUE =  (SELECT SUM(QUANTITY * ListPrice) FROM ORDERLINE  WHERE ORDERLINE.ORDERID = ORDERS.ORDERID GROUP BY ORDERLINE.ORDERID) 

UPDATE Product
Set LineOfBusiness = 'Software' Where LineOfBusiness = 'LOB A'

Update Product
Set LineOfBusiness = 'Accessory Components' Where LineOfBusiness = 'LOB B'

Update Product
Set LineOfBusiness = 'Routers' Where LineOfBusiness = 'LOB C'

Update Product
Set LineOfBusiness = 'Maintenance' Where LineOfBusiness = 'LOB D'

Update Product
Set LineOfBusiness = 'Installation' Where LineOfBusiness = 'LOB E'


DELETE 
	ORDERS
WHERE
	CompanyId IN (529161,888329,1823247,1549002,1823230,888339,888343,888334,1360709,482875,888327,1604908,
				   1851876,1589154,1702198,1251901,872261,872259,1796376,796375,1852340,1736595,1086887,1851107,
				   1850047,888330,1850071,969967,1852884,487545,1856437,1338842,1820857,998960)

DELETE 
	CUSTOMER
WHERE
	CompanyId IN (529161,888329,1823247,1549002,1823230,888339,888343,888334,1360709,482875,888327,1604908,
				   1851876,1589154,1702198,1251901,872261,872259,1796376,796375,1852340,1736595,1086887,1851107,
				   1850047,888330,1850071,969967,1852884,487545,1856437,1338842,1820857,998960)

DELETE 
	ORDERLINE
WHERE
	ORDERID NOT IN (SELECT ORDERID FROM ORDERS WHERE ORDERS.ORDERID = ORDERLINE.ORDERID)