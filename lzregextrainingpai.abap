*----------------------------------------------------------------------*
*  MODULE user_command_0001 INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
module user_command_0001 input.
  case sy-ucomm.
    when ucomm_check.
      _view->perform_check( ).
    when ucomm_back or ucomm_cancel or ucomm_exit.
      clear _view->action.
      perform leave_view.
    when ucomm_next.
      if _view->exercise_is_last = abap_false.
        _view->action = _view->action_next.
      else.
        _view->action = _view->action_done.
      endif.
      perform leave_view.
    when ucomm_prev.
      if _view->exercise_is_first = abap_false.
        _view->action = _view->action_prev.
        perform leave_view.
      endif.
    when others.
  endcase.
endmodule.                    "user_command_0001 INPUT