forward
global type w_print_setup from Window
end type
type cb_4 from commandbutton within w_print_setup
end type
type em_ybj_bottom from editmask within w_print_setup
end type
type em_ybj_left from editmask within w_print_setup
end type
type em_ybj_right from editmask within w_print_setup
end type
type em_ybj_top from editmask within w_print_setup
end type
type st_7 from statictext within w_print_setup
end type
type st_6 from statictext within w_print_setup
end type
type st_5 from statictext within w_print_setup
end type
type st_4 from statictext within w_print_setup
end type
type rb_ys_hb from radiobutton within w_print_setup
end type
type rb_ys_cs from radiobutton within w_print_setup
end type
type ddlb_zzdx from dropdownlistbox within w_print_setup
end type
type st_3 from statictext within w_print_setup
end type
type sle_y from singlelineedit within w_print_setup
end type
type st_2 from statictext within w_print_setup
end type
type st_1 from statictext within w_print_setup
end type
type ddlb_dy from dropdownlistbox within w_print_setup
end type
type em_fs from editmask within w_print_setup
end type
type rb_fw_y from radiobutton within w_print_setup
end type
type rb_fw_qb from radiobutton within w_print_setup
end type
type cb_3 from commandbutton within w_print_setup
end type
type cb_2 from commandbutton within w_print_setup
end type
type cb_1 from commandbutton within w_print_setup
end type
type gb_3 from groupbox within w_print_setup
end type
type gb_2 from groupbox within w_print_setup
end type
type gb_1 from groupbox within w_print_setup
end type
type gb_14 from groupbox within w_print_setup
end type
end forward

global type w_print_setup from Window
int X=823
int Y=360
int Width=1938
int Height=1136
boolean TitleBar=true
string Title="打印设置"
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=response!
cb_4 cb_4
em_ybj_bottom em_ybj_bottom
em_ybj_left em_ybj_left
em_ybj_right em_ybj_right
em_ybj_top em_ybj_top
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
rb_ys_hb rb_ys_hb
rb_ys_cs rb_ys_cs
ddlb_zzdx ddlb_zzdx
st_3 st_3
sle_y sle_y
st_2 st_2
st_1 st_1
ddlb_dy ddlb_dy
em_fs em_fs
rb_fw_y rb_fw_y
rb_fw_qb rb_fw_qb
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
gb_14 gb_14
end type
global w_print_setup w_print_setup

type variables
datawindow idw_dw
end variables

forward prototypes
public subroutine wf_save ()
end prototypes

public subroutine wf_save ();CHOOSE CASE trim(ddlb_zzdx.text)
	CASE 'A3 297 x 420 毫米'
		idw_dw.Modify("DataWindow.Print.Paper.Size='8'")
	CASE 'A4 210 x 297 毫米'
		idw_dw.Modify("DataWindow.Print.Paper.Size='9'")
	CASE 'A5 148 x 210 毫米'
		idw_dw.Modify("DataWindow.Print.Paper.Size='11'")
	CASE 'B4 250 x 354 毫米'
		idw_dw.Modify("DataWindow.Print.Paper.Size='12'")
	CASE 'B5 182 x 257 毫米'
		idw_dw.Modify("DataWindow.Print.Paper.Size='13'")
	case '210 x 280 毫米'
		idw_dw.Modify("DataWindow.Print.Paper.Size='4'")
	CASE '默认纸张大小'
		idw_dw.Modify("DataWindow.Print.Paper.Size='0'")
END CHOOSE


CHOOSE CASE trim(ddlb_dy.text)
	CASE '所选页面'
		idw_dw.Modify("DataWindow.Print.Page.RangeInclude='0'")
	CASE '奇数页'
		idw_dw.Modify("DataWindow.Print.Page.RangeInclude='1'")
	CASE '偶数页'
		idw_dw.Modify("DataWindow.Print.Page.RangeInclude='2'")
END CHOOSE

idw_dw.Modify("DataWindow.Print.Copies='"+string(integer(em_fs.text)) +"'")

idw_dw.Modify("DataWindow.Print.Margin.Top='"+string(integer(em_ybj_top.text))+"'")
idw_dw.Modify("DataWindow.Print.Margin.bottom='"+string(integer(em_ybj_bottom.text))+"'")
idw_dw.Modify("DataWindow.Print.Margin.left='"+string(integer(em_ybj_left.text))+"'")
idw_dw.Modify("DataWindow.Print.Margin.right='"+string(integer(em_ybj_right.text))+"'")

if rb_fw_qb.checked=true then
	idw_dw.Modify("DataWindow.Print.Page.Range=''")
else
	idw_dw.Modify("DataWindow.Print.Page.Range='"+trim(sle_y.text)+"'")
end if	

if rb_ys_cs.checked=true then  //打印方向
	idw_dw.Modify("DataWindow.Print.Orientation=0")	
else
	idw_dw.Modify("DataWindow.Print.Orientation=1")	
end if


end subroutine

on w_print_setup.create
this.cb_4=create cb_4
this.em_ybj_bottom=create em_ybj_bottom
this.em_ybj_left=create em_ybj_left
this.em_ybj_right=create em_ybj_right
this.em_ybj_top=create em_ybj_top
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.rb_ys_hb=create rb_ys_hb
this.rb_ys_cs=create rb_ys_cs
this.ddlb_zzdx=create ddlb_zzdx
this.st_3=create st_3
this.sle_y=create sle_y
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_dy=create ddlb_dy
this.em_fs=create em_fs
this.rb_fw_y=create rb_fw_y
this.rb_fw_qb=create rb_fw_qb
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_14=create gb_14
this.Control[]={this.cb_4,&
this.em_ybj_bottom,&
this.em_ybj_left,&
this.em_ybj_right,&
this.em_ybj_top,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.rb_ys_hb,&
this.rb_ys_cs,&
this.ddlb_zzdx,&
this.st_3,&
this.sle_y,&
this.st_2,&
this.st_1,&
this.ddlb_dy,&
this.em_fs,&
this.rb_fw_y,&
this.rb_fw_qb,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.gb_3,&
this.gb_2,&
this.gb_1,&
this.gb_14}
end on

on w_print_setup.destroy
destroy(this.cb_4)
destroy(this.em_ybj_bottom)
destroy(this.em_ybj_left)
destroy(this.em_ybj_right)
destroy(this.em_ybj_top)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.rb_ys_hb)
destroy(this.rb_ys_cs)
destroy(this.ddlb_zzdx)
destroy(this.st_3)
destroy(this.sle_y)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_dy)
destroy(this.em_fs)
destroy(this.rb_fw_y)
destroy(this.rb_fw_qb)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_14)
end on

event open;idw_dw=message.powerobjectparm
gf_center_window(this)

end event

event activate;CHOOSE CASE idw_dw.Describe("DataWindow.Print.Paper.Size")
	CASE '8' 
		ddlb_zzdx.text='A3 297 x 420 毫米'
	CASE '9' 
		ddlb_zzdx.text='A4 210 x 297 毫米'
	CASE '11' 
		ddlb_zzdx.text='A5 148 x 210 毫米'
	CASE '12' 
		ddlb_zzdx.text='B4 250 x 354 毫米'
	CASE '13' 
		ddlb_zzdx.text='B5 182 x 257 毫米'
	case '4'
		ddlb_zzdx.text='210 x 280 毫米'
	case '0'
		ddlb_zzdx.text='默认纸张大小'	
	CASE ELSE 
		ddlb_zzdx.text='A4 210 x 297 毫米'
END CHOOSE

CHOOSE CASE idw_dw.Describe("DataWindow.Print.Page.RangeInclude")
	CASE '0'
		ddlb_dy.text='所选页面'
	CASE '1'
		ddlb_dy.text='奇数页'
	CASE '2'
		ddlb_dy.text='偶数页'
	CASE ELSE
		ddlb_dy.text='所选页面'
END CHOOSE


if integer(idw_dw.Describe("DataWindow.Print.Copies"))<1 then
	em_fs.text='1'
else
	em_fs.text=trim(idw_dw.Describe("DataWindow.Print.Copies"))
end if

em_ybj_top.text="0" //idw_dw.Describe("DataWindow.Print.Margin.Top")
em_ybj_bottom.text="150" //idw_dw.Describe("DataWindow.Print.Margin.bottom")
em_ybj_left.text=idw_dw.Describe("DataWindow.Print.Margin.left")
em_ybj_right.text=idw_dw.Describe("DataWindow.Print.Margin.right")

if idw_dw.Describe("DataWindow.Print.Page.Range")<>"" then
	rb_fw_y.checked=true
	sle_y.enabled=true
	sle_y.text=idw_dw.Describe("DataWindow.Print.Page.Range")
else
	rb_fw_qb.checked=true
end if

CHOOSE CASE idw_dw.Describe("DataWindow.Print.Orientation")	//打印方向
	case '0'
		rb_ys_cs.checked = true
	case '1'
		rb_ys_hb.checked = true
end choose

end event

type cb_4 from commandbutton within w_print_setup
int X=814
int Y=908
int Width=325
int Height=88
int TabOrder=140
string Text="预览(&P)"
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;wf_save()
openwithparm(w_support_preview,idw_dw)
end event

type em_ybj_bottom from editmask within w_print_setup
int X=1577
int Y=108
int Width=247
int Height=76
int TabOrder=50
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
boolean Spin=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type em_ybj_left from editmask within w_print_setup
int X=1143
int Y=248
int Width=247
int Height=76
int TabOrder=60
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
boolean Spin=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type em_ybj_right from editmask within w_print_setup
int X=1577
int Y=248
int Width=247
int Height=76
int TabOrder=70
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
boolean Spin=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type em_ybj_top from editmask within w_print_setup
int X=1143
int Y=108
int Width=247
int Height=76
int TabOrder=40
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
boolean Spin=true
double Increment=1
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_7 from statictext within w_print_setup
int X=942
int Y=256
int Width=192
int Height=56
boolean Enabled=false
string Text="左(&L):"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_6 from statictext within w_print_setup
int X=1390
int Y=116
int Width=192
int Height=56
boolean Enabled=false
string Text="下(&B):"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_print_setup
int X=1390
int Y=256
int Width=192
int Height=56
boolean Enabled=false
string Text="右(&R):"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_print_setup
int X=951
int Y=116
int Width=183
int Height=56
boolean Enabled=false
string Text="上(&T):"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type rb_ys_hb from radiobutton within w_print_setup
int X=498
int Y=292
int Width=329
int Height=76
int TabOrder=30
string Text="横向(&H)"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type rb_ys_cs from radiobutton within w_print_setup
int X=114
int Y=292
int Width=302
int Height=76
int TabOrder=20
string Text="纵向(&I)"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type ddlb_zzdx from dropdownlistbox within w_print_setup
int X=114
int Y=100
int Width=699
int Height=288
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
string Item[]={"A3 297 x 420 毫米",&
"A4 210 x 297 毫米",&
"A5 148 x 210 毫米",&
"B4 250 x 354 毫米",&
"B5 182 x 257 毫米",&
"210 x 280 毫米",&
"默认纸张大小"}
end type

type st_3 from statictext within w_print_setup
int X=201
int Y=604
int Width=1486
int Height=76
boolean Enabled=false
string Text="请键入页码和或用逗号分隔的面码范围（例如：1,3,4-12）。"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type sle_y from singlelineedit within w_print_setup
int X=722
int Y=508
int Width=1079
int Height=76
int TabOrder=100
boolean Enabled=false
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_print_setup
int X=78
int Y=728
int Width=229
int Height=56
boolean Enabled=false
string Text="份数(&C):"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_print_setup
int X=713
int Y=732
int Width=229
int Height=56
boolean Enabled=false
string Text="打印(&R):"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type ddlb_dy from dropdownlistbox within w_print_setup
int X=951
int Y=724
int Width=855
int Height=308
int TabOrder=120
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
string Item[]={"所选页面",&
"奇数页",&
"偶数页"}
end type

type em_fs from editmask within w_print_setup
int X=315
int Y=720
int Width=247
int Height=76
int TabOrder=110
BorderStyle BorderStyle=StyleLowered!
string Mask="####"
boolean Spin=true
double Increment=1
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type rb_fw_y from radiobutton within w_print_setup
int X=494
int Y=508
int Width=247
int Height=76
int TabOrder=90
string Text="页(&G)"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;sle_y.enabled=true
end event

type rb_fw_qb from radiobutton within w_print_setup
int X=110
int Y=508
int Width=302
int Height=76
int TabOrder=80
string Text="全部(&A)"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;sle_y.enabled=false
end event

type cb_3 from commandbutton within w_print_setup
int X=334
int Y=908
int Width=439
int Height=88
int TabOrder=130
string Text="打印机设置(&S)"
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;printsetup()
end event

type cb_2 from commandbutton within w_print_setup
int X=1545
int Y=908
int Width=325
int Height=88
int TabOrder=160
string Text="取消(&C)"
boolean Cancel=true
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within w_print_setup
int X=1179
int Y=908
int Width=325
int Height=88
int TabOrder=150
string Text="确认(&O)"
boolean Default=true
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

event clicked;//long job
wf_save()
idw_dw.print()
//job=printopen()
//printsend(job,char(27)+"x2"+char(27)+"U2")
//printdatawindow(job,idw_dw)
close(parent)
end event

type gb_3 from groupbox within w_print_setup
int X=905
int Y=28
int Width=965
int Height=376
string Text="页边距"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type gb_2 from groupbox within w_print_setup
int X=46
int Y=224
int Width=837
int Height=176
string Text="方向"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_print_setup
int X=46
int Y=28
int Width=837
int Height=196
string Text="纸张大小"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type gb_14 from groupbox within w_print_setup
int X=41
int Y=420
int Width=1829
int Height=440
string Text="范围"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

