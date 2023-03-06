# ZFIORI_TILES

What Fiori Catalog have been created ? 
What Fiori Apps are installed on my S/4 HANA ? 
How do they relate with Fiori Apps Library ( https://fioriappslibrary.hana.ondemand.com/ ) ?
How are Tiles and Target Mapping defined ?

This development (ongoing) tries to give some insight and requires to install this package with https://abapgit.org/.

Create the ZTBC_C_FIORI_APP table then uploading Fiori Apps with SE38 ZTBC_UPL_FIORI_APPS  according to

https://blogs.sap.com/2020/12/27/sap-fiori-tips-download-list-of-all-fiori-apps-in-excel-format-from-reference-library/

You could load a higher version if you wanted to compare what's available in your current release versus what's new.

The SQL Gets you the S/4 HANA Tiles and Target Mappings Along with App Names installed on your system ( restricted to one catalog) 
and compares it to the Fiori Apps Library.

Change the line with "ORIG" . "PARENTID" LIKE ( N'%ZBC_TS_FI_GL_DISP%' ) with your own Catalog/or Family considering the naming conventions used.

For example Tiles Catalog SAP_TC_FIN_ACC_COMMON has been mocked as ZBC_TS_FI_GL_DISP...

/UI2/FLP_CUS_CONF ( /UI2/FLPSETCV Client Only Configuration while /UI2/FLP_SYS_CONF is Cross-Client Configuration /UI2/FLPSETV)

1. If all users should see the spaces layout and be able to switch between the layouts, 
set SPACES and SPACES_ENABLE_USER to true.
SM30 on /UI2/FLPSETCV SPACES_ENABLE_USER = true
2. If all users should only see the spaces layout, set SPACES to true, and set SPACES_ENABLE_USER to false.

3. If all users should see the home page by default but be able to switch between the layouts, set SPACES to false, and set SPACES_ENABLE_USER to true.

4. If you want to deactivate the spaces layout completely for now, set SPACES and SPACES_ENABLE_USER to false. Then the home page is always displayed.

https://blogs.sap.com/2020/05/03/manage-spaces-and-pages-for-sap-fiori-launchpad/
