local storyboard = require("storyboard")
local scene = storyboard.newScene()
local screenGroup
local ui = require("ui")
local backgroundMusic = audio.loadStream("TrainBackground.mp3")
local buttonPressedSound = audio.loadSound("ButtonPressed.mp3")
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
local changeSceneEffectSetting={
	effect = "slideRight",
	time = 300,
}

local addMenu = function()
	local onBackBtnTouch = function(event)
		if event.phase == "press" then
            audio.play(buttonPressedSound)
        end
		if event.phase == "release" then
			storyboard.gotoScene("covermenu",changeSceneEffectSetting)
		end
	end
	
	local backBtn = ui.newButton{
		defaultSrc = "InfoButton_"..language..".png",
		defaultX=136,
		defaultY=50,
		overSrc = "InfoButtonPressed_"..language..".png",
		overX=136,
		overY=50,
		onEvent = onBackBtnTouch
	}
	backBtn.x = 160
	if isIPhone5 then
		backBtn.y= 537
	else
		backBtn.y= 449
	end
	screenGroup:insert(backBtn)
end
-- ****************************** --
-- ********* storyboard ********* --
-- ****************************** --
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
	print ("***** railInfo createScene event*****")
	screenGroup = self.view
	--加入背景
	local backgroundImage
	if isIPhone5 then
		backgroundImage = 
		display.newImageRect("InfoBackgroundiPhone5.png",320,568)
		backgroundImage.x = 160
		backgroundImage.y = 284
	else
		backgroundImage = 
		display.newImageRect("InfoBackground.png",320,480)
		backgroundImage.x = 160
		backgroundImage.y = 240
	end
	screenGroup:insert(backgroundImage)
	addMenu()
end

--畫面到螢幕上時，呼叫enterScene，移除之前的場景
function scene:enterScene(event)
	print ("***** railInfo enterScene event*****")
	audio.play(backgroundMusic,{loops=-1})
	storyboard.removeScene("covermenu")
end

--即將被移除，呼叫exitScene，停止音樂，釋放音樂記憶體
function scene:exitScene()
	print ("***** railInfo exitScene event*****")
	audio.stop()
	audio.dispose(backgroundMusic)
	backgroundMusic = nil
	audio.dispose(buttonPressedSound)
	buttonPressedSound = nil
end

--下一個畫面呼叫完enterScene、完全在螢幕上後，呼叫destroyScene
function scene:destroyScene(event)
	print ("***** railInfo destroyScene event*****")
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene