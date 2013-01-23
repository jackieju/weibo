require 'net/http'
require 'CGI'
require 'json'
require 'Mysql'
require 'addfollow.rb'

domain = "weibo.com"
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

err_OK = "A00006"           # OK
err_nomorefollow = "M05002" # 关注人数达到上线
 err_num = 0
 succ_number  =0
dbh=nil
#begin
    dbh = Mysql.real_connect("localhost", "root", "", "weibo")
    log dbh.inspect
 #   log (" select id,uid,sex,flag, f, p from user where  ((not f  like '%#{myid}%' ) OR  f is NULL) and p!=0 and fans < 300 limit 100");
    #res = dbh.query("select id,uid,sex,flag, f, p from user where f not like '%#{myid}%' and p!=0  order by p desc");
   # res = dbh.query(" select id,uid,sex,flag, f, p from user where  ((not f  like '%#{myid}%' ) OR  f is NULL) and p!=0 limit 100");
    
dr = dbh.query("select * from commented ")
        p dr.inspect
        number = dr.num_rows
        
a = ["手表", "儿童节", "冰箱",
  "广州","武汉", "长沙","赤道", "火车","书包","沈阳","西安","电话", "飞机","上海","巴黎","劳动节","海口","情人节","动物园","国庆节","足球","酱油","绿豆","福州","老虎","莫斯科","哈尔滨",
  "鳄鱼","熊猫","大象", "苹果"
  ]
b= ["熊猫","大象", "苹果"]
myid='1785122705' # 锵锵三人行不行
#myid = '1404793074' # 唐朝兄弟
# star's id
#id = '1645494153' # 立方快报
#id = '1640571365' # laoluo
id = '1683936900' # qiangqiangsanrenxin
id = '3100584981' #xiekexin app
target_id = '1713926427'
fans_number = 191822
#fans_number = 1573
page_start = 0 
page_start = $*[0].to_i if $*[0] != nil
page_max =  fans_number/20 + 1
#cookie="uc=18b%7C1h2%7Cvu; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; _s_tentry=-; Apache=116.227.16.155.346301281427325225; _s_upa=12; SUE=es%3D9949b4465f0d096b1aa090876b317182%26ev%3Dv0%26es2%3D71cbff0b2a971419c70f1d1859dc33dd; SUP=cv%3D1%26bt%3D1281427345%26et%3D1281513745%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282032145; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0; un=jackie.ju@gmail.com; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; uc=91%7C62%7Cen"

#cookie=	"ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; _s_tentry=-; _s_upa=20; Apache=116.227.16.155.346301281427325225; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=p%7C8%7C2r"
#cookie= "ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; _s_tentry=-; _s_upa=23; Apache=116.227.16.155.346301281427325225; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; ULOGIN_IMG=12814915567727; uc=t%7C8%7C2r"
#cookie="uc=18b%7C1h5%7C100; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=v%7C8%7C2r; _s_tentry=-; ULOGIN_IMG=12814962299322; _s_upa=28; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; Apache=116.227.16.155.346301281427325225"
#cookie="uc=18b%7C1h5%7C100; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=whju; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A1%2C%221%22%3A1%2C%220%22%3A1%2C%22uid%22%3A%221404793074%22%7D; ALF=1282094465; SUR=uid%3D1404793074%26user%3Dwhju%26nick%3Dwhju%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02%26ag%3D2%26sex%3D1%26ssl%3D0; uc=v%7C8%7C2r; _s_tentry=-; _s_upa=30; SUP=cv%3D1%26bt%3D1281489665%26et%3D1281576065%26lt%3D1%26uid%3D1404793074%26user%3Dwhju%26ag%3D2%26name%3Dwhju%2540sina.com%26nick%3Dwhju%26sex%3D1%26ps%3D0%26email%3Dwhju%2540sina.com%26dob%3D1977-01-02; SUE=es%3D7bd42ab4c040afe3c82069799c201ade%26ev%3Dv0%26es2%3Df9e603d339786dd0467f708fb8577e9c; Apache=116.227.16.155.346301281427325225; ULOGIN_IMG=128152690912"
cookie="uc=18b%7C1h5%7C100; ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=jackie.ju@gmail.com; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; _s_tentry=-; _s_upa=37; Apache=116.227.16.155.346301281427325225; ULOGIN_IMG=128152690912; SUE=es%3D179580ba9c2d68c79e5d6a3c2278af6e%26ev%3Dv0%26es2%3D95b2f115ad7b792648c1d5ab5293a15f; SUP=cv%3D1%26bt%3D1281557454%26et%3D1281643854%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282162254; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0; uc=v2%7C3b%7C11"
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; _s_upa=52; ULOGIN_IMG=12817193265784; Apache=116.227.16.155.346301281427325225; SUE=es%3D8c419133d34556465d704ff4c1b00897%26ev%3Dv0%26es2%3D4b214db6688bdc0fbc3717d92c2ba287; SUP=cv%3D1%26bt%3D1281719351%26et%3D1281805751%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282324151; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0"
cookie="ALLYESID4=00100621164002822517; vjuids=a31d5c7c9.1294caab46b.0.31dcf5b8e83cd; ULV=1281427351283:2:1:1:116.227.16.155.346301281427325225:1276891535804; UOR=finance,finance,; SINAGLOBAL=116.227.22.37.234431236717259746; vjlast=1279313959; un=jackie.ju@gmail.com; tprivacyset=%7B%2220%22%3A0%2C%2219%22%3A0%2C%2218%22%3A0%2C%2217%22%3A0%2C%2216%22%3A0%2C%2215%22%3A0%2C%2214%22%3A0%2C%2213%22%3A0%2C%2212%22%3A0%2C%2211%22%3A0%2C%2210%22%3A0%2C%229%22%3A0%2C%228%22%3A0%2C%227%22%3A0%2C%226%22%3A0%2C%225%22%3A0%2C%224%22%3A0%2C%223%22%3A0%2C%222%22%3A0%2C%221%22%3A0%2C%220%22%3A0%2C%22uid%22%3A%221785122705%22%7D; appkey=; _s_tentry=-; _s_upa=66; ULOGIN_IMG=12817193265784; Apache=116.227.16.155.346301281427325225; SUE=es%3D3cf6b8c02ee87d266e2894547f1419de%26ev%3Dv0%26es2%3Dd0a4fedfde004a71b62ba275e93d74e5; SUP=cv%3D1%26bt%3D1281806648%26et%3D1281893048%26lt%3D1%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26sex%3D%26ps%3D0%26email%3D%26dob%3D; ALF=1282411448; SUR=uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26email%3D%26dob%3D%26ag%3D4%26sex%3D%26ssl%3D0; uc=1u0%7C8k%7C13"
cookie="USRHAWB=usrmdins313157; _s_tentry=-; UOR=,weibo.com,; Apache=6946222159244.558.1353178683162; SINAGLOBAL=6946222159244.558.1353178683162; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; SUS=SID-1785122705-1353179190-XD-ego4u-41cef2fa7ee7d8c6a2726d70289f2124; SUE=es%3D94f033a29ea02ea8f1d6c48185ce786c%26ev%3Dv1%26es2%3D3acdbb8f067282f458e2fce929129365%26rs0%3DRaMvaiGsYJYo%252BcmtumssIRpEAbem%252FQsNaZtw8mR6G7J0oc5FrNBTu7qKf%252FAkfhNlZS8FWtX9UbSHDiJULh84agep%252BG0d5eOvvIppJdLLGDWXXKoUkJdJ3mrn8YbjQZcLpG8%252BvnHe3PaioVVFUXjR%252BBOWL7m3rqRKoxZhB%252F1d7dU%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353179190%26et%3D1353265590%26d%3Dc909%26i%3Dbff8%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D11%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1353783985; SSOLoginState=1353179190; wvr=3.6; ads_ck=0; SinaRot/3/3renxin=43"
cookie="USRHAWB=usrmdins312_115; _s_tentry=-; UOR=,weibo.com,; Apache=6946222159244.558.1353178683162; SINAGLOBAL=6946222159244.558.1353178683162; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; SUS=SID-1785122705-1353179190-XD-ego4u-41cef2fa7ee7d8c6a2726d70289f2124; SUE=es%3D94f033a29ea02ea8f1d6c48185ce786c%26ev%3Dv1%26es2%3D3acdbb8f067282f458e2fce929129365%26rs0%3DRaMvaiGsYJYo%252BcmtumssIRpEAbem%252FQsNaZtw8mR6G7J0oc5FrNBTu7qKf%252FAkfhNlZS8FWtX9UbSHDiJULh84agep%252BG0d5eOvvIppJdLLGDWXXKoUkJdJ3mrn8YbjQZcLpG8%252BvnHe3PaioVVFUXjR%252BBOWL7m3rqRKoxZhB%252F1d7dU%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353179190%26et%3D1353265590%26d%3Dc909%26i%3Dbff8%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D11%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1353783985; SSOLoginState=1353179190; wvr=3.6; ads_ck=0; SinaRot/3/3renxin=43"
cookie="myuid=1785122705; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; UOR=,weibo.com,; SINAGLOBAL=6946222159244.558.1353178683162; Apache=6946222159244.558.1353178683162; _s_tentry=-; USRHAWB=usr213116; USREG=usrmdins15137; SUS=SID-1785122705-1353251033-XD-obtl9-249d9e68237c7c2ec551f5b909b22124; SUE=es%3D794e9327da24f1639a57c65e91842a15%26ev%3Dv1%26es2%3D28926c6cbde7b9df461230933f8cbaa1%26rs0%3DpODIPwrE%252Bx4ShevhSOIbD%252FGkv57lymX1Nnsd3gG%252FVx16gPqhyK4AAlfYyJTx7lyI4IdUzIlpMusqirVndmWY33vjzjjdCmqESxNw4oHtbrjN806k6DPIb7EEf7K0lILrjPkMDPXanDbW3KsEDigc7oAHdBnx6cWxr%252Ffan8y0uGI%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353251033%26et%3D1353337433%26d%3Dc909%26i%3D95b2%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D2%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1353855830; SSOLoginState=1353251033; un=jackie.ju@gmail.com; wvr=3.6; ads_ck=0; SinaRot/3/3renxin=81; SinaRot/2/z5O5ajrn8=11; SinaRot/1/z5HqJ1LnV=55"
# xiakexing app
cookie="myuid=1785122705; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; UOR=,weibo.com,; SINAGLOBAL=6946222159244.558.1353178683162; Apache=6946222159244.558.1353178683162; _s_tentry=-; USRHAWB=usr213117; USREG=usrmdins15137; un=ju@joyqom.com; ads_ck=1; SinaRot/3/3renxin=82; SinaRot/2/z5O5ajrn8=11; SinaRot/1/z5HqJ1LnV=55; SinaRot/1/yednYfmJE=75; SinaRot/1/z5SdCrOCb=50; ULOGIN_IMG=1353290322877; SUS=SID-3100584981-1353299849-XD-r4102-f86780421eb1db75e7e5239a48732124; SUE=es%3D2123036169da67139d9080cdbc88049c%26ev%3Dv1%26es2%3D12a66ac280b52424cb282a305613274c%26rs0%3D2jcLQFtBcYzMbKtNY5tJqnauDq72cInqdnOQKnZXJp1xdj%252FXCBPItGipHFfkNlNOG6wENMX2RkBcqURzu9ZRdmEvTwsfj9JKkyK9ZlgfWy0Y4M4Ja6cBAYvKnuvzBNSBzjXzdo0j2xcnl1aHuKDyv7uNvZ26lE98K22t6x2Ckf8%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353299849%26et%3D1353386249%26d%3Dc909%26i%3D2cff%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1353904642; SSOLoginState=1353299849; v=5; wvr=5; SinaRot/g/handbook=60"
cookie="_s_tentry=www.weibo.com; UOR=www.weibo.com,www.weibo.com,; Apache=6655958919901.442.1353555263130; SINAGLOBAL=6655958919901.442.1353555263130; ULV=1353555263154:1:1:1:6655958919901.442.1353555263130:; SUS=SID-3100584981-1353555283-XD-am9r7-d193db043ecd28e96f29ab5f03362124; SUE=es%3D085f5a545e4e9b58189f5334d2d0d223%26ev%3Dv1%26es2%3D049a917f4c423ee3c8cbdd15aeed1785%26rs0%3DTzKBXG262gHIPG4nsXD0bO%252FCowciN4GX8MJQtnnXskCXlJkq%252BWZ1XkXLHnhU9iQv85%252Fm8CqLCmddYKH9DF3iYcfnqA4x6luw1P7iAh2G03WxYD8uTitXt5ayRvnZwuqs6Mri0YO0FxgKRMUTJGTzWnk%252BEu%252BbkfeRTcZ4Etgsn%252FQ%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353555283%26et%3D1353641683%26d%3Dc909%26i%3Dd319%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D2%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1354160081; SSOLoginState=1353555283; v=5; USRHAWB=usrmdins312_185; wvr=5; SinaRot/u/3100584981%3Ftopnav%3D1%26wvr%3D5=73"
cookie="UOR=www.weibo.com,www.weibo.com,; ULV=1353555263154:1:1:1:6655958919901.442.1353555263130:; ALF=1354160081; wvr=5; SINAGLOBAL=6655958919901.442.1353555263130; SSOLoginState=1353555283; SUS=SID-3100584981-1353773291-XD-snxyp-63869baaae13ba041c2f17239edf2124; Apache=6655958919901.442.1353555263130; _s_tentry=www.weibo.com; WBStore=6c620bb7b11aa459|logo_1122; USRHAWB=usrmdins210113; SUE=es%3Df3f2e5e51a41b8816bb8cdc9c328e435%26ev%3Dv1%26es2%3D6f84106c4124ab28cd59511d03f5470c%26rs0%3D2RYI4I6%252F7zeNjnLvRdmx2okxKb5%252BUetyIURn%252Byg2mptkxsQByX6XZ3chIXZJc44OhD0tlNsYQtf6jNbHsCkQkHLqp8%252FRpG%252Fz9mi3OYp0130FzXPpePrC2vZaq95XVDb1EFz2Ex1Mv4waICsbGaaZ%252Bosd7xqu%252BOkYmenbjh3g%252FuM%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353773291%26et%3D1353859691%26d%3Dc909%26i%3Dd319%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D"
cookie="UOR=www.weibo.com,www.weibo.com,; ULV=1353555263154:1:1:1:6655958919901.442.1353555263130:; ALF=1354160081; wvr=5; SINAGLOBAL=6655958919901.442.1353555263130; SUS=SID-3100584981-1353889875-XD-5czh4-648cdf9cb4577cd097f868893b652124; _s_tentry=www.weibo.com; Apache=6655958919901.442.1353555263130; SSOLoginState=1353555283; USRHAWB=usrmdins212_170; SUE=es%3D51bd57e5f8369fd3a852d1a7c5d0999e%26ev%3Dv1%26es2%3D8449c6c780415236526cca3f6d683d95%26rs0%3Dsx8zh4XgjgYAE5OJw%252FDHIXK%252ByZKzY9UXAgjIWXPJvNOlrNIFjn66CcwFKh%252F%252BMBPtJI6gQ88gjhJxeicHTrJqFDds%252FWiEpvrkRlFTQbUAcf1TqP1RYabxkUhL71M1dcQncnb4LOfKgKFYd3Ay2y4wWrF0rQDEw2Yu4ld80JGZrtI%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353889875%26et%3D1353976275%26d%3Dc909%26i%3Dd319%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ads_ck=1"
cookie="USRHAWB=usr313226; v5reg=usrmdins1030; _s_tentry=-; appkey=; UOR=,www.weibo.com,; Apache=7271725288058.626.1354615360211; SINAGLOBAL=7271725288058.626.1354615360211; ULV=1354615360311:1:1:1:7271725288058.626.1354615360211:; SUS=SID-3100584981-1354615417-XD-6s2x4-2ae738d421b6e1fab614d6b6478e2124; SUE=es%3Df26f65fda30656e8e123dc7f2ec63012%26ev%3Dv1%26es2%3Dda4d6ee5c8c9e2039dbae70d69e17698%26rs0%3DgxdfdNhER5%252FM5axw5MbbP88xYxCuUk2WixNb1Z1jUNiVU%252FqJNOfuyIoIowp7nJW8nEMdhlFNVD%252Bo15OVkR%252BUCKrIMrI71454beTxMF1EspIrC6WsRBCHuXW8%252FnTnSylHTnccQjbBY8DHPDjeLvjBnbsbCe2YOu5I2pB28kck3zM%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354615418%26et%3D1354701818%26d%3Dc909%26i%3D2884%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1355220216; SSOLoginState=1354615418; v=5; un=ju@joyqom.com; wvr=5; SinaRot/u/3100584981%3Fwvr%3D5%26lf%3Dreg=79; WBStore=f57947a079372025|"
cookie="un=ju@joyqom.com; UOR=login.sina.com.cn,www.weibo.com,spr_wbbop_wb_denglutips_newbacc:1354121563740; myuid=1404793074; ULV=1354718225693:2:1:1:2416904103456.482.1354718225678:1354120665473; USRHAWB=usr313227; v5reg=usrmdins1028; _s_tentry=-; appkey=; Apache=2416904103456.482.1354718225678; SINAGLOBAL=2416904103456.482.1354718225678; SUS=SID-3100584981-1354718273-XD-140ak-312d325876cc55922d198f3bb4e32124; SUE=es%3D58824b3c46ed9437c1a875b137841a43%26ev%3Dv1%26es2%3Dda05f24301a0436d39da94a62b595a7d%26rs0%3DJsQx3gjZl%252BGJYwC3fCd1zxG85nnLVileNnfgCCz%252FOoqX66KbV7vohgIMEGGuKvIfvARlPmbpGb4Ez%252FlcJxPcDr95rDh2VMp6IpYsB8qd3%252FLrlDuhWIznFmVJVUUHj9tp2%252BttrJOwE57JJOqTlHiIpGCx5gCj7uHtd6k4J0tZjWo%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354718274%26et%3D1354804674%26d%3Dc909%26i%3Ddf82%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1355323070; SSOLoginState=1354718274; v=5; wvr=5; SinaRot/u/3100584981%3Fwvr%3D5%26lf%3Dreg=61"
cookie="_s_tentry=weibo.com; UOR=weibo.com,www.weibo.com,; Apache=7838428560298.35.1354914290584; SINAGLOBAL=7838428560298.35.1354914290584; ULV=1354914290587:1:1:1:7838428560298.35.1354914290584:; SUS=SID-3100584981-1354914367-XD-hst1i-d7f1da0e071b3d39cdd3fc7e53a72124; SUE=es%3Dabeef0e403adf1c98a4f6c0a9949c7f7%26ev%3Dv1%26es2%3D04e4d34dab38fc6ecb2c1ac4ef3a80bf%26rs0%3DMf1fBFtRCD7E1Yv0xsAAjkJlH%252Bf9w3saFWMemvxjK5ZFhgAyd4HJnmCWBZOj%252BtdtTerDPBaE%252BCKEauFFKHjdIL6qX7otiX6c%252BBqSfwN%252BaubvOHPRUI7jXwMBuK90uZRV3mGk6J7Zpq9q0qpKLh2jYCc0XvOG3TtI1ow4B5EaajU%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354914367%26et%3D1355000767%26d%3Dc909%26i%3Ddf82%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1355519164; SSOLoginState=1354914367; v=5; wvr=5"
cookie="UOR=weibo.com,www.weibo.com,; ULV=1354914290587:1:1:1:7838428560298.35.1354914290584:; ALF=1355519164; wvr=5; SINAGLOBAL=7838428560298.35.1354914290584; v=5; SSOLoginState=1354914367; SUS=SID-3100584981-1355152299-XD-ctkyr-779862c6fc8e0d37e1624b99bb572124; Apache=7838428560298.35.1354914290584; _s_tentry=weibo.com; USRHAWB=usrmdins312_215; SUE=es%3D5d107895d9527b543794952d6f4f422a%26ev%3Dv1%26es2%3D9c1efd931d15346b05f35a56b0720aa7%26rs0%3DgIuxPaLflZv2m%252B6923V9yZAho57wcu6Sc3JOPEjTPq0cAvl6Xua2y4ZXvZpUccnpEOl8YXbl0GBb%252Fcl0hiOZA7LfydAdnq5ATWIf%252BDZ7cwT4Y3klbSAY4tl53zpaXOeF%252BaisKl6P1ysvNnfat08ilXKtqPrsker4MsQSOHADRZ4%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1355152299%26et%3D1355238699%26d%3Dc909%26i%3Ddf82%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D"
require 'cookies.rb'
cookie = $cookies[:xkxapp]

# path_addfollow = "/attention/aj_addfollow.php"
path_addfollow = "/aj/f/group/update?__rnd=1353181699899"

http = Net::HTTP.new(domain, 80)
headers = {
  'Cookie' => cookie,
  'User-Agent'=> "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
  'Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/x-nuxeo-liveedit;application!vnd.oasis.opendocument.text;application!vnd.oasis.opendocument.spreadsheet;application!vnd.oasis.opendocument.presentation;application!msword;application!vnd.ms-excel;application!vnd.ms-powerpoint",
  # 'Referer' => "http://#{domain}/attention/att_list.php?action=1&uid=#{id}&page=0"
  'Referer' => "http://#{domain}/#{target_id}/fans?page=1"
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


# add comments
c_i = 0
c_content=["//", "///","////", "[话筒]"]
end_id= "3513608966875443"
number_in_page = 0
interval = 30 # time interval
trap("SIGINT") { throw :ctrl_c }
catch :ctrl_c do
begin
for p in (page_start..page_max) do
    log "page #{p}\n------------------------------\n"
    # path = "/attention/att_list.php?action=1&page=#{p}&uid=#{id}"
number_in_page = 0
   

    br = false
    #url = "http://t.sina.com.cn/1645494153/fans"
    #resp = Net::HTTP.post_form(URI.parse(url),{'Cookie'=>cookie})# Net::HTTP.get(URI.parse(url))
    path = "/aj/mblog/fsearch?count=15&_k=135318307315198&_t=0&__rnd=1353183175362"
    # home page http://weibo.com/aj/mblog/fsearch?
    path = "/aj/mblog/fsearch?page=#{p}&count=15&max_id=3513559583109439&pre_page=#{p}&end_id=#{end_id}&pagebar=1&_k=1353193203274317&_t=0&__rnd=1353196579671"

    http = Net::HTTP.new("s.weibo.com", 80)
    # search by '游戏' http://s.weibo.com/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1&page=3
    path = "/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1&page=#{p}"
    
    # search by "iphone 好玩"
    #path="/weibo/iphone%2520%25E5%25A5%25BD%25E7%258E%25A9&k=1&page=#{p}"
    
    # search by 'iPhone 游戏'
    #path="/weibo/iPhone%2520%25E6%25B8%25B8%25E6%2588%258F&k=1&page=#{p}"

    log "get page from #{path}"
    begin
    resp, d = http.get(path, headers)
            rescue Exception =>e
           p e.inspect
        end
    # p "--------- page content ---------"
      p "------->>#{d}"
     p "------->>#{resp.inspect}"
    #  p "--------- page content end ---------"
    
    #  jsr = JSON.parse(d)
    #  
    #  if (jsr['code'] != '100000')
    #    p " code is not 1000000, return"
    #          br = true
    #         break
    # end
    # 
    # data = jsr['data']
    #  p data.inspect
    
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
    # regexp = /<a.*?action-data=\"allowForward=.*?url=http.\/\/weibo.com\/(\d+)\/(\w+)&.*?mid=(\d+).*?uid=(\d+).*?>转发(\((.*?)\)){0,1}<\/a>.*?>评论(\((.*?)\)){0,1}<\/a>/im
    regexp = /<a.*?action-data=\"allowForward=.*?url=http.\/\/weibo.com\/(\d+)\/(\w+)&.*?mid=(\d+).*?uid=(\d+).*?>转发(\((.*?)\)){0,1}<\/a>.*?>评论(\((.*?)\)){0,1}<\/a>/im
 
    count = 0
    d.scan(regexp){|m|
        ouid = ""
        mid = ""
        comment_number = 100
        
        p "fans id #{m.inspect}"
        
        # p "fans id #{m[0]}"
        
        p "m1=#{m[1]}"
        
=begin        
        re = /action\-data=\"uid=(\d+).amp.mid=(\d+)\"/im
       
        m[1].scan(re){|m2|
        p "==>m2: #{m2.inspect}"
        mid = m2[1]
        }
        re2 = /<a href=\"\/(\d+)\/(\w+)\".*?\((.*?)\)<\/a>/im
        re2= /href=.*?action-type="feed_list_comment"  action-data=\"ouid=(.*?)&location=home.*?评论\(*(.*?)\)*<\/a>/
            # re2 = /action-type=\"feed_list_comment\"  action\-data=\"ouid=(.*?)\&location=home.*?评论\(*(.*?)\)*<\/a>/im
        re2 = /action-type=\"feed_list_comment\" action\-data=\"ouid=(.*?)\&location=home.*?评论(\(*(.*?)\)){0,1}<\/a>/im
        m[1].scan(re2){|m3|
        p "==>m3: #{m3.inspect}"
        ouid = m3[0]
        comment_number = m3[2].to_i if m3[2] != ""
        }
        
        re2=/action-type=\"feed_list_forward\" action-data=\".*?url=http:\/\/weibo.com\/(\d+)\/(\w+)&mid=(\d+)&name=(.*?)&uid=(\d+)&domain=.*?&pid=(\w+)" >转发(\((.*?)\)){0,1}<\/a>/
        wb_url = ""
        m[1].scan(re2){|m4|
             p "==>m4: #{m4.inspect}"
             wb_url = "/#{m4[0]}/#{m4[1]}"
          
        }
=end
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
            if json_ret["code"] == '100001'
                p "too much request today, sleep 3600 sec ..."
                # sleep (3600)
            end
            #print "stop\n"
            err_num += 1
            # br = true if err_num > max_err_num
            # break
        elsif  json_ret && json_ret["code"] == '100000'
            succ_number += 1
        else
        end
        
=begin        
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
              sleep(1)
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
=end 
          number_in_page += 1
          p "sleep 5 sec ..."
          sleep(5*2)
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
rescue SignalException => e
  raise e
rescue Exception => e
end
end # do
log("==== stop at #{Time.now.to_s} ===============")
log("myid:\t#{myid}\n")
log("starid:\t#{id}\n")
log("success of follow: #{succ_number}")
log("==============================================")
