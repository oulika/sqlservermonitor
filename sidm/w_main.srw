forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
integer width = 3035
integer height = 1384
boolean titlebar = true
string title = "数据库进程"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 80269524
event ue_event pbm_custom01
mdi_1 mdi_1
end type
global w_main w_main

type variables
private:
s_str istr_icon

CONSTANT long NIM_MODIFY=1
public:
string  is_menu
boolean ib_icon = true
integer ii_sort = 1
window  iw_link

end variables

forward prototypes
public function boolean wf_connect ()
public subroutine wf_icon ()
end prototypes

event ue_event;m_popup lm_popup 
Integer li_X, li_Y

if lparam <> 512 then debugbreak()
choose case lparam 
	case 512 //Movehere
	Case 513 // LButtonUp
	case 515 //左键双击
		// 删除图标
		Shell_NotifyIcon( 2, istr_icon )
		this.show()
		Send(Handle(this), 274, 61728, 0)
	CASE 517 + 999 // RButtonUp
		li_X = This.X
		li_Y = This.Y
		// 移动到屏幕外以免show 时看到，你可关闭此句看什么效果
		This.Move ( - This.Width - 10, - This.Height - 10 )
		// 加这句才能看到菜单条（菜单条属于此windows)
		This.Show ( )
		lm_popup = CREATE m_popup
		lm_popup.m_item.PopMenu ( PointerX ( ), PointerY ( ) )
		// 恢复设置
		This.Hide ( )
		This.Move ( li_X, li_Y )
		DESTROY lm_popup
		choose case is_menu
			case 'show'
				// 删除图标
				Shell_NotifyIcon( 2, istr_icon )
				this.show()
				Send(Handle(this), 274, 61728, 0)
			case 'close'
				// 删除图标
				Shell_NotifyIcon( 2, istr_icon )
				close(this)
		end choose
end choose 

end event

public function boolean wf_connect ();string ls_computername
registryget("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\VxD\VNETSUP","ComputerName",ls_computername)
SQLCA.DBMS = "MSS Microsoft SQL Server 6.x"
SQLCA.Database = "bstest"
SQLCA.LogPass = "t2b0v5"
SQLCA.ServerName = "pfsvr0"
SQLCA.LogId = "sa"
SQLCA.AutoCommit = True
SQLCA.DBParm = "DBGetTime=1,host='" + ls_computername +"',appname='连接'"
connect;
return (sqlca.sqlcode = 0 )

end function

public subroutine wf_icon ();//if isvalid(w_link_oracle) then 
//	if w_link_oracle.dw_main.rowcount() > 0 then //锁表
//		if not ib_icon then 
//			istr_icon.icon = LoadImageA(0, "fire.ico", NIM_MODIFY, 0, 0, 80 )
//			messagebox("", 1)
//			ib_icon = true
//		else
//			istr_icon.icon = LoadImageA(0, "fire2.ico", NIM_MODIFY, 0, 0, 80 )
//			messagebox("", 2)
//			ib_icon = false
//		end if
//		shell_notifyicon (0, istr_icon )
//	else //未锁表
//		if not ib_icon then 
//			// 显示icon关键函数, 0为显示，1为修改，2为删除
//			istr_icon.icon = LoadImageA(0, "fire.ico", NIM_MODIFY, 0, 0, 80 )
//			shell_notifyicon (0, istr_icon )
//			ib_icon = true
//		end if
//	end if
//end if
//
end subroutine

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event resize;string ls_resource
Long ll_handle
//if sizetype = 1 then
//	// 下三句为装入图标资源,notepad.exe即为写字板，exe执行时显示的图标内定为1
////	ls_resource = "notepad.exe"
////	ll_handle = loadlibrary ( ls_resource )
////	istr_icon.icon = loadicon ( ll_handle, 1 )
//	istr_icon.icon = LoadImageA ( 0, "fire.ico", NIM_MODIFY, 0, 0, 80 )
//	// 窗口回调事件号,pbm_custom01即为1024,02为1025,依此类推
//	istr_icon.callbackmessage = 1024
//	istr_icon.tips = this.title
//	istr_icon.hwnd = handle ( this )
//	istr_icon.size = 88
//	istr_icon.id = 100
//	// 标识值,即为显示tips 4, 显示icon 2, 激活窗口对应事件号
//	istr_icon.flags = 7
//	// 显示icon关键函数, 0为显示，1为修改，2为删除
//	shell_notifyicon ( 0, istr_icon )
//	this.hide()
//	// 释放资源
//	freelibrary ( ll_handle )
//end if
//
end event

event close;// 删除图标
Shell_NotifyIcon( 2, istr_icon )
disconnect;
m_main.m_s.m_proc.enabled = false

end event

event open;timer(1)

end event

event timer;if isvalid(w_link) then w_link.st_tm.text = string(today(), 'yyyy年mm月dd日 ') + string(now(), 'hh:mm:ss')
wf_icon()

end event

event closequery;closewindow(handle(this))
return 1

end event

type mdi_1 from mdiclient within w_main
long BackColor=276856960
end type

