forward
global type nvo_thread from nonvisualobject
end type
end forward

global type nvo_thread from nonvisualobject
end type
global nvo_thread nvo_thread

type variables
nonvisualobject inv_arg

end variables
forward prototypes
public subroutine uf_setparent (ref nonvisualobject nv_arg)
public subroutine uf_start ()
end prototypes

public subroutine uf_setparent (ref nonvisualobject nv_arg);inv_arg = nv_arg

end subroutine

public subroutine uf_start ();inv_arg.TriggerEvent('ue_thread')

end subroutine

on nvo_thread.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_thread.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

