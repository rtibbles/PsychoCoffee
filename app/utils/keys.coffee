define ->

    keys = {
        "backspace" : 8
        "tab" : 9
        "enter" : 13
        "shift": 16
        "ctrl": 17
        "alt": 18
        "escape" : 27
        "space": 32
        "page_up" : 33
        "page_down" : 34
        "end" : 35
        "home" : 36
        "insert" : 45
        "delete" : 46
        "0" : 48
        "1" : 49
        "2" : 50
        "3" : 51
        "4" : 52
        "5" : 53
        "6" : 54
        "7" : 55
        "8" : 56
        "9" : 57
        "a" : 65
        "b" : 66
        "c" : 67
        "d" : 68
        "e" : 69
        "f" : 70
        "g" : 71
        "h" : 72
        "i" : 73
        "j" : 74
        "k" : 75
        "l" : 76
        "m" : 77
        "n" : 78
        "o" : 79
        "p" : 80
        "q" : 81
        "r" : 82
        "s" : 83
        "t" : 84
        "u" : 85
        "v" : 86
        "w" : 87
        "x" : 88
        "y" : 89
        "z" : 90
        "numpad0" : 96
        "numpad1" : 97
        "numpad2" : 98
        "numpad3" : 99
        "numpad4" : 100
        "numpad5" : 101
        "numpad6" : 102
        "numpad7" : 103
        "numpad8" : 104
        "numpad9" : 105
        "numpad*" : 106
        "numpad+" : 107
        "numpad-" : 109
        "numpad." : 110
        "numpad/" : 111
        "f1" : 112
        "f2" : 113
        "f3" : 114
        "f4" : 115
        "f5" : 116
        "f6" : 117
        "f7" : 118
        "f8" : 119
        "f9" : 120
        "f10" : 121
        "f11" : 122
        "f12" : 123
        "num_lock" : 144
        "scroll_lock" : 145
        ";" : 186
        "=" : 187
        "," : 188
        "-" : 189
        "." : 190
        "/" : 191
        "[" : 219
        "\\" : 220
        "]" : 221
        "'" : 222
    }

    delete_text = (text) ->
        text.slice 0, -1

    dummy = (text) ->
        text

    keysToText = {
        "backspace": delete_text
        "tab" : "\t"
        "enter" : "\n"
        "delete" : delete_text
        "space": " "
        "shift": dummy
        "ctrl": dummy
        "alt": dummy
        "escape" : dummy
        "page_up" : dummy
        "page_down" : dummy
        "end" : dummy
        "home" : dummy
        "insert" : dummy
        "numpad0" : dummy
        "numpad1" : dummy
        "numpad2" : dummy
        "numpad3" : dummy
        "numpad4" : dummy
        "numpad5" : dummy
        "numpad6" : dummy
        "numpad7" : dummy
        "numpad8" : dummy
        "numpad9" : dummy
        "numpad*" : dummy
        "numpad+" : dummy
        "numpad-" : dummy
        "numpad." : dummy
        "numpad/" : dummy
        "f1" : dummy
        "f2" : dummy
        "f3" : dummy
        "f4" : dummy
        "f5" : dummy
        "f6" : dummy
        "f7" : dummy
        "f8" : dummy
        "f9" : dummy
        "f10" : dummy
        "f11" : dummy
        "f12" : dummy
        "num_lock" : dummy
        "scroll_lock" : dummy
    }


    Keys: keys
    KeysToText: keysToText