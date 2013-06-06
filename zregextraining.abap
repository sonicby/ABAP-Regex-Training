report zregextraining.
*/**
* Starts the training program.
* Allows the user to optionally specify an exercise number to start at.
*/

parameters exercise type i default 1.

data training type ref to zcl_rt_controller.
create object training.
if exercise is not initial.
  training->run( exercise ).
else.
  training->run( ).
endif.