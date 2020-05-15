﻿/* Variable input @FlightName,@FlightServiceId */

DECLARE 
	@Enabled AS int,
	@RecId AS bigint

SELECT @Enabled = [ENABLED], @RecId = SYSFLIGHTING.RECID
FROM SYSFLIGHTING
JOIN [PARTITIONS] ON [PARTITIONS].Recid = SYSFLIGHTING.PARTITION
WHERE FLIGHTNAME = @FlightName
  AND PARTITIONKEY = 'initial'

if (@Enabled = 1)
	return
else if (@Enabled = 0)
	UPDATE SYSFLIGHTING SET ENABLED = 1 WHERE RECID = @RecId
else
	INSERT INTO SYSFLIGHTING (FLIGHTNAME, ENABLED, FLIGHTSERVICEID) VALUES (@FlightName, 1, @FlightServiceId)
