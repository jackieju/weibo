require 'net/http'
require 'CGI'
require 'json'
require 'Mysql'
require 'util.rb'



def unfollow(id, t, cookie, domain="weibo.com", target_id=1713926427)
        domain = "weibo.com" if ! domain or domain==""
        target_id = '1713926427' if target_id == nil
     
    headers = {
        'Cookie' => cookie,
        'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
        'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
        # 'Referer' => "http://#{domain}/#{target_id}/fans?page=1"
       'Referer' => "http://#{domain}/#{id}/myfollow"
    }
=begin     
http://www.weibo.com/aj/f/unfollow?_wv=5&__rnd=1355165804829&_t=0&location=myfollow&refer_flag=unfollow&refer_sort=relationManage&uid=1821963513
Host: www.weibo.com
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:2.0) Gecko/20100101 Firefox/4.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint
Accept-Language: en,en-us;q=0.7,ja;q=0.3
Accept-Encoding: gzip, deflate
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
Keep-Alive: 115
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded; charset=UTF-8
X-Requested-With: XMLHttpRequest
Referer: http://www.weibo.com/3100584981/myfollow
Content-Length: 83
Cookie: UOR=weibo.com,www.weibo.com,; ULV=1354914290587:1:1:1:7838428560298.35.1354914290584:; ALF=1355519164; un=ju@joyqom.com; wvr=5; USRHAWB=usr313227; SINAGLOBAL=7838428560298.35.1354914290584; v=5; SSOLoginState=1354914367; SUS=SID-3100584981-1355152299-XD-ctkyr-779862c6fc8e0d37e1624b99bb572124; Apache=7838428560298.35.1354914290584; _s_tentry=weibo.com; SUE=es%3D5d107895d9527b543794952d6f4f422a%26ev%3Dv1%26es2%3D9c1efd931d15346b05f35a56b0720aa7%26rs0%3DgIuxPaLflZv2m%252B6923V9yZAho57wcu6Sc3JOPEjTPq0cAvl6Xua2y4ZXvZpUccnpEOl8YXbl0GBb%252Fcl0hiOZA7LfydAdnq5ATWIf%252BDZ7cwT4Y3klbSAY4tl53zpaXOeF%252BaisKl6P1ysvNnfat08ilXKtqPrsker4MsQSOHADRZ4%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1355152299%26et%3D1355238699%26d%3Dc909%26i%3Ddf82%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; WBStore=1b425150f3ebbaa7|; SinaRot/u/3100584981%3Ftopnav%3D1%26wvr%3D5=33
Pragma: no-cache
Cache-Control: no-cache
=end
        path_unfollow="/aj/f/unfollow?_wv=5"
        qq = "uid=1850988623&f=0&extra=&oid=3100584981&nogroup=false&fnick=果壳网&location=myfollow&refer_sort=card"
        q = "uid=#{t}&f=0&extra=&oid=#{id}&nogroup=false&location=myfollow&refer_sort=card"
        q = "refer_sort=relationManage&location=myfollow&refer_flag=unfollow&uid=#{t}&_t=0"
        
        # path_unfollow="/aj/f/unfollow?_wv=5&__rnd=1355165804829&_t=0&location=myfollow&refer_flag=unfollow&refer_sort=relationManage&uid=#{t}"
     begin
            http = Net::HTTP.new("weibo.com", 80)
            r,dd = http.post(path_unfollow, q, headers)
        rescue Exception=>e
            p e.inspect
            return nil
        end
         print "#{r.inspect}, #{dd.inspect}\n------\n"
        log("unfollow #{t.to_s} return #{dd}")
        if dd && dd!=""
            json_ret = JSON.parse(dd)
              return json_ret
        else
              return nil
        end
end