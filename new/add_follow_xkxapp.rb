require 'net/http'
require 'util.rb'
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

# @@dbh=nil
# #begin
#     @@dbh = Mysql.real_connect("localhost", "root", "", "weibo")
#     log @@dbh.inspect
    
err_OK = "A00006"           # OK
err_nomorefollow = "M05002" # 关注人数达到上线
max_err_num = 100
err_num = 0

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
# page_start = 0 
# if $*[0] != nil
#     page_start = $*[0].to_i 
# else
#     rs= dbh.query("select * from global where name='lp#{id}#{target_id}'")
#     if rs && rs.num_rows>0 
#         page_start = rs[0].to_i
#     end
# end
# page_max =  fans_number/20 + 1
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
cookie="USRHAWB=usrmdins212103; _s_tentry=-; UOR=,weibo.com,; Apache=6946222159244.558.1353178683162; SINAGLOBAL=6946222159244.558.1353178683162; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; SUS=SID-1785122705-1353179190-XD-ego4u-41cef2fa7ee7d8c6a2726d70289f2124; SUE=es%3D94f033a29ea02ea8f1d6c48185ce786c%26ev%3Dv1%26es2%3D3acdbb8f067282f458e2fce929129365%26rs0%3DRaMvaiGsYJYo%252BcmtumssIRpEAbem%252FQsNaZtw8mR6G7J0oc5FrNBTu7qKf%252FAkfhNlZS8FWtX9UbSHDiJULh84agep%252BG0d5eOvvIppJdLLGDWXXKoUkJdJ3mrn8YbjQZcLpG8%252BvnHe3PaioVVFUXjR%252BBOWL7m3rqRKoxZhB%252F1d7dU%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353179190%26et%3D1353265590%26d%3Dc909%26i%3Dbff8%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D11%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1353783985; SSOLoginState=1353179190; wvr=3.6; ads_ck=0; SinaRot/3/3renxin=56; SinaRot/2/ysHPkvX0Q=2; SinaRot/3/3renxin%3Ftopnav%3D1%26wvr%3D4=68; SinaRot/3/3renxin%3Ftopnav%3D1%26wvr%3D4%26mblogsort%3D2=69; SinaRot/3/3renxin%231353199700674=57; SinaRot/1/z4vINw7L8=9; SinaRot/3/3renxin%231353199778323=75; SinaRot/2/z5EjjELbj=65; SinaRot/1/z5ET00gNF=59"

# qiangqiangshanrenxing
cookie="myuid=1785122705; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; UOR=,weibo.com,; SINAGLOBAL=6946222159244.558.1353178683162; Apache=6946222159244.558.1353178683162; _s_tentry=-; USRHAWB=usr213116; USREG=usrmdins15137; SUS=SID-1785122705-1353251033-XD-obtl9-249d9e68237c7c2ec551f5b909b22124; SUE=es%3D794e9327da24f1639a57c65e91842a15%26ev%3Dv1%26es2%3D28926c6cbde7b9df461230933f8cbaa1%26rs0%3DpODIPwrE%252Bx4ShevhSOIbD%252FGkv57lymX1Nnsd3gG%252FVx16gPqhyK4AAlfYyJTx7lyI4IdUzIlpMusqirVndmWY33vjzjjdCmqESxNw4oHtbrjN806k6DPIb7EEf7K0lILrjPkMDPXanDbW3KsEDigc7oAHdBnx6cWxr%252Ffan8y0uGI%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353251033%26et%3D1353337433%26d%3Dc909%26i%3D95b2%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D2%26uid%3D1785122705%26user%3Djackie.ju%2540gmail.com%26ag%3D4%26name%3Djackie.ju%2540gmail.com%26nick%3Djackie.ju%26fmp%3D%26lcp%3D2012-11-17%252018%253A56%253A34; ALF=1353855830; SSOLoginState=1353251033; un=jackie.ju@gmail.com; wvr=3.6; ads_ck=0; SinaRot/3/3renxin=81; SinaRot/2/z5O5ajrn8=11; SinaRot/1/z5HqJ1LnV=55"

# xiakexing app
cookie="myuid=1785122705; ULV=1353178683185:1:1:1:6946222159244.558.1353178683162:; UOR=,weibo.com,; SINAGLOBAL=6946222159244.558.1353178683162; Apache=6946222159244.558.1353178683162; _s_tentry=-; USRHAWB=usr213117; USREG=usrmdins15137; un=ju@joyqom.com; ads_ck=1; SinaRot/3/3renxin=82; SinaRot/2/z5O5ajrn8=11; SinaRot/1/z5HqJ1LnV=55; SinaRot/1/yednYfmJE=75; SinaRot/1/z5SdCrOCb=50; ULOGIN_IMG=1353290322877; SUS=SID-3100584981-1353299849-XD-r4102-f86780421eb1db75e7e5239a48732124; SUE=es%3D2123036169da67139d9080cdbc88049c%26ev%3Dv1%26es2%3D12a66ac280b52424cb282a305613274c%26rs0%3D2jcLQFtBcYzMbKtNY5tJqnauDq72cInqdnOQKnZXJp1xdj%252FXCBPItGipHFfkNlNOG6wENMX2RkBcqURzu9ZRdmEvTwsfj9JKkyK9ZlgfWy0Y4M4Ja6cBAYvKnuvzBNSBzjXzdo0j2xcnl1aHuKDyv7uNvZ26lE98K22t6x2Ckf8%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353299849%26et%3D1353386249%26d%3Dc909%26i%3D2cff%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1353904642; SSOLoginState=1353299849; v=5; wvr=5; SinaRot/g/handbook=60"
cookie="_s_tentry=www.weibo.com; UOR=www.weibo.com,www.weibo.com,; Apache=6655958919901.442.1353555263130; SINAGLOBAL=6655958919901.442.1353555263130; ULV=1353555263154:1:1:1:6655958919901.442.1353555263130:; SUS=SID-3100584981-1353555283-XD-am9r7-d193db043ecd28e96f29ab5f03362124; SUE=es%3D085f5a545e4e9b58189f5334d2d0d223%26ev%3Dv1%26es2%3D049a917f4c423ee3c8cbdd15aeed1785%26rs0%3DTzKBXG262gHIPG4nsXD0bO%252FCowciN4GX8MJQtnnXskCXlJkq%252BWZ1XkXLHnhU9iQv85%252Fm8CqLCmddYKH9DF3iYcfnqA4x6luw1P7iAh2G03WxYD8uTitXt5ayRvnZwuqs6Mri0YO0FxgKRMUTJGTzWnk%252BEu%252BbkfeRTcZ4Etgsn%252FQ%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353555283%26et%3D1353641683%26d%3Dc909%26i%3Dd319%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D2%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1354160081; SSOLoginState=1353555283; v=5; USRHAWB=usrmdins312_185; wvr=5; SinaRot/u/3100584981%3Ftopnav%3D1%26wvr%3D5=73"
cookie="UOR=www.weibo.com,www.weibo.com,; ULV=1353555263154:1:1:1:6655958919901.442.1353555263130:; ALF=1354160081; wvr=5; SINAGLOBAL=6655958919901.442.1353555263130; SUS=SID-3100584981-1353889875-XD-5czh4-648cdf9cb4577cd097f868893b652124; _s_tentry=www.weibo.com; Apache=6655958919901.442.1353555263130; SSOLoginState=1353555283; USRHAWB=usrmdins212_170; SUE=es%3D51bd57e5f8369fd3a852d1a7c5d0999e%26ev%3Dv1%26es2%3D8449c6c780415236526cca3f6d683d95%26rs0%3Dsx8zh4XgjgYAE5OJw%252FDHIXK%252ByZKzY9UXAgjIWXPJvNOlrNIFjn66CcwFKh%252F%252BMBPtJI6gQ88gjhJxeicHTrJqFDds%252FWiEpvrkRlFTQbUAcf1TqP1RYabxkUhL71M1dcQncnb4LOfKgKFYd3Ay2y4wWrF0rQDEw2Yu4ld80JGZrtI%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1353889875%26et%3D1353976275%26d%3Dc909%26i%3Dd319%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ads_ck=1"
cookie="USRHAWB=usrmdins31464; _s_tentry=weibo.com; UOR=weibo.com,www.weibo.com,; Apache=2282531159577.7363.1354049880736; SINAGLOBAL=2282531159577.7363.1354049880736; ULV=1354049880756:1:1:1:2282531159577.7363.1354049880736:; SUS=SID-3100584981-1354049930-XD-kozb3-287a3f751c015ff2a35fb07e75392124; SUE=es%3Db2ac112c6ab5e7709361dbcbaa80ae6e%26ev%3Dv1%26es2%3Db1e75b6dda4afa1208721f3ff04747f6%26rs0%3DDIrKKzIvUdz1YGq95b%252Fw22nUObXu9EO9nPeq2QEi3EuGHf4fo0N5QSr57Xiu9Vju3gwO7Ygdv7HZKlsS1cOfE7Q8epFXfD6qETKKojTujowr1XKg1Xh2QDWvJzK4kZ1euvFrF0CM3NQ147qG0uvhAB8npbT%252Bcf34BFxMJ59mKfI%253D%26rv%3D0; SUP=cv%3D1%26bt%3D1354049930%26et%3D1354136330%26d%3Dc909%26i%3D2884%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D0%26uid%3D3100584981%26user%3Dju%2540joyqom.com%26ag%3D4%26name%3Dju%2540joyqom.com%26nick%3D%25E4%25BE%25A0%25E5%25AE%25A2%25E8%25A1%258CApp%26fmp%3D%26lcp%3D; ALF=1354654726; SSOLoginState=1354049930; v=5; ads_ck=1; wvr=5; SinaRot/u/3100584981%3Ftopnav%3D1%26wvr%3D5=25"
# grab_and_follow(id, cookie)
search_and_follow(id, cookie)