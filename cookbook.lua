--移除statusBar
display.setStatusBar(display.HiddenStatusBar)

--放置圖片
local image = display.newImageRect("imageName.png", 480, 320)
image.x = 240
image.y = 160

--製作按鈕(要先把ui.lua放進)
local ui = require("ui")

local onButtonTouched = function(event)
    if event.phase == "press" then
        print"just pressed sound button"
    end
    if event.phase == "release" then
        print"just released sound button"
    end
end

local myButton = ui.newButton{
            defaultSrc = "buttonImage.png",
            defaultX=51,
            defaultY=224,
            overSrc = "buttonImagePressed.png",
            overX=51,
            overY=224,
            onEvent = onButtonTouched,
            id="myButton1",
            text="",
            font = "Helvetica",
            textColor = {255,255,255,255},
            size = 16,
            emboss = false
}
myButton.x = 37
myButton.y = 131

--播放聲音、暫停播放、釋放聲音記憶體
audio.loadStream() --load背景音樂
audio.loadSound()  --load音效
audio.play()
audio.pause()
audio.resume()
audio.dispose()
audioTrack = nil

--函數定義
local functionName = function()
    -- 要做的事
end

--for迴圈
for i=1,10 do
    print(i)
end

--while迴圈
local i=1
while i<=10 do
    print(i)
    i=i+1
end

--if判斷1
if something then
    -- 要做的事
end

--if判斷2
if something then
    -- 要做的事
elseif something else then
    -- 要做的事
end

--if判斷3
if something then
    -- 要做的事
else
    -- 要做的事
end

--生成有次序的table1
local fruitBag = {}
fruitBag[1] = "apple"
fruitBag[2] = "banana"
fruitBag[3] = "mango"
print(fruitBag[1])

--生成有次序的table2
local fruitBag ={"apple","banana","mango"}
print(fruitBag[1])

--生成無次序的table
local fruitBag={
    red="apple",
    yellow="banana"
}
fruitBag.green = "mango"
print(fruitBag.red)
print(fruitBag["red"])

--table的數量
#table

--table 加入元素
table.insert(tableName,position,addElement)

--table 移除元素
table.insert(tableName,position)

--有次序的table列舉元素
for i=1, #fruitName do
    print(fruitName[i])
end

--無次序的table列舉元素
for key,value in pairs(tableName) do
end

--改變圖形位置
object.x
object.y

--改變圖形大小
object.xScale --2的話是2倍，1的話是1倍
object.yScale

--圖形旋轉
object.rotation --角度

--圖形可見
object.isVisible --true or false

--圖形透明度
object.alpha --1到0，0是完全透明

--畫圓形
local myCircle = display.newCircle( 100, 100, 30 )
myCircle:setFillColor(128,128,128)
myCircle.strokeWidth = 5
myCircle:setStrokeColor(128,0,0)  -- red

--畫方形
local myRectangle = display.newRect(0, 0, 150, 50)
myRectangle.strokeWidth = 3
myRectangle:setFillColor(140, 140, 140)
myRectangle:setStrokeColor(180, 180, 180)

--畫圓角方形
local myRoundedRect = display.newRoundedRect(0, 0, 150, 50, 12)
myRoundedRect.strokeWidth = 3
myRoundedRect:setFillColor(140, 140, 140)
myRoundedRect:setStrokeColor(180, 180, 180)

--畫多邊形
local star = display.newLine( 0,-110, 27,-35 )
star:append( 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, 0,-110 )
star:setColor( 255, 102, 102, 255 )
star.width = 3

--移動圖層順序
object:toFront()
object:toBack()

--移動東西，或是改變東西的狀態、變形
transition.to(somethingToMove,
    {time=1200, x=250, transition = easing.outExpo,
    onComplete = function() justDoSomeThing = false end})

easing.inExpo()
easing.inOutExpo()
easing.inOutQuad()
easing.inQuad()
easing.linear()
easing.outExpo()
easing.outQuad()

--過一段時間要執行某函式的寫法，用timer.performWithDelay()
local doSomething = function()
    print("do something")
end
timer.performWithDelay(2000,doSomething)

--觸碰事件
moveMyCar = function(event)
    if event.phase == "began" then
        transition.to(car,{time=800, x=event.x, y = event.y})
    end
end

Runtime:addEventListener("touch", moveMyCar)

--加上觸摸事件間聽器
local justTouchScreen = function(event)
    --do something here, event.phase=="began" or "ended"
end

Runtime:addEventListener("touch", onSceneTouch)

--各種滑動手勢偵測
local justTouchScreen = function(event)
    if event.phase == "ended" then
        if event.xStart < event.x and (event.x - event.xStart)>=30 then
            print("swipe right")
            car.x = car.x+10
            return true
        elseif event.xStart > event.x and (event.xStart - event.x)>=30 then
            print("swipe left")
            car.x = car.x-10
            return true
        end

        if event.yStart < event.y and (event.y - event.yStart)>=30 then
            print("swipe down")
            car.y = car.y+10
            return true
        elseif event.yStart > event.y and (event.yStart - event.y)>=30 then
            print("swipe left")
            car.y = car.y-10
            return true
        end
    end
end

Runtime:addEventListener("touch", onSceneTouch)

--單單為某一物體加上觸碰監聽器1
local justTouchCar = function(event)
    --do something here, event.phase=="began" or "ended"
end
car:addEventListener("touch", justTouchCar)

--單單為某一物體加上觸碰監聽器2
function car:touch(event)
    --do something here, event.phase=="began" or "ended"
end
car:addEventListener("touch", car)

--Endless Running Game
--object.enterFrame = scrollSomething //不同的背景、不同的速度

--movieClip
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

--不停放大縮小的按鈕
local function startBtnScaleUp()
        local startBtnScaleDown = function()
                transition.to(startBtn,{time=150,xScale=1,yScale=1,onComplete= startBtnScaleUp})
        end
        transition.to(startBtn,{time=150,xScale=1.06,yScale=1.06,onComplete= startBtnScaleDown})
end
startBtnScaleUp()

--支援iphone5
    --config.lua
    local thisDeviceHeight = 480
    if(system.getInfo("model") == "iPhone") or (system.getInfo("model") == "iPod touch") then
        local isIPhone5 = (display.pixelHeight >960)
        if isIPhone5 then
            thisDeviceHeight = 568
        end
    end

    application =
    {
        content =
        {
           width = 320,
           height = thisDeviceHeight,
           scale = "zoomStretch",
           fps = 30,
           antialias = true,      
           imageSuffix =
            {
                ["@2x"] = 1.8,
            },
        },
    }

    --程式裡處理
    local isIPhone5
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

--移除物體
object:removeSelf()

--物理引擎使用
local physics = require "physics"
physics.start()
physics.addBody()
object:applyForce()

--物理物體碰撞
onCollision = function(event)
    if event.phase == "began" then
        --do something here
    end
end

Runtime:addEventListener("collision", onCollision)

--storyboard
local storyboard = require("storyboard")
local scene = storyboard.newScene()
local screenGroup
--畫面沒到螢幕上時，先呼叫createScene，負責UI畫面繪製
function scene:createScene(event)
    screenGroup = self.view
    --要做什麼事寫在這邊
end

--畫面到螢幕上時，呼叫enterScene，移除之前的場景
function scene:enterScene(event)
    --要做什麼事寫在這邊
end

--即將被移除，呼叫exitScene，停止音樂，釋放音樂記憶體
function scene:exitScene()
    --要做什麼事寫在這邊
end

--下一個畫面呼叫完enterScene、完全在螢幕上後，呼叫destroyScene
function scene:destroyScene(event)
    --要做什麼事寫在這邊
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene

--storyboard到別的場景
local setting ={
    effect = "slideLeft",
    time = 300,
}
storyboard.gotoScene("otherScene", setting)

--判斷語系
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
--加入不同語系圖片 coverTitle = display.newImageRect("CoverTitle_"..language..".png",318,124)

--判斷是否有網路
local isMyNetworkReachable
local http = require("socket.http")
local myUrl = "http://tw.yahoo.com"
local response = http.request(myUrl)
if response ==nil  then
    isMyNetworkReachable = false
else
    isMyNetworkReachable = true
end

--WebView
local myWebView = native.newWebView(0,0,320,412)
myWebView:request("http://appsgaga.com/AndroidMobileMiniWebSite/mobile.html")

--用完webView要記得丟棄
myWebView:removeSelf()
myWebView = nil

--用自己的文字
require('bmf')
local myleftLabelFont = bmf.loadFont('LeftLabelFont.fnt')
local leftLabel = bmf.newString(myleftLabelFont,"someString")

--存取資料
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

--字串長度
string.len()

---切分字串
string.sub("某個字串",1,2)

--數字轉字串
tostring()

--字串轉數字
tonumber()