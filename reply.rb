require 'net/http'
require 'CGI'


myid = '1404793074' # 唐朝兄弟

cookie="UOR=,www.weibo.com,; SinaRot//=53; SINAGLOBAL=1314399494498.6396; ULV=1314399499426:1:1:1:1314399494498.6396:; USRHAJAWB=usrmdins13104; Apache=1314399494498.6396; _s_tentry=-; SUE=es%3Dc81dab07d445a6ce00ec80081dd7dd5d%26ev%3Dv1%26es2%3Db8bf1b5e31e3040751683267d3b89984%26rs0%3DhR5Mw5u3GGf89LuHbEBuU40DmiE%252FwCthNx5IO5R7dJfJYIod75uk7HhQThcTTuHbuMahIMqunM1dB5%252F%252BGg%252FRCBQmVb0%252Fny2pnrvwOtlP1JI6e0%252BRshFrk53pkYe15i8hizlrIacoIilXUKTeWf1ndhy%252Bl8qBsnvWgaWdzn%252FfilQ%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1314399762%26et%3D1314486162%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ln%3D1404793074%26os%3D%26fmp%3D%26lcp%3D%26us%3D; ALF=1315004560; SSOLoginState=1314399762; wvr=3; un=whju; WNP=1404793074%2C255; ads_ck=0"

http = Net::HTTP.new("http://www.weibo.com", 80)
headers = {
  'Cookie' => cookie,
  'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
  'Accept' => "UOR=,www.weibo.com,; SinaRot//=53; SINAGLOBAL=1314399494498.6396; ULV=1314399499426:1:1:1:1314399494498.6396:; USRHAJAWB=usrmdins13104; Apache=1314399494498.6396; _s_tentry=-; SUE=es%3Dc81dab07d445a6ce00ec80081dd7dd5d%26ev%3Dv1%26es2%3Db8bf1b5e31e3040751683267d3b89984%26rs0%3DhR5Mw5u3GGf89LuHbEBuU40DmiE%252FwCthNx5IO5R7dJfJYIod75uk7HhQThcTTuHbuMahIMqunM1dB5%252F%252BGg%252FRCBQmVb0%252Fny2pnrvwOtlP1JI6e0%252BRshFrk53pkYe15i8hizlrIacoIilXUKTeWf1ndhy%252Bl8qBsnvWgaWdzn%252FfilQ%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1314399762%26et%3D1314486162%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ln%3D1404793074%26os%3D%26fmp%3D%26lcp%3D%26us%3D; ALF=1315004560; SSOLoginState=1314399762; wvr=3; un=whju; WNP=1404793074%2C255; ads_ck=0",
  'Referer' => "http://www.weibo.com/1654592030/xl9GPxW4u"
}

path_reply = "comment/addcomment.php"
replyUid = "";
cid = "";
source="uid=1404793074&ownerUid=1654592030&resourceId=3350421398088054&productId=miniblog&productName=&resTitle=%25E2%2596%25B2%2520%25E4%25B8%2593%25E5%25AE%25B6%25E5%2588%2586%25E6%259E%2590%25EF%25BC%258C%25E4%25B8%258A%25E6%25B5%25B7%25E6%2596%25B9%25E8%25A8%2580%25E6%25B2%25AA%25E8%25AF%25AD%25E4%25B8%25A5%25E9%2587%258D%25E5%259C%25B0%25E5%25BD%25B1%25E5%2593%258D%25E7%259D%2580%25E4%25B8%258A%25E6%25B5%25B7%25E6%2588%2590%25E4%25B8%25BA%25E5%259B%25BD%25E9%2599%2585%25E5%258C%2596%25E5%25A4%25A7%25E9%2583%25BD%25E5%25B8%2582%25E3%2580%2582%25E6%2597%25A0%25E8%25AE%25BA%25E4%25BD%25A0%25E4%25BD%259C%25E4%25B8%25BA%25E4%25B8%258A%25E6%25B5%25B7%25E6%259C%25AC%25E5%259C%25B0%25E4%25BA%25BA%25EF%25BC%258C%25E8%25BF%2598%25E6%2598%25AF%25E4%25B8%258A%25E6%25B5%25B7%25E5%25A4%2596%25E5%259C%25B0%25E4%25BA%25BA%25EF%25BC%258C%25E4%25BD%25A0%25E6%2598%25AF%25E5%2590%25A6%25E8%25B5%259E%25E6%2588%2590%25E4%25B8%258A%25E6%25B5%25B7%25E5%258F%2596%25E6%25B6%2588%25E6%25B2%25AA%25E8%25AF%25AD%25EF%25BC%259F&resInfo=&listInDiv=2&replyUid=1068614534&ccontent=%25E5%258F%2591%25E8%25BF%2599%25E4%25B8%25AA%25E5%25BE%25AE%25E5%258D%259A%25E7%259A%2584%25E7%25BA%25AF%25E7%25B2%25B9%25E6%2598%25AF%25E9%2580%259A%25E8%25BF%2587%25E6%2589%25BE%25E9%25AA%2582%25E6%259D%25A5%25E5%25A2%259E%25E5%258A%25A0%25E8%25BD%25AC%25E5%258F%2591%25E8%25AF%2584%25E8%25AE%25BA%25E9%2587%258F%25EF%25BC%258C%25E6%2588%2591%25E7%259C%258B%25E4%25BA%2586%25E5%25A5%25BD%25E5%2587%25A0%25E9%25A1%25B5%25EF%25BC%258C%25E6%25B2%25A1%25E4%25B8%2580%25E4%25B8%25AA%25E6%2594%25AF%25E6%258C%2581%25E7%259A%2584%25EF%25BC%258C%25E6%258B%259C%25E6%2589%2598%25EF%25BC%258C%25E6%2598%25AF%25E4%25B8%25AA%25E6%25AD%25A3%25E5%25B8%25B8%25E4%25BA%25BA%25E9%2583%25BD%25E4%25B8%258D%25E4%25BC%259A%25E5%2590%258C%25E6%2584%258F%25E5%25A5%25BD%25E4%25B8%258D%25EF%25BC%259F%25E9%2582%25A3%25E4%25B8%25AD%25E6%2596%2587%25E8%25BF%2598%25E5%25BD%25B1%25E5%2593%258D%25E5%259B%25BD%25E9%2599%2585%25E5%258C%2596%25E5%2591%25A2%25EF%25BC%258C%25E8%25A6%2581%25E4%25B8%258D%25E5%2590%25A7%25E4%25B8%25AD%25E6%2596%2587%25E4%25B9%259F%25E5%258F%2596%25E6%25B6%2588%25E5%2596%25BD%25EF%25BC%259F&cid=2021108263052885522&forward=0&content=%E8%BF%99%E4%B8%AA%E6%98%8E%E6%98%BE%E6%98%AF%E6%98%AF%E6%9F%93%E9%A6%99%E4%B8%BA%E6%8C%91%E6%8B%A8%E5%9C%B0%E5%9F%9F%E7%9F%9B%E7%9B%BE%E5%92%8C%E7%82%92%E4%BD%9C%E8%87%AA%E5%B7%B1%E7%BC%96%E9%80%A0%E5%87%BA%E6%9D%A5%E7%9A%84%EF%BC%8C%20%E7%94%A8%E5%BF%83%E4%B9%8B%E9%99%A9%E6%81%B6%EF%BC%81%EF%BC%81%E6%9C%80%E7%97%9B%E6%81%A8%E8%BF%99%E7%B1%BB%E5%88%AB%E6%9C%89%E7%94%A8%E5%BF%83%E6%88%96%E4%B8%BA%E4%BA%86%E7%82%92%E4%BD%9C%E8%87%AA%E5%B7%B1%E8%80%8C%E6%8C%91%E6%8B%A8%E5%9B%BD%E4%BA%BA%E5%85%B3%E7%B3%BB%E7%9A%84%E4%BA%BA%EF%BC%81%EF%BC%81%E8%BA%AB%E4%B8%BA%E5%8D%8E%E4%BA%BA%E5%8D%B4%E4%B8%8D%E4%BD%86%E9%84%99%E8%A7%86%E5%A4%9A%E6%95%B0%E5%8D%8E%E4%BA%BA%EF%BC%8C%E8%80%8C%E4%B8%94%E7%9F%A2%E5%BF%97%E6%B1%A1%E6%9F%93%E4%BE%AE%E8%BE%B1%E6%B1%A1%E8%94%91%E5%8D%8E%E4%BA%BA%E6%96%87%E5%8C%96%EF%BC%8C%E7%A6%BB%E9%97%B4%E5%8D%8E%E4%BA%BA%E6%84%9F%E6%83%85%EF%BC%81%E5%BC%BA%E7%83%88%E8%A6%81%E6%B1%82%E6%96%B0%E6%B5%AA%E5%BE%AE%E5%8D%9A%E5%B0%81%E6%9D%80%E4%B8%80%E8%B4%AF%E4%BB%87%E8%A7%86%E5%A4%A7%E9%99%86%E4%B8%80%E8%B4%AF%E5%88%AB%E6%9C%89%E7%94%A8%E5%BF%83%E7%9A%84%E6%9F%93%E9%A6%99%E5%BE%AE%E5%8D%9A%EF%BC%81%EF%BC%81%EF%BC%81&role=-1&retcode=";
q = {"ccontent"=>"%E4%BD%A0%E6%88%90%E5%8A%9F%E7%BA%A2%E4%BA%86",
"cid"=>"2021108263052885522",
"content"=>"这个明显是是染香为挑拨地域矛盾和炒作自己编造出来的， 用心之险恶！！最痛恨这类别有用心或为了炒作自己而挑拨国人关系的人！！身为华人却不但鄙视多数华人，而且矢志污染侮辱污蔑华人文化，离间华人感情！强烈要求新浪微博封杀一贯仇视大陆一贯别有用心的染香微博！！！",
"forward"=>"0",
"listInDiv"=>"2",
"ownerUid"=>"1654592030",
"productId"=>"miniblog",
"productName"=>"",
"replyUid"=>"1068614534",
"resInfo"=>"",
"resTitle"=>"%E2%96%B2%20%E4%B8%93%E5%AE%B6%E5%88%86%E6%9E%90%EF%BC%8C%E4%B8%8A%E6%B5%B7%E6%96%B9%E8%A8%80%E6%B2%AA%E8%AF%AD%E4%B8%A5%E9%87%8D%E5%9C%B0%E5%BD%B1%E5%93%8D%E7%9D%80%E4%B8%8A%E6%B5%B7%E6%88%90%E4%B8%BA%E5%9B%BD%E9%99%85%E5%8C%96%E5%A4%A7%E9%83%BD%E5%B8%82%E3%80%82%E6%97%A0%E8%AE%BA%E4%BD%A0%E4%BD%9C%E4%B8%BA%E4%B8%8A%E6%B5%B7%E6%9C%AC%E5%9C%B0%E4%BA%BA%EF%BC%8C%E8%BF%98%E6%98%AF%E4%B8%8A%E6%B5%B7%E5%A4%96%E5%9C%B0%E4%BA%BA%EF%BC%8C%E4%BD%A0%E6%98%AF%E5%90%A6%E8%B5%9E%E6%88%90%E4%B8%8A%E6%B5%B7%E5%8F%96%E6%B6%88%E6%B2%AA%E8%AF%AD%EF%BC%9F",
"resourceId"=>"3350421398088054",
"role"=>"-1",
"uid"=>"1404793074"
}


 r,dd = http.post(path_reply, "f=1&rnd=0.09343721463422711&#{source}", headers)
 
  print "#{r}, #{dd}\n------\n"