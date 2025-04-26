--Enable Database Mail

/*
Open SSMS ? Go to "Object Explorer" ? "Management" ? Right-click "Database Mail" ? Configure.

Follow wizard to:

Create a Database Mail account

Assign an SMTP server (smtp.company.com, port 25 or 587)

Set up a Mail Profile (e.g., OilGasAlerts)

Test sending a test email to ensure it works.
*/

-Enable Database Mail in SQL Server

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;

--Create Table and Insert Sample Data

CREATE TABLE production_data (
  well_id       VARCHAR(50),
  production_dt DATE,
  volume        INT
);

INSERT INTO production_data VALUES ('WELL-001', GETDATE(), 430);
INSERT INTO production_data VALUES ('WELL-002', GETDATE(), 620);