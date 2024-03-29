/* 
THIS SQL RETURNS SAME CONTENT AS TCODE /UI2/FLPCM_CUST 
but has the Fiori Apps Libary Detail and makes it easier Cross Client
BEWARE OF CLIENT CONTEXT - ADJUST ACCORDING TO THE GOLDEN/FIORI DEV used CLIENT 
ADJUST CATALOG SEARCH / APP SEARCH IN LAST WHERE CLAUSE with 'ZBC_TS'
*/

with cte_fioriapp_pfcg_role as
(
SELECT AGR_NAME,
CASE WHEN SUBSTR_REGEXPR('(.+)\:(.+)' IN URL GROUP 1 ) = 'sap-ui2-group' THEN 
SUBSTR_REGEXPR('(.+)\:(.+)' IN URL GROUP 1 ) END AS ID_GROUP,
CASE WHEN SUBSTR_REGEXPR('(.+)\:(.+)' IN URL GROUP 1 ) = 'sap-ui2-group' THEN 
SUBSTR_REGEXPR('(.+)\:(.+)' IN URL GROUP 2 ) END AS GROUP_NAME,
SUBSTR_REGEXPR('(.+)\:(.+)' IN SUBSTRING(URL,1,LOCATE(URL,'?',1)-1) GROUP 1 ) AS ID_TYPE_CATALOG,
CASE WHEN SUBSTR_REGEXPR('(.+)\:(.+)' IN URL GROUP 1 ) =  'X-SAP-UI2-CATALOGPAGE' THEN
SUBSTR_REGEXPR('(.+)\:(.+)' IN SUBSTRING(URL,1,LOCATE(URL,'?',1)-1) GROUP 2 ) END AS CATALOG_NAME,
SUBSTRING(URL,1,LOCATE(URL,'?',1)-1) AS TECHNICAL_CATALOG_NAME
FROM AGR_BUFFI
WHERE MANDT = '300' AND SUBSTR_REGEXPR('(.+)\:(.+)' IN URL GROUP 1 ) IN ('sap-ui2-group','X-SAP-UI2-CATALOGPAGE')
AND ( AGR_NAME LIKE 'TS%' OR AGR_NAME LIKE 'ZSAP%' OR AGR_NAME LIKE 'SAP%' )
)
,
cte_uploaded_fiori_apps as
(
SELECT 
FIORI_ID
,LINE_OF_BUSINESS
,SCOPE_ITEM
,ROLE_NAME
,APP_NAME
,APPLICATION_TYPE
,APP_LAUNCHER_TITLE_SUBTITLE
,LIGHTHOUSE
,APPLICATION_COMPONENT
,UI_TECHNOLOGY
,DEVICE_TYPE
,PRODUCT_CATEGORY
,DATABASE_ID
,FRONTEND_SOFTWARE_COMPONENT
,FRONTEND_MIN_SP
,BACKEND_SOFTWARE_COMP_VERSIONS
,BACKEND_MIN_SP
,HANA_SOFTWARE_COMP_VERSIONS
,HANA_MIN_SP
,FRONTEND_PRODUCT_VERSION
,PRODUCT_VERSION_NAME_BACKEND
,HANA_PRODUCT_VERSION
,FRONTEND_PRODUCT_VERSION_STACK
,BACKEND_PRODUCT_VERSION_STACK
,HANA_PRODUCT_VERSION_STACK
,NOTE_COLLECTION
,SEMANTIC_OBJECT_ACTION
,TECHNICAL_CATALOG_NAME
,TECHNICAL_CATALOG_DESCRIPTION
,BUSINESS_CATALOG_NAME
,BUSINESS_CATALOG_DESCRIPTION
,BUSINESS_GROUP_NAME
,BUSINESS_GROUP_DESCRIPTION
,LEADING_BUSINESS_ROLE_NAME
,LEADING_BUSINESS_ROLE_DESCR
,ADDITIONAL_BUSINESS_ROLE_NAME
,ADDITIONAL_BUSINESS_ROLE_DESCR
,INDUSTRY
,GTM_APP_DESCRIPTION
,BSP_NAME
,lower(BSP_APPLICATION_URL) AS BSP_APPLICATION_URL
,SAPUI5_COMPONENT_ID
,PRIMARY_ODATA_SERVICE_NAME
,PRIMARY_ODATASERVICE_VERSION
,ADDITIONAL_ODATA_SERVICES
,ADDITIONAL_ODATASERVICES_VERS
,BEX_QUERY_NAME
,LEADING_TRANSACTION_CODES
,WDA_CONFIGURATION
,SUBSTRING(LINK,1,LOCATE(LINK,';',1)-2) AS LINK
FROM ZTBC_C_FIORI_APP
WHERE MANDT = '300'
/*
AND TECHNICAL_CATALOG_NAME = 'SAP_HCMFAB_TC_T'
AND lower(BSP_APPLICATION_URL) = '/sap/bc/ui5_ui5/sap/hcmfab_pay_mon'
*/
)
,
cte_fiori_installed_apps as
(
SELECT 
"ORIG" . "ID" , "ORIG" . "PARENTID" , 
SUBSTR_REGEXPR('(.+)\:(.+)\:(.+)\:(.+)' IN "ORIG"."ID" GROUP 2 ) AS ID_TYPE,
SUBSTR_REGEXPR('(.+)\:(.+)\:(.+)\:(.+)' IN "ORIG"."ID" GROUP 3 ) AS TECHNICAL_CATALOG_NAME,
SUBSTR_REGEXPR('(.+)\:(.+)' IN "ORIG"."PARENTID" GROUP 1 ) AS P_ID_TYPE,
SUBSTR_REGEXPR('(.+)\:(.+)' IN "ORIG"."PARENTID" GROUP 2 ) AS P_CATALOG_PAGE,
COALESCE( "REFM" . "DOMAINID" , "REF" . "DOMAINID" , "ORIG" . "DOMAINID" ) "DOMAINID" , 
"ORIG" . "REFERENCECHIPID" , "ORIG" . "URL" , "REFM" . "URL" "REFM_URL" , "REF" . "URL" "REF_URL" , 
COALESCE( "REFM" . "SEM_OBJ" , "REF" . "SEM_OBJ" , "ORIG" . "SEM_OBJ" ) "SEM_OBJ" , 
COALESCE( "REFM" . "SEM_ACT" , "REF" . "SEM_ACT" , "ORIG" . "SEM_ACT" ) "SEM_ACT" , 
COALESCE( "REFM" . "SEM_OBJ" , "REF" . "SEM_OBJ" , "ORIG" . "SEM_OBJ" )||'-'||COALESCE( "REFM" . "SEM_ACT" , "REF" . "SEM_ACT" , "ORIG" . "SEM_ACT" ) AS "SEMANTIC_OBJECT_ACTION",
COALESCE( "REFM" . "APP_TYPE" , "REF" . "APP_TYPE" , "ORIG" . "APP_TYPE" ) "APP_TYPE" , 
COALESCE( "REFM" . "WD_APPL_ID" , "REF" . "WD_APPL_ID" , "ORIG" . "WD_APPL_ID" ) "WD_APPL_ID" , 
COALESCE( "REFM" . "WD_CONF_ID" , "REF" . "WD_CONF_ID" , "ORIG" . "WD_CONF_ID" ) "WD_CONF_ID" , 
COALESCE( "REFM" . "WD_COMPABILITY_MODE" , "REF" . "WD_COMPABILITY_MODE" , "ORIG" . "WD_COMPABILITY_MODE" ) "WD_COMPABILITY_MODE" , 
COALESCE( "REFM" . "UI5_COMPONENT_ID" , "REF" . "UI5_COMPONENT_ID" , "ORIG" . "UI5_COMPONENT_ID" ) "UI5_COMPONENT_ID" , 
COALESCE( "REFM" . "TCODE" , "REF" . "TCODE" , "ORIG" . "TCODE" ) "TCODE" , 
COALESCE( "REFM" . "WCF_TARGET_ID" , "REF" . "WCF_TARGET_ID" , "ORIG" . "WCF_TARGET_ID" ) "WCF_TARGET_ID" , 
COALESCE( "REFM" . "URLT_ID" , "REF" . "URLT_ID" , "ORIG" . "URLT_ID" ) "URLT_ID" , "ORIG" . "URLT_PARAMETERS" , 
"REFM" . "URLT_PARAMETERS" "URLT_REFM_PARAMETERS" , "REF" . "URLT_PARAMETERS" "URLT_REF_PARAMETERS" , 
COALESCE( "REFM" . "FORM_FACTOR_DESKTOP" , "REF" . "FORM_FACTOR_DESKTOP" , "ORIG" . "FORM_FACTOR_DESKTOP" ) "FORM_FACTOR_DESKTOP" , 
COALESCE( "REFM" . "FORM_FACTOR_TABLET" , "REF" . "FORM_FACTOR_TABLET" , "ORIG" . "FORM_FACTOR_TABLET" ) "FORM_FACTOR_TABLET" , 
COALESCE( "REFM" . "FORM_FACTOR_PHONE" , "REF" . "FORM_FACTOR_PHONE" , "ORIG" . "FORM_FACTOR_PHONE" ) "FORM_FACTOR_PHONE" , 
"ORIG" . "PARAMETERS" , "REFM" . "PARAMETERS" "REFM_PARAMETERS" , "REF" . "PARAMETERS" "REF_PARAMETERS" , 
COALESCE( "REFM" . "ADD_PARAMS_ALLOWED" , "REF" . "ADD_PARAMS_ALLOWED" , "ORIG" . "ADD_PARAMS_ALLOWED" ) "ADD_PARAMS_ALLOWED" , 
COALESCE( "REFM" . "SYSTEM_ALIAS" , "REF" . "SYSTEM_ALIAS" , "ORIG" . "SYSTEM_ALIAS" ) "SYSTEM_ALIAS" , 
COALESCE( "REFM" . "INFORMATION" , "REF" . "INFORMATION" , "ORIG" . "INFORMATION" ) "INFORMATION" , 
COALESCE( "REFM" . "CONF_TEXT" , "REF" . "CONF_TEXT" , "ORIG" . "CONF_TEXT" ) "CONF_TEXT" , "ORIG" . "REFERENCEPARENTID" , "ORIG" . "SHORT_GUID" , 
COALESCE( "REFM_PROPT" . "VALUE" , "REF_PROPT" . "VALUE" , "ORIG_PROPMT" . "VALUE" , "ORIG_PROPT" . "VALUE" ) "VALUE" , 
COALESCE( "REFM_LPD" . "LPD_ROLE" , "REF_LPD" . "LPD_ROLE" , "ORIG_LPD" . "LPD_ROLE" ) "LPD_ROLE" , 
COALESCE( "REFM_LPD" . "LPD_INSTANCE" , "REF_LPD" . "LPD_INSTANCE" , "ORIG_LPD" . "LPD_INSTANCE" ) "LPD_INSTANCE" , 
COALESCE( "REFM_LPD" . "LPD_ALIAS" , "REF_LPD" . "LPD_ALIAS" , "ORIG_LPD" . "LPD_ALIAS" ) "LPD_ALIAS" , 
COALESCE( "REFM_LPD" . "LPD_APP_ID" , "REF_LPD" . "LPD_APP_ID" , "ORIG_LPD" . "LPD_APP_ID" ) "LPD_APP_ID" , 4 "SCOPE" , 
CASE WHEN "REFM" . "ID" IS NOT NULL THEN 4 ELSE ( CASE WHEN "REF" . "ID" IS NOT NULL THEN 5 END ) END "REF_SCOPE" 
FROM "/UI2/PB_C_TMM" "ORIG" LEFT OUTER JOIN "/UI2/PB_C_TM" "REF" 
ON "ORIG" . "REFERENCECHIPID" = "REF" . "ID" 
LEFT OUTER JOIN "/UI2/PB_C_TMM" "REFM" ON "ORIG" . "MANDT" = "REFM" . "MANDT" 
AND "ORIG" . "REFERENCECHIPID" = "REFM" . "ID" 
LEFT OUTER JOIN "/UI2/PB_C_PROPT" "ORIG_PROPT" ON "ORIG" . "ID" = "ORIG_PROPT" . "BAG_PARENTID" 
AND "ORIG_PROPT" . "BAG_ID" = N'tileProperties' AND "ORIG_PROPT" . "NAME" = N'display_title_text' AND "ORIG_PROPT" . "BAG_CATEGORY" = N'C' AND "ORIG_PROPT" . "LANGU" = N'E' 
LEFT OUTER JOIN "/UI2/PB_C_PROPMT" "ORIG_PROPMT" ON "ORIG" . "MANDT" = "ORIG_PROPMT" . "MANDT" AND "ORIG" . "ID" = "ORIG_PROPMT" . "BAG_PARENTID" AND "ORIG_PROPMT" . "BAG_ID" = N'tileProperties' AND "ORIG_PROPMT" . "NAME" = N'display_title_text' AND "ORIG_PROPMT" . "BAG_CATEGORY" = N'C' AND "ORIG_PROPMT" . "LANGU" = N'E' 
LEFT OUTER JOIN "/UI2/PB_C_PROPT" "REF_PROPT" ON "REF" . "ID" = "REF_PROPT" . "BAG_PARENTID" AND "REF_PROPT" . "BAG_ID" = N'tileProperties' AND "REF_PROPT" . "NAME" = N'display_title_text' AND "REF_PROPT" . "BAG_CATEGORY" = N'C' AND "REF_PROPT" . "LANGU" = N'E' 
LEFT OUTER JOIN "/UI2/PB_C_PROPMT" "REFM_PROPT" ON "ORIG" . "MANDT" = "REFM_PROPT" . "MANDT" AND "REFM" . "ID" = "REFM_PROPT" . "BAG_PARENTID" AND "REFM_PROPT" . "BAG_ID" = N'tileProperties' AND "REFM_PROPT" . "NAME" = N'display_title_text' AND "REFM_PROPT" . "BAG_CATEGORY" = N'C' AND "REFM_PROPT" . "LANGU" = N'E' 
LEFT OUTER JOIN "/UI2/PB_C_TMMLPD" "ORIG_LPD" ON "ORIG" . "MANDT" = "ORIG_LPD" . "MANDT" AND "ORIG" . "ID" = "ORIG_LPD" . "ID" 
LEFT OUTER JOIN "/UI2/PB_C_TMLPD" "REF_LPD" ON "REF" . "ID" = "REF_LPD" . "ID" 
LEFT OUTER JOIN "/UI2/PB_C_TMMLPD" "REFM_LPD" ON "ORIG" . "MANDT" = "REFM_LPD" . "MANDT" AND "REFM" . "ID" = "REFM_LPD" . "ID" 
LEFT OUTER JOIN "/UI2/PB_C_PAGEM" "PAGEM" ON "ORIG" . "MANDT" = "PAGEM" . "MANDT" AND "REF" . "PARENTID" = "PAGEM" . "ID" 
WHERE "ORIG" . "MANDT" = '300' 
/*AND "ORIG" . "PARENTID" LIKE ( N'%X-SAP-UI2-CATALOGPAGE:SAP_HCMFAB_TC_T%' ) */
AND SUBSTR_REGEXPR('(.+)\:(.+)\:(.+)\:(.+)' IN "ORIG"."ID" GROUP 2 ) = 'X-SAP-UI2-CATALOGPAGE'  
AND ( NOT "REFM" . "PARENTID" IS NULL OR NOT "PAGEM" . "ID" IS NOT NULL ) 
AND ( "REFM" . "ID" IS NULL AND "REF" . "ID" IS NULL 
AND ( "ORIG" . "SEM_OBJ" <> N'' OR "ORIG" . "SEM_ACT" <> N'' ) 
AND ( "ORIG" . "SEM_OBJ" <> N'Shell' OR NOT "ORIG" . "SEM_ACT" IN ( N'plugin' , N'bootConfig' ) ) OR "REFM" . "ID" IS NOT NULL AND ( "REFM" . "SEM_OBJ" <> N'' OR "REFM" . "SEM_ACT" <> N'' ) AND ( "REFM" . "SEM_OBJ" <> N'Shell' OR NOT "REFM" . "SEM_ACT" IN ( N'plugin' , N'bootConfig' ) ) OR "REFM" . "ID" IS NULL AND "REF" . "ID" IS NOT NULL AND ( "REF" . "SEM_OBJ" <> N'' OR "REF" . "SEM_ACT" <> N'' ) 
AND ( "REF" . "SEM_OBJ" <> N'Shell' OR NOT "REF" . "SEM_ACT" IN ( N'plugin' , N'bootConfig' ) ) )
)
,
cte_join_with_library as
(
SELECT
PFCG.AGR_NAME AS PFCG_ROLE, 
I.ID,
I.PARENTID,
I.DOMAINID,
I.REFERENCECHIPID,
I.ID_TYPE,
LENGTH(I.TECHNICAL_CATALOG_NAME ) AS LENGTH_CATALOG,
I.TECHNICAL_CATALOG_NAME AS I_TECHNICAL_CATALOG_NAME,
U.SEMANTIC_OBJECT_ACTION,
COALESCE(U.FIORI_ID,I.TCODE) AS FIORI_ID,
U.LINE_OF_BUSINESS,
U.SCOPE_ITEM,
U.ROLE_NAME,
U.APP_NAME,
U.TECHNICAL_CATALOG_NAME,
U.TECHNICAL_CATALOG_DESCRIPTION,
U.BUSINESS_CATALOG_NAME,
U.BUSINESS_CATALOG_DESCRIPTION,
U.BUSINESS_GROUP_NAME,
U.BUSINESS_GROUP_DESCRIPTION,

U.LEADING_BUSINESS_ROLE_NAME,
U.LEADING_BUSINESS_ROLE_DESCR,
U.ADDITIONAL_BUSINESS_ROLE_NAME,
U.ADDITIONAL_BUSINESS_ROLE_DESCR,
U.INDUSTRY,
U.GTM_APP_DESCRIPTION,
U.BSP_NAME,
U.BSP_APPLICATION_URL,
U.SAPUI5_COMPONENT_ID
,I.SEM_OBJ
,I.SEM_ACT
,I.APP_TYPE
,I.WD_APPL_ID
,I.WD_CONF_ID
,I.WD_COMPABILITY_MODE
,I.UI5_COMPONENT_ID
,I.TCODE
,I.WCF_TARGET_ID
,I.URLT_ID
,I.URLT_PARAMETERS
,I.URLT_REFM_PARAMETERS
,I.URLT_REF_PARAMETERS

,I.FORM_FACTOR_DESKTOP
,I.FORM_FACTOR_TABLET
,I.FORM_FACTOR_PHONE

,I.PARAMETERS
,I.REFM_PARAMETERS
,I.REF_PARAMETERS

,I.ADD_PARAMS_ALLOWED
,I.SYSTEM_ALIAS
,I.INFORMATION
,I.CONF_TEXT
,I.REFERENCEPARENTID
,I.SHORT_GUID
,I.VALUE
,U.NOTE_COLLECTION


,U.PRIMARY_ODATA_SERVICE_NAME
,U.PRIMARY_ODATASERVICE_VERSION
,U.ADDITIONAL_ODATA_SERVICES
,U.ADDITIONAL_ODATASERVICES_VERS
,U.BEX_QUERY_NAME
,U.LEADING_TRANSACTION_CODES
,U.WDA_CONFIGURATION
,I.LPD_ROLE
,I.LPD_INSTANCE
,I.LPD_ALIAS
,I.LPD_APP_ID
,I.SCOPE
,I.REF_SCOPE
,I.URL
,I.REFM_URL
,I.REF_URL

FROM cte_fiori_installed_apps as I
LEFT OUTER JOIN cte_uploaded_fiori_apps as U
ON U.SEMANTIC_OBJECT_ACTION = I.SEMANTIC_OBJECT_ACTION
LEFT OUTER JOIN cte_fioriapp_pfcg_role AS PFCG
ON PFCG.CATALOG_NAME = I.TECHNICAL_CATALOG_NAME

)
SELECT
PT.TITLE, J.*
FROM cte_join_with_library AS J
LEFT OUTER JOIN "/UI2/PB_C_PAGEMT" AS PT 
ON J.PARENTID = PT.ID AND PT.MANDT = '300' AND PT.LANGU = 'E'
/*
WHERE SEMANTIC_OBJECT_ACTION LIKE '%GLAccount-analyzeTrialBalance%'
WHERE APP_NAME LIKE '%Launchpad%' OR APP_NAME LIKE '%Content%'
*/
;
