forward
global type nvo_argv from nonvisualobject
end type
end forward

global type nvo_argv from nonvisualobject
event ue_thread ( )
end type
global nvo_argv nvo_argv

type variables
Window win_arg

end variables
forward prototypes
public subroutine uf_setparent (window w_argv)
end prototypes

event ue_thread();win_arg.TriggerEvent("ue_thread")

end event

public subroutine uf_setparent (window w_argv);win_arg = w_argv

end subroutine

on nvo_argv.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_argv.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

