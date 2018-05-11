--[[
    麻将的牌的规则(十六进制)：0x11：1万 0x12：1筒。。。
    扑克的牌的规则(个位代表花色，十位和百位代表点数)：31：方块3,154：黑桃2,160:小王,170：大王
    
    type:默认为扑克，麻将为 “mj”
    lai_zi:扑克传对应的点数，麻将为那张牌的值
    set:要检测的牌
]]
card_value = {}
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
function card_value.point(t)
    local point = 0
    for _,v in pairs(t.set) do
        point = point + get_value{c=v,type=t.type}
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
    
end


function card_value.repeat(t)
    
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
tb.set = {31,32,33,34}
tb.lai_zi = 3
print(card_value.lai_zi_nums(tb))