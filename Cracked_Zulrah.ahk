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
    return
}

; DEBUGGING - Get Raw Mouse Coordinates
^g::
    MouseGetPos, OutputVarX, OutputVarY
    MsgBox, %OutputVarX%, %OutputVarY%
return

RandomizeVariance() {
    ; Mouse Location (x,y Coordinate) Variance - Int
    Random, rMouseCoordVar, 2, 6
    ; Mouse Movement Speed variance - Float
    Random, rMouseSpeedVar, 1.1, 1.4
    ; Mouse Click Speed variance - Float
    Random rClickSpeedVar, 0.25, 1.25
    ; Random MS sleep time - Int
    Random rSleepTime, 100, 150

    newObject := Object("rMouseCoordVar", rMouseCoordVar, "rMouseSpeedVar", rMouseSpeedVar, "rClickSpeedVar", rClickSpeedVar, "rSleepTimeVar", rSleepTime)

return newObject

}

setAllMouseCoords() {

    ; Reset to empty before pushing coords
    global inventCoords := []
    global prayerCoords := []

    MouseGetPos, currX, currY

    inventCoords.Push({ "itemX": currX, "itemY": currY })
    inventCoords.Push({ "itemX": currX, "itemY": currY+35 })
    inventCoords.Push({ "itemX": currX, "itemY": currY+65 })

    inventCoords.Push({ "itemX": currX+45, "itemY": currY })
    inventCoords.Push({ "itemX": currX+45, "itemY": currY+35 })
    inventCoords.Push({ "itemX": currX+45, "itemY": currY+65 })

    ; invent coords for anti-venom
    inventCoords.Push({ "antiVenomX": currX+120, "antiVenomY": currY+35 })

    ; Protection prayer Coordinates
    prayerCoords.Push({ "protMageX": currX+15, "protMageY": currY+110, "protRangeX": currX+65, "protRangeY": currY+110 })
    ; Offensive prayer Coordinates
    prayerCoords.Push({ "prayRigX": currX+65, "prayRigY": currY+185, "prayAugX": currX+95, "prayAugY": currY+185 })

    ; MsgBox, % "Mouse Coords Set: " inventCoords[1]["itemX"]
return
}

; RIG (with MAGE pray)
PrayRig() {
    global prayerCoords

    randomVariance := RandomizeVariance()
    Random, adtlRandomVariance, 1.1, 1.9

    rCoordVariance := randomVariance["rMouseCoordVar"]

    rMoveSpeed := randomVariance["rMouseSpeedVar"]+adtlRandomVariance

    ; Open Prayer tab 
    Send, {F4}

    ; RIGOUR Coords
    rigCoordX := prayerCoords[2]["prayRigX"]+rCoordVariance
    rigCoordY := prayerCoords[2]["prayRigY"]+rCoordVariance

    ; Pray Rigour
    MouseMove, rigCoordX, rigCoordY, rMoveSpeed
    MouseClick, Left

    ; Return to inventory
    Send, {F1}
return
}

; AUGURY mage prayer (with RANGE pray)
PrayAug() {

    global prayerCoords

    randomVariance := RandomizeVariance()
    Random, adtlRandomVariance, 1.1, 1.9

    rCoordVariance := randomVariance["rMouseCoordVar"]

    rMoveSpeed := randomVariance["rMouseSpeedVar"]+adtlRandomVariance

    ; Open Prayer tab 
    Send, {F4}

    ; Augury Coords
    augCoordX := prayerCoords[2]["prayAugX"]+rCoordVariance
    augCoordY := prayerCoords[2]["prayAugY"]+rCoordVariance

    ; Pray Aug
    MouseMove, augCoordX, augCoordY, rMoveSpeed
    MouseClick, Left

    ; Return to inventory
    Send, {F1}

return
}

; MAGE PRAY
ProtMage() {

    global prayerCoords

    ; MsgBox, % "Global PrayerCoords = " prayerCoords[1]["protMageX"] " " prayerCoords[1]["protMageY"]

    randomVariance := RandomizeVariance()
    Random, adtlRandomVariance, 1.1, 1.9

    ; MsgBox, % "Randomized Variances: " randomVariance["rMouseCoordVar"] ", " randomVariance["rMouseSpeedVar"] ", " randomVariance["rSleepTimeVar"]

    rCoordVariance := randomVariance["rMouseCoordVar"]
    rMoveSpeed := randomVariance["rMouseSpeedVar"]+adtlRandomVariance
    rSleepTimer := randomVariance["rSleepTimeVar"]

    ; MAGE Pray Coords
    mageCoordX := prayerCoords[1]["protMageX"]+rCoordVariance
    mageCoordY := prayerCoords[1]["protMageY"]+rCoordVariance

    ; Hotkey open Prayer tab
    Send, {F4}

    ; Pray Magic
    MouseMove, mageCoordX, mageCoordY, rMoveSpeed
    MouseClick, Left

    Sleep, rSleepTimer

    ; Return to inventory
    Send, {F1}

return 
}

; RANGE PRAY
ProtRange(){

    global prayerCoords

    randomVariance := RandomizeVariance()
    Random, adtlRandomVariance, 1.1, 1.9

    rCoordVariance := randomVariance["rMouseCoordVar"]
    rMoveSpeed := randomVariance["rMouseSpeedVar"]
    rSleepTimer := randomVariance["rSleepTimeVar"]

    ; MAGE Pray Coords
    rangeCoordX := prayerCoords[1]["protRangeX"]
    rangeCoordY := prayerCoords[1]["protRangeY"]

    ; Hotkey open Prayer tab
    Send, {F4}

    ; Pray Magic
    MouseMove, rangeCoordX+rCoordVariance, rangeCoordY+rCoordVariance, rMoveSpeed+adtlRandomVariance
    MouseClick, Left

    Sleep, rSleepTimer
    Send, {F1}

return 
}

switchToRangeGear() {

    global inventCoords

    randomVars := RandomizeVariance()

    ; debugRandomVarianceObject(randomVars)
    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    totalIterations := inventCoords.Length()

    ; Open inventory
    Send, {F1}

    for i in inventCoords {
        Random, adtlRandomVariance, 0.25, .75
        if (i != 4) {
            MouseMove, inventCoords[i]["itemX"]+rCoordVar, inventCoords[i]["itemY"]+rCoordVar, rMoveSpeed+adtlRandomVariance
            MouseClick, Left
        }
    }

return
}

switchToMagicGear() {

    global inventCoords

    randomVars := RandomizeVariance()

    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    totalIterations := inventCoords.Length()

    ; Open inventory
    Send, {F1}

    for i in inventCoords {
        Random, adtlRandomVariance, 0.25, .75

        MouseMove, inventCoords[i]["itemX"]+rCoordVar, inventCoords[i]["itemY"]+rCoordVar, rMoveSpeed+adtlRandomVariance
        MouseClick, Left
    }

return
}

antiVenomSippy() {

    global inventCoords

    randomVars := RandomizeVariance()

    rCoordVar := randomVars["rMouseCoordVar"]
    rMoveSpeed := randomVars["rMouseSpeedVar"]

    antiVenomPosX := inventCoords[7]["antiVenomX"]+rCoordVar
    antiVenomPosY := inventCoords[7]["antiVenomY"]+rCoordVar
    ; Open inventory
    Send, {F1}

    MouseMove, antiVenomPosX, antiVenomPosY, rMoveSpeed
    MouseClick, Left

return
}

; #################
; HOTKEY BINDINGS
; #################

; SET MOUSE COORDS - Gets current mousePos and sets the rest with a hard-coded offset
Numpad0::
    setAllMouseCoords()
return

; Sip Prayer potion
Numpad1::
    ; Prayer Pot sippy
return

; Sip Anti-Venom potion
Numpad2::
    BlockInput, On
    antiVenomSippy()
    BlockInput Off
return 

; Tick eat - shark/karambwan combo (up to 4 iterations)
Numpad3::
    BlockInput, On
    ; Tick Eat
    BlockInput, Off
return

; MAGIC GEAR | Prot Range (Melee/Range form)
Numpad4::
    BlockInput, On
    ProtMage()
    BlockInput, Off
return 

; Pray Rigour (with Range gear against Magic attacks)
Numpad5::
    BlockInput, On
    PrayRig()
    BlockInput, Off
return

; Switch to Range Gear (against Magic attacks with Rigour pray)
Numpad6::
    BlockInput, On
    switchToRangeGear()
    BlockInput, Off
return

; Protect Magic
Numpad7::
    BlockInput, On
    ProtRange()
    BlockInput, Off
return 

; Pray Augory (with Magic gear against Range attacks)
Numpad8::
    BlockInput, On
    PrayAug()
    BlockInput, Off
return

; Switch to Mage Gear (against Range attacks with Aug pray)
Numpad9::
    BlockInput, On
    switchToMagicGear()
    BlockInput, Off
return

NumpadAdd::
    BlockInput, On
    randomVariances := RandomizeVariance()
    rMoveSpeed := randomVariances["rMouseSpeedVar"]
    rCoordVar := randomVariances["rMouseCoordVar"]

    ; Store starting mouse Pos. to return it after
    MouseGetPos, startingPosX, startingPosY

    ProtRange()
    PrayAug()
    switchToMagicGear()

    MouseMove, startingPosX, startingPosY, rMoveSpeed
    BlockInput, Off

return

NumpadEnter::
    BlockInput, On
    randomVariances := RandomizeVariance()
    rMoveSpeed := randomVariances["rMouseSpeedVar"]
    rCoordVar := randomVariances["rMouseCoordVar"]

    ; Store starting mouse Pos. to return it after
    MouseGetPos, startingPosX, startingPosY

    ProtMage()
    PrayRig()
    switchToRangeGear()

    MouseMove, startingPosX, startingPosY, rMoveSpeed
    BlockInput, Off

return