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
local changeSceneEffectSetting={
	effect = "slideLeft",
	time = 300,
}
local isIPhone5
if display.contentScaleX ==0.5 and display.contentScaleY == 0.5 
	and display.contentWidth == 320 and display.contentHeight == 568 then
	isIPhone5 = true
end

-- ****************************** --
-- ********* storyboard ********* --
-- ****************************** --
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
	print ("***** howToPlay createScene event*****")
	screenGroup = self.view
	--加入背景
	local backgroundImage
	if isIPhone5 then
		backgroundImage = 
		display.newImageRect("HowToPlayBackgroundiPhone5_"..language..".png",320,568)
		backgroundImage.x = 160
		backgroundImage.y = 284
	else
		backgroundImage = 
		display.newImageRect("HowToPlayBackground_"..language..".png",320,480)
		backgroundImage.x = 160
		backgroundImage.y = 240
	end

	local removeBody = function(event)
		local phase = event.phase
		if "began" == phase then
			storyboard.gotoScene("covermenu",changeSceneEffectSetting)
		end
		return true
	end
	backgroundImage:addEventListener("touch", removeBody)
	screenGroup:insert(backgroundImage)
end

function scene:enterScene(event)
	print("***** howToPlay enterScene event *****")
end
function scene:exitScene()
	print("***** howToPlay exitScene event *****")
end
function scene:destroyScene(event)
	print("***** howToPlay destroyScene event *****")
end
scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene