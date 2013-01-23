def log(msg)
 open("weibo.log", "a") { |file|
     if ( msg =~/\n$/)
     else
       msg = msg.to_s+"\n"
     end
     file.write("#{msg}")
     print "#{msg}"
  }
end

@@dbh=nil


def dbh
    if !@@dbh
        @@dbh = Mysql.real_connect("localhost", "root", "", "weibo")

    end
    return @@dbh
end