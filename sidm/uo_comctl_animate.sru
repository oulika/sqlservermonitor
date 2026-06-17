forward
global type uo_comctl_animate from UserObject
end type
end forward

global type uo_comctl_animate from UserObject
UserObjects ObjectType=ExternalVisual!
int Width=393
int Height=96
long BackColor=0
string ClassName="sysanimate32"
string LibraryName="comctl32.dll"
long Style=1174405126
end type
global uo_comctl_animate uo_comctl_animate

type prototypes
Function uLong SendMessageA (ulong hWnd , ulong wMsg , ulong wParam ,string lParam ) library "user32.dll"

end prototypes

type variables
// Progress Meter Message Constants
Constant Private Long WM_USER		= 1024
Constant Private Long  AviFileComp  = 101
Constant Private Long  AviSearch   = 102
Constant Private Long  AviFileCopy   = 103
Constant Private Long  AviDownload   = 104
Constant Private Long  AviPrinting  = 105

Constant Private Long ACM_OPEN = WM_USER + 100
Constant Private Long ACM_PLAY = WM_USER + 101
Constant Private Long ACM_STOP = WM_USER + 102
end variables

forward prototypes
public function long of_playavi (readonly string as_avifilename)
public function long of_stopplay ()
end prototypes

public function long of_playavi (readonly string as_avifilename);//play avi 
//TaoQing taosoft@public.szonline.net
SendMessagea(handle(this), ACM_OPEN, 0, as_avifilename)
Return Send(handle(this), ACM_PLAY, -1,  4294901760) 

end function

public function long of_stopplay ();//Stop play avi 
//TaoQing taosoft@public.szonline.net

Return Send(Handle(this), ACM_STOP, 0, 0)

end function

