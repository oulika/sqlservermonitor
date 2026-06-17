forward
global type w_link_oracle_new from window
end type
type st_ver from statictext within w_link_oracle_new
end type
type dw_pre from datawindow within w_link_oracle_new
end type
type dw_sql from datawindow within w_link_oracle_new
end type
type cbx_zdjs from checkbox within w_link_oracle_new
end type
type em_ms from editmask within w_link_oracle_new
end type
type st_tm from statictext within w_link_oracle_new
end type
type st_m from statictext within w_link_oracle_new
end type
type em_sxpl from editmask within w_link_oracle_new
end type
type st_sxpl from statictext within w_link_oracle_new
end type
type st_ms from statictext within w_link_oracle_new
end type
type dw_main from datawindow within w_link_oracle_new
end type
type dw_his from datawindow within w_link_oracle_new
end type
end forward

global type w_link_oracle_new from window
integer width = 3680
integer height = 1980
boolean titlebar = true
string title = "会话"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 80269524
event ue_write ( string as_now )
event ue_write_simple ( boolean ab_first,  integer ai_row,  string as_sql )
event ue_thread ( )
st_ver st_ver
dw_pre dw_pre
dw_sql dw_sql
cbx_zdjs cbx_zdjs
em_ms em_ms
st_tm st_tm
st_m st_m
em_sxpl em_sxpl
st_sxpl st_sxpl
st_ms st_ms
dw_main dw_main
dw_his dw_his
end type
global w_link_oracle_new w_link_oracle_new

type variables
string      is_sql, is_title, is_errtext
boolean     ib_connect = true
boolean     ib_test = false
integer     ii_type = 1, ii_asc, ii_level, ii_temp
nvo_thread  uo_thread
nvo_argv    uo_argv
long        il_zh

end variables

forward prototypes
public subroutine wf_filewrite (string as_text)
public function string wf_getsql (integer ai_spid)
public subroutine wf_setsql (integer ai_type)
public subroutine wf_filewrite_xls ()
public subroutine wf_set_tree (integer ai_fathid)
public function string wf_fill (string as_cont, integer ai_len, integer ai_lr)
end prototypes

event ue_write(string as_now);string ls_cn, ls_pn, ls_dn, ls_tm, ls_spid, ls_blocked, ls_un, ls_status, ls_cmd, ls_io, ls_cpu
int li_count, li_spid
string ls_sql, ls_ipaddr
datetime ldt_n

for li_count = 1 to dw_main.rowcount()
	if not isnull(dw_main.object.cn[li_count]) then 
		ls_cn = trim(dw_main.object.cn[li_count])
	else
		ls_cn = ''
	end if
	ls_cn += space(10 - len(ls_cn))
	if not isnull(dw_main.object.dn[li_count]) then 
		ls_dn = trim(dw_main.object.dn[li_count])
	else
		ls_dn = ''
	end if
	if ls_dn = '' then exit
	ls_dn += space(8 - len(ls_dn))
	if not isnull(dw_main.object.pn[li_count]) then 
		ls_pn = left(trim(dw_main.object.pn[li_count]), 16)
	else
		ls_pn = ''
	end if
	ls_pn += space(16 - len(ls_pn))
	if not isnull(dw_main.object.tm[li_count]) then 
		ls_tm = trim(string(dw_main.object.tm[li_count]))
	else
		ls_tm = ''
	end if
	ls_tm = space(5 - len(ls_tm)) + ls_tm
	if not isnull(dw_main.object.spid[li_count]) then 
		ls_spid = trim(string(dw_main.object.spid[li_count]))
	else
		ls_spid = ''
	end if
	ls_spid = space(3 - len(ls_spid)) + ls_spid
	if not isnull(dw_main.object.blocked[li_count]) then 
		ls_blocked = trim(string(dw_main.object.blocked[li_count]))
	else
		ls_blocked = ''
	end if
	if ls_blocked = '0' then ls_blocked = ''
	ls_blocked = space(3 - len(ls_blocked)) + ls_blocked
	//取用户	
	if not isnull(dw_main.object.un[li_count]) then
		ls_un = dw_main.object.un[li_count]
	else
		ls_un = ''
	end if
	ls_un = ls_un + space(6 - len(ls_un)) 
	//取命令	
	if not isnull(dw_main.object.cmd[li_count]) then
		ls_cmd = dw_main.object.cmd[li_count]
	else
		ls_cmd = ''
	end if
	ls_cmd = ls_cmd + space(16 - len(ls_cmd)) 
	//取Cpu	
	if not isnull(dw_main.object.cpu[li_count]) then
		ls_cpu = string(dw_main.object.cpu[li_count])
	else
		ls_cpu = ''
	end if
	ls_cpu = space(4 - len(ls_cpu)) + ls_cpu
	//取io	
	if not isnull(dw_main.object.physical_io[li_count]) then
		ls_io = string(dw_main.object.physical_io[li_count])
	else
		ls_io = ''
	end if
	ls_io = space(5 - len(ls_io)) + ls_io
	//取进程状态	
	if not isnull(dw_main.object.status[li_count]) then
		ls_status = dw_main.object.status[li_count]
	else
		ls_status = ''
	end if
	ls_status = ls_status + space(10 - len(ls_status)) 
	if pos(upper(sqlca.dbms), "SYBASE") > 0 then
		if not isnull(dw_main.object.ipaddr[li_count]) then
			ls_ipaddr = dw_main.object.ipaddr[li_count]
		else
			ls_ipaddr = ""
		end if
		wf_filewrite(as_now + '机器【' + ls_cn + '】用户' + ls_un + '连到' + ls_dn + '上的应用 ' + ls_pn + &
			'进程' + ls_spid + '#已等待进程' + ls_blocked + '#' + ls_tm + '秒 命令' + ls_cmd + &
			'Cpu' + ls_cpu + 'io' + ls_io + '状态' + ls_status + "IP地址" + ls_ipaddr)
	else
		wf_filewrite(as_now + '机器【' + ls_cn + '】用户' + ls_un + '连到' + ls_dn + '上的应用 ' + ls_pn + &
			'进程' + ls_spid + '#已等待进程' + ls_blocked + '#' + ls_tm + '秒 命令' + ls_cmd + &
			'Cpu' + ls_cpu + 'io' + ls_io + '状态' + ls_status)
	end if
	//取阻塞者的SQL语句 Richard 2004.03.09
	if dw_main.object.blocked[li_count] = 0 then
		li_spid = dw_main.object.spid[li_count]
		ls_dn   = dw_main.object.dn[li_count]
		if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then return
		if pos(upper(sqlca.dbms), "SYBASE") = 0 and pos(upper(sqlca.dbms), "SYC") = 0 then
			dw_sql.retrieve(li_spid)
			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
		else
			ls_sql = wf_getsql(li_spid)
		end if
		wf_filewrite("{")
		wf_filewrite(ls_sql + '}')
	end if
next
wf_filewrite("")

end event

event ue_write_simple(boolean ab_first, integer ai_row, string as_sql);string ls_cn, ls_pn, ls_dn, ls_tm, ls_spid, ls_blocked, ls_un, ls_status, ls_cmd, ls_io, ls_cpu
string ls_sql, ls_ipaddr, ls_lb

if not isnull(dw_main.object.cn[ai_row]) then 
	ls_cn = trim(dw_main.object.cn[ai_row])
else
	ls_cn = ''
end if
ls_cn += space(10 - len(ls_cn))
if not isnull(dw_main.object.dn[ai_row]) then 
	ls_dn = trim(dw_main.object.dn[ai_row])
else
	ls_dn = ''
end if
ls_dn += space(8 - len(ls_dn))
if not isnull(dw_main.object.pn[ai_row]) then 
	ls_pn = left(trim(dw_main.object.pn[ai_row]), 16)
else
	ls_pn = ''
end if
ls_pn += space(16 - len(ls_pn))
if not isnull(dw_main.object.tm[ai_row]) then 
	ls_tm = trim(string(dw_main.object.tm[ai_row]))
else
	ls_tm = ''
end if
ls_tm = space(5 - len(ls_tm)) + ls_tm
if not isnull(dw_main.object.spid[ai_row]) then 
	ls_spid = trim(string(dw_main.object.spid[ai_row]))
else
	ls_spid = ''
end if
ls_spid = space(3 - len(ls_spid)) + ls_spid
if not isnull(dw_main.object.blocked[ai_row]) then 
	ls_blocked = trim(string(dw_main.object.blocked[ai_row]))
else
	ls_blocked = ''
end if
if ls_blocked = '0' then ls_blocked = ''
ls_blocked = space(3 - len(ls_blocked)) + ls_blocked
//取用户	
if not isnull(dw_main.object.un[ai_row]) then
	ls_un = dw_main.object.un[ai_row]
else
	ls_un = ''
end if
ls_un = ls_un + space(6 - len(ls_un)) 
//取命令	
if not isnull(dw_main.object.cmd[ai_row]) then
	ls_cmd = dw_main.object.cmd[ai_row]
else
	ls_cmd = ''
end if
ls_cmd = ls_cmd + space(16 - len(ls_cmd)) 
//取Cpu	
if not isnull(dw_main.object.cpu[ai_row]) then
	ls_cpu = string(dw_main.object.cpu[ai_row])
else
	ls_cpu = ''
end if
ls_cpu = space(4 - len(ls_cpu)) + ls_cpu
//取io	
if not isnull(dw_main.object.physical_io[ai_row]) then
	ls_io = string(dw_main.object.physical_io[ai_row])
else
	ls_io = ''
end if
ls_io = space(5 - len(ls_io)) + ls_io
//取进程状态	
if not isnull(dw_main.object.status[ai_row]) then
	ls_status = dw_main.object.status[ai_row]
else
	ls_status = ''
end if
ls_status = ls_status + space(10 - len(ls_status)) 
if pos(upper(sqlca.dbms), 'SYBASE') > 0 or pos(upper(sqlca.dbms), 'SYC') > 0  then
	if not isnull(dw_main.object.ipaddr[ai_row]) then
		ls_ipaddr = dw_main.object.ipaddr[ai_row]
	else
		ls_ipaddr = ''
	end if
end if
if ab_first then
	ls_lb = '阻塞者  '
else
	ls_lb = '被阻塞者'
end if
wf_filewrite(ls_lb + ' 计算机:' + ls_cn + '用户:' + ls_un + 'spid:' + ls_spid + ' 数据库:' + ls_dn + '应用程序:' + ls_pn + &
	'Cpu:' + ls_cpu + 'io:' + ls_io + '状态:' + ls_status + 'IP地址:' + ls_ipaddr + ' SQL命令:')
wf_filewrite(as_sql + '~r~n')

end event

event ue_thread();wf_filewrite_xls()

end event

public subroutine wf_filewrite (string as_text);int li_file
datetime ldt_n
string ls_date, ls_path, ls_fn

select sysdate into :ldt_n from dual using SQLCA;
if sqlca.sqlcode <> 0 then 
	ls_date = string(today(), "yyyy.mm.dd") 
else
	ls_date = string(ldt_n, "yyyy.mm.dd")
end if
ls_path = gs_apppath + "\log\"
ls_fn   = ls_path + ls_date + "_" + sqlca.servername + ".txt"
li_file = fileopen(ls_fn, linemode!, write!, lockwrite!, append!)
if li_file < 0 then messagebox("", li_file)
filewrite(li_file, as_text)
fileclose(li_file)

end subroutine

public function string wf_getsql (integer ai_spid);int li_file, li_pos1, li_pos2
string ls_sql

li_file = fileopen("0a.sql", linemode!, write!, lockwrite!, replace!)
filewrite(li_file, "dbcc traceon(3604)")
filewrite(li_file, "go")
filewrite(li_file, "dbcc sqltext(" + string(ai_spid) + ")")
filewrite(li_file, "go")
filewrite(li_file, "dbcc traceoff")
filewrite(li_file, "go")
fileclose(li_file)
gf_run("isql -S " + sqlca.servername + " -U " + sqlca.logid + " -P " + &
	sqlca.logpass + " -i 0a.sql -o 0b.txt")
li_file = fileopen("0b.txt", streammode!, read!)
fileread(li_file, ls_sql)
fileclose(li_file)
li_pos1 = pos(ls_sql, "SQL Text:")
li_pos2 = pos(ls_sql, "DBCC", li_pos1)
ls_sql = mid(ls_sql, li_pos1 + 10, li_pos2 - li_pos1 - 10)
return ls_sql

end function

public subroutine wf_setsql (integer ai_type);string ls_sql 

timer(0)
ii_type = ai_type
choose case ii_type
	case 1 //锁/被锁
		if dw_main.dataobject <> "d_link_sqlserver_2005" then
			ls_sql = is_sql + " and a.blocked > 0 union all " + is_sql + " and a.spid in (select spid from master.dbo.sysprocesses b(nolock) where b.blocked > 0)"
			dw_main.setsqlselect(ls_sql)
		end if
	case 2 //活动
		ls_sql = is_sql + " and a.status not like '%sleeping%' and a.status not like '%recv sleep%' and a.status not like '%background%' and a.program_name not like 'Spy%'"
		dw_main.setsqlselect(ls_sql)
	case 3 //所有
		dw_main.setsqlselect(is_sql)
end choose
timer(integer(em_sxpl.text))

end subroutine

public subroutine wf_filewrite_xls ();datetime  ldt_n
string    ls_date, ls_datetime, ls_path, ls_fn, ls_mb, ls_tree, ls_sql
oleobject lole_xls
int       li_rtn, li_row, li_sid, li_bsid, li_han, li_pos
boolean   lb_close, lb_first
string ls_t

//ls_t = string(now(), "hh:mm:ss:fff")
ldt_n = gf_server_date()
ls_date = string(ldt_n, "yyyy.mm.dd")
ls_datetime = string(ldt_n, "hh:mm:ss")
ls_path = GetCurrentDirectory() + "\log\"
ls_fn   = ls_path + ls_date + "_" + sqlca.servername + ".xlsx"
ls_mb   = ls_path + "日志模板.xlsx"
lole_xls = create oleobject
li_rtn   = lole_xls.connecttonewobject("Excel.Application")
if li_rtn <> 0 then
	is_errtext = "无法连接到Excel.Application组件服务"
	goto p_error
end if
if not fileexists(ls_fn) then //无当日文件
	lole_xls.Workbooks.Open(ls_mb)
	lole_xls.ActiveWorkbook.SaveAs(ls_fn)
else
	lole_xls.Workbooks.Open(ls_fn)
end if
lb_close = true //文件已打开，需关闭
li_han = 2
//计算未使用的下一行
do while true
	li_sid = integer(lole_xls.ActiveSheet.cells(li_han, 4).value) //会话
	if li_sid = 0 or isnull(li_sid) then 
		exit
	else
		li_han ++
	end if
loop
//if li_han <> 2 then li_han ++ //空行
lb_first = true
for li_row = 1 to dw_main.rowcount()
	ls_tree = dw_main.object.tree[li_row]
	if len(ls_tree) > 0 then //只记录锁或被锁的进程
		if lb_first then 
			lole_xls.ActiveSheet.cells(li_han, 1).value = ls_datetime
			lb_first = false
		end if
		lole_xls.ActiveSheet.cells(li_han, 2).value = dw_main.object.tree[li_row]
		lole_xls.ActiveSheet.cells(li_han, 3).value = dw_main.object.sbz[li_row] //锁标志
		lole_xls.ActiveSheet.cells(li_han, 4).value = dw_main.object.会话[li_row]
		lole_xls.ActiveSheet.cells(li_han, 5).value = dw_main.object.锁会话[li_row]
		lole_xls.ActiveSheet.cells(li_han, 6).value = dw_main.object.主机名[li_row]
		lole_xls.ActiveSheet.cells(li_han, 7).value = dw_main.object.ip地址[li_row]
		lole_xls.ActiveSheet.cells(li_han, 8).value = dw_main.object.应用名[li_row]
		lole_xls.ActiveSheet.cells(li_han, 9).value = dw_main.object.数据库[li_row]
		lole_xls.ActiveSheet.cells(li_han, 10).value = dw_main.object.会话状态[li_row]
		lole_xls.ActiveSheet.cells(li_han, 11).value = dw_main.object.cpu时间[li_row]
		lole_xls.ActiveSheet.cells(li_han, 12).value = dw_main.object.等待时间[li_row]
		lole_xls.ActiveSheet.cells(li_han, 13).value = dw_main.object.等待类型[li_row]
		lole_xls.ActiveSheet.cells(li_han, 14).value = dw_main.object.等待的资源[li_row]
		ls_sql = dw_main.object.sql语句[li_row]; 
		li_pos = pos(ls_sql, char(13) + char(10))
		do while li_pos > 0
			ls_sql = gf_replace(ls_sql, char(13) + char(10), ""); 
			li_pos = pos(ls_sql, char(13) + char(10))
		loop
		lole_xls.ActiveSheet.cells(li_han, 15).value = ls_sql
		lole_xls.ActiveSheet.cells(li_han, 16).value = dw_main.object.zd[li_row]
		lole_xls.ActiveSheet.cells(li_han, 17).value = dw_main.object.登录名[li_row]
		li_han ++
	end if
next
if isvalid(lole_xls) then 
	if lb_close then lole_xls.activeworkbook.close(true)
	lole_xls.Application.quit			
	lole_xls.DisConnectObject()
	destroy lole_xls
end if
//messagebox(ls_t, string(now(), "hh:mm:ss:fff"))
return 

p_error:
if isvalid(lole_xls) then 
	try
		if lb_close then lole_xls.activeworkbook.close(false)
		lole_xls.Application.quit			
		lole_xls.DisConnectObject()
		destroy lole_xls
	catch (runtimeerror e)
		is_errtext += "," + e.getmessage()
	end try
end if
messagebox("提示", is_errtext)


end subroutine

public subroutine wf_set_tree (integer ai_fathid);//递归调用
//传入父会话所在行，先遍历兄弟会话，再遍历兄弟的子会话
string  ls_tree 
integer li_me, li_bsid, li_fath, li_brot, li_row, li_brotid[]
boolean lb_first = true

ls_tree = char(ii_asc)
ii_level ++
li_fath = dw_main.find("会话 = " + string(ai_fathid), 1, dw_main.rowcount())
li_bsid = dw_main.object.会话[li_fath]
li_me = dw_main.find("锁会话 = " + string(li_bsid) + " and tree = ''", li_fath + 1, dw_main.rowcount())
ii_temp ++
//dw_main.saveas("c:\" + string(ii_temp) + ".xls", excel!, true)
if li_me > 0 then 
	if dw_main.object.tree[li_fath] = "" then dw_main.object.tree[li_fath] = ls_tree
	do while true //遍历兄弟会话
		if dw_main.object.tree[li_me] = "" then dw_main.object.tree[li_me] = dw_main.object.tree[li_fath] + ls_tree
		if isnull(dw_main.object.锁会话[li_me - 1]) or dw_main.object.锁会话[li_me - 1] <> li_bsid then //上一行会话的锁与当前会话的锁不同
			if lb_first then //第一次移动到父亲之后
				dw_main.rowscopy(li_me, li_me, primary!, dw_main, li_fath + 1, primary!) 
				dw_main.deleterow(li_me + 1)
				li_me = li_fath + 1
				lb_first = false
			else //之后移动到兄弟之后
				dw_main.rowscopy(li_me, li_me, primary!, dw_main, li_brot + 1, primary!) //
				dw_main.deleterow(li_me + 1)
				li_me = li_brot + 1
			end if
		end if
		ii_temp ++
		//dw_main.saveas("c:\" + string(ii_temp) + ".xls", excel!, true)
		li_brot = li_me
		li_brotid[upperbound(li_brotid) + 1] = dw_main.object.会话[li_brot]
		if li_me = dw_main.rowcount() then exit
		li_me = dw_main.find("锁会话 = " + string(li_bsid) + " and tree = ''", li_me + 1, dw_main.rowcount())
		if li_me = 0 then exit
	loop
	for li_row = 1 to upperbound(li_brotid) //遍历兄弟的子会话
		wf_set_tree(li_brotid[li_row]) 
	next
	if ii_level = 1 then ii_asc ++ 
end if
ii_level -- 

end subroutine

public function string wf_fill (string as_cont, integer ai_len, integer ai_lr);if isnull(as_cont) then as_cont = ""

if ai_lr = 1 then 
	return left(left(as_cont, ai_len) + space(ai_len), ai_len)
else
	return right(space(ai_len) + right(as_cont, ai_len), ai_len)
end if

end function

on w_link_oracle_new.create
this.st_ver=create st_ver
this.dw_pre=create dw_pre
this.dw_sql=create dw_sql
this.cbx_zdjs=create cbx_zdjs
this.em_ms=create em_ms
this.st_tm=create st_tm
this.st_m=create st_m
this.em_sxpl=create em_sxpl
this.st_sxpl=create st_sxpl
this.st_ms=create st_ms
this.dw_main=create dw_main
this.dw_his=create dw_his
this.Control[]={this.st_ver,&
this.dw_pre,&
this.dw_sql,&
this.cbx_zdjs,&
this.em_ms,&
this.st_tm,&
this.st_m,&
this.em_sxpl,&
this.st_sxpl,&
this.st_ms,&
this.dw_main,&
this.dw_his}
end on

on w_link_oracle_new.destroy
destroy(this.st_ver)
destroy(this.dw_pre)
destroy(this.dw_sql)
destroy(this.cbx_zdjs)
destroy(this.em_ms)
destroy(this.st_tm)
destroy(this.st_m)
destroy(this.em_sxpl)
destroy(this.st_sxpl)
destroy(this.st_ms)
destroy(this.dw_main)
destroy(this.dw_his)
end on

event open;if not gf_isconnect_oracle() then
	messagebox('提示','尚未连接数据库!')
	close(this)
	return
end if
wf_filewrite(string(gf_server_date(), 'yyyy.mm.dd hh:mm:ss') + "开始记录" + sqlca.servername + "~r~n")
w_main.title = "Oracle服务(" + sqlca.servername + ")"
is_title = this.title
is_sql = dw_main.getsqlselect()
dw_main.settransobject(sqlca)
dw_sql.settransobject(sqlca)
m_main.m_s.m_proc.enabled = true
m_main.m_s.m_proc.m_o_proc.enabled = true
m_main.m_s.m_proc.m_u_proc.enabled = true
m_main.m_s.m_proc.m_a_proc.enabled = true
//is_prog = profilestring("sidm.ini", "option", "prog", "!@#$") + "%"
dw_main.modify("kill_sql.visible='0'")
dw_pre.modify("kill_sql.visible='0'")
trigger event timer()

end event

event timer;string   ls_sql, ls_sid, ls_temp
long     ll_row, ll_temp, ll_maxzh, ll_find_m, ll_find_pre
datetime ldt_n
boolean  lb_zdhh, lb_first = true

timer(0)
ldt_n = gf_server_date()
st_tm.text = string(ldt_n, "yyyy-mm-dd hh:mm:ss")
if ib_connect then
	select 1 into :ll_temp from dual;
	if sqlca.sqlcode <> 0 then //已断开
		ib_connect = false
		wf_filewrite("在本机时间" + string(today(), "yyyy.mm.dd hh:mm:ss") + "断开与服务器" + sqlca.servername + "的连接~r~n")
		goto p_end
	end if
else
	disconnect;
	connect;
	if sqlca.sqlcode = 0 then //重新连上
		timer(integer(em_sxpl.text))
		wf_filewrite("在" + string(gf_server_date(), "yyyy.mm.dd hh:mm:ss") + "重新连上服务器" + sqlca.servername + "~r~n")
		ib_connect = true
		dw_main.settransobject(sqlca)
		dw_sql.settransobject(sqlca)
	else
		goto p_end
	end if
end if
dw_main.setredraw(false)
dw_pre.setredraw(false)
if dw_main.rowcount() > 0 then 
	dw_pre.reset()
	dw_main.rowscopy(1, dw_main.rowcount(), primary!, dw_pre, 999999, primary!)
end if
dw_main.retrieve()

for ll_row = 1 to dw_main.rowcount()
	//设置时间
	dw_main.object.sysd[ll_row] = string(ldt_n, "hh:mm:ss")
	
	//树形图示
	if dw_main.object.lv[ll_row] <> 1 and dw_main.find("lv = 1", 1, dw_main.rowcount()) > 0 then 
		if ll_row = dw_main.rowcount() then 
			dw_main.object.sid_xs[ll_row] = gf_replace(dw_main.object.sid_xs[ll_row], '├', '└')
		elseif dw_main.object.lv[ll_row] <> dw_main.object.lv[ll_row + 1] then 
			dw_main.object.sid_xs[ll_row] = gf_replace(dw_main.object.sid_xs[ll_row], '├', '└')			
		end if
		dw_main.object.zh[ll_row] = il_zh //设置树组
	else
		if ll_row <> 1 then
			dw_main.insertrow(ll_row)
			ll_row ++
		end if
		il_zh ++
		dw_main.object.zh[ll_row] = il_zh //设置树组
	end if	
	//获取SQL语句
	ls_sql = dw_main.object.gv$sqlarea_sql_text[ll_row]
	if len(ls_sql) > 0 then continue
	ls_sid = dw_main.object.sid[ll_row]
//	dw_sql.retrieve(integer(ls_sid))
	ls_sql = ""
	for ll_temp = 1 to dw_sql.rowcount()
		ls_sql = ls_sql + dw_sql.object.sql[ll_temp]
		if ll_temp = dw_sql.rowcount() or ll_temp = 1 then exit 
		ls_sql += "~r~n"
	next
	dw_main.object.gv$sqlarea_sql_text[ll_row] = ls_sql 
next
dw_main.setredraw(true)
dw_pre.setredraw(true)

//中断会话
lb_zdhh = false
if dw_main.rowcount() > 0 and cbx_zdjs.checked then 
	ll_maxzh = dw_main.object.c_maxzh[1]
	for ll_temp = dw_main.object.c_minzh[1] to ll_maxzh
		ll_find_m = dw_main.find("zh = " + string(ll_temp) + " and lv > 1 and gv$session_seconds_in_wait > " + em_ms.text, 1, dw_main.rowcount())
		if ll_find_m > 0 then //组中有超过设定的时间的会话，需中断
			ll_find_m = dw_main.find("zh = " + string(ll_temp) + " and lv = 1", 1, dw_main.rowcount())
			if ll_find_m > 0 then //找到了源头
				if pos(dw_main.object.gv$session_program[ll_find_m], '(LGWR)') <> 0 then 
					//如为特殊会话，不中断
				else
					ls_temp = dw_main.object.kill_sql[ll_find_m]
					execute immediate :ls_temp using SQLCA;
					if SQLCA.sqlcode = 0 then 
						dw_main.object.bzxx[ll_find_m] = "中断会话(成功)"
						lb_zdhh = true
					else
						dw_main.object.bzxx[ll_find_m] = "中断会话(失败)"
					end if
				end if
			end if
		end if
	next
end if
if lb_zdhh then gf_delay(5000) //有成功中断过会话，延时5秒

//进入历史
//if dw_main.rowcount() = 0 then //当前无数据，最近的全部进历史
//	dw_pre.rowscopy(1, dw_pre.rowcount(), primary!, dw_his, 999999, primary!)
//	dw_pre.reset()
//else
//	if dw_pre.rowcount() > 0 then //按组比对数据
//		ll_maxzh = dw_pre.object.c_maxzh[1]
//		for ll_temp = dw_pre.object.c_minzh[1] to ll_maxzh
//			ll_find_pre = dw_pre.find("zh = " + string(ll_temp), 1, dw_pre.rowcount())
//			do while true //比对某组数据
//				ll_find_m = dw_main.find("sid_xs = '" + dw_pre.object.sid_xs[ll_find_pre] + "'", 1, dw_main.rowcount())
//				if ll_find_m = 0 then //当前列表中没有时将该组写入历史
//					p_copy:
//					for ll_row = ll_find_pre to dw_pre.rowcount()
//						dw_pre.rowscopy(ll_row, ll_row, primary!, dw_his, 999999, primary!)
//						dw_pre.deleterow(ll_row)
//						ll_row --
//						if ll_row = dw_pre.rowcount() then exit //最后一行
//						if isnull(dw_pre.object.sid_xs[ll_row + 1]) then //该组结束
//							dw_pre.rowscopy(ll_row, ll_row, primary!, dw_his, 999999, primary!) //拷贝空行
//							dw_pre.deleterow(ll_row)
//							ll_row --
//							exit
//						end if
//					next
//				else
//					for ll_row = ll_find_pre to dw_pre.rowcount()
//						if dw_pre.object.sid_xs[ll_row]         = dw_main.object.sid_xs[ll_find_m] and &
//								dw_pre.object.sid_xs[ll_row]      = dw_main.object.sid_xs[ll_find_m] and &
//								dw_pre.object.gv$session_machine[ll_row]     = dw_main.object.gv$session_machine[ll_find_m] and &
//								dw_pre.object.gv$session_program[ll_row]     = dw_main.object.gv$session_program[ll_find_m] and &
//								dw_pre.object.gv$session_username[ll_row]    = dw_main.object.gv$session_username[ll_find_m] and &
//								dw_pre.object.dba_objects_object_name[ll_row] = dw_main.object.dba_objects_object_name[ll_find_m] and &
//								dw_pre.object.gv$session_wait_class[ll_row]  = dw_main.object.gv$session_wait_class[ll_find_m] then 
//							
//						else
//							goto p_copy
//						end if
//					next
//				end if
//			loop
//		next
//	end if
//end if

//记录日志
if dw_main.rowcount() > 0 then 
	ll_maxzh = dw_main.object.c_maxzh[1]
	for ll_temp = dw_main.object.c_minzh[1] to ll_maxzh
		ll_find_m = dw_main.find("zh = " + string(ll_temp) + " and lv > 1 and gv$session_seconds_in_wait > 5", 1, dw_main.rowcount())
		if ll_find_m > 0 then //组中有超过5秒的会话，需记录
			ll_find_m = dw_main.find("zh = " + string(ll_temp), 1, dw_main.rowcount())
			do while true //写某一组日志(源头或等待超过5秒
				if dw_main.object.lv[ll_find_m] = 1 or dw_main.object.gv$session_seconds_in_wait[ll_find_m] > 5 then
					ls_temp = &
						wf_fill(dw_main.object.sysd[ll_find_m], 8, 1) + &
						" " + wf_fill(dw_main.object.sid_xs[ll_find_m], 26, 1) + &
						" " + wf_fill(dw_main.object.gv$session_machine[ll_find_m], 16, 1) + &
						" " + wf_fill(dw_main.object.gv$session_program[ll_find_m], 30, 1) + &
						" " + wf_fill(dw_main.object.gv$session_username[ll_find_m], 16, 1) + &
						" " + wf_fill(dw_main.object.dba_objects_object_name[ll_find_m], 16, 1) + &
						" " + wf_fill(dw_main.object.lock_type[ll_find_m], 16, 1) + &
						" " + wf_fill(dw_main.object.gv$session_wait_class[ll_find_m], 16, 1) + &
						" " + wf_fill(string(dw_main.object.gv$session_seconds_in_wait[ll_find_m]), 8, 2) + &
						" " + wf_fill(dw_main.object.bzxx[ll_find_m], 16, 1) + &
						" " + wf_fill(dw_main.object.gv$sqlarea_sql_text[ll_find_m], 200, 1)
					wf_filewrite(ls_temp)
				end if
				ll_find_m ++ 
				if ll_find_m > dw_main.rowcount() then 
					//每次间隔
					wf_filewrite("") 
					wf_filewrite(gf_public_replace(space(200), " ", "=")) 
					wf_filewrite("")
					exit //已到最后一行 Exit
				end if
				if isnull(dw_main.object.zh[ll_find_m]) or dw_main.object.zh[ll_find_m] <> ll_temp then 
					wf_filewrite("") //每组间隔
					exit //下一行为另一组 Exit
				end if
			loop
		end if
	next
end if

p_end:
if not ib_test then timer(integer(em_sxpl.text))

end event

event closequery;//if em_1.text <> '1001' then 
//	CloseWindow(handle(w_main))
//	return 1
//end if
if messagebox("提示", "是否退出应用程序?", question!, yesno!, 2) = 2 then return 1
timer(0)
wf_filewrite(string(gf_server_date(), 'yyyy.mm.dd hh:mm:ss') + "记录结束~r~n")

end event

event close;m_main.m_s.m_proc.enabled = false
m_main.m_s.m_proc.m_o_proc.enabled = false
m_main.m_s.m_proc.m_u_proc.enabled = false
m_main.m_s.m_proc.m_a_proc.enabled = false
//SharedObjectUnRegister('object')
////注销先前注册过的共享对象object
//If IsValid(uo_thread) Then Destroy uo_thread//若uo_thread已经存在，先删除 
//If IsValid(uo_argv) Then Destroy uo_argv
disconnect;
halt

end event

event resize;integer li_tza = 0

dw_main.width  = width - 90
dw_main.height = height/2  
dw_pre.width   = width - 90
dw_pre.y       = height/2 + 10 
dw_pre.height  = height/2 - (st_sxpl.height * 3) - 80 

st_sxpl.y   = dw_pre.height + dw_main.height + 40 - li_tza
em_sxpl.y   = dw_pre.height + dw_main.height + 30 - li_tza 
st_ms.y     = dw_pre.height + dw_main.height + 40 - li_tza 
em_ms.y     = dw_pre.height + dw_main.height + 30 - li_tza 
cbx_zdjs.y  = dw_pre.height + dw_main.height + 30 - li_tza 
st_m.y      = dw_pre.height + dw_main.height + 40 - li_tza 
st_ver.y      = dw_pre.height + dw_main.height + 40 - li_tza 
st_tm.y     = dw_pre.height + dw_main.height + 40 - li_tza 
st_tm.x     = width - st_tm.width - 80

end event

type st_ver from statictext within w_link_oracle_new
integer x = 1472
integer y = 1784
integer width = 946
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
string text = "Ver:1.6 Build on 21.05.30 at 13:25"
boolean focusrectangle = false
end type

type dw_pre from datawindow within w_link_oracle_new
integer x = 14
integer y = 892
integer width = 3616
integer height = 864
integer taborder = 10
string title = "锁/被锁进程(最近)"
string dataobject = "d_link_oracle_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;return 1

end event

event rbuttondown;//int li_spid, li_file, li_pos1, li_pos2
//string ls_sql, ls_dn
//
//if row = 0 then return
//timer(0)
//this.setrow(row)
//if pos(upper(sqlca.dbms), "SYBASE") = 0 and pos(upper(sqlca.dbms), "SYC") = 0 then
//	if dw_main.dataobject = "d_link_sqlserver_2005" then 
//		li_spid = this.object.会话[row]
//		ls_sql = dw_main.object.sql语句[row]
//		if ls_sql = "" or isnull(ls_sql) then
//			dw_sql.retrieve(li_spid)
//			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//		end if
//	else
//		ls_dn   = this.object.dn[row]
//		if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then goto p_end
//		li_spid = this.object.spid[row]
//		dw_sql.retrieve(li_spid)
//		if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//	end if
//else
//	ls_dn   = this.object.dn[row]
//	if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then goto p_end
//	li_spid = this.object.spid[row]
//	ls_sql = wf_getsql(li_spid)
//end if
//messagebox("进程 " + string(li_spid), ls_sql)
//::clipboard(ls_sql)
//
//p_end:
//timer(integer(em_sxpl.text))
//
end event

event retrieveend;string  ls_tname, ls_sql, ls_tree
integer li_row, li_sid, li_find, li_bsid, li_bsidp, li_bsidpp, li_rowi

//if dw_main.dataobject = "d_link_sqlserver_2005" then
//	ls_tname = 'SQL会话'
//	ii_asc = asc("A")
//	ii_level = 0
//	//==============================================================================
//	//测试模式
//	//==============================================================================
//	if ib_test then 
//		dw_main.reset()
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 62; dw_main.object.锁会话[li_rowi] = 0;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 99; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 253; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 254; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 381; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 826; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 1016; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 614; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2004; dw_main.object.锁会话[li_rowi] = 614;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 281; dw_main.object.锁会话[li_rowi] = 826;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2000; dw_main.object.锁会话[li_rowi] = 614;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2001; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2003; dw_main.object.锁会话[li_rowi] = 2001;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 63; dw_main.object.锁会话[li_rowi] = 0;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 20; dw_main.object.锁会话[li_rowi] = 63;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 30; dw_main.object.锁会话[li_rowi] = 63;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 40; dw_main.object.锁会话[li_rowi] = 20;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 50; dw_main.object.锁会话[li_rowi] = 30;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 60; dw_main.object.锁会话[li_rowi] = 30;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 70; dw_main.object.锁会话[li_rowi] = 60;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 80; dw_main.object.锁会话[li_rowi] = 50;
//	end if
//	//==============================================================================
//	dw_main.setsort("锁会话, 会话")
//	dw_main.sort()
//	for li_row = 1 to dw_main.rowcount()
//		dw_main.object.tree[li_row] = ""
//	next
//	for li_row = 1 to dw_main.rowcount()
//		li_sid = dw_main.object.会话[li_row]
//		ls_sql  = dw_main.object.sql语句[li_row]
//		if ls_sql = "" or isnull(ls_sql) then 
//			dw_sql.retrieve(li_sid)
//			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//			dw_main.object.sql语句[li_row] = ls_sql
//		end if
////		gf_waiting("正在生成树逻辑,请稍候...", li_row/dw_main.rowcount()*100)
//		if dw_main.object.tree[li_row] = "" then wf_set_tree(li_sid)
//	next
////	gf_waiting("", - 1)
//	for li_row = 1 to dw_main.rowcount()
////		gf_waiting("正在生成树形状,请稍候...", li_row/dw_main.rowcount()*100)
//		ls_tree = dw_main.object.tree[li_row]
//		li_sid  = dw_main.object.会话[li_row]
//		li_bsid = dw_main.object.锁会话[li_row]
//		choose case len(ls_tree)
//			case 1
//				dw_main.object.tree[li_row] = "*" + string(dw_main.object.会话[li_row])
//				dw_main.object.sbz[li_row]  = "◆"
//			case 2 //2种形状
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree = "└-"
//				else
//					ls_tree = "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//			case 3 //4种形状
//				li_find = dw_main.find("会话 = " + string(li_bsid), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidp = dw_main.object.锁会话[li_find] //父
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidp), li_row + 1, dw_main.rowcount())
//				end if
//				if li_find = 0 then //其后父无兄弟
//					ls_tree = "   "
//				else
//					ls_tree = "│ "
//				end if
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree += "└-"
//				else
//					ls_tree += "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//			case 4
//				if li_sid = 7 then debugbreak()
//				li_find = dw_main.find("会话 = " + string(li_bsid), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidp = dw_main.object.锁会话[li_find]
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidp), li_row + 1, dw_main.rowcount())
//				end if
//				if li_find = 0 then //其后父无兄弟
//					ls_tree = "   "
//				else 
//					ls_tree = "│ "
//				end if
//				li_find = dw_main.find("会话 = " + string(li_bsidp), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidpp = dw_main.object.锁会话[li_find]
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidpp), li_row + 1, dw_main.rowcount())
//				end if
//					if li_find = 0 then //其后祖无兄弟
//					ls_tree = "   " + ls_tree
//				else
//					ls_tree = "│ " + ls_tree
//				end if
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree += "└-"
//				else
//					ls_tree += "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//		end choose
//	next
////	gf_waiting("", - 1)
//else
//	for li_row = 1 to dw_main.rowcount()
//		li_sid = dw_main.object.spid[li_row]
//		messagebox("", li_sid)
//		select to_char(s.sql_text) into :ls_sql from v$session a, v$sqlarea s 
//			where a.sql_address = s.address(+) and a.sql_hash_value = s.hash_value(+) 
//		and a.sid = :li_sid;
//		messagebox(string(sqlca.sqlnrows), sqlca.sqlerrtext)
//
//	next
//end if
//if this.rowcount() > 0 then 
//	parent.title = is_title + '  ' + ls_tname + '  ' + string(this.rowcount()) + '个'
//else
//	parent.title = is_title + '  ' + ls_tname
//end if

end event

type dw_sql from datawindow within w_link_oracle_new
boolean visible = false
integer x = 2999
integer y = 908
integer width = 521
integer height = 268
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_sql"
string dataobject = "d_sql_oracle"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;settransobject(sqlca)

end event

event dberror;return 1

end event

type cbx_zdjs from checkbox within w_link_oracle_new
integer x = 1125
integer y = 1780
integer width = 302
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
string text = "自动解锁"
end type

type em_ms from editmask within w_link_oracle_new
event keydown pbm_keydown
integer x = 837
integer y = 1768
integer width = 192
integer height = 76
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "60"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
end type

event keydown;if keydown(keyenter!) then 
	close(w_main)
end if

end event

event modified;timer(integer(this.text)/1000)

end event

type st_tm from statictext within w_link_oracle_new
integer x = 3067
integer y = 1784
integer width = 535
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
boolean enabled = false
string text = "08:30:33"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_m from statictext within w_link_oracle_new
integer x = 512
integer y = 1784
integer width = 91
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
boolean enabled = false
string text = "秒"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_sxpl from editmask within w_link_oracle_new
event keydown pbm_keydown
integer x = 311
integer y = 1768
integer width = 192
integer height = 76
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "5"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
end type

event keydown;if keydown(keyenter!) then 
	close(w_main)
end if

end event

event modified;timer(integer(this.text)/1000)

end event

type st_sxpl from statictext within w_link_oracle_new
integer x = 32
integer y = 1784
integer width = 283
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
boolean enabled = false
string text = "刷新频率："
boolean focusrectangle = false
end type

type st_ms from statictext within w_link_oracle_new
integer x = 713
integer y = 1784
integer width = 425
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
string text = "超过        秒"
boolean focusrectangle = false
end type

type dw_main from datawindow within w_link_oracle_new
integer x = 14
integer y = 8
integer width = 3616
integer height = 868
integer taborder = 30
string title = "锁/被锁进程(当前)"
string dataobject = "d_link_oracle_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;string  ls_tname, ls_sql, ls_tree
integer li_row, li_sid, li_find, li_bsid, li_bsidp, li_bsidpp, li_rowi

//if dw_main.dataobject = "d_link_sqlserver_2005" then
//	ls_tname = 'SQL会话'
//	ii_asc = asc("A")
//	ii_level = 0
//	//==============================================================================
//	//测试模式
//	//==============================================================================
//	if ib_test then 
//		dw_main.reset()
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 62; dw_main.object.锁会话[li_rowi] = 0;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 99; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 253; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 254; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 381; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 826; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 1016; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 614; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2004; dw_main.object.锁会话[li_rowi] = 614;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 281; dw_main.object.锁会话[li_rowi] = 826;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2000; dw_main.object.锁会话[li_rowi] = 614;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2001; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2003; dw_main.object.锁会话[li_rowi] = 2001;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 63; dw_main.object.锁会话[li_rowi] = 0;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 20; dw_main.object.锁会话[li_rowi] = 63;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 30; dw_main.object.锁会话[li_rowi] = 63;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 40; dw_main.object.锁会话[li_rowi] = 20;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 50; dw_main.object.锁会话[li_rowi] = 30;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 60; dw_main.object.锁会话[li_rowi] = 30;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 70; dw_main.object.锁会话[li_rowi] = 60;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 80; dw_main.object.锁会话[li_rowi] = 50;
//	end if
//	//==============================================================================
//	dw_main.setsort("锁会话, 会话")
//	dw_main.sort()
//	for li_row = 1 to dw_main.rowcount()
//		dw_main.object.tree[li_row] = ""
//	next
//	for li_row = 1 to dw_main.rowcount()
//		li_sid = dw_main.object.会话[li_row]
//		ls_sql  = dw_main.object.sql语句[li_row]
//		if ls_sql = "" or isnull(ls_sql) then 
//			dw_sql.retrieve(li_sid)
//			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//			dw_main.object.sql语句[li_row] = ls_sql
//		end if
////		gf_waiting("正在生成树逻辑,请稍候...", li_row/dw_main.rowcount()*100)
//		if dw_main.object.tree[li_row] = "" then wf_set_tree(li_sid)
//	next
////	gf_waiting("", - 1)
//	for li_row = 1 to dw_main.rowcount()
////		gf_waiting("正在生成树形状,请稍候...", li_row/dw_main.rowcount()*100)
//		ls_tree = dw_main.object.tree[li_row]
//		li_sid  = dw_main.object.会话[li_row]
//		li_bsid = dw_main.object.锁会话[li_row]
//		choose case len(ls_tree)
//			case 1
//				dw_main.object.tree[li_row] = "*" + string(dw_main.object.会话[li_row])
//				dw_main.object.sbz[li_row]  = "◆"
//			case 2 //2种形状
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree = "└-"
//				else
//					ls_tree = "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//			case 3 //4种形状
//				li_find = dw_main.find("会话 = " + string(li_bsid), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidp = dw_main.object.锁会话[li_find] //父
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidp), li_row + 1, dw_main.rowcount())
//				end if
//				if li_find = 0 then //其后父无兄弟
//					ls_tree = "   "
//				else
//					ls_tree = "│ "
//				end if
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree += "└-"
//				else
//					ls_tree += "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//			case 4
//				if li_sid = 7 then debugbreak()
//				li_find = dw_main.find("会话 = " + string(li_bsid), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidp = dw_main.object.锁会话[li_find]
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidp), li_row + 1, dw_main.rowcount())
//				end if
//				if li_find = 0 then //其后父无兄弟
//					ls_tree = "   "
//				else 
//					ls_tree = "│ "
//				end if
//				li_find = dw_main.find("会话 = " + string(li_bsidp), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidpp = dw_main.object.锁会话[li_find]
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidpp), li_row + 1, dw_main.rowcount())
//				end if
//					if li_find = 0 then //其后祖无兄弟
//					ls_tree = "   " + ls_tree
//				else
//					ls_tree = "│ " + ls_tree
//				end if
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree += "└-"
//				else
//					ls_tree += "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//		end choose
//	next
////	gf_waiting("", - 1)
//else
//	for li_row = 1 to dw_main.rowcount()
//		li_sid = dw_main.object.spid[li_row]
//		messagebox("", li_sid)
//		select to_char(s.sql_text) into :ls_sql from v$session a, v$sqlarea s 
//			where a.sql_address = s.address(+) and a.sql_hash_value = s.hash_value(+) 
//		and a.sid = :li_sid;
//		messagebox(string(sqlca.sqlnrows), sqlca.sqlerrtext)
//
//	next
//end if
//if this.rowcount() > 0 then 
//	parent.title = is_title + '  ' + ls_tname + '  ' + string(this.rowcount()) + '个'
//else
//	parent.title = is_title + '  ' + ls_tname
//end if

end event

event rbuttondown;//int li_spid, li_file, li_pos1, li_pos2
//string ls_sql, ls_dn
//
//if row = 0 then return
//timer(0)
//this.setrow(row)
//if pos(upper(sqlca.dbms), "SYBASE") = 0 and pos(upper(sqlca.dbms), "SYC") = 0 then
//	if dw_main.dataobject = "d_link_sqlserver_2005" then 
//		li_spid = this.object.会话[row]
//		ls_sql = dw_main.object.sql语句[row]
//		if ls_sql = "" or isnull(ls_sql) then
//			dw_sql.retrieve(li_spid)
//			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//		end if
//	else
//		ls_dn   = this.object.dn[row]
//		if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then goto p_end
//		li_spid = this.object.spid[row]
//		dw_sql.retrieve(li_spid)
//		if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//	end if
//else
//	ls_dn   = this.object.dn[row]
//	if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then goto p_end
//	li_spid = this.object.spid[row]
//	ls_sql = wf_getsql(li_spid)
//end if
//messagebox("进程 " + string(li_spid), ls_sql)
//::clipboard(ls_sql)
//
//p_end:
//timer(integer(em_sxpl.text))
//
end event

event dberror;return 1

end event

type dw_his from datawindow within w_link_oracle_new
boolean visible = false
integer x = 2907
integer y = 860
integer width = 3616
integer height = 864
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "锁/被锁进程(历史)"
string dataobject = "d_link_oracle_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;return 1

end event

event rbuttondown;//int li_spid, li_file, li_pos1, li_pos2
//string ls_sql, ls_dn
//
//if row = 0 then return
//timer(0)
//this.setrow(row)
//if pos(upper(sqlca.dbms), "SYBASE") = 0 and pos(upper(sqlca.dbms), "SYC") = 0 then
//	if dw_main.dataobject = "d_link_sqlserver_2005" then 
//		li_spid = this.object.会话[row]
//		ls_sql = dw_main.object.sql语句[row]
//		if ls_sql = "" or isnull(ls_sql) then
//			dw_sql.retrieve(li_spid)
//			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//		end if
//	else
//		ls_dn   = this.object.dn[row]
//		if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then goto p_end
//		li_spid = this.object.spid[row]
//		dw_sql.retrieve(li_spid)
//		if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//	end if
//else
//	ls_dn   = this.object.dn[row]
//	if ls_dn = "no db" or li_spid = 0 or isnull(li_spid) then goto p_end
//	li_spid = this.object.spid[row]
//	ls_sql = wf_getsql(li_spid)
//end if
//messagebox("进程 " + string(li_spid), ls_sql)
//::clipboard(ls_sql)
//
//p_end:
//timer(integer(em_sxpl.text))
//
end event

event retrieveend;string  ls_tname, ls_sql, ls_tree
integer li_row, li_sid, li_find, li_bsid, li_bsidp, li_bsidpp, li_rowi

//if dw_main.dataobject = "d_link_sqlserver_2005" then
//	ls_tname = 'SQL会话'
//	ii_asc = asc("A")
//	ii_level = 0
//	//==============================================================================
//	//测试模式
//	//==============================================================================
//	if ib_test then 
//		dw_main.reset()
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 62; dw_main.object.锁会话[li_rowi] = 0;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 99; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 253; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 254; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 381; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 826; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 1016; dw_main.object.锁会话[li_rowi] = 62;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 614; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2004; dw_main.object.锁会话[li_rowi] = 614;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 281; dw_main.object.锁会话[li_rowi] = 826;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2000; dw_main.object.锁会话[li_rowi] = 614;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2001; dw_main.object.锁会话[li_rowi] = 253;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 2003; dw_main.object.锁会话[li_rowi] = 2001;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 63; dw_main.object.锁会话[li_rowi] = 0;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 20; dw_main.object.锁会话[li_rowi] = 63;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 30; dw_main.object.锁会话[li_rowi] = 63;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 40; dw_main.object.锁会话[li_rowi] = 20;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 50; dw_main.object.锁会话[li_rowi] = 30;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 60; dw_main.object.锁会话[li_rowi] = 30;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 70; dw_main.object.锁会话[li_rowi] = 60;
//		li_rowi = dw_main.insertrow(0); dw_main.object.会话[li_rowi] = 80; dw_main.object.锁会话[li_rowi] = 50;
//	end if
//	//==============================================================================
//	dw_main.setsort("锁会话, 会话")
//	dw_main.sort()
//	for li_row = 1 to dw_main.rowcount()
//		dw_main.object.tree[li_row] = ""
//	next
//	for li_row = 1 to dw_main.rowcount()
//		li_sid = dw_main.object.会话[li_row]
//		ls_sql  = dw_main.object.sql语句[li_row]
//		if ls_sql = "" or isnull(ls_sql) then 
//			dw_sql.retrieve(li_sid)
//			if dw_sql.rowcount() > 0 then ls_sql = dw_sql.object.eventinfo[1]
//			dw_main.object.sql语句[li_row] = ls_sql
//		end if
////		gf_waiting("正在生成树逻辑,请稍候...", li_row/dw_main.rowcount()*100)
//		if dw_main.object.tree[li_row] = "" then wf_set_tree(li_sid)
//	next
////	gf_waiting("", - 1)
//	for li_row = 1 to dw_main.rowcount()
////		gf_waiting("正在生成树形状,请稍候...", li_row/dw_main.rowcount()*100)
//		ls_tree = dw_main.object.tree[li_row]
//		li_sid  = dw_main.object.会话[li_row]
//		li_bsid = dw_main.object.锁会话[li_row]
//		choose case len(ls_tree)
//			case 1
//				dw_main.object.tree[li_row] = "*" + string(dw_main.object.会话[li_row])
//				dw_main.object.sbz[li_row]  = "◆"
//			case 2 //2种形状
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree = "└-"
//				else
//					ls_tree = "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//			case 3 //4种形状
//				li_find = dw_main.find("会话 = " + string(li_bsid), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidp = dw_main.object.锁会话[li_find] //父
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidp), li_row + 1, dw_main.rowcount())
//				end if
//				if li_find = 0 then //其后父无兄弟
//					ls_tree = "   "
//				else
//					ls_tree = "│ "
//				end if
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree += "└-"
//				else
//					ls_tree += "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//			case 4
//				if li_sid = 7 then debugbreak()
//				li_find = dw_main.find("会话 = " + string(li_bsid), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidp = dw_main.object.锁会话[li_find]
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidp), li_row + 1, dw_main.rowcount())
//				end if
//				if li_find = 0 then //其后父无兄弟
//					ls_tree = "   "
//				else 
//					ls_tree = "│ "
//				end if
//				li_find = dw_main.find("会话 = " + string(li_bsidp), 1, dw_main.rowcount())
//				if li_find > 0 then 
//					li_bsidpp = dw_main.object.锁会话[li_find]
//					li_find  = dw_main.find("锁会话 = " + string(li_bsidpp), li_row + 1, dw_main.rowcount())
//				end if
//					if li_find = 0 then //其后祖无兄弟
//					ls_tree = "   " + ls_tree
//				else
//					ls_tree = "│ " + ls_tree
//				end if
//				if dw_main.find("锁会话 = " + string(li_bsid), li_row + 1, dw_main.rowcount()) = 0 or li_row = dw_main.rowcount() then //其后无兄弟
//					ls_tree += "└-"
//				else
//					ls_tree += "├-"
//				end if
//				dw_main.object.tree[li_row] = ls_tree + "*" + string(li_sid)
//		end choose
//	next
////	gf_waiting("", - 1)
//else
//	for li_row = 1 to dw_main.rowcount()
//		li_sid = dw_main.object.spid[li_row]
//		messagebox("", li_sid)
//		select to_char(s.sql_text) into :ls_sql from v$session a, v$sqlarea s 
//			where a.sql_address = s.address(+) and a.sql_hash_value = s.hash_value(+) 
//		and a.sid = :li_sid;
//		messagebox(string(sqlca.sqlnrows), sqlca.sqlerrtext)
//
//	next
//end if
//if this.rowcount() > 0 then 
//	parent.title = is_title + '  ' + ls_tname + '  ' + string(this.rowcount()) + '个'
//else
//	parent.title = is_title + '  ' + ls_tname
//end if

end event

