------------------------------------------------
--
-- file : rssReader_class.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 - 16
--
-- comment : xml形式をRSS機能を用いて記事のデータを保持
--
------------------------------------------------

module(...,package.seeall)

-- Library
local rss = require("Rss.rss")
local atom = require("Rss.atom")

-- RssFeedを<item>タグごとに返す
local function returnRssFeed(file, path)

	-- xml形式をRSSfeed形式へ変換
    local feed = rss.feed(file, path)

    local stories = feed.items

    return stories
	
end

local function cutTitleAndLink( articleData )

	local data = {}

	for i = 1 , #articleData do
		data[i] = {}
		data[i]["title"] = articleData[i]["title"]
		data[i]["link"] = articleData[i]["link"]
	end

	return data
end

-- あらかじめ保存しておいたファイルから得た記事データからtitleとlinkを取得
local function getRssData( fileName )

	local data = {}
	local articleData = {}

	local path = system.pathForFile( fileName , system.CachesDirectory )
	local fh, errStr = io.open( path, "r" )

	if fh then
	    io.close(fh)
	   	articleData = returnRssFeed( fileName , system.CachesDirectory )
	else
	    local alert = native.showAlert( "RSS", "Feed temporarily unavaialble.", { "OK" }, true )
	end

	data = cutTitleAndLink(articleData)

	return data
end
	

local function listener(xmlUrl,fileName)

	local self = {}

	-- xmlURLの文章を解析してLuaのテーブルとしてファイルへ保存
	function self:getNewlyResponse()

		local function networkListener( event )

		    if ( event.isError ) then
		        local alert = native.showAlert( "RSS", "Feed temporarily unavaialble.", { "OK" }, true )
		    else
				local stories = returnRssFeed( event.response.filename, event.response.baseDirectory )				
		    end

		    return true
		end

		-- サイトの更新を監視していない
		network.setStatusListener( "news.livedoor.com", nil )

		-- 最新のレスポンスを受け取る
		network.download( xmlUrl , "GET" , networkListener , fileName , system.CachesDirectory )

	end

	return self

end


function new(xmlUrl,fileName)

    return listener(xmlUrl,fileName)

end

function func()
	return getRssData
end