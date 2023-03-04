# ZFIORI_TILES

Create the ZTBC_C_FIORI_APP table then uploading Fiori Apps with SE38 ZTBC_UPL_FIORI_APPS  according to

https://blogs.sap.com/2020/12/27/sap-fiori-tips-download-list-of-all-fiori-apps-in-excel-format-from-reference-library/

You could load a higher version if you wanted to compare what's available in your current release versus what's new.

The SQL Gets you the S/4 HANA Tiles and Target Mappings Along with App Names

Change the line with "ORIG" . "PARENTID" LIKE ( N'%ZBC_TS_FI_GL_DISP%' ) with your Catalogs Like Naming Conventions
