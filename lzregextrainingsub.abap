*&---------------------------------------------------------------------*
*&      Form  init
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form init.
  " Init custom controls and html views
  create object task1_text_area
    exporting
      container_name = task1_text_area_name.
  create object task1_text_view
    exporting
      parent = task1_text_area.
  create object task2_text_area
    exporting
      container_name = task2_text_area_name.
  create object task2_text_view
    exporting
      parent = task2_text_area.
  create object task3_text_area
    exporting
      container_name = task3_text_area_name.
  create object task3_text_view
    exporting
      parent = task3_text_area.
  create object task1_capture_text_area
    exporting
      container_name = task1_capture_text_area_name.
  create object task1_capture_text_view
    exporting
      parent = task1_capture_text_area.
  create object task2_capture_text_area
    exporting
      container_name = task2_capture_text_area_name.
  create object task2_capture_text_view
    exporting
      parent = task2_capture_text_area.
  create object task3_capture_text_area
    exporting
      container_name = task3_capture_text_area_name.
  create object task3_capture_text_view
    exporting
      parent = task3_capture_text_area.
endform.                    "init

*&---------------------------------------------------------------------*
*&      Form  reload
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form reload.
  data: url type c length 255,
        html type w3_htmltab,
        html_string type string,
        capture_text type string,
        is_first type abap_bool.

  " Task types
  task1_type = _view->task_type_text( _view->exercise->task1->type ).
  task2_type = _view->task_type_text( _view->exercise->task2->type ).
  task3_type = _view->task_type_text( _view->exercise->task3->type ).

  " Match/skip task text
  html_string = _view->exercise->task1->text.
  perform add_html_headfoot changing html_string.
  perform string_to_w3_html using html_string changing html.
  task1_text_view->load_data( importing assigned_url = url changing data_table = html ).
  task1_text_view->show_url( url = url ).
  clear: html, html_string.

  html_string = _view->exercise->task2->text.
  perform add_html_headfoot changing html_string.
  perform string_to_w3_html using html_string changing html.
  task2_text_view->load_data( importing assigned_url = url changing data_table = html ).
  task2_text_view->show_url( url = url ).
  clear: html, html_string.

  html_string = _view->exercise->task3->text.
  perform add_html_headfoot changing html_string.
  perform string_to_w3_html using html_string changing html.
  task3_text_view->load_data( importing assigned_url = url changing data_table = html ).
  task3_text_view->show_url( url = url ).
  clear: html, html_string.

  " Capture task text
  if _view->exercise->task1->type = zcl_rt_task=>type_capture.
    " Capture texts separated by a comma
    is_first = abap_true.
    loop at _view->exercise->task1->capture into capture_text.
      if is_first = abap_true.
        html_string = capture_text.
        is_first = abap_false.
      else.
        concatenate html_string `, ` capture_text into html_string.
      endif.
    endloop.
    perform add_html_headfoot changing html_string.
    perform string_to_w3_html using html_string
                              changing html.
  else.
    " Empty html page
    perform add_html_headfoot changing html_string.
    perform string_to_w3_html using html_string
                              changing html.
  endif.
  task1_capture_text_view->load_data( importing assigned_url = url changing data_table = html ).
  task1_capture_text_view->show_url( url = url ).
  clear: html, html_string.

  if _view->exercise->task2->type = zcl_rt_task=>type_capture.
    " Capture texts separated by a comma
    is_first = abap_true.
    loop at _view->exercise->task2->capture into capture_text.
      if is_first = abap_true.
        html_string = capture_text.
        is_first = abap_false.
      else.
        concatenate html_string `, ` capture_text into html_string.
      endif.
    endloop.
    perform add_html_headfoot changing html_string.
    perform string_to_w3_html using html_string
                              changing html.
  else.
    " Empty html page
    perform add_html_headfoot changing html_string.
    perform string_to_w3_html using html_string
                              changing html.
  endif.
  task2_capture_text_view->load_data( importing assigned_url = url changing data_table = html ).
  task2_capture_text_view->show_url( url = url ).
  clear: html, html_string.

  if _view->exercise->task3->type = zcl_rt_task=>type_capture.
    " Capture texts separated by a comma
    is_first = abap_true.
    loop at _view->exercise->task3->capture into capture_text.
      if is_first = abap_true.
        html_string = capture_text.
        is_first = abap_false.
      else.
        concatenate html_string `, ` capture_text into html_string.
      endif.
    endloop.
    perform add_html_headfoot changing html_string.
    perform string_to_w3_html using html_string
                              changing html.
  else.
    " Empty html page
    perform add_html_headfoot changing html_string.
    perform string_to_w3_html using html_string
                              changing html.
  endif.
  task3_capture_text_view->load_data( importing assigned_url = url changing data_table = html ).
  task3_capture_text_view->show_url( url = url ).
  clear: html, html_string.

endform.                    "reload

*&---------------------------------------------------------------------*
*&      Form  leave_view
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form leave_view.
  task1_text_area->free( ).
  task2_text_area->free( ).
  task3_text_area->free( ).
  task1_capture_text_area->free( ).
  task2_capture_text_area->free( ).
  task3_capture_text_area->free( ).
  leave to screen 0.
endform.                    "leave_view

*&---------------------------------------------------------------------*
*&      Form  string_to_w3_html
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->STRING     text
*      -->W3_HTML    text
*----------------------------------------------------------------------*
form string_to_w3_html using string type string
                       changing html type w3_htmltab.
  data offset type i.
  data html_line type w3_html.
  data string_len type i.
  data rows type i.
  data last_row_length type i.
  data row_length type i.
  row_length = 255.
  offset = 0.
  string_len = strlen( string ).
  rows = string_len div row_length.
  last_row_length = string_len mod row_length.
  do rows times.
    html_line = string+offset(row_length).
    append html_line to html.
    replace all occurrences of cl_abap_char_utilities=>horizontal_tab in html_line with `&#9;`.
    add row_length to offset.
  enddo.
  if last_row_length > 0.
    clear html_line.
    html_line = string+offset(last_row_length).
    replace all occurrences of cl_abap_char_utilities=>horizontal_tab in html_line with `&#9;`.
    append html_line to html.
  endif.
endform.                    "string_to_w3_html

*&---------------------------------------------------------------------*
*&      Form  add_html_headfoot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->STRING     text
*----------------------------------------------------------------------*
form add_html_headfoot changing string type string.
  concatenate html_open string html_close into string.
endform.                    "add_html_headfoot

*&---------------------------------------------------------------------*
*&      Form  toggle_buttons
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form toggle_buttons.
  loop at screen.
    case screen-name.
      when `NEXT`.
        if _view->exercise_is_last = abap_true and _view->solved_all = abap_true.
          screen-active = 1.
          next = zcl_rt_icons=>done.
        else.
          next = zcl_rt_icons=>next.
          if _view->exercise_is_last = abap_true or _view->solved_all = abap_false.
            screen-active = 0.
          else.
            screen-active = 1.
          endif.
        endif.
        modify screen.
      when `PREVIOUS`.
        previous = zcl_rt_icons=>previous.
        if _view->exercise_is_first = abap_true.
          screen-active = 0.
        else.
          screen-active = 1.
        endif.
        modify screen.
      when others.
        " Do nothing
    endcase.
  endloop.
endform.                    "toggle_buttons