----------------------------------------------
--
-- file : main.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 -16
--
-- comment : Rss-readerの作成課題
--
----------------------------------------------

-- 設定ファイル
require("Lib.tsconfig")

-- マルチタッチ有効
system.activate( "multitouch" )

-- ステータスバーを隠す
display.setStatusBar( display.HiddenStatusBar )

-- Library
local storyboard = require("storyboard")
storyboard.purgeOnSceneChange = true

-- メモリを確認
--[[
storyboard.isDebug = true
Runtime:addEventListener( "enterFrame", storyboard.printMemUsage )
]]

-- トップページへ移動
storyboard.gotoScene("Controller.topPage",{time = 500,effect = "fade"})