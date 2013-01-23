require 'net/http'
require 'CGI'
require 'json'
require 'Mysql'
require 'addfollow.rb'
require 'comment.rb'

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

cookie="USRHAWB=usrmdins212_114; _s_tentry=-; UOR=,www.weibo.com,; Apache=5794354652357.579.1353308774411; SINAGLOBAL=5794354652357.579.1353308774411; ULV=1353308774415:1:1:1:5794354652357.579.1353308774411:; SUS=SID-1785122705-1353308795-XD-wjore-78937d94e4bb087a805acbc83b212124; SUE=es%3Dfc5b1a4cdf902c77746ed708db75da8a%26ev%3Dv1%26es2%3D4edd74b317ec4367abb7715503ceeb70%26rs0%3DLoEETJlDyRo4uYsxXbl8D3gk2T%252F4T9K0h7K%252FnfWyFHj91IYU8s9Ss7MH6VdSOBJoMIqfOVdGXS7gqU7gQ9OZTakLBO2WKHqtns2bkmyWRIF1Dz2kYGRF3q1%252BX21zYAF3G8DGiXIyfOPrASUMgMDiSaw1QUV76rAYYl6EGCPc0FA%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353308795%26et%3D1353395195%26d%3Dc909%26i%3Dd0d9%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1353913593; SSOLoginState=1353308795; un=jackie.ju@gmail.com;wvr=3.6; SinaRot/3/3renxin%3Fwvr%3D3.6%26lf%3Dreg=65; ads_ck=1;SinaRot/2/z5DifoRdR=28"
cookie="myuid=1785122705; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; UOR=,weibo.com,; SINAGLOBAL=6946222159244.558.1353178683162; ULOGIN_IMG=1353290322877; _s_tentry=-; Apache=6946222159244.558.1353178683162; USRHAWB=usrmdins212_148; WBStore=9cb27f876adebd1c|logo_18; USRHAJAWB=usrmdins13145; appkey=; SinaRot/u/3100584981%3Ftopnav%3D1%26wvr%3D5=36; SUS=SID-1785122705-1353553477-XD-piw28-f2a575ad6bf16afb4c4346cd99d02124; SUE=es%3D45cedff102e678b58d24fa282b0ff969%26ev%3Dv1%26es2%3D6e2c71be05f6d95556c3c38802b1f835%26rs0%3DVi3S9m23mZxaT945HuvGHp6L94wKaR9euQ7r1mxMh8yG%252FQEwTvdS9T7F%252ByVmy7BakicLftuoF8mMIV7S%252F9WYLDRcZbOed1%252F2t7kP1KFXHMv%252FRY9HCOkRI5UsDRYl%252BQJPOYuyDgqClvmHUwNAceedqKoS9Bv7k6matRX%252BBZ88gSg%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353553477%26et%3D1353639877%26d%3Dc909%26i%3Db32f%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1354158274; SSOLoginState=1353553477; wvr=3.6"
cookie="myuid=1785122705; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; UOR=,weibo.com,; un=jackie.ju@gmail.com; SINAGLOBAL=6946222159244.558.1353178683162; appkey=; Apache=6946222159244.558.1353178683162; _s_tentry=-; ULOGIN_IMG=1353290322877; v5reg=usrmdins1029; USRHAWB=usr213233; USREG=usrmdins15137; SUS=SID-1785122705-1353554910-XD-jdcf1-96c68880727a5ab571576683fb802124; SUE=es%3D99d37d242a914294b7bbf74e722e34b2%26ev%3Dv1%26es2%3Dc2c1053a2b5ab27f49c6960676d12c3d%26rs0%3D3FlP0NVGw8SxCndgPceAPwB%252BadVfPBvnzV97GVYbQ%252FLawX5A%252BLCrEOVcXcNqLIchTU1%252FMqiCoYyy%252FznsHGfKCKLbXbK8S9pKf6PLaCfcphXgsOyVmoEqtvfpx3YD1OMAUxG82yxh8FFLJkzadTzm%252FL1S8BFxqAUVkHCdJS8MKzE%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353554910%26et%3D1353641310%26d%3Dc909%26i%3Dccae%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1354159708; SSOLoginState=1353554910; wvr=3.6; ads_ck=1; SinaRot/3/3renxin%3Fwvr%3D3.6%26lf%3Dreg=53"
cookie="USRHAWB=usrmdins211154; _s_tentry=-; UOR=,weibo.com,; Apache=4372356987997.5444.1353890120733; SINAGLOBAL=4372356987997.5444.1353890120733; ULV=1353890120759:1:1:1:4372356987997.5444.1353890120733:; SUS=SID-1785122705-1353890147-XD-eloxt-48eeecf36cd0f4729f54f00afaff2124; SUE=es%3D0a7b761cf08bd94d7d893d5314b5ebe6%26ev%3Dv1%26es2%3D37a7e201e11bf890c1d34da9ff9bf2a3%26rs0%3DkVYFiAi9nLRDBnkobR%252ByPomY2YFZD3OdXoTDWprdGM22mpgGxiWRtVYnFAOuUWuzjgMFgLUh4UtqTkWyNWIEwQWvZM0yB9cGi%252Ffo9GVradq5s7pc49zuGxXoDo7N1F9nAWM5JzA2JIJypZgnmvzALdIChFT1WRKWC5KS4aMUWD4%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353890147%26et%3D1353976547%26d%3Dc909%26i%3D7453%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1354494943; SSOLoginState=1353890147; wvr=3.6; ads_ck=1"
cookie="USRHAWB=usrmdins211143; _s_tentry=-; UOR=,weibo.com,; Apache=9972967931804.578.1354615141861; SINAGLOBAL=9972967931804.578.1354615141861; ULV=1354615141881:1:1:1:9972967931804.578.1354615141861:; SUS=SID-1785122705-1354615169-XD-b2arz-aaa8d0b897a24b543260f76fb0e42124; SUE=es%3D6b0ba6bd023a13a4acdbcba7e54bd27f%26ev%3Dv1%26es2%3Daf2b3ffd0bc9ac80ec368a7130c3af8f%26rs0%3DyirXdYHHLQkHIZVYcf5gmDDwiSWsZoJCGyHLJslXeQ0CBF%252FL5ufo%252BnZWEbWgNMabcrnyZJhL4xYKDDj5YmhExq0odJ3uagzUY8ItrpR4ZY8zVsgGYz7x8YmzY4aIKagzdd%252B1QvzvZGWtY8EpDcVnInOHIhB52xD4tXsvX1CDhzw%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354615169%26et%3D1354701569%26d%3Dc909%26i%3Daaeb%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1355219965; SSOLoginState=1354615169; wvr=3.6"
cookie="USRHAWB=usr313239; v5reg=usrmdins1031; _s_tentry=www.weibo.com; appkey=; UOR=www.weibo.com,www.weibo.com,; Apache=5362196107096.557.1354718386874; SINAGLOBAL=5362196107096.557.1354718386874; ULV=1354718387012:1:1:1:5362196107096.557.1354718386874:; SUS=SID-1785122705-1354718407-XD-pdnwb-446f652a434aed401db3d413098b2124; SUE=es%3D4f74958559ad70dcc6e8ea4d8e07da3c%26ev%3Dv1%26es2%3D92025adc013a37a6b7fe19e98fafb59c%26rs0%3Dzjny%252BkSQKTD0q62sc%252BYFD3yPw6430uhYrKDXGeP6lysCd8mrvr91fK%252FsZqFE3mUuWR0Z1BghMIGF8VlY4GpkEvJmTU5c02FZWVgTXxap6xjseLa6JT5GRjEI%252B%252Boiaa3GOLrSB0EFPWK3EpMVM91149tyKtIKawb4NT05wofr2BA%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354718407%26et%3D1354804807%26d%3Dc909%26i%3D460b%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1355323204; SSOLoginState=1354718407; un=jackie.ju@gmail.com; wvr=3.6"
cookie="wvr=3.6; ALF=1355323204; ULV=1354718387012:1:1:1:5362196107096.557.1354718386874:; UOR=www.weibo.com,www.weibo.com,; SINAGLOBAL=5362196107096.557.1354718386874; SSOLoginState=1354718407; SUS=SID-1785122705-1354914169-XD-s1wy8-ef37d7706a648705798ce3cf93002124; Apache=5362196107096.557.1354718386874; appkey=; _s_tentry=www.weibo.com; SUE=es%3D288037919974c374036a27e85b7ffa4c%26ev%3Dv1%26es2%3Dc2198b1bcdc2d57adaed83656986af24%26rs0%3DDAncEfxcUSG5pTukXzAePM414ylypGDGiCskdREXRCXBpGwv%252BvqJgb2%252FRAj8yYiIEOPYvqHZ6fMvTlXDtvvju5UexaTOgYe%252B6Jn2ggDSUzT72FgPbZFmVpwiqdXHtO7mEaNC5O%252FTQd%252FXZ1h%252FXqIOPsSLADtVBF7Q%252Fc8F4Qmh214%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354914169%26et%3D1355000569%26d%3Dc909%26i%3Dae53%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; USRHAWB=usrmdins212_124; SinaRot/3/3renxin%3Fgroupfeed%3D1=35; ads_ck=1"
require 'cookies.rb'
cookie = $cookies[:qq3rx]
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
# c_content=["//", "///","////", "[话筒]"]
c_content= ["玩过iPhone上的「侠客行」吗？很好玩的！https://itunes.apple.com/cn/app/xia-ke-xing/id533032159?mt=8[做鬼脸]",
"玩过iPhone上的「侠客行」吗？我觉得超好玩的！https://itunes.apple.com/us/app/xia-ke-xing/id533032159?mt=8[做鬼脸]",
"玩过iPhone上的「侠客行」吗？很好玩的！我玩了很久还在玩https://itunes.apple.com/cn/app/xia-ke-xing/id533032159?mt=8[做鬼脸]",
"玩过iPhone游戏「侠客行」吗？很好玩的！https://itunes.apple.com/us/app/xia-ke-xing/id533032159?mt=8[做鬼脸]",
"玩过iPhone游戏「侠客行」吗？我觉得超好玩的！https://itunes.apple.com/cn/app/xia-ke-xing/id533032159?mt=8[做鬼脸]",
"玩过iPhone游戏「侠客行」吗？很好玩的！我玩了很久还在玩https://itunes.apple.com/us/app/xia-ke-xing/id533032159?mt=8[做鬼脸]"]
end_id= "3513608966875443"
number_in_page = 0
interval = 30 # time interval
page_start = 0
while true
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
    # search by '游戏' http://s.weibo.com/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1&page=3
    http = Net::HTTP.new("s.weibo.com", 80)
    path = "/weibo/%25E6%25B8%25B8%25E6%2588%258F&k=1&page=#{p}"
    
    # search by "iphone 游戏" http://s.weibo.com/weibo/iphone%2520%25E6%25B8%25B8%25E6%2588%258F?topnav=1&wvr=5&b=1
    path = "/weibo/iphone%2B%25E6%25B8%25B8%25E6%2588%258F&b=1&page=#{p}"
    
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
    regexp = /<dl class=\"feed_list\".*?<p node-type=\"feed_list_content\">(.*?)<\/p>.*?<a.*?action-data=\"allowForward=.*?url=http.\/\/weibo.com\/(\d+)\/(\w+)&.*?mid=(\d+).*?uid=(\d+).*?>转发(\((.*?)\)){0,1}<\/a>.*?>评论(\((.*?)\)){0,1}<\/a>.*?来自.*?<a.*?>.*?(iPhone|iPad).*?<\/a>/im
    count = 0
    d.scan(regexp){|m|
        ouid = ""
        mid = ""
        comment_number = 100
        
        p "--->fans id #{m.inspect}"
        
        # p "fans id #{m[0]}"
        p "weibo url:/#{m[1]}/#{m[2]}"
        
        isV = false
        m[0].scan(/<img.*?class=\"approve/){|_mm|
            isV = true
        }

        next if !isV
        p "===>isV!!!"
        p "m2=#{m[2]}"
        
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

    mid = m[3]
    ouid= m[4]
    comment_number = m[8].to_i
    wb_url = "/#{ouid}/#{m[2]}"
           p "==>url: #{wb_url}, /#{ouid}/#{mid}, comment number #{comment_number}, "
  
        
        if ouid == ""  || mid == "" #|| comment_number > 100
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
                p "too much request today, sleep 300 sec ..."
                 sleep (300)
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
        domain = "s.weibo.com"
        p "domain=#{domain}"
=begin
        http = Net::HTTP.new(domain, 80)

 
    #http://weibo.com/aj/mblog/forward?__rnd=1353199806827&_t=0&appkey=&group_source=group_all&location=home&mid=3513585890420479&module=tranlayout&reason=%E8%BD%AC%E5%8F%91%E5%BE%AE%E5%8D%9A&style_type=1
    #http://weibo.com/aj/comment/add?__rnd=1353199507130&_t=0&act=post&content=haha&forward=0&group_source=group_all&isroot=0&location=home&mid=3513585890420479&module=scommlist&uid=1785122705
        # q = "fromuid=#{myid}&uid=#{m.to_s}"
        # q = "type=s&remark=&user=#{m.to_s}&gid=%5B%5D&_t=0"
        # http://weibo.com/aj/comment/add?__rnd=1353187944254&_t=0&act=post&content=hehe&forward=0&isroot=0&location=mblog&mid=3468416587615016&module=bcommlist&type=big&uid=1785122705
        # q = "act=post&mid=3468416587615016&uid=1785122705&forward=0&isroot=0&content=haha&type=big&location=mblog&module=bcommlist&_t=0"
	    c_i = (c_i+1)%c_i.size
	    q="__rnd=1353199806827&_t=0&act=post&content=#{c_content[c_i]}&forward=0&isroot=0&location=mblog&mid=#{mid}&module=bcommlist&type=big&uid=#{ouid}"
		log(q)
        # headers["user"] = m.to_s
        # headers["type"] = "s"
        # headers["_t"] = "0"
        headers["X-Requested-With"] = "XMLHttpRequest"
        headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
        if domain == "weibo.com"
            path_comment = "/aj/comment/add"
        elsif domain == "s.weibo.com"
            path_comment = "/ajax/comment/add"
        end
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
                          stmt = "insert into commented values('#{ouid}', '#{mid}', '#{id}', '#{wb_url})"
              p "stmt = #{stmt}"
            dbh.query(stmt)
            p "====> add comments(page #{p}/#{number_in_page}) "#{c_content[c_i]}" OK <==="
          end
         rescue Exception =>e
           p e.inspect
        
         end # rescue
=end
   if add_comment(cookie,ouid,mid,"hello",wb_url,domain, id)
       p "====> add comments(page #{p}/#{number_in_page}) "#{c_content[c_i]}" OK <==="
          number_in_page += 1
      end
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
end # while
log("==== stop at #{Time.now.to_s} ===============")
log("myid:\t#{myid}\n")
log("starid:\t#{id}\n")
log("==============================================")
