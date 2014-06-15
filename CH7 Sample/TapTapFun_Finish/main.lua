display.setStatusBar(display.HiddenStatusBar)
local ui = require("ui")
local physics = require "physics"
physics.start()

local mainTouchLayer
local selectMenu
local decolayer
local menuArrowBtn, buttomBar
local rightNowImage = 1
local isMenuDown = false
local isIPhone5 = false
local backgroundMusic = audio.loadStream("BackgroundMusic.mp3")
local starSound = audio.loadSound("Star.mp3")
local heartSound = audio.loadSound("Heart.mp3")
local flowerSound = audio.loadSound("Flower.mp3")
local rainSound1 = audio.loadSound("Rain1.mp3")
local rainSound2 = audio.loadSound("Rain2.mp3")
local circleSound = audio.loadSound("Circle.mp3")
local musicSound1 = audio.loadSound("Music1.mp3")
local musicSound2 = audio.loadSound("Music2.mp3")
local buttonPressed = audio.loadSound("ButtonPressed.mp3")
local drawBackground
local addSelectMenu
local addDecolayer
local moveMyMenu 
local makeSomething
local checkOutIfItsIPhone5
local playBackgroundMusic,onCollision
local giveMeStar
local giveMeHeart
local giveMeFlower
local giveMeRain
local giveMeCircle 
local giveMeMusic

local main = function()
	checkOutIfItsIPhone5()
	drawBackground()
	addSelectMenu()
	addDecolayer()
	playBackgroundMusic()
	physics.addBody(bottomBar,"static",{density = 1.0, friction = 0.3, bounce=0.4})
	Runtime:addEventListener("touch", makeSomething)
	Runtime:addEventListener("collision", onCollision)
end

--下面定義其他的函式
checkOutIfItsIPhone5 = function()
	if display.contentScaleX ==0.5 
		and display.contentScaleY == 0.5 
		and display.contentWidth == 320 
		and display.contentHeight == 568 then
		isIPhone5 = true
	end
end

drawBackground = function()
	if isIPhone5 then
		local background = display.newImageRect("BackgroundiPhone5.png",320,568)
		background.x = 160
		background.y = 284
	else
		local background = display.newImageRect("Background.png",320,480)
		background.x = 160
		background.y = 240
	end
end

addSelectMenu = function()
	--init mainTouchLayer
	mainTouchLayer = display.newGroup()

	--init select menu
	selectMenu = display.newGroup()

	--place menu background
	local selectMenuImage = display.newImageRect("Menu.png",320,185)
	selectMenu:insert(selectMenuImage)

	if isIPhone5 then
		selectMenu.x = 160
		selectMenu.y = 44
	else
		selectMenu.x = 160
		selectMenu.y = -31.7
	end

	--place menu arrow button
	local onMenuArrowTouch = function(event)
		if event.phase == "release" then
			moveMyMenu()
		end
	end
		
	menuArrowBtn = ui.newButton{
		defaultSrc = "MenuArrow.png",
		defaultX=35,
		defaultY=42,
		overSrc = "MenuArrow_Pressed.png",
		overX=35,
		overY=42,
		onEvent = onMenuArrowTouch,
	}
	menuArrowBtn.x = 106
	menuArrowBtn.y = 58
	selectMenu:insert(menuArrowBtn)

	--place menu star button
	local menuStarBtn
	local onMenuStarTouch = function(event)
		if event.phase == "release" then
			rightNowImage = 1
			moveMyMenu()
		end
	end
			
	menuStarBtn = ui.newButton{
		defaultSrc = "MenuStar.png",
		defaultX=42,
		defaultY=40,
		overSrc = "MenuStar_Pressed.png",
		overX=42,
		overY=40,
		onEvent = onMenuStarTouch,
	}
	menuStarBtn.x = -105
	menuStarBtn.y = -60
	selectMenu:insert(menuStarBtn)

	--place menu heart button
	local menuHeartBtn
	local onMenuHeartTouch = function(event)
		if event.phase == "release" then
			rightNowImage = 2
			moveMyMenu()
		end
	end
		
	menuHeartBtn = ui.newButton{
		defaultSrc = "MenuHeart.png",
		defaultX=46,
		defaultY=41,
		overSrc = "MenuHeart_Pressed.png",
		overX=46,
		overY=41,
		onEvent = onMenuHeartTouch,
	}
	menuHeartBtn.x = 0
	menuHeartBtn.y = -60
	selectMenu:insert(menuHeartBtn)

	--place menu flower button
	local menuFlowerBtn
	local onMenuFlowerTouch = function(event)
		if event.phase == "release" then
			rightNowImage = 3
			moveMyMenu()
		end
	end
		
	menuFlowerBtn = ui.newButton{
		defaultSrc = "MenuFlower.png",
		defaultX=48,
		defaultY=44,
		overSrc = "MenuFlower_Pressed.png",
		overX=48,
		overY=44,
		onEvent = onMenuFlowerTouch,
	}
	menuFlowerBtn.x = 106
	menuFlowerBtn.y = -62
	selectMenu:insert(menuFlowerBtn)

	--place menu rain button
	local menuRainBtn
	local onMenuRainTouch = function(event)
		if event.phase == "release" then
			rightNowImage = 4
			moveMyMenu()
		end
	end
		
	menuRainBtn = ui.newButton{
		defaultSrc = "MenuRain.png",
		defaultX=27,
		defaultY=41,
		overSrc = "MenuRain_Pressed.png",
		overX=27,
		overY=41,
		onEvent = onMenuRainTouch,
	}
	menuRainBtn.x = -105
	menuRainBtn.y = -1
	selectMenu:insert(menuRainBtn)

	--place menu circle button
	local menuCircleBtn
	local onMenuCircleTouch = function(event)
		if event.phase == "release" then
			rightNowImage = 5
			moveMyMenu()
		end
	end
		
	menuCircleBtn = ui.newButton{
		defaultSrc = "MenuCircle.png",
		defaultX=38,
		defaultY=39,
		overSrc = "MenuCircle_Pressed.png",
		overX=38,
		overY=39,
		onEvent = onMenuCircleTouch,
	}
	menuCircleBtn.x = 0
	menuCircleBtn.y = -2
	selectMenu:insert(menuCircleBtn)

	--place menu music button
	local menuMusicBtn
	local onMenuMusicTouch = function(event)
		if event.phase == "release" then
			rightNowImage = 6
			moveMyMenu()
		end
	end
		
	menuMusicBtn = ui.newButton{
		defaultSrc = "MenuMusic.png",
		defaultX=35,
		defaultY=42,
		overSrc = "MenuMusic_Pressed.png",
		overX=35,
		overY=42,
		onEvent = onMenuMusicTouch,
	}
	menuMusicBtn.x = 104
	menuMusicBtn.y = -2
	selectMenu:insert(menuMusicBtn)
end

moveMyMenu = function()
	audio.play(buttonPressed)
	if isIPhone5 then
		if isMenuDown then
			menuArrowBtn.rotation=0
			transition.to(selectMenu,{time=800, y=44, transition = easing.outExpo,onComplete = function() isMenuDown = false end})
		else
			menuArrowBtn.rotation=180
			transition.to(selectMenu,{time=800, y=164.5, transition = easing.outExpo,onComplete = function() isMenuDown = true end})
		end
	else
		if isMenuDown then
			menuArrowBtn.rotation=0
			transition.to(selectMenu,{time=800, y=-31.7, transition = easing.outExpo,onComplete = function ()isMenuDown = false end})
		else
			menuArrowBtn.rotation=180
			transition.to(selectMenu,{time=800, y=92.5, transition = easing.outExpo,onComplete = function() isMenuDown = true end})
		end
	end	
end

addDecolayer = function()
	decolayer = display.newGroup()
	bottomBar = display.newImageRect("ButtonBar.png",320,66)
	if isIPhone5 then
		bottomBar.x = 160
		bottomBar.y = 568-33
	else
		bottomBar.x = 160
		bottomBar.y = 480-33
	end

	decolayer:insert(bottomBar)

	if isIPhone5 then
		local topBar = display.newImageRect("TopBar.png",320,72)
		topBar.x = 160
		topBar.y = 72/2
		decolayer:insert(topBar)
	end
end

makeSomething = function(event)
	if isMenuDown then
		return
	end
	if isIPhone5 then
		if event.y<72 then
			return
		end
		if event.x>210 and event.y<132 then
			return
		end 
	else
		if event.x>210 and event.y<60 then
			return
		end
	end
	if event.phase == "began" and mainTouchLayer.numChildren<11 then
		if rightNowImage ==1 then
			giveMeStar(event.x,event.y)
		elseif rightNowImage ==2 then
			giveMeHeart(event.x,event.y)
		elseif rightNowImage ==3 then
			giveMeFlower(event.x,event.y)
		elseif rightNowImage ==4 then
			giveMeRain(event.x,event.y)
		elseif rightNowImage ==5 then
			giveMeCircle(event.x,event.y)
		elseif rightNowImage ==6 then
			giveMeMusic(event.x,event.y)
		end
	end
end

giveMeStar = function(xPosition,yPosition)
	audio.play(starSound)
	local star = display.newImageRect("Star.png",125,120)
	star.x = xPosition
	star.y = yPosition
	transition.to (star,{time=2000, x= star.x+5, y = star.y+5,rotation = 1080, onComplete = function() star:removeSelf() end})
	mainTouchLayer:insert(star)
end

giveMeHeart = function(xPosition,yPosition)
	audio.play(heartSound)
	local velocity = 0.1
	local heart = display.newImageRect("Heart.png",120,93)
	heart.x = xPosition
	heart.y = yPosition
	if isIPhone5 then
		transition.to (heart,{time=(618-yPosition)/velocity,y = 618, onComplete = function() heart:removeSelf() end})
	else
		transition.to (heart,{time=(530-yPosition)/velocity,y = 530, onComplete = function() heart:removeSelf() end})
	end
	mainTouchLayer:insert(heart)
end

giveMeFlower = function(xPosition,yPosition)
	audio.play(flowerSound)
	local flower = display.newImageRect("Flower.png",134,136)
	flower.x = xPosition
	flower.y = yPosition
	flower:scale(0.1,0.1)

	function fadeMyFlower()
		transition.to (flower,{time=500,xScale = 1.5, yScale = 1.5,alpha = 0,onComplete = function() flower:removeSelf() end})
	end
	transition.to (flower,{time=1500,xScale = 1, yScale = 1, transition = easing.outExpo,onComplete = fadeMyFlower})
	mainTouchLayer:insert(flower)
end

giveMeRain = function(xPosition,yPosition)
	audio.play(rainSound1)
	local rain = display.newImageRect("Rain1.png",123,79)
	rain.x = xPosition
	rain.y = yPosition

	local splash = function ()
		audio.play(rainSound2)
		local rainSplash = display.newImageRect("Rain2.png",123,79)
		rainSplash.x = rain.x
		rainSplash.y = rain.y
		mainTouchLayer:insert(rainSplash)
		rain:removeSelf()
		local removeSplash = function()
			rainSplash:removeSelf()
		end
		timer.performWithDelay(800,removeSplash)
	end

	if isIPhone5 then
		transition.to (rain,{time=((568-79/2)-66-yPosition)*6,y = 568-(79/2)-66, onComplete = splash})
	else
		transition.to (rain,{time=((480-79/2)-66-yPosition)*6,y = 480-(79/2)-66, onComplete = splash})
	end
	
	mainTouchLayer:insert(rain)
end

giveMeCircle = function(xPosition,yPosition)
	audio.play(circleSound)
	local circle = display.newImageRect("Circle.png",134,134)
	circle.x = xPosition
	circle.y = yPosition
	circle.name = "circle"
	mainTouchLayer:insert(circle)
	physics.addBody(circle,"dynamic",{density=1.0, friction=0.2, bounce = 0.8,radius=67})
	local removeMyCircle = function ()
		circle:removeSelf()
	end
	timer.performWithDelay(3000,removeMyCircle)
end

giveMeMusic = function(xPosition,yPosition)
	audio.play(musicSound1)
	local music = display.newImageRect("Music.png",125,127)
	music.x = xPosition
	music.y = yPosition
	music.name = "music"
	mainTouchLayer:insert(music)
	physics.addBody(music,"dynamic",{density=1.0, friction=0.2, bounce = 2.0})
	music:applyForce( -2000, -2000, music.x, music.y )
	local removeMyMusic = function ()
		music:removeSelf()
	end
	timer.performWithDelay(3000,removeMyMusic)
end

onCollision = function(event)
	if event.phase == "began" and event.object1.name == "music" then
		audio.play(musicSound2)
	elseif event.phase == "began" and event.object1.name == "circle" then
		audio.play(circleSound)
	end
end

playBackgroundMusic = function()
	audio.setVolume(0.3,{channel=8})--put it near button
	audio.play(backgroundMusic,{loops=-1, channel =8})
end
--上面定義其他的函式

main()
