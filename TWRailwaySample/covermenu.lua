local ui = require("ui")
local storyboard = require("storyboard")
local scene = storyboard.newScene()
local screenGroup
local language = "en"
local thisOS=system.getInfo("platformName")
if thisOS=="Android" then
	print("Don't support Android")
else
	language = userDefinedLanguage or system.getPreference("ui","language")
	if language ~="zh-Hant" then
		language = "en"
	end
end
local isIPhone5
if display.contentScaleX ==0.5 and display.contentScaleY == 0.5 
	and display.contentWidth == 320 and display.contentHeight == 568 then
	isIPhone5 = true
end
local coverTitle
local backgroundMusic = audio.loadStream("BackgroundMusic.mp3")
local buttonPressedSound = audio.loadSound("ButtonPressed.mp3")
local addMenu
local addLabel
local changeSceneEffectSetting={
	effect = "slideLeft",
	time = 300,
}

-- ****************************** --
-- ********** add menu ********** --
-- ****************************** --
addMenu = function()
	local playBtn
	local highScoreBtn
	local infoBtn
	local moreAppBtn
	local verticalPadding = 44
	local startingY
	if isIPhone5 then
		startingY = 371
	else
		startingY = 315
	end

	local onPlayTouch = function(event)
		if event.phase =="press" then
			audio.play(buttonPressedSound)
		end
		if event.phase == "release" then
			storyboard.gotoScene("gameplay",changeSceneEffectSetting)
		end
	end
	playBtn = ui.newButton{
		defaultSrc = "CoverMenuButton1_"..language..".png",
		defaultX=185,
		defaultY=37,
		overSrc = "CoverMenuButton1Pressed_"..language..".png",
		overX=185,
		overY=37,
		onEvent = onPlayTouch
	}
	playBtn.x = 160
	playBtn.y = startingY
	screenGroup:insert(playBtn)

	local function playBtnAnimation()
		local playBtnScaleUp = function()
			transition.to( playBtn, { time=150, xScale = 1,
				yScale=1, onComplete=playBtnAnimation })
		end
		transition.to( playBtn, { time=150, xScale = 1.06,
	 			yScale=1.06, onComplete=playBtnScaleUp })
	end
	playBtnAnimation()

	local onHighScoreTouch = function(event)
		if event.phase =="press" then
			audio.play(buttonPressedSound)
		end

		if event.phase == "release" then
			storyboard.gotoScene("highscore",changeSceneEffectSetting)
		end
	end

	highScoreBtn = ui.newButton{
		defaultSrc = "CoverMenuButton2_"..language..".png",
		defaultX=185,
		defaultY=37,
		overSrc = "CoverMenuButton2Pressed_"..language..".png",
		overX=185,
		overY=37,
		onEvent = onHighScoreTouch
	}
	highScoreBtn.x = 160
	highScoreBtn.y = startingY + verticalPadding*1
	screenGroup:insert(highScoreBtn)

	local onInfoBtnTouch = function(event)
		if event.phase =="press" then
			audio.play(buttonPressedSound)
		end

		if event.phase == "release" then
			storyboard.gotoScene("railinfo",changeSceneEffectSetting)
		end
	end

	infoBtn = ui.newButton{
		defaultSrc = "CoverMenuButton3_"..language..".png",
		defaultX=185,
		defaultY=37,
		overSrc = "CoverMenuButton3Pressed_"..language..".png",
		overX=185,
		overY=37,
		onEvent = onInfoBtnTouch
	}
	infoBtn.x = 160
	infoBtn.y = startingY + verticalPadding*2
	screenGroup:insert(infoBtn)


	local onMoreAppTouch = function(event)
		if event.phase =="press" then
			audio.play(buttonPressedSound)
		end

		if event.phase == "release" then
			storyboard.gotoScene("moreapp",changeSceneEffectSetting)
		end
	end

	moreAppBtn = ui.newButton{
		defaultSrc = "CoverMenuButton4_"..language..".png",
		defaultX=185,
		defaultY=37,
		overSrc = "CoverMenuButton4Pressed_"..language..".png",
		overX=185,
		overY=37,
		onEvent = onMoreAppTouch
	}
	moreAppBtn.x = 160
	moreAppBtn.y = startingY + verticalPadding*3
	screenGroup:insert(moreAppBtn)
end

-- ****************************** --
-- ********* add  label ********* --
-- ****************************** --
addLabel = function()
	coverTitle = display.newImageRect("CoverTitle_"..language..".png",318,124)
	if isIPhone5 then
		coverTitle.x = 160
		coverTitle.y = 295
	else
		coverTitle.x = 160
		coverTitle.y = 240
	end

	local function labelAnimation()
		local labelRotation = function()
		transition.to( coverTitle, { time=800,
		 rotation = 2, onComplete=labelAnimation })
		end
		transition.to( coverTitle, { time=800,
		 rotation = -2, onComplete=labelRotation })
	end
	labelAnimation()
	screenGroup:insert(coverTitle)
end

-- ****************************** --
-- ********* storyboard ********* --
-- ****************************** --
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
	print ("***** mainmenu createScene event *****")
	screenGroup = self.view
	local backgroundImage
	if isIPhone5 then
		backgroundImage = 
		display.newImageRect("CoverMenuBackgroundiPhone5.png",320,568)
		backgroundImage.x = 160
		backgroundImage.y = 284
	else
		backgroundImage = 
		display.newImageRect("CoverMenuBackground.png",320,480)
		backgroundImage.x = 160
		backgroundImage.y = 240
	end
	screenGroup:insert(backgroundImage)
	addLabel()
	addMenu()
end

--畫面到螢幕上時，呼叫enterScene，移除之前的場景
function scene:enterScene(event)
	print("***** mainmenu enterScene event *****")
	storyboard.removeScene("gameplay")
	storyboard.removeScene("howtoplay")
	storyboard.removeScene("moreapp")
	storyboard.removeScene("highscore")
	storyboard.removeScene("railinfo")
	audio.play(backgroundMusic,{loops=-1})
end

--即將被移除，呼叫exitScene，停止音樂，釋放音樂記憶體
function scene:exitScene()
	print("***** mainmenu exitScene event *****")
	audio.stop()
	audio.dispose(backgroundMusic)
	backgroundMusic = nil
	audio.dispose(buttonPressedSound)
	buttonPressedSound = nil
end

--下一個畫面呼叫完enterScene、完全在螢幕上後，呼叫destroyScene
function scene:destroyScene(event)
	--要做什麼事寫在這邊
	print("***** mainmenu destroyScene event *****")
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene