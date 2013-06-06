class ZCL_RT_TASK definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_TASK
*"* do not include other source files here!!!

  constants TYPE_MATCH type I value 0. "#EC NOTEXT
  constants TYPE_SKIP type I value 1. "#EC NOTEXT
  constants TYPE_CAPTURE type I value 2. "#EC NOTEXT
  data TYPE type I .
  data TEXT type STRING .
  data CAPTURE type STRINGTAB .
  data ICON type ICON_TEXT .
  type-pools ABAP .
  data SOLVED type ABAP_BOOL .

  methods CLONE
    returning
      value(RETURNING) type ref to ZCL_RT_TASK .
protected section.
*"* protected components of class ZCL_RT_TASK
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_TASK
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_RT_TASK IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_TASK->CLONE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method clone.
*/**
* Returns an exact copy of itself
*/
  create object returning.
  returning->type = me->type.
  returning->text = me->text.
  returning->capture = me->capture.
  returning->icon = me->icon.
  returning->solved = me->solved.
endmethod.
ENDCLASS.
