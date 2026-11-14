# LIB_THEME

One look for every stack we build (the owner, 2026-11-14: "a style sheet to run once before
building any stacks, or to call on by any stack scripts, for a unified IMGUI kind of look").

| Where | What |
|---|---|
| `themes/dark.txt`, `themes/light.txt` | the colours, `key <tab> r,g,b`: plain text any tool can read |
| `livecode/lib_theme.livecodescript` | `Theme.Use`, `Theme.Begin` / `Theme.End` (templates reset), `Theme.ApplyStack`, `Theme.Apply`, `Theme.Get`, `Theme.MenuBar` |

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
A control with the custom property `uThemeSkip` = true is left alone (hand-coloured graphics).
Used by: LIB_BIT/editor (BitEditor).
