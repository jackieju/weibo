require 'net/http'
require 'CGI'
require 'json'
require 'Mysql'
require 'util.rb'

# class AddFollow
#     def initialize(domain./)
#         
#     end
def add_follow(id, m, cookie, domain="weibo.com", target_id=1713926427)
        domain = "weibo.com" if ! domain or domain==""
        target_id = '1713926427' if target_id == nil
        dr = dbh.query("select * from addfollow where f='#{id}' and t='#{m.to_s}' ")
        p dr.inspect
        record_found = false
        if dr && dr.num_rows > 0
            record_found = true
            retcode = dr.fetch_hash["retcode"]
            if retcode.to_i == 100000 || retcode.to_i == -1
                p "user(#{dr.inspect}) already followed"
                # sleep(interval)
                return nil
            end
            
        end
    
    headers = {
        'Cookie' => cookie,
        'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
        'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
        'Referer' => "http://#{domain}/#{target_id}/fans?page=1"
    }
        path_addfollow="/aj/f/followed?__rnd=1353200431008"
        q = "_t=0&f=1&location=profile&refer_flag=&refer_sort=profile&uid=#{m.to_s}"
		
		log(q)
        # headers["user"] = m.to_s
        # headers["type"] = "s"
        # headers["_t"] = "0"
        headers["X-Requested-With"] = "XMLHttpRequest"
        headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
        headers["Referer"] = "http://weibo.com/u/#{m.to_s}"
  #http://weibo.com/aj/f/followed?__rnd=1353200431008&_t=0&f=1&location=profile&refer_flag=&refer_sort=profile&uid=3096672153&wforce=1
  
     
        begin
            http = Net::HTTP.new("weibo.com", 80)
            r,dd = http.post(path_addfollow, q, headers)
        rescue
        end
        # r,dd = http.post(path_updategroup, q, headers)
        print "#{r}, #{dd}\n------\n"
        log("add follow #{m.to_s} for #{id} return #{dd}")
        if dd && dd!=""
            json_ret = JSON.parse(dd)
            p "==>#{dd['code']}"
              # if rejected by server
              #if (dd=~/M02016/) 
              # if (not dd =~/A00006/) 
              if record_found && json_ret["code"]!=nil
                   stmt= "update addfollow set retcode='#{json_ret["code"]}' where f='#{id}' and t='#{m.to_s}'"
              else
                  if json_ret["code"].to_i == 100000 
                    stmt= "insert  into addfollow (f, t, retcode, nick,updated_at) values('#{id}', '#{m.to_s}', '#{json_ret["code"]}', '#{json_ret["data"]["fnick"].to_s}', NULL)"
                  else
                      stmt= "insert  into addfollow (f, t, retcode, nick,updated_at) values('#{id}', '#{m.to_s}', '#{json_ret["code"]}', NULL, NULL)"
                end
              end
              p "statment: #{stmt}"
              dbh.query(stmt)
    
              return json_ret
          else
              return ""
          end
        # if not json_ret["code"] == '100000'
        #     if json_ret["code"] == '100001'
        #         p "too much request today, sleep 3600 sec ..."
        #         sleep (3600)
        #     end
        #     #print "stop\n"
        #     err_num += 1
        #     br = true if err_num > max_err_num
        #     # break
        # else
        # end
end


def search_and_follow(id, cookie, key="侠客", sdomain="s.weibo.com", domain="weibo.com")
    headers = {
        'Cookie' => cookie,
        'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
        'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
        'Referer' => "http://#{sdomain}/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1"
    }

    page_start =0
   if $*[0] != nil
        page_start = $*[0].to_i 
    else
        rs= dbh.query("select * from global where name='lp#{id}#{key}'")
        if rs && rs.num_rows>0 
             page_start = rs.fetch_hash["value"].to_i
            
        else
            dbh.query("insert into global values( 'lp#{id}#{key}', '0')")
        end
    end

    page_max = 100000

    index= 0
    count =0


    # add comments
    c_i = 0
    c_content=["//", "///","////", "[话筒]"]
    end_id= "3513608966875443"
    number_in_page = 0
    interval = 30 # time interval
    err_num = 0
    for p in (page_start..page_max) do
        
        stmt = "update global set value='#{p.to_s}' where name='lp#{id}#{key}'"
        p "stmt=#{stmt}"
        dbh.query(stmt)
        log "page #{p}\n------------------------------\n"
        log "page #{p}\n------------------------------\n"
        # path = "/attention/att_list.php?action=1&page=#{p}&uid=#{id}"
        number_in_page = 0
   

        br = false
        #url = "http://t.sina.com.cn/1645494153/fans"
        #resp = Net::HTTP.post_form(URI.parse(url),{'Cookie'=>cookie})# Net::HTTP.get(URI.parse(url))
        path = "/aj/mblog/fsearch?count=15&_k=135318307315198&_t=0&__rnd=1353183175362"
        # home page http://weibo.com/aj/mblog/fsearch?
        path = "/aj/mblog/fsearch?page=#{p}&count=15&max_id=3513559583109439&pre_page=#{p}&end_id=#{end_id}&pagebar=1&_k=1353193203274317&_t=0&__rnd=1353196579671"
        # search by '游戏' http://s.weibo.com/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1&page=3
        http = Net::HTTP.new(sdomain, 80)
        path = "/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1&page=#{p}"
    
        log "get page from http://#{domain}#{path}"
        begin
        resp, d = http.get(path, headers)
                rescue Exception =>e
               p e.inspect
            end
        # p "--------- page content ---------"
          p "------->>#{d}"
         p "------->>#{resp.inspect}"
        #  p "--------- page content end ---------"
        if !d || d==""
           sleep(5)
            next
        end
    
        #<dd class="info W_linkb W_textb">nt<span>nt<a href="/2121093115/ysHPkvX0Q?type=repost" suda-uatrack="key=smart_feed&value=details_feed">u8f6cu53d1(352)</a>nt<i class="W_vline">|</i>ntt<a href="/2121093115/ysHPkvX0Q" suda-uatrack="key=smart_feed&value=details_feed">u8bc4u8bba(15)</a>nt</span>nt<a class="date" href="/2121093115/ysHPkvX0Q" title="2012-07-16 14:00" date="1342418418000" node-type="feed_list_item_date" suda-uatrack="key=smart_feed&value=details_feed">7u670816u65e5 14:00</a> u6765u81ea<a target="_blank" href="http://weibo.pp.cc/time/" rel="nofollow">u76aeu76aeu65f6u5149u673a</a>n</dd>
        # regexp = /<a title=".*?" uid="(\d+)"/
        # regexp = /uid=(\d+)&fnick=.*?&sex=./
        # regexp = /<dd class=\".*?\">nt<span>nt<a href=\"\/(\d+)\/\w+\?type=repost\" suda-uatrack=\".*?\">\w+\d+<\/a>nt<i class=\"\w+\">|<\/i>ntt<a href=\"\/(\d+)\/\w+\" suda-uatrack=\"key=smart_feed&value=details_feed\">\w+?\((\d+)\)<\/a>nt<\/span>nt<a class=\"date\" href=\"\/(\d+)\/\w+\" title=\".*?\" date=\"\d+\" node-type=\"\w+\" suda-uatrack=\"key=smart_feed&value=details_feed\">.*?<\/a>[\w\s]+?<a target=\"_blank\" href=\"http:\/\/weibo.pp.cc\/time\/\" rel=\"nofollow\">\w+<\/a>n<\/dd>/
        regexp = /<a href=\"\/(\d+)\/\w+\?type=repost\"/
        regexp = /action\-data=\"uid=(\d+).amp.mid=(\d+)\".*?<a href=\"\/(\d+)\/\w+\" suda-uatrack=\".*?\">\W+\((.*?)\)<\/a>/
        regexp= /action.type=\".*?\".action.data=\"uid=(\d+).amp.mid=(\d+)\".*?><img.*?.class=\"bigcursor\".*?><img.*?><\/div>/

        regexp= /action.data=\"uid=(.*?)service.account.weibo.com\/reportspam/
        regexp = /action-data=\"uid=/
        regexp = /<img usercard=.*?action\-data=\"uid=(\d+).amp.mid=(\d+)\".*?<a href=\"\/(\d+)\/\w+\" suda-uatrack=\".*?\">\W+\((.*?)\)<\/a>.*?<img usercard=/im
        regexp = /<img usercard=.*?<img usercard=/im
        # mat = regexp.match(data)
        # p mat.inspect
        regexp = /action\-data=\"uid=(\d+).amp.mid=(\d+)\".*?<a href=\"\/(\d+)\/\w+\" suda-uatrack=\".*?\">\W+\((.*?)\)<\/a>/im
        regexp = /<img usercard=\"id=(\d+)\"(.*?)<div node-type=\"feed_list_repeat/im
           # action-type="feed_list_forward" action-data="allowForward=1&url=http://weibo.com /1675728851/z5ScS4bPo&mid=3514000140998782&name=津津有个小宇宙& uid=1675728851&domain=dansonjirozjy"
        # .. <a suda-data="key=tblog_search_v4.1&value=weibo_feed_p_page:3514000250065298" action-type="feed_list_comment" href="javascript:void(0);">评论(1)</a>
        #regexp = /<a.*?action-type=\"feed_list_forward\" action-data="allowForward=.&url=.*?(\d+)\/(\w+)&mid=(\w+)&name=.*?uid=(\d+)&domain=\w+".*?转发.*?<\/a><a.*? /
        regexp = /<a.*?action-data=\"allowForward=.*?url=http.\/\/weibo.com\/(\d+)\/(\w+)&.*?mid=(\d+).*?uid=(\d+).*?>转发(\((.*?)\)){0,1}<\/a>.*?>评论(\((.*?)\)){0,1}<\/a>/im
        count = 0
        p "--->d:#{d.inspect}"
        d.scan(regexp){|m|
            ouid = ""
            mid = ""
            comment_number = 100
        
            p "fans id #{m.inspect}"
        
            # p "fans id #{m[0]}"
        
            p "m1=#{m[1]}"

        mid = m[2]
        ouid= m[3]
        comment_number = m[7].to_i
        wb_url = "/#{ouid}/#{m[1]}"
               p "==>url: #{wb_url}, /#{ouid}/#{mid}, comment number #{comment_number}, "
  
        
            if ouid == "" || comment_number > 100 || mid == ""
                  # sleep(interval)
                next
            end
      
            end_id = mid
        
        
            #
            # add follow
            #
            p "#{id} follow #{ouid}"
            json_ret= add_follow(id, ouid, cookie)
            if  json_ret && json_ret["code"] != '100000'
                if json_ret["code"] == '100001' or json_ret["code"] == '100027'
                    p "too much request today, sleep 3600 sec ..."
                    return
                    # sleep (3600)
                end
                #print "stop\n"
                err_num += 1
                # br = true if err_num > max_err_num
                # break
            else
            end
        
        
            # 
            # comment
            #
        
            stmt = "select * from commented where uid='#{ouid}' and mid='#{mid}'"
            p "stmt: #{stmt}"
            dr = dbh.query("select * from commented where uid='#{ouid}' and mid='#{mid}'")
            p dr.inspect
            if dr && dr.num_rows > 0
                p "record(#{dr.inspect}) already commented"
                  # sleep(interval)
                next
            else
          
            end
    
            http = Net::HTTP.new(domain, 80)

 
        #http://weibo.com/aj/mblog/forward?__rnd=1353199806827&_t=0&appkey=&group_source=group_all&location=home&mid=3513585890420479&module=tranlayout&reason=%E8%BD%AC%E5%8F%91%E5%BE%AE%E5%8D%9A&style_type=1
        #http://weibo.com/aj/comment/add?__rnd=1353199507130&_t=0&act=post&content=haha&forward=0&group_source=group_all&isroot=0&location=home&mid=3513585890420479&module=scommlist&uid=1785122705
            # q = "fromuid=#{myid}&uid=#{m.to_s}"
            # q = "type=s&remark=&user=#{m.to_s}&gid=%5B%5D&_t=0"
            # http://weibo.com/aj/comment/add?__rnd=1353187944254&_t=0&act=post&content=hehe&forward=0&isroot=0&location=mblog&mid=3468416587615016&module=bcommlist&type=big&uid=1785122705
            # q = "act=post&mid=3468416587615016&uid=1785122705&forward=0&isroot=0&content=haha&type=big&location=mblog&module=bcommlist&_t=0"
    	    c_i = (c_i+1)%3
    	    q="__rnd=1353199806827&_t=0&act=post&content=#{c_content[c_i]}&forward=0&isroot=0&location=mblog&mid=#{mid}&module=bcommlist&type=big&uid=#{ouid}"
    		log(q)
            # headers["user"] = m.to_s
            # headers["type"] = "s"
            # headers["_t"] = "0"
            headers["X-Requested-With"] = "XMLHttpRequest"
            headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
            path_comment = "/aj/comment/add"
            count += 1
            begin
            
                r,dd = http.post(path_comment, q, headers)
       
            p "#{r}, #{dd}\n------\n"
            log("add comments to #{ouid}/#{mid}, url=#{wb_url}) return #{dd}")
            json_ret = JSON.parse(dd)
            p "==>#{dd['code']}"
              # if rejected by server
              #if (dd=~/M02016/) 
              # if (not dd =~/A00006/) 
              if not json_ret["code"] == '100000'
    
                #print "stop\n"
                # br = true
                # break
                else
                              stmt = "insert into commented values('#{ouid}', '#{mid}', '#{id}')"
                  p "stmt = #{stmt}"
                dbh.query(stmt)
                p "====> add comments(page #{p}/#{number_in_page}) "#{c_content[c_i]}" OK <==="
              end
               rescue Exception =>e
               p e.inspect
        
              end # rescue
              number_in_page += 1
              p "sleep 5 sec ..."
              sleep(5)
          } #scan
          p "count=#{count}"
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
        if count == 0
              p "sleep #{interval} sec ..."
              sleep(interval)
          end
    end # for

end
def grab_and_follow(id, cookie, domain="weibo.com", target_id=1713926427)
      headers = {
        'Cookie' => cookie,
        'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
        'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
        'Referer' => "http://#{domain}/#{target_id}/fans?page=1"
    }
    page_start = 0 
    if $*[0] != nil
        page_start = $*[0].to_i 
    else
        rs= dbh.query("select * from global where name='lp#{id}#{target_id}'")
        if rs && rs.num_rows>0 
             page_start = rs.fetch_hash["value"].to_i
            
        else
            dbh.query("insert into global values( 'lp#{id}#{target_id}', '0')")
        end
    end
    page_max =  1000000
    
    http = Net::HTTP.new(domain, 80)

log("===========================================")
log "start at #{Time.now.to_s} "
log("===========================================")
log("myid:\t#{id}\n")
log("starid:\t#{target_id}\n")
log("from page:\t#{page_start}")
log("---------------------------------------")

# end
#path = "/#{id}/fans"
print "add fans of user #{id}\n"
index= 0
count =0
for p in (page_start..page_max) do
    # dbh.query("insert into global values( 'lp#{id}#{target_id}', '#{p.to_s}')")
    stmt = "update global set value='#{p.to_s}' where name='lp#{id}#{target_id}'"
    p "stmt=#{stmt}"
    dbh.query(stmt)
    log "page #{p}\n------------------------------\n"
    
    # path = "/attention/att_list.php?action=1&page=#{p}&uid=#{id}"
    path = "/#{target_id}/fans?page=#{p}"
    log path+"\n"

    br = false
    #url = "http://t.sina.com.cn/1645494153/fans"
    #resp = Net::HTTP.post_form(URI.parse(url),{'Cookie'=>cookie})# Net::HTTP.get(URI.parse(url))
    begin
        resp, d = http.get(path, headers)
    rescue
    end
    # p "--------- page content ---------"
    p "------->>#{d}"
    # print "------->>#{resp.inspect}"
    # p "--------- page content end ---------"
    
    # regexp = /<a title=".*?" uid="(\d+)"/
    count = 0
    regexp = /uid=(\d+)&fnick=.*?&sex=./
    d.scan(regexp){|m|
        p "fans id #{m}"

        # q = "fromuid=#{myid}&uid=#{m.to_s}"
        json_ret= add_follow(id, m.to_s, cookie)
        if  json_ret && json_ret["code"] != '100000'
            if json_ret["code"] == '100001'
                p "too much request today, sleep 3600 sec ..."
                sleep (3600)
            end
            #print "stop\n"
            err_num += 1
            br = true if err_num > max_err_num
            # break
        else
        end
       
          sleep(5)
      } #scan
      # prevent from too fast
      #sleep(5)
    
     if br
      print "Stop at page #{p}\n"
      log("Stop at page #{p}\n")
      # break
      sleep(3600)
      print "restart at page #{p} on #{DateTime.now.to_s}\n"
      
      #print "sleep 3600 ... "
      #for i in (0..3600)
       #   sleep(1)
        #  print "\b#{i}"
      #end
  else
      if count == 0
          p "sleep 5 sec ..."
          sleep(5)
      end
     end
    #print "sleep 10 second ...\n"
    #sleep(10)
end # for
log("==== stop at #{Time.now.to_s} ===============")
log("myid:\t#{myid}\n")
log("starid:\t#{id}\n")
log("==============================================")


end

# end #class