package judgeua;

# judgeua.pl ユーザーエージェント(UA)から携帯端末の種類等を判定する
#  雀の往来,美味しい牛乳(←テキストエディタが文字コード判定を誤らないようにするための文字列)
#
# Ver. 1.06 2012/1/29
# 
# Copyright(C) 2005-2012 毛流麦花. All rights reserved.
#
#
# 本ソフトウェアは以下の利用規定に同意した場合のみ使用することができます。
# 以下の利用規程に同意した場合のみ、
# 本ソフトウェアの使用権が作成者(毛流麦花)から貸与されることになります。
# (あくまでも使用許諾であり、使用権が譲渡されるわけではありません。)
#
# [利用規定]
# (1)本ライブラリ・ソフトウェア(judgeua.pl)はフリーソフトウェアですが
#    著作権は作成者（毛流麦花）に帰属し、すべての権利は留保されています。
# (2)本ライブラリ・ソフトウェアを使用したことによるいかなる損害、トラブル、損失、結果についても
#    作成者は責任を負いません。
# (3)本ライブラリ・ソフトウェア(judgeua.pl)内の著作権表記、利用規定を削除することはできません。
# (4)本ライブラリ・ソフトウェアは非商用目的・商用目的のいずれにおいても自由にお使いいただけます。
# (5)改変がない状態でのjudgeua.plの再配布は自由です。再配布に際して、
#    作成者の事前・事後の承諾を得る必要はありませんし、作成者に連絡する必要はありません。
# (6)改変があるjudgeua.plの再配布は、改変されていることが明記されており、
#    さらに改変箇所が明記されている場合のみ可能です。
#    この場合の再配布についても、作成者の事前・事後の承諾を得る必要はありませんし、作成者に連絡する必要はありません。
# (7)前(5),(6)項の再配布に伴って発生したいかなる損害、トラブル、損失、結果についても
#    作成者（毛流麦花）は責任を負いません。
# (8)本ライブラリ・ソフトウェアのバグ（不具合）について作成者は修正する義務を負いません。
# (9)作成者は本ライブラリ・ソフトウェアに関する依頼・質問に答える義務を負いません。
# (10)本ライブラリ・ソフトウェアはHP内全文検索エンジンmsearchを携帯電話等の携帯端末に対応させることを意図して
#     作られたものであり、汎用性は一切考慮されていません。
#     また仕様・インターフェース等は予告なく変更することがあります。
#
#
# [謝辞]
# CGIぽん http://cgipon.specters.net/
#
#
# [履歴]
# Ver. 1.00  2005/09/22  最初のバージョン
#    対応: DoCoMo(i-mode(mova, FOMA))/au(EZweb(HDML, WAP2.0))/Vodafone(J-SKY(2GのWEB), 3G)
#          TU-KA(EZweb(HDML, WAP2.0))/WILLCOM(AirEDGE, H")/ASTEL(dot-i)/L-mode/一部のPDA
#    UTF-8対応：DoCoMoのFOMA, auとTU-KAのWAP2.0対応機(すべてUTF-8対応とみなす),
#               VodafoneのP4(2)型(J-N51, V601N)とW型(V801SH, V801SA)と3GC型
#               WILLCOMのAH-K3001V/AH-K3002V
#
# Ver. 1.01  2005/10/01  下記端末・ブラウザに対応した(つもり)
#    WILLCOM WX300K/WX310K/WX310SA/WX310J(すべてUTF-8対応とみなす)
#    Javaベースのブラウザ(jig browser/Scope)(すべてUTF-8対応とみなす) (SiteSneaker/ibisBrowserには未対応。)
#    PDAに搭載されたNetFront(すべてUTF-8対応とみなす)
#
# Ver. 1.02  2008/02/25  下記端末に対応した(つもり)
#    SoftBank(3G, すべてUTF-8対応とみなす)
#    Disney Mobile(SoftBank(3G)と同じ)
#
# Ver. 1.03  2008/02/29  下記端末に対応した(つもり)
#    EMOBILE(すべてUTF-8対応とみなす)
#
# Ver. 1.04  2012/1/22  下記端末/ブラウザに対応した(つもり)
#    本バージョンからget_terminfo()の返値の仕様を変更した。
#    iPhone/iPodTouch（スマホとみなす）
#    Androidスマホ端末（スマホとみなす）
#    Windows Phone(Mango以降)（スマホとみなす）
#    BlackBerryHTML5対応スマホ端末（スマホとみなす）
#    iPad/Androidタブレット端末（タブレットとみなす）
#    BlackBerryタブレット端末（タブレットとみなす）
#    HP TouchPad端末（タブレットとみなす）
#    EMOBILE H31IA,H12HW,H11HW(携帯電話とみなす)
#    Opera Mini/Opera Mobile(携帯電話とみなす)
#    Nintendo DSi/DSiLL/3DS/Wii(スマホとみなす)
#    Nintendo 上記以外のゲーム機(DS/DSLite)(携帯電話とみなす)
#    PlayStation PS Vita(スマホとみなす)
#    PlayStation 上記以外のゲーム機(PS2/PS3/PSP)(携帯電話とみなす)
#    WebKit系のNetFront(NetFrontLifeBrowserなど、スマホとみなす)
#    Android用Firefox(スマホとみなす)
#    Android用Opera Mini/Mobile(スマホとみなす)
#
# Ver. 1.05  2012/1/24  下記端末/ブラウザに対応した(つもり)
#    ドコモ携帯(FOMA)のフルブラウザ(PCとみなす)
#    ドコモ携帯(FOMA,富士通製)のスマートブラウザ(スマホとみなす)
#    au携帯(3G)のPCサイトビューアー(PCとみなす)
#    SoftBank携帯(3G)のPCサイトブラウザ(PCとみなす)
#    WILLCOM-PHSのフルブラウザ(PCとみなす)
#    EMOBILE携帯(3G)のH11Tのフルブラウザ(PCとみなす、H31IA/H11HW/H12HWのフルブラウザは通常ブラウザと識別できないため未対応)
#
# Ver. 1.06  2012/1/29
#    日本語フォント太字可否を返すようにした。
#   （ハイライト表示方法を太字・赤文字のどちらにするかを判断する材料にするため。）
#    WILLCOM-PHSフルブラウザの判定を修正(Opera搭載機を判定するようにした。)
#

sub get_terminfo {
  local(*ua)    = @_;   # 判定対象のユーザーエージェント文字列(参照渡し)
  my $termtype  = '';   # 端末の種類を示す文字列
  my $fontbold  = 'NG'; # 日本語フォントの太字が効かない可能性がある場合はNG、確実に効く場合はOK
  # $termtypeの例
  # $termtype='PC'     パソコン
  # $termtype='MOBILE' 携帯電話
  # $termtype='SPHONE' スマートフォン
  # $termtype='TABLET' タブレット
  # $termtype='OTHERS' その他(UTF-8エンコードHTMLを表示できない機種)

  if($ua =~ /DoCoMo\/1\.0/) {                        # DoCoMo/1.0(mova)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /DoCoMo\/2\.0/) {                   # DoCoMo/2.0(FOMA)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /^KDDI-/) {                         # au/TU-KAのWAP2.0
    $termtype  = 'MOBILE';                           # WAP2.0対応機はすべてUTF-8対応とみなす。(含 PCサイトビューアー搭載機)
  } elsif($ua =~ /^UP\.Browser/) {                   # au/TU-KAのHDML (HTMLではない)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /^J-PHONE/) {                       # J-PHONE
    $termtype  = 'OTHERS';
    if ($ua =~ /(J-N51|V601N)/)   { $termtype = 'MOBILE'; }  # P4(2)型のはずなのでUTF-8対応のはず。
    if ($ua =~ /(V801SH|V801SA)/) { $termtype = 'MOBILE'; }  # W型のはずなのでUTF-8対応のはず。
  } elsif($ua =~ /^Vodafone/) {                      # Vodafone
    $termtype  = 'MOBILE';                           # 3GC型なのでUTF-8対応のはず。
  } elsif($ua =~ /^SoftBank/) {                      # SoftBank
    $termtype  = 'MOBILE';                           # 3GC型なのでUTF-8対応のはず。
  } elsif($ua =~ /^MOT/) {                           # SoftBank
    $termtype  = 'MOBILE';                           # 3GC型なのでUTF-8対応のはず。
  } elsif($ua =~ /^emobile/) {                       # EMOBILE
    $termtype  = 'MOBILE';
  } elsif($ua =~ /(H31IA|H12HW|H11HW)/) {            # EMOBILE H31IA,H12HW,H11HW
    $termtype  = 'MOBILE';
  } elsif($ua =~ /DDIPOCKET/) {                      # WILLCOM(AirEDGE)
    $termtype  = 'OTHERS';
    if ($ua =~ /Opera/)    { $termtype = 'MOBILE'; } # 京ぽん(AH-K3001V/AH-K3002V)を想定(Opera搭載)
  } elsif($ua =~ /WILLCOM/) {                        # WILLCOM(AirEDGE) WX300/310シリーズ以降
    $termtype  = 'MOBILE';                           # WX300/310シリーズ以降はすべてUTF-8対応とみなす。
  } elsif($ua =~ /(jig browser|Scope)/) {            # Javaベースのブラウザ(jig browser/Scope)
    $termtype  = 'MOBILE';                           # JavaベースのブラウザはすべてUTF-8対応とみなす。
  } elsif($ua =~ /(PalmScape|sharp pda browser|WorldTALK)/) { # 各種PDA
    $termtype  = 'MOBILE';                           # PDAはすべてUTF-8対応とみなす。
  } elsif($ua =~ /(PDXGW|Ginga)/) {                  # H"(Open Net Contents) (HTMLではない)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /ASTEL/) {                          # ASTEL(dot-i)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /L-mode/) {                         # L-mode
    $termtype  = 'OTHERS';
  } elsif(($ua =~ /FOMA/) && ($ua =~ /WebKit/)) {       # ドコモ携帯(FOMA)のスマートブラウザ(WebKit系、HTML5対応)
    $termtype  = 'SPHONE';
  } elsif($ua =~ /FOMA/) {                              # ドコモ携帯(FOMA)のフルブラウザ
    $termtype  = 'PC';
  } elsif(($ua =~ /KDDI/) && ($ua =~ /Opera Mobi/)) {   # au携帯(3G)のPCサイトビューアー(スマホ扱いでも問題なさそうだが、PC扱いとする)
    $termtype  = 'PC';
  } elsif(($ua =~ /KDDI/) && ($ua =~ /Opera/)) {        # au携帯(3G)のPCサイトビューアー
    $termtype  = 'PC';
  } elsif(($ua =~ /SoftBank/) && ($ua =~ /NetFront/)) { # SoftBank携帯(3G)のPCサイトブラウザ
    $termtype  = 'PC';
  } elsif((($ua =~ /MobilePhone/) && ($ua =~ /NMCS/)) && ($ua =~ /NetFront/)) { # WILLCOM-PHSのフルブラウザ
    $termtype  = 'PC';
  } elsif((($ua =~ /Opera/) && ($ua =~ /KYOCERA/)) && ($ua =~ /(WX|AH)/)) {     # WILLCOM-PHSのフルブラウザ
    $termtype  = 'PC';
  } elsif((($ua =~ /Opera/) && ($ua =~ /SHARP/)) && ($ua =~ /WS/)) {            # WILLCOM-PHSのフルブラウザ
    $termtype  = 'PC';
  } elsif(($ua =~ /H11T/) && ($ua =~ /NetFront/)) {     # EMOBILE携帯(3G)のH11Tのフルブラウザ
    $termtype  = 'PC';
  } elsif(($ua =~ /NetFront/) && ($ua =~ /WebKit/)) { # NetFront(WebKit系、HTML5対応)
    $termtype  = 'SPHONE';
  } elsif($ua =~ /NetFront/) {                       # NetFront(HTML5非対応)
    $termtype  = 'MOBILE';
  } elsif(($ua =~ /Android/) && ($ua =~ /Firefox/)) { # Android版Firefox
    $termtype  = 'SPHONE';
  } elsif(($ua =~ /Android/) && ($ua =~ /Opera (Mini|Mobi)/)) { # Opera Mini/Opera Mobile for Android
    $termtype  = 'SPHONE';
  } elsif($ua =~ /Opera (Mini|Mobi)/) {              # Opera Mini/Opera Mobile for BlackBerry,SymbianOS,WindowsMobile,etc
    $termtype  = 'MOBILE';
  } elsif($ua =~ /Nintendo (DSi|3DS|Wii)/) {         # Nintendo ゲーム機(DSi,DSiLL,3DS,Wii)
    $termtype  = 'SPHONE';                           # スマホ扱い(HTML5+CSS3対応可)
  } elsif(($ua =~ /Opera/) && ($ua =~ /Nitro/)) {    # Nintendo ゲーム機(DS/DSLite)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /Nintendo/) {                       # Nintendo ゲーム機(上記以外)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /PlayStation Vita/) {               # PlayStationシリーズ ゲーム機(PS Vita)
    $termtype  = 'SPHONE';                           # スマホ扱い(HTML5+CSS3対応可)
  } elsif($ua =~ /PlayStation/i) {                   # PlayStationシリーズ ゲーム機(上記以外)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /webOS/) {                          # webOS端末
    $termtype  = 'TABLET';                           # webOS端末はHP TouchPadのみを想定。
  } elsif(($ua =~ /BlackBerry/) && ($ua =~ /WebKit/)) { # BlackBerry(HTML5対応)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif(($ua =~ /PlayBook/) && ($ua =~ /WebKit/)) {   # BlackBerry PlayBook
    $termtype  = 'TABLET';
    $fontbold  = 'OK';
  } elsif($ua =~ /BlackBerry/) {                     # BlackBerry(HTML5非対応)
    $termtype  = 'MOBILE';
  } elsif(($ua =~ /Windows CE/) || ($ua =~ /IEMobile (6|7|8)\./)) { # Pocket PC/Windows Mobile/Windows Phone(Mango以前)
    $termtype  = 'MOBILE';
  } elsif(($ua =~ /Windows Phone 6\./) || ($ua =~ /IEMobile\/(6|7|8)\./)) { # Windows Phone(Mango以前)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /IEMobile\//) {                     # Windows Phone(Mango以降)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif($ua =~ /iPad/) {                           # iPad(UserAgentに"iPhone OS"を含むiPad対策のためiPhoneよりも先に判別する)
    $termtype  = 'TABLET';
    $fontbold  = 'OK';
  } elsif($ua =~ /iPod/) {                           # iPodTouch(UserAgentに"iPhone OS"を含むiPodTouch対策のためiPhoneよりも先に判別する)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif($ua =~ /iPhone/) {                         # iPhone(iPad,iPod,iPhoneを見れば、Mobile Safari, Opera Mobile両方が検出可)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif((($ua =~ /Android/) && ($ua =~ /Mobile/)) && ($ua =~ /SC-01C/)) { # Galaxy Tab SC-01C
    $termtype  = 'TABLET';                           # SC-01CはタブレットなのにUserAgentに"Mobile"を含むため個別に判別する。
  } elsif(($ua =~ /Android/) && ($ua =~ /Mobile/)) { # Androidスマホ端末
    $termtype  = 'SPHONE';
  } elsif($ua =~ /Android/) {                        # Androidタブレット端末
    $termtype  = 'TABLET';
  } else {
    $termtype  = 'PC';
    $fontbold  = 'OK';
  }

  return(wantarray ? ($termtype, $fontbold) : $termtype);

} # END of sub get_terminfo()


1;
