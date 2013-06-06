function-pool zregextraining.

constants: ucomm_back type syucomm value `BACK`,
           ucomm_cancel type syucomm value `CANCEL`,
           ucomm_check type syucomm value `CHECK`,
           ucomm_exit type syucomm value `EXIT`,
           ucomm_next type syucomm value `NEXT`,
           ucomm_prev type syucomm value `PREV`.

constants: task1_text_area_name type c length 20 value `TASK1_TEXT`,
           task2_text_area_name type c length 20 value `TASK2_TEXT`,
           task3_text_area_name type c length 20 value `TASK3_TEXT`,
           task1_capture_text_area_name type c length 20 value `TASK1_CAPTURE_TEXT`,
           task2_capture_text_area_name type c length 20 value `TASK2_CAPTURE_TEXT`,
           task3_capture_text_area_name type c length 20 value `TASK3_CAPTURE_TEXT`.

constants: html_open type string value `<html><body style="margin:0; padding:0 0 0 4px; overflow:hidden; background-color:#000000; color:#ffffff; font-family:'Trebuchet MS', Helvetica, Verdana, sans-serif; font-size:15px; ` &
                                       `font-weight: bold; word-spacing: 2px">`,
           html_close type string value `</body></html>`.

data: _view type ref to zcl_rt_view.

data: previous type string,
      next type string.

data: task1_type type string,
      task2_type type string,
      task3_type type string.

data: task1_text_area type ref to cl_gui_custom_container,
      task1_text_view type ref to cl_gui_html_viewer,
      task2_text_area type ref to cl_gui_custom_container,
      task2_text_view type ref to cl_gui_html_viewer,
      task3_text_area type ref to cl_gui_custom_container,
      task3_text_view type ref to cl_gui_html_viewer.

data: task1_capture_text_area type ref to cl_gui_custom_container,
      task1_capture_text_view type ref to cl_gui_html_viewer,
      task2_capture_text_area type ref to cl_gui_custom_container,
      task2_capture_text_view type ref to cl_gui_html_viewer,
      task3_capture_text_area type ref to cl_gui_custom_container,
      task3_capture_text_view type ref to cl_gui_html_viewer.