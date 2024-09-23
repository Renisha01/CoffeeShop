--23010101655

CREATE TABLE Product (
    ProductID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ProductName varchar(50) NOT NULL,
    ProductPrice decimal(10,2) NOT NULL,
    ProductCode varchar(50) NOT NULL,
    Description varchar(50) NOT NULL,
    UserID int FOREIGN KEY REFERENCES New_User(UserID)
);
INSERT INTO Product (ProductName, ProductPrice, ProductCode, Description, UserID)
VALUES
('Item1', 100.00, '123', 'Item1 Description', 1),
('Item2', 200.00, '124', 'Item2 Description', 2),
('Item3', 300.00, '125', 'Item3 Description', 3);
--------------------------------------------------------------------------------------------------------------------------
CREATE TABLE New_User (
    UserID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    UserName varchar(50) NOT NULL,
    Email varchar(50) NOT NULL,
    Password varchar(50) NOT NULL,
    MobileNo varchar(50) NOT NULL,
    Address varchar(50) NOT NULL,
    IsActive bit NOT NULL
);
INSERT INTO New_User (UserName, Email, Password, MobileNo, Address, IsActive)
VALUES
('abc', 'abc@gmail.com', '123', '123', 'rajkot', 1),
('pqr', 'pqr@gmail.com', '456', '456', 'Du', 0),
('xyz', 'xyz@gmail.com', '789', '789', 'Diet', 1);
-------------------------------------------------------------------------------------------------------------------------
CREATE TABLE New_Order (
    OrderID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    OrderDate datetime NOT NULL,
    CustomerID int FOREIGN KEY REFERENCES Customer(CustomerID),
    PaymentMode varchar(50),
    TotalAmount decimal(10,2),
    ShippingAddress varchar(50) NOT NULL,
    UserID int FOREIGN KEY REFERENCES New_User(UserID)
);
INSERT INTO New_Order (OrderDate, CustomerID, PaymentMode, TotalAmount, ShippingAddress, UserID)
VALUES
('2023-01-01', 1, 'Credit Card', 1000.00, '123 Main St', 1),
('2023-02-01', 2, 'PayPal', 1500.00, '456 Elm St', 2),
('2023-03-01', 3, 'Debit Card', 2000.00, '789 Oak St', 3);
------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE OrderDetail (
    OrderDetailID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    OrderID int FOREIGN KEY REFERENCES New_Order(OrderID),
    ProductID int FOREIGN KEY REFERENCES Product(ProductID),
    Quantity int NOT NULL,
    Amount decimal(10,2),
    TotalAmount decimal(10,2),
    UserID int FOREIGN KEY REFERENCES New_User(UserID)
);
INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Amount, TotalAmount, UserID)
VALUES
(1, 1, 1, 100.00, 100.00, 1),
(2, 2, 2, 200.00, 400.00, 2),
(3, 3, 3, 300.00, 900.00, 3);
-------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Customer (
    CustomerID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    CustomerName varchar(50) NOT NULL,
    HomeAddress varchar(50) NOT NULL,
    Email varchar(50) NOT NULL,
    MobileNo varchar(50) NOT NULL,
    GST_NO varchar(50) NOT NULL,
    CityName varchar(50) NOT NULL,
    PinCode varchar(50) NOT NULL,
    NetAmount decimal(10,2) NOT NULL,
    UserID Int FOREIGN KEY REFERENCES New_User(UserID)
);
INSERT INTO Customer (CustomerName, HomeAddress, Email, MobileNo, GST_NO, CityName, PinCode, NetAmount, UserID)
VALUES
('John Doe', '123 Main St', 'john@example.com', '555-1234', 'GST123', 'CityA', '123456', 1000.00, 1),
('Jane Smith', '456 Elm St', 'jane@example.com', '555-5678', 'GST124', 'CityB', '654321', 1500.00, 2),
('Alice Johnson', '789 Oak St', 'alice@example.com', '555-9876', 'GST125', 'CityC', '789012', 2000.00, 3);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Bills (
    BillID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    BillNumber varchar(50) NOT NULL,
    BillDate datetime NOT NULL,
    OrderID int FOREIGN KEY REFERENCES New_Order(OrderID),
    TotalAmount decimal(10,2),
    Discount decimal(10,2),
    NetAmount decimal(10,2) NOT NULL,
    UserID int FOREIGN KEY REFERENCES New_User(UserID)
);
INSERT INTO Bills (BillNumber, BillDate, OrderID, TotalAmount, Discount, NetAmount, UserID)
VALUES
('BILL001', '2023-01-02', 1, 1000.00, 50.00, 950.00, 1),
('BILL002', '2023-02-02', 2, 1500.00, 75.00, 1425.00, 2),
('BILL003', '2023-03-02', 3, 2000.00, 100.00, 1900.00, 3);

SELECT * FROM New_User;
SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM New_Order;
SELECT * FROM OrderDetail;
SELECT * FROM Bills;

--------PROCEDURES--------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------### Table-Product ###----------------------------------------------------------------------

---GetALL & GetById 
CREATE PROCEDURE [dbo].[GetProducts]
    @ProductID int = NULL
AS
BEGIN
    IF @ProductID IS NULL
    BEGIN
        SELECT * FROM [dbo].Product;
    END
    ELSE
    BEGIN
        SELECT * FROM [dbo].Product WHERE ProductID = @ProductID;
    END
END;
EXEC [dbo].[GetProducts] 2

---INSERT
CREATE PROCEDURE [dbo].[InsertProduct]
    @ProductName varchar(50),
    @ProductPrice decimal(10,2),
    @ProductCode varchar(50),
    @Description varchar(50),
    @UserID int
AS
BEGIN
    INSERT INTO [dbo].Product (ProductName, ProductPrice, ProductCode, Description, UserID)
    VALUES (@ProductName, @ProductPrice, @ProductCode, @Description, @UserID);
END;
EXEC [dbo].[InsertProduct] 'Item4', 100.00, '123', 'Item4 Description', 3 

--UPDATE
CREATE PROCEDURE [dbo].[UpdateProduct]
    @ProductID int,
    @ProductName varchar(50),
    @ProductPrice decimal(10,2),
    @ProductCode varchar(50),
    @Description varchar(50),
    @UserID int
AS
BEGIN
    UPDATE [DBO].Product
    SET 
		ProductName = @ProductName,
        ProductPrice = @ProductPrice,
        ProductCode = @ProductCode,
        Description = @Description,
        UserID = @UserID
    WHERE ProductID = @ProductID;
END;
EXEC [dbo].[UpdateProduct] 4 ,'Item4', 100.00, '123', 'Item4 Des', 3 

--DELETE
CREATE PROCEDURE [dbo].[DeleteProduct]
    @ProductID int
AS
BEGIN
    DELETE FROM [DBO].Product WHERE ProductID = @ProductID;
END;
EXEC [dbo].[DeleteProduct] 4

-----------------------------------------------------### TABLE - USER ###----------------------------------------------------------------------

--GETALL & GETBYID
CREATE PROCEDURE [dbo].[GetNewUsers]
    @UserID int = NULL
AS
BEGIN
    IF @UserID IS NULL
    BEGIN
        SELECT * FROM [dbo].New_User;
    END
    ELSE
    BEGIN
        SELECT * FROM [dbo].New_User WHERE UserID = @UserID;
    END
END;
EXEC [dbo].[GetNewUsers]

--INSERT
CREATE PROCEDURE [dbo].[InsertNewUser]
    @UserName varchar(50),
    @Email varchar(50),
    @Password varchar(50),
    @MobileNo varchar(50),
    @Address varchar(50),
    @IsActive bit
AS
BEGIN
    INSERT INTO [DBO].New_User (UserName, Email, Password, MobileNo, Address, IsActive)
    VALUES (@UserName, @Email, @Password, @MobileNo, @Address, @IsActive);
END;
EXEC [dbo].[InsertNewUser] 'aaa', 'aaa@gmail.com', '123', '123', 'jam', 3




--Update
CREATE PROCEDURE [dbo].[UpdateNewUser]
    @UserID int,
    @UserName varchar(50),
    @Email varchar(50),
    @Password varchar(50),
    @MobileNo varchar(50),
    @Address varchar(50),
    @IsActive bit
AS
BEGIN
    UPDATE [dbo].New_User
    SET UserName = @UserName,
        Email = @Email,
        Password = @Password,
        MobileNo = @MobileNo,
        Address = @Address,
        IsActive = @IsActive
    WHERE UserID = @UserID;
END;
EXEC [dbo].[UpdateNewUser] 4 ,'aaa', 'aaa@gmail.com', '123', '123', 'jamnagar', 3

select * from New_User
--Delete
CREATE PROCEDURE [dbo].[DeleteNewUser]
    @UserID int
AS
BEGIN
    DELETE FROM [dbo].New_User WHERE UserID = @UserID;
END;
EXEC [dbo].[DeleteNewUser] 4

-----------------------------------------------------### TABLE - Order ###----------------------------------------------------------------------

--GetAll & GetById
CREATE PROCEDURE [dbo].[GetOrders]
    @OrderID int = NULL
AS
BEGIN
    IF @OrderID IS NULL
    BEGIN
        SELECT * FROM [dbo].New_Order;
    END
    ELSE
    BEGIN
        SELECT * FROM [dbo].New_Order WHERE OrderID = @OrderID;
    END
END;
EXEC [dbo].[GetOrders]

--Insert
CREATE PROCEDURE [dbo].[InsertOrder]
    @OrderDate datetime,
    @CustomerID int,
    @PaymentMode varchar(50),
    @TotalAmount decimal(10,2),
    @ShippingAddress varchar(50),
    @UserID int
AS
BEGIN
    INSERT INTO [dbo].New_Order (OrderDate, CustomerID, PaymentMode, TotalAmount, ShippingAddress, UserID)
    VALUES (@OrderDate, @CustomerID, @PaymentMode, @TotalAmount, @ShippingAddress, @UserID);
END;
EXEC [dbo].[InsertOrder] '2020-02-02', 3, 'Credit', 1000.00, 'Main St', 2

--Update
CREATE PROCEDURE [dbo].[UpdateOrder]
    @OrderID int,
    @OrderDate datetime,
    @CustomerID int,
    @PaymentMode varchar(50),
    @TotalAmount decimal(10,2),
    @ShippingAddress varchar(50),
    @UserID int
AS
BEGIN
    UPDATE [dbo].New_Order
    SET OrderDate = @OrderDate,
        CustomerID = @CustomerID,
        PaymentMode = @PaymentMode,
        TotalAmount = @TotalAmount,
        ShippingAddress = @ShippingAddress,
        UserID = @UserID
    WHERE OrderID = @OrderID;
END;
EXEC [dbo].[UpdateOrder] 4, '2020-02-02', 3, 'Credit', 2000.00, 'Main St', 2

--Delete
CREATE PROCEDURE [dbo].[DeleteOrder]
    @OrderID int
AS
BEGIN
    DELETE FROM New_Order WHERE OrderID = @OrderID;
END;
EXEC [dbo].[DeleteOrder] 4

-----------------------------------------------------### TABLE - Order_Details ###----------------------------------------------------------------------

--GetAll & GetById
CREATE PROCEDURE [dbo].[GetOrderDetails]
    @OrderDetailID int = NULL
AS
BEGIN
    IF @OrderDetailID IS NULL
    BEGIN
        SELECT * FROM [dbo].OrderDetail;
    END
    ELSE
    BEGIN
        SELECT * FROM [dbo].OrderDetail WHERE OrderDetailID = @OrderDetailID;
    END
END;
EXEC [dbo].[GetOrderDetails] 

--Insert
CREATE PROCEDURE [dbo].[InsertOrderDetail]
    @OrderID int,
    @ProductID int,
    @Quantity int,
    @Amount decimal(10,2),
    @TotalAmount decimal(10,2),
    @UserID int
AS
BEGIN
    INSERT INTO [dbo].OrderDetail (OrderID, ProductID, Quantity, Amount, TotalAmount, UserID)
    VALUES (@OrderID, @ProductID, @Quantity, @Amount, @TotalAmount, @UserID);
END;

--Update
CREATE PROCEDURE [dbo].[UpdateOrderDetail]
    @OrderDetailID int,
    @OrderID int,
    @ProductID int,
    @Quantity int,
    @Amount decimal(10,2),
    @TotalAmount decimal(10,2),
    @UserID int
AS
BEGIN
    UPDATE [dbo].OrderDetail
    SET OrderID = @OrderID,
        ProductID = @ProductID,
        Quantity = @Quantity,
        Amount = @Amount,
        TotalAmount = @TotalAmount,
        UserID = @UserID
    WHERE OrderDetailID = @OrderDetailID;
END;
CREATE PROCEDURE [dbo].[UpdateOrder]
    @OrderID int,
    @OrderDate datetime,
    @CustomerID int,
    @PaymentMode varchar(50),
    @TotalAmount decimal(10,2),
    @ShippingAddress varchar(50),
    @UserID int
AS
BEGIN
    UPDATE [dbo].New_Order
    SET OrderDate = @OrderDate,
        CustomerID = @CustomerID,
        PaymentMode = @PaymentMode,
        TotalAmount = @TotalAmount,
        ShippingAddress = @ShippingAddress,
        UserID = @UserID
    WHERE OrderID = @OrderID;
END;

--Delete
CREATE PROCEDURE [dbo].[DeleteOrderDetail]
    @OrderDetailID int
AS
BEGIN
    DELETE FROM [dbo].OrderDetail WHERE OrderDetailID = @OrderDetailID;
END;

-----------------------------------------------------### TABLE - Bills ###----------------------------------------------------------------------

--GetAll & GetById
CREATE PROCEDURE [dbo].[GetBills]
    @BillID int = NULL
AS
BEGIN
    IF @BillID IS NULL
    BEGIN
        SELECT * FROM Bills;
    END
    ELSE
    BEGIN
        SELECT * FROM Bills WHERE BillID = @BillID;
    END
END;
Exec [dbo].[GetBills]

--Insert
CREATE PROCEDURE [dbo].[InsertBill]
    @BillNumber varchar(50),
    @BillDate datetime,
    @OrderID int,
    @TotalAmount decimal(10,2),
    @Discount decimal(10,2),
    @NetAmount decimal(10,2),
    @UserID int
AS
BEGIN
    INSERT INTO [dbo].Bills (BillNumber, BillDate, OrderID, TotalAmount, Discount, NetAmount, UserID)
    VALUES (@BillNumber, @BillDate, @OrderID, @TotalAmount, @Discount, @NetAmount, @UserID);
END;

--Update
CREATE PROCEDURE [dbo].[UpdateBill]
    @BillID int,
    @BillNumber varchar(50),
    @BillDate datetime,
    @OrderID int,
    @TotalAmount decimal(10,2),
    @Discount decimal(10,2),
    @NetAmount decimal(10,2),
    @UserID int
AS
BEGIN
    UPDATE Bills
    SET BillNumber = @BillNumber,
        BillDate = @BillDate,
        OrderID = @OrderID,
        TotalAmount = @TotalAmount,
        Discount = @Discount,
        NetAmount = @NetAmount,
        UserID = @UserID
    WHERE BillID = @BillID;
END;

--Delete
CREATE PROCEDURE [dbo].[DeleteBill]
    @BillID int
AS
BEGIN
    DELETE FROM Bills WHERE BillID = @BillID;
END;

-----------------------------------------------------### TABLE - Customer ###----------------------------------------------------------------------

--GetAll & GetById
CREATE PROCEDURE [dbo].[GetCustomers]
    @CustomerID int = NULL
AS
BEGIN
    IF @CustomerID IS NULL
    BEGIN
        SELECT * FROM Customer;
    END
    ELSE
    BEGIN
        SELECT * FROM Customer WHERE CustomerID = @CustomerID;
    END
END;

--Insert
CREATE PROCEDURE [dbo].[InsertCustomer]
    @CustomerName varchar(50),
    @HomeAddress varchar(50),
    @Email varchar(50),
    @MobileNo varchar(50),
    @GST_NO varchar(50),
    @CityName varchar(50),
    @PinCode varchar(50),
    @NetAmount decimal(10,2),
    @UserID int
AS
BEGIN
    INSERT INTO Customer (CustomerName, HomeAddress, Email, MobileNo, GST_NO, CityName, PinCode, NetAmount, UserID)
    VALUES (@CustomerName, @HomeAddress, @Email, @MobileNo, @GST_NO, @CityName, @PinCode, @NetAmount, @UserID);
END;

--Update
CREATE PROCEDURE [dbo].[UpdateCustomer]
    @CustomerID int,
    @CustomerName varchar(50),
    @HomeAddress varchar(50),
    @Email varchar(50),
    @MobileNo varchar(50),
    @GST_NO varchar(50),
    @CityName varchar(50),
    @PinCode varchar(50),
    @NetAmount decimal(10,2),
    @UserID int
AS
BEGIN
    UPDATE Customer
    SET CustomerName = @CustomerName,
        HomeAddress = @HomeAddress,
        Email = @Email,
        MobileNo = @MobileNo,
        GST_NO = @GST_NO,
        CityName = @CityName,
        PinCode = @PinCode,
        NetAmount = @NetAmount,
        UserID = @UserID
    WHERE CustomerID = @CustomerID;
END;

--Delete
CREATE PROCEDURE [dbo].[DeleteCustomer]
    @CustomerID int
AS
BEGIN
    DELETE FROM Customer WHERE CustomerID = @CustomerID;
END;


insert into [dbo].[New_User] (UserName, Email, Password, MobileNo, Address, IsActive)
values
('John Doe', 'john.doe@example.com', 'password123', '1234567890', '123 Main St', 1),
('Jane Smith', 'jane.smith@example.com', 'password456', '0987654321', '456 Elm St', 1),
('Alice Johnson', 'alice.johnson@example.com', 'password789', '1122334455', '789 Pine St', 0),
('Bob Brown', 'bob.brown@example.com', 'password321', '2233445566', '321 Oak St', 1),
('Charlie Davis', 'charlie.davis@example.com', 'password654', '3344556677', '654 Cedar St', 0),
('David Evans', 'david.evans@example.com', 'password111', '4455667788', '111 Maple St', 1);











create PROCEDURE PR_Product_SelectByPK
    @ProductID INT
AS
BEGIN
    SELECT
        ProductID,
        ProductName,
        ProductPrice,
        ProductCode,
        Description,
        UserID
    FROM
        Product
    WHERE
        Product.[ProductID] = @ProductID
END
exec PR_Product_SelectByPK 1

-----------------------------------------------------
Create PROCEDURE [dbo].[PR_User_DropDown]
AS
BEGIN
    SELECT
		[dbo].[New_User].[UserId],
        [dbo].[New_User].[UserName]
    FROM
        [dbo].[New_User]
END

CREATE PROCEDURE [dbo].[PR_Product_DropDown]
AS
BEGIN
    SELECT
		[dbo].[Product].[ProductID],
        [dbo].[Product].[ProductName]
    FROM
        [dbo].[Product]
END

CREATE PROCEDURE [dbo].[PR_User_DropDown_IsActive]
AS
BEGIN
    SELECT
		[dbo].[New_User].[IsActive]
    FROM
        [dbo].[New_User]
END
exec [dbo].[PR_User_DropDown_IsActive] 1

CREATE PROCEDURE [dbo].[PR_Customer_DropDown]
AS
BEGIN
    SELECT
	[dbo].[Customer].[CustomerID],
        [dbo].[Customer].[CustomerName]
    FROM
        [dbo].[Customer]
END


CREATE PROCEDURE [dbo].[PR_Order_DropDown]
AS
BEGIN
    SELECT
	[dbo].[Bills].[OrderID]
    FROM
        [dbo].[Bills]
END


CREATE PROCEDURE [dbo].[PR_Bills_SelectByPK]
@BillID int
as 
begin
 select * from Bills where BillID=@BillID
end


CREATE PROCEDURE [dbo].[PR_Order_SelectByPK]
@OrderID int
as 
begin
 select * from Orders where OrderID=@OrderID
end

CREATE PROCEDURE [dbo].[PR_OrderDetail_SelectByPK]
@OrderDetailID int
as 
begin
 select * from OrderDetail where OrderDetailID=@OrderDetailID
end

CREATE PROCEDURE [dbo].[PR_Customer_SelectByPK]
@CustomerID int
as 
begin
 select * from Customer where CustomerID=@CustomerID
end


select * from Bills

--------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_User_Login]

			@UserName			nvarchar(50),
			@Password			nvarchar(50)
AS 
Begin
SELECT
		 [dbo].[New_User].[UserID]
		,[dbo].[New_User].[UserName]
		,[dbo].[New_User].[Email]
		,[dbo].[New_User].[Password]
		,[dbo].[New_User].[MobileNo]
		,[dbo].[New_User].[IsActive]
		,[dbo].[New_User].[Address]

FROM	 [dbo].[New_User]
WHERE	[dbo].[New_User].[UserName] = @UserName 
AND		[dbo].[New_User].[Password] = @Password
end

------------------------------------------------------------------------------------------------------------------------
