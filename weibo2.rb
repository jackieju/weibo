require 'net/http'
require 'CGI'


def log(msg)
 open("weibo.log", "a") { |file|
     if ( msg =~/\n$/)
     else
       msg += "\n"
     end
     file.write("#{msg}")
     print "#{msg}"
  }
end


a = ["手表", "儿童节", "冰箱",
  "广州","武汉", "长沙","赤道", "火车","书包","沈阳","西安","电话", "飞机","上海","巴黎","劳动节","海口","情人节","动物园","国庆节","足球","酱油","绿豆","福州","老虎","莫斯科","哈尔滨",
  "鳄鱼","熊猫","大象", "苹果"
  ]
b= ["熊猫","大象", "苹果"]
#myid='1785122705' # 锵锵三人行不行
myid = '1404793074' # 唐朝兄弟
# star's id
#id = '1645494153' # 立方快报
#id = '1640571365' # laoluo
id = '1683936900' # qiangqiangsanrenxin
fans_number = 191822
#fans_number = 1573
page_start = 0 
page_max =  fans_number/20 + 1
#cookie="uc=18b%7C1h2%7Cvu; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; _s_tentry=-; Apache=116.227.16.155.346301281427325225; _s_upa=12; SUE=es%3D9949b4465f0d096b1aa090876b317182%26ev%3Dv0%26es2%3D71cbff0b2a971419c70f1d1859dc33dd; SUP=cv%3D1%26bt%3D1281427345%26et%3D1281513745%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282032145; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0; un=jackie.ju@gmail.com; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; uc=91%7C62%7Cen"

#cookie=	"ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; _s_tentry=-; _s_upa=20; Apache=116.227.16.155.346301281427325225; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=p%7C8%7C2r"
#cookie= "ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; _s_tentry=-; _s_upa=23; Apache=116.227.16.155.346301281427325225; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; ULOGIN_IMG=12814915567727; uc=t%7C8%7C2r"
#cookie="uc=18b%7C1h5%7C100; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=v%7C8%7C2r; _s_tentry=-; ULOGIN_IMG=12814962299322; _s_upa=28; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; Apache=116.227.16.155.346301281427325225"
#cookie="uc=18b%7C1h5%7C100; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=v%7C8%7C2r; _s_tentry=-; _s_upa=30; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; Apache=116.227.16.155.346301281427325225; ULOGIN_IMG=128152690912"
cookie="uc=18b%7C1h5%7C100; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=jackie.ju@gmail.com; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; _s_tentry=-; _s_upa=37; Apache=116.227.16.155.346301281427325225; ULOGIN_IMG=128152690912; SUE=es%3D179580ba9c2d68c79e5d6a3c2278af6e%26ev%3Dv0%26es2%3D95b2f115ad7b792648c1d5ab5293a15f; SUP=cv%3D1%26bt%3D1281557454%26et%3D1281643854%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282162254; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0; uc=v2%7C3b%7C11"
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; _s_upa=52; ULOGIN_IMG=12817193265784; Apache=116.227.16.155.346301281427325225; SUE=es%3D8c419133d34556465d704ff4c1b00897%26ev%3Dv0%26es2%3D4b214db6688bdc0fbc3717d92c2ba287; SUP=cv%3D1%26bt%3D1281719351%26et%3D1281805751%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282324151; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0"
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; _s_tentry=-; _s_upa=55; ULOGIN_IMG=12817193265784; Apache=116.227.16.155.346301281427325225; appkey=; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; SUE=es%3D55efd19e7b10fc371f78d3ee4a65a0ed%26ev%3Dv0%26es2%3Da0a10e357c082b4bddd6b1b22c1edd35; SUP=cv%3D1%26bt%3D1281721229%26et%3D1281807629%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282326029; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=vk%7C44%7C38"
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; _s_upa=76; ULOGIN_IMG=12817193265784; Apache=116.227.16.155.346301281427325225; SUE=es%3D211f0b8e073904248fcf8fbb03b7cc2c%26ev%3Dv0%26es2%3D4689f14a60b73900f7b8a5ec84af1c78; SUP=cv%3D1%26bt%3D1281809644%26et%3D1281896044%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282414444; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0"
path_addfollow = "/attention/aj_addfollow.php"
http = Net::HTTP.new("t.sina.com.cn", 80)
headers = {
  'Cookie' => cookie,
  'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
  'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
  'Referer' => "http://t.sina.com.cn/attention/att_list.php?action=1&uid=#{id}&page=0"
}
log("===========================================")
log "start at #{Time.now.to_s} "
log("===========================================")
log("myid:\t#{myid}\n")
log("starid:\t#{id}\n")
log("from page:\t#{page_start}")
log("---------------------------------------")

need_pincode = false


#path = "/#{id}/fans"
print "add fans of user #{id}\n"
index= 0
count =0
for p in (page_start..page_max) do
    log "page #{p}\n------------------------------\n"
    path = "/attention/att_list.php?action=1&page=#{p}&uid=#{id}"
    log path+"\n"

    br = false
    #url = "http://t.sina.com.cn/1645494153/fans"
    #resp = Net::HTTP.post_form(URI.parse(url),{'Cookie'=>cookie})# Net::HTTP.get(URI.parse(url))
    resp, d = http.get(path, headers)
    #print "------->>#{d}"
    regexp = /<a title=".*?" uid="(\d+)"/
    d.scan(regexp){|m|
        print m.to_s+"\n"
        http = Net::HTTP.new("t.sina.com.cn", 80)

        #print "rnd=001575566137080486&fromuid=#{myid}&uid=#{m.to_s}"
        #r,dd = http.post(path_addfollow, "rnd=001575566137080086&fromuid=#{myid}&uid=#{m.to_s}", headers)
        #r,dd = http.post(path_addfollow, "rnd=0.13575566137080086&fromuid=#{myid}&uid=#{m.to_s}", headers)
        if (need_pincode)
            bingo = false
            # get pincode
            q = "/pincode/pin1.php?lang=zh&r=3242101202323&rule"
            while (not bingo)
    
                  #print "#{q}\n"
                  r,dd = http.get(q, headers)
                  #print "#{r}, #{rdd}\n------\n"
                  print "pincode return #{r.content_length}, #{r['Set-Cookie']}\n"
                  mm = /ULOGIN_IMG=(\d+)/.match(r['Set-Cookie'])
            
                  #  if r.content_length > 2800 and r.content_length < 5000
                    if r.content_length > 3000
                
                           open(mm[0]+".png", "wb") { |file|
                              file.write(r.body)
                           }
                
                           print "send ping code \n"
                
                        # input = gets()
                         print "#{input}\n"
                         #   print "match #{mm[0]}\n"
                            cookie=cookie.gsub(/ULOGIN_IMG=\d+/, mm[0])
                      #    print "cookie #{cookie}\n"
            
                     #  s= CGI::escape("火车")
                  #     r,dd = http.post(path_addfollow, "rnd=0.5097866901478074&door=#{a}", headers)
                   #    print "#{r}, #{dd}\n------\n"
   
                         # for aa in a do
                            aa = a[index%a.size]
                            s= CGI::escape(aa)
                            print "#{aa}=>#{s}     "
                            r,dd = http.post(path_addfollow, "rnd=0.5097866901478074&door=#{s}", headers)
                            #r,dd = http.post(path_addfollow, "door=#{s}", headers)
                            print "#{r}, #{dd}\n------\n"
                            if dd =~ /00006/
                              print "bingo!!!\n"
                              index = index+1
                          	  bingo=true
                              break
                           else
                              count +=1
                                if count > 100
                                    index = index +1
                                    count= 0
                                end
                            end #if
                        #    break
                       #   end #for
               
           
                    end # if content_length > 30000
         
              
                  # add follow
            #r,dd = http.post(path_addfollow, "fromuid=#{myid}&uid=#{m.to_s}&door=40", headers)
            #print "#{r}, #{dd}\n------\n"
              
            end #while
        
        end # if need pincode
=begin

    while ( not bingo)
      for aa in a do
        s= CGI::escape(aa)
        r,dd = http.post(path_addfollow, "rnd=0.5097866901478074&door=#{a}", headers)
        print "#{r}, #{dd}\n------\n"
        if dd =~ /00006/
          print "bingo!!!\n"
      	  bingo=true
          break
        end
      end
    end
=end
    
		q = "fromuid=#{myid}&uid=#{m.to_s}"
		log(q)
        r,dd = http.post(path_addfollow, q, headers)
        print "#{r}, #{dd}\n------\n"
        log("add #{m.to_s} return #{dd}")
          # if rejected by server
          #if (dd=~/M02016/) 
          if (not dd =~/A00006/) 
            #print "stop\n"
            br = true
            break
          end
          sleep(1)
      } #scan
      # prevent from too fast
      #sleep(5)
    
     if br
      print "Stop at page #{p}\n"
      log("Stop at page #{p}\n")
      break
      #print "sleep 3600 ... "
      #for i in (0..3600)
       #   sleep(1)
        #  print "\b#{i}"
      #end
     end
    #print "sleep 10 second ...\n"
    #sleep(10)
end # for
log("==== stop at #{Time.now.to_s} ===============")
log("myid:\t#{myid}\n")
log("starid:\t#{id}\n")
log("==============================================")
