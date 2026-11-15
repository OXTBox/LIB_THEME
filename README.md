# LIB_THEME

One look for every stack we build (the owner, 2026-11-14: "a style sheet to run once before
building any stacks, or to call on by any stack scripts, for a unified IMGUI kind of look").

| Where | What |
|---|---|
| `themes/dark.txt`, `themes/light.txt` | the colours, `key <tab> r,g,b`: plain text any tool can read |
| `livecode/lib_theme.livecodescript` | `Theme.Use`, `Theme.Begin` / `Theme.End` (templates reset), `Theme.ApplyStack`, `Theme.Apply`, `Theme.Get`, `Theme.MenuBar`, `Theme.TabStrip` / `Theme.TabSelect` |

```
start using stack ".../LIB_THEME/livecode/lib_theme.livecodescript"
Theme.Use "dark"
Theme.Begin                 -- reset every template<object> first
... create the stack and its controls ...
Theme.MenuBar "MyStack", 0, 0, 1140, 30
Theme.ApplyStack "MyStack"
Theme.End
```

**The menu rule:** Windows draws a pulldown's list on a light background using the button's
text colour, so menu text is always dark (`menuText`) on a light face (`menuFace`), sitting on a
light menu-bar strip. Light text on menus is how the BitEditor's menus became grey-on-white.
**The tab rule (the owner, 2026-11-15):** the native tab control (a button with menuMode
"tabbed") is light grey on white whatever its colours. Do not use it. `Theme.TabStrip "Map",
"1bit" & cr & "Cells", left, top, tabWidth, tabHeight` draws the tabs (one locked field each,
named `tab_<strip>_<n>`); a click sends `tabPick <strip>, <tab name>` to the card;
`Theme.TabSelect "Map", "Cells"` shows the selection (each tab carries its two looks in custom
properties, so a built stack needs no library for it). Put a panel-coloured page under them.

A control with the custom property `uThemeSkip` = true is left alone (hand-coloured graphics).
Used by: LIB_BIT/editor (BitEditor).
