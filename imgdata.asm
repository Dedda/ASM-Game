section .data

    global img_welcome_screen
    global img_docks
    global img_harbor_plaza

    img_welcome_screen incbin "imgdata/welcome_screen.txt"
                            db 0

    img_docks          incbin "imgdata/docks.txt"
                            db 0

    img_harbor_plaza   incbin "imgdata/harbor_plaza.txt"
                            db 0