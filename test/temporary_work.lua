--[[
    麻将的牌的规则(十六进制)：0x11：1万 0x12：1筒。。。
    扑克的牌的规则(个位代表花色，十位和百位代表点数)：31：方块3,154：黑桃2,160:小王,170：大王
    
    type:默认为扑克，麻将为 “mj”
    lai_zi:扑克传对应的点数，麻将为那张牌的值
    set:要检测的牌
]]
card_value = {}
local inspect = require "inspect"
--获取点数
local function get_value(t)
    if t.type == "mj" then
        return t.c&0xf--c%16
    else
        return t.c//10
    end
end
--获取花色
local function get_type(t)
    if t.type == "mj" then
        return t.c>>4--c/16
    else
        return t.c%10
    end
end
--
local function get_point(t)
    if t.type == "mj" then        
        if get_type{c=t.c,type=t.type} == 4 then
            return 1
        else
            if get_value{c=t.c,type=t.type} == 1 or get_value{c=t.c,type=t.type} == 9 then
                return 1
            else
                return 3
            end
        end
    else
        return t.c//10
    end
end

--花色分组
local function mj_splice_by_type(set)
    if not set then
        return {}
    end
    local t = {[1] = {},[2] = {},[3] = {},[4] = {}}
    for i =1,#set do
        table.insert(t[set[i]>>4],set[i])
    end
    return t
end

local function pk_splice_by_type(set,type)
    if not set then
        return {}
    end
    local t = {[1] = {},[2] = {},[3] = {},[4] = {}}
    for i=1,#set do
        table.insert(t[get_type{c=set[i],type=type}],set[i])
    end
    return t
end

local function splice_by_type(t)
    local ret = {}

    if t.type == "mj" then
        ret = mj_splice_by_type(t.set)
    else
        ret = pk_splice_by_type(t.set)
    end

    return ret
end

function card_value.point(t)
    local point = 0
    for _,v in pairs(t.set) do
        point = point + get_point{c=v,type=t.type}
    end
    return point/#t.set
end

function card_value.colour(t)
    local nums = 0
    for k,v in pairs(t.set) do
        nums = nums + (get_type{c=v,type=t.type} - 1 )
    end
    return nums/#t.set
end


function card_value.same_colour(t)
    local tb = splice_by_type(t)
    print(inspect(tb))
    local _value = 0
    for _,v in pairs(tb) do
        if #v//5 > 0 then
            _value = _value + #v//5
        end
    end
    return _value * 3
end

--获取每种点数的牌数量
local function mj_get_point_nums(set)
    local ret = {}
    for k,v in pairs(set) do
        if not ret[v] then
            ret[v] = 1
        else
            ret[v] = ret[v] + 1
        end
    end
    return ret
end

local function pk_get_point_nums(set)
    local ret = {}
    for k,v in pairs(set) do
        local _value = get_value{c=v}
        if not ret[_value] then
            ret[_value] = 1
        else
            ret[_value] = ret[_value] + 1
        end
    end
    return ret
end

local function mj_get_repeatability(t)
    local nums = 0
    local tb = mj_get_point_nums(t.set)
    for k,v in pairs(tb) do
        if v == 4 then
            nums = nums + 4
        elseif v == 3 then
            nums = nums + 3
        elseif v == 2 then
            nums = nums + 2
        end
    end
    return nums
end

local function get_repeatability(t)
    local nums = 0
    local tb = {}
    if t.type == "mj" then
        tb = mj_get_point_nums(t.set)
    else
        tb = pk_get_point_nums(t.set)
    end
    for k,v in pairs(tb) do
        --超过4张暂时未处理
        if v == 4 then
            nums = nums + 4
        elseif v == 3 then
            nums = nums + 3
        elseif v == 2 then
            nums = nums + 2
        end
    end
    return nums
end

function card_value.repeatability(t)
    return get_repeatability(t) or 0
end

local function mj_get_continuous(set)
    local flag = {}
    for i=1,#set - 2 do
        if not flag[i] and get_type{c=set[i],type="mj"} ~= 4 then
            local pos = {i,0,0}
            for k,v in pairs(set) do
                if not flag[k] and v == set[i] + 1 then
                    pos[2] = k
                end
                if not flag[k] and v == set[i] + 2 then
                    pos[3] = k
                end
                if math.min(table.unpack(pos)) ~= 0 then
                    for i=1,#pos do
                        flag[pos[i]] = true
                    end
                    break
                end
            end
        end
    end
    return flag
end

local function get_continuous(set,index)
    local flag = {}
    for i=1,#set - 2 do
        if not flag[i] and get_type{c=set[i],type="mj"} ~= 4 then
            local pos = {}
            for k=1,index do
                pos[k] = 0
                if k == 1 then
                    pos[1] = i
                end
            end
            for k,v in pairs(set) do
                for y=1,index do
                    if not flag[k] and v == set[i] + y - 1 then
                        pos[y] = k
                    end
                end
                print(inspect(pos))
                if math.min(table.unpack(pos)) ~= 0 then
                    for i=1,#pos do
                        flag[pos[i]] = true
                    end
                    break
                end
            end
        end
    end
    return flag
end

function card_value.continuous(t)
    
end

function card_value.lai_zi_nums(t)
    local nums = 0
    for _,v in pairs(t.set) do
        if t.type == "mj" and v == t.lai_zi then
            nums = nums + 1
        elseif not t.type and get_value{c=v,type=t.type} == t.lai_zi then
            nums = nums + 1
        end
    end
    return nums
end


local tb = {}
tb.set = {31,31,31,31,31,32,33,34}
tb.set = {0x12,0x13,0x13,0x14,0x14,0x15,0x16,0x16,0x25,0x33,0x41}
--tb.type = "mj"
tb.lai_zi = 3
--print(card_value.repeatability(tb))

print(inspect(get_continuous(tb.set,3)))