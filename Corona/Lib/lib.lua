--------------------------------------------
--
-- file : lib.lua
--
-- creater : Nobuyoshi Tanaka
--
-- create - date : 2015 - 06 -16
--
-- comment : よく使う関数
--
--------------------------------------------
_W = display.contentWidth
_H = display.contentHeight

function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

-- 文字列を一定文字数で改行させる
function startNewline( str , chaNum )

    local str_string = tostring(str)
    local str_newLined = ""
    local newLineCount = 0
    local startPoint = 1
    local finishPoint = chaNum

    str_newLined = string.sub(str_string,startPoint,finishPoint)
    startPoint = finishPoint+1
    finishPoint = startPoint + chaNum - 1

    local function subNewline()

        if startPoint < str_string:len() then
            local subStr_cut = string.sub(str_string,startPoint,finishPoint)
            startPoint = finishPoint + 1
            finishPoint = startPoint + chaNum - 1
            str_newLined = str_newLined .. '\n' .. subStr_cut
            newLineCount = newLineCount + 1
            if startPoint < str_string:len() then
                subNewline()
            end
        else
            -- 改行しない
        end 
    end

    if startPoint < str_string:len() then
        if str_string:len() == (chaNum-1)*newLineCount then
        else
            subNewline()
        end
    else
        -- 改行しない
    end

    return str_newLined
end

function storyboardBtn(X,Y,word,file,option)

    local storyboard = require("storyboard")
    local group = display.newGroup()
    local btn = display.newRect(group,300,300,X,Y)
    btn:setFillColor(1)
    local text = display.newText(group,word,btn.x,btn.y,nil,40)
    text:setFillColor(0)

    local function storyboardListener(event)

        if event.phase == "began" then 

            btn:setFillColor(0.3,0.4,0.5)

        elseif event.phase == "ended" then

            btn:setFillColor(0.3,0.2,0.4)

            storyboard.gotoScene(file,option)

        end

        return true
    end

    btn:addEventListener("touch",storyboardListener)

    return group
end

