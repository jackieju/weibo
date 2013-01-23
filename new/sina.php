<?php  
/** 
 * 功能: 模拟新浪微博登陆 
 * 用途: 模拟用户登陆, 以便进行后续操作, 比如自动化的控制自己的新浪app刷新某些数据 
 * 注意事项:  
 *  1. 需要安装nodejs 
 *  2. 需要下载新浪的加密js文件, 请到新浪登陆页查看网络请求自己下载最新版本(我当时用的: http://js.t.sinajs.cn/t35/miniblog/static/js/sso.js?version=e482ef2bbdaa8bc2) 
 *  3. 对新浪加密js文件进行修改, 以便让nodejs可以运行它 
 *      1) 在文件前面增加下面内容 
var window  = { 
    location    : { 
        hash        : '',  
        host        : 'weibo.com',  
        hostname    : 'weibo.com',  
        href        : 'http://weibo.com/',  
        pathname    : '/',  
        port        : '',  
        protocol    : 'http:',  
        search      : '' 
    },  
    navigator   : { 
        appCodeName     : 'Mozilla',  
        appName         : 'Netscape',  
        appVersion      : '5.0 (Macintosh)',  
        buildID         : '20120713134347',  
        cookieEnabled   : true,  
        doNotTrack      : 'unspecified',  
        language        : 'en-US' 
    } 
}; 
var location    = window.location; 
var navigator   = window.navigator; 
 *      2) 在文件后面增加下面内容 
var argv    = process.argv.splice(2); 
 
var pubkey      = argv[0], 
    servertime  = argv[1], 
    nonce       = argv[2], 
    password    = argv[3]; 
 
var RSAKey = new sinaSSOEncoder.RSAKey(); 
RSAKey.setPublic(pubkey, '10001'); 
password = RSAKey.encrypt([servertime, nonce].join("\t") + "\n" + password);  
console.log(password); 
process.exit(); 
 *  4. 修改encode_password函数中的nodejs程序路径和修改后的新浪js文件路径 
 *  5. 修改用户名密码 
 * author: selfimpr 
 * blog: http://blog.csdn.net/lgg201 
 * mail: lgg860911@yahoo.com.cn 
 */  
  
define('REQUEST_METHOD_GET',                'GET');  
define('REQUEST_METHOD_POST',               'POST');  
define('REQUEST_METHOD_HEAD',               'HEAD');  
  
define('COOKIE_FILE',                       '/tmp/sina.login.cookie');  
  
function curl_switch_method($curl, $method) {  
    switch ( $method) {  
        case REQUEST_METHOD_POST:  
            curl_setopt($curl, CURLOPT_POST, TRUE);  
            break;  
        case REQUEST_METHOD_HEAD:  
            curl_setopt($curl, CURLOPT_NOBODY, TRUE);  
            break;  
        case REQUEST_METHOD_GET:  
        default:  
            curl_setopt($curl, CURLOPT_HTTPGET, TRUE);  
            break;  
    }  
}  
function curl_set_headers($curl, $headers) {  
    if ( emptyempty($headers) ) return ;  
    if ( is_string($headers) )   
        $headers    = explode("\r\n", $headers);  
    #类型修复  
    foreach ( $headers as &$header )   
        if ( is_array($header) )   
            $header = sprintf('%s: %s', $header[0], $header[1]);  
    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);  
}  
function curl_set_datas($curl, $datas) {  
    if ( emptyempty($datas) ) return ;  
    curl_setopt($curl, CURLOPT_POSTFIELDS, $datas);  
}  
function curl_request($url, $method = REQUEST_METHOD_GET, $datas = NULL, $headers = NULL) {  
    static  $curl;  
    if ( !$curl )  
        $curl   = curl_init();  
    curl_switch_method($curl, $method);  
    curl_setopt($curl, CURLOPT_URL,                     $url);  
    curl_setopt($curl, CURLOPT_RETURNTRANSFER,          TRUE);  
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION,          TRUE);  
    curl_setopt($curl, CURLOPT_AUTOREFERER,             TRUE);  
    curl_setopt($curl, CURLOPT_COOKIEJAR,               COOKIE_FILE);  
    curl_setopt($curl, CURLOPT_COOKIESESSION,           TRUE);  
    if ( $datas )   
        curl_set_datas($curl, $datas);  
    if ( $headers)   
        curl_set_headers($curl, $headers);  
    $response   = curl_exec($curl);  
    if ( $errno = curl_errno($curl) ) {  
        error_log(sprintf("%10d\t%s\n", $errno, curl_error($curl)), 3, 'php://stderr');  
        return FALSE;  
    }  
    return $response;  
}  
  
function get_js_timestamp() {  
    return time() * 1000 + rand(0, 999);  
}  
function http_build_query_no_encode($datas) {  
    $r  = array();  
    foreach ( $datas as $k => $v )   
        $r[]    = $k . '=' . $v;  
    return implode('&', $r);  
}  
  
function makeUrl($url, $info, $encode = TRUE) {  
    if ( !is_array($info) || empty($info) ) return $url;  
    $components = parse_url($url);  
    if ( array_key_exists('query', $components) )   
        $query  = parse_str($components['query']);  
    else   
        $query  = array();  
    if ( is_string($info) ) $info = parse_str($info);  
    $query      = array_merge($query, $info);  
    $query      = $encode  
                ? http_build_query($query)  
                : http_build_query_no_encode($query);  
    $components['scheme']   = array_key_exists('scheme', $components)  
                            ? $components['scheme'] . '://'  
                            : '';  
    $components['user']     = array_key_exists('user', $components)  
                            ? $components['user'] . ':' . $components[HTTP_URL_PASS] . '@'  
                            : '';  
    $components['host']     = array_key_exists('host', $components)  
                            ? $components['host']  
                            : '';  
    $components['port']     = array_key_exists('port', $components)  
                            ? ':' . $components['port']  
                            : '';  
    $components['path']     = array_key_exists('path', $components)  
                            ? '/' . ltrim($components['path'], '/')  
                            : '';  
    $components['query']    = $query   
                            ? '?' . $query  
                            : '';  
    $components['fragment'] = array_key_exists('fragment', $components)  
                            ? '#' . $components['fragment']  
                            : '';  
    return sprintf('%s%s%s%s%s%s%s', $components['scheme'], $components['user'], $components['host'],   
                                $components['port'], $components['path'],   
                                $components['query'], $components['fragment']);  
}  
  
function encode_username($username) {  
    return base64_encode(urlencode($username));  
}  
function encode_password($pub_key, $password, $servertime, $nonce) {  
    #这里是要用nodejs执行新浪的js文件  
    $response   = `/usr/local/node.js-0.8.8/bin/node sina.js "$pub_key" "$servertime" "$nonce" "$password"`;  
    return substr($response, 0, strlen($response) - 1);  
}  
  
  
function main_page() {  
    return curl_request('weibo.com');  
}  
function prepare_login_info() {  
    $time   = get_js_timestamp();  
    $url    = makeUrl('http://login.sina.com.cn/sso/prelogin.php', array(  
        'entry'     => 'sso',   
        'callback'  => 'sinaSSOController.preloginCallBack',   
        'su'        => encode_username('undefined'),   
        'rsakt'     => 'mod',   
        'client'    => 'ssologin.js(v1.4.2)',   
        '_'         => $time,   
    ), FALSE);  
    $response   = curl_request($url);  
    $length     = strlen($response);  
    $left       = 0;  
    $right      = $length - 1;  
    while ( $left < $length )   
        if ( $response[$left] == '{' ) break;  
        else $left ++;  
    while ( $right > 0 )  
        if ( $response[$right] == '}' ) break;  
        else $right --;  
    $response   = substr($response, $left, $right - $left + 1);  
    return array_merge(json_decode($response, TRUE), array(  
        'preloginTime'  => max(get_js_timestamp() - $time, 100),   
    ));  
}  
  
function login($info, $username, $password) {  
    $feedbackurl    = makeUrl('http://weibo.com/ajaxlogin.php', array(  
        'framelogin'        => 1,   
        'callback'          => 'parent.sinaSSOController.feedBackUrlCallBack',   
    ));  
    $datas  = array(  
        'encoding'          => 'UTF-8',   
        'entry'             => 'weibo',   
        'from'              => '',   
        'gateway'           => 1,   
        'nonce'             => $info['nonce'],   
        'prelt'             => $info['preloginTime'],   
        'pwencode'          => 'rsa2',   
        'returntype'        => 'META',   
        'rsakv'             => $info['rsakv'],   
        'savestate'         => 7,   
        'servertime'        => $info['servertime'],   
        'service'           => 'miniblog',   
        'sp'                => encode_password($info['pubkey'], $password, $info['servertime'], $info['nonce']),   
        'ssosimplelogin'    => 1,   
        'su'                => encode_username($username),   
        'url'               => $feedbackurl,   
        'useticket'         => 1,   
        'vsnf'              => 1,   
    );  
    $url    = makeUrl('http://login.sina.com.cn/sso/login.php', array(  
        'client'    => 'ssologin.js(v1.4.2)',   
    ), FALSE);  
    $response   = curl_request($url, REQUEST_METHOD_POST, $datas);  
    $sign       = 'location.replace(\'';  
    $response   = substr($response, strpos($response, $sign) + strlen($sign));  
    $location   = substr($response, 0, strpos($response, '\''));  
    $response   = curl_request($location);  
    $length     = strlen($response);  
    $left       = 0;  
    $right      = $length - 1;  
    while ( $left < $length )   
        if ( $response[$left] == '{' ) break;  
        else $left ++;  
    while ( $right > 0 )  
        if ( $response[$right] == '}' ) break;  
        else $right --;  
    $response   = substr($response, $left, $right - $left + 1);  
    return json_decode($response, true);  
}  
  
$info   = prepare_login_info();  
$info   = login($info, '用户名', '密码');  
echo curl_request('http://weibo.com/u/' . $info['userinfo']['uniqueid'] . $info['userinfo']['userdomain']); 