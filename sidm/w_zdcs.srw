forward
global type w_zdcs from window
end type
type dw_1 from datawindow within w_zdcs
end type
type em_1 from editmask within w_zdcs
end type
type st_1 from statictext within w_zdcs
end type
type cb_2 from commandbutton within w_zdcs
end type
type cb_1 from commandbutton within w_zdcs
end type
end forward

global type w_zdcs from window
integer x = 37
integer y = 36
integer width = 1106
integer height = 560
boolean titlebar = true
string title = "中断测试"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 79741120
dw_1 dw_1
em_1 em_1
st_1 st_1
cb_2 cb_2
cb_1 cb_1
end type
global w_zdcs w_zdcs

type variables
int ii_status = 1
string is_filename

end variables

on w_zdcs.create
this.dw_1=create dw_1
this.em_1=create em_1
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.dw_1,&
this.em_1,&
this.st_1,&
this.cb_2,&
this.cb_1}
end on

on w_zdcs.destroy
destroy(this.dw_1)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;em_1.text = profilestring("sidm.ini","other","filename","")
gf_center_window(this)

end event

event timer;datetime ldt_today
int li_file
if not gf_isconnect() then
	li_file = fileopen(is_filename, linemode!, write!, shared!, append!)
	if ii_status = 1 then
		disconnect;
		filewrite(li_file, string(datetime(today(), now()), 'yyyy.mm.dd hh:mm:ss fff断开与数据库的连接!'))
		m_main.m_s.m_connect.enabled = true
	end if
	if gf_connect() then
		ii_status = 1
		filewrite(li_file, string(datetime(today(), now()), 'yyyy.mm.dd hh:mm:ss fff成功与数据库重新连接!'))
	else
		ii_status = 0
		filewrite(li_file, string(datetime(today(), now()), 'yyyy.mm.dd hh:mm:ss fff与数据库重新连接失败!'))
	end if
	fileclose(li_file)
end if

end event

type dw_1 from datawindow within w_zdcs
boolean visible = false
integer x = 32
integer y = 52
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type em_1 from editmask within w_zdcs
integer x = 407
integer y = 128
integer width = 485
integer height = 88
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
end type

type st_1 from statictext within w_zdcs
integer x = 151
integer y = 136
integer width = 251
integer height = 76
integer textsize = -12
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "保存到:"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_zdcs
integer x = 658
integer y = 620
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_1 from commandbutton within w_zdcs
integer x = 370
integer y = 284
integer width = 334
integer height = 108
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
string text = "确定(&O)"
boolean default = true
end type

event clicked;int li_file
is_filename = em_1.text
li_file = fileopen(is_filename, linemode!, write!, shared!, append!)
if not gf_isconnect() then 
	if gf_connect() then
		filewrite(li_file, string(datetime(today(), now()), 'yyyy.mm.dd hh:mm:ss fff首次成功与数据库连接!'))
	else
		filewrite(li_file, string(datetime(today(), now()), 'yyyy.mm.dd hh:mm:ss fff首次与数据库的连接失败!'))
	end if
else
	filewrite(li_file, string(datetime(today(), now()), 'yyyy.mm.dd hh:mm:ss fff在此这前已成功连接到数据库!'))
end if
fileclose(li_file)
parent.visible = false
m_main.m_s.m_zdcs.enabled = false
setprofilestring("sidm.ini","other","filename",em_1.text)
timer(1)

end event

