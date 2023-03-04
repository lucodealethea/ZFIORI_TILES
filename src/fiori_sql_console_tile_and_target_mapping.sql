with cte_uploaded_fiori_apps as
(
SELECT * FROM ZTBC_C_FIORI_APP
)
,
cte_page_builder as
(
SELECT "ORIG" . "ID" , "ORIG" . "PARENTID" , 
COALESCE( "REFM" . "DOMAINID" , "REF" . "DOMAINID" , "ORIG" . "DOMAINID" ) "DOMAINID" , 
"ORIG" . "REFERENCECHIPID" , "ORIG" . "URL" , "REFM" . "URL" "REFM_URL" , 
"REF" . "URL" "REF_URL" , 
COALESCE( "REFM" . "SEM_OBJ" , "REF" . "SEM_OBJ" , "ORIG" . "SEM_OBJ" ) "SEM_OBJ" , 
COALESCE( "REFM" . "SEM_ACT" , "REF" . "SEM_ACT" , "ORIG" . "SEM_ACT" ) "SEM_ACT" , 
COALESCE( "REFM" . "APP_TYPE" , "REF" . "APP_TYPE" , "ORIG" . "APP_TYPE" ) "APP_TYPE" , 
COALESCE( "REFM" . "WD_APPL_ID" , "REF" . "WD_APPL_ID" , "ORIG" . "WD_APPL_ID" ) "WD_APPL_ID" , 
COALESCE( "REFM" . "WD_CONF_ID" , "REF" . "WD_CONF_ID" , "ORIG" . "WD_CONF_ID" ) "WD_CONF_ID" , 
COALESCE( "REFM" . "WD_COMPABILITY_MODE" , "REF" . "WD_COMPABILITY_MODE" , "ORIG" . "WD_COMPABILITY_MODE" ) "WD_COMPABILITY_MODE" , 
COALESCE( "REFM" . "UI5_COMPONENT_ID" , "REF" . "UI5_COMPONENT_ID" , "ORIG" . "UI5_COMPONENT_ID" ) "UI5_COMPONENT_ID" , 
COALESCE( "REFM" . "TCODE" , "REF" . "TCODE" , "ORIG" . "TCODE" ) "TCODE" , 
COALESCE( "REFM" . "WCF_TARGET_ID" , "REF" . "WCF_TARGET_ID" , "ORIG" . "WCF_TARGET_ID" ) "WCF_TARGET_ID" , 
COALESCE( "REFM" . "URLT_ID" , "REF" . "URLT_ID" , "ORIG" . "URLT_ID" ) "URLT_ID" , "ORIG" . "URLT_PARAMETERS" , "REFM" . "URLT_PARAMETERS" "URLT_REFM_PARAMETERS" , "REF" . "URLT_PARAMETERS" "URLT_REF_PARAMETERS" , 
COALESCE( "REFM" . "FORM_FACTOR_DESKTOP" , "REF" . "FORM_FACTOR_DESKTOP" , "ORIG" . "FORM_FACTOR_DESKTOP" ) "FORM_FACTOR_DESKTOP" , 
COALESCE( "REFM" . "FORM_FACTOR_TABLET" , "REF" . "FORM_FACTOR_TABLET" , "ORIG" . "FORM_FACTOR_TABLET" ) "FORM_FACTOR_TABLET" , 
COALESCE( "REFM" . "FORM_FACTOR_PHONE" , "REF" . "FORM_FACTOR_PHONE" , "ORIG" . "FORM_FACTOR_PHONE" ) "FORM_FACTOR_PHONE" , 
"ORIG" . "PARAMETERS" , "REFM" . "PARAMETERS" "REFM_PARAMETERS" , "REF" . "PARAMETERS" "REF_PARAMETERS" , 
COALESCE( "REFM" . "ADD_PARAMS_ALLOWED" , "REF" . "ADD_PARAMS_ALLOWED" , "ORIG" . "ADD_PARAMS_ALLOWED" ) "ADD_PARAMS_ALLOWED" , 
COALESCE( "REFM" . "SYSTEM_ALIAS" , "REF" . "SYSTEM_ALIAS" , "ORIG" . "SYSTEM_ALIAS" ) "SYSTEM_ALIAS" , 
COALESCE( "REFM" . "INFORMATION" , "REF" . "INFORMATION" , "ORIG" . "INFORMATION" ) "INFORMATION" , 
COALESCE( "REFM" . "CONF_TEXT" , "REF" . "CONF_TEXT" , "ORIG" . "CONF_TEXT" ) "CONF_TEXT" , 
"ORIG" . "REFERENCEPARENTID" , "ORIG" . "SHORT_GUID" , 
COALESCE( "REFM_PROPT" . "VALUE" , "REF_PROPT" . "VALUE" , "ORIG_PROPMT" . "VALUE" , "ORIG_PROPT" . "VALUE" ) "VALUE" , 
COALESCE( "REFM_LPD" . "LPD_ROLE" , "REF_LPD" . "LPD_ROLE" , "ORIG_LPD" . "LPD_ROLE" ) "LPD_ROLE" , 
COALESCE( "REFM_LPD" . "LPD_INSTANCE" , "REF_LPD" . "LPD_INSTANCE" , "ORIG_LPD" . "LPD_INSTANCE" ) "LPD_INSTANCE" , 
COALESCE( "REFM_LPD" . "LPD_ALIAS" , "REF_LPD" . "LPD_ALIAS" , "ORIG_LPD" . "LPD_ALIAS" ) "LPD_ALIAS" , 
COALESCE( "REFM_LPD" . "LPD_APP_ID" , "REF_LPD" . "LPD_APP_ID" , "ORIG_LPD" . "LPD_APP_ID" ) "LPD_APP_ID" ,
 4 "SCOPE" , 
 CASE WHEN "REFM" . "ID" IS NOT NULL THEN 4 ELSE ( CASE WHEN "REF" . "ID" IS NOT NULL THEN 5 END ) END "REF_SCOPE" 
 FROM "/UI2/PB_C_TMM" "ORIG" 
 LEFT OUTER JOIN "/UI2/PB_C_TM" "REF" 
 ON "ORIG" . "REFERENCECHIPID" = "REF" . "ID" 
 LEFT OUTER JOIN "/UI2/PB_C_TMM" "REFM" 
 ON "ORIG" . "MANDT" = "REFM" . "MANDT" AND "ORIG" . "REFERENCECHIPID" = "REFM" . "ID" 
 LEFT OUTER JOIN "/UI2/PB_C_PROPT" "ORIG_PROPT" 
 ON "ORIG" . "ID" = "ORIG_PROPT" . "BAG_PARENTID" AND "ORIG_PROPT" . "BAG_ID" = N'tileProperties' 
 AND "ORIG_PROPT" . "NAME" = N'display_title_text' AND "ORIG_PROPT" . "BAG_CATEGORY" = N'C' 
 AND "ORIG_PROPT" . "LANGU" = N'E' 
 LEFT OUTER JOIN "/UI2/PB_C_PROPMT" "ORIG_PROPMT" 
 ON "ORIG" . "MANDT" = "ORIG_PROPMT" . "MANDT" 
 AND "ORIG" . "ID" = "ORIG_PROPMT" . "BAG_PARENTID" AND "ORIG_PROPMT" . "BAG_ID" = N'tileProperties' 
 AND "ORIG_PROPMT" . "NAME" = N'display_title_text' AND "ORIG_PROPMT" . "BAG_CATEGORY" = N'C' 
 AND "ORIG_PROPMT" . "LANGU" = N'E' 
 LEFT OUTER JOIN "/UI2/PB_C_PROPT" "REF_PROPT" 
 ON "REF" . "ID" = "REF_PROPT" . "BAG_PARENTID" AND "REF_PROPT" . "BAG_ID" = N'tileProperties' 
 AND "REF_PROPT" . "NAME" = N'display_title_text' AND "REF_PROPT" . "BAG_CATEGORY" = N'C' AND "REF_PROPT" . "LANGU" = N'E' 
 LEFT OUTER JOIN "/UI2/PB_C_PROPMT" "REFM_PROPT" ON "ORIG" . "MANDT" = "REFM_PROPT" . "MANDT" AND "REFM" . "ID" = "REFM_PROPT" . "BAG_PARENTID" 
 AND "REFM_PROPT" . "BAG_ID" = N'tileProperties' AND "REFM_PROPT" . "NAME" = N'display_title_text' 
 AND "REFM_PROPT" . "BAG_CATEGORY" = N'C' AND "REFM_PROPT" . "LANGU" = N'E' 
 LEFT OUTER JOIN "/UI2/PB_C_TMMLPD" "ORIG_LPD" ON "ORIG" . "MANDT" = "ORIG_LPD" . "MANDT" AND "ORIG" . "ID" = "ORIG_LPD" . "ID" 
 LEFT OUTER JOIN "/UI2/PB_C_TMLPD" "REF_LPD" ON "REF" . "ID" = "REF_LPD" . "ID" 
 LEFT OUTER JOIN "/UI2/PB_C_TMMLPD" "REFM_LPD" ON "ORIG" . "MANDT" = "REFM_LPD" . "MANDT" AND "REFM" . "ID" = "REFM_LPD" . "ID" 
 LEFT OUTER JOIN "/UI2/PB_C_PAGEM" "PAGEM" ON "ORIG" . "MANDT" = "PAGEM" . "MANDT" AND "REF" . "PARENTID" = "PAGEM" . "ID" 
 WHERE "ORIG" . "MANDT" = '600' AND "ORIG" . "PARENTID" LIKE ( N'%ZBC_TS%' ) 
 AND ( NOT "REFM" . "PARENTID" IS NULL OR NOT "PAGEM" . "ID" IS NOT NULL ) 
 AND ( "REFM" . "ID" IS NULL AND "REF" . "ID" IS NULL 
 AND ( "ORIG" . "SEM_OBJ" <> N'' OR "ORIG" . "SEM_ACT" <> N'' ) 
 AND ( "ORIG" . "SEM_OBJ" <> N'Shell' OR NOT "ORIG" . "SEM_ACT" IN ( N'plugin' , N'bootConfig' ) ) OR "REFM" . "ID" IS NOT NULL AND ( "REFM" . "SEM_OBJ" <> N'' OR "REFM" . "SEM_ACT" <> N'' ) 
 AND ( "REFM" . "SEM_OBJ" <> N'Shell' OR NOT "REFM" . "SEM_ACT" IN ( N'plugin' , N'bootConfig' ) ) OR "REFM" . "ID" IS NULL AND "REF" . "ID" IS NOT NULL 
 AND ( "REF" . "SEM_OBJ" <> N'' OR "REF" . "SEM_ACT" <> N'' ) AND ( "REF" . "SEM_OBJ" <> N'Shell' OR NOT "REF" . "SEM_ACT" IN ( N'plugin' , N'bootConfig' ) ) )
)
,
cte_fiori_installed_apps as
(
SELECT
ID
,PARENTID
,DOMAINID
,REFERENCECHIPID
,URL
,REFM_URL
,REF_URL
,SEM_OBJ
,SEM_ACT
,SEM_OBJ||'-'||SEM_ACT AS SEMANTIC_OBJECT_ACTION
,APP_TYPE
,WD_APPL_ID
,WD_CONF_ID
,WD_COMPABILITY_MODE
,UI5_COMPONENT_ID
,TCODE
,WCF_TARGET_ID
,URLT_ID
,URLT_PARAMETERS
,URLT_REFM_PARAMETERS
,URLT_REF_PARAMETERS
,FORM_FACTOR_DESKTOP
,FORM_FACTOR_TABLET
,FORM_FACTOR_PHONE
,PARAMETERS
,REFM_PARAMETERS
,REF_PARAMETERS
,ADD_PARAMS_ALLOWED
,SYSTEM_ALIAS
,INFORMATION
,CONF_TEXT
,REFERENCEPARENTID
,SHORT_GUID
,VALUE
,LPD_ROLE
,LPD_INSTANCE
,LPD_ALIAS
,LPD_APP_ID
,SCOPE
,REF_SCOPE
 
FROM cte_page_builder
)
SELECT 
SUBSTRING(I.ID,LOCATE(I.ID,'ZBC',1),17) AS CATALOG,
U.FIORI_ID,
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
,I.ID
,I.PARENTID
,I.DOMAINID
,I.REFERENCECHIPID



,I.SEM_OBJ
,I.SEM_ACT
,I.SEMANTIC_OBJECT_ACTION
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
,I.LPD_ROLE
,I.LPD_INSTANCE
,I.LPD_ALIAS
,I.LPD_APP_ID
,I.SCOPE
,I.REF_SCOPE

/*
,I.URL
,I.REFM_URL
,I.REF_URL

*/
FROM cte_fiori_installed_apps as I
LEFT OUTER JOIN cte_uploaded_fiori_apps as U
ON U.SEMANTIC_OBJECT_ACTION = I.SEMANTIC_OBJECT_ACTION
WHERE ID LIKE '%ZBC_TS_FI_GL_DISP%'
