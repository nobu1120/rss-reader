--------------------------------------------
--
-- file : article.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 -16
--
-- comment : 記事を表示,Controller
--
--------------------------------------------

-- Library
local storyboard = require("storyboard")
local scene

-- Model
local article_model = require("Model.article_model")
local model = article_model.new()

local article_view = require("View.article_view")
local view = article_view.new()
local categoryTab

scene = storyboard.newScene()

-- 前のシーンのビューがない時
function scene:createScene( event )

end

function scene:willEnterScene( event )

	-- ローディング
	native.setActivityIndicator( true )

	local sceneGroup = self.view
	
	view.createCategoryBar()
	sceneGroup:insert(view.viewGroup)

end

function scene:enterScene( event )

	local sceneGroup = self.view

	native.setActivityIndicator( false )

	-- 入室と同時に記事データを全て取得
	model.enterArticlePage()

	-- 戻るボタン
	local gotoTopPageBtn = storyboardBtn(200,100,"戻る","Controller.topPage",{ time = 500 , effect = "slideRight"})
	gotoTopPageBtn.y = _H-400
	sceneGroup:insert(gotoTopPageBtn)

end

function scene:exitScene( event )
	-- ローディング
	native.setActivityIndicator( true )
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