forward
global type w_waiting from Window
end type
type cb_cancel from commandbutton within w_waiting
end type
type st_info from statictext within w_waiting
end type
type uo_1 from vu_progress within w_waiting
end type
end forward

global type w_waiting from Window
int X=850
int Y=688
int Width=1650
int Height=260
boolean Enabled=false
long BackColor=79741120
boolean Resizable=true
WindowType WindowType=popup!
event refresh ( string ls_message )
cb_cancel cb_cancel
st_info st_info
uo_1 uo_1
end type
global w_waiting w_waiting

forward prototypes
public subroutine refresh (integer an_percent, string as_info)
public subroutine enablecancel (boolean ab_enable)
end prototypes

public subroutine refresh (integer an_percent, string as_info);SetPointer(HourGlass!)
if (an_Percent<0)or(an_Percent>=100) then
	Close(This)
	return
end if
st_Info.Text = as_Info+" "+String(an_Percent)+"%"
uo_1.SetProgress(an_Percent)
return
end subroutine

public subroutine enablecancel (boolean ab_enable);cb_Cancel.Visible = ab_Enable
w_waiting.height=400
return
end subroutine

on w_waiting.create
this.cb_cancel=create cb_cancel
this.st_info=create st_info
this.uo_1=create uo_1
this.Control[]={this.cb_cancel,&
this.st_info,&
this.uo_1}
end on

on w_waiting.destroy
destroy(this.cb_cancel)
destroy(this.st_info)
destroy(this.uo_1)
end on

event open;SetPointer(HourGlass!)
gf_Center_Window(This)
cb_Cancel.Visible = False
st_Info.Text = "正在处理，请稍候0%..."
uo_1.SetProgress(0)
return

end event

event activate;//==============================================================================
// Added By Sunlf 2001.12.14
//==============================================================================
Window lw_ParentWin

lw_ParentWin = ParentWindow()

IF IsValid(lw_ParentWin) THEN lw_ParentWin.SetFocus()
//==============================================================================

end event

type cb_cancel from commandbutton within w_waiting
int X=635
int Y=244
int Width=370
int Height=88
int TabOrder=20
string Text="取消(&C)"
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;if MessageBox("操作提示","处理尚未完成，是否确认要退出?",Information!,OKCancel!,2)=1 then
	Close(Parent)
end if
return
end event

type st_info from statictext within w_waiting
int X=50
int Y=24
int Width=1536
int Height=60
boolean Enabled=false
string Text="请稍候..."
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type uo_1 from vu_progress within w_waiting
int X=32
int Y=96
int Width=1550
boolean BringToTop=true
boolean Border=true
long BackColor=16777215
end type

on uo_1.destroy
call vu_progress::destroy
end on

