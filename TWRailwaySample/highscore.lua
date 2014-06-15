local storyboard = require("storyboard")
local scene = storyboard.newScene()
local screenGroup
local ui = require("ui")
require('bmf')
local myHighScoreLabelLayer = bmf.loadFont( 'HighScoreLayer.fnt' )
local highScoreTable
local backgroundMusic = audio.loadStream("TrainBackground.mp3")
local buttonPressedSound = audio.loadSound("ButtonPressed.mp3")
local loadRecord
local changeSceneEffectSetting={
	effect = "slideRight",
	time = 300,
}
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

loadRecord =function(strFileName)
	--will load specified file, or create new file if it doesn't exist
    local theFile = strFileName
    local path = system.pathForFile(theFile, system.DocumentsDirectory)
    --io.open opens a file at path; returns nil if no file found
    local file = io.open(path,"r")
    if file then
        --read all contents of file
        local myValue = file:read( "*a" )
        print("returnTable form loadRecord= " .. myValue)
        io.close(file)
        return myValue
    else
        --create file because it doesn't exist yet
        local file = io.open(path,"w+")
        file:write("99.99")
        io.close(file)
        local saveTable = "99.99"
        return saveTable
    end
end

local addMenu = function()
	local backBtn
	local onBackBtnTouch = function(event)
        if event.phase == "press" then
            audio.play(buttonPressedSound)
        end
		if event.phase == "release" then
			storyboard.gotoScene("covermenu",changeSceneEffectSetting)
		end
	end
	backBtn = ui.newButton{
		defaultSrc = "HighScoreButton_"..language..".png",
		defaultX=208,
		defaultY=50,
		overSrc = "HighScoreButtonPressed_"..language..".png",
		overX=208,
		overY=50,
		onEvent = onBackBtnTouch
	}
    if isIPhone5 then
        backBtn.x = 160
        backBtn.y= 504
    else
        backBtn.x = 160
        backBtn.y= 430
    end
	screenGroup:insert(backBtn)
end

-- ****************************** --
-- ********* storyboard ********* --
-- ****************************** --
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
    print("***** highscore createScene event *****")
	screenGroup = self.view
    local backgroundImage
    if isIPhone5 then
        backgroundImage = 
        display.newImageRect(
            "HighScoreBackgroundiPhone5_"..language..".png", 320, 568)
        backgroundImage.x = 160
        backgroundImage.y = 284
    else
        backgroundImage = 
        display.newImageRect(
            "HighScoreBackground_"..language..".png", 320, 480)
        backgroundImage.x = 160
        backgroundImage.y = 240
    end
	screenGroup:insert(backgroundImage)
	addMenu()
    for i=1,10 do
        local aHighScore = loadRecord("highscore" .. tostring(i) ..".data")
        if aHighScore == "99.99" then
            aHighScore = ""
        end
        local redText = bmf.newString(myHighScoreLabelLayer,aHighScore)
        local xNumber
        local yNumber
        local originalX = 97
        local originalY
        local xDistance = 159
        local yDistance = 51
        if isIPhone5 then
            originalY = 234
        else
            originalY = 144
        end
        if i>5 then
            xNumber = 1
            yNumber = i-6
        else
            xNumber = 0
            yNumber = i-1
        end
        redText:setReferencePoint( display.CenterReferencePoint )
        redText.x = originalX+xDistance * xNumber
        redText.y = originalY+yDistance * yNumber
        redText.xScale = 0.5
        redText.yScale = 0.5
        screenGroup:insert(redText)
    end
end

--畫面到螢幕上時，呼叫enterScene，移除之前的場景
function scene:enterScene(event)
    print("***** highscore enterScene event *****")
	--completely remove maingame and options
    audio.play(backgroundMusic,{loops=-1})
	storyboard.removeScene("covermenu")
end

--即將被移除，呼叫exitScene，停止音樂，釋放音樂記憶體
function scene:exitScene()
    print("***** highscore exitScene event *****")
	audio.stop()
	audio.dispose(backgroundMusic)
	backgroundMusic = nil
	audio.dispose(buttonPressedSound)
	buttonPressedSound = nil
end

--下一個畫面呼叫完enterScene、完全在螢幕上後，呼叫destroyScene
function scene:destroyScene(event)
    print("***** highscore destroyScene event *****")

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene