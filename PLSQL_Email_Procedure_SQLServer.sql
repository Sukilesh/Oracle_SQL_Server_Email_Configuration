DECLARE @Body NVARCHAR(MAX) = '';

SELECT @Body = COALESCE(@Body, '') +
    'Well ' + well_id + ' has low production: ' + 
    CAST(volume AS VARCHAR) + ' on ' + 
    CONVERT(VARCHAR, production_dt, 23) + CHAR(13) + CHAR(10)
FROM production_data
WHERE volume < 500;

IF LEN(@Body) > 0
BEGIN
  EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'OilGasAlerts',
    @recipients = 'operations@company.com',
    @subject = '?? Low Production Alert',
    @body = @Body,
    @body_format = 'TEXT';
END;