require 'net/http'
require 'CGI'
require 'util.rb'
require 'Mysql'
require "global.rb"


# ========== variable ============== #
myid='1785122705' # 锵锵三人行不行
#myid = '1404793074' # 唐朝兄弟
# star's id
#id = '1645494153' # 立方快报
#id = '1640571365' # laoluo
id = '1683936900' # qiangqiangsanrenxin
#fans_number = 1573
page_start = 0 
page_max =  50
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1282153966534:4:3:2:116.227.24.65.249241282151291764:1282151308416; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1282159376; un=jackie.ju@gmail.com; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; _s_upa=11; Apache=116.227.24.65.249241282151291764; _s_tentry=-; uc=1ug%7Caq%7C1r; SUE=es%3Dbc05c0153fd0f413d0b43d9867162d22%26ev%3Dv0%26es2%3D66e6970347a9d6c5022434c8067f1961; SUP=cv%3D1%26bt%3D1282159727%26et%3D1282246127%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282764527; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0"
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1282549120175:5:4:1:1282549095491.6467:1282153966534; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1282297131; _s_upa=16; Apache=1282549095491.6467; SUE=es%3D9e23419e5ced3497f7ea2860b89e637f%26ev%3Dv0%26es2%3D24f96fe38289f8a42375d78e6913faf5; SUP=cv%3D1%26bt%3D1282549861%26et%3D1282636365%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1283154765; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0"
cookie=$cookie
path_addfollow = "/attention/aj_addfollow.php"
http = Net::HTTP.new("t.sina.com.cn", 80)
headers = {
  'Cookie' => cookie,
  'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
  'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
  'Referer' => "http://t.sina.com.cn/attention/att_list.php?action=1&uid=#{id}&page=0"
}


# ========== main ============== #
=begin
create table user (id int(10) auto_increment, uid varchar(18), name varchar(20), fans int(10), follow int(10), sex int(10), loc1 varchar(20), loc2 varchar(20), flag int(10), f varchar(255), createtime timestamp, p int(10) default 0, primary key (id)) default charset utf8;
create table global (name varchar(10), value varchar (255)) default charset utf8;
 insert into global values("last_page", 0);
 insert into global values("last_user", 0);
create unique index i1 on user (uid);
create table relations (id int(20) auto_increment, uid varchar(18), fans varchar(18), primary key (id)) default charset utf8;
create unique index i2 on relations (uid, fans);
=end
# get start id from mysql
dbh=nil
#begin
    dbh = Mysql.real_connect("localhost", "root", "", "weibo")
    log dbh.inspect
     res = dbh.query("select * from global where name='last_user'");
     
     last_user = res.fetch_row[1]
     log "last_user"

     res = dbh.query("select * from global where name='last_page'");
     if res.num_rows > 0
       last_page = res.fetch_row[1]
     else
       last_page= 0
     end
     page_start = last_page.to_i
# rescue Mysql::Error => e
#     puts "Error code: #{e.errno}"
#      puts "Error message: #{e.error}"
#      puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
# ensure
#      # disconnect from server
#      dbh.close if dbh
# end

while (true)
  
     if last_user == '0'
         current_user = id
     else
       log "select id, uid from user where id>=#{last_user}"
        res = dbh.query("select id, uid, fans from user where id>=#{last_user} and flag=0")
        row = res.fetch_row
        current_user = row[1]
        last_user=row[0]
        fans = row[2]
     end
    
     if fans.to_i == 0
          rs = dbh.query("update global set value='0' where name='last_page'" )
          rs = dbh.query("update global set value='#{last_user}' where name='last_user'" )
          
          # set flag to 2 => processed
          rs = dbh.query("update user set flag=2 where id=#{last_user}" )
          page_start = 0
          last_user = last_user.to_i + 1


       next;
     end
     
          # set flag to 2 => processed
          rs = dbh.query("update user set flag=1 where id=#{last_user}" )
          
page_number = fans.to_i / 20 +1
page_number = page_max if page_number > page_max
log("===========================================")
log "start at #{Time.now.to_s} "
log("===========================================")
log("myid:\t#{myid}\n")
log("starid:\t#{current_user}\n")
log("from page:\t#{page_start}")
log("#{fans} fans, #{page_number} pages")
log("---------------------------------------")
# get  fans
#path = "/#{id}/fans"
#log "get fans of user #{current_user}, #{fans} fans\n"
index= 0
count =0

for p in (page_start..page_number) do
    log "page #{p}\n------------------------------\n"
    path = "/attention/att_list.php?action=1&page=#{p}&uid=#{current_user}"
    log path+"\n"

    br = false
    #url = "http://t.sina.com.cn/1645494153/fans"
    #resp = Net::HTTP.post_form(URI.parse(url),{'Cookie'=>cookie})# Net::HTTP.get(URI.parse(url))
    begin
    resp, d = http.get(path, headers)
    rescue Exception=>e
      log "Exception:#{e}"
      next
    end
   #print "------->>#{d}"
      #<li class="MIB_linedot_l" onmouseover="App.changeBackColor(event,this);" onmouseout="App.changeBackColor(event,this);" id="1674411570">^M
      #                                  <div class="conBox_l"><a href="http://t.sina.com.cn/1674411570"><img pop="true" title=今世缘摄影 uid="1674411570" imgtype="head" src="http://tp3.sinaimg.cn/1674411570/50/0"></img></a></div>^M
      ##                                  <div class="conBox_c"> <span class="name"><a title="今世缘摄影" uid="1674411570" href="http://t.sina.com.cn/1674411570">今世缘摄影</a><span class="remark"></span></span>^M
       #                                   <p class="address"><img src="http://timg.sjs.sinajs.cn/miniblog2style/images/common/transparent.gif" class="small_icon man" title="男" />河北, <span>粉丝<strong>2</strong>人</span></p>^M
     #                                     <div class="content MIB_linkbl">  <a href='http://t.sina.com.cn/1674411570' class='ms'>#我最大的乐趣#玩电脑(2009-12-25 11:05)</a> </div>^M
        #                                                                        </div>^M
       #                                 <div class="conBox_r">^M                                                                                                                         <p><a href="javascript:void(0);" onclick="App.followadd('1674411570',this,'1','今世缘摄影');return false;" class="concernBtn_Add"><span class="addnew">+</span>加关注</a></p>^M                                                                                                                        </div>^M
         #                               <div class="clearit"></div>^M
         #                           </li>^M
#      regexp = /<a title="(.*?)" uid="(\d+)".*?<p class="address"><img src=.*class=(.*?)" title=.*?\/>(.*?), <span>粉丝<strong>(.*?)<\/strong>/                                                                     
    regexp = /<a title="(.*?)" uid="(\d+)".*?<p class="address"><img src=".*?" class="(.*?)" title=.*?\/>(.*?)<span>粉丝<strong>(.*?)<\/strong>/m
    d.scan(regexp){|m|
        log m.join(",").to_s+"\n"
        title=m[0]
        uid=m[1]
        if (m[2] =~ /female/)
          sex = 0
        else
          sex = 1
        end
        loc = m[3]
        if (loc =~ /(.*?),(.*)/)
          location = $1
          location2 = $2
        else
          location =""
          location2= ""
        end
        
        fans = m[4]
        
      
        log "insert relation between user #{uid}->#{current_user} into db"
        log "sql: insert into relations values(null, '#{current_user}', '#{uid}') "
        begin
            rs = dbh.query("insert into relations values(null, '#{current_user}', '#{uid}') " )
          rescue Mysql::Error => e
           #  log "Error code: #{e.errno}"
             log "===>Error: #{e.error}"
        end
      
      
        # insert into user
        log "insert user #{uid} into user"
        log "insert into user (id, uid, name, fans, sex, loc1, loc2, flag, f, createtime) values(null, '#{uid}', '#{title}', #{fans.to_i}, 0, #{sex}, '#{location}', '#{location2}', 0, '', null) " 
        begin
            rs = dbh.query("insert into user (id, uid, name, fans, follow, sex, loc1, loc2, flag, f, createtime) values(null, '#{uid}', '#{title}', #{fans.to_i}, 0, #{sex}, '#{location}', '#{location2}', 0, '', null) " )
          rescue Mysql::Error => e
           #  log "Error code: #{e.errno}"
             log "===>Error: #{e.error}"
        end
        
        
      } #scan
      # prevent from too fast
      sleep(1)
      # record last page
      begin
            rs = dbh.query("update global set value='#{p}' where name='last_page'" )
            rs = dbh.query("update global set value='#{last_user}' where name='last_user'" )
          rescue
        end
        
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

   # set flag to 2 => processed
    rs = dbh.query("update user set flag=2 where id=#{last_user}" )
    
    page_start = 0
    last_user = last_user.to_i + 1
  
end # while


log("==== stop at #{Time.now.to_s} ===============")
log("myid:\t#{myid}\n")
log("starid:\t#{current_id}\n")
log("==============================================")
