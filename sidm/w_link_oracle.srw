forward
global type w_link_oracle from window
end type
type dw_sql from datawindow within w_link_oracle
end type
type cbx_zdjs from checkbox within w_link_oracle
end type
type em_ms from editmask within w_link_oracle
end type
type st_tm from statictext within w_link_oracle
end type
type st_m from statictext within w_link_oracle
end type
type em_sxpl from editmask within w_link_oracle
end type
type st_sxpl from statictext within w_link_oracle
end type
type st_ms from statictext within w_link_oracle
end type
type mle_sql from multilineedit within w_link_oracle
end type
type dw_main from datawindow within w_link_oracle
end type
end forward

global type w_link_oracle from window
integer width = 3680
integer height = 2012
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
dw_sql dw_sql
cbx_zdjs cbx_zdjs
em_ms em_ms
st_tm st_tm
st_m st_m
em_sxpl em_sxpl
st_sxpl st_sxpl
st_ms st_ms
mle_sql mle_sql
dw_main dw_main
end type
global w_link_oracle w_link_oracle

type variables
string      is_sql, is_title, is_errtext
boolean     ib_connect = true
boolean     ib_test = false
integer     ii_type = 1, ii_asc, ii_level, ii_temp
nvo_thread  uo_thread
nvo_argv    uo_argv
string      is_prog

end variables

forward prototypes
public subroutine wf_filewrite (string as_text)
public function string wf_getsql (integer ai_spid)
public subroutine wf_setsql (integer ai_type)
public subroutine wf_filewrite_xls ()
public subroutine wf_set_tree (integer ai_fathid)
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

on w_link_oracle.create
this.dw_sql=create dw_sql
this.cbx_zdjs=create cbx_zdjs
this.em_ms=create em_ms
this.st_tm=create st_tm
this.st_m=create st_m
this.em_sxpl=create em_sxpl
this.st_sxpl=create st_sxpl
this.st_ms=create st_ms
this.mle_sql=create mle_sql
this.dw_main=create dw_main
this.Control[]={this.dw_sql,&
this.cbx_zdjs,&
this.em_ms,&
this.st_tm,&
this.st_m,&
this.em_sxpl,&
this.st_sxpl,&
this.st_ms,&
this.mle_sql,&
this.dw_main}
end on

on w_link_oracle.destroy
destroy(this.dw_sql)
destroy(this.cbx_zdjs)
destroy(this.em_ms)
destroy(this.st_tm)
destroy(this.st_m)
destroy(this.em_sxpl)
destroy(this.st_sxpl)
destroy(this.st_ms)
destroy(this.mle_sql)
destroy(this.dw_main)
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
is_prog = profilestring("sidm.ini", "option", "prog", "!@#$") + "%"
trigger event timer()

end event

event timer;int      li_temp, li_blocked, li_sj, li_row
string   ls_sql, ls_sid_xs, ls_cn, ls_un, ls_pn, ls_now, ls_mess, ls_temp
string   ls_sid
datetime ldt_n
boolean  lb_first
long     ll_sid, ll_find

timer(0)
st_tm.text = "" + string(gf_server_date(), "yyyy-mm-dd hh:mm:ss")
//select SID into :ll_sid from v$MYSTAT where ROWNUM = 1 using SQLCA;
//gf_begin_transaction(SQLCA)
//delete from MY_LOCK using SQLCA;
//insert into MY_LOCK 
//	//被锁的会话
//	select SESSION_ID from v$locked_object where 
//		SESSION_ID IN (SELECT SID FROM V$SESSION where BLOCKING_SESSION > 0)
//	union
//	//锁会话
//	select BLOCKING_SESSION from V$SESSION where BLOCKING_SESSION is not null
//	using SQLCA;
//delete from MY_LOCK where SESSION_ID = :ll_sid using SQLCA;
//gf_commit_transaction(SQLCA)
if ib_connect then
	select 1 into :li_temp from dual;
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
dw_main.retrieve(is_prog)
//获取SQL语句
for li_row = dw_main.rowcount() to 1 step - 1
	if isnull(dw_main.object.blocking_session[li_row]) then 
		ls_sql = dw_main.object.sql_text[li_row]
		if len(ls_sql) > 0 then continue
		ls_sid = dw_main.object.sid[li_row]
		dw_sql.retrieve(integer(ls_sid))
		ls_sql = ""
		for li_temp = 1 to dw_sql.rowcount()
			ls_sql = ls_sql + dw_sql.object.sql[li_temp]
			if li_temp = dw_sql.rowcount() or li_temp = 1 then exit 
			ls_sql += "~r~n"
		next
		dw_main.object.sql_text[li_row] = ls_sql 
	end if
next
dw_main.setredraw(true)
if dw_main.find("(sid_xs like '%→%') and ms > 5", 1, dw_main.rowcount()) > 0 then  
	if fileexists("warning.wav") then
		sndPlaySoundA ("warning.wav", waveOutGetNumDevs())
	else
		beep(1) 
	end if
	select sysdate into :ldt_n from dual using SQLCA;
	ls_now = string(ldt_n, 'yyyy.mm.dd hh:mm:ss')
	mle_sql.text = ''
	for li_temp = 1 to dw_main.rowcount()
		ls_mess = ""
		ls_sid_xs = dw_main.object.sid_xs[li_temp]
		ls_sid_xs = left(ls_sid_xs + space(26), 26)
		ls_cn = dw_main.object.machine[li_temp]
		ls_pn = dw_main.object.program[li_temp]
		ls_un = dw_main.object.username[li_temp]
		li_sj = dw_main.object.ms[li_temp]
		if isnull(ls_cn) then ls_cn = ""
		ls_cn = string(li_temp, "00") + ".会话：" + ls_sid_xs + &
			"计算机：" + ls_cn + "  "
		if isnull(ls_un) then ls_un = ""
		ls_un = "用户：" + ls_un + "  "
		if isnull(ls_pn) then ls_pn = ""
		ls_pn = "应用程序：" + ls_pn + "  "
		if isnull(li_sj) then li_sj = 0
		ls_sql = trim(dw_main.object.sql_text[li_temp])
		if isnull(ls_sql) then ls_sql = ""
		if li_temp = 1 then 
			mle_sql.text = "==================================================================~r~n"
			mle_sql.text += "▲" + ls_now + ' 共 ' + string(dw_main.rowcount()) + ' 个会话 最长等待时间:' + string(dw_main.object.max_ms[1])
			mle_sql.text += "~r~n=================================================================="
		end if
		if cbx_zdjs.checked then 
			ls_temp = dw_main.object.kill_sql[li_temp]
			if len(ls_temp) > 0 and dw_main.object.ms[li_temp] > integer(em_ms.text) then
				execute immediate :ls_temp using SQLCA;
				if SQLCA.sqlcode = 0 then 
					ls_mess = "~r~n--中断会话(" +  ls_temp + ")成功★--"
				else
					ls_mess = "~r~n--中断进程(" +  ls_temp + ")失败☆--"
				end if
			end if
		end if
		mle_sql.text += "~r~n" + ls_cn + ls_un + "sid：" + string(ls_sid) + "  " + ls_pn + "等待时间：" + string(li_sj) + "  sql命令："
		if ls_sql + ls_mess <> "" then mle_sql.text += "~r~n" + ls_sql + ls_mess
		if li_temp <> dw_main.rowcount() then mle_sql.text += "~r~n------------------------------------------------------------------"
	next
	mle_sql.text += "~r~n"
	if dw_main.find("ms > 5", 1, dw_main.rowcount()) > 0 then //阻塞5以上写日志
		wf_filewrite(mle_sql.text) 
	end if
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
mle_sql.width   = width - 90
mle_sql.y       = height/2 + 10 
mle_sql.height  = height/2 - (st_sxpl.height * 3) - 80 

st_sxpl.y   = mle_sql.height + dw_main.height + 40 - li_tza
em_sxpl.y   = mle_sql.height + dw_main.height + 30 - li_tza 
st_ms.y     = mle_sql.height + dw_main.height + 40 - li_tza 
em_ms.y     = mle_sql.height + dw_main.height + 30 - li_tza 
cbx_zdjs.y  = mle_sql.height + dw_main.height + 30 - li_tza 
st_m.y      = mle_sql.height + dw_main.height + 40 - li_tza 
st_tm.y     = mle_sql.height + dw_main.height + 40 - li_tza 
st_tm.x     = width - st_tm.width - 80

end event

type dw_sql from datawindow within w_link_oracle
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

type cbx_zdjs from checkbox within w_link_oracle
integer x = 1120
integer y = 1784
integer width = 302
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 67108864
string text = "自动解锁"
boolean lefttext = true
end type

type em_ms from editmask within w_link_oracle
event keydown pbm_keydown
integer x = 837
integer y = 1772
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

type st_tm from statictext within w_link_oracle
integer x = 3067
integer y = 1788
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

type st_m from statictext within w_link_oracle
integer x = 512
integer y = 1788
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

type em_sxpl from editmask within w_link_oracle
event keydown pbm_keydown
integer x = 311
integer y = 1772
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

type st_sxpl from statictext within w_link_oracle
integer x = 32
integer y = 1788
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

type st_ms from statictext within w_link_oracle
integer x = 713
integer y = 1788
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

type mle_sql from multilineedit within w_link_oracle
integer x = 14
integer y = 880
integer width = 3616
integer height = 888
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long backcolor = 16777215
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type dw_main from datawindow within w_link_oracle
integer x = 14
integer y = 8
integer width = 3616
integer height = 868
integer taborder = 30
string title = "锁/被锁进程"
string dataobject = "d_link_oracle"
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

