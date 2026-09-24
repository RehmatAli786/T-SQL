ALTER TABLE pos.Tax
ADD ApplicationId INT NULL;

ALTER TABLE pos.Discount
ADD ApplicationId INT NULL;

ALTER TABLE pos.Customers
ADD ApplicationId INT NULL;

ALTER SCHEMA dbo TRANSFER pos.Tax;
ALTER SCHEMA dbo TRANSFER pos.Discount;
ALTER SCHEMA dbo TRANSFER pos.Customers;


IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'shp')
BEGIN
	EXEC('CREATE SCHEMA shp')
END
GO

CREATE TABLE shp.ItemCategories(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,
	Name VARCHAR(50),
	Color VARCHAR(10),
	IsDeleted bit,

	CreatedById UNIQUEIDENTIFIER,
	CreatedAt DATETIME2(7),
	ModifiedById UNIQUEIDENTIFIER NULL,
	ModifiedDate DATETIME2(7) NULL,

	CONSTRAINT PK_ItemCategories_Id PRIMARY KEY(Id),
	CONSTRAINT FK_ItemCategories_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id)
);

CREATE TABLE shp.Items(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,
	Name VARCHAR(100),
	Description VARCHAR(450) NULL,
	Price DECIMAL(18, 2),
	Image VARCHAR(50),
	IsDeleted bit,

	CategoryId INT NULL,

	CreatedById UNIQUEIDENTIFIER,
	CreatedAt DATETIME2(7),
	ModifiedById UNIQUEIDENTIFIER NULL,
	ModifiedDate DATETIME2(7) NULL,

	CONSTRAINT PK_Items_Id PRIMARY KEY(Id),
	CONSTRAINT FK_Items_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id),
	CONSTRAINT FK_Items_ItemCategories_CategoryId FOREIGN KEY(CategoryId) REFERENCES shp.ItemCategories(Id)
);

CREATE TABLE shp.ItemPriceDetails(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,
	Name VARCHAR(100),
	Price DECIMAL(18, 2),
	IsDeleted bit,

	ItemId INT NOT NULL,

	CreatedById UNIQUEIDENTIFIER,
	CreatedAt DATETIME2(7),
	ModifiedById UNIQUEIDENTIFIER NULL,
	ModifiedDate DATETIME2(7) NULL,

	CONSTRAINT PK_ItemPriceDetails_Id PRIMARY KEY(Id),
	CONSTRAINT FK_ItemPriceDetails_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id),
	CONSTRAINT FK_ItemPriceDetails_Items_ItemId FOREIGN KEY(ItemId) REFERENCES shp.Items(Id)
);

CREATE TABLE shp.Orders(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,
	OrderType INT,
	ItemCount INT,
	Status INT,
	CancelReason VARCHAR(450) NULL,

	Feedback VARCHAR(450) NULL,
	Rating DECIMAL(2, 1) NULL,
	RiderFeedback VARCHAR(450) NULL,
	RiderRating DECIMAL(2, 1) NULL,

	IsPaid BIT,
	IsDeleted BIT,

	Discount DECIMAL(18, 2),
	Tax DECIMAL(18, 2),
	DeliveryCharge DECIMAL(18, 2),
	DeliveryDiscount DECIMAL(18, 2),
	ItemDiscount DECIMAL(18, 2),
	TotalDiscount DECIMAL(18, 2),
	GrossTotal DECIMAL(18, 2),
	NetTotal DECIMAL(18, 2),

	RiderId NVARCHAR(450) NULL,
	CustomerId INT,
	TaxId INT NULL,
	DiscountId INT NULL,

	CreatedById UNIQUEIDENTIFIER,
	CreatedAt DATETIME2(7),
	ModifiedById UNIQUEIDENTIFIER NULL,
	ModifiedDate DATETIME2(7) NULL,

	CONSTRAINT PK_Orders_Id PRIMARY KEY(Id),
	CONSTRAINT FK_Orders_AspNetUsers_RiderId FOREIGN KEY(RiderId) REFERENCES dbo.AspNetUsers(Id),
	CONSTRAINT FK_Orders_Discount_DiscountId FOREIGN KEY(DiscountId) REFERENCES dbo.Discount(Id),
	CONSTRAINT FK_Orders_Tax_TaxId FOREIGN KEY(TaxId) REFERENCES dbo.Tax(Id),
	CONSTRAINT FK_Orders_Customers_CustomerId FOREIGN KEY(CustomerId) REFERENCES dbo.Customers(Id),
	CONSTRAINT FK_Orders_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id),
);

CREATE TABLE shp.OrderItems(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,

	Remark VARCHAR(450),

	OrderId INT,
	ItemId INT,
	ItemPriceDetailId INT,

	Quantity INT,
	UnitPrice DECIMAL(18, 2),
	TotalPrice DECIMAL(18, 2),

	TaxAmount DECIMAL(18, 2),
	DiscountAmount DECIMAL(18, 2),

	TaxId INT NULL,
	DiscountId INT NULL,

	IsDeleted BIT,

	CreatedById UNIQUEIDENTIFIER,
	CreatedAt DATETIME2(7),
	ModifiedById UNIQUEIDENTIFIER NULL,
	ModifiedDate DATETIME2(7) NULL,

	CONSTRAINT PK_OrderItems_Id PRIMARY KEY(Id),
	CONSTRAINT FK_OrderItems_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id),
	CONSTRAINT FK_OrderItems_Discount_DiscountId FOREIGN KEY(DiscountId) REFERENCES dbo.Discount(Id),
	CONSTRAINT FK_OrderItems_Tax_TaxId FOREIGN KEY(TaxId) REFERENCES dbo.Tax(Id),
	CONSTRAINT FK_OrderItems_Orders_OrderId FOREIGN KEY(OrderId) REFERENCES shp.Orders(Id),
	CONSTRAINT FK_OrderItems_Items_ItemId FOREIGN KEY(ItemId) REFERENCES shp.Itmes(Id),
	CONSTRAINT FK_OrderItems_ItemPriceDetails_ItemPriceDetaild FOREIGN KEY(ItemPriceDetailId) REFERENCES shp.ItemPriceDetails(Id),
);

CREATE TABLE shp.OrderPayments(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,

	PaymentName VARCHAR(50),
	OrderId INT,
	PaymentId INT,

	CONSTRAINT PK_OrderPayments_Id PRIMARY KEY(Id),
	CONSTRAINT FK_OrderPayments_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id),
	CONSTRAINT FK_OrderPayments_PaymentMethods_PaymentId FOREIGN KEY(PaymentId) REFERENCES tenant.PaymentMethods(Id),
	CONSTRAINT FK_OrderPayments_Orders_OrderId FOREIGN KEY(OrderId) REFERENCES shp.Orders(Id),
);

CREATE TABLE shp.OrderLogs(
	Id INT IDENTITY(1, 1),
	TenantId INT NOT NULL,

	OrderId INT,
	LogType INT,

	Title VARCHAR(100),
	Description VARCHAR(450),

	CreatedById UNIQUEIDENTIFIER,
	CreatedAt DATETIME2(7),
	ModifiedById UNIQUEIDENTIFIER NULL,
	ModifiedDate DATETIME2(7) NULL,

	CONSTRAINT PK_OrderLogs_Id PRIMARY KEY(Id),
	CONSTRAINT FK_OrderLogs_Tenants_TenantId FOREIGN KEY(TenantId) REFERENCES dbo.Tenants(Id),
	CONSTRAINT FK_OrderLogs_Orders_OrderId FOREIGN KEY(OrderId) REFERENCES shp.Orders(Id),
);
