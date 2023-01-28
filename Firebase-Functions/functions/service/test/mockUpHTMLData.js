export const mockUpHTMLData = `
<!DOCTYPE html>
<html id="__hELLO" lang="ko" data-theme="light">

                                                                  <head>
                
                
                        <!-- BusinessLicenseInfo - START -->
        
            <link href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/plugin/BusinessLicenseInfo/style.css" rel="stylesheet" type="text/css"/>

            <script>function switchFold(entryId) {
    var businessLayer = document.getElementById("businessInfoLayer_" + entryId);

    if (businessLayer) {
        if (businessLayer.className.indexOf("unfold_license") > 0) {
            businessLayer.className = "business_license_layer";
        } else {
            businessLayer.className = "business_license_layer unfold_license";
        }
    }
}
</script>

        
        <!-- BusinessLicenseInfo - END -->
        <!-- DaumShow - START -->
        <style type="text/css">#daumSearchBox {
    height: 21px;
    background-image: url(//i1.daumcdn.net/imgsrc.search/search_all/show/tistory/plugin/bg_search2_2.gif);
    margin: 5px auto;
    padding: 0;
}

#daumSearchBox input {
    background: none;
    margin: 0;
    padding: 0;
    border: 0;
}

#daumSearchBox #daumLogo {
    width: 34px;
    height: 21px;
    float: left;
    margin-right: 5px;
    background-image: url(//i1.daumcdn.net/img-media/tistory/img/bg_search1_2_2010ci.gif);
}

#daumSearchBox #show_q {
    background-color: transparent;
    border: none;
    font: 12px Gulim, Sans-serif;
    color: #555;
    margin-top: 4px;
    margin-right: 15px;
    float: left;
}

#daumSearchBox #show_btn {
    background-image: url(//i1.daumcdn.net/imgsrc.search/search_all/show/tistory/plugin/bt_search_2.gif);
    width: 37px;
    height: 21px;
    float: left;
    margin: 0;
    cursor: pointer;
    text-indent: -1000em;
}
</style>

        <!-- DaumShow - END -->

<!-- System - START -->

<!-- System - END -->

        <!-- TistoryProfileLayer - START -->
        <link href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/plugin/TistoryProfileLayer/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/plugin/TistoryProfileLayer/script.js"></script>

        <!-- TistoryProfileLayer - END -->

                
                <meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="format-detection" content="telephone=no">
<script src="//t1.daumcdn.net/tistory_admin/lib/jquery/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script src="//t1.daumcdn.net/tistory_admin/lib/lightbox/js/lightbox-v2.10.0.min.js" defer></script>
<script type="text/javascript" src="//t1.daumcdn.net/tiara/js/v1/tiara.min.js"></script><meta name="referrer" content="always"/>
<meta name="google-adsense-platform-account" content="ca-host-pub-9691043933427338"/>
<meta name="google-adsense-platform-domain" content="tistory.com"/>
<meta name="description" content="지난 글에서 UICollectionView Cell에 더티 플래그를 사용해 Constraints 업데이트 하는 횟수를 줄여주었다. [iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현 부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm malchafrappuccino.tistory.com 막상 적용하기는 했는데 성능이 얼마나 좋아졌는지 정량적으로 확인해보고 싶어 테스트를 진행했다. .."/>
<meta property="og:type" content="article"/>
<meta property="og:url" content="https://malchafrappuccino.tistory.com/148"/>
<meta property="og.article.author" content="말차프라푸치노"/>
<meta property="og:site_name" content="말차맛 개발공부"/>
<meta property="og:title" content="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정"/>
<meta name="by" content="말차프라푸치노"/>
<meta property="og:description" content="지난 글에서 UICollectionView Cell에 더티 플래그를 사용해 Constraints 업데이트 하는 횟수를 줄여주었다. [iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현 부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm malchafrappuccino.tistory.com 막상 적용하기는 했는데 성능이 얼마나 좋아졌는지 정량적으로 확인해보고 싶어 테스트를 진행했다. .."/>
<meta property="og:image" content="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png"/>
<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:site" content="@TISTORY"/>
<meta name="twitter:title" content="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정"/>
<meta name="twitter:description" content="지난 글에서 UICollectionView Cell에 더티 플래그를 사용해 Constraints 업데이트 하는 횟수를 줄여주었다. [iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현 부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm malchafrappuccino.tistory.com 막상 적용하기는 했는데 성능이 얼마나 좋아졌는지 정량적으로 확인해보고 싶어 테스트를 진행했다. .."/>
<meta property="twitter:image" content="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png"/>
<meta content="https://malchafrappuccino.tistory.com/148" property="dg:plink" content="https://malchafrappuccino.tistory.com/148"/>
<meta name="plink"/>
<meta name="title" content="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정"/>
<meta name="article:media_name" content="말차맛 개발공부"/>
<meta property="article:mobile_url" content="https://malchafrappuccino.tistory.com/m/148"/>
<meta property="article:pc_url" content="https://malchafrappuccino.tistory.com/148"/>
<meta property="article:mobile_view_url" content="https://malchafrappuccino.tistory.com/m/148"/>
<meta property="article:pc_view_url" content="https://malchafrappuccino.tistory.com/148"/>
<meta property="article:talk_channel_view_url" content="https://malchafrappuccino.tistory.com/m/148"/>
<meta property="article:pc_service_home" content="https://www.tistory.com"/>
<meta property="article:mobile_service_home" content="https://www.tistory.com/m"/>
<meta property="article:txid" content="4726082_148"/>
<meta property="article:published_time" content="2023-01-27T23:37:34+09:00"/>
<meta property="og:regDate" content="20230127095308"/>
<meta property="article:modified_time" content="2023-01-28T14:20:12+09:00"/>
<link rel="stylesheet" type="text/css" href="https://t1.daumcdn.net/tistory_admin/lib/lightbox/css/lightbox.min.css"/>
<link rel="stylesheet" type="text/css" href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/style/font.css"/>
<link rel="stylesheet" type="text/css" href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/style/content.css"/>
<link rel="stylesheet" type="text/css" href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/style/uselessPMargin.css"/>
<script type="text/javascript">(function() {
    var tjQuery = jQuery.noConflict(true);
    window.tjQuery = tjQuery;
    window.orgjQuery = window.jQuery; window.jQuery = tjQuery;
    window.jQuery = window.orgjQuery; delete window.orgjQuery;
})()</script>
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/base.js"></script>
<script type="text/javascript">if (!window.T) { window.T = {} }
window.T.config = {"TOP_SSL_URL":"https://www.tistory.com","PREVIEW":false,"ROLE":"owner","PREV_PAGE":"","NEXT_PAGE":"","BLOG":{"id":4726082,"name":"malchafrappuccino","title":"말차맛 개발공부","isDormancy":false},"NEED_COMMENT_LOGIN":false,"COMMENT_LOGIN_CONFIRM_MESSAGE":"","LOGIN_URL":"https://www.tistory.com/auth/login/?redirectUrl=https%3A%2F%2Fmalchafrappuccino.tistory.com%2F148","DEFAULT_URL":"https://malchafrappuccino.tistory.com","USER":{"name":"말차프라푸치노","homepage":"https://malchafrappuccino.tistory.com"},"SUBSCRIPTION":{"status":"none","isConnected":false,"isPending":false,"isWait":false,"isProcessing":false,"isNone":true},"IS_LOGIN":true,"HAS_BLOG":true,"TOP_URL":"http://www.tistory.com","JOIN_URL":"https://www.tistory.com/member/join","ROLE_GROUP":"member"};
window.appInfo = {"domain":"tistory.com","topUrl":"https://www.tistory.com","loginUrl":"https://www.tistory.com/auth/login","logoutUrl":"https://www.tistory.com/auth/logout"};
window.initData = {"user":{"id":4897208,"loginId":"utak@kakao.com","name":"말차프라푸치노"}};

window.TistoryBlog = {
    basePath: "",
    url: "https://malchafrappuccino.tistory.com",
    tistoryUrl: "https://malchafrappuccino.tistory.com",
    manageUrl: "https://malchafrappuccino.tistory.com/manage",
    token: "vvXgnlzarL2jXDSsCm13V957D/jwdu7jjaLd7F4Rm4kU+8Wi6HvxWfOdzHslHSCL"
};
var servicePath = "";
var blogURL = "";</script>
<script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

                
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정 — 말차맛 개발공부</title>
    <link rel="alternate" type="application/rss+xml" title="말차맛 개발공부" href="https://malchafrappuccino.tistory.com/rss">
    <script async src="//kit.fontawesome.com/65f7e05682.js"></script>
    <script async src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.2/highlight.min.js"></script>
    <script defer src="//cdn.jsdelivr.net/npm/uikit@3.5.7/dist/js/uikit.min.js"></script>
    <script defer src="//cdn.jsdelivr.net/npm/uikit@3.5.7/dist/js/uikit-icons.min.js"></script>
    <link rel="preconnect" href="https://ka-f.fontawesome.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="stylesheet" href="//fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500;700&display=swap">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/uikit@3.5.7/dist/css/uikit.min.css">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/gh/wan2land/d2coding/d2coding-ligature-full.css" media="print" onload="this.media='all'">
    <link id="__hljs" rel="stylesheet" href="#">
    <script>
      var $ = tjQuery;
    </script>
    <script>
      window.H = {};
      window.H.skinOptions = {
        listImageMode: 'default',
        gridColumnCount: '3',
        galleryColumnCount: '3',
        articleMode: 'default',
        hljsThemeLight: 'xcode',
        hljsThemeDark: 'vs2015',
        comment: '1',
        message: '1',
        messageRequest: '도움이 되셨다면 공감 부탁드립니다!',
        messageHeart: '공감해주셔서 감사합니다.',
        messageUnheart: '공감이 취소되었습니다.',
        messageSubscribe: '구독 감사합니다.',
        messageUnsubscribe: '구독이 취소되었습니다.',
        messageUrl: '포스트 주소가 복사되었습니다.'
      };
    </script>
    <script>
      $('html').attr('data-theme', localStorage.TTDARK ? localStorage.TTDARK === 'Y' ? 'dark' : 'light' : window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : $('html').attr('data-theme'));
    </script>
    <style>
      :root {
        --h-article-width: 720px;
        --h-index-width: 1100px;
        --h-guestbook-width: 720px;
        --h-tagcloud-width: 1100px;
        --h-gallery-item-height: 280px;
      }
    </style>
    <script defer src="https://tistory1.daumcdn.net/tistory/4726082/skin/images/app.1c48b1a9629ce4d65f09.js?_version_=1633880738"></script>
    <script defer src="https://tistory1.daumcdn.net/tistory/4726082/skin/images/script.FrbryNdOYVQxSJh7oOwJ.js?_version_=1633880738"></script>
    <link rel="stylesheet" href="https://tistory1.daumcdn.net/tistory/4726082/skin/style.css?_version_=1633880738">
  
                
                
                <style type="text/css">.another_category {
    border: 1px solid #E5E5E5;
    padding: 10px 10px 5px;
    margin: 10px 0;
    clear: both;
}

.another_category h4 {
    font-size: 12px !important;
    margin: 0 !important;
    border-bottom: 1px solid #E5E5E5 !important;
    padding: 2px 0 6px !important;
}

.another_category h4 a {
    font-weight: bold !important;
}

.another_category table {
    table-layout: fixed;
    border-collapse: collapse;
    width: 100% !important;
    margin-top: 10px !important;
}

* html .another_category table {
    width: auto !important;
}

*:first-child + html .another_category table {
    width: auto !important;
}

.another_category th, .another_category td {
    padding: 0 0 4px !important;
}

.another_category th {
    text-align: left;
    font-size: 12px !important;
    font-weight: normal;
    word-break: break-all;
    overflow: hidden;
    line-height: 1.5;
}

.another_category td {
    text-align: right;
    width: 80px;
    font-size: 11px;
}

.another_category th a {
    font-weight: normal;
    text-decoration: none;
    border: none !important;
}

.another_category th a.current {
    font-weight: bold;
    text-decoration: none !important;
    border-bottom: 1px solid !important;
}

.another_category th span {
    font-weight: normal;
    text-decoration: none;
    font: 10px Tahoma, Sans-serif;
    border: none !important;
}

.another_category_color_gray, .another_category_color_gray h4 {
    border-color: #E5E5E5 !important;
}

.another_category_color_gray * {
    color: #909090 !important;
}

.another_category_color_gray th a.current {
    border-color: #909090 !important;
}

.another_category_color_gray h4, .another_category_color_gray h4 a {
    color: #737373 !important;
}

.another_category_color_red, .another_category_color_red h4 {
    border-color: #F6D4D3 !important;
}

.another_category_color_red * {
    color: #E86869 !important;
}

.another_category_color_red th a.current {
    border-color: #E86869 !important;
}

.another_category_color_red h4, .another_category_color_red h4 a {
    color: #ED0908 !important;
}

.another_category_color_green, .another_category_color_green h4 {
    border-color: #CCE7C8 !important;
}

.another_category_color_green * {
    color: #64C05B !important;
}

.another_category_color_green th a.current {
    border-color: #64C05B !important;
}

.another_category_color_green h4, .another_category_color_green h4 a {
    color: #3EA731 !important;
}

.another_category_color_blue, .another_category_color_blue h4 {
    border-color: #C8DAF2 !important;
}

.another_category_color_blue * {
    color: #477FD6 !important;
}

.another_category_color_blue th a.current {
    border-color: #477FD6 !important;
}

.another_category_color_blue h4, .another_category_color_blue h4 a {
    color: #1960CA !important;
}

.another_category_color_violet, .another_category_color_violet h4 {
    border-color: #E1CEEC !important;
}

.another_category_color_violet * {
    color: #9D64C5 !important;
}

.another_category_color_violet th a.current {
    border-color: #9D64C5 !important;
}

.another_category_color_violet h4, .another_category_color_violet h4 a {
    color: #7E2CB5 !important;
}
</style>

                
                <link rel="stylesheet" type="text/css" href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/style/dialog.css"/>
<link rel="stylesheet" type="text/css" href="//t1.daumcdn.net/tistory_admin/www/style/top/font.css"/>
<link rel="stylesheet" type="text/css" href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/style/postBtn.css"/>
<link rel="stylesheet" type="text/css" href="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/style/tistory.css"/>
<link rel="canonical" href="https://malchafrappuccino.tistory.com/148"/>

<!-- BEGIN STRUCTURED_DATA -->
<script type="application/ld+json">
    {"@context":"http://schema.org","@type":"BlogPosting","mainEntityOfPage":{"@id":"https://malchafrappuccino.tistory.com/148","name":null},"url":"https://malchafrappuccino.tistory.com/148","headline":"[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정","description":"지난 글에서 UICollectionView Cell에 더티 플래그를 사용해 Constraints 업데이트 하는 횟수를 줄여주었다. [iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현 부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm malchafrappuccino.tistory.com 막상 적용하기는 했는데 성능이 얼마나 좋아졌는지 정량적으로 확인해보고 싶어 테스트를 진행했다. ..","author":{"@type":"Person","name":"말차프라푸치노","logo":null},"image":{"@type":"ImageObject","url":"https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png","width":"800px","height":"800px"},"datePublished":"20230127T23:37:34","dateModified":"20230128T14:20:12","publisher":{"@type":"Organization","name":"TISTORY","logo":{"@type":"ImageObject","url":"https://t1.daumcdn.net/tistory_admin/static/images/openGraph/opengraph.png","width":"800px","height":"800px"}}}
</script>
<!-- END STRUCTURED_DATA -->
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/common.js"></script>

                </head>

                                  <body id="tt-body-page" data-sidebar-default="1">
                
                
    
      <div id="__loader">
        <div class="la-ball-clip-rotate uk-position-center">
          <div></div>
        </div>
      </div>
    
    
      <div id="__tidory">
        <div id="sidebar__mask"></div>
        <aside id="__sidebar">
          <div id="sidebar__shadow">
            
                <!-- 프로필 -->
                <div id="sidebar__profile"><img class="thumbnail lazyload" data-src="https://t1.daumcdn.net/tistory_admin/static/manage/images/r3/default_L.png" data-sizes="auto" width="100" height="100" alt="말차프라푸치노">
                  <div class="title"><a href="https://malchafrappuccino.tistory.com/">말차맛 개발공부</a></div>
                  <div class="blogger">말차프라푸치노</div>
                </div>
              
                <!-- 방문자 수 -->
                <div id="sidebar__counter">
                  <div class="total">
                    <div class="cnt-item">
                      <div class="title">전체 방문자</div>
                      <div class="cnt">1,660</div>
                    </div>
                  </div>
                  <div class="day">
                    <div class="cnt-item">
                      <div class="title">오늘</div>
                      <div class="cnt">9</div>
                    </div>
                    <div class="cnt-item">
                      <div class="title">어제</div>
                      <div class="cnt">9</div>
                    </div>
                  </div>
                </div>
              
                <!-- 검색 -->
                <div id="sidebar__search">
                  
                    <div class="uk-search uk-search-default"><span uk-search-icon=""></span><label for="search">검색</label><input class="uk-search-input" id="search" type="search" name="search" value="" onkeypress="if (event.keyCode == 13) { try {
    window.location.href = '/search' + '/' + looseURIEncode(document.getElementsByName('search')[0].value);
    document.getElementsByName('search')[0].value = '';
    return false;
} catch (e) {} }"></div>
                  
                </div>
              
                <!-- 카테고리 -->
                <nav id="sidebar__category"><ul class="tt_category"><li class=""><a href="/category" class="link_tit"> 분류 전체보기 <span class="c_cnt">(146)</span> <img alt="N" src="https://tistory1.daumcdn.net/tistory_admin/blogs/image/category/new_ico_5.gif" style="vertical-align:middle;padding-left:2px;"/></a>
  <ul class="category_list"><li class=""><a href="/category/%EC%B1%85" class="link_item"> 책 <span class="c_cnt">(20)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/%EC%B1%85/%EA%B0%9C%EB%B0%9C" class="link_sub_item"> 개발 <span class="c_cnt">(9)</span> </a></li>
<li class=""><a href="/category/%EC%B1%85/UX" class="link_sub_item"> UX <span class="c_cnt">(3)</span> </a></li>
<li class=""><a href="/category/%EC%B1%85/%EC%8B%9C%EB%A6%AC%EC%A6%88" class="link_sub_item"> 시리즈 <span class="c_cnt">(7)</span> </a></li>
<li class=""><a href="/category/%EC%B1%85/%EA%B7%B8%20%EC%99%B8" class="link_sub_item"> 그 외 <span class="c_cnt">(1)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/%EC%9D%BC%EA%B8%B0" class="link_item"> 일기 <span class="c_cnt">(8)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/%EC%9D%BC%EA%B8%B0/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%20%ED%9B%84%EA%B8%B0" class="link_sub_item"> 프로젝트 후기 <span class="c_cnt">(1)</span> </a></li>
<li class=""><a href="/category/%EC%9D%BC%EA%B8%B0/%EC%A0%9C%ED%92%88%20%ED%9B%84%EA%B8%B0" class="link_sub_item"> 제품 후기 <span class="c_cnt">(2)</span> </a></li>
<li class=""><a href="/category/%EC%9D%BC%EA%B8%B0/%EB%B6%80%EC%8A%A4%ED%8A%B8%EC%BA%A0%ED%94%84" class="link_sub_item"> 부스트캠프 <span class="c_cnt">(5)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/%EB%B6%80%EC%8A%A4%ED%8A%B8%EC%BA%A0%ED%94%84" class="link_item"> 부스트캠프 <span class="c_cnt">(2)</span> <img alt="N" src="https://tistory1.daumcdn.net/tistory_admin/blogs/image/category/new_ico_5.gif" style="vertical-align:middle;padding-left:2px;"/></a></li>
<li class=""><a href="/category/Apple%20%EC%86%8C%EC%8B%9D" class="link_item"> Apple 소식 <span class="c_cnt">(4)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/Apple%20%EC%86%8C%EC%8B%9D/ios%20%EC%86%8C%EC%8B%9D" class="link_sub_item"> ios 소식 <span class="c_cnt">(1)</span> </a></li>
<li class=""><a href="/category/Apple%20%EC%86%8C%EC%8B%9D/Swift" class="link_sub_item"> Swift <span class="c_cnt">(1)</span> </a></li>
<li class=""><a href="/category/Apple%20%EC%86%8C%EC%8B%9D/%EC%A0%9C%ED%92%88%20%EC%86%8C%EC%8B%9D" class="link_sub_item"> 제품 소식 <span class="c_cnt">(1)</span> </a></li>
<li class=""><a href="/category/Apple%20%EC%86%8C%EC%8B%9D/WWDC" class="link_sub_item"> WWDC <span class="c_cnt">(1)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/%EC%BB%A8%ED%8D%BC%EB%9F%B0%EC%8A%A4" class="link_item"> 컨퍼런스 <span class="c_cnt">(1)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/%EC%BB%A8%ED%8D%BC%EB%9F%B0%EC%8A%A4/Toss" class="link_sub_item"> Toss <span class="c_cnt">(1)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/SwiftUI" class="link_item"> SwiftUI <span class="c_cnt">(13)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/SwiftUI/SwiftUI%20%EA%B3%B5%EB%B6%80" class="link_sub_item"> SwiftUI 공부 <span class="c_cnt">(1)</span> </a></li>
<li class=""><a href="/category/SwiftUI/SwiftUI%20%EC%95%B1%20%EB%A7%8C%EB%93%A4%EA%B8%B0" class="link_sub_item"> SwiftUI 앱 만들기 <span class="c_cnt">(12)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/Swift" class="link_item"> Swift <span class="c_cnt">(45)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/Swift/Swift%20%EA%B3%B5%EC%8B%9D%EB%AC%B8%EC%84%9C" class="link_sub_item"> Swift 공식문서 <span class="c_cnt">(28)</span> </a></li>
<li class=""><a href="/category/Swift/Design%20Pattern" class="link_sub_item"> Design Pattern <span class="c_cnt">(10)</span> </a></li>
<li class=""><a href="/category/Swift/Swift%20%EB%AC%B8%EB%B2%95" class="link_sub_item"> Swift 문법 <span class="c_cnt">(3)</span> </a></li>
<li class=""><a href="/category/Swift/Swift%20Concurrency" class="link_sub_item"> Swift Concurrency <span class="c_cnt">(2)</span> </a></li>
<li class=""><a href="/category/Swift/%EB%82%B4%EA%B0%80%20%EA%B6%81%EA%B8%88%ED%95%9C%20%EA%B1%B0" class="link_sub_item"> 내가 궁금한 거 <span class="c_cnt">(1)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/%EC%8B%A4%ED%97%98%EC%8B%A4" class="link_item"> 실험실 <span class="c_cnt">(1)</span> </a></li>
<li class=""><a href="/category/Git" class="link_item"> Git <span class="c_cnt">(1)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/Git/%EC%97%90%EB%9F%AC" class="link_sub_item"> 에러 <span class="c_cnt">(1)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/%EC%9B%B9%20%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D" class="link_item"> 웹 프로그래밍 <span class="c_cnt">(1)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/%EC%9B%B9%20%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/React" class="link_sub_item"> React <span class="c_cnt">(1)</span> </a></li>
</ul>
</li>
<li class=""><a href="/category/%EC%BD%94%EB%94%A9%20%ED%85%8C%EC%8A%A4%ED%8A%B8" class="link_item"> 코딩 테스트 <span class="c_cnt">(47)</span> </a>
  <ul class="sub_category_list"><li class=""><a href="/category/%EC%BD%94%EB%94%A9%20%ED%85%8C%EC%8A%A4%ED%8A%B8/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4" class="link_sub_item"> 프로그래머스 <span class="c_cnt">(47)</span> </a></li>
</ul>
</li>
</ul>
</li>
</ul>
</nav>
              
                <!-- 블로그 메뉴 -->
                <nav id="sidebar__blogmenu">
                  <h2>블로그 메뉴</h2><ul>
  <li class="t_menu_home first"><a href="/" target="">홈</a></li>
  <li class="t_menu_tag"><a href="/tag" target="">태그</a></li>
  <li class="t_menu_guestbook last"><a href="/guestbook" target="">방명록</a></li>
</ul>
                </nav>
              
                <!-- 공지사항 -->
                <div id="sidebar__notice"><a href="/notice">
                    <h2>공지사항</h2>
                  </a>
                  
                    <ul>
                      
                    </ul>
                  
                </div>
              
                <!-- 인기 글 -->
                <nav id="sidebar__popular-posts">
                  <h2>인기 글</h2>
                  <ul>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/146">[부스트캠프 7기 iOS] 부스트캠프를 끝 마치며...</a>
                          <div class="date">2022.12.24</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fodt1V%2FbtrUt8DP6bH%2FBIyRcfXepkYEkKPYcUwv8k%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[부스트캠프 7기 iOS] 부스트캠프를 끝 마치며...">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/134">[Slash 2022] 토스 온라인 개발자 컨퍼런스 후기</a>
                          <div class="date">2022.06.28</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FmNhcK%2FbtrFZFBmYJ3%2FfPuUIwLRJN4nyxRL4rLKf1%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[Slash 2022] 토스 온라인 개발자 컨퍼런스 후기">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/144">[실험실] - JPEG 압축률에 따른 품질 비교 (10% ⋯</a>
                          <div class="date">2022.09.25</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FKtM0R%2FbtrMU5ncI8F%2FsccQi3cK2Sy9jKBMeELSg0%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[실험실] - JPEG 압축률에 따른 품질 비교 (10% ⋯">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/126">[Swift] Foundation 에 대해 알아보기</a>
                          <div class="date">2022.04.18</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FrXQmd%2FbtrzJ2J6r6U%2FLsBrsQ5xHoysmkEAYyWZuK%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[Swift] Foundation 에 대해 알아보기">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/146">[부스트캠프 7기 iOS] 부스트캠프를 끝 마치며...</a>
                          <div class="date">2022.12.24</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fodt1V%2FbtrUt8DP6bH%2FBIyRcfXepkYEkKPYcUwv8k%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[부스트캠프 7기 iOS] 부스트캠프를 끝 마치며...">
                      </li>
                    
                  </ul>
                </nav>
              
                <!-- 태그 -->
                <div id="sidebar__tags"><a href="/tag">
                    <h2>태그</h2>
                  </a>
                  <ul>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EC%B1%85%EB%A6%AC%EB%B7%B0">책리뷰</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EB%B6%80%EC%8A%A4%ED%8A%B8%EC%BA%A0%ED%94%84iOS">부스트캠프iOS</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EB%94%94%EC%9E%90%EC%9D%B8%20%ED%8C%A8%ED%84%B4">디자인 패턴</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/Swift%EB%AC%B8%EB%B2%95">Swift문법</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/Swift%EA%B3%B5%EC%8B%9D%EB%AC%B8%EC%84%9C">Swift공식문서</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EC%BD%94%EB%94%A9">코딩</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EC%95%B1%EA%B0%9C%EB%B0%9C">앱개발</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EC%BD%94%EB%94%A9%ED%85%8C%EC%8A%A4%ED%8A%B8">코딩테스트</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EC%B1%85">책</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/Swift%20%EB%94%94%EC%9E%90%EC%9D%B8%20%ED%8C%A8%ED%84%B4">Swift 디자인 패턴</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EB%82%A0%EC%94%A8%EC%96%B4%ED%94%8C">날씨어플</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud3" href="/tag/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4">프로그래머스</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/SwiftUI">SwiftUI</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%ED%95%84%EB%8F%85%EC%84%9C">필독서</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/TODO">TODO</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EB%B6%80%EC%8A%A4%ED%8A%B8%EC%BA%A0%ED%94%84">부스트캠프</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud1" href="/tag/Swift">Swift</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EC%BD%94%EB%94%A9%20%ED%85%8C%EC%8A%A4%ED%8A%B8">코딩 테스트</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/ios">ios</a></li>
                    
                      <li><i class="fa fa-hashtag" aria-hidden="true"></i><a class="cloud4" href="/tag/%EA%B0%9C%EB%B0%9C">개발</a></li>
                    
                  </ul>
                </div>
              
                <!-- 최근 댓글 -->
                <div id="sidebar__recent-comments">
                  <h2>최근 댓글</h2>
                  <ul>
                    
                      <li><a href="/146#comment13437904">암살 사진 ㅋㅋㅋㅋㅋㅋ</a>
                        <div class="metainfo">
                          <div class="author">느리님</div>
                        </div>
                      </li>
                    
                      <li><a href="/146#comment13436828">항상 잘 보고 있습니다 좋은 하루 되세요 :)</a>
                        <div class="metainfo">
                          <div class="author">alpha-traveler</div>
                        </div>
                      </li>
                    
                      <li><a href="/144#comment13329575">글 솜씨가 뛰어나시네요! 좋은 글 잘 보고 갑니다 다음에도⋯</a>
                        <div class="metainfo">
                          <div class="author">alpha-traveler</div>
                        </div>
                      </li>
                    
                      <li><a href="/127#comment13199399">앱 삭제 정책은 동의하는데 30일은 좀 짧은 것 같습니다</a>
                        <div class="metainfo">
                          <div class="author">Seunghwan 'the Appstore User' Jeong</div>
                        </div>
                      </li>
                    
                      <li><a href="/104#comment13199396">좋은 정보 감사합니다😎</a>
                        <div class="metainfo">
                          <div class="author">Seunghwan 'the Code Artist' Jeong</div>
                        </div>
                      </li>
                    
                  </ul>
                </div>
              
                <!-- 최근 글 -->
                <nav id="sidebar__recent-posts">
                  <h2>최근 글</h2>
                  <ul>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/148">[iOS] UICollectionViewCell에 더티 플⋯</a>
                          <div class="date">2023.01.27</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[iOS] UICollectionViewCell에 더티 플⋯">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/147">[iOS] UICollectionViewCell에 더티 플⋯</a>
                          <div class="date">2023.01.27</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FDInvn%2FbtrXkXs0rKd%2FsQWIEXK38VfeRP3IE0Pdl1%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[iOS] UICollectionViewCell에 더티 플⋯">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/146">[부스트캠프 7기 iOS] 부스트캠프를 끝 마치며...</a>
                          <div class="date">2022.12.24</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fodt1V%2FbtrUt8DP6bH%2FBIyRcfXepkYEkKPYcUwv8k%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[부스트캠프 7기 iOS] 부스트캠프를 끝 마치며...">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/145">[iOS] burstcamp - cellViewModel ⋯</a>
                          <div class="date">2022.12.05</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FYaiDj%2FbtrSJYJlddO%2F5MpxHku0OAHFaacxp2gvK0%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[iOS] burstcamp - cellViewModel ⋯">
                      </li>
                    
                      <li>
                        <div class="metainfo"><a class="title" href="/144">[실험실] - JPEG 압축률에 따른 품질 비교 (10% ⋯</a>
                          <div class="date">2022.09.25</div>
                        </div>
                        <img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FKtM0R%2FbtrMU5ncI8F%2FsccQi3cK2Sy9jKBMeELSg0%2Fimg.png" data-sizes="auto" width="60" height="45" alt="[실험실] - JPEG 압축률에 따른 품질 비교 (10% ⋯">
                      </li>
                    
                  </ul>
                </nav>
              
                <!-- 티스토리 -->
                <div id="sidebar__tistory">
                  <h2>티스토리</h2>
                </div>
              
          </div>
        </aside>
        <nav class="uk-navbar-container uk-navbar-transparent" id="__nav" uk-sticky="top: 280; animation: uk-animation-slide-top; cls-active: sticky; cls-inactive: uk-navbar-transparent;" uk-navbar="">
          <div class="uk-navbar-left" id="nav__s1"><img class="profile lazyload" data-src="https://t1.daumcdn.net/tistory_admin/static/manage/images/r3/default_L.png" data-sizes="auto" alt="말차프라푸치노" width="40" height="40"></div>
          <div class="uk-navbar-center" id="nav__metainfo">
            <h1 class="title">말차맛 개발공부</h1>
          </div>
          <div class="uk-navbar-right" id="nav__s2"></div>
        </nav>
        <main id="__main">
          <div id="main__content">
            
            
                
        
  
    <div id="__permalink_article">
      <div class="article content__permalink" data-mode="default">
        <header class="header">
          
            <div class="img">
              <div class="mask"></div><img class="thumbnail lazyload" data-src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png" data-sizes="auto" alt="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정">
            </div>
          
          <div class="heading"><a class="category" href="/category">카테고리 없음</a>
            <h1 class="title">[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정</h1>
            <div class="metainfo"><time class="date">2023. 1. 27. 23:37</time><span class="permalink__admin">
                <span class="update"><a href="https://malchafrappuccino.tistory.com/manage/post/148?returnURL=https://malchafrappuccino.tistory.com/148">수정</a></span><span class="delete"><a href="#" onclick="deleteEntry(148); return false;">삭제</a></span><span class="state"><a href="#" onclick="changeVisibility(148, 0); return false;">공개</a></span>
              </span></div>
          </div>
        </header>
        <article class="content">            <!-- System - START -->

<!-- System - END -->

            <div class="tt_article_useless_p_margin contents_style"><p data-ke-size="size16">지난 글에서 UICollectionView Cell에 더티 플래그를 사용해 Constraints 업데이트 하는 횟수를 줄여주었다.</p>
<figure id="og_1674830291999" contenteditable="false" data-ke-type="opengraph" data-ke-align="alignCenter" data-og-type="article" data-og-title="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현" data-og-description="부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm" data-og-host="malchafrappuccino.tistory.com" data-og-source-url="https://malchafrappuccino.tistory.com/147" data-og-url="https://malchafrappuccino.tistory.com/147" data-og-image="https://scrap.kakaocdn.net/dn/beOQm9/hyRpHVCwQW/mNNQecRZCMlwXSl5cKXbL1/img.png?width=600&amp;height=600&amp;face=0_0_600_600,https://scrap.kakaocdn.net/dn/cQ4Nlr/hyRpNIikM5/WKkjT7R97ekoB8uKYi1ASK/img.png?width=600&amp;height=600&amp;face=0_0_600_600,https://scrap.kakaocdn.net/dn/vNaGe/hyRpJy9oY3/aPgJ4kEk3dlZc3TLplEjAK/img.png?width=1780&amp;height=292&amp;face=0_0_1780_292"><a href="https://malchafrappuccino.tistory.com/147" target="_blank" rel="noopener" data-source-url="https://malchafrappuccino.tistory.com/147">
<div class="og-image" style="background-image: url('https://scrap.kakaocdn.net/dn/beOQm9/hyRpHVCwQW/mNNQecRZCMlwXSl5cKXbL1/img.png?width=600&amp;height=600&amp;face=0_0_600_600,https://scrap.kakaocdn.net/dn/cQ4Nlr/hyRpNIikM5/WKkjT7R97ekoB8uKYi1ASK/img.png?width=600&amp;height=600&amp;face=0_0_600_600,https://scrap.kakaocdn.net/dn/vNaGe/hyRpJy9oY3/aPgJ4kEk3dlZc3TLplEjAK/img.png?width=1780&amp;height=292&amp;face=0_0_1780_292');">&nbsp;</div>
<div class="og-text">
<p class="og-title" data-ke-size="size16">[iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현</p>
<p class="og-desc" data-ke-size="size16">부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm</p>
<p class="og-host" data-ke-size="size16">malchafrappuccino.tistory.com</p>
</div>
</a></figure>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">막상 적용하기는 했는데 성능이 얼마나 좋아졌는지 정량적으로 확인해보고 싶어 테스트를 진행했다.</p>
<p data-ke-size="size16">&nbsp;</p>
<ul style="list-style-type: disc;" data-ke-list-type="disc">
<li>피드를 1000개 생성한다.</li>
<li>기존에 Constraints를 업데이트 안 할 때랑 CPU 사용량을 비교한다.</li>
<li>피드 리스트에서 이미지가 있는 피드 : 이미지가 없는 피드의 비율을 조정해가며 확인해본다.</li>
</ul>
<p data-ke-size="size16">&nbsp;</p>
<h2 data-ke-size="size16"><b>테스트를 위한 목업 데이터 만들기</b></h2>
<p data-ke-size="size16">테스트를 위한 목업 피드가 필요했다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">목업 피드를 생성하는 구조체를 만들어주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<pre id="code_1674823276408" class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>struct MockUpFeedData {

// 썸네일 이미지가 있는 피드
    func createMockUpFeed() -&gt; Feed {
        return Feed(
            feedUUID: UUID().uuidString,
            writer: createMockUpFeedWriter(),
            title: "이미지가 있는 피드입니다. 이미지가 있는 피드입니다. 이미지가 있는 피드입니다. 이미지가 있는 피드입니다.",
            pubDate: Date(),
            url: "",
            thumbnailURL: "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&amp;fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fodt1V%2FbtrUt8DP6bH%2FBIyRcfXepkYEkKPYcUwv8k%2Fimg.png",
            content: content(),
            scrapCount: Int.random(in: 0...50),
            isScraped: false
        )
    }
  
  // 썸네일 이미지가 없는 피드
      func createMockUpFeedWithoutThumbnailImage() -&gt; Feed {
        return Feed(
            feedUUID: UUID().uuidString,
            writer: createMockUpFeedWriter(),
            title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            pubDate: Date(),
            url: "",
            thumbnailURL: "",
            content: content(),
            scrapCount: Int.random(in: 0...50),
            isScraped: false
        )
    }
  	
	private func createMockUpFeedWriter() -&gt; FeedWriter {
	// 피드 작성자 생성
	// 길어서 생략
	}
  
	private func content() -&gt; String {
	// 피드 컨텐츠 생성
	// 길어서 생략
	}
 }</code></pre>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">Diffable DataSource를 사용해서 모든 Feed가 Hashable 해야하므로, FeedUUID에 UUID 값을 넣어주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">혹시 constraints 설정이 잘못됐으면 확인하려고 <span style="color: #ee2323;">이미지 유무에 따라 제목을 다르게</span> 해주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">현재 앱에서는 클린 아키텍처를 사용하고 있다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">FirebaseService -&gt; FeedRepository를 거쳐 UseCase로 피드 데이터를 전달한다.</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="mockUp 도식.png" data-origin-width="1328" data-origin-height="492"><span data-url="https://blog.kakaocdn.net/dn/bYO62T/btrXo4DKPLu/RsXMSGKZuMjSIbkZZJR6Jk/img.png" data-lightbox="lightbox" data-alt="간략히 보는 burstcamp 아키텍처"><img src="https://blog.kakaocdn.net/dn/bYO62T/btrXo4DKPLu/RsXMSGKZuMjSIbkZZJR6Jk/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbYO62T%2FbtrXo4DKPLu%2FRsXMSGKZuMjSIbkZZJR6Jk%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-filename="mockUp 도식.png" data-origin-width="1328" data-origin-height="492"/></span><figcaption>간략히 보는 burstcamp 아키텍처</figcaption>
</figure>
</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">MockUpFeed를 만들기 위해 FeedRepository를 채택하는 새로운 <span style="color: #ef5369;">MockUpFeedRepository</span> 클래스를 만들어주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<pre id="code_1674823146267" class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>final class MockUpFeedRepository: FeedRepository {

    let mockUpFeedData = MockUpFeedData()

    func fetchRecentHomeFeedList() async throws -&gt; HomeFeedList {
        let mockUpNormalFeedList = createMockUpNormalFeedList(imageFeedCount: 500, noImageFeedCount: 500)
        return HomeFeedList(recommendFeed: [], normalFeed: mockUpNormalFeedList)
    }

    private func createMockUpNormalFeedList(imageFeedCount: Int, noImageFeedCount: Int) -&gt; [Feed] {
        var result: [Feed] = []
        for _ in 1...imageFeedCount {
            result.append(mockUpFeedData.createMockUpFeed())
        }
        for _ in 1...noImageFeedCount {
            result.append(mockUpFeedData.createMockUpFeedWithoutThumbnailImage())
        }
        return result.shuffled()
    }
    
    // 프로토콜에 대한 나머지 구현은 현재 사용하지 않기 때문에 에러를 throw해주었다.
        func fetchMoreNormalFeed() async throws -&gt; [Feed] {
        throw MockUpFeedRepositoryError.noImplementation
    }
    // ...
}</code></pre>
<p data-ke-size="size16"><span style="color: #009a87;">썸네일 이미지가 있는 피드</span>와 <span style="color: #009a87;">썸네일 이미지가 없는 피드</span>를 500개씩 만들고 섞어주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">함수 인자를 바꿔가며 피드 비율을 조절해주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h2 data-ke-size="size16"><b>피드 케이스 설정하기</b></h2>
<p data-ke-size="size16">테스트 케이스를 4가지 정도 설정해주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size23"><b>1. 100 : 0</b></h3>
<p data-ke-size="size16">전부 다 이미지가 있는 피드라 업데이트가 발생하지 않음</p>
<p data-ke-size="size16">다른 테스트 케이스와 비교를 위한 기본 테스트</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size20"><b>2. 50 : 50</b></h3>
<p data-ke-size="size16">가장 기본적인 반반 테스트</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size23"><b>3. 80 : 20</b></h3>
<p data-ke-size="size16">운영체제의 교체 정책을 공부하다 보면&nbsp; <span style="color: #009a87;"><b>80 대 20 워크로드</b></span>가 있다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">20%의 페이지(인기 있는 페이지)들에서&nbsp; 80%의 참조가 발생하고 나머지 80%의 페이지<span>(비인기 페이지)<span>&nbsp;</span></span>들에 대해서 20%의 참조만 발생한다는 것이다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">비단 운영체제뿐 만아니라 경제학에서도 사용되는 개념으로 더 자세한 건 <span style="color: #009a87;"><b>파레토 법칙</b></span>을 검색해보면 된다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">썸네일 이미지가 있는 블로그가 대부분이므로 80%라 가정하고 테스트를 했다.</p>
<p data-ke-size="size16"><span style="font-family: -apple-system, BlinkMacSystemFont, 'Helvetica Neue', 'Apple SD Gothic Neo', Arial, sans-serif; letter-spacing: 0px;">&nbsp;</span></p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size16"><b>4. 95 : 5</b></h3>
<p data-ke-size="size16">썸네일 이미지가 있는 블로그가 극단적으로 많다고 생각하고 테스트를 했다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h2 data-ke-size="size26"><b>Instruments 사용하기</b></h2>
<p data-ke-size="size16">Instruments - Time Profiler를 사용해 CPU 사용량을 확인할 수 있다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="스크린샷 2023-01-27 오후 9.27.55.png" data-origin-width="836" data-origin-height="521"><span data-url="https://blog.kakaocdn.net/dn/brsDys/btrXn5XqKw0/oTX6mFQY8glxGekgQKCRM0/img.png" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/brsDys/btrXn5XqKw0/oTX6mFQY8glxGekgQKCRM0/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbrsDys%2FbtrXn5XqKw0%2FoTX6mFQY8glxGekgQKCRM0%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" width="603" height="376" data-filename="스크린샷 2023-01-27 오후 9.27.55.png" data-origin-width="836" data-origin-height="521"/></span></figure>
</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size23"><b>테스트 환경</b></h3>
<ul style="list-style-type: disc;" data-ke-list-type="disc">
<li>14인 맥북 프로 M1 Pro 8코어 &amp; 14코어 GPU, 512GB, 16GB (14인치 깡통 맥북 프로 M1)</li>
<li>Ventura 13.0</li>
<li>시뮬레이터 iphone 14 pro max - iOS 16.2</li>
<li>맥북 충전하면서 실행</li>
<li>Instreuments 버전 14.1</li>
</ul>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size23"><b>테스트 내용</b></h3>
<p data-ke-size="size16">30초 동안 스크롤하면서 Constraints 업데이트에 따른 CPU 사용량 확인하기</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size16"><b>결과</b></h3>
<p data-ke-size="size16">결과를 확인하기 앞서 Instruments 사용이 처음이라 테스트 케이스에 대해 비교하는 방법을 못 찾았다 🫠</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">피그마로 옮겨 직접 비교했다.</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="Instruments 비교.png" data-origin-width="604" data-origin-height="245"><span data-url="https://blog.kakaocdn.net/dn/bxVcOY/btrXo4X4v5A/HNeuTZtxN62uBwHoBh8Ms0/img.png" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/bxVcOY/btrXo4X4v5A/HNeuTZtxN62uBwHoBh8Ms0/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbxVcOY%2FbtrXo4X4v5A%2FHNeuTZtxN62uBwHoBh8Ms0%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-filename="Instruments 비교.png" data-origin-width="604" data-origin-height="245"/></span></figure>
</p>
<p data-ke-size="size16">결과는 그림과 같았다.</p>
<p data-ke-size="size16">차이가 보이는가???</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">50 : 50 과 80: 20을 비교해보면 확실히 80: 20이 CPU 사용량이 적어보인다.</p>
<p data-ke-size="size16">But, 가장 업데이트가 적은 95 : 5가 CPU 사용량이 많아 보인다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">그렇다. <b><span style="color: #ee2323;">정확</span><span style="color: #ee2323;">한 비교가 불가능</span></b>하다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-origin-width="500" data-origin-height="281"><span data-url="https://blog.kakaocdn.net/dn/bqxMse/btrXo6avGmU/XdKvre9kPuCEbfND6NbyRK/img.gif" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/bqxMse/btrXo6avGmU/XdKvre9kPuCEbfND6NbyRK/img.gif" srcset="https://blog.kakaocdn.net/dn/bqxMse/btrXo6avGmU/XdKvre9kPuCEbfND6NbyRK/img.gif" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-origin-width="500" data-origin-height="281"/></span></figure>
</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16"><span style="color: #ee2323;">시뮬레이터에서 스크롤을 내가 직접했기 때문</span></p>
<p data-ke-size="size16">각 테스트 마다 스크롤 속도가 달라서 요청하는 연산량이 달랐고 정확한 비교가 불가능했다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">Instrument 어렵다....</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16"><b>+ Hang</b></p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="스크린샷 2023-01-27 오후 10.17.11.png" data-origin-width="123" data-origin-height="66"><span data-url="https://blog.kakaocdn.net/dn/bV4hgP/btrXnLdP9op/aTg85gnS3O2uWUTK99JWq1/img.png" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/bV4hgP/btrXnLdP9op/aTg85gnS3O2uWUTK99JWq1/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbV4hgP%2FbtrXnLdP9op%2FaTg85gnS3O2uWUTK99JWq1%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" width="326" height="175" data-filename="스크린샷 2023-01-27 오후 10.17.11.png" data-origin-width="123" data-origin-height="66"/></span></figure>
</p>
<p data-ke-size="size16"><span>Instruments에 Hangs이라는 것 있다.</span></p>
<p data-ke-size="size16"><span>Hang은<span>&nbsp;</span></span><span style="color: #ee2323;">아무런 반응을 하지 않은 상태로써 시스템&nbsp;운영이 불가능한 상태</span>를 의미한다.&nbsp;</p>
<p data-ke-size="size16">목업 데이터 1000개를 한 번에 생성하다 보니 시작시 순간적으로 시뮬레이터가 멈췄다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h2 data-ke-size="size16"><b>Update 수 측정하기</b></h2>
<p data-ke-size="size16">성능 측정을 위한 다른 방법을 고민했다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">가장 쉽고 좋은 방법이 있었다. 바로 <span style="color: #ee2323;"><b>contraints가 업데이트 되는 수를 측정하는 것</b></span>이다!</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">더티 플래그가 없었을 때, Cell이 1000개 있다면 1000번의 업데이트가 이루어졌다.</p>
<p data-ke-size="size16">더티 플래그가 있다면 호출 수가 얼마나 줄지 확인해보았다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">앞선 테스트 케이스와 마찬가지로 1000개의 셀에 대해 50 : 50, 80 : 20, 95 : 5 비율로 비교를 해봤다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size16"><b>Counter 만들기</b></h3>
<p data-ke-size="size16">가볍게 counter를 하나 만들어주었다.</p>
<pre id="code_1674826423385" class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>struct TestCounter {
    static var count = 0

    static func up() {
        count += 1
        print("Constraints 업데이트 수 : ", count)
    }
}</code></pre>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">업데이트 될 때마다 count를 up하고 출력해주었다.</p>
<pre id="code_1674826448439" class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>    private func setThumbnailImage(urlString: String) {
        if hasThumbnailImage &amp;&amp; !newFeedHaveImage(urlString) {
            updateEmptyImageView()
            updateTitleLabelWithEmptyImageView()
            hasThumbnailImage = false
            TestCounter.up()
        } else if !hasThumbnailImage &amp;&amp; newFeedHaveImage(urlString) {
            updateThumbnailImageView()
            updateTitleLabel()
            self.thumbnailImageView.setImage(urlString: urlString)
            hasThumbnailImage = true
            TestCounter.up()
        }
    }</code></pre>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size16"><b>개발자답게 확인하기</b></h3>
<p data-ke-size="size16">개발자는 어떤 사람인가....</p>
<p data-ke-size="size16">사람이 할 일을 컴퓨터가 하도록 만드는 사람이다.....</p>
<p data-ke-size="size16">1000개의 Cell을 그냥 스크롤 하는 것이 아닌 자동화하는게 진짜 개발자 아니겠는가...</p>
<p data-ke-size="size16">라는 생각을 가지고 머리를 굴려봤다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">현재 앱에서 네비게이션바를 누르면 스크롤 최상단으로 온다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">이걸 조금 수정해서 네비게이션바를 누르면 collectionView 최하단으로 이동시켜 주었다.</p>
<pre id="code_1674826542546" class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>private func configureNavigationBar() {
	navigationController?.navigationBar.topItem?.title = "홈"
	let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollToBottom))
	navigationController?.navigationBar.addGestureRecognizer(tapGesture)
}
    
@objc private func scrollToBottom() {
	homeView.collectionView.scrollToItem(at: IndexPath(item: 999, section: 1), at: .bottom, animated: true)
}</code></pre>
<p data-ke-size="size16">현재 앱에 2개의 섹션(추천 피드 섹션, 일반 피드 섹션)과 1000개의 일반 피드가 있다.</p>
<p data-ke-size="size16">1000 - 1 = 999 번째로 이동해주었다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="scroll to bottom.gif" data-origin-width="808" data-origin-height="880"><span data-url="https://blog.kakaocdn.net/dn/b7f192/btrXm7aGXuG/QgG4n5QQBR5lP41X6TKTd0/img.gif" data-lightbox="lightbox" data-alt="이동 영상"><img src="https://blog.kakaocdn.net/dn/b7f192/btrXm7aGXuG/QgG4n5QQBR5lP41X6TKTd0/img.gif" srcset="https://blog.kakaocdn.net/dn/b7f192/btrXm7aGXuG/QgG4n5QQBR5lP41X6TKTd0/img.gif" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" width="399" height="435" data-filename="scroll to bottom.gif" data-origin-width="808" data-origin-height="880"/></span><figcaption>이동 영상</figcaption>
</figure>
</p>
<p data-ke-size="size16">근데 뭔가 이상했다.&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">업데이트 된 수가 계속 50 언저리로만 나왔다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">최악의 경우를 생각하면 O(2n)이라 1000이 나올 수도 있는데 50이 나오는 건 말이 안됐다.</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-origin-width="500" data-origin-height="281"><span data-url="https://blog.kakaocdn.net/dn/bqxMse/btrXo6avGmU/XdKvre9kPuCEbfND6NbyRK/img.gif" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/bqxMse/btrXo6avGmU/XdKvre9kPuCEbfND6NbyRK/img.gif" srcset="https://blog.kakaocdn.net/dn/bqxMse/btrXo6avGmU/XdKvre9kPuCEbfND6NbyRK/img.gif" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-origin-width="500" data-origin-height="281"/></span></figure>
</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">scrollToItem() 을 정확히 알기 위해 공식 문서로 갔다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="스크린샷 2023-01-27 오후 10.48.48.png" data-origin-width="761" data-origin-height="225"><span data-url="https://blog.kakaocdn.net/dn/bLIt7I/btrXnKTxlVR/xcRSnEnnegq3Nxk7LBNl2K/img.png" data-lightbox="lightbox" data-alt="https://developer.apple.com/documentation/uikit/uicollectionview/1618046-scrolltoitem"><img src="https://blog.kakaocdn.net/dn/bLIt7I/btrXnKTxlVR/xcRSnEnnegq3Nxk7LBNl2K/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbLIt7I%2FbtrXnKTxlVR%2FxcRSnEnnegq3Nxk7LBNl2K%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-filename="스크린샷 2023-01-27 오후 10.48.48.png" data-origin-width="761" data-origin-height="225"/></span><figcaption>https://developer.apple.com/documentation/uikit/uicollectionview/1618046-scrolltoitem</figcaption>
</figure>
</p>
<p data-ke-size="size16">설명이 한 줄이 끝이다. 스크롤 한다고만 돼있다.&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">아무튼 중간을 거치지 않는다. 그렇다면 뭐다???</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h3 data-ke-size="size23"><b>직접 스크롤 하기</b></h3>
<p data-ke-size="size16">훌륭한 개발자가 되었다는 자아도취에서 빠져나와 원래로 돌아왔다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">머리가 나쁘면 뭐다?</p>
<figure id="og_1674826208249" contenteditable="false" data-ke-type="video" data-ke-mobilestyle="widthContent" data-ke-style="alignCenter" data-video-host="youtube" data-video-url="https://www.youtube.com/shorts/B059XUFM6D0" data-video-thumbnail="https://scrap.kakaocdn.net/dn/csCH76/hyRpItpZYg/cUQWpVW3rvqoRwQceNcPA0/img.jpg?width=480&amp;height=360&amp;face=0_0_480_360,https://scrap.kakaocdn.net/dn/uInGX/hyRpPsxfvr/FvDBlgx3T8jhP3n6PwgEt0/img.jpg?width=480&amp;height=360&amp;face=0_0_480_360" data-source-url="https://www.youtube.com/shorts/B059XUFM6D0" data-video-width="480" data-video-height="360" data-video-origin-width="480" data-video-origin-height="360" data-video-title="더티 플래그 적용에 따른 Constraints 업데이트 수 확인">
<div class="video_content"><img src="https://scrap.kakaocdn.net/dn/csCH76/hyRpItpZYg/cUQWpVW3rvqoRwQceNcPA0/img.jpg?width=480&amp;height=360&amp;face=0_0_480_360,https://scrap.kakaocdn.net/dn/uInGX/hyRpPsxfvr/FvDBlgx3T8jhP3n6PwgEt0/img.jpg?width=480&amp;height=360&amp;face=0_0_480_360" width="480" height="360" />
<div class="video_title">&nbsp;</div>
</div>
<figcaption contenteditable="true">직접 스크롤한 영상</figcaption>
</figure>
<p data-ke-size="size16">3개의 테스트 케이스에 대해 10번씩, 30 * 1000 = 30000개의 Cell을 직접 스크롤 했다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-origin-width="540" data-origin-height="303"><span data-url="https://blog.kakaocdn.net/dn/c97zNW/btrXn8s8Qtq/DJkccMyTRkW3e2bqYY2THK/img.gif" data-lightbox="lightbox" data-alt="현재 내 손"><img src="https://blog.kakaocdn.net/dn/c97zNW/btrXn8s8Qtq/DJkccMyTRkW3e2bqYY2THK/img.gif" srcset="https://blog.kakaocdn.net/dn/c97zNW/btrXn8s8Qtq/DJkccMyTRkW3e2bqYY2THK/img.gif" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-origin-width="540" data-origin-height="303"/></span><figcaption>현재 내 손</figcaption>
</figure>
</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<h2 data-ke-size="size16"><b>결과</b></h2>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="edited_호출 횟수 비교.jpeg" data-origin-width="1920" data-origin-height="1080"><span data-url="https://blog.kakaocdn.net/dn/oqYVV/btrXnjhFhpl/dqC2wySpIsli1wCK19Gob0/img.png" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/oqYVV/btrXnjhFhpl/dqC2wySpIsli1wCK19Gob0/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FoqYVV%2FbtrXnjhFhpl%2FdqC2wySpIsli1wCK19Gob0%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" data-filename="edited_호출 횟수 비교.jpeg" data-origin-width="1920" data-origin-height="1080"/></span></figure>
</p>
<p data-ke-size="size16">Constraints 업데이트 횟수가 50% ~ 90% 줄어든 것을 확인했다. 하지만 이건 피드 비율에 따라서 달라질 수 있는 수치이다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">조금 더 알고리즘적으로 생각해보자.</p>
<ul style="list-style-type: disc;" data-ke-list-type="disc">
<li>m : 썸네일 이미지가 있는 피드 개수</li>
<li>n : 썸네일 이미지가 없는 피드 개수</li>
</ul>
<p data-ke-size="size16">최악의 경우는 더티 플래그 히트 없이 모든 셀이 업데이트 되는 경우이다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">O(2n) 일 것이다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">하지만 통계적으로 대부분의 블로그에는 썸네일 이미지가 있다. 그렇다면 m &gt;&gt; n 일 것이고 0 에 수렴할 것이다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="O그래프.png" data-origin-width="744" data-origin-height="545"><span data-url="https://blog.kakaocdn.net/dn/bBp1am/btrXooiedw5/n9ahcNaJ6k5eGk3AivgkvK/img.png" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/bBp1am/btrXooiedw5/n9ahcNaJ6k5eGk3AivgkvK/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" width="455" height="333" data-filename="O그래프.png" data-origin-width="744" data-origin-height="545"/></span></figure>
</p>
<p data-ke-size="size16">그래프로 보면 다음과 같다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">블로그의 경우 대부분 썸네일 이미지가 있으므로 100:0에 가까워질 것이다.</p>
<p data-ke-size="size16">전체 피드 N이 커짐에 따라 Update 되는 횟수가 거의 0에 근접할 것이다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">현재 테스트 DB에는 팀원 3명의 피드 32개가 있다.</p>
<p data-ke-size="size16">썸네일 이미지가 있는 피드가 20개, 없는 피드가 12개이다.</p>
<p><figure class="imageblock alignCenter" data-ke-mobileStyle="widthOrigin" data-filename="수식.png" data-origin-width="626" data-origin-height="78"><span data-url="https://blog.kakaocdn.net/dn/XRuKa/btrXn6vmx1K/YwuzqVdnhOAxbL8OUooZaK/img.png" data-lightbox="lightbox"><img src="https://blog.kakaocdn.net/dn/XRuKa/btrXn6vmx1K/YwuzqVdnhOAxbL8OUooZaK/img.png" srcset="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FXRuKa%2FbtrXn6vmx1K%2FYwuzqVdnhOAxbL8OUooZaK%2Fimg.png" onerror="this.onerror=null; this.src='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png'; this.srcset='//t1.daumcdn.net/tistory_admin/static/images/no-image-v1.png';" width="498" height="62" data-filename="수식.png" data-origin-width="626" data-origin-height="78"/></span></figure>
</p>
<p data-ke-size="size16">현재 기준 Constraints를 업데이트하는 횟수를 최소 25% 줄였다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">나중에 앱 출시하고 DB에 데이터가 쌓이면 얼마나 줄었는지 더 확인해봐야겠다.</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p style="text-align: center;" data-ke-size="size16">UICollectionView에 더티플래그 사용하기</p>
<p style="text-align: center;" data-ke-size="size16">&nbsp;</p>
<p style="text-align: center;" data-ke-size="size16">끝</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16">&nbsp;</p></div>
            <!-- System - START -->

<!-- System - END -->

                    <div class="container_postbtn #post_button_group">
  <div class="postbtn_like"><script>window.ReactionButtonType = 'reaction';
window.ReactionApiUrl = '//malchafrappuccino.tistory.com/reaction';
window.ReactionReqBody = {
    entryId: 148
}</script>
<div class="wrap_btn" id="reaction-148"></div>
<script src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/reaction-button-container.min.js"></script><div class="wrap_btn wrap_btn_share"><button type="button" class="btn_post sns_btn btn_share" aria-expanded="false" data-thumbnail-url="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&amp;fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbBp1am%2FbtrXooiedw5%2Fn9ahcNaJ6k5eGk3AivgkvK%2Fimg.png" data-title="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (2/2) - 성능 측정" data-description="지난 글에서 UICollectionView Cell에 더티 플래그를 사용해 Constraints 업데이트 하는 횟수를 줄여주었다. [iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현 부스트캠프 7기 - burstcamp 개발 과정을 공유하는 포스트입니다. GitHub - boostcampwm-2022/iOS09-burstcamp: iOS 얼죽아 burstcamp 입니다 ^^ iOS 얼죽아 burstcamp 입니다 ^^. Contribute to boostcampwm-2022/iOS09-burstcamp developm malchafrappuccino.tistory.com 막상 적용하기는 했는데 성능이 얼마나 좋아졌는지 정량적으로 확인해보고 싶어 테스트를 진행했다. .." data-profile-image="https://t1.daumcdn.net/tistory_admin/static/manage/images/r3/default_L.png" data-profile-name="말차프라푸치노" data-pc-url="https://malchafrappuccino.tistory.com/148" data-relative-pc-url="/148" data-blog-title="말차맛 개발공부"><span class="ico_postbtn ico_share">공유하기</span></button>
  <div class="layer_post" id="tistorySnsLayer"></div>
</div><div class="wrap_btn"><button type="button" class="btn_post" data-entry-id="148"><span class="ico_postbtn ico_statistics">통계</span></button></div><div class="wrap_btn wrap_btn_etc" data-entry-id="148" data-entry-visibility="public" data-category-visibility="public"><button type="button" class="btn_post btn_etc1" aria-expanded="false"><span class="ico_postbtn ico_etc">게시글 관리</span></button>
  <div class="layer_post" id="tistoryEtcLayer"></div>
</div></div>
</div>

                    <!-- PostListinCategory - START -->

<!-- PostListinCategory - END -->

            <div id="__spy">
              <div id="spy__shadow" uk-sticky="offset: 65">
                <ul class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; offset: 65"></ul>
              </div>
            </div>
          
        </article>
        <footer class="footer">
          
            
          
          
            <div class="permalink__tags"><a href="/tag/Dirty%20Flag" rel="tag">Dirty Flag</a>, <a href="/tag/instruments" rel="tag">instruments</a>, <a href="/tag/uicollectionview" rel="tag">uicollectionview</a>, <a href="/tag/updateConstraints" rel="tag">updateConstraints</a>, <a href="/tag/%EB%8D%94%ED%8B%B0%20%ED%94%8C%EB%9E%98%EA%B7%B8" rel="tag">더티 플래그</a>, <a href="/tag/%EC%BB%AC%EB%A0%89%EC%85%98%EB%B7%B0" rel="tag">컬렉션뷰</a>, <a href="/tag/%ED%85%8C%EC%8A%A4%ED%8A%B8" rel="tag">테스트</a></div>
          
          <div class="permalink__btn"><button class="permalink__comment-btn" uk-toggle=".permalink__comment"><i class="fas fa-comment"></i>댓글</button></div>
          
            <div class="permalink__author"><img class="profile lazyload" data-src="https://t1.daumcdn.net/tistory_admin/static/manage/images/r3/default_L.png" data-sizes="auto" width="80" height="80" alt="말차프라푸치노">
              <div class="description">
                <div class="user">말차프라푸치노</div>
                <div class="desc"></div>
              </div>
            </div>
          
        </footer>
      </div>
      <div class="permalink__comment">
        <div id="entry148Comment">
          <form method="post" action="/comment/add/148" onsubmit="return false" style="margin: 0">
    
<div class="rp-form content__form">
  <div class="form__shadow"><label for="comment">댓글</label><textarea id="comment" name="comment"></textarea>
    <div class="rp-form-control form-control">
      
        <div class="form__control__inner">
          
        </div>
      
      <div class="form__submit"><input id="secret" type="checkbox" name="secret"><label id="secret-label" for="secret"></label><a href="#" onclick="addComment(this, 148); return false;">댓글쓰기</a></div>
    </div>
  </div>
</div>

</form>
          
            <div class="rp-list content__list">
              <ol uk-accordion="multiple: true; toggle: .control > .more; content: > ol; animation: false; targets: > li[id^=comment]">
                            

            
              </ol>
            </div>
          
        </div>
<script type="text/javascript">loadedComments[148]=true;
findFragmentAndHighlight(148);</script>

      </div>
      
        
        <a class="permalink__notify uk-box-shadow-medium" href="/147" id="prev">
            <img class="thumbnail lazyload" src="https://img1.daumcdn.net/thumb/R750x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FDInvn%2FbtrXkXs0rKd%2FsQWIEXK38VfeRP3IE0Pdl1%2Fimg.png" alt="[iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현">
            <div class="metainfo">
              <div class="description">이전 글</div>
              <div class="title">[iOS] UICollectionViewCell에 더티 플래그 적용하기 (1/2) - 구현</div>
            </div>
          </a>
      
    </div>
  
  
  

        
    
            
            
            
            
              
            
          </div>
        </main>
        <footer class="uk-navbar-container uk-navbar-transparent" id="__footer" uk-navbar="">
          <div class="uk-navbar-left"><a id="__designed-by" href="https://pronist.tistory.com/5" target="_blank" rel="noreferrer">hELLO. 티스토리 스킨을 소개합니다.<i class="fa fa-code"></i></a></div>
          <div class="uk-navbar-right">
            
              <div id="__theme-btn">테마 바꾸기<i class="fa fa-moon-o" aria-hidden="true"></i></div>
            
            <a id="__toTop" href="#" uk-scroll="target: #__hELLO">제일 위로<i class="fa fa-chevron-up"></i></a>
          </div>
        </footer>
      </div>
    
    <div id="scroll-indicator">
      <div class="progress-container">
        <div class="progress-bar"></div>
      </div>
    </div>
  <div class="#menubar menu_toolbar ">
  <h2 class="screen_out">티스토리툴바</h2>
</div>
<div class="#menubar menu_toolbar "></div>
<iframe id="editEntry" style="position:absolute;width:1px;height:1px;left:-100px;top:-100px" src="//malchafrappuccino.tistory.com/api"></iframe>

                <!-- DragSearchHandler - START -->
<script src="//search1.daumcdn.net/search/statics/common/js/g/search_dragselection.min.js"></script>

<!-- DragSearchHandler - END -->

                
                <script>window.tiara = {"svcDomain":"user.tistory.com","section":"글뷰","trackPage":"글뷰_보기","page":"글뷰","key":"4726082-148","customProps":{"userId":"4897208","blogId":"4726082","entryId":"148","role":"owner","filterTarget":false,"trackPage":"글뷰_보기"},"entry":{"entryId":"148","categoryName":"카테고리 없음","categoryId":"0","author":"4897208","image":"kage@bBp1am/btrXooiedw5/n9ahcNaJ6k5eGk3AivgkvK","plink":"/148","tags":["Dirty Flag","instruments","uicollectionview","updateConstraints","더티 플래그","컬렉션뷰","테스트"]},"kakaoAppKey":"3e6ddd834b023f24221217e370daed18","appUserId":"1727305849"}</script>
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/tiara.min.js"></script>
<script type="text/javascript">(function($) {
    $(document).ready(function() {
        lightbox.options.fadeDuration = 200;
        lightbox.options.resizeDuration = 200;
        lightbox.options.wrapAround = false;
        lightbox.options.albumLabel = "%1 / %2";
    })
})(tjQuery);</script>
<div style="{margin:0; padding:0; border:none; background:none; float:none; clear:none; z-index:0}"></div>
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/owner.js"></script>
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/common.js"></script>
<script type="text/javascript">window.roosevelt_params_queue = window.roosevelt_params_queue || [{channel_id: 'dk', channel_label: '{tistory}'}]</script>
<script type="text/javascript" src="//t1.daumcdn.net/midas/rt/dk_bt/roosevelt_dk_bt.js" async="async"></script>
<script type="text/javascript" src="https://tistory1.daumcdn.net/tistory_admin/userblog/userblog-ce2b1cf88ca4f3e019bc6a3b9c241e836905a98e/static/script/menubar.min.js"></script>
<script>            (function (win, doc, src) {
    win.Wpm = win.Wpm || function (name, param) {
        win.Wpm.queue = win.Wpm.queue || [];
        const { queue } = win.Wpm;
        queue.push([name, param]);
    };
    const script = doc.createElement('script');
    script.src = src;
    script.async = 1;
    const [elem] = doc.getElementsByTagName('script');
    elem.parentNode.insertBefore(script, elem);
})(window, document, 'https://t1.kakaocdn.net/malibu_prod/wpm.js');
            const APP_KEY = 'd3cda7e82e6e4144bdc998b8e25f125d';
            Wpm('appKey', APP_KEY);</script>

                </body>

</html>`