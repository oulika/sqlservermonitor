forward
global type vu_progress from UserObject
end type
type st_1 from statictext within vu_progress
end type
type st_2 from statictext within vu_progress
end type
type st_3 from statictext within vu_progress
end type
type st_4 from statictext within vu_progress
end type
type st_5 from statictext within vu_progress
end type
type st_6 from statictext within vu_progress
end type
type st_7 from statictext within vu_progress
end type
type st_8 from statictext within vu_progress
end type
type st_9 from statictext within vu_progress
end type
type st_10 from statictext within vu_progress
end type
type st_11 from statictext within vu_progress
end type
type st_12 from statictext within vu_progress
end type
type st_13 from statictext within vu_progress
end type
type st_14 from statictext within vu_progress
end type
type st_15 from statictext within vu_progress
end type
type st_16 from statictext within vu_progress
end type
type st_17 from statictext within vu_progress
end type
type st_18 from statictext within vu_progress
end type
type st_19 from statictext within vu_progress
end type
type st_20 from statictext within vu_progress
end type
type st_21 from statictext within vu_progress
end type
type st_22 from statictext within vu_progress
end type
type st_23 from statictext within vu_progress
end type
type st_24 from statictext within vu_progress
end type
type st_25 from statictext within vu_progress
end type
end forward

global type vu_progress from UserObject
int Width=1390
int Height=100
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
st_11 st_11
st_12 st_12
st_13 st_13
st_14 st_14
st_15 st_15
st_16 st_16
st_17 st_17
st_18 st_18
st_19 st_19
st_20 st_20
st_21 st_21
st_22 st_22
st_23 st_23
st_24 st_24
st_25 st_25
end type
global vu_progress vu_progress

type variables
private  statictext  st_progress[25]
private  boolean   ib_single
end variables

forward prototypes
public subroutine initialize (integer ai_width, integer ai_height, integer ai_space)
public subroutine setprogress (integer ai_value)
end prototypes

public subroutine initialize (integer ai_width, integer ai_height, integer ai_space);/* 

1.ai_Space > 0 使用块状进度条     
2.ai_Space = 0 使用条状进度条

*/
integer i
FOR i = 1 TO 25
	st_progress[i].visible = False
NEXT
IF ai_Space > 0 THEN
	ib_Single = False
	/* 计算各个进度条块大小 */
	ai_Width  = (ai_Width - 23 - ai_Space * 24) / 25
	ai_Height = (ai_Height - 24 )
	/* 调整各个进度条块位置 */
	FOR i = 1 TO 25
		IF i = 1 THEN
	      st_progress[i].Move(5,4)
		ELSE
			st_progress[i].Move(st_progress[i - 1].X + st_progress[i - 1].Width + ai_Space,4)
		END IF
	   st_progress[i].Resize(ai_Width,ai_Height)
   NEXT
	/* 计算整个进度条大小 */
	ai_Width  = st_progress[25].X + st_progress[25].Width + 23
	ai_Height = st_progress[25].Height + 24
ELSE
	ib_Single = True
	st_progress[1].Move(0,0)
	st_progress[1].width   = 0
	st_progress[1].Height  = ai_Height
	st_progress[1].visible = True
END IF

/* 调整进度条大小 */
This.Resize(ai_Width , ai_Height)


end subroutine

public subroutine setprogress (integer ai_value);integer i
IF ai_value > 0 AND ai_value <= 100 THEN
	IF ib_Single THEN
		st_progress[1].Width = ai_Value * This.Width / 100
		RETURN
	END IF	
	FOR i = 1 TO integer(ai_value / 4)
		IF NOT st_progress[i].visible THEN
         st_progress[i].visible = True
		END IF	
	NEXT	 
ELSE  // 重置进度条
	IF st_progress[1].visible THEN
	   FOR i = 1 TO 25
		   st_progress[i].visible = False
	   NEXT	
	END IF
	IF ib_Single THEN
		st_progress[1].visible = True
		st_progress[1].Width   = 0
	END IF		
END IF

end subroutine

on vu_progress.create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_13=create st_13
this.st_14=create st_14
this.st_15=create st_15
this.st_16=create st_16
this.st_17=create st_17
this.st_18=create st_18
this.st_19=create st_19
this.st_20=create st_20
this.st_21=create st_21
this.st_22=create st_22
this.st_23=create st_23
this.st_24=create st_24
this.st_25=create st_25
this.Control[]={this.st_1,&
this.st_2,&
this.st_3,&
this.st_4,&
this.st_5,&
this.st_6,&
this.st_7,&
this.st_8,&
this.st_9,&
this.st_10,&
this.st_11,&
this.st_12,&
this.st_13,&
this.st_14,&
this.st_15,&
this.st_16,&
this.st_17,&
this.st_18,&
this.st_19,&
this.st_20,&
this.st_21,&
this.st_22,&
this.st_23,&
this.st_24,&
this.st_25}
end on

on vu_progress.destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.st_15)
destroy(this.st_16)
destroy(this.st_17)
destroy(this.st_18)
destroy(this.st_19)
destroy(this.st_20)
destroy(this.st_21)
destroy(this.st_22)
destroy(this.st_23)
destroy(this.st_24)
destroy(this.st_25)
end on

event constructor;integer i
FOR i = 1 TO 25
	st_progress[i] = This.Control[i]
NEXT

initialize(This.Width,This.Height,0)  // 默认为单一进度条

end event

type st_1 from statictext within vu_progress
int X=5
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within vu_progress
int X=59
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within vu_progress
int X=114
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within vu_progress
int X=169
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within vu_progress
int X=224
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_6 from statictext within vu_progress
int X=279
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_7 from statictext within vu_progress
int X=334
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_8 from statictext within vu_progress
int X=389
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_9 from statictext within vu_progress
int X=443
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_10 from statictext within vu_progress
int X=498
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_11 from statictext within vu_progress
int X=553
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_12 from statictext within vu_progress
int X=608
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_13 from statictext within vu_progress
int X=663
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_14 from statictext within vu_progress
int X=718
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_15 from statictext within vu_progress
int X=773
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_16 from statictext within vu_progress
int X=827
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_17 from statictext within vu_progress
int X=882
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_18 from statictext within vu_progress
int X=937
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_19 from statictext within vu_progress
int X=992
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_20 from statictext within vu_progress
int X=1047
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_21 from statictext within vu_progress
int X=1102
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_22 from statictext within vu_progress
int X=1157
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_23 from statictext within vu_progress
int X=1211
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_24 from statictext within vu_progress
int X=1266
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

type st_25 from statictext within vu_progress
int X=1321
int Y=4
int Width=46
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8388608
int TextSize=-11
int Weight=400
string FaceName="宋体"
FontCharSet FontCharSet=GB2312CharSet!
FontPitch FontPitch=Variable!
end type

