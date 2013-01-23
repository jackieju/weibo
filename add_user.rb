require 'net/http'
require 'CGI'
require 'util.rb'
require 'Mysql'
require "global.rb"

followids={'1785122705'=>1, '1404793074'=>1, '1645494153'=>1, '1640571365'=>1, '1643971635'=>1,'1182391231'=>1,'1558148043'=>1,'1195403385'=>1,'1645494153'=>1,'1785122705'=>1,'1195031270'=>1}
myid='1785122705' # 锵锵三人行不行
#myid = '1404793074' # 唐朝兄弟
#cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1282153966534:4:3:2:116.227.24.65.249241282151291764:1282151308416; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1282297131; un=jackie.ju@gmail.com; _s_tentry=-; _s_upa=30; Apache=116.227.24.65.249241282151291764; SUE=es%3D8c680f9800d7628a28e9d4a534c5ccb5%26ev%3Dv0%26es2%3D7dcb5b1c3d59313e8d0b941ad1a28e46; SUP=cv%3D1%26bt%3D1282332875%26et%3D1282419275%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282937675; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; uc=106%7Cam%7C2c"
#cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1282153966534:4:3:2:116.227.24.65.249241282151291764:1282151308416; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1282159376; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; _s_upa=18; Apache=116.227.24.65.249241282151291764; _s_tentry=-; SUE=es%3D359a1e8ccb7cc30ed5132ad2ee02ea35%26ev%3Dv0%26es2%3D528de2fe4c9baca88569360fef262239; SUP=cv%3D1%26bt%3D1282162273%26et%3D1282248673%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282767073; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=1ua%7C9t%7C43"
cookie=$cookie
path_addfollow = "/attention/aj_addfollow.php"
http = Net::HTTP.new("t.sina.com.cn", 80)
headers = {
  'Cookie' => cookie,
  'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
  'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
  'Referer' => "http://t.sina.com.cn/attention/att_list.php?action=1&uid=#{myid}&page=0"
}


dbh=nil
#begin
    dbh = Mysql.real_connect("localhost", "root", "", "weibo")
    log dbh.inspect
    log (" select id,uid,sex,flag, f, p from user where  ((not f  like '%#{myid}%' ) OR  f is NULL) and p!=0 and fans < 300 limit 100");
    #res = dbh.query("select id,uid,sex,flag, f, p from user where f not like '%#{myid}%' and p!=0  order by p desc");
    res = dbh.query(" select id,uid,sex,flag, f, p from user where  ((not f  like '%#{myid}%' ) OR  f is NULL) and p!=0 limit 100");
    number = res.num_rows

    
log("===========================================")
log "start at #{Time.now.to_s} "
log("===========================================")
log("myid:\t#{myid}\n")
log("select #{number} users")
log("---------------------------------------")
br = false
i = 0
count = 0
   while(i < number && ! br)
     
     r = res.fetch_hash
	 break if !r
     log "===>#{r}"
     uid = r["uid"]
     
     q = "fromuid=#{myid}&uid=#{uid.to_s}"
		log(q)
        r,dd = http.post(path_addfollow, q, headers)
        print "#{r}, #{dd}\n------\n"
        log("add #{uid} return #{dd}")
          # if rejected by server
          #if (dd=~/M02016/) 
           if ( dd =~/A00006/) 
            
             f = "#{r['f']},#{myid}" # record which account has followed it
              log "update user set f='#{f}' where uid = '#{uid}'"
             dbh.query("update user set f='#{f}' where uid = '#{uid}'");
             count=count+1
           else
            #print "stop\n"
            br = true
            break
          end
          sleep(1)
     
   end
   
   if dd =~/M05002/  # reach max follow number
     # start delete follow
     for page in 0..100
         url = "/attention/att_list.php?action=0&page=#{page}"
         r,dd = http.post(url, "", headers)
        # log "#{dd}"
     
         # <div class="conBox_c"> <span class="name"><a title="地平线1988" uid="1725329103" href="http://t.sina.com.cn/1725329103">地平线1988</a><span class="remark"></span></span>
         exp = /<div class="conBox_c"> <span class="name"><a title=".*?" uid="(.*?)" href/
          dd.scan(exp){|m|
            u = m[0].to_s
            if (followids[u] != 1)
              log "--> delete user #{u}"
              param = "fromuid=#{myid}&touid=#{u}"
              url = "/attention/aj_delfollow.php"
              r,dd = http.post(url, param, headers)
              log dd 
            end
          }
     end # for
   end  # if dd =~/M05002/
   
   if dd=~/"M02016"/  # reach the max number per day
     log "\n\nreach max follow number per day\n"
   end
   
log("==== stop at #{Time.now.to_s} ===============")
log("myid:\t#{myid}\n")
log("#{count} users followed\n")
log("==============================================")
