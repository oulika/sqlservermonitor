forward
global type sidm from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
Environment ge_Environment
string      gs_apppath

end variables
global type sidm from application
string appname = "sidm"
end type
global sidm sidm

type prototypes
Function boolean DES(ref string inStr, ref string key, ref string outStr, int mode) library "NetDiskDll.dll"
//获取计算机名
function long GetComputerNameA(ref string name, long size) Library "kernel32.dll"
//注销、重启、关闭计算机
Function Long ExitWindowsEx(Long uflag,Long nouse) Library "user32.dll"
//
function long LoadLibrary( ref string string ) LIBRARY "KERNEL32" Alias For LoadLibraryA
function long FreeLibrary( long long ) LIBRARY "KERNEL32" 
function boolean Shell_NotifyIcon( ulong long, ref s_str str ) LIBRARY "SHELL32" Alias FOR "Shell_NotifyIconA" 
function long LoadIcon( long long, long long ) LIBRARY "USER32" Alias For LoadIconA
function long LoadImageA ( long hInstance, string lpszName, uint uType, int a, int b, uint l ) library "user32.dll"
function long activatewindow( long handle, boolean ub) Library "user32.dll"
//playsound
Function boolean sndPlaySoundA (string SoundName, uint Flags) Library "WINMM.DLL"
Function uint waveOutGetNumDevs () Library "WINMM.DLL"
//
function uLong SystemParametersInfoA (ulong uAction, ulong uParam, ref any lpvParam, ulong fuWinIni) Library "user32.dll"  
function long GetCurrentProcessId ( ) library "kernel32" 
function long RegisterServiceProcess ( long dwProcessID, long dwtype )  library "kernel32" 
//
Function uint GetWindow (long handle,uint relationship) Library "USER32.DLL"
Function int GetWindowTextA(long handle, ref string wintext, int length) Library "USER32.DLL"
Function boolean IsWindowVisible (long handle) Library "USER32.DLL"
//发送消息
function ulong SendMessage(ulong hwnd,ulong wMsg,ulong wParam,ref ulong lParam) LIBRARY "user32.dll" 
//
function ulong FindWindowA (ulong classname, string windowname) Library "USER32.DLL"
//
public function integer _lcreat(string filename,int num) library "kernel32.dll"
public function integer _lopen(string filename,int access) library "kernel32.dll"
public function integer _lread(int file,ref string text,int len) library "kernel32.dll"
public function integer _lwrite(int file,ref string text,int len) library "kernel32.dll"
public function integer _lclose(int file) library "kernel32.dll"
public function integer _llseek(int file,int offset,int position) library "kernel32.dll"
//
function long CloseWindow(long handle) Library "user32.dll" 
Function long GetForegroundWindow() Library "user32.dll"

Function Long SetWindowPos(Long hwnd, Long ord, Long x, Long y, Long dx, Long dy, Long uflag) Library "user32.dll"

end prototypes

on sidm.create
appname="sidm"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sidm.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;transaction SQLHIS
boolean lb_scs = false

if lb_scs then 
// Profile 四院.PORTAL56_HIS
	SQLCA.DBMS = "O90 Oracle9i (9.0.1)"
	SQLCA.LogPass = "PORTAL56_HIS"
	SQLCA.ServerName = "bs-whis56"
	SQLCA.LogId = "PORTAL56_HIS"
	SQLCA.AutoCommit = False
	SQLCA.DBParm = "CommitOnDisconnect='No',PBCatalogOwner='PORTAL56_HIS'"
	connect using SQLCA;
	
	SQLHIS = create transaction
	SQLHIS.DBMS = "O90 Oracle9i (9.0.1)"
	SQLHIS.LogPass = "PORTAL56_HIS"
	SQLHIS.ServerName = "bs-whis56"
	SQLHIS.LogId = "PORTAL56_HIS"
	SQLHIS.AutoCommit = False
	SQLHIS.DBParm = "CommitOnDisconnect='No',PBCatalogOwner='PORTAL56_HIS'"
	connect using SQLHIS;
	
	update TMP_TEST_LOCK set JLXH = JLXH + 1 where JLXH = 3 using SQLCA;
	update TMP_TEST_LOCK set JLXH = JLXH + 2 where JLXH = 3 using SQLHIS;
	
	halt close
end if

////使alt+ctrl+del失效
//Integer SPI_SCREENSAVERRUNNING = 97  
//Integer i_ret  
//any any_value  
//i_ret = SystemParametersInfoA(SPI_SCREENSAVERRUNNING, 1, any_value, 0) 
//不在任务列表中显示
//Constant long RSP_SIMPLE_SERVICE = 1  
//Constant long RSP_UNREGISTER_SERVICE = 0  
//Long ll_ProcessID 
//ll_ProcessID = GetCurrentProcessId ( ) 
//RegisterServiceProcess ( ll_ProcessID, RSP_SIMPLE_SERVICE ) 
//environment env
//GetEnvironment(env)
//if env.ScreenHeight < 768 or env.ScreenWidth < 1024 then
//	messagebox("提示", "请将分率调至1024*768")
//end if
if findwindowa(0, '我的应用程序') = 0 then 
	open(w_main)
//	open(w_color)
else
	halt
end if
GetEnvironment(ge_environment)
gs_apppath = GetCurrentDirectory() 
if gf_connect() then 
	m_main.m_s.m_link.triggerevent(clicked!)
	m_main.m_s.m_locktest.enabled = true
	//if gf_connect() then open(w_link_new)
end if
idle(20)

end event

event idle;//string ls_time,ls_now
//ls_time = profilestring("liq.ini","option","shutdown_time","")
//ls_now = string(now(), 'hh:mm:ss')
//if ls_now >= ls_time then ExitWindowsEx(1,0)
if isvalid(w_link) then 
	if w_link.ii_type <> 1 then 
		m_main.m_s.m_proc.m_o_proc.triggerevent(clicked!)
	end if
end if

end event

event close;//Constant long RSP_UNREGISTER_SERVICE = 0  
//Long ll_ProcessID 
//ll_ProcessID = GetCurrentProcessId ( ) 
//RegisterServiceProcess ( ll_ProcessID, RSP_UNREGISTER_SERVICE)
//
disconnect;

end event

