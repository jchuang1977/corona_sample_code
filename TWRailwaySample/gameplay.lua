local ui = require("ui")
local storyboard = require("storyboard")
local scene = storyboard.newScene()
local screenGroup
require('bmf')
local myleftLabelFont = bmf.loadFont('LeftLabelFont.fnt')
local myTimeLabelFont = bmf.loadFont('TimeLabelFont.fnt')
math.randomseed(os.time())
local hasPlayBefore = false
local canSwipe = false
local isPause = true
local lifeNumber = 3
local myTime =0
local originalTime = 0
local oneSecond = 1
local leftNumber = 20
local iPhone5AddOn
local rightGesture
local destinationStation
local rightNowStation
local eastOrWest
local myTimerStartToGo
local highScoreTable
local leftLabel
local timeLabel
local lifeIcon1
local lifeIcon2
local lifeIcon3
local pauseButton
local bigBlueDestination
local smallBlueDestination
local trainImage
local destinationBoard
local blackDestination
local platformImage
local ready
local go
local rightOrWrong
local resultGroup
local callMyResult
local countdownToPlay
local showGo
local playGameNow
local poseQuestion
local backToMenu
local saveRecord
local loadRecord
local shuffleMyArray
local moveMyTrain
local tickTac
local youGotIt
local youWrong
local backgroundMusic = audio.loadStream("TrainBackground.mp3")
local buttonPressedSound = audio.loadSound("ButtonPressed.mp3")
local readySound = audio.loadSound("Ready.mp3")
local goSound = audio.loadSound("Go.mp3")
local settingAlready = audio.loadSound("SettingAlready.mp3")
local rightAnswer = audio.loadSound("Right.mp3")
local ohNein = audio.loadSound("OhNein.mp3")
local wrongAnswer = audio.loadSound("WrongAnswer1.mp3")
local clickSound = audio.loadSound("Click1.mp3")
local trainEffect = audio.loadSound("TrainEffect.mp3")
local wrongNumberSound = audio.loadSound("WrongNumber.mp3")
local winSound = audio.loadSound("Win.mp3")
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

saveRecord = function(strFileName, tableValue)
    --will save speified value to specified file
    local theFile = strFileName
    local theValue = tableValue

    local path = system.pathForFile(theFile, system.DocumentsDirectory)
    -- io.open opens a file at path; returns nil if no file found
    local file = io.open(path,"w+")
    if file then
        file:write(theValue)
        io.close(file)
    end
end

loadRecord = function(strFileName)
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

local function makeBackground()
	local backgroundImage
	if isIPhone5 then
		backgroundImage = 
        display.newImageRect("GamePlayBackgroundiPhone5.png",320,568)
		backgroundImage.x = 160
		backgroundImage.y = 284
        iPhone5AddOn = 88
	else
		backgroundImage = 
        display.newImageRect("GamePlayBackground.png",320,480)
		backgroundImage.x = 160
		backgroundImage.y = 240
        iPhone5AddOn = 0
	end

    leftLabel = bmf.newString(myleftLabelFont,"20")
    leftLabel.xScale = 0.5
    leftLabel.yScale = 0.5
    leftLabel:setReferencePoint( display.CenterReferencePoint )
    leftLabel.x = 40
    leftLabel.y = 59 + iPhone5AddOn

    timeLabel = display.newText("00.00",
        100,34,128,80,native.systemFontBold,40)
    timeLabel:setTextColor(255, 0, 0)
    timeLabel:setReferencePoint( display.CenterReferencePoint )
    timeLabel.x = 167
    timeLabel.y = 72 + iPhone5AddOn

    lifeIcon1 = display.newGroup()
    local tmpImage1 = display.newImageRect( "XWhite.png", 15, 16 )
    lifeIcon1:insert(tmpImage1)
    lifeIcon2 = display.newGroup()
    local tmpImage2 = display.newImageRect( "XWhite.png", 15, 16 )
    lifeIcon2:insert(tmpImage2)
    lifeIcon3 = display.newGroup()
    local tmpImage3 = display.newImageRect( "XWhite.png", 15, 16 )
    lifeIcon3:insert(tmpImage3)
    lifeIcon1.x = 261
    lifeIcon1.y = 18 + iPhone5AddOn
    lifeIcon2.x = 281
    lifeIcon2.y = 18 + iPhone5AddOn
    lifeIcon3.x = 302
    lifeIcon3.y = 18 + iPhone5AddOn

    local onPauseBtnTouch = function(event)
        if event.phase =="press" and isPause == false then
            audio.play(buttonPressedSound)
            audio.pause(8)
            timer.cancel(myTimerStartToGo)
            callMyResult(4)
        end
    end
    pauseButton = ui.newButton{
        defaultSrc = "PauseButton.png",
        defaultX=67,
        defaultY=47,
        overSrc = "PauseButtonPressed.png",
        overX=67,
        overY=47,
        onEvent = onPauseBtnTouch
    }
    pauseButton.x = 282
    pauseButton.y = 55 + iPhone5AddOn

    bigBlueDestination = display.newGroup()
    local temBig = display.newImageRect( "16.png", 88, 43 )
    bigBlueDestination:insert(temBig)
    bigBlueDestination.x = 158
    bigBlueDestination.y = 139 + iPhone5AddOn
    bigBlueDestination.isVisible=false

    smallBlueDestination = display.newGroup()
    local tmpSmall = display.newImageRect( "1a.png", 29, 15 )
    smallBlueDestination:insert(tmpSmall)
    smallBlueDestination.x = 214
    smallBlueDestination.y = 174 + iPhone5AddOn

    trainImage = display.newGroup()
    local tmpTrain =display.newImageRect( "Train1.png", 301, 130 )
    trainImage:insert(tmpTrain)
    trainImage.x = 480
    trainImage.y = 372 + iPhone5AddOn

    destinationBoard = 
    display.newImageRect( "Destination.png", 142, 99 )
    destinationBoard.x = 158
    destinationBoard.y = 272 + iPhone5AddOn
    destinationBoard.isVisible = false

    blackDestination = display.newGroup()
    local temBlack = display.newImageRect( "12b.png", 60, 29 )
    blackDestination:insert(temBlack)
    blackDestination.x = 158
    blackDestination.y = 273 + iPhone5AddOn
    blackDestination.isVisible = false

    platformImage = display.newImageRect( "Platform.png", 320, 62 )
    platformImage.x = 160
    platformImage.y = 449 + iPhone5AddOn

    rightOrWrong = display.newGroup()
    local tempRightOrWrong = 
    display.newImageRect("RightAnswer.png",188,188)
    rightOrWrong:insert(tempRightOrWrong)
    rightOrWrong.x= 160
    rightOrWrong.y= 260 + iPhone5AddOn
    rightOrWrong.isVisible = false

    ready = display.newImageRect("Ready.png",245,68)
    go = display.newImageRect("Go.png",150,99)
    ready.x= 160
    ready.y= 260 + iPhone5AddOn
    go.x= 160
    go.y= 260 + iPhone5AddOn
    ready.isVisible = false
    go.isVisible = false

    resultGroup = display.newGroup()
    if isIPhone5 then
        resultGroup.x = 0
        resultGroup.y = -568
    else
        resultGroup.x = 0
        resultGroup.y = -480
    end

    screenGroup:insert(backgroundImage)
    screenGroup:insert(leftLabel)
    screenGroup:insert(timeLabel)
    screenGroup:insert(lifeIcon1)
    screenGroup:insert(lifeIcon2)
    screenGroup:insert(lifeIcon3)
    screenGroup:insert(pauseButton)
    screenGroup:insert(bigBlueDestination)
    screenGroup:insert(smallBlueDestination)
    screenGroup:insert(trainImage)
    screenGroup:insert(destinationBoard)
    screenGroup:insert(blackDestination)
    screenGroup:insert(platformImage)
    screenGroup:insert(rightOrWrong)
    screenGroup:insert(ready)
    screenGroup:insert(go)
    screenGroup:insert(resultGroup)
end

shuffleMyArray = function(t)
    local n = #t
    math.randomseed(os.time())
    while n>=2 do
        local k = math.random(n)
        t[n],t[k] = t[k],t[n]
        n=n-1
    end
end

countdownToPlay = function()
    --play ready sound
    audio.play(readySound)
    --show ready
    ready.xScale = 0.9
    ready.yScale = 0.9
    ready.isVisible = true
    local removeImageOfReady =function()
        showGo()
        ready.isVisible=false
        ready.alpha=1
    end
    local fadeImageOfReady =function()
        transition.to(ready, {time=100, alpha=0,
         xScale=1.5,yScale=1.5, onComplete = removeImageOfReady})
    end
    --first do this transition
    transition.to(ready, {time=1500, alpha=1,
     xScale=1.0,yScale=1.0, onComplete = fadeImageOfReady})
end

showGo = function()
    --play go sound
    audio.play(goSound)
    --show go
    go.xScale = 0.9
    go.yScale = 0.9
    go.isVisible = true
    local removeImageOfGo =function()
        timer.performWithDelay(500,playGameNow) -- playgamenow
        go.isVisible=false
        go.alpha=1
    end
    local fadeImageOfGo =function()
        transition.to(go, {time=50, alpha=0,
         xScale=1.3,yScale=1.3, onComplete = removeImageOfGo})
    end
    --start fo fade go
    transition.to(go, {time=300, alpha=1,
     xScale=1.0,yScale=1.0, onComplete = fadeImageOfGo})
end

playGameNow = function()
    --make ready and go ready for next show up
    ready.isVisible = false
    ready.alpha = 1
    go.isVisible = false
    go.alpha = 1
    myTimerStartToGo=timer.performWithDelay(1, tickTac,0)
    if hasPlayBefore then
        audio.resume(8)
    else
        audio.play(backgroundMusic,{channel=8,loops=-1})
        hasPlayBefore = true
    end
    poseQuestion()
end

tickTac = function(event)
    myTime = event.count*0.03 + originalTime
    if math.floor(myTime)>oneSecond then
        audio.play(clickSound)
        print("**********JUST PAST A SECOND*********")
        oneSecond = oneSecond+1
    end
    local myTimeString
    if myTime<10 then
        myTimeString = "0"..tostring(myTime)
    elseif myTime>=10 and myTime<100 then
        myTimeString = tostring(myTime)
    elseif myTime>=100 then
        myTimeString = "99.99"
        timeLabel.isVisible = false
        leftLabel.isVisible = false
        audio.play(wrongNumberSound)
        callMyResult(2)
        timer.cancel(myTimerStartToGo)
        originalTime = myTime
        isPause = true
    end
    timeLabel.text = myTimeString
end

poseQuestion = function()
    eastOrWest = math.random(2)
    local tempStations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
    shuffleMyArray(tempStations)
    for i=1,#tempStations do
        print(tempStations[i])
    end
    if tempStations[1]>=10 then
        rightNowStation = eastOrWest*100+tempStations[1]
    else
        rightNowStation = eastOrWest*10+tempStations[1]
    end
    if tempStations[2]>=10 then
        destinationStation = eastOrWest*100+tempStations[2]
    else
        destinationStation = eastOrWest*10+tempStations[2]
    end
    if destinationStation>rightNowStation then
        rightGesture = "right"
    else
        rightGesture = "left"
    end
    changeImage(smallBlueDestination,tostring(eastOrWest).."a.png",3)
    changeImage(bigBlueDestination,tostring(rightNowStation)..".png",1)
    bigBlueDestination.isVisible = true
    moveMyTrain()
end

changeImage = function (imageGroup,imgNumber,imgType)
    local tempWidth
    local tempHeight    
    if imgType ==1 then
        tempWidth =88
        tempHeight =43
    elseif imgType ==2 then
        tempWidth =60
        tempHeight =29
    elseif imgType ==3 then
        tempWidth =29
        tempHeight =15
    elseif imgType ==4 then
        tempWidth =301
        tempHeight =130
    elseif imgType ==5 then
        tempWidth =188
        tempHeight =188
    elseif imgType ==6 then
        tempWidth =15
        tempHeight =16
    end
    imageGroup[1]:removeSelf()
    local tempImg = display.newImageRect(imgNumber,tempWidth,tempHeight)
    imageGroup:insert(tempImg)
end

local showQuestion = function ()
    audio.play(settingAlready)
    destinationBoard.isVisible = true
    changeImage(blackDestination,tostring(destinationStation).."b.png",2)
    blackDestination.isVisible = true
    canSwipe = true
    isPause = false
end
moveMyTrain = function()
    audio.play(trainEffect)
    if eastOrWest ==1 then
        changeImage(trainImage,"Train1.png",4)
    else
        changeImage(trainImage,"Train2.png",4)
    end
    transition.to(trainImage,{time = 800,x =160, 
        transition = easing.outExpo,onComplete = showQuestion})
end

local function onSceneTouch(event)
    if event.phase == "began" then
        event.xStart = event.x
        event.yStart = event.y
    end

    if event.phase == "ended" then
        if event.xStart < event.x and (event.x - event.xStart) >= 30 then
            if canSwipe and isPause==false then
                if rightGesture =="right" then
                    youGotIt()
                else
                    youWrong()
                end
            end
            return true
        elseif event.xStart > event.x and (event.xStart - event.x) >= 30 then 
            if canSwipe and isPause==false then
                if rightGesture =="left" then
                    youGotIt()
                else
                    youWrong()
                end
            end
            return true
        end
    end
end

local beforeNextQuestion =function()
    rightOrWrong.isVisible = false
    poseQuestion()
end

youGotIt = function()
    audio.play(rightAnswer)
    isPause = true
    canSwipe = false
    leftNumber = leftNumber-1
    leftLabel.text = leftNumber
    leftLabel.x = 30
    if leftNumber ==0 then
        timer.cancel(myTimerStartToGo)
        callMyResult(1)
    else
        changeImage(rightOrWrong,"RightAnswer.png",5)
        rightOrWrong.isVisible = true
        bigBlueDestination.isVisible = false
        destinationBoard.isVisible = false
        blackDestination.isVisible = false
        if rightGesture =="right" then
            transition.to(trainImage,{time = 200, x =480, 
                transition = easing.outExpo})
        else
            transition.to(trainImage,{time = 200, x =-160, 
                transition = easing.outExpo,
                onComplete= function() trainImage.x =480 end})
        end
        timer.performWithDelay(700,beforeNextQuestion)
    end
end

youWrong = function()
    audio.play(wrongAnswer)
    isPause = true
    canSwipe = false
    if lifeNumber ==3 then
        changeImage(lifeIcon1,"XRed.png",6)
    elseif lifeNumber ==2 then
        changeImage(lifeIcon2,"XRed.png",6)
    elseif lifeNumber ==1 then
        changeImage(lifeIcon3,"XRed.png",6)
    end
    lifeNumber = lifeNumber-1
    if lifeNumber ==0 then
        timer.cancel(myTimerStartToGo)
        audio.play(wrongNumberSound)
        callMyResult(3)
    else
        changeImage(rightOrWrong,"WrongAnswer.png",5)
        rightOrWrong.isVisible = true
        bigBlueDestination.isVisible = false
        destinationBoard.isVisible = false
        blackDestination.isVisible = false
        if rightGesture =="left" then
            transition.to(trainImage,{time = 200,x = 480, 
                transition = easing.outExpo})
        else
            transition.to(trainImage,{time = 200,x =-160, 
                transition = easing.outExpo,
                onComplete= function() trainImage.x =480 end})
        end
        timer.performWithDelay(700,beforeNextQuestion)
    end 
end

callMyResult = function(resultType)
    audio.pause(8)
    local resultGroupAllClear = function()
        local clearmyResult = function()
            for i = resultGroup.numChildren,1,-1 do
                resultGroup[i]:removeSelf()
            end
        end
        if isIPhone5 then
            transition.to(resultGroup, {time=300, y=-568,
                transition = easing.outExpo, 
                onComplete = clearmyResult})
        else
            transition.to(resultGroup, {time=300, y=-480,
                transition = easing.outExpo, 
                onComplete = clearmyResult})
        end
    end

    local restartGame = function()
        originalTime = 0
        myTime = 0
        leftNumber = 20
        lifeNumber = 3
        changeImage(lifeIcon1,"XWhite.png",6)
        changeImage(lifeIcon2,"XWhite.png",6)
        changeImage(lifeIcon3,"XWhite.png",6)
        leftLabel.text = 20
        leftLabel.x = 30
        timeLabel.text = "00.00"
        bigBlueDestination.isVisible = false
        blackDestination.isVisible = false
        destinationBoard.isVisible = false
        trainImage.x = 480
        countdownToPlay()
    end

    local resultGroupRestartGame = function(event)
        if event.phase =="press" then
            audio.play(buttonPressedSound)
        end
        if event.phase == "release" then
            restartGame()
            resultGroupAllClear()
        end
    end

    local resultGroupbackToMenu = function(event)
        if event.phase =="press" then
            audio.play(buttonPressedSound)
        end
        if event.phase == "release" then
            storyboard.gotoScene("covermenu",changeSceneEffectSetting)
        end
    end

    local restartGameButton = ui.newButton{
        defaultSrc = "PauseButton2_"..language..".png",
        defaultX=207,
        defaultY=51,
        overSrc = "PauseButton2Pressed_"..language..".png",
        overX=207,
        overY=51,
        onEvent = resultGroupRestartGame
    }

    local backToMenuButton = ui.newButton{
        defaultSrc = "PauseButton3_"..language..".png",
        defaultX=207,
        defaultY=51,
        overSrc = "PauseButton3Pressed_"..language..".png",
        overX=207,
        overY=51,
        onEvent = resultGroupbackToMenu
    }

    if resultType ==1 then
        -- ****************************** --
        -- *********** result ************ --
        -- ****************************** --
        audio.play(winSound)
        isPause = true
        canSwipe = false
        local resultBackground
        if isIPhone5 then
            resultBackground = 
            display.newImageRect("ResultBackgroundiPhone5_"..language..".png",320,568)
            resultBackground.x = 160
            resultBackground.y = 284
        else
            resultBackground = 
            display.newImageRect("ResultBackground_"..language..".png",320,480)
            resultBackground.x = 160
            resultBackground.y = 240
        end

        restartGameButton.x = 160
        restartGameButton.y = 325 +iPhone5AddOn
        backToMenuButton.x = 160
        backToMenuButton.y = 387 +iPhone5AddOn

        local myTimeString
        if myTime<10 then
            myTimeString = "0"..tostring(myTime)
        elseif myTime>=10 and myTime<100 then
            myTimeString = tostring(myTime)
        end

        if tonumber(myTimeString)<highScoreTable[10] then
            highScoreTable[11] = tonumber(myTimeString)
            table.sort(highScoreTable)

            --存檔
            local highScoreKeyArray = {}
            for i=1,10 do
                highScoreKeyArray[i] = "highscore" .. tostring(i) ..".data"
            end
            local highscoreValueArray = {}
            for i = 1,10 do
                highscoreValueArray[i]=tostring(highScoreTable[i])
            end
            for i=1,10 do
                saveRecord(highScoreKeyArray[i],highscoreValueArray[i])
            end
            --重建highScoreTable
            for i = 1,11 do
                table.remove(highScoreTable,i)
            end
            for i=1,10 do
                highScoreTable[i] = tonumber(loadRecord(highScoreKeyArray[i]))
                print("highscore"..i.."="..highScoreTable[i])
            end
        end

        local resultTimeLabel = bmf.newString(myTimeLabelFont,myTimeString)
        resultTimeLabel.xScale = 0.5
        resultTimeLabel.yScale = 0.5
        resultTimeLabel:setReferencePoint( display.CenterReferencePoint )
        resultTimeLabel.x = 160
        resultTimeLabel.y = 275 + iPhone5AddOn
        resultGroup:insert(resultBackground)
        resultGroup:insert(restartGameButton)
        resultGroup:insert(backToMenuButton)
        resultGroup:insert(resultTimeLabel)
    elseif resultType ==2 then
        -- ****************************** --
        -- ********* game over1********** --
        -- ****************************** --
        local gameOverBackground
        if isIPhone5 then
            gameOverBackground = 
            display.newImageRect("GameOverBackgroundiPhone5_"..language..".png",320,568)
            gameOverBackground.x = 160
            gameOverBackground.y = 284
        else
            gameOverBackground = 
            display.newImageRect("GameOverBackground_"..language..".png",320,480)
            gameOverBackground.x = 160
            gameOverBackground.y = 240
        end
        restartGameButton.x = 160
        restartGameButton.y = 325 +iPhone5AddOn
        backToMenuButton.x = 160
        backToMenuButton.y = 387 +iPhone5AddOn
        timeLabel.isVisible = true
        leftLabel.isVisible = true

        local gameOverDisplay = 
        display.newImageRect("TimesUp_"..language..".png",103,100)
        gameOverDisplay.x = 97
        gameOverDisplay.y = 157+iPhone5AddOn
        resultGroup:insert(gameOverBackground)
        resultGroup:insert(restartGameButton)
        resultGroup:insert(backToMenuButton)
        resultGroup:insert(gameOverDisplay)
        timer.performWithDelay(1000,function() audio.play(ohNein) end)
    elseif resultType ==3 then
        -- ****************************** --
        -- ********* game over2********** --
        -- ****************************** --
        local gameOverBackground
        if isIPhone5 then
            gameOverBackground = 
            display.newImageRect("GameOverBackgroundiPhone5_"..language..".png",320,568)
            gameOverBackground.x = 160
            gameOverBackground.y = 284
        else
            gameOverBackground = 
            display.newImageRect("GameOverBackground_"..language..".png",320,480)
            gameOverBackground.x = 160
            gameOverBackground.y = 240
        end
        restartGameButton.x = 160
        restartGameButton.y = 325 +iPhone5AddOn
        backToMenuButton.x = 160
        backToMenuButton.y = 387 +iPhone5AddOn

        local gameOverDisplay = 
        display.newImageRect("NoLife_"..language..".png",103,100)
        gameOverDisplay.x = 97
        gameOverDisplay.y = 157+iPhone5AddOn
        resultGroup:insert(gameOverBackground)
        resultGroup:insert(restartGameButton)
        resultGroup:insert(backToMenuButton)
        resultGroup:insert(gameOverDisplay)
        timer.performWithDelay(1000,function() audio.play(ohNein) end)
    elseif resultType ==4 then
        -- ****************************** --
        -- *********** pause ************ --
        -- ****************************** --
        originalTime = myTime
        isPause = true
        canSwipe = false
        local pauseBackground
        local backToGameButton
        if isIPhone5 then
            pauseBackground = 
            display.newImageRect("PauseBackgroundiPhone5_"..language..".png",320,568)
            pauseBackground.x = 160
            pauseBackground.y = 284
        else
            pauseBackground = 
            display.newImageRect("PauseBackground_"..language..".png",320,480)
            pauseBackground.x = 160
            pauseBackground.y = 240
        end

        local resultGroupBackToGame = function(event)
            if event.phase =="press" then
                audio.play(buttonPressedSound)
            end
            if event.phase == "release" then
                myTimerStartToGo=timer.performWithDelay(1, tickTac,0)
                canSwipe =true
                isPause =false
                resultGroupAllClear()
                audio.resume(8)
            end
        end
        backToGameButton = ui.newButton{
            defaultSrc = "ResultButton1_"..language..".png",
            defaultX=207,
            defaultY=51,
            overSrc = "ResultButton1Pressed_"..language..".png",
            overX=207,
            overY=51,
            onEvent = resultGroupBackToGame
        }
        backToGameButton.x = 160
        backToGameButton.y = 215 +iPhone5AddOn

        restartGameButton.x = 160
        restartGameButton.y = 290 +iPhone5AddOn

        backToMenuButton.x = 160
        backToMenuButton.y = 363 +iPhone5AddOn

        resultGroup:insert(pauseBackground)
        resultGroup:insert(backToGameButton)
        resultGroup:insert(restartGameButton)
        resultGroup:insert(backToMenuButton)
    end
    transition.to(resultGroup, {time=300, y=0,transition = easing.outExpo})
end
-- ****************************** --
-- ********* storyboard ********* --
-- ****************************** --
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
    print("***** gameplay createScene event *****")
	screenGroup = self.view
	makeBackground()
end

--畫面到螢幕上時，呼叫enterScene，移除之前的場景
function scene:enterScene(event)
    print("***** gameplay enterScene event *****")
	storyboard.removeScene("covermenu")
	highScoreTable = {} 
    for i=1,10 do
        highScoreTable[i] = 
        tonumber(loadRecord("highscore" .. tostring(i) ..".data"))
        print("highscore =  " .. highScoreTable[i])
    end
    countdownToPlay()
    Runtime:addEventListener("touch", onSceneTouch)
end

--即將被移除，呼叫exitScene，停止音樂，釋放音樂記憶體
function scene:exitScene()
    print("***** gameplay exitScene event *****")
	audio.stop()
    audio.dispose(backgroundMusic)
    audio.dispose(buttonPressedSound)
    audio.dispose(readySound)
    audio.dispose(goSound)
    audio.dispose(settingAlready)
    audio.dispose(rightAnswer)
    audio.dispose(ohNein)
    audio.dispose(wrongAnswer)
    audio.dispose(clickSound)
    audio.dispose(trainEffect)
    audio.dispose(wrongNumberSound)
    audio.dispose(winSound)
    backgroundMusic = nil
    buttonPressedSound = nil
    ready = nil
    go = nil
    settingAlready = nil
    rightAnswer = nil
    ohNein = nil
    wrongAnswer = nil
    clickSound = nil
    trainEffect = nil
    wrongNumberSound = nil
    winSound = nil
end

--下一個畫面呼叫完enterScene、完全在螢幕上後，呼叫destroyScene
function scene:destroyScene(event)
	--要做什麼事寫在這邊
    print("***** gameplay destroyScene event *****")
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene