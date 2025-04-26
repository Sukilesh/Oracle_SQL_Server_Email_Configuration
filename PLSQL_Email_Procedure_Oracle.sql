DECLARE
  l_mailhost   VARCHAR2(255) := 'your.smtp.server';
  l_sender     VARCHAR2(100) := 'alert@oilgas.com';
  l_recipient  VARCHAR2(100) := 'operations@company.com';
  l_subject    VARCHAR2(100) := '?? Low Production Alert';
  l_body       CLOB := '';
  l_conn       UTL_SMTP.connection;

BEGIN
  -- Collect message
  FOR r IN (
    SELECT well_id, volume, production_dt
    FROM production_data
    WHERE volume < 500
  ) LOOP
    l_body := l_body || 'Well ' || r.well_id || ' has low production: ' || r.volume || ' on ' || TO_CHAR(r.production_dt, 'YYYY-MM-DD') || CHR(10);
  END LOOP;

  IF l_body IS NOT NULL THEN
    l_conn := UTL_SMTP.open_connection(l_mailhost, 25);
    UTL_SMTP.helo(l_conn, l_mailhost);
    UTL_SMTP.mail(l_conn, l_sender);
    UTL_SMTP.rcpt(l_conn, l_recipient);
    UTL_SMTP.open_data(l_conn);

    UTL_SMTP.write_data(l_conn, 'From: ' || l_sender || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_conn, 'To: ' || l_recipient || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_conn, 'Subject: ' || l_subject || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_conn, 'Content-Type: text/plain' || UTL_TCP.crlf || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_conn, l_body);

    UTL_SMTP.close_data(l_conn);
    UTL_SMTP.quit(l_conn);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('Email error: ' || SQLERRM);
END;
/