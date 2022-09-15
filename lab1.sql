-- Delete LoginGeny1
IF EXISTS(SELECT * FROM sys.server_principals WHERE name='LoginGeny1')
    BEGIN
        PRINT 'DROP LOGIN LoginGeny1'
        DROP LOGIN LoginGeny1;
    END

-- Delete LoginGeny2
IF EXISTS(SELECT * FROM sys.server_principals WHERE name='LoginGeny2')
    BEGIN
        PRINT 'DROP LOGIN LoginGeny2'
        DROP LOGIN LoginGeny2;
    END

-- Delete LoginGeny3
IF EXISTS(SELECT * FROM sys.server_principals WHERE name='LoginGeny3')
    BEGIN
        PRINT 'DROP LOGIN LoginGeny3'
        DROP LOGIN LoginGeny3;
    END
GO

-- Delete users
USE AdventureWorks2017;
GO
DROP USER IF EXISTS Geny1
DROP USER IF EXISTS Geny2
DROP USER IF EXISTS Geny3
GO

USE AdventureWorksDW2017;
GO
DROP USER IF EXISTS GenyDW
GO

-- Delete roles
DROP ROLE IF EXISTS [selectSchemaSales]
DROP ROLE IF EXISTS [selectUpdateSchemaHumanResources]

-- Principal code
USE AdventureWorks2017
GO

-- Create LoginGeny1
IF NOT EXISTS(SELECT * FROM sys.server_principals WHERE name='LoginGeny1')
    BEGIN
        PRINT 'CREATE LOGIN LoginGeny1'
        CREATE LOGIN LoginGeny1 WITH PASSWORD = 'Geny1&Pass'
    END

-- Create LoginGeny2
IF NOT EXISTS(SELECT * FROM sys.server_principals WHERE name='LoginGeny2')
    BEGIN
        PRINT 'CREATE LOGIN LoginGeny2'
        CREATE LOGIN LoginGeny2 WITH PASSWORD = 'Geny2&Pass'
    END

-- Create LoginGeny3
IF NOT EXISTS(SELECT * FROM sys.server_principals WHERE name='LoginGeny3')
    BEGIN
        PRINT 'CREATE LOGIN LoginGeny3'
        CREATE LOGIN LoginGeny3 WITH PASSWORD = 'Geny3&Pass'
    END
GO

-- Create Geny1
IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name='Geny1')
    BEGIN
        PRINT 'CREATE User Geny1'
        CREATE USER Geny1 FOR LOGIN LoginGeny1;
    END

-- Create Role to SELECT and UPDATE on schema HumanRecources
IF NOT EXISTS (SELECT * FROM sysusers WHERE name='selectUpdateSchemaHumanResources')
    BEGIN
        CREATE ROLE [selectUpdateSchemaHumanResources];
    END

-- Grant actions to role
GRANT SELECT, UPDATE ON SCHEMA :: HumanResources TO [selectUpdateSchemaHumanResources]

-- Add user to role
ALTER ROLE selectUpdateSchemaHumanResources ADD MEMBER Geny1
GO

-- Create Geny2
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='Geny2')
    BEGIN
		PRINT 'CREATE User Geny2'
        CREATE USER Geny2 FOR LOGIN LoginGeny2;
    END

-- Create ROLE to SELECT from schema sales 
IF NOT EXISTS (SELECT * FROM sysusers WHERE name='selectSchemaSales')
    BEGIN
        CREATE ROLE [selectSchemaSales]
    END

-- Grant permission to ROLE
GRANT SELECT ON SCHEMA :: Sales TO selectSchemaSales

-- Add UserName2 to ROLE
ALTER ROLE selectSchemaSales ADD MEMBER Geny2
GO

-- Create GenyDW
USE AdventureWorksDW2017
GO

IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name='GenyDW')
    BEGIN
		PRINT 'CREATE User GenyDW'
        CREATE USER GenyDW FOR LOGIN LoginGeny2;
    END

-- Add GenyDW to ROLE
ALTER ROLE db_owner ADD MEMBER GenyDW

-- Create Geny3
USE AdventureWorks2017
GO

IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name='Geny3')
BEGIN
	PRINT 'CREATE User Geny3'
    CREATE USER Geny3 FOR LOGIN LoginGeny3;
END
ALTER SERVER ROLE dbcreator ADD MEMBER LoginGeny3
GO
