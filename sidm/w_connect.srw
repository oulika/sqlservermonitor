forward
global type w_connect from window
end type
type cb_exit from commandbutton within w_connect
end type
type cb_save from commandbutton within w_connect
end type
type cb_connect from commandbutton within w_connect
end type
type dw_1 from datawindow within w_connect
end type
end forward

global type w_connect from window
integer x = 823
integer y = 360
integer width = 1915
integer height = 804
boolean titlebar = true
string title = "连接到数据库"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
cb_exit cb_exit
cb_save cb_save
cb_connect cb_connect
dw_1 dw_1
end type
global w_connect w_connect

on w_connect.create
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.cb_connect=create cb_connect
this.dw_1=create dw_1
this.Control[]={this.cb_exit,&
this.cb_save,&
this.cb_connect,&
this.dw_1}
end on

on w_connect.destroy
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.cb_connect)
destroy(this.dw_1)
end on

event open;string ls_dbms, ls_servername, ls_database, ls_logid, ls_logpass, ls_dbparm
int li_autocommit

gf_center_window(this)
ls_dbms = profilestring("sidm.ini", "database","dbms","")
ls_servername = gf_decrypt(profilestring("sidm.ini","database","servername",""), "servername")
ls_database = gf_decrypt(profilestring("sidm.ini","database","database",""), "database")
ls_logid = gf_decrypt(profilestring("sidm.ini","database","logid",""), "logid")
ls_logpass = gf_decrypt(profilestring("sidm.ini","database","logpass",""), "logpass")
li_autocommit = integer(profilestring("sidm.ini","database","autocommit","1"))
ls_dbparm = gf_decrypt(profilestring("sidm.ini","database","dbparm",""), "dbparm")
dw_1.insertrow(0)
dw_1.object.dbms[1] = ls_dbms
dw_1.object.servername[1] = ls_servername
dw_1.object.database[1] = ls_database
dw_1.object.logid[1] = ls_logid
dw_1.object.logpass[1] = ls_logpass
dw_1.object.autocommit[1] = li_autocommit
dw_1.object.dbparm[1] = ls_dbparm

sqlca.dbms = ls_dbms
sqlca.servername = ls_servername
sqlca.database = ls_database
sqlca.logid = ls_logid
sqlca.logpass = ls_logpass
if li_autocommit = 1 then
	sqlca.autocommit = true
else
	sqlca.autocommit = false
end if
sqlca.dbparm = ls_dbparm

end event

type cb_exit from commandbutton within w_connect
integer x = 1129
integer y = 560
integer width = 329
integer height = 108
integer taborder = 40
integer textsize = -12
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "退出(&X)"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_save from commandbutton within w_connect
integer x = 635
integer y = 848
integer width = 329
integer height = 108
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
string text = "保存(&S)"
end type

event clicked;dw_1.accepttext()
this.enabled = false
string ls_dbms, ls_servername, ls_database, ls_logid, ls_logpass, ls_dbparm
int li_autocommit, li_file

if not fileexists('sidm.ini') then
	li_file = fileopen('sidm.ini', linemode!, write!, lockreadwrite!)
	fileclose(li_file)
end if
ls_dbms = dw_1.object.dbms[1]
ls_servername = gf_encrypt(dw_1.object.servername[1], "servername")
ls_database = gf_encrypt(dw_1.object.database[1], "database")
ls_logid = gf_encrypt(dw_1.object.logid[1], "logid")
ls_logpass = gf_encrypt(dw_1.object.logpass[1], "logpass")
li_autocommit = dw_1.object.autocommit[1]
ls_dbparm = gf_encrypt(dw_1.object.dbparm[1], "dbparm")
setprofilestring('sidm.ini','database','dbms',ls_dbms)
setprofilestring('sidm.ini','database','servername',ls_servername)
setprofilestring('sidm.ini','database','database',ls_database)
setprofilestring('sidm.ini','database','logid',ls_logid)
setprofilestring('sidm.ini','database','logpass',ls_logpass)
setprofilestring('sidm.ini','database','autocommit',string(li_autocommit))
setprofilestring('sidm.ini','database','dbparm', ls_dbparm)

end event

type cb_connect from commandbutton within w_connect
integer x = 347
integer y = 560
integer width = 329
integer height = 108
integer taborder = 20
integer textsize = -12
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "连接(&C)"
end type

event clicked;string ls_computername, ls_dbparm
int li_autocommit

this.enabled = false
cb_save.triggerevent(clicked!)
sqlca.dbms = dw_1.object.dbms[1]
sqlca.servername = dw_1.object.servername[1]
sqlca.database = dw_1.object.database[1]
sqlca.logid = dw_1.object.logid[1]
sqlca.logpass = dw_1.object.logpass[1]
ls_dbparm = dw_1.object.dbparm[1]
li_autocommit = dw_1.object.autocommit[1]
if li_autocommit = 1 then
	sqlca.autocommit = true
else
	sqlca.autocommit = false
end if
if upper(sqlca.dbms) = "OLE DB" then 
	sqlca.dbparm = "PROVIDER='SQLOLEDB'," + &
		"PROVIDERSTRING='database=" + sqlca.Database + "'," + &
		"DATASOURCE='" + sqlca.ServerName + "'"
	sqlca.lock = "RC"
end if
if ls_dbparm = "" or isnull(ls_dbparm) then 
	sqlca.dbparm += ",host='" + ls_computername + "',appname='SIDM'"  
else
	sqlca.dbparm += "," + ls_dbparm + ",host='" + ls_computername + "',appname='SIDM'"
end if
connect;
if sqlca.sqlcode<>0 then 
	messagebox("数据库连接失败", sqlca.sqlerrtext)
else
	m_main.m_s.m_connect.enabled = false
end if
close(parent)

end event

type dw_1 from datawindow within w_connect
integer x = 14
integer y = 16
integer width = 1851
integer height = 512
integer taborder = 10
string dataobject = "d_connect"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event editchanged;cb_save.enabled = true

end event

event itemchanged;cb_save.enabled = true

end event

