forward
global type w_sswr from Window
end type
type st_3 from statictext within w_sswr
end type
type st_2 from statictext within w_sswr
end type
type st_1 from statictext within w_sswr
end type
type dw_2 from datawindow within w_sswr
end type
type cb_2 from commandbutton within w_sswr
end type
type ddlb_1 from dropdownlistbox within w_sswr
end type
type em_e from editmask within w_sswr
end type
type em_b from editmask within w_sswr
end type
type cb_1 from commandbutton within w_sswr
end type
type dw_1 from datawindow within w_sswr
end type
end forward

global type w_sswr from Window
int X=690
int Y=600
int Width=2290
int Height=1232
boolean TitleBar=true
string Title="四舍五入查询"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
WindowType WindowType=popup!
st_3 st_3
st_2 st_2
st_1 st_1
dw_2 dw_2
cb_2 cb_2
ddlb_1 ddlb_1
em_e em_e
em_b em_b
cb_1 cb_1
dw_1 dw_1
end type
global w_sswr w_sswr

on w_sswr.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_2=create dw_2
this.cb_2=create cb_2
this.ddlb_1=create ddlb_1
this.em_e=create em_e
this.em_b=create em_b
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.st_3,&
this.st_2,&
this.st_1,&
this.dw_2,&
this.cb_2,&
this.ddlb_1,&
this.em_e,&
this.em_b,&
this.cb_1,&
this.dw_1}
end on

on w_sswr.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.cb_2)
destroy(this.ddlb_1)
destroy(this.em_e)
destroy(this.em_b)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;if not gf_isconnect() then
	messagebox('提示','尚未连接任务数据库!')
	close(this)
	return
end if
GF_CENTER_WINDOW(THIS)
LONG LL_ROW
STRING LS_YHMC,LS_YHDM
DW_1.SETTRANSOBJECT(SQLCA)
DW_2.SETTRANSOBJECT(SQLCA)
DW_2.RETRIEVE()
STRING LS_DATE
SELECT CONVERT(CHAR(10),GETDATE(),102) INTO :LS_DATE FROM GY_XTCS;
EM_B.TEXT=LS_DATE
EM_E.TEXT=LS_DATE
FOR LL_ROW=1 TO DW_2.ROWCOUNT()
	LS_DATE=DW_2.OBJECT.YHMC[LL_ROW]
	LS_DATE+=SPACE(10 - LEN(LS_YHMC))+DW_2.OBJECT.YHDM[LL_ROW]
	DDLB_1.ADDITEM(LS_DATE)
NEXT

end event

type st_3 from statictext within w_sswr
int X=1239
int Y=1016
int Width=87
int Height=76
boolean Enabled=false
string Text="至"
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=67108864
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_sswr
int X=635
int Y=1012
int Width=155
int Height=76
boolean Enabled=false
string Text="起止"
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=67108864
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_sswr
int X=55
int Y=1012
int Width=169
int Height=76
boolean Enabled=false
string Text="用户"
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=67108864
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_2 from datawindow within w_sswr
int X=1152
int Y=388
int Width=494
int Height=360
int TabOrder=50
boolean Visible=false
string DataObject="d_yhmc"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

type cb_2 from commandbutton within w_sswr
int X=695
int Y=1316
int Width=247
int Height=108
int TabOrder=70
string Text="none"
boolean Cancel=true
string FaceName="System"
FontCharSet FontCharSet=Ansi!
end type

event clicked;CLOSE(PARENT)
end event

type ddlb_1 from dropdownlistbox within w_sswr
int X=219
int Y=1000
int Width=379
int Height=552
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean Sorted=false
boolean VScrollBar=true
long TextColor=33554432
long BackColor=33554431
int TextSize=-12
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event selectionchanged;CB_1.TRIGGEREVENT(CLICKED!)
end event

type em_e from editmask within w_sswr
int X=1317
int Y=1008
int Width=425
int Height=92
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
string Mask="yyyy.mm.dd"
MaskDataType MaskDataType=DateMask!
boolean Spin=true
long TextColor=33554432
long BackColor=33554431
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_b from editmask within w_sswr
int X=805
int Y=1008
int Width=425
int Height=92
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
string Mask="yyyy.mm.dd"
MaskDataType MaskDataType=DateMask!
boolean Spin=true
long TextColor=33554432
long BackColor=33554431
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_sswr
int X=1833
int Y=1000
int Width=329
int Height=104
int TabOrder=40
string Text=" &S 查询"
int TextSize=-12
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;STRING LS_CZGH,ls_title
LONG LL_ROW,LL_ROWN,LL_SSWR
DOUBLE LD_JE
ls_title = parent.title
LS_CZGH=RIGHT(DDLB_1.TEXT,4)
DW_1.SETREDRAW(FALSE)
DW_1.RETRIEVE(EM_B.TEXT,EM_E.TEXT,LS_CZGH)
LL_ROWN=DW_1.ROWCOUNT()
FOR LL_ROW=1 TO LL_ROWN
	parent.title = ls_title + '  Now is working ...' + string(ll_row/ll_rown*100,'0') +'%'
	LD_JE=DW_1.OBJECT.XJJE[LL_ROW]
	LL_SSWR=LONG(RIGHT(STRING(LD_JE,'0.00'),1))
	IF LD_JE>0 THEN
		IF LL_SSWR<5 THEN 
			DW_1.OBJECT.SS[LL_ROW]= - LL_SSWR
		ELSE
			DW_1.OBJECT.WR[LL_ROW]= 10 - LL_SSWR
		END IF
	ELSE
		IF LL_SSWR<5 THEN 
			DW_1.OBJECT.WR[LL_ROW]=LL_SSWR
		ELSE
			DW_1.OBJECT.SS[LL_ROW]=LL_SSWR - 10
		END IF
	END IF
NEXT
parent.title = ls_title
IF DW_1.ROWCOUNT()>6 THEN
	DW_1.SCROLLTOROW(DW_1.ROWCOUNT()-6)
ELSE
	DW_1.SCROLLTOROW(DW_1.ROWCOUNT())
END IF
DW_1.SETREDRAW(TRUE)


end event

type dw_1 from datawindow within w_sswr
int X=14
int Y=12
int Width=2235
int Height=968
int TabOrder=60
string DataObject="d_sswr"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event clicked;if row>0 and row<=this.rowcount() then
	this.selectrow(0,false)
	this.selectrow(row,true)
end if

end event

event rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)

end event

