--斗地主拆分牌算法
local M = {}
require "landlord_poker"
local inspect = require "inspect"

function table_copy_table(ori_tab)
	if (type(ori_tab) ~= "table") then
		return nil
	end
	local new_tab = {}
	for i,v in pairs(ori_tab) do
		local vtyp = type(v)
		if (vtyp == "table") then
			new_tab[i] = table_copy_table(v)
		elseif (vtyp == "thread") then
			new_tab[i] = v
		elseif (vtyp == "userdata") then
			new_tab[i] = v
		else
			new_tab[i] = v
		end
	end
	return new_tab
end


function M.split(set)
	--先找出单牌(左边没有右边也没有的) 2 和 鬼牌直接定为单牌
	--拆完牌的数据
	local split = {}
	local cards = {41,42,54,61,64,74,83,93,103,114,121,122,123,121,141,151,152,153,160,170}
	local set_t = table_copy_table(cards)
	local cards_Obj = LPokerUtils.numToObj(set_t)
	local cards_nums =LPokerUtils.get_point_nums(cards_Obj)
	local single_cards = LPokerUtils.get_single_cards(cards_nums)
	--第一步拆分完成
	--把拆分出来的牌从手牌中分出来
	local separate_cards = M.separate_card(set_t,single_cards)
	--把拆分出来的牌归类(根据特征值的大类)LPokerUtils.explodeValue(value)
	M.separate_card_1(separate_cards,split)
	--print(inspect(set_t))
	--print(inspect(separate_cards))
	--print(inspect(split))
	--第二步拆分
	M.continue_separate(set_t,split)
end

function M.continue_separate(set,split)
	local set_t = table_copy_table(set)
	local cards_Obj = LPokerUtils.numToObj(set_t)
	--local cards_nums =LPokerUtils.get_point_nums(cards_Obj)
	--剩余的牌中提取出炸弹,3个,对子
	local bomb , trio , one_pair , remain_cards
	bomb , remain_cards = LPokerUtils.getAllBomb(set_t , 0)
	trio , remain_cards = LPokerUtils.getAllTrio(remain_cards , 0)
	one_pair , remain_cards = LPokerUtils.getAllOnePair(remain_cards , 0)
	remain_cards,joke_pair = M.separate_joke_pair(remain_cards)

	print("bomb",inspect(bomb))
	print("trio",inspect(trio))
	print("one_pair",inspect(one_pair))
	print("remain_cards",inspect(remain_cards))

	
end

function M.separate_card_1(cards,split)
	local ret = {}
	local bomb , trio , one_pair ,joke_pair, remain_cards
	bomb , remain_cards = LPokerUtils.getAllBomb(cards , 0)
	trio , remain_cards = LPokerUtils.getAllTrio(remain_cards , 0)
	one_pair , remain_cards = LPokerUtils.getAllOnePair(remain_cards , 0)
	remain_cards,joke_pair = M.separate_joke_pair(remain_cards)
	M.range(bomb,split)
	M.range(trio,split)
	M.range(one_pair,split)
	M.range(joke_pair,split)
	local ex = {}
	for k,v in pairs(remain_cards) do
		local tmp = {v}
		local tmptzz =LPokerUtils.getCardsTypeValue(tmp)
		table.insert(ex,{cards = tmp , tzz = tmptzz})
	end
	M.range(ex,split)
end

--归类
function M.range(tb,split)
	for k,v in pairs(tb) do
		local _type = LPokerUtils.explodeValue(v.tzz)
		split[#split + 1] = {cards =v.cards,_type = _type}
	end
end

--set手牌  cards要分离的牌
function M.separate_card(set,cards)
	local ret = {}
	for k,v in pairs(M.get_origin_data(set,cards)) do
		table.insert(ret,M.dorp(set,v)) 
	end

	return ret
end

function M.separate_joke_pair(cards)
	local ret = cards
	local ret2 = {}
	local joke = {}
	local tzz
	if M.has(ret,160) and M.has(ret,170) then
		joke.cards = {}
		table.insert(	joke.cards,M.dorp(ret,160) )
		table.insert(	joke.cards,M.dorp(ret,170) )
		joke.tzz = LPokerUtils.getCardsTypeValue(joke.cards)
		table.insert(ret2,joke)
	end
	return ret,ret2
end


function M.has(t,c)

	for i,v in ipairs(t) do
		if v == c then
			return true
		end
	end
end

function M.get_origin_data(set,cards)
	local ret = {}
	local _cards = table_copy_table(cards)
	local obj = {}
	for i=1,#set do
		obj = LPokerUtils.numToObj(set[i])
		if _cards[obj.value] and _cards[obj.value] > 0 then
			table.insert(ret,set[i])
			_cards[obj.value] = _cards[obj.value] - 1
		end
	end
	return ret
end

function M.dorp(t,c)
		for i,v in ipairs(t) do
		if v == c then
			return table.remove(t,i)
		end
	end
end
M.split()
return M