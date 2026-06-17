forward
global type w_yszk from Window
end type
type cb_5 from commandbutton within w_yszk
end type
type cb_4 from commandbutton within w_yszk
end type
type dw_13 from datawindow within w_yszk
end type
type cb_3 from commandbutton within w_yszk
end type
type dw_12 from datawindow within w_yszk
end type
type dw_11 from datawindow within w_yszk
end type
type dw_10 from datawindow within w_yszk
end type
type dw_3 from datawindow within w_yszk
end type
type dw_2 from datawindow within w_yszk
end type
type dw_1 from datawindow within w_yszk
end type
type dw_9 from datawindow within w_yszk
end type
type dw_8 from datawindow within w_yszk
end type
type dw_7 from datawindow within w_yszk
end type
type dw_6 from datawindow within w_yszk
end type
type dw_5 from datawindow within w_yszk
end type
type dw_4 from datawindow within w_yszk
end type
type cb_2 from commandbutton within w_yszk
end type
type cb_1 from commandbutton within w_yszk
end type
type st_sour from statictext within w_yszk
end type
type st_desc from statictext within w_yszk
end type
type lv_1 from listview within w_yszk
end type
type tv_1 from treeview within w_yszk
end type
end forward

global type w_yszk from Window
int X=82
int Y=236
int Width=3506
int Height=1908
boolean TitleBar=true
string Title="医生转科处理"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
WindowType WindowType=popup!
cb_5 cb_5
cb_4 cb_4
dw_13 dw_13
cb_3 cb_3
dw_12 dw_12
dw_11 dw_11
dw_10 dw_10
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
dw_9 dw_9
dw_8 dw_8
dw_7 dw_7
dw_6 dw_6
dw_5 dw_5
dw_4 dw_4
cb_2 cb_2
cb_1 cb_1
st_sour st_sour
st_desc st_desc
lv_1 lv_1
tv_1 tv_1
end type
global w_yszk w_yszk

type prototypes
Function long GetFileTime (long lh, ref datetime lc, ref datetime la, ref datetime lw) library "kernel32.dll"
end prototypes

type variables
transaction its_ts[20]


end variables

forward prototypes
public subroutine wf_insertchilditem (integer ai_handle, integer ai_sjks)
public subroutine wf_refresh (integer ai_ksdm)
end prototypes

public subroutine wf_insertchilditem (integer ai_handle, integer ai_sjks);treeviewitem ltv_item1
int li_row, li_sjks
dw_2.setfilter("string(SJKS) = '" + string(ai_sjks) +"'")
dw_2.filter()
for li_row = 1 to dw_2.rowcount()
	ltv_item1.pictureindex = 1
	ltv_item1.selectedpictureindex = 2
	ltv_item1.label = dw_2.object.ksmc[li_row]
	ltv_item1.data = dw_2.object.ksdm[li_row]
	tv_1.insertitemlast(ai_handle, ltv_item1)
next
return

end subroutine

public subroutine wf_refresh (integer ai_ksdm);listviewitem llv_item1
int li_row
string ls_ygxm, ls_ygdm
lv_1.deleteitems()
dw_3.setfilter("string(ksdm) = '" + string(ai_ksdm) + "'")
dw_3.filter()
for li_row = 1 to dw_3.rowcount()
	ls_ygxm = dw_3.object.ygxm[li_row]
	ls_ygdm = dw_3.object.ygdm[li_row]
	llv_item1.label = ls_ygxm + '(' + ls_ygdm +')'
	llv_item1.pictureindex = 1
	lv_1.additem(llv_item1)
next

end subroutine

on w_yszk.create
this.cb_5=create cb_5
this.cb_4=create cb_4
this.dw_13=create dw_13
this.cb_3=create cb_3
this.dw_12=create dw_12
this.dw_11=create dw_11
this.dw_10=create dw_10
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_9=create dw_9
this.dw_8=create dw_8
this.dw_7=create dw_7
this.dw_6=create dw_6
this.dw_5=create dw_5
this.dw_4=create dw_4
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_sour=create st_sour
this.st_desc=create st_desc
this.lv_1=create lv_1
this.tv_1=create tv_1
this.Control[]={this.cb_5,&
this.cb_4,&
this.dw_13,&
this.cb_3,&
this.dw_12,&
this.dw_11,&
this.dw_10,&
this.dw_3,&
this.dw_2,&
this.dw_1,&
this.dw_9,&
this.dw_8,&
this.dw_7,&
this.dw_6,&
this.dw_5,&
this.dw_4,&
this.cb_2,&
this.cb_1,&
this.st_sour,&
this.st_desc,&
this.lv_1,&
this.tv_1}
end on

on w_yszk.destroy
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.dw_13)
destroy(this.cb_3)
destroy(this.dw_12)
destroy(this.dw_11)
destroy(this.dw_10)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_9)
destroy(this.dw_8)
destroy(this.dw_7)
destroy(this.dw_6)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_sour)
destroy(this.st_desc)
destroy(this.lv_1)
destroy(this.tv_1)
end on

event open;//treeviewitem ltv_item1
//int li_handle, li_handle1, li_handle2, li_sjks, li_row
//if not gf_isconnect() then
//	messagebox('提示','尚未连接任务数据库!')
//	close(this)
//	return
//end if
//gf_center_window(this)
//dw_1.settransobject(sqlca)
//dw_2.settransobject(sqlca)
//dw_3.settransobject(sqlca)
//dw_1.retrieve()
//dw_2.retrieve()
//dw_3.retrieve()
////全院科室
//ltv_item1.label = '全院科室'
//ltv_item1.pictureindex = 1
//ltv_item1.selectedpictureindex = 2
//li_handle = tv_1.insertitemlast(0, ltv_item1)
////第一级科室
//dw_1.setfilter("SJKS = 0")
//dw_1.filter()
//for li_row = 1 to dw_1.rowcount()
//	ltv_item1.pictureindex = 1
//	ltv_item1.selectedpictureindex = 2
//	ltv_item1.label = dw_1.object.ksmc[li_row]
//	ltv_item1.data = dw_1.object.ksdm[li_row]
//	li_handle1 = tv_1.insertitemlast(li_handle, ltv_item1)
//	li_sjks = dw_1.object.ksdm[li_row]
//	//第二级科室
//	wf_insertchilditem(li_handle1, li_sjks)
//next
//tv_1.expanditem(li_handle)
//
//lv_1.addcolumn('医生姓名与代码',left!,800)
//lv_1.view = listviewreport!
//
end event

event close;int li_i
for li_i = 1 to 20
	destroy its_ts[li_i]
next	

end event

event timer;cb_2.triggerevent(clicked!)

end event

type cb_5 from commandbutton within w_yszk
int X=46
int Y=1504
int Width=247
int Height=108
int TabOrder=160
string Text="none"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dw_13.insertrow(0)
dw_13.object.ypmc[1] = 'NO'
dw_13.modify("st_1.text = 'NO'")
end event

type cb_4 from commandbutton within w_yszk
int X=1673
int Y=1676
int Width=306
int Height=108
int TabOrder=180
string Text="Sybase"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Profile bshis
int i
string ls_tm1, ls_tm2
long ll_tm1, ll_tm2
SQLCA.DBMS = "ODBC"
SQLCA.AutoCommit = True
SQLCA.DBParm = "ConnectString='DSN=bshis;UID=sa;PWD=;'"

// Profile bsrun
SQLCA.DBMS = "SYC Sybase System 10/11"
SQLCA.Database = "bsrun"
SQLCA.ServerName = "wgyy_syba_server"
SQLCA.LogId = "sa"
SQLCA.AutoCommit = True
SQLCA.DBParm = "Host='wjs-12',AppName='PB6.0'"
disconnect;
connect;
if sqlca.sqlcode <> 0 then goto error
ls_tm1 = string(now(), 'hhmmssfff')
dw_13.settransobject(sqlca)
for i = 1 to 1
	dw_13.retrieve()
next
ls_tm2 = string(now(), 'hhmmssfff')
ll_tm1 = long(mid(ls_tm1, 1, 2))*3600000 + long(mid(ls_tm1, 3, 2))*60000 + long(mid(ls_tm1, 5, 5))
ll_tm2 = long(mid(ls_tm2, 1, 2))*3600000 + long(mid(ls_tm2, 3, 2))*60000 + long(mid(ls_tm2, 5, 5))
messagebox(ls_tm1, ls_tm2 + ";" + string(ll_tm2 - ll_tm1))
return

error:
messagebox("错误", sqlca.sqlerrtext)

end event

type dw_13 from datawindow within w_yszk
int X=201
int Y=912
int Width=1742
int Height=516
int TabOrder=170
string DataObject="d_yk_typk"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type cb_3 from commandbutton within w_yszk
int X=1243
int Y=1680
int Width=279
int Height=108
int TabOrder=190
string Text="ODBC"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Profile bshis
int i
string ls_tm1, ls_tm2
long ll_tm1, ll_tm2
SQLCA.DBMS = "ODBC"
SQLCA.AutoCommit = True
SQLCA.DBParm = "ConnectString='DSN=bshis;UID=sa;PWD=;'"

// Profile bsrun
//SQLCA.DBMS = "SYC Sybase System 10/11"
//SQLCA.Database = "bsrun"
//SQLCA.ServerName = "wgyy_syba_server"
//SQLCA.LogId = "sa"
//SQLCA.AutoCommit = True
//SQLCA.DBParm = "Host='wjs-12',AppName='PB6.0'"
disconnect;
connect;
if sqlca.sqlcode <> 0 then goto error
ls_tm1 = string(now(), 'hhmmssfff')
dw_13.settransobject(sqlca)
for i = 1 to 1
	dw_13.retrieve()
next
ls_tm2 = string(now(), 'hhmmssfff')
ll_tm1 = long(mid(ls_tm1, 1, 2))*3600000 + long(mid(ls_tm1, 3, 2))*60000 + long(mid(ls_tm1, 5, 5))
ll_tm2 = long(mid(ls_tm2, 1, 2))*3600000 + long(mid(ls_tm2, 3, 2))*60000 + long(mid(ls_tm2, 5, 5))
messagebox(ls_tm1, ls_tm2 + ";" + string(ll_tm2 - ll_tm1))
return

error:
messagebox("错误", sqlca.sqlerrtext)

end event

type dw_12 from datawindow within w_yszk
int X=2738
int Y=1016
int Width=841
int Height=432
int TabOrder=20
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_11 from datawindow within w_yszk
int X=1838
int Y=1020
int Width=841
int Height=432
int TabOrder=30
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_10 from datawindow within w_yszk
int X=923
int Y=1040
int Width=841
int Height=432
int TabOrder=90
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_3 from datawindow within w_yszk
int X=1833
int Y=32
int Width=841
int Height=432
int TabOrder=60
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_2 from datawindow within w_yszk
int X=946
int Y=36
int Width=841
int Height=432
int TabOrder=70
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_1 from datawindow within w_yszk
int X=37
int Y=36
int Width=841
int Height=432
int TabOrder=120
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_9 from datawindow within w_yszk
int X=18
int Y=1020
int Width=841
int Height=432
int TabOrder=100
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_8 from datawindow within w_yszk
int X=2757
int Y=508
int Width=841
int Height=432
int TabOrder=10
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_7 from datawindow within w_yszk
int X=1883
int Y=508
int Width=841
int Height=432
int TabOrder=50
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_6 from datawindow within w_yszk
int X=928
int Y=544
int Width=841
int Height=432
int TabOrder=80
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_5 from datawindow within w_yszk
int X=27
int Y=520
int Width=841
int Height=432
int TabOrder=40
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_4 from datawindow within w_yszk
int X=2743
int Y=24
int Width=841
int Height=432
int TabOrder=110
string DataObject="d_yzsr_cq"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type cb_2 from commandbutton within w_yszk
int X=1573
int Y=1460
int Width=247
int Height=108
int TabOrder=140
string Text="none"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//datetime ldt_1, ldt_2, ldt_3
//int li_file
//li_file = fileopen("liq.pbl")
//getfiletime(li_file, ref ldt_1, ref ldt_2, ref ldt_3)
//messagebox(string(li_file), string(ldt_1))
//fileclose(li_file)
dw_1.retrieve(3300, 0)
dw_2.retrieve(3301, 0)
dw_3.retrieve(3302, 0)
dw_4.retrieve(3303, 0)
dw_5.retrieve(3304, 0)
dw_6.retrieve(3307, 0)
dw_7.retrieve(3308, 0)
dw_8.retrieve(3309, 0)
dw_9.retrieve(3310, 0)
dw_10.retrieve(3311, 0)
dw_11.retrieve(3313, 0)
dw_12.retrieve(3314, 0)
timer(1)


end event

type cb_1 from commandbutton within w_yszk
int X=1207
int Y=1452
int Width=247
int Height=108
int TabOrder=130
string Text="none"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;int li_i
for li_i = 1 to 20
	its_ts[li_i] = create transaction
	its_ts[li_i].DBMS = "SYC Sybase System 10/11"
//	its_ts[li_i].DBMS = "MSS Microsoft SQL Server 6.x"

	its_ts[li_i].Database = "bsrun"
	its_ts[li_i].ServerName = "sybase"
	its_ts[li_i].LogId = "sa"
	its_ts[li_i].AutoCommit = False
	its_ts[li_i].DBParm = "appname='(" + string(li_i) + ")'"
	connect using its_ts[li_i];
	if its_ts[li_i].sqlcode <> 0 then goto error
next
dw_1.settransobject(its_ts[1])
dw_2.settransobject(its_ts[2])
dw_3.settransobject(its_ts[3])
dw_4.settransobject(its_ts[4])
dw_5.settransobject(its_ts[5])
dw_6.settransobject(its_ts[6])
dw_7.settransobject(its_ts[7])
dw_8.settransobject(its_ts[8])
dw_9.settransobject(its_ts[9])
dw_10.settransobject(its_ts[10])
dw_11.settransobject(its_ts[11])
dw_12.settransobject(its_ts[12])

return

error:
messagebox(string(li_i), its_ts[li_i].sqlerrtext)
for li_i = 1 to 20
	destroy its_ts[li_i]
next	
end event

type st_sour from statictext within w_yszk
int X=210
int Y=1660
int Width=247
int Height=76
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="sour"
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

type st_desc from statictext within w_yszk
int X=718
int Y=1664
int Width=270
int Height=76
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="desc"
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

type lv_1 from listview within w_yszk
int X=1330
int Y=1516
int Width=2331
int Height=1576
int TabOrder=150
boolean DragAuto=true
BorderStyle BorderStyle=StyleLowered!
ListViewView View=ListViewReport!
string LargePictureName[]={"Custom076!"}
int LargePictureWidth=16
int LargePictureHeight=16
long LargePictureMaskColor=553648127
string SmallPictureName[]={"Custom076!"}
int SmallPictureWidth=16
int SmallPictureHeight=16
long SmallPictureMaskColor=553648127
long StatePictureMaskColor=553648127
long TextColor=33554432
int TextSize=-12
int Weight=400
string FaceName="System"
FontCharSet FontCharSet=GB2312CharSet!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event dragleave;treeviewitem ltv_item1
tv_1.getitem(tv_1.finditem(currenttreeitem!, 0), ltv_item1)
st_sour.text = ltv_item1.label
end event

type tv_1 from treeview within w_yszk
int X=128
int Y=1532
int Width=1038
int Height=1592
int TabOrder=160
BorderStyle BorderStyle=StyleLowered!
boolean LinesAtRoot=true
string PictureName[]={"Custom039!",&
"Custom050!"}
long PictureMaskColor=553648127
long StatePictureMaskColor=536870912
long TextColor=33554432
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event selectionchanged;int li_ksdm
treeviewitem ltv_item1
this.getitem(newhandle, ltv_item1)
li_ksdm = integer(ltv_item1.data)
wf_refresh(li_ksdm)

end event

event dragwithin;int li_x, li_y
treeviewitem ltv_item1
this.getitem(handle, ltv_item1)
if ltv_item1.level = 2 then this.expanditem(handle)
st_desc.text = ltv_item1.label

end event

