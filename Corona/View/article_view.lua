--------------------------------------------
--
-- file : article_view.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 -16
--
-- comment : 記事表示の部分
--
--------------------------------------------

module(...,package.seeall)

-- Library
local widget = require( "widget" )
local json = require("json")

-- Model
local article_model = require("Model.article_model")
local model = article_model.new()

local function listener()

	local self = {}
	local firstView = display.newGroup()
	self.viewGroup = display.newGroup()

	function self.createCategoryBar()

		local font = native.newFont( "Helvetica-Bold", 16 )
	
		--------------------------------------------
		--
		-- comment : 記事を画面上に表示する
		--
		--------------------------------------------
		self.viewGroup = display.newGroup()
		local articleGroup = display.newGroup()
		local background = display.newRect(self.viewGroup,_W/2,_H/2 + 50,_W,_H)
		background:setFillColor(0.3,0.8,0.5)

		-- 一つの記事を表示し、タップすると、その記事はリンクを飛ぶ
		local function displayArticle(data)

			local title = display.newText(data.title,280,80,font,25)
			-- 左端を基準とする
			title.anchorX = 0
			title.x = 20
			title:setFillColor(1)
			title:scale(0.7,1)

			-- リンクを移動
			local function titleListener( event )
				system.openURL(data.link)
			end
			title:addEventListener("tap",titleListener)

			return title
		end

		--　最初にページに入ったときの挙動
		local function enterListener( event )

			display.remove(firstView)
			firstView = nil
			firstView = display.newGroup()

			if event.name == "enter-articlePage" then
				for i = 1 , 3 do
					local article = displayArticle(event.data[i])
    				article.y = article.y + 50*(i-1)
    				firstView:insert(article)
				end
			end
			firstView.isVisible = true
			self.viewGroup:insert(firstView)
		end
		Runtime:addEventListener("enter-articlePage",enterListener)

		---------------------------------------------
		--
		-- comment : カテゴリーを選択するタブを作成
		--
		---------------------------------------------

		local tabGroup = display.newGroup()

		-- タップされたカテゴリー表示
		local function categoryTapListener( event )

			firstView.isVisible = false

			-- 記事を入れるグループ
			display.remove(articleGroup)
			articleGroup = nil
			articleGroup = display.newGroup()
    		
    		-- 選択されたカテゴリーの記事のタイトルとリンクを全て取得、記事を表示
    		local data = model.getTitleAndLink(event.target._id)
    		for i = 1 , 3 do
    			local article = displayArticle(data[i])
    			article.y = article.y + 50*(i-1)
    			articleGroup:insert(article)
    		end
    		self.viewGroup:insert(articleGroup)
		end

		-- タブの一つ一つのボタンを保持
		local tabButtons = {}

		for i = 1 , 10 do
			tabButtons[i] = {}
			tabButtons[i].id = i
			tabButtons[i].size = 20
			tabButtons[i].labelYOffset = -10
			tabButtons[i].labelColor = { default={ 0.5, 0.5, 0.3 }, over={ 0.3 , 0.4 , 0.5 } }
			tabButtons[i].onPress = categoryTapListener
		end

		-- 各種カテゴリー
		tabButtons[1].selected = true
		tabButtons[1].label = "主要"
		tabButtons[2].label = "国内"
		tabButtons[3].label = "海外"
		tabButtons[4].label = "IT経済"
		tabButtons[5].label = "芸能"
		tabButtons[6].label = "スポーツ"
		tabButtons[7].label = "映画"
		tabButtons[8].label = "グルメ"
		tabButtons[9].label = "女子"
		tabButtons[10].label = "トレンド"

		-- タブバー作成
		local tabBar = widget.newTabBar
		{
		  	left = 0,
		    top = 0,
		    width = display.actualContentWidth,
		    height = 50,
		    -- tabSelectedFrameWidth = _W/10,
		    tabSelectedFrameHeight = 50,
		    buttons = tabButtons
		}


		-- ---------------------------------------
		-- --
		-- -- comment : 横スクロール作成
		-- --
		-- ---------------------------------------
		-- local function scrollListener( event )

		--     local phase = event.phase
		--     if ( phase == "began" ) then print( "Scroll view was touched" )
		--     elseif ( phase == "moved" ) then print( "Scroll view was moved" )
		--     	for i = 1 , 10 do
		--     		tabButtons[i].labelXOffset = -event.target.x*i
		--     		print(tabButtons[i].labelXOffset)
		--     	end
		--     elseif ( phase == "ended" ) then print( "Scroll view was released" )
		--     end

		--     -- In the event a scroll limit is reached...
		--     if ( event.limitReached ) then
		--         if ( event.direction == "up" ) then print( "Reached top limit" )
		--         elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
		--         elseif ( event.direction == "left" ) then print( "Reached left limit" )
		--         elseif ( event.direction == "right" ) then print( "Reached right limit" )
		--         end
		--     end

		--     return true
		-- end

		-- -- スクロール
		-- local scrollView = widget.newScrollView
		-- {
		--     top = 0,
		--     left = 0,
		--     width = _W,
		--     height = 80,
		--     scrollWidth = _W+200,
		--     rightPadding = 50,
		--     scrollHeight = _H,
		--     listener = scrollListener,
		-- }

		-- scrollView:insert(tabBar)
		-- self.viewGroup:insert(scrollView)
		tabGroup:insert(tabBar)
		self.viewGroup:insert(tabGroup)
		self.viewGroup:insert(articleGroup)

	end

	return self

end

function new()
	return listener()
end

