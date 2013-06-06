function z_rt_taskview.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(VIEW) TYPE REF TO  ZCL_RT_VIEW
*"----------------------------------------------------------------------
*/**
* Displays an exercise
*/

  _view = view.
  perform init.
  call screen 1.

endfunction.