class ZCL_RT_ICONS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_ICONS
*"* do not include other source files here!!!

  class-data CANCEL type ICONS-TEXT read-only .
  class-data OK type ICONS-TEXT read-only .
  class-data UNKNOWN type ICONS-TEXT read-only .
  class-data NEXT type ICONS-TEXT .
  class-data PREVIOUS type ICONS-TEXT .
  class-data DONE type ICONS-TEXT .

  class-methods CLASS_CONSTRUCTOR .
protected section.
*"* protected components of class ZCL_RT_ICONS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_ICONS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_RT_ICONS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_RT_ICONS=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method class_constructor.
*/**
* Initializes the icons
*/
  call function 'ICON_CREATE'
    exporting
      name   = `ICON_CANCEL`
      text   = ``
      info   = `Incorrect`
    importing
      result = cancel.
  call function 'ICON_CREATE'
    exporting
      name   = `ICON_OKAY`
      text   = ``
      info   = `Correct`
    importing
      result = ok.
  call function 'ICON_CREATE'
    exporting
      name   = `ICON_SYSTEM_HELP`
      text   = ``
      info   = `Not checked`
    importing
      result = unknown.
  call function 'ICON_CREATE'
    exporting
      name   = `ICON_NEXT_OBJECT`
      text   = `Next`
      info   = `Next`
    importing
      result = next.
  call function 'ICON_CREATE'
    exporting
      name   = `ICON_PREVIOUS_OBJECT`
      text   = `Previous`
      info   = `Previous`
    importing
      result = previous.
  call function 'ICON_CREATE'
    exporting
      name   = `ICON_COMPLETE`
      text   = `Done`
      info   = `Done`
    importing
      result = done.
endmethod.
ENDCLASS.
