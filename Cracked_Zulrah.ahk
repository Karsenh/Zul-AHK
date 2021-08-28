; #################
; Global Vars
; #################
CoordMode, Mouse, Relative

inventCoords := Array()
inventCoords := []

prayerCoords := Array()
prayerCoords := []

antiVenomCoords := Array()
antiVenomCoords := []

; #################
; HELPER FUNCTIONS
; #################

; DEBUGGING randomVariance numbers Object
debugRandomVarianceObject(testObject) {
    MsgBox, % "Test Object rMouseCoordVar = " testObject["rMouseCoordVar"]
    MsgBox, % "Test Object rMouseSpeedVar = " testObject["rMouseSpeedVar"]
    MsgBox, % "Test Object rClickSpeedVar = " testObject["rClickSpeedVar"]
}

; DEBUGGING - Get Raw Mouse Coordinates
^g::
    MouseGetPos, OutputVarX, OutputVarY
    MsgBox, %OutputVarX%, %OutputVarY%
return

RandomizeVariance() {
    ; Mouse Location (x,y Coordinate) Variance
    Random, rMouseCoordVar, 2, 6
    ; Mouse Movement Speed variance - FLOAT?
    Random, rMouseSpeedVar, 1.2, 1.5
    ; Mouse Click Speed variance - INT
    Random rClickSpeedVar, 0.25, 1.25
    ; Random MS sleep time
    Random rSleepTime, 100, 150

    randomNums := Object("rMouseCoordVar", rMouseCoordVar, "rMouseSpeedVar", rMouseSpeedVar, "rClickSpeedVar", rClickSpeedVar, "rSleepTimeVar", rSleepTime)

return randomNums 
}

; #################
; HOTKEY BINDINGS
; #################

; SET MOUSE COORDS - Gets current mousePos and sets the rest with a hard-coded offset
NumpadEnter::
    inventCoords := []
    prayerCoords := []
    MouseGetPos, currX, currY

    inventCoords.Push({ "itemX": currX, "itemY": currY })
    inventCoords.Push({ "itemX": currX, "itemY": currY+35 })
    inventCoords.Push({ "itemX": currX, "itemY": currY+65 })

    inventCoords.Push({ "itemX": currX+45, "itemY": currY })
    inventCoords.Push({ "itemX": currX+45, "itemY": currY+35 })
    inventCoords.Push({ "itemX": currX+45, "itemY": currY+65 })

    ; inventory coords for anti-venom
    antiVenomCoords.Push({ "antiVenomX": currX+120, "antiVenomY": currY+35 })

    ; Protection prayer Coordinates
    prayerCoords.Push({ "protMageX": currX+15, "protMageY": currY+110, "protRangeX": currX+45, "protRangeY": currY+110 })
    ; Offensive prayer Coordinates
    prayerCoords.Push({ "prayRigX": currX+65, "prayRigY": currY+185, "prayAugX": currX+95, "prayAugY": currY+185 })

return

; PRAY against MAGE
ProtMage() {
    BlockInput, On

    randomVariance := RandomizeVariance()
    Random, adtlRandomVariance, 1.1, 1.9

    global prayerCoords

    rCoordVariance := randomVariance["rMouseCoordVar"]
    rMoveSpeed := randomVariance["rMouseSpeedVar"]
    rSleepTimer := randomVariance["rSleepTimeVar"]

    ; MAGE Pray Coords
    mageCoordX := prayerCoords[1]["protMageX"]
    mageCoordY := prayerCoords[1]["protMageY"]

    ; RIGOUR Coords
    rigCoordX := prayerCoords[2]["prayRigX"]
    rigCoordY := prayerCoords[2]["prayRigY"]

    ; Hotkey open Prayer tab
    Send, {F4}

    ; Pray Magic
    MouseMove, mageCoordX+rCoordVariance, mageCoordY+rCoordVariance, rMoveSpeed+adtlRandomVariance
    MouseClick, Left

    ; Pray Rigour
    MouseMove, rigCoordX+rCoordVariance, rigCoordY+rCoordVariance, rMoveSpeed+adtlRandomVariance
    MouseClick, Left

    Sleep, rSleepTimer
    Send, {F1}
    BlockInput, Off

return 
}

; PRAY against RANGE
ProtRange(){
    BlockInput, On
    randomVariance := RandomizeVariance()
    Random, adtlRandomVariance, 1.1, 1.9

    global prayerCoords

    rCoordVariance := randomVariance["rMouseCoordVar"]
    rMoveSpeed := randomVariance["rMouseSpeedVar"]
    rSleepTimer := randomVariance["rSleepTimeVar"]

    ; MAGE Pray Coords
    rangeCoordX := prayerCoords[1]["protRangeX"]
    rangeCoordY := prayerCoords[1]["protRangeY"]

    ; RIGOUR Coords
    augCoordX := prayerCoords[2]["prayAugX"]
    augCoordY := prayerCoords[2]["prayAugY"]

    ; Hotkey open Prayer tab
    Send, {F4}

    ; Pray Magic
    MouseMove, rangeCoordX+rCoordVariance, rangeCoordY+rCoordVariance, rMoveSpeed+adtlRandomVariance
    MouseClick, Left

    ; Pray Rigour
    MouseMove, augCoordX+rCoordVariance, augCoordY+rCoordVariance, rMoveSpeed+adtlRandomVariance
    MouseClick, Left

    Sleep, rSleepTimer
    Send, {F1}
    BlockInput, Off

return 
}

; RANGE GEAR | Prot Mage (Mage form)
Numpad8::
    BlockInput, On
    randomVars := RandomizeVariance()

    ; debugRandomVarianceObject(randomVars)
    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    totalIterations := inventCoords.Length()

    for i in inventCoords {
        Random, adtlRandomVariance, 0.25, .75
        if (i != 4) {
            MouseMove, inventCoords[i]["itemX"]+rCoordVar, inventCoords[i]["itemY"]+rCoordVar, rMoveSpeed+adtlRandomVariance
            MouseClick, Left
        }
    }

    ProtMage()
    BlockInput, Off

return 

; MAGIC GEAR | Prot Range (Melee/Range form)
Numpad7::
    BlockInput, On

    randomVars := RandomizeVariance()

    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    totalIterations := inventCoords.Length()

    for i in inventCoords {
        Random, adtlRandomVariance, 0.25, .75

        MouseMove, inventCoords[i]["itemX"]+rCoordVar, inventCoords[i]["itemY"]+rCoordVar, rMoveSpeed+adtlRandomVariance
        MouseClick, Left
    }

    ProtRange()
    BlockInput, Off

return 

; Toggle Prayer: Prot Magic | Rigour
Numpad4::
    BlockInput, On
    ProtRange()
    BlockInput, Off

return

; Toggle Prayer: Prot Range | Aug
Numpad5::
    BlockInput, On
    ProtMage()
    BlockInput, Off
return

; Sip Anti-venom
NumpadAdd::
    BlockInput, On
    global antiVenomCoords
    randomVars := RandomizeVariance()

    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    ; MsgBox, % "Moving mouse to XY pos: " antiVenomCoords[1]["antiVenomX"] " " antiVenomCoords[1]["antiVenomY"]

    MouseMove, antiVenomCoords[1]["antiVenomX"]+rCoordVar, antiVenomCoords[1]["antiVenomY"]+rCoordVar, rMoveSpeed
    MouseClick, Left
    BlockInput, Off
return

; Switch to Magic gear
Numpad1::
    BlockInput, On

    randomVars := RandomizeVariance()

    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    totalIterations := inventCoords.Length()

    for i in inventCoords {
        Random, adtlRandomVariance, 0.25, .75

        MouseMove, inventCoords[i]["itemX"]+rCoordVar, inventCoords[i]["itemY"]+rCoordVar, rMoveSpeed+adtlRandomVariance
        MouseClick, Left
    }
    BlockInput, Off

return

; Switch to Range gear
Numpad2::
    BlockInput, On
    randomVars := RandomizeVariance()

    ; debugRandomVarianceObject(randomVars)
    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    totalIterations := inventCoords.Length()

    for i in inventCoords {
        Random, adtlRandomVariance, 0.25, .75
        if (i != 4) {
            MouseMove, inventCoords[i]["itemX"]+rCoordVar, inventCoords[i]["itemY"]+rCoordVar, rMoveSpeed+adtlRandomVariance
            MouseClick, Left
        }
    }
    BlockInput, Off
return