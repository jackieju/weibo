require 'net/http'
require 'CGI'
require 'util.rb'
require 'Mysql'
# optmized version

fans_number=10000


dbh=nil

    dbh = Mysql.real_connect("localhost", "root", "", "weibo")
    log dbh.inspect
    res = dbh.query("select id,uid,sex,flag,name,fans from user where fans>#{fans_number} order by fans desc");
    number = res.num_rows
    
    
log("===========================================")
log "start at #{Time.now.to_s} "
log "#{number} 0 lever users"
log("===========================================")
#log("myid:\t#{myid}\n")
#log("select #{number} users")
#log("---------------------------------------")
br = false
i = 0
count = 0
   while(i < number && ! br)
     r = res.fetch_hash
     if (r == nil)
       break
     end
     log "===>#{r}"
     uid = r["uid"]
     name =r["name"]
     
     log "find users followed by #{uid} #{name}"
     
     # 1st level
     res1 = dbh.query("select uid, fans from relations where fans='#{uid}'");
     number_followed1 = res1.num_rows
     log("1st level #{number_followed1} users")
     p = r["fans"].to_i
 
     res1.each do |row|
 
         # set priority 
         dbh.query "update user set p=#{p} where uid='#{row[0]}' and p<#{p}"
          count += dbh.affected_rows
    
         # 2nd level
         res2 = dbh.query("select uid, fans from relations where fans='#{row[0]}'");
         number_followed2 = res2.num_rows
         log("2st level #{number_followed2} users")
         res2.each do |row|
              # set priority
              p = p /2
             dbh.query("update user set  p=#{p} where uid='#{row[0]}'  and p<#{p}")
              count += dbh.affected_rows
    
             # 3nd level
             res3 = dbh.query("select uid, fans from relations where fans='#{row[0]}'");
             number_followed3 = res3.num_rows
             log("3st level #{number_followed3} users")
             res3.each do |row|
                # set priority
                p = p/2
                dbh.query("update user set  p=#{p} where uid='#{row[0]}'  and p<#{p}")
                count += dbh.affected_rows
             end
         end
         
    end

     
   end
   
log("==== stop at #{Time.now.to_s} ===============")
log("update #{count} users")
#log("myid:\t#{myid}\n")
#log("#{count} users followed\n")
log("==============================================")
