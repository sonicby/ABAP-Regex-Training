class ZCL_RT_CONTROLLER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_CONTROLLER
*"* do not include other source files here!!!

  methods CONSTRUCTOR .
  methods RUN
    importing
      !START_WITH_EXERCISE_NUMBER type I default 1 .
protected section.
*"* protected components of class ZCL_RT_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_CONTROLLER
*"* do not include other source files here!!!

  data _CHECKER type ref to ZCL_RT_CHECKER .
  data _MODEL type ref to ZCL_RT_MODEL .
  data _VIEW type ref to ZCL_RT_VIEW .
  data _CURRENT_EXERCISE type I .

  methods _ON_CHECK
    for event CHECK of ZCL_RT_VIEW
    importing
      !EXERCISE_NUMBER
      !INPUT .
  methods _NEXT .
  methods _PREVIOUS .
  methods _CHECK_FIRST_LAST .
  methods _SET_EXERCISE_NUMBER
    importing
      !NUMBER type I .
ENDCLASS.



CLASS ZCL_RT_CONTROLLER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_CONTROLLER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
*/**
* Initialize MVC
*/
  " Setup regex checker
  create object _checker.
  " Setup model and view
  create object _model.
  create object _view
    exporting
      model = _model.
  " Subscribe to view events
  set handler _on_check for _view.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_CONTROLLER->RUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] START_WITH_EXERCISE_NUMBER     TYPE        I (default =1)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method run.
*/**
* Starts the application
*/
  " Set current exercise
  _set_exercise_number( start_with_exercise_number ).
  " Display view
  _view->display( _current_exercise ).
  while _view->action is not initial.
    clear: _view->input, _view->solved_all.
    case _view->action.
      when _view->action_next.
        _next( ).
        _view->display( _current_exercise ).
      when _view->action_prev.
        _previous( ).
        _view->display( _current_exercise ).
      when _view->action_done.
        submit zregextrainingdone.
      when others.
        " Quit
        exit.
    endcase.
  endwhile.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CONTROLLER->_CHECK_FIRST_LAST
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _check_first_last.
*/**
* Checks if the current exercise is the first and/or last exercise
*/
  if lines( _model->exercises ) = _current_exercise.
    _view->exercise_is_last = abap_true.
  else.
    _view->exercise_is_last = abap_false.
  endif.
  if _current_exercise = 1.
    _view->exercise_is_first = abap_true.
  else.
    _view->exercise_is_first = abap_false.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CONTROLLER->_NEXT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _next.
*/**
* Set next exercise
*/
  _set_exercise_number( _current_exercise + 1 ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CONTROLLER->_ON_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] EXERCISE_NUMBER                LIKE
* | [--->] INPUT                          LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _on_check.
*/**
* Event handler for 'check' event coming from the view
*/
  " Read the exercise to check
  data exercise type ref to zcl_rt_exercise.
  read table _model->exercises index exercise_number into exercise.
  " Perform check
  _model->checked_exercise = _checker->check_exercise( input = input exercise = exercise ).
  " All solved?
  if _model->checked_exercise->task1->solved = abap_true and
     _model->checked_exercise->task2->solved = abap_true and
     _model->checked_exercise->task3->solved = abap_true.
    _view->solved_all = abap_true.
  else.
    _view->solved_all = abap_false.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CONTROLLER->_PREVIOUS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _previous.
*/**
* Set previous exercise
*/
  _set_exercise_number( _current_exercise - 1 ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_RT_CONTROLLER->_SET_EXERCISE_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NUMBER                         TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _set_exercise_number.
*/**
* Set the current exercise number. Makes sure this number doesn't go out of bounds.
*/
  if number < 1.
    _current_exercise = 1.
  else.
    if lines( _model->exercises ) < number.
      _current_exercise = lines( _model->exercises ).
    else.
      _current_exercise = number.
    endif.
  endif.
  _check_first_last( ).
endmethod.
ENDCLASS.
