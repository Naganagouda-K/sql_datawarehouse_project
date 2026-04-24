/*
Script Puropse : This script checks for the existence of the 'DataWarehouse' database, drops it if present, and recreates it. It also initializes three schemas within the database: bronze, silver, and gold.
*/

Use master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create new database
Create database DataWarehouse;
Go
use DataWarehouse;
Go
  
-- Create schemas
Create schema bronze;
go
Create schema silver;
go
Create schema gold;
go
