class ZCL_RT_MODEL definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_RT_MODEL
*"* do not include other source files here!!!

  types:
    EXERCISES_TAB type standard table of ref to ZCL_RT_exercise .

  data EXERCISES type EXERCISES_TAB .
  data CHECKED_EXERCISE type ref to ZCL_RT_EXERCISE .

  methods CONSTRUCTOR .
  methods NEW_MATCH_TASK
    importing
      !TEXT type STRING
      !MATCH_TEXT type STRING
    returning
      value(RETURNING) type ref to ZCL_RT_TASK .
  methods NEW_SKIP_TASK
    importing
      !TEXT type STRING
      !SKIP_TEXT type STRING
    returning
      value(RETURNING) type ref to ZCL_RT_TASK .
  methods NEW_CAPTURE_TASK
    importing
      !TEXT type STRING
      !CAPTURE_TEXTS type STRINGTAB
    returning
      value(RETURNING) type ref to ZCL_RT_TASK .
  methods NEW_TASK
    importing
      !TYPE type I
      !TEXT type STRING
    returning
      value(RETURNING) type ref to ZCL_RT_TASK .
protected section.
*"* protected components of class ZCL_RT_MODEL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_RT_MODEL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_RT_MODEL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_MODEL->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
*/**
* Initializes all exercises.
* All these exercises were taken from the great regular expressions tutorial at <a href="http://regexone.com" target="_blank">RegexOne</a>
*/

  data exercise type ref to zcl_rt_exercise.
  data capture_texts type stringtab.

  create object exercise.
  exercise->title1 = `In regular expressions everything is a character.`.
  exercise->title2 = `For example, a matches a, and ab matches ab`.
  exercise->title3 = `Match a letter which appears in all these strings.`.
  exercise->task1 = new_match_task( text = `abcdefg` match_text = `` ).
  exercise->task2 = new_match_task( text = `abcde` match_text = `` ).
  exercise->task3 = new_match_task( text = `abc` match_text = `` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The \d character can be used to match any digit from 0 to 9.`.
  exercise->title2 = `Match the digits in these strings.`.
  exercise->title3 = ``.
  exercise->task1 = new_match_task( text = `abc123xyz` match_text = `123` ).
  exercise->task2 = new_match_task( text = `define “123”` match_text = `123` ).
  exercise->task3 = new_match_task( text = `var g = 123;` match_text = `123` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The . (dot) matches anything (wildcard). To match an actual dot, use the escape character: \.`.
  exercise->title2 = `Match the dots in these strings.`.
  exercise->title3 = ``.
  exercise->task1 = new_match_task( text = `c4t.` match_text = `.` ).
  exercise->task2 = new_match_task( text = `?=+.` match_text = `.` ).
  exercise->task3 = new_skip_task( text = `abc1` skip_text = `abc1` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Match specific characters by defining them inside square brackets.`.
  exercise->title2 = `For example, [abc] will match a single a, b, or c.`.
  exercise->title3 = `Match all strings except the last one using square brackets.`.
  exercise->task1 = new_match_task( text = `can` match_text = `can` ).
  exercise->task2 = new_match_task( text = `man` match_text = `man` ).
  exercise->task3 = new_skip_task( text = `fan` skip_text = `fan` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Exclude specific characters by defining them inside square brackets, starting with the hat.`.
  exercise->title2 = `For example, [^abc] will exclude a single a, b, or c.`.
  exercise->title3 = `Match all strings except the last one using square brackets and the hat.`.
  exercise->task1 = new_match_task( text = `hog` match_text = `hog` ).
  exercise->task2 = new_match_task( text = `dog` match_text = `dog` ).
  exercise->task3 = new_skip_task( text = `bog` skip_text = `bog` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `A character range can be defined using a dash inside square brackets.`.
  exercise->title2 = `For example, [0-6] matches any digit from 0 to 6, and [^n-p] will match any character except n, o and p.`.
  exercise->title3 = `Match the first letter of these strings.`.
  exercise->task1 = new_match_task( text = `Ana` match_text = `A` ).
  exercise->task2 = new_match_task( text = `Bob` match_text = `B` ).
  exercise->task3 = new_match_task( text = `Cpc` match_text = `C` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The number of repetitions can be specified with curly braces.`.
  exercise->title2 = `For example, a{3} will match the a character exactly 3 times, and a{1,3} will match it 1, 2 or 3 times.`.
  exercise->title3 = `Match the z's, but only when there's 2 or more.`.
  exercise->task1 = new_match_task( text = `wazzzzup` match_text = `zzzz` ).
  exercise->task2 = new_match_task( text = `wazzzup` match_text = `zzz` ).
  exercise->task3 = new_skip_task( text = `wazup` skip_text = `z` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The * means 0 or more. The + means 1 or more`.
  exercise->title2 = `For example, \d+ means one or more digits, and .* means 0 or more of any character.`.
  exercise->title3 = `Match these strings using the * and +.`.
  exercise->task1 = new_match_task( text = `aaaabcc` match_text = `` ).
  exercise->task2 = new_match_task( text = `aabbbbc` match_text = `` ).
  exercise->task3 = new_match_task( text = `aacc` match_text = `` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The ? (question mark) means a character or group is optional.`.
  exercise->title2 = `For example, ab?c will match either the strings "abc" or "ac" because the b is considered optional.`.
  exercise->title3 = `Match these strings using the question mark.`.
  exercise->task1 = new_match_task( text = `1 file found?` match_text = `1 file found?` ).
  exercise->task2 = new_match_task( text = `2 files found?` match_text = `2 files found?` ).
  exercise->task3 = new_match_task( text = `x files found?` match_text = `x files found?` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The ' ' (space) matches a space, \t matches a tab, \n a newline, \r a carriage return.`.
  exercise->title2 = `You can use \s to match any of these.`.
  exercise->title3 = `Match the strings with whitespace.`.
  data task1_tabs type string.
  concatenate `1.` cl_abap_char_utilities=>horizontal_tab cl_abap_char_utilities=>horizontal_tab cl_abap_char_utilities=>horizontal_tab `abc` into task1_tabs.
  exercise->task1 = new_match_task( text = task1_tabs match_text = task1_tabs ).
  exercise->task2 = new_match_task( text = `2.   abc` match_text = `2.   abc` ).
  exercise->task3 = new_skip_task( text = `3.abc` skip_text = `3.abc` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `The ^ (hat) means starts with. The $ (dollar sign) means ends with.`.
  exercise->title2 = `For example, ^successful$ will match exactly a line that contains only the word successful.`.
  exercise->title3 = `Match only the first string using the ^ and $.`.
  exercise->task1 = new_match_task( text = `Mission: successful` match_text = `Mission: successful` ).
  exercise->task2 = new_skip_task( text = `Last Mission: unsuccessful` skip_text = `Last Mission: unsuccessful` ).
  exercise->task3 = new_skip_task( text = `Next Mission: successful upon capture of target` skip_text = `Next Mission: successful upon capture of target` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Use (…) (parenthesis) to group a pattern and capture the matching strings.`.
  exercise->title2 = `For example, ^(IMG\d+)\.png$ would capture the filename but not the extension of a numbered image filename.`.
  exercise->title3 = `Capture the filenames, but only for the PDF files.`.
  append `file_a_record_file` to capture_texts.
  exercise->task1 = new_capture_task( text = `file_a_record_file.pdf` capture_texts = capture_texts ).
  clear capture_texts.
  append `file_yesterday` to capture_texts.
  exercise->task2 = new_capture_task( text = `file_yesterday.pdf` capture_texts = capture_texts ).
  clear capture_texts.
  exercise->task3 = new_skip_task( text = `testfile_fake.pdf.tmp` skip_text = `testfile_fake.pdf.tmp` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Groups can be nested.`.
  exercise->title2 = `For example, ^(IMG(\d+))\.png$ would capture both the filename, and just the number part of the filename.`.
  exercise->title3 = `Capture the entire date string, but also capture the year separately.`.
  append `Jan 1987` to capture_texts.
  append `1987` to capture_texts.
  exercise->task1 = new_capture_task( text = `Jan 1987` capture_texts = capture_texts ).
  clear capture_texts.
  append `May 1969` to capture_texts.
  append `1969` to capture_texts.
  exercise->task2 = new_capture_task( text = `May 1969` capture_texts = capture_texts ).
  clear capture_texts.
  append `Aug 2011` to capture_texts.
  append `2011` to capture_texts.
  exercise->task3 = new_capture_task( text = `Aug 2011` capture_texts = capture_texts ).
  clear capture_texts.
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Quantifiers (*, +, ? and {m,n} can be applied to groups.`.
  exercise->title2 = `For example, instead of writing \d?\d?\d? you can instead write (\d{3})? to match the same string.`.
  exercise->title3 = `Capture the numbers in these resolution strings.`.
  append `1280` to capture_texts.
  append `720` to capture_texts.
  exercise->task1 = new_capture_task( text = `1280x720` capture_texts = capture_texts ).
  clear capture_texts.
  append `1920` to capture_texts.
  append `1600` to capture_texts.
  exercise->task2 = new_capture_task( text = `1920x1600` capture_texts = capture_texts ).
  clear capture_texts.
  append `1024` to capture_texts.
  append `768` to capture_texts.
  exercise->task3 = new_capture_task( text = `1024x768` capture_texts = capture_texts ).
  clear capture_texts.
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Use the | (pipe) to indicate a logical OR.`.
  exercise->title2 = `For example, "Buy more (milk|bread|juice)" matches strings ending with milk, bread or juice.`.
  exercise->title3 = `Only capture the strings with small fuzzy creatures.`.
  exercise->task1 = new_match_task( text = `I love cats` match_text = `I love cats` ).
  exercise->task2 = new_match_task( text = `I love dogs` match_text = `I love dogs` ).
  exercise->task3 = new_skip_task( text = `I love logs` skip_text = `I love logs` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Metacharacters: \d digits, \w words, \s whitespace, \b boundary, \D non-digit, \W non-word, \S non-whitespace`.
  exercise->title2 = `Try out the different metacharacters and see what they match.`.
  exercise->title3 = ``.
  exercise->task1 = new_match_task( text = `The quick brown fox jumped over the lazy dog.` match_text = `` ).
  exercise->task2 = new_match_task( text = `There were 614 instances of students getting 90.0% or above.` match_text = `` ).
  exercise->task3 = new_match_task( text = `The FCC had to censor the network for saying &?#$*@!.` match_text = `` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Match these scientific and decimal numbers.`.
  exercise->title2 = ``.
  exercise->title3 = ``.
  exercise->task1 = new_match_task( text = `-255.34` match_text = `-255.34` ).
  exercise->task2 = new_match_task( text = `1.9e10` match_text = `1.9e10` ).
  exercise->task3 = new_skip_task( text = `720p` skip_text = `720p` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Capture the area codes on these phone numbers.`.
  exercise->title2 = ``.
  exercise->title3 = ``.
  append `415` to capture_texts.
  exercise->task1 = new_capture_task( text = `415-555-1234` capture_texts = capture_texts ).
  clear capture_texts.
  append `416` to capture_texts.
  exercise->task2 = new_capture_task( text = `(416)555-3456` capture_texts = capture_texts ).
  clear capture_texts.
  append `403` to capture_texts.
  exercise->task3 = new_capture_task( text = `4035555678` capture_texts = capture_texts ).
  clear capture_texts.
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Capture the name part for these email addresses.`.
  exercise->title2 = ``.
  exercise->title3 = ``.
  append `tom.riddle` to capture_texts.
  exercise->task1 = new_capture_task( text = `tom.riddle@hogwarts.com` capture_texts = capture_texts ).
  clear capture_texts.
  append `hermione` to capture_texts.
  exercise->task2 = new_capture_task( text = `hermione+gmailfilter@hogwarts.com` capture_texts = capture_texts ).
  clear capture_texts.
  append `tom` to capture_texts.
  exercise->task3 = new_capture_task( text = `tom@hogwarts.eu.com` capture_texts = capture_texts ).
  clear capture_texts.
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Capture the filename and extension for the image files only.`.
  exercise->title2 = ``.
  exercise->title3 = ``.
  append `img0912` to capture_texts.
  append `jpg` to capture_texts.
  exercise->task1 = new_capture_task( text = `img0912.jpg` capture_texts = capture_texts ).
  clear capture_texts.
  append `updated_img0912` to capture_texts.
  append `png` to capture_texts.
  exercise->task2 = new_capture_task( text = `updated_img0912.png` capture_texts = capture_texts ).
  clear capture_texts.
  exercise->task3 = new_skip_task( text = `documentation.html` skip_text = `documentation.html` ).
  append exercise to exercises.

  create object exercise.
  exercise->title1 = `Extract the method name, filename and line number from these error log entries.`.
  exercise->title2 = ``.
  exercise->title3 = ``.
  exercise->task1 = new_skip_task( text = `E/( 1553): java.lang.StringIndexOutOfBoundsException` skip_text = `E/( 1553): java.lang.StringIndexOutOfBoundsException` ).
  append `makeView` to capture_texts.
  append `ListView.java` to capture_texts.
  append `1727` to capture_texts.
  exercise->task2 = new_capture_task( text = `E/( 1553):   at widget.List.makeView(ListView.java:1727)` capture_texts = capture_texts ).
  clear capture_texts.
  append `fillFrom` to capture_texts.
  append `ListView.java` to capture_texts.
  append `709` to capture_texts.
  exercise->task3 = new_capture_task( text = `E/( 1553):   at widget.List.fillFrom(ListView.java:709)` capture_texts = capture_texts ).
  clear capture_texts.
  append exercise to exercises.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_MODEL->NEW_CAPTURE_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXT                           TYPE        STRING
* | [--->] CAPTURE_TEXTS                  TYPE        STRINGTAB
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_capture_task.
*/**
* Returns a new capture task
*/
  data task type ref to zcl_rt_task.
  task = new_task( type = zcl_rt_task=>type_capture text = text ).
  task->capture = capture_texts.
  returning = task.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_MODEL->NEW_MATCH_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXT                           TYPE        STRING
* | [--->] MATCH_TEXT                     TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_match_task.
*/**
* Returns a new match task
*/
  data task type ref to zcl_rt_task.
  task = new_task( type = zcl_rt_task=>type_match text = text ).
  append match_text to task->capture.
  returning = task.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_MODEL->NEW_SKIP_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXT                           TYPE        STRING
* | [--->] SKIP_TEXT                      TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_skip_task.
*/**
* Returns a new skip task
*/
  data task type ref to zcl_rt_task.
  task = new_task( type = zcl_rt_task=>type_skip text = text ).
  append skip_text to task->capture.
  returning = task.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RT_MODEL->NEW_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] TYPE                           TYPE        I
* | [--->] TEXT                           TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_RT_TASK
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_task.
*/**
* Returns a new task
*/
  data task type ref to zcl_rt_task.
  create object task.
  task->type = type.
  task->text = text.
  task->icon = zcl_rt_icons=>unknown.
  returning = task.
endmethod.
ENDCLASS.
