--Run as sysdba
--Enable required packages

@?/rdbms/admin/utlmail.sql
@?/rdbms/admin/prvtmail.plb
@?/rdbms/admin/utlsmtp.sql

--Set SMTP Server Parameters

ALTER SYSTEM SET smtp_out_server = 'smtp.yourcompany.com' SCOPE = BOTH;
ALTER SYSTEM SET smtp_out_server_port = 25 SCOPE = BOTH; 

--Grant Required Privileges

GRANT EXECUTE ON UTL_MAIL TO your_user;
GRANT EXECUTE ON UTL_SMTP TO your_user;

--Network ACLs (for 11g and later)

BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl         => 'mail_acl.xml',
    description => 'Allow mail send',
    principal   => 'YOUR_USERNAME',
    is_grant    => TRUE,
    privilege   => 'connect'
  );

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
    acl        => 'mail_acl.xml',
    host       => 'smtp.yourcompany.com',
    lower_port => 25,
    upper_port => 25
  );
END;
/

CREATE TABLE production_data (
  well_id       VARCHAR2(50),
  production_dt DATE,
  volume        NUMBER
);

INSERT INTO production_data VALUES ('WELL-001', SYSDATE, 430);
INSERT INTO production_data VALUES ('WELL-002', SYSDATE, 600);
COMMIT;