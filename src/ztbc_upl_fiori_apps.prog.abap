REPORT ztbc_upl_fiori_apps.

* Upload file from Fiori Apps Library

TABLES : ztbc_c_fiori_app.

TYPES : BEGIN OF ty_rec,
          rec TYPE string,
        END   OF ty_rec.

TYPES : BEGIN OF ty_data.
          INCLUDE STRUCTURE ztbc_c_fiori_app.
TYPES :  END   OF ty_data.

DATA : gv_applserv TYPE as4flag,
       gv_title    TYPE string,
       gv_guiext   TYPE string,
       gv_guiflt   TYPE string.

DATA : gt_records       TYPE TABLE OF ty_rec,
       gt_data          TYPE TABLE OF ty_data,
       gs_records       TYPE ty_rec,
       gs_data          TYPE ty_data,
       gv_headerxstring TYPE xstring,
       gv_filelength    TYPE i,
       gv_string1       TYPE string,
       gv_string2       TYPE string,
       gv_string3       TYPE string.

*---------------------------------------------------------------------*
PARAMETERS : p_file TYPE string.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*******************
  CALL METHOD cl_rsan_ut_files=>f4
    EXPORTING
      i_applserv       = gv_applserv                " Choose File from App.Server Otherwise from GUI
      i_title          = gv_title                " Popup Window Title
      i_gui_extension  = gv_guiext
      i_gui_ext_filter = gv_guiflt
    CHANGING
      c_file_name      = p_file                  " Chosen File Name
    EXCEPTIONS
      failed           = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
START-OF-SELECTION.
*******************
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_file
      filetype                = 'ASC'
    IMPORTING
      filelength              = gv_filelength
      header                  = gv_headerxstring
    TABLES
      data_tab                = gt_records
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  LOOP AT gt_records INTO gs_records.

    REPLACE ALL OCCURRENCES OF ',' IN gs_records-rec WITH ';'.

    IF gs_records-rec(1) = '"'.
      SHIFT gs_records-rec LEFT.
    ENDIF.

    DO 20 TIMES.
      SPLIT gs_records-rec AT '""' INTO gv_string1 gv_string2 gv_string3.
      IF gv_string2 IS NOT INITIAL.
        REPLACE ALL OCCURRENCES OF ';' IN gv_string2 WITH ','.
        CLEAR gs_records-rec.
        CONCATENATE gv_string1 gv_string2 gv_string3 INTO gs_records-rec.
      ENDIF.
    ENDDO.

    SPLIT gs_records-rec AT ';' INTO
    gs_data-fiori_id
    gs_data-line_of_business
    gs_data-scope_item
    gs_data-role_name
    gs_data-app_name
    gs_data-application_type
    gs_data-app_launcher_title_subtitle
    gs_data-lighthouse
    gs_data-application_component
    gs_data-ui_technology
    gs_data-device_type
    gs_data-product_category
    gs_data-database_id
    gs_data-frontend_software_component
    gs_data-frontend_min_sp
    gs_data-backend_software_comp_versions
    gs_data-backend_min_sp
    gs_data-hana_software_comp_versions
    gs_data-hana_min_sp
    gs_data-frontend_product_version
    gs_data-product_version_name_backend
    gs_data-hana_product_version
    gs_data-frontend_product_version_stack
    gs_data-backend_product_version_stack
    gs_data-hana_product_version_stack
    gs_data-note_collection
    gs_data-semantic_object_action
    gs_data-technical_catalog_name
    gs_data-technical_catalog_description
    gs_data-business_catalog_name
    gs_data-business_catalog_description
    gs_data-business_group_name
    gs_data-business_group_description
    gs_data-leading_business_role_name
    gs_data-leading_business_role_descr
    gs_data-additional_business_role_name
    gs_data-additional_business_role_descr
    gs_data-industry
    gs_data-gtm_app_description
    gs_data-bsp_name
    gs_data-bsp_application_url
    gs_data-sapui5_component_id
    gs_data-primary_odata_service_name
    gs_data-primary_odataservice_version
    gs_data-additional_odata_services
    gs_data-additional_odataservices_vers
    gs_data-bex_query_name
    gs_data-leading_transaction_codes
    gs_data-wda_configuration
    gs_data-link.

    INSERT ztbc_c_fiori_app FROM gs_data.
    IF sy-subrc = 4.
      MODIFY ztbc_c_fiori_app FROM gs_data.
    ENDIF.
  ENDLOOP.
