local ui = require("ui")
local storyboard = require("storyboard")
local scene = storyboard.newScene()
local screenGroup
local myWebView
local backBtn
local isMyNetworkReachable
local backgroundMusic = audio.loadStream("TrainBackground.mp3")
local buttonPressedSound = audio.loadSound("ButtonPressed.mp3")
local addWebView
local language = "en"
local os=system.getInfo("platformName")
if os=="Android" then
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
			if myWebView then
				myWebView.isVisible = false
				myWebView:removeSelf()
				myWebView = nil
			end
		end
	end
	
	backBtn = ui.newButton{
		defaultSrc = "InfoButton_"..language..".png",
		defaultX=136,
		defaultY=50,
		overSrc = "InfoButtonPressed_"..language..".png",
		overX=136,
		overY=50,
		onEvent = onBackBtnTouch
	}
	backBtn.x = 160
	backBtn.isVisible=false
	screenGroup:insert(backBtn)
end

addWebView = function()
	--判斷是否有網路
	local http = require("socket.http")
	local myUrl = "http://tw.yahoo.com"
	local response = http.request(myUrl)
	if response ==nil  then
		isMyNetworkReachable = false
	else
		isMyNetworkReachable = true
	end
	if isMyNetworkReachable then
		print ("network checked is ok")
		native.setActivityIndicator(false)
		if isIPhone5 then
			myWebView = native.newWebView(0,0,320,490)
			myWebView.isVisible = true
			if os=="Android" then
				myWebView:request(
					"http://appsgaga.com/
					AndroidMobileMiniWebSite/mobile.html")
			else
				myWebView:request(
					"http://appsgaga.com/
					MobileMiniWebSite/mobile.html")
			end
			
			backBtn.y= 529
		else
			myWebView = native.newWebView(0,0,320,402)
			myWebView.isVisible = true
			if os=="Android" then
				myWebView:request("http://appsgaga.com/
					AndroidMobileMiniWebSite/mobile.html")
			else
				myWebView:request("http://appsgaga.com/
					MobileMiniWebSite/mobile.html")
			end
			backBtn.y= 441
		end
	else
		print ("network checked is not ok")
		native.setActivityIndicator(false)
		if isIPhone5 then
			local backgroundImage = 
			display.newImageRect("MoreAppBackgroundiPhone5_"..language..".png",320,568)
			backgroundImage.x= 160
			backgroundImage.y = 284
			screenGroup:insert(backgroundImage)
			backBtn:toFront()
			backBtn.y= 507
		else
			local backgroundImage = 
			display.newImageRect("MoreAppBackground_"..language..".png", 320, 480)
			backgroundImage.x= 160
			backgroundImage.y = 240
			screenGroup:insert(backgroundImage)
			backBtn:toFront()
			backBtn.y= 402
		end
	end
	backBtn.isVisible = true
end
-- ****************************** --
-- ********* storyboard ********* --
-- ****************************** --
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
	print("***** moreapp createScene event *****")
	--開始擺放UI
	native.setActivityIndicator(true)
	screenGroup = self.view
	local backgroundRect
	if isIPhone5 then
		backgroundRect = display.newRect(0,0,320,568)
		backgroundRect:setFillColor(213,213,213)
	else
		backgroundRect = display.newRect(0,0,320,480)
		backgroundRect:setFillColor(213,213,213)
	end
	screenGroup:insert(backgroundRect)
	addMenu()
end

--畫面到螢幕上時，呼叫enterScene，移除之前的場景，放背景音樂
function scene:enterScene(event)
	print("***** moreapp enterScene event *****")
	audio.play(backgroundMusic,{loops=-1})
	storyboard.removeScene("covermenu")
	addWebView()
end

--畫面快要離開螢幕的時候，呼叫exitScene
function scene:exitScene()
	--停止音樂，釋放音樂記憶體
    print("***** moreapp exitScene event *****")
    audio.stop()
	audio.dispose(backgroundMusic)
	backgroundMusicMore = nil
	audio.dispose(buttonPressedSound)
	buttonPressedSoundMore = nil
end

--畫面要被銷燬之前，呼叫destroyScene
function scene:destroyScene(event)
	print("***** moreapp destroyScene event *****")
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene