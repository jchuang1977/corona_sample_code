display.setStatusBar(display.HiddenStatusBar)

local background = display.newImageRect("Background.png",320,480)
background.x = 160
background.y = 240

local city1 = display.newImageRect( "City1.png", 320, 325 )
city1.x = 160
city1.y = 317

local city2 = display.newImageRect( "City1.png", 320, 325 )
city2.x = 480
city2.y = 317

city1.speed = 2
city2.speed = 2

function scrollMyCity(self,event)
        self.x = self.x - self.speed
        if self.x==-160 then
                self.x = 480
        end
end

city1.enterFrame = scrollMyCity
Runtime:addEventListener("enterFrame", city1)
city2.enterFrame = scrollMyCity
Runtime:addEventListener("enterFrame", city2)

local city3 = display.newImageRect( "City2.png", 320, 258 )
city3.x = 160
city3.y = 351

local city4 = display.newImageRect( "City2.png", 320, 258 )
city4.x = 480
city4.y = 351

local road1 = display.newImageRect( "Road.png", 320, 52 )
road1.x = 160
road1.y = 454

local road2 = display.newImageRect( "Road.png", 320, 52 )
road2.x = 480
road2.y = 454

city3.speed = 4
city4.speed = 4
road1.speed = 5
road2.speed = 5

city3.enterFrame = scrollMyCity
Runtime:addEventListener("enterFrame", city3)
city4.enterFrame = scrollMyCity
Runtime:addEventListener("enterFrame", city4)
road1.enterFrame = scrollMyCity
Runtime:addEventListener("enterFrame", road1)
road2.enterFrame = scrollMyCity
Runtime:addEventListener("enterFrame", road2)

local movieclip = require("movieclip")
local car
car = movieclip.newAnim({"MyCar1.png","MyCar2.png","MyCar3.png",
                        "MyCar4.png","MyCar5.png","MyCar6.png",
                        "MyCar7.png","MyCar8.png","MyCar9.png","MyCar10.png"})
car:setSpeed(.4)
car:setDrag{drag=true}
car:play()
car.x = 83
car.y = 379

local coverMenu = display.newGroup()

local coverBackground = display.newImageRect("CoverBackground.png",320,480)
coverBackground.x = 160
coverBackground.y = 240
coverMenu:insert(coverBackground)

local ui = require("ui")
local onStartTouch =function(event)
        if event.phase =="release" then
                transition.to(coverMenu,{time=300,y=-480})
        end
end
local startBtn = ui.newButton{
        defaultSrc = "CoverButton.png",
        defaultX=232,
        defaultY=68,
        overSrc = "CoverButtonPressed.png",
        overX=232,
        overY=68,
        onEvent = onStartTouch,
}
startBtn.x = 160
startBtn.y = 350
coverMenu:insert(startBtn)

local function startBtnScaleUp()
        local startBtnScaleDown = function()
                transition.to(startBtn,{time=150,xScale=1,yScale=1,onComplete= startBtnScaleUp})
        end
        transition.to(startBtn,{time=150,xScale=1.06,yScale=1.06,onComplete= startBtnScaleDown})
end
startBtnScaleUp()