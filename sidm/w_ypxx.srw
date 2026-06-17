forward
global type w_ypxx from Window
end type
type sle_1 from singlelineedit within w_ypxx
end type
type cb_1 from commandbutton within w_ypxx
end type
type cb_5 from commandbutton within w_ypxx
end type
type ddlb_2 from dropdownlistbox within w_ypxx
end type
type st_2 from statictext within w_ypxx
end type
type dw_1 from datawindow within w_ypxx
end type
type st_1 from statictext within w_ypxx
end type
end forward

global type w_ypxx from Window
int X=0
int Y=0
int Width=3685
int Height=2284
boolean TitleBar=true
string Title="药品信息"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
WindowType WindowType=popup!
sle_1 sle_1
cb_1 cb_1
cb_5 cb_5
ddlb_2 ddlb_2
st_2 st_2
dw_1 dw_1
st_1 st_1
end type
global w_ypxx w_ypxx

type variables
long ll_rown
end variables

event open;if not gf_isconnect() then
	messagebox('提示','尚未连接任务数据库!')
	close(this)
	return
end if
dw_1.settransobject(sqlca)
select count(*) into :ll_rown
from yk_typk,
	yk_ypsx,
	yk_ypbm,
	yk_ypcd,
	yk_cddz where yk_typk.ypsx=yk_ypsx.ypsx
	and yk_typk.ypxh=yk_ypbm.ypxh
	and yk_typk.ypxh=yk_ypcd.ypxh
	and yk_ypcd.ypcd=yk_cddz.ypcd
	and yk_ypcd.pfjg>0;
dw_1.retrieve()
dw_1.setsort("ctype,yk_typk_pydm")
dw_1.sort()
dw_1.selectrow(1,true)
sle_1.setfocus()
end event

on w_ypxx.create
this.sle_1=create sle_1
this.cb_1=create cb_1
this.cb_5=create cb_5
this.ddlb_2=create ddlb_2
this.st_2=create st_2
this.dw_1=create dw_1
this.st_1=create st_1
this.Control[]={this.sle_1,&
this.cb_1,&
this.cb_5,&
this.ddlb_2,&
this.st_2,&
this.dw_1,&
this.st_1}
end on

on w_ypxx.destroy
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.cb_5)
destroy(this.ddlb_2)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.st_1)
end on

type sle_1 from singlelineedit within w_ypxx
event keyup pbm_keyup
int X=357
int Y=2016
int Width=407
int Height=92
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
TextCase TextCase=Upper!
long TextColor=33554432
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event keyup;string ls_text
long ll_row
long ll_ypxh,ll_ypcd
ls_text=trim(sle_1.text)
choose case key
	case keyuparrow! 
		dw_1.scrollpriorrow()
		return
	case keydownarrow! 
		dw_1.scrollnextrow()
		return
	case keypageup!
		dw_1.scrollpriorpage()
		return
	case keypagedown!
		dw_1.scrollnextpage()
		return
end choose
if ls_text<>'' then
   ll_row=dw_1.find("yk_typk_pydm like '"+ls_text+"%'",1,dw_1.rowcount())
	if ll_row>0 then
		dw_1.scrolltorow(ll_row)
		dw_1.selectrow(0,false)
		dw_1.selectrow(ll_row,true)
	end if
end if


end event

type cb_1 from commandbutton within w_ypxx
int X=1170
int Y=2008
int Width=311
int Height=108
int TabOrder=30
string Text="&P打印"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;openwithparm(w_print_setup,dw_1)

end event

type cb_5 from commandbutton within w_ypxx
int X=850
int Y=2512
int Width=247
int Height=108
int TabOrder=40
string Text="none"
boolean Cancel=true
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;close(parent)
end event

type ddlb_2 from dropdownlistbox within w_ypxx
int X=2775
int Y=2008
int Width=667
int Height=600
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean Sorted=false
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
string Item[]={"全部",&
"可能有问题的记录",&
"西药库",&
"中药库"}
end type

event selectionchanged;choose case index
	case 1
		dw_1.setfilter("")
	case 2
		dw_1.setfilter("((((czxdw='盒' or czxdw='合' or czxdw='瓶') and czxbz>1) &
 			or ((cbfdw='盒' or cbfdw='合' or cbfdw='瓶') and cbfbz=1 and cbfbz<>czxbz) &
			 )  or isnull(cypdw) or isnull(czxdw) or isnull(cbfdw) or isnull(cyfdw) &
			) ")
	case 3
		dw_1.setfilter("yk_typk_xtsb=1")
	case 4
		dw_1.setfilter("yk_typk_xtsb=2")
end choose
dw_1.filter()
dw_1.setsort("ctype,yk_typk_pydm")
dw_1.sort()
dw_1.setfocus()
end event

type st_2 from statictext within w_ypxx
int X=2619
int Y=2040
int Width=197
int Height=76
boolean Enabled=false
string Text="过滤"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_1 from datawindow within w_ypxx
event dwnkey pbm_dwnkey
int Width=3648
int Height=1988
int TabOrder=10
string DataObject="d_ypxx"
boolean Border=false
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event clicked;if row<=this.rowcount() and row>0 then
	this.selectrow(0,false)
	this.selectrow(row,true)
end if
sle_1.setfocus()


end event

event rowfocuschanged;this.selectrow(0,false)
this.selectrow(this.getrow(),true)

end event

event getfocus;this.selectrow(0,false)
this.selectrow(1,true)
end event

event retrieveend;//w_main.st_jdt.visible=false
end event

event doubleclicked;sle_1.setfocus()

end event

type st_1 from statictext within w_ypxx
int X=46
int Y=2028
int Width=306
int Height=76
boolean Enabled=false
string Text="拼音代码"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

