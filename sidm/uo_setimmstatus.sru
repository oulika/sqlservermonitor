forward
global type uo_setimmstatus from nonvisualobject
end type
end forward

global type uo_setimmstatus from nonvisualobject
end type
global uo_setimmstatus uo_setimmstatus

type prototypes
private function long ImmGetContext(long hWnd) library "imm32.dll"
private function boolean  ImmSetOpenStatus(long hIMC,boolean status) library "imm32.dll"
private function boolean ImmReleaseContext(long hWnd,long hIMC) library "imm32.dll"

end prototypes

forward prototypes
public function boolean openimm (long hwnd)
public function boolean closeimm (long hWnd)
public function boolean openimm (long hwnd)
public function boolean closeimm (long hWnd)
end prototypes

public function boolean openimm (long hwnd);long ll_IMC
boolean lb_success
ll_IMC=immGetContext( hWnd )
lb_success=immSetOpenStatus(ll_IMC,true) 
lb_success=lb_success and immReleaseContext(hWnd,ll_IMC)
return lb_success


end function

public function boolean closeimm (long hWnd);long ll_IMC
boolean lb_success
ll_IMC=immGetContext(hWnd)
lb_success=immSetOpenStatus(ll_IMC,false) 
lb_success=lb_success and immReleaseContext(hWnd,ll_IMC)
return lb_success


end function

on uo_setimmstatus.create
TriggerEvent( this, "constructor" )
end on

on uo_setimmstatus.destroy
TriggerEvent( this, "destructor" )
end on

