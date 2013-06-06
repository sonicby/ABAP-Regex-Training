class ZCL_RT_CHECKER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_CHECKER
*"* do not include other source files here!!!

  methods CHECK_EXERCISE
    importing
      !INPUT type STRING
      !EXERCISE type ref to ZCL_RT_EXERCISE
    returning
      value(RETURNING) type ref to ZCL_RT_EXERCISE .
  methods CHECK_TASK
    importing
      !INPUT type STRING
      !TASK type ref to ZCL_RT_TASK .
protected section.
*"* protected components of class ZCL_RT_CHECKER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_CHECKER
*"* do not include other source files here!!!

  constants SPAN_OPEN_GREEN type STRING value `<span style="color:#64b10a;">`. "#EC NOTEXT
  constants SPAN_OPEN_RED type STRING value `<span style="color:#d62f2f; text-decoration:line-through;">`. "#EC NOTEXT
  constants SPAN_CLOSE type STRING value `</span>`. "#EC NOTEXT
  constants GREEN_SPACE type STRING value `<span style="background-color:#64b10a;"> </span>`. "#EC NOTEXT
  constants RED_SPACE type STRING value `<span style="background-color:#d62f2f;"> </span>`. "#EC NOTEXT
  constants GREEN_TAB type STRING value `<span style="background-color:#64b10a;">&#9;</span>`. "#EC NOTEXT
  constants RED_TAB type STRING value `<span style="background-color:#d62f2f;">&#9;</span>`. "#EC NOTEXT

  methods _HIGHLIGHT_MATCH
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK .
  methods _HIGHLIGHT_MATCHES
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK .
  methods _HIGHLIGHT_SKIP
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK .
  methods _HIGHLIGHT_TEXT
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK
      !SPAN_OPEN type STRING
      !HIGHLIGHTED_SPACE type STRING
      !HIGHLIGHTED_TAB type STRING
    returning
      value(RETURNING) type STRING .
  methods _HIGHLIGHT_CAPTURE_TEXTS
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK
      !SPAN_OPEN type STRING
      !HIGHLIGHTED_SPACE type STRING
      !HIGHLIGHTED_TAB type STRING
    returning
      value(RETURNING) type STRINGTAB .
  methods _VALIDATE_MATCH
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK .
  methods _VALIDATE_SKIP
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK .
  methods _VALIDATE_MATCHES
    importing
      !REGEX type ref to CL_ABAP_REGEX
      !TASK type ref to ZCL_RT_TASK .
ENDCLASS.



CLASS ZCL_RT_CHECKER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_CHECKER->CHECK_EXERCISE
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUT                          TYPE        STRING
* | [--->] EXERCISE                       TYPE REF TO ZCL_RT_EXERCISE
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_EXERCISE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method check_exercise.
*/**
* Checks all tasks inside an exercise
*/
  data: checked_exercise type ref to zcl_rt_exercise.
  checked_exercise = exercise->clone( ).

  " Check tasks
  check_task( input = input task = checked_exercise->task1 ).
  check_task( input = input task = checked_exercise->task2 ).
  check_task( input = input task = checked_exercise->task3 ).

  returning = checked_exercise.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_CHECKER->CHECK_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUT                          TYPE        STRING
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method check_task.
*/**
* Checks a task
*/
  data: regex type ref to cl_abap_regex.

  " Create regex
  try.
      create object regex
        exporting
          pattern = input.
    catch cx_sy_regex.
      " Invalid regex
      task->icon = zcl_rt_icons=>cancel.
      task->solved = abap_false.
      return.
  endtry.

  " Handle task based on task type
  case task->type.
    when zcl_rt_task=>type_match.
      " Highlight match (green)
      _validate_match( regex = regex task = task ).
      _highlight_match( regex = regex task = task ).
    when zcl_rt_task=>type_skip.
      " Highlight match (red)
      _validate_skip( regex = regex task = task ).
      _highlight_skip( regex = regex task = task ).
    when zcl_rt_task=>type_capture.
      " Highlight matches
      _validate_matches( regex = regex task = task ).
      _highlight_matches( regex = regex task = task ).
    when others.
      return.
  endcase.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_HIGHLIGHT_CAPTURE_TEXTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* | [--->] SPAN_OPEN                      TYPE        STRING
* | [--->] HIGHLIGHTED_SPACE              TYPE        STRING
* | [--->] HIGHLIGHTED_TAB                TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRINGTAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _highlight_capture_texts.
  data: capture_text type string,
        capture_texts_highlighted type stringtab,
        matcher type ref to cl_abap_matcher,
        match type match_result,
        submatch type submatch_result,
        sub_match_text type string,
        sub_match_text_highlighted type string.

  try.
      " Match
      create object matcher
        exporting
          regex = regex
          text  = task->text.

      " Get all matches and highlight them
      while matcher->find_next( ) = abap_true.
        match = matcher->get_match( ).
        loop at match-submatches into submatch.
          sub_match_text = matcher->text+submatch-offset(submatch-length).
          loop at task->capture into capture_text.
            if capture_text cs sub_match_text.
              sub_match_text_highlighted = sub_match_text.
              replace all occurrences of ` ` in sub_match_text_highlighted with highlighted_space.
              replace all occurrences of cl_abap_char_utilities=>horizontal_tab in sub_match_text_highlighted with highlighted_space.
              concatenate span_open sub_match_text_highlighted span_close into sub_match_text_highlighted.
              replace sub_match_text in capture_text with sub_match_text_highlighted.
              append capture_text to capture_texts_highlighted.
              delete task->capture.
            endif.
          endloop.
        endloop.
      endwhile.
      " Don't forget to keep the not-highlighted capture texts
      append lines of task->capture to capture_texts_highlighted.

      returning = capture_texts_highlighted.

    catch cx_sy_matcher.
      " Matcher problem
      task->icon = zcl_rt_icons=>cancel.
      task->solved = abap_false.
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_HIGHLIGHT_MATCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _highlight_match.
  data highlighted_text type string.
  " Highlight text (green)
  highlighted_text = _highlight_text( regex = regex task = task span_open = span_open_green highlighted_space = green_space highlighted_tab = green_tab ).
  " Update task text with highlighted text
  task->text = highlighted_text.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_HIGHLIGHT_MATCHES
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _highlight_matches.
  data highlighted_text type string.
  data highlighted_capture_texts type stringtab.
  " Highlight text (green)
  highlighted_text = _highlight_text( regex = regex task = task span_open = span_open_green highlighted_space = green_space highlighted_tab = green_tab ).
  " Highlight capture texts (green)
  highlighted_capture_texts = _highlight_capture_texts( regex = regex task = task span_open = span_open_green highlighted_space = green_space highlighted_tab = green_tab ).
  " Update task text with highlighted text and highlighted capture texts
  task->text = highlighted_text.
  task->capture = highlighted_capture_texts.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_HIGHLIGHT_SKIP
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _highlight_skip.
  data highlighted_text type string.
  " Highlight text (red)
  highlighted_text = _highlight_text( regex = regex task = task span_open = span_open_red highlighted_space = red_space highlighted_tab = red_tab ).
  " Update task text with highlighted text
  task->text = highlighted_text.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_HIGHLIGHT_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* | [--->] SPAN_OPEN                      TYPE        STRING
* | [--->] HIGHLIGHTED_SPACE              TYPE        STRING
* | [--->] HIGHLIGHTED_TAB                TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _highlight_text.
  data: matcher type ref to cl_abap_matcher,
        match type match_result,
        match_text_highlighted type string.

  try.
      " Match
      create object matcher
        exporting
          regex = regex
          text  = task->text.

      " Get all matches and highlight them
      while matcher->find_next( ) = abap_true.
        match = matcher->get_match( ).
        match_text_highlighted = matcher->text+match-offset(match-length).
        replace all occurrences of `$` in match_text_highlighted with `\$`. " Apparently the 'replace_found' method chokes on an unescaped $
        replace all occurrences of ` ` in match_text_highlighted with highlighted_space.
        replace all occurrences of cl_abap_char_utilities=>horizontal_tab in match_text_highlighted with highlighted_tab.
        concatenate span_open match_text_highlighted span_close into match_text_highlighted.
        matcher->replace_found( match_text_highlighted ).
      endwhile.

      returning = matcher->text.

    catch cx_sy_matcher.
      " Matcher problem
      task->icon = zcl_rt_icons=>cancel.
      task->solved = abap_false.
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_VALIDATE_MATCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _validate_match.
  data: matcher type ref to cl_abap_matcher,
        match type match_result,
        match_text type string,
        match_text_concat type string,
        capture_text type string.

  try.
      " Match
      create object matcher
        exporting
          regex = regex
          text  = task->text.

      " All matches together must match the entire task capture text
      while matcher->find_next( ) = abap_true.
        match = matcher->get_match( ).
        match_text = matcher->text+match-offset(match-length).
        concatenate match_text_concat match_text into match_text_concat.
      endwhile.
      read table task->capture into capture_text index 1. " Extactly 1 capture text for match/skip tasks
      if capture_text is initial.
        " No capture text means any match is ok
        if match_text_concat is not initial.
          task->icon = zcl_rt_icons=>ok.
          task->solved = abap_true.
        else.
          task->icon = zcl_rt_icons=>cancel.
          task->solved = abap_false.
        endif.
      else.
        " Must match capture text
        if capture_text = match_text_concat.
          task->icon = zcl_rt_icons=>ok.
          task->solved = abap_true.
        else.
          task->icon = zcl_rt_icons=>cancel.
          task->solved = abap_false.
        endif.
      endif.

    catch cx_sy_matcher.
      " Matcher problem
      task->icon = zcl_rt_icons=>cancel.
      task->solved = abap_false.
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_VALIDATE_MATCHES
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _validate_matches.
  data: capture_text type string,
        capture_texts_org type stringtab,
        capture_texts type stringtab,
        matcher type ref to cl_abap_matcher,
        match type match_result,
        submatch type submatch_result,
        sub_match_text type string.

  try.
      " Match
      create object matcher
        exporting
          regex = regex
          text  = task->text.

      " Get all matches
      capture_texts_org = task->capture.
      while matcher->find_next( ) = abap_true.
        match = matcher->get_match( ).
        loop at match-submatches into submatch.
          sub_match_text = matcher->text+submatch-offset(submatch-length).
          loop at capture_texts_org into capture_text.
            if capture_text = sub_match_text.
              append capture_text to capture_texts.
              delete capture_texts_org.
              exit.
            endif.
          endloop.
        endloop.
      endwhile.

      " All capture texts must have been matched
      if lines( task->capture ) = lines( capture_texts ).
        task->icon = zcl_rt_icons=>ok.
        task->solved = abap_true.
      else.
        task->icon = zcl_rt_icons=>cancel.
        task->solved = abap_false.
      endif.

    catch cx_sy_matcher.
      " Matcher problem
      task->icon = zcl_rt_icons=>cancel.
      task->solved = abap_false.
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CHECKER->_VALIDATE_SKIP
* +-------------------------------------------------------------------------------------------------+
* | [--->] REGEX                          TYPE REF TO CL_ABAP_REGEX
* | [--->] TASK                           TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _validate_skip.
  data: matcher type ref to cl_abap_matcher,
        match type match_result,
        match_text type string,
        match_text_concat type string,
        capture_text type string.

  try.
      " Match
      create object matcher
        exporting
          regex = regex
          text  = task->text.

      " All matches together must match the entire task capture text
      while matcher->find_next( ) = abap_true.
        match = matcher->get_match( ).
        match_text = matcher->text+match-offset(match-length).
        concatenate match_text_concat match_text into match_text_concat.
      endwhile.
      read table task->capture into capture_text index 1. " Extactly 1 capture text for match/skip tasks
      if capture_text is initial.
        " No capture text means any match is NOT ok
        if match_text_concat is initial.
          task->icon = zcl_rt_icons=>ok.
          task->solved = abap_true.
        else.
          task->icon = zcl_rt_icons=>cancel.
          task->solved = abap_false.
        endif.
      else.
        " Must NOT match capture text
        if capture_text <> match_text_concat.
          task->icon = zcl_rt_icons=>ok.
          task->solved = abap_true.
        else.
          task->icon = zcl_rt_icons=>cancel.
          task->solved = abap_false.
        endif.
      endif.

    catch cx_sy_matcher.
      " Matcher problem
      task->icon = zcl_rt_icons=>cancel.
      task->solved = abap_false.
      return.
  endtry.

endmethod.
ENDCLASS.
