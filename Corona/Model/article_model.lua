--------------------------------------------
--
-- file : article_model.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 -16
--
-- comment : 記事データのを保持
--
--------------------------------------------

module(...,package.seeall)

local function listener()

	local self = {}

	-- Rss-reader作成クラス
	local rssReader_class = require("Class.rssReader_class")

	-- 記事のタイトルとリンクを取得
	local getArticleData = rssReader_class.func()

	local category = {}
	for i = 1 , 10 do
	    category[i] = nil
	end

	-- 各種ファイル名
	local xmlFile = {}
	xmlFile[1]  = "top.xml"
	xmlFile[2]  = "dom.xml"
	xmlFile[3]  = "int.xml"
	xmlFile[4]  = "eco.xml"
	xmlFile[5]  = "ent.xml"
	xmlFile[6]  = "spo.xml"
	xmlFile[7]  = "52.xml"
	xmlFile[8]  = "gourmet.xml"
	xmlFile[9]  = "love.xml"
	xmlFile[10] = "trend.xml"

	-- 主要，国内，海外，IT 経済，芸能，スポーツ，映画，グルメ，女子，トレンド
	-- この時点ではまだ情報を受け取っていない
	category[1]  = rssReader_class.new("http://news.livedoor.com/topics/rss/top.xml",xmlFile[1])
	category[2]  = rssReader_class.new("http://news.livedoor.com/topics/rss/dom.xml",xmlFile[2])
	category[3]  = rssReader_class.new("http://news.livedoor.com/topics/rss/int.xml",xmlFile[3])
	category[4]  = rssReader_class.new("http://news.livedoor.com/topics/rss/eco.xml",xmlFile[4])
	category[5]  = rssReader_class.new("http://news.livedoor.com/topics/rss/ent.xml",xmlFile[5])
	category[6]  = rssReader_class.new("http://news.livedoor.com/topics/rss/spo.xml",xmlFile[6])
	category[7]  = rssReader_class.new("http://news.livedoor.com/rss/summary/52.xml",xmlFile[7])
	category[8]  = rssReader_class.new("http://news.livedoor.com/topics/rss/gourmet.xml",xmlFile[8])
	category[9]  = rssReader_class.new("http://news.livedoor.com/topics/rss/love.xml",xmlFile[9])
	category[10] = rssReader_class.new("http://news.livedoor.com/topics/rss/trend.xml",xmlFile[10])

	-- ネットワーク対応時のみネットワークを監視
	-- ここでxml形式urlの情報をxmlファイルへ保存
	if network.canDetectNetworkStatusChanges then

	    local function networkListener( event )
	        if event.isReachable then
	            for i = 1 , 10 do
	                category[i]:getNewlyResponse()
	            end
	        end
	    end

	    network.setStatusListener( "news.livedoor.com", networkListener )
	else
	    native.showAlert("network", "not supported", {"OK"})
	end

	-- 選択されたカテゴリーに一致する記事のタイトルとリンクを取得する
	function self.getTitleAndLink(categoryId)
		print("categoryId:"..categoryId)
		local data = {}
		for k,v in pairs(category) do
			if tostring(k) == tostring(categoryId) then
				data = getArticleData(xmlFile[k])
			end
		end

		return data
	end

	function self.enterArticlePage()
		
		local data = getArticleData(xmlFile[1])

		local disEvent = {

			name = "enter-articlePage",
			data = data
		}
		Runtime:dispatchEvent(disEvent)

	end

	return self

end

function new()
	return listener()
end