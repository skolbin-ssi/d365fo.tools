﻿ /*Variable input @Id,@SignInName,@Name,@SID, @StartUpCompany, @NetworkDomain, @IdentityProvider */

DROP TABLE IF EXISTS #TempUser 

SET Nocount ON;

DECLARE @TableId AS int,
        @RecId AS bigint,
		@ExistsCompany as int

SELECT @ExistsCompany = count(1) 
  FROM [dbo].[DIRPARTYTABLE]
  join dbo.[PARTITIONS] p on p.RECID = DIRPARTYTABLE.PARTITION
  where DATAAREA = @StartUpCompany

  if(@ExistsCompany = 0)
	set @StartUpCompany ='dat'
  
/* Get Admin to copy */
SELECT top 1 userInfo.* INTO #TempUser
FROM userinfo
JOIN [PARTITIONS] ON [PARTITIONS].Recid = userinfo.PARTITION
WHERE id = 'admin'
  AND PARTITIONKEY = 'initial'


/*Change row to match the new user */
UPDATE #TempUser
  SET 
    -- [RECID] = @RecId	  ,
    [ID] = @Id
	  ,[Name] = @Name
	  ,[SID] = @SID
	  ,[COMPANY] = @StartUpCompany
    ,[NETWORKALIAS] = @SignInName
	  ,RECVERSION = 1
    ,[NETWORKDOMAIN] = @NetworkDomain
    ,[IDENTITYPROVIDER] = @IdentityProvider
    ,[OBJECTID] = iif(@ObjectId = '',[OBJECTID],@ObjectId)
    ,[EXTERNALID] = ''
    


/* Create the user */

INSERT INTO userinfo(ID, NAME, ENABLE, DEL_STARTUPMENU, STATUSLINEINFO, TOOLBARINFO, DEBUGINFO, AUTOINFO, AUTOUPDATE, GARBAGECOLLECTLIMIT, HISTORYLIMIT, MESSAGELIMIT, GENERALINFO, SHOWSTATUSLINE, SHOWTOOLBAR, DEBUGGERPOPUP, SHOWAOTLAYER, DEL_PASSWORD, DEL_OSACCOUNTNAME, STARTUPPROJECT, CONFIRMDELETE, CONFIRMUPDATE, REPORTFONTNAME, REPORTFONTSIZE, FORMFONTNAME, FORMFONTSIZE, PROPERTYFONTNAME, PROPERTYFONTSIZE, INFOLOGLEVEL, COMPANY, AUTOLOGOFF, QUERYTIMELIMIT, TRACEINFO, REPORTTOPMARGIN, REPORTBOTTOMMARGIN, REPORTLEFTMARGIN, REPORTRIGHTMARGIN, COMPILERWARNINGLEVEL, SID, NETWORKDOMAIN, NETWORKALIAS, ENABLEDONCE, EXTERNALUSER, LANGUAGE, HELPLANGUAGE, PREFERREDTIMEZONE, PREFERREDCALENDAR, HOMEPAGEREFRESHDURATION, NOTIFYTIMEZONEMISMATCH, FILTERBYGRIDONBYDEFAULT, GLOBALFORMOPENMODE, DEL_DEFAULTMODELID, SHOWMODELNAMEINAOT, ACCOUNTTYPE, ISSUERRECID, CREDENTIALRECID, GLOBALLISTPAGELINKMODE, GLOBALEXCELEXPORTMODE, CLIENTACCESSLOGLEVEL, DEFAULTPARTITION, GLOBALEXCELEXPORTFILEPATH, EXTERNALIDTYPE, EXTERNALID, RECVERSION, PARTITION, PREFERREDLOCALE, IDENTITYPROVIDER, OBJECTID, INTERACTIVELOGON, ISMICROSOFTACCOUNT)
	SELECT ID, NAME, ENABLE, DEL_STARTUPMENU, STATUSLINEINFO, TOOLBARINFO, DEBUGINFO, AUTOINFO, AUTOUPDATE, GARBAGECOLLECTLIMIT, HISTORYLIMIT, MESSAGELIMIT, GENERALINFO, SHOWSTATUSLINE, SHOWTOOLBAR, DEBUGGERPOPUP, SHOWAOTLAYER, DEL_PASSWORD, DEL_OSACCOUNTNAME, STARTUPPROJECT, CONFIRMDELETE, CONFIRMUPDATE, REPORTFONTNAME, REPORTFONTSIZE, FORMFONTNAME, FORMFONTSIZE, PROPERTYFONTNAME, PROPERTYFONTSIZE, INFOLOGLEVEL, COMPANY, AUTOLOGOFF, QUERYTIMELIMIT, TRACEINFO, REPORTTOPMARGIN, REPORTBOTTOMMARGIN, REPORTLEFTMARGIN, REPORTRIGHTMARGIN, COMPILERWARNINGLEVEL, SID, NETWORKDOMAIN, NETWORKALIAS, ENABLEDONCE, EXTERNALUSER, LANGUAGE, HELPLANGUAGE, PREFERREDTIMEZONE, PREFERREDCALENDAR, HOMEPAGEREFRESHDURATION, NOTIFYTIMEZONEMISMATCH, FILTERBYGRIDONBYDEFAULT, GLOBALFORMOPENMODE, DEL_DEFAULTMODELID, SHOWMODELNAMEINAOT, ACCOUNTTYPE, ISSUERRECID, CREDENTIALRECID, GLOBALLISTPAGELINKMODE, GLOBALEXCELEXPORTMODE, CLIENTACCESSLOGLEVEL, DEFAULTPARTITION, GLOBALEXCELEXPORTFILEPATH, EXTERNALIDTYPE, EXTERNALID, RECVERSION, PARTITION, PREFERREDLOCALE, IDENTITYPROVIDER, OBJECTID, INTERACTIVELOGON, ISMICROSOFTACCOUNT FROM #TempUser

DROP TABLE #TempUser



SET Nocount OFF;
select count(1) from userinfo
where [RECID] = (SELECT MAX(Recid) FROM dbo.USERINFO)