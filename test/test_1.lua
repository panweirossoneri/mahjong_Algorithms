local name = {

 "  墨尔本.晴",
 " 心宽何处不桃源",
 "  涙冷颜、",
 " 离人愁",
 "江船夜雨听笛",
 " 灬 离歌且莫翻新阕",
 "捞月亮的人",
 "听弦断ヽ　断那三千痴缠。",
 "残冬醉离殇、",
 "离殇丶 似水流年飞逝",
 "叶繁终唯枯。",
 "卿以君歌",
      "远赴相思",
      "太平洋",
      "仦__灬最美年华",
      "绿竹猗猗",
      "流年//岁月",
      "忆兮倾此１生为伊乆°",
      "黑白曲线丶谁落兮了岁尘",
      "笙歌醉梦",
      "待绾之人。",
      "凉城昔忆i",
      "月下瑹歌゛",
      "一曲琵琶倾城梦",
      "■岁月流年﹌",
      "童言无忌！",
      "陌丄、重染。",
      "枯叶蝶的伤。",
      "深府石板幽径",
      "颠覆天下",
      "后宫三千男妃@",
      "苏墨白ゥ",
      "几年离索，",
      "困你的牢笼",
      "法西斯",
      "长欢久安",
      "送君千里",
      "洒落凡尘的雨",
     " 妾本良人i",
}
function create_sql()
  --1250   1418
	for i=1,200 do
		--print(string.format("INSERT INTO `qicaipoker`.`usergame`(`uid`, `uchip`, `udiamond`, `utombola`, `ulevel`, `matchticket`, `udocard`, `utime`, `uvip`, `uldays`, `uscore`, `uhscore`, `uwincnt`, `ulosecnt`, `udrawcnt`, `win_streak`, `ulogins`, `ustatus`, `gt`, `mucount`, `zgcount`, `strong_box`, `br_wincnt`, `br_losecnt`, `br_drawcnt`, `day_ticket`, `month_ticket`, `master_integrate`) VALUES (1201350+%d, 50000, 0, 0, 1, 0, 0, 1525576489, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0);",i))
    --print(string.format("INSERT INTO `qicaipoker`.`userinfo`(`uid`, `game`, `puid`, `uemail`, `pfid`, `usid`, `uname`, `uface`, `usex`, `login_type`, `mobile`, `device_id`, `urtime`, `ustatus`, `next_key`, `is_pay`) VALUES (1201379 + %d, 1, 1231232379 + %d , '1201010@163.com', 1, 1, '%s', 'http://cnd.7cpoker.com/image/header/%d.png', 2, NULL, NULL, '', 1525576489, 0, NULL, 0);",i,i,name[i],i//2))
	 print(string.format("UPDATE `qicaipoker`.`userinfo` SET `uface` = 'http://cnd.7cpoker.com/image/header/%d.png' WHERE `uid` = 1201000 + %d;",i%40,i))
  end
end

create_sql()

--print(#name)
--INSERT INTO `qicaipoker`.`usergame`(`uid`, `uchip`, `udiamond`, `utombola`, `ulevel`, `matchticket`, `udocard`, `utime`, `uvip`, `uldays`, `uscore`, `uhscore`, `uwincnt`, `ulosecnt`, `udrawcnt`, `win_streak`, `ulogins`, `ustatus`, `gt`, `mucount`, `zgcount`, `strong_box`, `br_wincnt`, `br_losecnt`, `br_drawcnt`, `day_ticket`, `month_ticket`, `master_integrate`) VALUES (1201199, 50000, 0, 0, 1, 0, 0, 1525576489, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0);
--http://cnd.7cpoker.com/image/header/96.png

--UPDATE `qicaipoker`.`userinfo` SET `uface` = 'http://cnd.7cpoker.com/image/header/%d.png' WHERE `uid` = 1201417;
