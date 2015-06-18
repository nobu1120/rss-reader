--------------------------------------------
--
-- file : topPage.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 -18
--
-- comment : トップページ
--
--------------------------------------------

-- Library
local storyboard = require("storyboard")

local scene = storyboard.newScene()


function scene:createScene( event )
	local sceneGroup = self.view

	-- 背景
	local background = display.newRect(_W/2,_H/2,_W,_H)
	background:setFillColor(0.3,0.4,0.5)

	-- ページ遷移ボタン >>> 使い方:storyboardBtn(width,height,word,file,option)
	local gotoNewsPageBtn = storyboardBtn(300,100,"livedoorNews","Controller.article",{ time = 500 , effect = "slideLeft" })
	gotoNewsPageBtn.y = 250

	sceneGroup:insert(background)
	sceneGroup:insert(gotoNewsPageBtn)
end

function scene:willEnterScene( event )
end

function scene:enterScene( event )
	native.setActivityIndicator( false )
end

function scene:exitScene( event )

end

function scene:didExitScene( event )

end

function scene:destroyScene( event )
	display.remove(self.view)
	self.view = nil
end


scene:addEventListener("createScene",createScene)
scene:addEventListener("willEnterScene",willEnterScene)
scene:addEventListener("enterScene",enterScene)
scene:addEventListener("exitScene",exitScene)
scene:addEventListener("didExitScene",didExitScene)
scene:addEventListener("destroyScene",destroyScene)

return scene