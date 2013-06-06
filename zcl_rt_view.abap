class ZCL_RT_VIEW definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_VIEW
*"* do not include other source files here!!!

  constants ACTION_NEXT type STRING value `NEXT`. "#EC NOTEXT
  constants ACTION_PREV type STRING value `PREV`. "#EC NOTEXT
  constants ACTION_DONE type STRING value `DONE`. "#EC NOTEXT
  data ACTION type STRING .
  data EXERCISE type ref to ZCL_RT_EXERCISE .
  data INPUT type STRING .
  type-pools ABAP .
  data EXERCISE_IS_FIRST type ABAP_BOOL .
  data EXERCISE_IS_LAST type ABAP_BOOL .
  data SOLVED_ALL type ABAP_BOOL .

  events CHECK
    exporting
      value(EXERCISE_NUMBER) type I
      value(INPUT) type STRING .

  methods CONSTRUCTOR
    importing
      !MODEL type ref to ZCL_RT_MODEL .
  methods DISPLAY
    importing
      !EXERCISE_NUMBER type I .
  methods PERFORM_CHECK .
  methods TASK_TYPE_TEXT
    importing
      !TYPE type I
    returning
      value(RETURNING) type STRING .
protected section.
*"* protected components of class ZCL_RT_VIEW
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_VIEW
*"* do not include other source files here!!!

  data _EXERCISE_NUMBER type I .
  data _MODEL type ref to ZCL_RT_MODEL .
ENDCLASS.



CLASS ZCL_RT_VIEW IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_VIEW->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] MODEL                          TYPE REF TO ZCL_RT_MODEL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
*/**
* Initialize
*/
  _model = model.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_VIEW->DISPLAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] EXERCISE_NUMBER                TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method display.
*/**
* Display the current exercise
*/
  _exercise_number = exercise_number.
  " Read the exercise to display
  data current_exercise type ref to zcl_rt_exercise.
  read table _model->exercises index _exercise_number into current_exercise.
  exercise = current_exercise->clone( ).
  " Display the exercise
  call function 'Z_RT_TASKVIEW'
    exporting
      view = me.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_VIEW->PERFORM_CHECK
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method perform_check.
*/**
* Exercise check requested by user
*/
  " Raise check event
  raise event check
    exporting
      exercise_number = _exercise_number
      input           = input.
  " Events in ABAP are synchronous, so immediately update the
  " currently displayed exercise to display the checked exercise
  exercise = _model->checked_exercise.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_VIEW->TASK_TYPE_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] TYPE                           TYPE        I
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method task_type_text.
  case type.
    when zcl_rt_task=>type_match.
      returning = `Match text`.
    when zcl_rt_task=>type_skip.
      returning = `Skip text`.
    when zcl_rt_task=>type_capture.
      returning = `Capture text`.
    when others.
      returning = `Unknown`.
  endcase.
endmethod.
ENDCLASS.
