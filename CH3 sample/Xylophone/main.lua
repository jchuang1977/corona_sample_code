display.setStatusBar(display.HiddenStatusBar)
local backgroundImage = display.newImageRect("Background.png",480,320)
backgroundImage.x = 240
backgroundImage.y = 160

local mySound1 = audio.loadSound("S1.mp3") 
local mySound2 = audio.loadSound("S2.mp3") 
local mySound3 = audio.loadSound("S3.mp3") 
local mySound4 = audio.loadSound("S4.mp3") 
local mySound5 = audio.loadSound("S5.mp3") 
local mySound6 = audio.loadSound("S6.mp3") 
local mySound7 = audio.loadSound("S7.mp3") 
local mySound8 = audio.loadSound("S8.mp3")

local ui = require("ui")

local on1Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound1)
    end
end

local sound1Button = ui.newButton{
    defaultSrc = "1.png",
    defaultX=51,
    defaultY=224,
    overSrc = "1P.png",
    overX=51,
    overY=224,
    onEvent = on1Touched,
}



local on2Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound2)
    end
end

local sound2Button = ui.newButton{
    defaultSrc = "2.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "2P.png",     
    overX=51,               
    overY=224,              
    onEvent = on2Touched,   
}

local on3Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound3)
    end
end

local sound3Button = ui.newButton{
    defaultSrc = "3.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "3P.png",     
    overX=51,               
    overY=224,              
    onEvent = on3Touched,   
}

local on4Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound4)
    end
end

local sound4Button = ui.newButton{
    defaultSrc = "4.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "4P.png",     
    overX=51,               
    overY=224,              
    onEvent = on4Touched,   
}

local on5Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound5)
    end
end

local sound5Button = ui.newButton{
    defaultSrc = "5.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "5P.png",     
    overX=51,               
    overY=224,              
    onEvent = on5Touched,   
}

local on6Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound6)
    end
end

local sound6Button = ui.newButton{
    defaultSrc = "6.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "6P.png",     
    overX=51,               
    overY=224,              
    onEvent = on6Touched,   
}

local on7Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound7)
    end
end

local sound7Button = ui.newButton{
    defaultSrc = "7.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "7P.png",     
    overX=51,               
    overY=224,              
    onEvent = on7Touched,   
}

local on8Touched = function(event)
    if event.phase == "press" then
        audio.play(mySound8)
    end
end

local sound8Button = ui.newButton{
    defaultSrc = "8.png",   
    defaultX=51,            
    defaultY=224,           
    overSrc = "8P.png",     
    overX=51,               
    overY=224,              
    onEvent = on8Touched,   
}

local startingX = 37
local startingY = 131
local myPadding = 58
sound1Button.x = startingX
sound1Button.y = startingY
sound2Button.x = startingX + myPadding*1
sound2Button.y = startingY 
sound3Button.x = startingX + myPadding*2
sound3Button.y = startingY 
sound4Button.x = startingX + myPadding*3
sound4Button.y = startingY 
sound5Button.x = startingX + myPadding*4
sound5Button.y = startingY 
sound6Button.x = startingX + myPadding*5
sound6Button.y = startingY 
sound7Button.x = startingX + myPadding*6
sound7Button.y = startingY 
sound8Button.x = startingX + myPadding*7
sound8Button.y = startingY

