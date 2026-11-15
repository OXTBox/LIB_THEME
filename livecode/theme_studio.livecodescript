-- theme_studio.livecodescript: the stack script of Theme_Studio (TODO A-89 and A-90, Opus 15 Nov 2026).
-- SOURCE OF TRUTH: edit this file. The window is built by code (TS.Build) on a brand-new empty stack:
--   create stack "Theme_Studio_dev_<stamp>", set its script to this file, send "TS.Build" to it.
-- LEFT   every key of themes/<name>.txt with its colour; click one: swatch, R,G,B to edit, Pick...,
--        and the comment lines the file has above that key. Set / Pick preview at once (Theme.Set).
--        Save writes the values back into the file (comments and order kept); Revert reloads it.
-- RIGHT  live samples of each control kind, coloured by lib_theme (Theme.ApplyStack), and the
--        scrollbar options (A-90): native, thin native (scrollbarWidth 8), and no bar.
-- Never names its own stack (the name changes every version): uses this stack.
constant kThemeLib = "//wsl$/Ubuntu/home/igame3d/projects/LIB_THEME/livecode/lib_theme.livecodescript"
local sThemeName, sKeys, sVal, sCurKey, sFileText, sDirty

on openStack
   TS.Start
end openStack

on closeStackRequest
   set the destroyStack of this stack to true
   pass closeStackRequest
end closeStackRequest

command TS.Start
   if "lib_theme" is not among the lines of the stacksInUse then start using stack kThemeLib
   if sThemeName is empty then put "dark" into sThemeName
   TS.Load sThemeName
end TS.Start

-------------------------------------------------------------------- the window, built by code

command TS.Build
   local tSample, i
   set the defaultStack to the short name of this stack
   lock screen
   lock messages
   set the width of this stack to 920
   set the height of this stack to 520
   set the resizable of this stack to false
   TS.Make "label", "Title", "10,6,460,30", "Theme Studio"
   set the textSize of field "Title" to 16
   set the textStyle of field "Title" to "bold"
   TS.Make "option", "ThemeMenu", "10,36,150,60", "dark" & return & "light"
   set the script of button "ThemeMenu" to "on menuPick pItem" & return & "   TS.Load pItem" & return & "end menuPick"
   TS.Make "list", "Keys", "10,68,250,470", empty
   set the tabStops of field "Keys" to 110
   set the script of field "Keys" to "on mouseUp" & return & "   TS.Select the hilitedLine of me" & return & "end mouseUp"
   create graphic "Swatch"
   set the style of graphic "Swatch" to "rectangle"
   set the filled of graphic "Swatch" to true
   set the rect of graphic "Swatch" to 260, 68, 340, 140
   set the uThemeSkip of graphic "Swatch" to true
   TS.Make "label", "KeyName", "350,68,470,90", empty
   set the textStyle of field "KeyName" to "bold"
   TS.Make "field", "RGB", "260,150,380,174", empty
   set the script of field "RGB" to "on returnInField" & return & "   TS.SetFromField" & return & "end returnInField" & return & \
         "on enterInField" & return & "   TS.SetFromField" & return & "end enterInField"
   TS.Make "button", "Set", "386,150,460,174", "Set"
   set the script of button "Set" to "on mouseUp" & return & "   TS.SetFromField" & return & "end mouseUp"
   TS.Make "button", "Pick", "260,180,360,204", "Pick..."
   set the script of button "Pick" to "on mouseUp" & return & "   TS.Pick" & return & "end mouseUp"
   TS.Make "note", "KeyNote", "260,212,470,430", empty
   TS.Make "button", "Save", "260,440,350,468", "Save"
   set the script of button "Save" to "on mouseUp" & return & "   TS.Save" & return & "end mouseUp"
   TS.Make "button", "Revert", "356,440,446,468", "Revert"
   set the script of button "Revert" to "on mouseUp" & return & "   TS.Revert" & return & "end mouseUp"
   TS.Make "label", "Status", "10,478,910,500", empty
   -- the samples (right half)
   TS.Make "label", "SamplesTitle", "490,6,900,30", "Samples (live, in the theme's colours)"
   set the textStyle of field "SamplesTitle" to "bold"
   create graphic "SampleMenuStrip"
   set the style of graphic "SampleMenuStrip" to "rectangle"
   set the filled of graphic "SampleMenuStrip" to true
   set the lineSize of graphic "SampleMenuStrip" to 0
   set the rect of graphic "SampleMenuStrip" to 490, 36, 900, 60
   TS.Make "pulldown", "SampleMenu", "494,38,574,58", "New|Open|-|Save"
   TS.Make "button", "SampleButton", "490,68,600,94", "A button"
   create button "SampleCheck"
   set the style of button "SampleCheck" to "checkbox"
   set the label of button "SampleCheck" to "A checkbox"
   set the rect of button "SampleCheck" to 610, 68, 740, 94
   TS.Make "field", "SampleField", "490,102,690,190", "An editable field." & return & "Line 2" & return & "Line 3" & return & "Line 4" & return & "Line 5" & return & "Line 6"
   set the vScrollbar of field "SampleField" to true
   TS.Make "list", "SampleList", "700,102,900,190", "List line 1" & return & "List line 2 (selected)" & return & "List line 3" & return & "List line 4" & return & "List line 5" & return & "List line 6"
   set the hilitedLine of field "SampleList" to 2
   create scrollbar "SampleBar"
   set the rect of scrollbar "SampleBar" to 490, 198, 900, 214
   set the thumbPosition of scrollbar "SampleBar" to 30
   create button "SampleTabs"
   set the style of button "SampleTabs" to "menu"
   set the menuMode of button "SampleTabs" to "tabbed"
   set the text of button "SampleTabs" to "Native" & return & "tabs" & return & "here"
   set the rect of button "SampleTabs" to 490, 222, 900, 280
   -- A-90: three ways to have a scroll bar
   put "Line 1" into tSample
   repeat with i = 2 to 20
      put return & "Line" && i after tSample
   end repeat
   TS.Make "field", "BarNative", "490,290,620,400", tSample
   set the vScrollbar of field "BarNative" to true
   TS.Make "field", "BarThin", "630,290,760,400", tSample
   set the vScrollbar of field "BarThin" to true
   set the scrollbarWidth of field "BarThin" to 8
   TS.Make "field", "BarNone", "770,290,900,400", tSample
   set the vScrollbar of field "BarNone" to false
   TS.Make "note", "BarNote", "490,404,910,474", empty
   unlock messages
   unlock screen
   TS.Start
end TS.Build

-- one control of the studio: label / note / field / list / button / option / pulldown
command TS.Make pKind, pName, pRect, pText
   switch pKind
      case "label"
      case "note"
         create field pName
         set the lockText of field pName to true
         set the traversalOn of field pName to false
         set the showBorder of field pName to false
         set the opaque of field pName to false
         set the dontWrap of field pName to (pKind is "label")
         set the text of field pName to pText
         set the uThemeSkip of field pName to true    -- labels sit on the page: text colour only
         break
      case "field"
         create field pName
         set the text of field pName to pText
         break
      case "list"
         create field pName
         set the listBehavior of field pName to true
         set the lockText of field pName to true
         set the dontWrap of field pName to true
         set the vScrollbar of field pName to true
         set the text of field pName to pText
         break
      case "button"
         create button pName
         set the label of button pName to pText
         break
      case "option"
      case "pulldown"
         create button pName
         set the style of button pName to "menu"
         if pKind is "option" then
            set the menuMode of button pName to "option"
         else
            set the menuMode of button pName to "pulldown"
            set the label of button pName to "Menu"
            replace "|" with return in pText
         end if
         set the text of button pName to pText
         break
   end switch
   if pKind is "option" then set the label of button pName to line 1 of pText
   if pKind is among the items of "label,note,field,list" then
      set the rect of field pName to pRect
   else
      set the rect of button pName to pRect
   end if
end TS.Make

-------------------------------------------------------------------- the theme file

-- read themes/<name>.txt: keys in order, values, the whole text (for its comments)
command TS.Load pName
   local tLine, tKey
   if pName is empty then put "dark" into pName
   put pName into sThemeName
   Theme.Use pName
   if the result is not empty then
      TS.Status the result
      exit TS.Load
   end if
   put textDecode(url ("binfile:" & TS.File()), "UTF-8") into sFileText
   put empty into sKeys
   put empty into sVal
   set the itemDelimiter to tab
   repeat for each line tLine in sFileText
      if tLine is empty or char 1 of tLine is "#" then next repeat
      put item 1 of tLine into tKey
      put tKey & return after sKeys
      put item 2 of tLine into sVal[tKey]
   end repeat
   delete the last char of sKeys
   put false into sDirty
   lock messages
   set the label of button "ThemeMenu" of this stack to pName
   unlock messages
   TS.ShowKeys
   TS.Select 1
   TS.ApplyAll
   TS.Status "Loaded" && TS.File()
end TS.Load

function TS.File
   return Theme.Folder() & "/themes/" & sThemeName & ".txt"
end TS.File

command TS.ShowKeys
   local tKey, tOut
   repeat for each line tKey in sKeys
      put tKey & tab & sVal[tKey] & return after tOut
   end repeat
   delete the last char of tOut
   put tOut into field "Keys" of this stack
end TS.ShowKeys

-- line pN of the key list: its swatch, value and the comment lines above it in the file
command TS.Select pN
   local tKey
   if pN is empty or pN < 1 then exit TS.Select
   put line pN of sKeys into tKey
   if tKey is empty then exit TS.Select
   put tKey into sCurKey
   set the hilitedLine of field "Keys" of this stack to pN
   put tKey into field "KeyName" of this stack
   put sVal[tKey] into field "RGB" of this stack
   set the backgroundColor of graphic "Swatch" of this stack to sVal[tKey]
   put TS.CommentFor(tKey) into field "KeyNote" of this stack
end TS.Select

-- the comment block above a key's group (a comment covers the keys under it, up to a blank line)
function TS.CommentFor pKey
   local tLine, tNote, tWasKey
   put false into tWasKey
   set the itemDelimiter to tab
   repeat for each line tLine in sFileText
      if tLine is empty then
         put empty into tNote
      else if char 1 of tLine is "#" then
         if tWasKey then put empty into tNote
         put char 2 to -1 of tLine & return after tNote
         put false into tWasKey
      else if item 1 of tLine is pKey then
         return word 1 to -1 of tNote
      else
         put true into tWasKey
      end if
   end repeat
   return empty
end TS.CommentFor

-- a colour is three whole numbers 0 to 255
function TS.IsRGB pRGB
   local tPart
   if the number of items of pRGB is not 3 then return false
   repeat for each item tPart in pRGB
      if tPart is not an integer then return false
      if tPart < 0 or tPart > 255 then return false
   end repeat
   return true
end TS.IsRGB

command TS.Revert
   TS.Load sThemeName
end TS.Revert

command TS.SetFromField
   TS.SetValue word 1 to -1 of field "RGB" of this stack
end TS.SetFromField

command TS.SetValue pRGB
   local tN
   replace space with empty in pRGB
   if sCurKey is empty then exit TS.SetValue
   if not TS.IsRGB(pRGB) then
      TS.Status "Not a colour: give three numbers 0-255, like 30,30,34"
      exit TS.SetValue
   end if
   put pRGB into sVal[sCurKey]
   Theme.Set sCurKey, pRGB
   put true into sDirty
   put lineOffset(sCurKey, sKeys) into tN
   TS.ShowKeys
   TS.Select tN
   TS.ApplyAll
   TS.Status sCurKey && "=" && pRGB && "(not saved yet: Save writes the file)"
end TS.SetValue

command TS.Pick
   if sCurKey is empty then exit TS.Pick
   answer color with sVal[sCurKey]
   if it is empty then exit TS.Pick
   TS.SetValue it
end TS.Pick

-- write the values back into the file: only the value of each key line changes
command TS.Save
   local tLine, tOut
   set the itemDelimiter to tab
   repeat for each line tLine in sFileText
      if tLine is not empty and char 1 of tLine is not "#" and sVal[item 1 of tLine] is not empty then
         put item 1 of tLine & tab & sVal[item 1 of tLine] into tLine
      end if
      put tLine & return after tOut
   end repeat
   if the last char of sFileText is not return then delete the last char of tOut
   put textEncode(tOut, "UTF-8") into url ("binfile:" & TS.File())
   if the result is not empty then
      TS.Status "Save failed:" && the result
      exit TS.Save
   end if
   put tOut into sFileText
   put false into sDirty
   TS.Status "Saved" && TS.File() && "at" && the long time
end TS.Save

-------------------------------------------------------------------- colouring

-- the whole studio in the theme, then the bits lib_theme leaves alone
command TS.ApplyAll
   local tName, tLabels
   set the defaultStack to the short name of this stack
   lock screen
   Theme.ApplyStack the short name of this stack
   repeat for each item tName in "Title,KeyName,KeyNote,Status,SamplesTitle,BarNote"
      set the foregroundColor of field tName to Theme.Get("text")
   end repeat
   set the foregroundColor of field "KeyNote" to Theme.Get("dim")
   set the backgroundColor of graphic "SampleMenuStrip" to Theme.Get("menuBar")
   -- OXT-Beyond in Windows dark mode draws an option menu's button dark, so the menu rule's dark
   -- text vanishes on it (seen 15 Nov): give this one light text. Open-list colours: still to see.
   if the systemAppearance is "dark" then
      set the foregroundColor of button "ThemeMenu" to Theme.Get("text")
      set the backgroundColor of button "ThemeMenu" to Theme.Get("panel")
   end if
   if sCurKey is not empty then set the backgroundColor of graphic "Swatch" to sVal[sCurKey]
   set the borderColor of graphic "Swatch" to Theme.Get("border")
   put "Scroll bars (A-90). This IDE reports systemAppearance =" && the systemAppearance & \
         ": OXT-Beyond follows Windows' dark mode, so native scroll bars and tabs draw dark (LiveCode 9.6.3 drew them white)." & return & \
         "Left: native.  Middle: native, thin (scrollbarWidth 8).  Right: no bar (vScrollbar false): try the mouse wheel on it." into field "BarNote"
   unlock screen
end TS.ApplyAll

command TS.Status pText
   put pText into field "Status" of this stack
end TS.Status

-- tests: one line
function TS.State
   return sThemeName & "|" & the number of lines of sKeys & "|" & sCurKey & "|" & sVal[sCurKey] & "|" & sDirty
end TS.State
