SELECT
    username,
    COUNT(*) AS total_sessions,
    SEC_TO_TIME(SUM(acctsessiontime)) AS total_time_hms,
    ROUND(SUM(acctinputoctets) / 1024 / 1024 / 1024, 2) AS total_upload_gb,
    ROUND(SUM(acctoutputoctets) / 1024 / 1024 / 1024, 2) AS total_download_gb,
    ROUND(SUM(acctinputoctets + acctoutputoctets) / 1024 / 1024 / 1024, 2) AS total_gb
FROM radacct
GROUP BY username
ORDER BY total_gb DESC;
