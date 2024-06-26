                VERSION := "v1.1"
          raw_gui_width := 250
         raw_gui_height := 150
        raw_left_offset := 10
   raw_toggletype_width := 30
raw_toggletype_x_offset := 120
            left_offset := "x" raw_left_offset " "
              gui_width := "w" raw_gui_width
             gui_height := "h" raw_gui_height
      toggle_type_width := " w" raw_toggletype_width
           exitapp_bind := "*!p"

; send mode
sendmode "input"

; old center gui ctrl function
cgc(width) {
    return "x" (raw_gui_width - width) / 2 " "
}

; raw center gui ctrl function
rawcguictrl(controlname, width) {
    controlname.getpos(&getpos_x,, &getpos_width)
    if !isinteger(getpos_width) {
        regexreplace(getpos_width, "x")
    }
    return (getpos_x + (getpos_width - width) / 2)
}

; center gui ctrl function
cguictrl(controlname, width) {
    controlname.getpos(&getpos_x,, &getpos_width)
    return "x" rawcguictrl(controlname, width) " "
}

; raw side calculation function
rawside(controlname, side) {
    controlname.getpos(,,&getpos_width)
    if side = "left" {
        return (raw_gui_width / 4) - (getpos_width / 2)
    } else if side = "right" {
        return (raw_gui_width / 2) + (raw_gui_width / 4) - (getpos_width / 2)
    }
}

; side calculation function
side(controlname, side) {
    return "x" rawside(controlname, side) " "
}

; BOTH GETPOS AND MOVE INTO ONE FUNCTION
fullcguictrl(centeredctrl, refctrl) {
    centeredctrl.getpos(,,&getpos_width)
    centeredctrl.move(rawcguictrl(refctrl,getpos_width))
}

; bottom function
b(y_offset) {
    return "y" raw_gui_height - y_offset
}

; goofy y values
   y_edit := 40
y_credits := 35
  y_other := 110
  y_enter := 40
     y_ac := 75
  y_delay := 110
y(type, extra_offset) {
    return "y" type + extra_offset
}

; SETUP GUI
main := gui("-caption -minimizebox -maximizebox")
main.backcolor := "333845"

; FONT
main.setfont("q2", "Segoe UI")

; TITLE
main.setfont("cwhite s12 bold")
    title := main.addtext("x0 y10 " gui_width " Center", "Selection Screen")

; VELOCITY CALCULATOR
loadvelcalc() {
    VERSION := "v1.2"
    ; SETUP GUI
    main := gui("-caption -minimizebox -maximizebox")
    main.backcolor := "333845"

    ; FONT
    main.setfont("q2", "Segoe UI")

    ; TITLE
    main.setfont("cwhite s12 bold")
        main.addtext("x0 y10 " gui_width " Center", "Velocity Calculator " VERSION)
    ; EDIT BOX AND SUBMIT
    main.setfont("cblack s7 norm")
        mainedit := main.addedit(y(y_edit, 0) " w90")
            mainedit.move(rawside(mainedit, "left"))
    main.setfont("cwhite s7 norm")
        mainedittext := main.addtext(left_offset y(y_edit, 22), "`"ai + bj, ci + dj`" format")
            fullcguictrl(mainedittext, mainedit)
    main.setfont("cwhite s8 norm")
        mainoutputtext := main.addtext("x" raw_left_offset + 5 " " y(y_edit, 37) " w" (raw_gui_width / 2) - (raw_left_offset) + 5, "output:")
    main.setfont("cblack s7 norm")
        mainsubmit := main.addbutton(y(y_edit, 57), "submit")
            fullcguictrl(mainsubmit, mainedit)
            mainsubmit.onevent("click", func_submit)
    main.setfont("cblack s7 norm")
        maindropdown := main.adddropdownlist(y(y_edit, 83), ["Exact Value", "Approximate Value"])
            fullcguictrl(maindropdown, mainedit)
            maindropdown.value := 1

    ; CREDITS
    main.setfont("cwhite s10")
        maincredittitle := main.addtext(y(y_credits, 0), "Credits")
            maincredittitle.move(rawside(maincredittitle, "right"))
    main.setfont("cwhite s7 norm")
        maincreditcreator := main.addtext(y(y_credits, 18), "Anbubu - Creator")
            fullcguictrl(maincreditcreator, maincredittitle)

    main_exitapp(thisGui) {
        exitapp
        return false
    }
    
    func_submit(x, y) {
        str_regexed := regexreplace(mainedit.text, "i|j|\s")
        splstr := strsplit(str_regexed, ",")
        mainoutputtext.text := "output: " dot_product(splstr[1],splstr[2])
    }

    dot_product(a, b) {
        a := strsplit(a, "+")
        b := strsplit(b, "+")
        i1 := a[1]
        i2 := b[1]
        j1 := a[2]
        j2 := b[2]
        return i1 * i2 "i + " j1 * j2 "j"
    }

    ; SHOW
    main.show(gui_width " " gui_height)
}

; ENTER BIND AND AUTOCLICKER
loadenterac() {
    VERSION := "v2.1"

    ; BINDS
    enter_bind := "F2"
    ac_bind := "alt & c"

    ; DECLARATIONS
    global enter_toggle_value := false
    global ac_toggle_value := false
    global enter_realtoggle_value := false
    global ac_realtoggle_value := false
    raw_left_offset := 10
    left_offset := "x" raw_left_offset " "
    delay := 1

    ; SETUP GUI
    main := gui("-caption -minimizebox -maximizebox")
        main.backcolor := "333845"

    ; FONT
    main.setfont("q2", "Segoe UI")

    ; TITLE
    main.setfont("cwhite s12 bold")
        main.addtext("x0 y10 " gui_width " Center", "Autoclicker " VERSION)
    
    ; TOGGLE AND TEXT
    main.setfont("cwhite s7 norm")
        main.addtext(left_offset b(20), "quit ahk script: " exitapp_bind)
        main.addtext(left_offset y(y_enter, 15), "enter macro: " enter_bind)
        main.addtext(left_offset y(y_ac, 15), "autoclicker: " ac_bind)

    ; CREDITS
    main.setfont("cwhite s10")
        maincredittitle := main.addtext("y35", "Credits")
            maincredittitle.move(rawside(maincredittitle, "right"))
    main.setfont("cwhite s7 norm")
        maincreditcreator := main.addtext("y53 w85 h60 Center", "Anbubu - Creator")
            fullcguictrl(maincreditcreator, maincredittitle)

    ; DELAY EDITBOX
    main.setfont("cwhite s7 norm")
        delayheading := main.addtext(y(y_delay, -15) " w85 h60 Center", "Delay")
            fullcguictrl(delayheading, maincredittitle)
    main.setfont("cblack s7 norm")
        mainde := main.addedit(y(y_delay, 0) " w70", delay)
            fullcguictrl(mainde, maincredittitle)
    main.setfont("cwhite s6 norm")
        delayextrainfo := main.addtext(y(y_delay, 22) " w85 h60 Center", "Constantly Updates")
            fullcguictrl(delayextrainfo, maincredittitle)

    ; SET HOTKEY
    main.setfont("cwhite s7 norm")
        mainsh := main.addbutton("y70 Center", "Set Hotkey")
            fullcguictrl(mainsh, maincredittitle)

    ; TOGGLES
    main.setfont("cwhite s10 norm")
        mainenter := main.addcheckbox(left_offset y(y_enter, 0), "Enter Macro")
        mainac := main.addcheckbox(left_offset y(y_ac, 0), "Autoclicker")

    ; TOGGLE TYPES
    main.setfont("cwhite s9 norm")
    /*
        mainentertype := main.adddropdownlist(y(y_enter, 0) toggle_type_width, ["Hold", "Toggle"])
            mainentertype.move(raw_toggletype_x_offset)
            mainentertype.value := 1
        mainactype := main.adddropdownlist(y(y_ac, 0) toggle_type_width, ["Hold", "Toggle"])
            mainactype.move(raw_toggletype_x_offset)
            mainactype.value := 1
    */
        realentertype := "H"
            mainentertype := main.addtext(y(y_enter, 0) toggle_type_width, "[" realentertype "]")
                mainentertype.move(raw_toggletype_x_offset)
        realactype := "H"
            mainactype := main.addtext(y(y_ac, 0) toggle_type_width, "[" realactype "]")
                mainactype.move(raw_toggletype_x_offset)

    ; ONEVENT DECLARATIONS
            enter_toggle := main_toggle.bind(,, enter_bind, enter_macro, enter_toggle_value)
               ac_toggle := main_toggle.bind(,, ac_bind, ac_macro, ac_toggle_value)
        enter_toggletype := main_toggletype.bind(,, realentertype, mainentertype)
           ac_toggletype := main_toggletype.bind(,, realactype, mainactype)
             main.onevent("close", main_exitapp)
        mainenter.onevent("click", enter_toggle)
           mainac.onevent("click", ac_toggle)
    mainentertype.onevent("click", enter_toggletype)
       mainactype.onevent("click", ac_toggletype)

    main_exitapp(thisGui) {
        exitapp
        return false
    }

    main_toggle(x, y, bind, macro, togglevalue) {
        togglevalue := x.value
        hotkey bind, macro, togglevalue
        return
    }

    main_toggletype(x, y, toggletype, guictrltext) {
        if toggletype = "H" {
            toggletype := "T"
        } else if toggletype = "T" {
            toggletype := "H"
        }
        guictrltext.value := "[" toggletype "]"
    }

    enter_macro(thishotkey) {
        if realentertype = "H" {
            while getkeystate(thishotkey, "P") {
                send "{enter}"
                sleep mainde.value
            }
        } else if realentertype = "T" {
            if getkeystate(thishotkey, "P") {
                send "{" thishotkey " up}"
            }
            local realtoggle := false
            enter_realtoggle_value := !enter_realtoggle_value
            while enter_realtoggle_value {
                send "{enter}"
                sleep mainde.value
                if getkeystate(thishotkey, "P") and realtoggle {
                    enter_realtoggle_value := !enter_realtoggle_value
                }
                realtoggle := true
            }
        }
    }

    ac_macro(thishotkey) {
        local thishotkey_split := strsplit(thishotkey, " & ")
        local condition := ""
        keycheck(keys) {
            for i, v in keys {
                if strlower(v) = "alt" and !getkeystate(v) {
                    return false
                } else {
                    if !getkeystate(v, "P") {
                        return false
                    }
                }
            }
            return true
        }
        if realactype = "H" {
            while keycheck(thishotkey_split) {
                click
                click
                click
                sleep mainde.value
            }
        } else if realactype = "T" {
            if keycheck(thishotkey_split) {
                for i, v in thishotkey_split {
                    if strlower(v) = "alt" {
                        a_menumaskkey := "vkA4sc038"
                    }
                    send "{" v " up}"
                }
            }
            local realtoggle := false
            ac_realtoggle_value := !ac_realtoggle_value
            while ac_realtoggle_value {
                click
                click
                click
                sleep mainde.value
                if keycheck(thishotkey_split) and realtoggle {
                    ac_realtoggle_value := !ac_realtoggle_value
                }
                realtoggle := true
            }
        }
    }

    ; SHOW
    main.show(gui_width " " gui_height)
}

unloadvelc(v1, v2) {
    main.destroy()
    loadvelcalc()
}

unloadenter(v1, v2) {
    main.destroy()
    loadenterac()
}

; SELECTION SCREEN
main.setfont("s8 norm")
    velcalc := main.addbutton("y45 w105 vtest", "Velocity Calculator")
        velcalc.move(rawside(velcalc, "left"))
        velcalc.onevent("click", unloadvelc)
    enterac := main.addbutton("y45 w80", "Enter and AC")
        enterac.move(rawside(enterac, "right"))
        enterac.onevent("click", unloadenter)

; SHOW GUI
main.show(gui_width " " gui_height)

; EXITAPP
hotkey exitapp_bind, localexitapp
localexitapp(thishotkey) {
    exitapp
}