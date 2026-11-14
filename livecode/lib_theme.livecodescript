script "lib_theme"
######################################################################################
## lib_theme (LIB_THEME, 11 14 2026): one look for every stack we build (the owner: "a style
## sheet to run once before building any stacks, or to call on by any stack scripts, for a
## unified IMGUI kind of look").
##   start using stack ".../LIB_THEME/livecode/lib_theme.livecodescript"
##   Theme.Use "dark"                 load themes/dark.txt (the default; "light" too)
##   Theme.Begin                      before building: templates reset (no leftovers)
##   ... create controls ...
##   Theme.ApplyStack "MyStack"       colour every card and control by its type
##   Theme.End                        templates reset again
##   Theme.Get("panel")               one colour, "r,g,b"
##   Theme.Apply the long id of field "X"   one control
##   Theme.MenuBar "MyStack", 0, 0, 1140, 28   a light strip for pulldown menus to sit on
## THE MENU RULE: Windows draws a pulldown's list on a light background with the button's
## text colour, so menus get dark text (menuText) on a light face (menuFace), never light text.
######################################################################################

local sTheme, sName

command Theme.Use pName
   local tPath, tLine
   if pName is empty then put "dark" into pName
   put Theme.Folder() & "/themes/" & pName & ".txt" into tPath
   if there is not a file tPath then return "theme not found:" && tPath
   put empty into sTheme
   put pName into sName
   set the itemDel to tab
   repeat for each line tLine in textDecode(URL ("binfile:" & tPath), "UTF-8")
      if tLine is empty or char 1 of tLine is "#" then next repeat
      put item 2 of tLine into sTheme[item 1 of tLine]
   end repeat
   return empty
end Theme.Use

function Theme.Get pKey
   if sTheme is empty then Theme.Use "dark"
   return sTheme[pKey]
end Theme.Get

function Theme.Name
   return sName
end Theme.Name

-- the LIB_THEME folder (this script is in its livecode/ folder)
function Theme.Folder
   local tPath
   put the effective filename of stack "lib_theme" into tPath
   set the itemDel to "/"
   return item 1 to -3 of tPath
end Theme.Folder

-- templates are shared by every create command: reset them before and after building
command Theme.Begin
   Theme.ResetTemplates
end Theme.Begin

command Theme.End
   Theme.ResetTemplates
end Theme.End

command Theme.ResetTemplates
   reset the templateStack
   reset the templateCard
   reset the templateButton
   reset the templateField
   reset the templateGraphic
   reset the templateGroup
   reset the templateImage
   reset the templateScrollbar
   reset the templatePlayer
end Theme.ResetTemplates

-- every card and control of a stack, by type
command Theme.ApplyStack pStack
   local c, n, tCard
   if sTheme is empty then Theme.Use "dark"
   set the backgroundColor of stack pStack to Theme.Get("bg")
   set the foregroundColor of stack pStack to Theme.Get("text")
   set the hiliteColor of stack pStack to Theme.Get("hilite")
   put 1 into c
   repeat while c <= the number of cards of stack pStack
      put the long id of card c of stack pStack into tCard
      put 1 into n
      repeat while n <= the number of controls of tCard
         Theme.Apply the long id of control n of tCard
         add 1 to n
      end repeat
      add 1 to c
   end repeat
end Theme.ApplyStack

-- one control; a custom property uThemeSkip = true leaves it alone (hand-coloured graphics)
command Theme.Apply pObj
   local tType
   if the uThemeSkip of pObj is true then exit Theme.Apply
   put word 1 of the name of pObj into tType
   switch tType
      case "field"
         set the backgroundColor of pObj to Theme.Get("panel")
         set the foregroundColor of pObj to Theme.Get("text")
         set the borderColor of pObj to Theme.Get("border")
         set the hiliteColor of pObj to Theme.Get("hilite")
         set the threeD of pObj to false
         set the showFocusBorder of pObj to false
         break
      case "button"
         if the style of pObj is "menu" and the menuMode of pObj is among the words of "pulldown popup option comboBox cascade" then
            -- the menu rule (see the top)
            set the backgroundColor of pObj to Theme.Get("menuFace")
            set the foregroundColor of pObj to Theme.Get("menuText")
         else
            set the backgroundColor of pObj to Theme.Get("panel")
            set the foregroundColor of pObj to Theme.Get("text")
         end if
         set the borderColor of pObj to Theme.Get("border")
         set the hiliteColor of pObj to Theme.Get("hilite")
         set the threeD of pObj to false
         set the showFocusBorder of pObj to false
         break
      case "scrollbar"
         set the backgroundColor of pObj to Theme.Get("panel")
         set the foregroundColor of pObj to Theme.Get("text")
         break
      case "group"
         set the borderColor of pObj to Theme.Get("border")
         break
   end switch
end Theme.Apply

-- a light strip behind pulldown menus (an IMGUI-style menu bar)
command Theme.MenuBar pStack, pLeft, pTop, pRight, pBottom
   local tG
   if there is a graphic "Theme.MenuBar" of card 1 of stack pStack then delete graphic "Theme.MenuBar" of card 1 of stack pStack
   set the defaultStack to pStack
   create graphic "Theme.MenuBar"
   put it into tG
   set the style of tG to "rectangle"
   set the filled of tG to true
   set the lineSize of tG to 0
   set the backgroundColor of tG to Theme.Get("menuBar")
   set the foregroundColor of tG to Theme.Get("menuBar")
   set the rect of tG to pLeft, pTop, pRight, pBottom
   set the uThemeSkip of tG to true
   set the layer of tG to 1
   return tG
end Theme.MenuBar
