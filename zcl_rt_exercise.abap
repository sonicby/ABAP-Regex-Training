class ZCL_RT_EXERCISE definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_EXERCISE
*"* do not include other source files here!!!

  data TITLE1 type STRING .
  data TITLE2 type STRING .
  data TITLE3 type STRING .
  data TASK1 type ref to ZCL_RT_TASK .
  data TASK2 type ref to ZCL_RT_TASK .
  data TASK3 type ref to ZCL_RT_TASK .

  methods CLONE
    returning
      value(RETURNING) type ref to ZCL_RT_EXERCISE .
protected section.
*"* protected components of class ZCL_RT_EXERCISE
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_EXERCISE
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_RT_EXERCISE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_EXERCISE->CLONE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_EXERCISE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method clone.
*/**
* Returns an exact copy of itself
*/
  create object returning.
  returning->title1 = me->title1.
  returning->title2 = me->title2.
  returning->title3 = me->title3.
  returning->task1 = me->task1->clone( ).
  returning->task2 = me->task2->clone( ).
  returning->task3 = me->task3->clone( ).
endmethod.
ENDCLASS.
