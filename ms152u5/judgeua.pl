package judgeua;

# judgeua.pl �桼���������������(UA)�������ü���μ�������Ƚ�ꤹ��
#  ���α���,��̣��������(���ƥ����ȥ��ǥ�����ʸ��������Ƚ�����ʤ��褦�ˤ��뤿���ʸ����)
#
# Ver. 1.06 2012/1/29
# 
# Copyright(C) 2005-2012 ��ή����. All rights reserved.
#
#
# �ܥ��եȥ������ϰʲ������ѵ����Ʊ�դ������Τ߻��Ѥ��뤳�Ȥ��Ǥ��ޤ���
# �ʲ������ѵ�����Ʊ�դ������Τߡ�
# �ܥ��եȥ������λ��Ѹ���������(��ή����)������Ϳ����뤳�Ȥˤʤ�ޤ���
# (�����ޤǤ���ѵ����Ǥ��ꡢ���Ѹ������Ϥ����櫓�ǤϤ���ޤ���)
#
# [���ѵ���]
# (1)�ܥ饤�֥�ꡦ���եȥ�����(judgeua.pl)�ϥե꡼���եȥ������Ǥ���
#    ����Ϻ����ԡ���ή���֡ˤ˵�°�������٤Ƥθ�����α�ݤ���Ƥ��ޤ���
# (2)�ܥ饤�֥�ꡦ���եȥ���������Ѥ������Ȥˤ�뤤���ʤ�»�����ȥ�֥롢»������̤ˤĤ��Ƥ�
#    �����Ԥ���Ǥ���餤�ޤ���
# (3)�ܥ饤�֥�ꡦ���եȥ�����(judgeua.pl)������ɽ�������ѵ���������뤳�ȤϤǤ��ޤ���
# (4)�ܥ饤�֥�ꡦ���եȥ�������������Ū��������Ū�Τ�����ˤ����Ƥ⼫ͳ�ˤ��Ȥ����������ޤ���
# (5)���Ѥ��ʤ����֤Ǥ�judgeua.pl�κ����ۤϼ�ͳ�Ǥ��������ۤ˺ݤ��ơ�
#    �����Ԥλ���������ξ���������ɬ�פϤ���ޤ��󤷡������Ԥ�Ϣ����ɬ�פϤ���ޤ���
# (6)���Ѥ�����judgeua.pl�κ����ۤϡ����Ѥ���Ƥ��뤳�Ȥ���������Ƥ��ꡢ
#    ����˲��Ѳս꤬��������Ƥ�����Τ߲�ǽ�Ǥ���
#    ���ξ��κ����ۤˤĤ��Ƥ⡢�����Ԥλ���������ξ���������ɬ�פϤ���ޤ��󤷡������Ԥ�Ϣ����ɬ�פϤ���ޤ���
# (7)��(5),(6)��κ����ۤ�ȼ�ä�ȯ�����������ʤ�»�����ȥ�֥롢»������̤ˤĤ��Ƥ�
#    �����ԡ���ή���֡ˤ���Ǥ���餤�ޤ���
# (8)�ܥ饤�֥�ꡦ���եȥ������ΥХ����Զ��ˤˤĤ��ƺ����ԤϽ��������̳���餤�ޤ���
# (9)�����Ԥ��ܥ饤�֥�ꡦ���եȥ������˴ؤ�����ꡦ������������̳���餤�ޤ���
# (10)�ܥ饤�֥�ꡦ���եȥ�������HP����ʸ�������󥸥�msearch������������η���ü�����б������뤳�Ȥ�տޤ���
#     ���줿��ΤǤ��ꡢ�������ϰ��ڹ�θ����Ƥ��ޤ���
#     �ޤ����͡����󥿡��ե���������ͽ��ʤ��ѹ����뤳�Ȥ�����ޤ���
#
#
# [�ռ�]
# CGI�ݤ� http://cgipon.specters.net/
#
#
# [����]
# Ver. 1.00  2005/09/22  �ǽ�ΥС������
#    �б�: DoCoMo(i-mode(mova, FOMA))/au(EZweb(HDML, WAP2.0))/Vodafone(J-SKY(2G��WEB), 3G)
#          TU-KA(EZweb(HDML, WAP2.0))/WILLCOM(AirEDGE, H")/ASTEL(dot-i)/L-mode/������PDA
#    UTF-8�б���DoCoMo��FOMA, au��TU-KA��WAP2.0�б���(���٤�UTF-8�б��Ȥߤʤ�),
#               Vodafone��P4(2)��(J-N51, V601N)��W��(V801SH, V801SA)��3GC��
#               WILLCOM��AH-K3001V/AH-K3002V
#
# Ver. 1.01  2005/10/01  ����ü�����֥饦�����б�����(�Ĥ��)
#    WILLCOM WX300K/WX310K/WX310SA/WX310J(���٤�UTF-8�б��Ȥߤʤ�)
#    Java�١����Υ֥饦��(jig browser/Scope)(���٤�UTF-8�б��Ȥߤʤ�) (SiteSneaker/ibisBrowser�ˤ�̤�б���)
#    PDA����ܤ��줿NetFront(���٤�UTF-8�б��Ȥߤʤ�)
#
# Ver. 1.02  2008/02/25  ����ü�����б�����(�Ĥ��)
#    SoftBank(3G, ���٤�UTF-8�б��Ȥߤʤ�)
#    Disney Mobile(SoftBank(3G)��Ʊ��)
#
# Ver. 1.03  2008/02/29  ����ü�����б�����(�Ĥ��)
#    EMOBILE(���٤�UTF-8�б��Ȥߤʤ�)
#
# Ver. 1.04  2012/1/22  ����ü��/�֥饦�����б�����(�Ĥ��)
#    �ܥС�����󤫤�get_terminfo()�����ͤλ��ͤ��ѹ�������
#    iPhone/iPodTouch�ʥ��ޥۤȤߤʤ���
#    Android���ޥ�ü���ʥ��ޥۤȤߤʤ���
#    Windows Phone(Mango�ʹ�)�ʥ��ޥۤȤߤʤ���
#    BlackBerryHTML5�б����ޥ�ü���ʥ��ޥۤȤߤʤ���
#    iPad/Android���֥�å�ü���ʥ��֥�åȤȤߤʤ���
#    BlackBerry���֥�å�ü���ʥ��֥�åȤȤߤʤ���
#    HP TouchPadü���ʥ��֥�åȤȤߤʤ���
#    EMOBILE H31IA,H12HW,H11HW(�������äȤߤʤ�)
#    Opera Mini/Opera Mobile(�������äȤߤʤ�)
#    Nintendo DSi/DSiLL/3DS/Wii(���ޥۤȤߤʤ�)
#    Nintendo �嵭�ʳ��Υ����ൡ(DS/DSLite)(�������äȤߤʤ�)
#    PlayStation PS Vita(���ޥۤȤߤʤ�)
#    PlayStation �嵭�ʳ��Υ����ൡ(PS2/PS3/PSP)(�������äȤߤʤ�)
#    WebKit�Ϥ�NetFront(NetFrontLifeBrowser�ʤɡ����ޥۤȤߤʤ�)
#    Android��Firefox(���ޥۤȤߤʤ�)
#    Android��Opera Mini/Mobile(���ޥۤȤߤʤ�)
#
# Ver. 1.05  2012/1/24  ����ü��/�֥饦�����б�����(�Ĥ��)
#    �ɥ������(FOMA)�Υե�֥饦��(PC�Ȥߤʤ�)
#    �ɥ������(FOMA,�ٻ�����)�Υ��ޡ��ȥ֥饦��(���ޥۤȤߤʤ�)
#    au����(3G)��PC�����ȥӥ塼����(PC�Ȥߤʤ�)
#    SoftBank����(3G)��PC�����ȥ֥饦��(PC�Ȥߤʤ�)
#    WILLCOM-PHS�Υե�֥饦��(PC�Ȥߤʤ�)
#    EMOBILE����(3G)��H11T�Υե�֥饦��(PC�Ȥߤʤ���H31IA/H11HW/H12HW�Υե�֥饦�����̾�֥饦���ȼ��̤Ǥ��ʤ�����̤�б�)
#
# Ver. 1.06  2012/1/29
#    ���ܸ�ե�����������ݤ��֤��褦�ˤ�����
#   �ʥϥ��饤��ɽ����ˡ����������ʸ���Τɤ���ˤ��뤫��Ƚ�Ǥ�������ˤ��뤿�ᡣ��
#    WILLCOM-PHS�ե�֥饦����Ƚ�����(Opera��ܵ���Ƚ�ꤹ��褦�ˤ�����)
#

sub get_terminfo {
  local(*ua)    = @_;   # Ƚ���оݤΥ桼���������������ʸ����(�����Ϥ�)
  my $termtype  = '';   # ü���μ���򼨤�ʸ����
  my $fontbold  = 'NG'; # ���ܸ�ե���Ȥ������������ʤ���ǽ�����������NG���μ¤˸�������OK
  # $termtype����
  # $termtype='PC'     �ѥ�����
  # $termtype='MOBILE' ��������
  # $termtype='SPHONE' ���ޡ��ȥե���
  # $termtype='TABLET' ���֥�å�
  # $termtype='OTHERS' ����¾(UTF-8���󥳡���HTML��ɽ���Ǥ��ʤ�����)

  if($ua =~ /DoCoMo\/1\.0/) {                        # DoCoMo/1.0(mova)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /DoCoMo\/2\.0/) {                   # DoCoMo/2.0(FOMA)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /^KDDI-/) {                         # au/TU-KA��WAP2.0
    $termtype  = 'MOBILE';                           # WAP2.0�б����Ϥ��٤�UTF-8�б��Ȥߤʤ���(�� PC�����ȥӥ塼������ܵ�)
  } elsif($ua =~ /^UP\.Browser/) {                   # au/TU-KA��HDML (HTML�ǤϤʤ�)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /^J-PHONE/) {                       # J-PHONE
    $termtype  = 'OTHERS';
    if ($ua =~ /(J-N51|V601N)/)   { $termtype = 'MOBILE'; }  # P4(2)���ΤϤ��ʤΤ�UTF-8�б��ΤϤ���
    if ($ua =~ /(V801SH|V801SA)/) { $termtype = 'MOBILE'; }  # W���ΤϤ��ʤΤ�UTF-8�б��ΤϤ���
  } elsif($ua =~ /^Vodafone/) {                      # Vodafone
    $termtype  = 'MOBILE';                           # 3GC���ʤΤ�UTF-8�б��ΤϤ���
  } elsif($ua =~ /^SoftBank/) {                      # SoftBank
    $termtype  = 'MOBILE';                           # 3GC���ʤΤ�UTF-8�б��ΤϤ���
  } elsif($ua =~ /^MOT/) {                           # SoftBank
    $termtype  = 'MOBILE';                           # 3GC���ʤΤ�UTF-8�б��ΤϤ���
  } elsif($ua =~ /^emobile/) {                       # EMOBILE
    $termtype  = 'MOBILE';
  } elsif($ua =~ /(H31IA|H12HW|H11HW)/) {            # EMOBILE H31IA,H12HW,H11HW
    $termtype  = 'MOBILE';
  } elsif($ua =~ /DDIPOCKET/) {                      # WILLCOM(AirEDGE)
    $termtype  = 'OTHERS';
    if ($ua =~ /Opera/)    { $termtype = 'MOBILE'; } # ���ݤ�(AH-K3001V/AH-K3002V)������(Opera���)
  } elsif($ua =~ /WILLCOM/) {                        # WILLCOM(AirEDGE) WX300/310���꡼���ʹ�
    $termtype  = 'MOBILE';                           # WX300/310���꡼���ʹߤϤ��٤�UTF-8�б��Ȥߤʤ���
  } elsif($ua =~ /(jig browser|Scope)/) {            # Java�١����Υ֥饦��(jig browser/Scope)
    $termtype  = 'MOBILE';                           # Java�١����Υ֥饦���Ϥ��٤�UTF-8�б��Ȥߤʤ���
  } elsif($ua =~ /(PalmScape|sharp pda browser|WorldTALK)/) { # �Ƽ�PDA
    $termtype  = 'MOBILE';                           # PDA�Ϥ��٤�UTF-8�б��Ȥߤʤ���
  } elsif($ua =~ /(PDXGW|Ginga)/) {                  # H"(Open Net Contents) (HTML�ǤϤʤ�)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /ASTEL/) {                          # ASTEL(dot-i)
    $termtype  = 'OTHERS';
  } elsif($ua =~ /L-mode/) {                         # L-mode
    $termtype  = 'OTHERS';
  } elsif(($ua =~ /FOMA/) && ($ua =~ /WebKit/)) {       # �ɥ������(FOMA)�Υ��ޡ��ȥ֥饦��(WebKit�ϡ�HTML5�б�)
    $termtype  = 'SPHONE';
  } elsif($ua =~ /FOMA/) {                              # �ɥ������(FOMA)�Υե�֥饦��
    $termtype  = 'PC';
  } elsif(($ua =~ /KDDI/) && ($ua =~ /Opera Mobi/)) {   # au����(3G)��PC�����ȥӥ塼����(���ޥ۰����Ǥ�����ʤ�����������PC�����Ȥ���)
    $termtype  = 'PC';
  } elsif(($ua =~ /KDDI/) && ($ua =~ /Opera/)) {        # au����(3G)��PC�����ȥӥ塼����
    $termtype  = 'PC';
  } elsif(($ua =~ /SoftBank/) && ($ua =~ /NetFront/)) { # SoftBank����(3G)��PC�����ȥ֥饦��
    $termtype  = 'PC';
  } elsif((($ua =~ /MobilePhone/) && ($ua =~ /NMCS/)) && ($ua =~ /NetFront/)) { # WILLCOM-PHS�Υե�֥饦��
    $termtype  = 'PC';
  } elsif((($ua =~ /Opera/) && ($ua =~ /KYOCERA/)) && ($ua =~ /(WX|AH)/)) {     # WILLCOM-PHS�Υե�֥饦��
    $termtype  = 'PC';
  } elsif((($ua =~ /Opera/) && ($ua =~ /SHARP/)) && ($ua =~ /WS/)) {            # WILLCOM-PHS�Υե�֥饦��
    $termtype  = 'PC';
  } elsif(($ua =~ /H11T/) && ($ua =~ /NetFront/)) {     # EMOBILE����(3G)��H11T�Υե�֥饦��
    $termtype  = 'PC';
  } elsif(($ua =~ /NetFront/) && ($ua =~ /WebKit/)) { # NetFront(WebKit�ϡ�HTML5�б�)
    $termtype  = 'SPHONE';
  } elsif($ua =~ /NetFront/) {                       # NetFront(HTML5���б�)
    $termtype  = 'MOBILE';
  } elsif(($ua =~ /Android/) && ($ua =~ /Firefox/)) { # Android��Firefox
    $termtype  = 'SPHONE';
  } elsif(($ua =~ /Android/) && ($ua =~ /Opera (Mini|Mobi)/)) { # Opera Mini/Opera Mobile for Android
    $termtype  = 'SPHONE';
  } elsif($ua =~ /Opera (Mini|Mobi)/) {              # Opera Mini/Opera Mobile for BlackBerry,SymbianOS,WindowsMobile,etc
    $termtype  = 'MOBILE';
  } elsif($ua =~ /Nintendo (DSi|3DS|Wii)/) {         # Nintendo �����ൡ(DSi,DSiLL,3DS,Wii)
    $termtype  = 'SPHONE';                           # ���ޥ۰���(HTML5+CSS3�б���)
  } elsif(($ua =~ /Opera/) && ($ua =~ /Nitro/)) {    # Nintendo �����ൡ(DS/DSLite)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /Nintendo/) {                       # Nintendo �����ൡ(�嵭�ʳ�)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /PlayStation Vita/) {               # PlayStation���꡼�� �����ൡ(PS Vita)
    $termtype  = 'SPHONE';                           # ���ޥ۰���(HTML5+CSS3�б���)
  } elsif($ua =~ /PlayStation/i) {                   # PlayStation���꡼�� �����ൡ(�嵭�ʳ�)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /webOS/) {                          # webOSü��
    $termtype  = 'TABLET';                           # webOSü����HP TouchPad�Τߤ����ꡣ
  } elsif(($ua =~ /BlackBerry/) && ($ua =~ /WebKit/)) { # BlackBerry(HTML5�б�)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif(($ua =~ /PlayBook/) && ($ua =~ /WebKit/)) {   # BlackBerry PlayBook
    $termtype  = 'TABLET';
    $fontbold  = 'OK';
  } elsif($ua =~ /BlackBerry/) {                     # BlackBerry(HTML5���б�)
    $termtype  = 'MOBILE';
  } elsif(($ua =~ /Windows CE/) || ($ua =~ /IEMobile (6|7|8)\./)) { # Pocket PC/Windows Mobile/Windows Phone(Mango����)
    $termtype  = 'MOBILE';
  } elsif(($ua =~ /Windows Phone 6\./) || ($ua =~ /IEMobile\/(6|7|8)\./)) { # Windows Phone(Mango����)
    $termtype  = 'MOBILE';
  } elsif($ua =~ /IEMobile\//) {                     # Windows Phone(Mango�ʹ�)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif($ua =~ /iPad/) {                           # iPad(UserAgent��"iPhone OS"��ޤ�iPad�к��Τ���iPhone�������Ƚ�̤���)
    $termtype  = 'TABLET';
    $fontbold  = 'OK';
  } elsif($ua =~ /iPod/) {                           # iPodTouch(UserAgent��"iPhone OS"��ޤ�iPodTouch�к��Τ���iPhone�������Ƚ�̤���)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif($ua =~ /iPhone/) {                         # iPhone(iPad,iPod,iPhone�򸫤�С�Mobile Safari, Opera Mobileξ�������в�)
    $termtype  = 'SPHONE';
    $fontbold  = 'OK';
  } elsif((($ua =~ /Android/) && ($ua =~ /Mobile/)) && ($ua =~ /SC-01C/)) { # Galaxy Tab SC-01C
    $termtype  = 'TABLET';                           # SC-01C�ϥ��֥�åȤʤΤ�UserAgent��"Mobile"��ޤि����̤�Ƚ�̤��롣
  } elsif(($ua =~ /Android/) && ($ua =~ /Mobile/)) { # Android���ޥ�ü��
    $termtype  = 'SPHONE';
  } elsif($ua =~ /Android/) {                        # Android���֥�å�ü��
    $termtype  = 'TABLET';
  } else {
    $termtype  = 'PC';
    $fontbold  = 'OK';
  }

  return(wantarray ? ($termtype, $fontbold) : $termtype);

} # END of sub get_terminfo()


1;
