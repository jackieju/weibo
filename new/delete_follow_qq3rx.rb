require 'unfollow.rb'
require 'cookies.rb'
cookie = $cookies[:qq3rx]
id = "1683936900"
stmt = "select * from addfollow where f='#{id}' and retcode='100000' order by updated_at asc"
p stmt
dr = dbh.query(stmt)
dr.each_hash{|r|
     next if !r
    p "delete follow of #{id}: #{r["t"]} ..."
    u = unfollow(id, r["t"], cookie)
    p "delete return code #{u["code"]}" if u
    # p "抱歉，TA还不是你关注的人".unpack("U*").pack("U*")
    # p u["msg"].unpack("U*").pack("U*")

    # if u["code"].to_i == 100001 && u["msg"].unpack("U*").pack("U*").start_with?("抱歉，TA还不是你关注的人".unpack("U*").pack("U*"))
    if u && u["code"].to_i == 100000 || (u["code"].to_i == 100001 && u["msg"].start_with?("抱歉，TA还不是你关注的人"))
        dbh.query("update addfollow set retcode='-1' where f='#{id}' and t='#{r["t"]}'")
         p "reset to unfollowed "
    else
        p "unfollow #{r["t"]} failed"
    end
    sleep(1)

}