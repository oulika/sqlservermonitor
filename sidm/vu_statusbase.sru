forward
global type vu_statusbase from UserObject
end type
end forward

type RECT from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type vu_statusbase from UserObject
int Width=933
int Height=144
UserObjects ObjectType=ExternalVisual!
long BackColor=0
long PictureMaskColor=25166016
long TabBackColor=67108864
string ClassName="msctls_statusbar32"
string LibraryName="comctl32.dll"
long Style=1174405376
end type
global vu_statusbase vu_statusbase

type prototypes
function long SendMessageLong( long hWindow, uint Msg, ulong wParam, Ref long Parts[] ) Library 'user32' alias for 'SendMessageA'
function long SendMessageString( long hWindow, uint Msg, ulong wParam, Ref string szText ) Library 'user32' alias for 'SendMessageA'
function long SendMessageRect( long hWindow, uint Msg, ulong wParam, Ref RECT lpRect ) Library 'user32' alias for 'SendMessageA'
end prototypes

type variables
// Status Bar Messages
Constant Private Long WM_USER		= 1024
Constant Private Long SB_SETTEXT		= (WM_USER+1)
Constant Private Long SB_GETTEXT		= (WM_USER+2)
Constant Private Long SB_GETTEXTLENGTH	= (WM_USER+3)
Constant Private Long SB_SETPARTS		= (WM_USER+4)
Constant Private Long SB_GETPARTS		= (WM_USER+6)
Constant Private Long SB_GETBORDERS	= (WM_USER+7)
Constant Private Long SB_SETMINHEIGHT	= (WM_USER+8)
Constant Private Long SB_SIMPLE		= (WM_USER+9)
Constant Private Long SB_GETRECT		= (WM_USER+10)

// Status Bar Types
Constant Public Long SBT_NOBORDERS	= 256
Constant Public Long SBT_POPOUT		= 512
Constant Public Long SBT_RTLREADING	= 1024
Constant Public Long SBT_OWNERDRAW	= 4096

end variables

forward prototypes
public subroutine of_gettext (readonly integer aipart, ref string astext)
public function long of_getparts (ref long alparts[])
public function boolean of_setparts (long alparts[])
public function boolean of_setsimple (readonly boolean absimple)
public subroutine of_setminheight (readonly long alMinHeight)
public function integer of_gettextlength (readonly long alpart)
public function boolean of_getrect (readonly long alPart, ref long alTop, ref long alLeft, ref long alRight, ref long alBottom)
public function boolean of_getborders (ref long alHorizontalWidth, ref long alVerticalWidth, integer alSeperatorWidth)
public function boolean of_settext (readonly integer aipart, readonly integer aistyle, string astext)
end prototypes

public subroutine of_gettext (readonly integer aipart, ref string astext);//===================================================================
// Function:	uo_StatusBar::of_GetText()
//-------------------------------------------------------------------
// Description:The SB_GETTEXT message retrieves the text from the 
//					specified part of a status window. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) iPart
//					lParam = (LPARAM) (LPSTR) szText
//
// iPart
//		Zero-based index of the part from which to retrieve text. 
// szText
//		Pointer to the buffer that receives the text. 
//		This parameter is a null-terminated string. 
//-------------------------------------------------------------------
// Returns:	Returns a 32-bit value that consists of two 16-bit values. 
//				The low word specifies the length, in characters, of the text.
//				The high word specifies the type of operation used to 
//				draw the text. The type can be one of the following values: 
//
//		VALUE				MEANING
//		--------------	------------------------------------------------
//		0					The text is drawn with a border to appear lower 
//							than the plane of the window. 
//		SBT_NOBORDERS	The text is drawn without borders. 
//		SBT_POPOUT		The text is drawn with a border to appear higher 
//							than the plane of window. 
//		SBT_RTLREADING	Displays text using right-to-left reading order 
//							on Hebrew or Arabic systems. 
//
// If the text has the SBT_OWNERDRAW drawing type, this message 
//	returns the 32-bit value associated with the text instead of 
// the length and operation type. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================

// Allocate space for buffer
asText = Space(255)

SendMessageString( Handle(This), SB_GETTEXT, aiPart, asText )

RETURN

end subroutine

public function long of_getparts (ref long alparts[]);//===================================================================
// Function:	uo_StatusBar::of_GetParts()
//-------------------------------------------------------------------
// Description:The SB_GETPARTS message retrieves a count of the 
//					parts in a status window. The message also retrieves 
//					the coordinate of the right edge of the specified 
//					number of parts. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) nParts
//					lParam = (LPARAM) (LPINT) aRightCoord
//
// nParts
//		Number of parts for which to retrieve coordinates. 
//		If this parameter is greater than the number of parts in the
//		window, the message retrieves coordinates for existing parts only. 
// aRightCoord 
//		Pointer to an integer array that has the same number of elements 
//		as parts specified by nParts. Each element in the array receives 
//		the client coordinate of the right edge of the corresponding part. 
//		If an element is set to - 1, the position of the right edge for 
//		that part extends to the right edge of the window. To retrieve 
//		the current number of parts, set this parameter to zero. 
//-------------------------------------------------------------------
// Returns:	Returns the number of parts in the window if successful, 
//				or zero otherwise. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================
long	llCountParts, llIndex
long	llParts128[128], llParts[]

// Allocate memory for unbouded array before calling API function.
llParts[] = llParts128[]

// Get all of the parts.
llCountParts = SendMessageLong( Handle(This), SB_GETPARTS, UpperBound(llParts), llParts[] )

IF (llCountParts > 0) THEN
	// An array assignment will copy all 128 elements, which is undesirable.
	FOR llIndex = 1 TO llCountParts
		alParts[llIndex] = llParts[llIndex]
	NEXT
END IF

RETURN llCountParts

end function

public function boolean of_setparts (long alparts[]);//===================================================================
// Function:	uo_StatusBar::of_SetParts()
//-------------------------------------------------------------------
// Description:The SB_SETPARTS message sets the number of parts 
//					in a status window and the coordinate of the right 
//					edge of each part. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) nParts
//					lParam = (LPARAM) (LPINT) aWidths
//
// nParts 
//		Number of parts to set. The number of parts cannot be greater 
//		than 255. 
// aWidths 
//		Pointer to an integer array that has the same number of 
//		elements as parts specified by nParts. Each element in the 
//		array specifies the position, in client coordinates, of the 
//		right edge of the corresponding part. If an element is - 1, 
//		the position of the right edge for that part extends to the 
//		right edge of the window. 
//-------------------------------------------------------------------
// Returns:	If the operation succeeds, the return value is TRUE. 
//				If the operation fails, the return value is FALSE. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================
long		llCountParts
boolean	lbSetParts = FALSE

llCountParts = UpperBound( alParts[] )

IF llCountParts > 0 THEN
	lbSetParts = (SendMessageLong( Handle(This), SB_SETPARTS, llCountParts, alParts[] ) <> 0)
END IF

RETURN lbSetParts

end function

public function boolean of_setsimple (readonly boolean absimple);//===================================================================
// Function:	uo_StatusBar::of_SetSimple()
//-------------------------------------------------------------------
// Description:The SB_SIMPLE message specifies whether a status 
//					window displays simple text or displays all window 
//					parts set by a previous SB_SETPARTS message. 
//
// NOTE: If the status window is being changed from nonsimple to 
//			simple, or vice versa, the window is immediately redrawn. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) (BOOL) fSimple
//					lParam = 0
//
//fSimple 
//		Display type flag. If this parameter is TRUE, the window 
//		displays simple text. If it is FALSE, it displays
//		multiple parts. 
//-------------------------------------------------------------------
// Returns:	Returns TRUE if set was successful.
//				Returns FALSE if an error occurs. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================
long	llSimple

// Convert boolean to 'C' style boolean (NON-ZERO = TRUE)
IF abSimple THEN
	llSimple = 1
ELSE
	llSimple = 0
END IF

RETURN (Send( Handle(This), SB_SIMPLE, llSimple, 0 ) > 0)

end function

public subroutine of_setminheight (readonly long alMinHeight);//===================================================================
// Function:	uo_StatusBar::of_SetMinHeight()
//-------------------------------------------------------------------
// Description:The SB_SETMINHEIGHT message sets the minimum height 
//					of a status window’s drawing area. 
//
// NOTE: The minimum height is the sum of wParam and twice the width, 
//			in pixels, of the vertical border of the status window.
//			An application must send the WM_SIZE message to the status 
//			window to redraw the window. The wParam and lParam parameters 
//			of the WM_SIZE message should be set to zero. 
//-------------------------------------------------------------------
// Parameters: wParam = (WPARAM) minHeight
//					lParam = 0
//
//minHeight 
//		Minimum height, in pixels, of the window. 
//-------------------------------------------------------------------
// Returns:	<none>
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================

Send( Handle(This), SB_SETMINHEIGHT, alMinHeight, 0 )

RETURN 

end subroutine

public function integer of_gettextlength (readonly long alpart);//===================================================================
// Function:	uo_StatusBar::of_GetTextLength()
//-------------------------------------------------------------------
// Description:The SB_GETTEXTLENGTH message retrieves the length, 
//					in characters, of the text from the specified part 
//					of a status window. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) iPart
//					lParam = 0
//
//	iPart 
//		Zero-based index of the part from which to retrieve text. 
//-------------------------------------------------------------------
// Returns:	Returns a 32-bit value that consists of two 16-bit values. 
//				The low word specifies the length, in characters, of the text.
//				The high word specifies the type of operation used to draw 
//				the text. The type can be one of the following values: 
//
//		VALUE				MEANING
//		--------------	--------------------------------------------------
//		0					The text is drawn with a border to appear lower 
//							than the plane of the window. 
//		SBT_NOBORDERS	The text is drawn without borders. 
//		SBT_OWNERDRAW	The text is drawn by the parent window. 
//		SBT_POPOUT		The text is drawn with a border to appear higher 
//							than the plane of the window. 
//		SBT_RTLREADING	Displays text using right-to-left reading order
//							on Hebrew or Arabic systems. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================
long	llLength

llLength = Send( Handle(This), SB_GETTEXTLENGTH, alPart, 0 )

RETURN IntLow( llLength )

end function

public function boolean of_getrect (readonly long alPart, ref long alTop, ref long alLeft, ref long alRight, ref long alBottom);//===================================================================
// Function:	uo_StatusBar::of_GetRect()
//-------------------------------------------------------------------
// Description:The SB_GETRECT message retrieves the bounding 
//					rectangle of a part in a status window. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) iPart
//					lParam = (LPARAM) (LPRECT) lprc
//
// iPart 
//		Zero-based index of the part whose bounding rectangle is to be 
//		retrieved. 
//	lprc 
//		Pointer to a RECT structure that receives the bounding rectangle.
//-------------------------------------------------------------------
// Returns:	If the operation succeeds, the return value is TRUE. 
//				If the operation fails, the return value is FALSE. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================
boolean	lbGetRect = FALSE
RECT		lRECT

lbGetRect = ( SendMessageRect( Handle(This), SB_GETRECT, alPart, lRECT ) <> 0 )

IF lbGetRect THEN
	alTop		= lRECT.Top
	alLeft	= lRECT.Left
	alRight	= lRECT.Right
	alBottom	= lRECT.Bottom
END IF

RETURN lbGetRect

end function

public function boolean of_getborders (ref long alHorizontalWidth, ref long alVerticalWidth, integer alSeperatorWidth);//===================================================================
// Function:	uo_StatusBar::of_GetParts()
//-------------------------------------------------------------------
// Description:The SB_GETBORDERS message retrieves the current 
//					widths of the horizontal and vertical borders of a 
//					status window. 
//
// NOTE: The borders determine the spacing between the outside edge 
//			of the window and the rectangles within the window that
//			contain text. 
//			The borders also determine the spacing between rectangles. 
//-------------------------------------------------------------------
// Parameters:	wParam = 0
//					lParam = (LPARAM) (LPINT) aBorders; 
//
// aBorders 
//		Pointer to an integer array that has three elements. 
//		The first element receives the width of the horizontal border, 
//		the second receives the width of the vertical border, 
//		and the third receives the width of the border between rectangles. 
//-------------------------------------------------------------------
// Returns:	If the operation succeeds, the return value is TRUE. 
//				If the operation fails, the return value is FALSE. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================
long		llBorders[]
boolean	lbGetBorders = FALSE

// Initialise Unbounded array to correct size.
llBorders[3] = 0
llBorders[2] = 0
llBorders[1] = 0

lbGetBorders = ( SendMessageLong( Handle(This), SB_GETBORDERS, 0, llBorders[] ) <> 0)

IF lbGetBorders THEN
	alHorizontalWidth = llBorders[1]
	alVerticalWidth	= llBorders[2]
	alSeperatorWidth	= llBorders[3]
END IF

RETURN lbGetBorders

end function

public function boolean of_settext (readonly integer aipart, readonly integer aistyle, string astext);//===================================================================
// Function:	uo_StatusBar::of_SetText()
//-------------------------------------------------------------------
// Description:The SB_SETTEXT message sets the text in the specified 
//					part of a status window. 
//					The message invalidates the portion of the window that 
//					has changed, causing it to display the new text when 
//					the window next receives the WM_PAINT message. 
//-------------------------------------------------------------------
// Parameters:	wParam = (WPARAM) iPart | uType
//					lParam = (LPARAM) (LPSTR) szText
//
// iPart 
//		Zero-based index of the part to set. If this value is 255, 
//		the status window is assumed to be a simple window having only 
//		one part. 
// uType 
//		Type of drawing operation. 
//		This parameter can be one of the following values: 
//
//		VALUE				MEANING
//		--------------	--------------------------------------------------
//		0					The text is drawn with a border to appear lower 
//							than the plane of the window. 
//		SBT_NOBORDERS	The text is drawn without borders. 
//		SBT_OWNERDRAW	The text is drawn by the parent window. 
//		SBT_POPOUT		The text is drawn with a border to appear higher 
//							than the plane of the window. 
//		SBT_RTLREADING	Displays text using right-to-left reading order 
//							on Hebrew or Arabic systems. 
// szText 
//		Pointer to a null-terminated string that specifies the text to set. 
//		If uType is SBT_OWNERDRAW, this parameter represents 32 bits of 
//		data. The parent window must interpret the data and draw the text 
//		when it receives the WM_DRAWITEM message. 
//-------------------------------------------------------------------
// Returns:	If the operation succeeds, the return value is TRUE. 
//				If the operation fails, the return value is FALSE. 
//-------------------------------------------------------------------
// © 1997 Microsoft Corporation. All rights reserved.
//===================================================================

RETURN (SendMessageString( Handle(This), SB_SETTEXT, aiPart + aiStyle, asText ) <> 0)

end function

