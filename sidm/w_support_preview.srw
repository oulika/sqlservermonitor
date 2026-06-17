forward
global type w_support_preview from Window
end type
type st_2 from statictext within w_support_preview
end type
type ddlb_zzdx from dropdownlistbox within w_support_preview
end type
type cb_6 from commandbutton within w_support_preview
end type
type cb_5 from commandbutton within w_support_preview
end type
type cb_4 from commandbutton within w_support_preview
end type
type cb_3 from commandbutton within w_support_preview
end type
type st_1 from statictext within w_support_preview
end type
type ddlb_zoom from dropdownlistbox within w_support_preview
end type
type cb_2 from commandbutton within w_support_preview
end type
type cb_1 from commandbutton within w_support_preview
end type
type dw_1 from datawindow within w_support_preview
end type
end forward

global type w_support_preview from Window
int X=0
int Y=0
int Width=3657
int Height=2408
boolean TitleBar=true
string Title="打印预览窗口"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
WindowState WindowState=maximized!
WindowType WindowType=popup!
st_2 st_2
ddlb_zzdx ddlb_zzdx
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
st_1 st_1
ddlb_zoom ddlb_zoom
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_support_preview w_support_preview

type variables
datawindow idw_dw
end variables

on w_support_preview.create
this.st_2=create st_2
this.ddlb_zzdx=create ddlb_zzdx
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.st_1=create st_1
this.ddlb_zoom=create ddlb_zoom
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.st_2,&
this.ddlb_zzdx,&
this.cb_6,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.st_1,&
this.ddlb_zoom,&
this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_support_preview.destroy
destroy(this.st_2)
destroy(this.ddlb_zzdx)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.ddlb_zoom)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;gf_center_window (this)
idw_dw=message.powerobjectparm
dw_1.dataobject=idw_dw.dataobject
//dw_1.settransobject ( sqlca )

idw_dw.sharedata(dw_1)


dw_1.Modify("DataWindow.Print.Preview=Yes")
dw_1.Modify("DataWindow.Print.Preview.buttons=Yes")
dw_1.Modify("DataWindow.Print.Preview.Rulers=Yes")
dw_1.Modify("DataWindow.Print.Preview.Zoom='100'")
ddlb_zoom.text='100%'

dw_1.Modify("DataWindow.Print.Paper.Size='"+idw_dw.Describe("DataWindow.Print.Paper.Size")+"'")
dw_1.Modify("DataWindow.Print.Paper.RangeInclude='"+idw_dw.Describe("DataWindow.Print.Paper.RangeInclude")+"'")
dw_1.Modify("DataWindow.Print.Copies='"+idw_dw.Describe("DataWindow.Print.Copies")+"'")
dw_1.Modify("DataWindow.Print.Margin.Top='"+idw_dw.Describe("DataWindow.Print.Margin.Top")+"'")
dw_1.Modify("DataWindow.Print.Margin.bottom='"+idw_dw.Describe("DataWindow.Print.Margin.bottom")+"'")
dw_1.Modify("DataWindow.Print.Margin.left='"+idw_dw.Describe("DataWindow.Print.Margin.left")+"'")
dw_1.Modify("DataWindow.Print.Margin.right='"+idw_dw.Describe("DataWindow.Print.Margin.right")+"'")
dw_1.Modify("DataWindow.Print.Page.Range='"+idw_dw.Describe("DataWindow.Print.Page.Range")+"'")
dw_1.Modify("DataWindow.Print.color='"+idw_dw.Describe("DataWindow.Print.color")+"'")

CHOOSE CASE idw_dw.Describe("DataWindow.Print.Paper.Size")
	case '0'
		ddlb_zzdx.text='默认纸张大小'	
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
	CASE ELSE 
		ddlb_zzdx.text='A4 210 x 297 毫米'
END CHOOSE


end event

event closequery;idw_dw.Modify("DataWindow.Print.Paper.Size='"+dw_1.Describe("DataWindow.Print.Paper.Size")+"'")
idw_dw.Modify("DataWindow.Print.Paper.RangeInclude='"+dw_1.Describe("DataWindow.Print.Paper.RangeInclude")+"'")
idw_dw.Modify("DataWindow.Print.Copies='"+dw_1.Describe("DataWindow.Print.Copies")+"'")
idw_dw.Modify("DataWindow.Print.Margin.Top='"+dw_1.Describe("DataWindow.Print.Margin.Top")+"'")
idw_dw.Modify("DataWindow.Print.Margin.bottom='"+dw_1.Describe("DataWindow.Print.Margin.bottom")+"'")
idw_dw.Modify("DataWindow.Print.Margin.left='"+dw_1.Describe("DataWindow.Print.Margin.left")+"'")
idw_dw.Modify("DataWindow.Print.Margin.right='"+dw_1.Describe("DataWindow.Print.Margin.right")+"'")
idw_dw.Modify("DataWindow.Print.Page.Range='"+dw_1.Describe("DataWindow.Print.Page.Range")+"'")
idw_dw.Modify("DataWindow.Print.color='"+dw_1.Describe("DataWindow.Print.color")+"'")
end event

type st_2 from statictext within w_support_preview
int X=837
int Y=2188
int Width=325
int Height=76
boolean Enabled=false
string Text="纸张大小:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type ddlb_zzdx from dropdownlistbox within w_support_preview
int X=1161
int Y=2180
int Width=699
int Height=300
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
string Item[]={"A3 297 x 420 毫米",&
"A4 210 x 297 毫米",&
"A5 148 x 210 毫米",&
"B4 250 x 354 毫米",&
"B5 182 x 257 毫米",&
"默认纸张大小"}
end type

event selectionchanged;CHOOSE CASE trim(ddlb_zzdx.text)
	CASE 'A3 297 x 420 毫米'
		dw_1.Modify("DataWindow.Print.Paper.Size='8'")
	CASE 'A4 210 x 297 毫米'
		dw_1.Modify("DataWindow.Print.Paper.Size='9'")
	CASE 'A5 148 x 210 毫米'
		dw_1.Modify("DataWindow.Print.Paper.Size='11'")
	CASE 'B4 250 x 354 毫米'
		dw_1.Modify("DataWindow.Print.Paper.Size='12'")
	CASE 'B5 182 x 257 毫米'
		dw_1.Modify("DataWindow.Print.Paper.Size='13'")
END CHOOSE

messagebox("",dw_1.describe("datawindow.print.margin.right"))
end event

type cb_6 from commandbutton within w_support_preview
int X=489
int Y=2176
int Width=110
int Height=96
int TabOrder=30
string Text=">|"
int TextSize=-12
int Weight=700
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if dw_1.rowcount()>0 then
	dw_1.scrolltorow(dw_1.rowcount())
end if
end event

type cb_5 from commandbutton within w_support_preview
int X=91
int Y=2176
int Width=110
int Height=96
int TabOrder=90
string Text="|<"
int TextSize=-12
int Weight=700
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if dw_1.rowcount()>0 then
	dw_1.scrolltorow(1)
end if
end event

type cb_4 from commandbutton within w_support_preview
int X=201
int Y=2176
int Width=110
int Height=96
int TabOrder=80
string Text="<"
int TextSize=-12
int Weight=700
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dw_1.scrollpriorpage ( )
end event

type cb_3 from commandbutton within w_support_preview
int X=379
int Y=2176
int Width=110
int Height=96
int TabOrder=20
string Text=">"
int TextSize=-12
int Weight=700
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dw_1.scrollnextpage ( )
end event

type st_1 from statictext within w_support_preview
int X=1961
int Y=2188
int Width=325
int Height=76
boolean Enabled=false
string Text="缩放比例:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-12
int Weight=700
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type ddlb_zoom from dropdownlistbox within w_support_preview
int X=2290
int Y=2176
int Width=302
int Height=400
int TabOrder=50
BorderStyle BorderStyle=StyleLowered!
boolean Sorted=false
boolean VScrollBar=true
long TextColor=33554432
string FaceName="System"
FontCharSet FontCharSet=Ansi!
string Item[]={"10%",&
"20%",&
"50%",&
"80%",&
"100%",&
"150%",&
"200%",&
"300%"}
end type

event selectionchanged;//messagebox("",string(integer(mid(ddlb_zoom.text,1,len(ddlb_zoom.text)-1))))
dw_1.Modify("DataWindow.Print.Preview.Zoom='"+string(integer(mid(ddlb_zoom.text,1,len(ddlb_zoom.text)-1)))+"'")
//dw_1.Modify("DataWindow.Print.Preview.Zoom='100'")
end event

type cb_2 from commandbutton within w_support_preview
int X=2702
int Y=2172
int Width=343
int Height=108
int TabOrder=60
string Text="打印(&P)"
int TextSize=-12
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//long job
//job=printopen()
//printsend(job,char(27)+"x2"+char(27)+"U2")
//printdatawindow(job,dw_1)
//printclose(job)
dw_1.print()
end event

type cb_1 from commandbutton within w_support_preview
int X=3163
int Y=2172
int Width=343
int Height=108
int TabOrder=70
string Text="退出(&E)"
boolean Cancel=true
int TextSize=-12
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;close(parent)
end event

type dw_1 from datawindow within w_support_preview
int X=18
int Y=20
int Width=3593
int Height=2116
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

