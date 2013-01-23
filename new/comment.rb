require 'net/http'
require 'CGI'
require 'json'
require 'Mysql'
require 'addfollow.rb'
require 'cookies.rb'
def add_comment(cookie, ouid, mid, content, wb_url, domain="s.weibo.com", target_id=1713926427)
            http = Net::HTTP.new(domain, 80)

       q="__rnd=1353199806827&_t=0&act=post&content=#{content}&forward=0&isroot=0&location=mblog&mid=#{mid}&module=bcommlist&type=big&uid=#{ouid}"
		log(q)
headers = {
  'Cookie' => cookie,
  'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
  'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
  # 'Referer' => "http://#{domain}/attention/att_list.php?action=1&uid=#{id}&page=0"
  'Referer' => "http://#{domain}/#{target_id}/fans?page=1"
}
        headers["X-Requested-With"] = "XMLHttpRequest"
        headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
     if domain == "weibo.com"
            path_comment = "/aj/comment/add"
        elsif domain == "s.weibo.com"
            path_comment = "/ajax/comment/add"
        end
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
                          stmt = "insert into commented values('#{ouid}', '#{mid}', '#{id}', '#{wb_url}')"
              p "stmt = #{stmt}"
            dbh.query(stmt)
          end
         rescue Exception =>e
           p e.inspect
        return false
         end # rescue
         
         return true
end
#allowForward=1&rootmid=3535887549692366&rootname=你画我猜游戏微博&rootuid=2490707353&rooturl=http://weibo.com/2490707353/zf3B8EFqu&url=http://weibo.com/1845154101/zf6ErCp0l&mid=3536004919152585&name=我爱吴富贵&uid=1845154101&domain=&pid=94752d99tw1e0xw6oqpftj
add_comment($cookies[:qq3rx], "1845154101", "3536004919152585", "00j", "/1845154101/zf6ErCp0l")