#!/usr/local/bin/perl
#=============================================================================#
#                                                                             #
#                        msearch - mat's search program                       #
#                                 version 1.52(U5)                            #
#                                                                             #
#                  Ķ�ʰץ���ǥå����Ǹ������󥸥�ץ����                 #
#        Copyright (C) 2000-2016, Katsushi Matsuda. All Right Reserved.       #
#                                                   Modified by ��ή����      #
#=============================================================================#

#=============================================================================#
#                                    ����CGI                                  #
#=============================================================================#

#=============================================================================#
# �� <- �ܲ��Ǥ��Ф��뽤�����ɵ��ս�ˤ��ܰ��Ȥ��Ƣ����դ��Ƥ��롣
# [��ջ���]
#  ���ܥ�����ץȤϡ�EUC+LF(ʸ�������ɡ�EUC�����ԥ����ɡ�LF)����¸���뤳�ȡ�
#    UTF-8�����Ǥ���¸���ʤ����ȡ�
#
# [UTF-8�Ǥ����]
#  ������ʸ���ϡ���������Τߤǻ��Ѥ��뤳�ȡ�
#    �ץ������Ǥ�ASCIIʸ���Τߤ���Ѥ��뤳�ȡ�
#    �ä�printerror()�ΰ�����ɬ��ASCIIʸ��������ɽ�����뤳�ȡ�(����ʸ������Ϥ���������NCRs(&#XXXX;)�����ǡ�)
#
# [ư��⡼�ɤ����]
#
# $utf_mode=1��   UTF-8��msearch�Ȥ���ư�

$utf_mode=1;

#
#=============================================================================#

if($utf_mode) {                 # ��
  require './utfjp.pl';         # ���ܸ�ʸ��������-Unicode�Ѵ��饤�֥��
  &utfjp::mappingmode('j2u');   # �ޥåԥ󥰥ơ��֥��JIS ->Unicode�����Τߤˤ��롣
} else {
  require './jcode.pl';		# �����������Ѵ��ѥå�����
  require './fold.pl';		# ���Х���ʸ���ե�����ǥ��󥰥ѥå�����
}

########################################
### �Ƽ��ѿ����(�ѹ����ʤ��ǲ�����) ###
########################################

### ����ǥå�����Ϣ
@g_index = ();			# ����ǥå���������
				# �ե�����̾,����,�ǽ���������,�ե����륵����,URL,�����ȥ�,��� ��
@match = ();			# �����˰��ä����ä�����ǥå���
				# �ǽ���������,�ե����륵����,URL,�����ȥ�,���� ��
$g_indexfile = "";              # ����ǥå����ե�����

### �����꡼��Ϣ
@g_and = ();			# �����������(and)
@g_not = ();			# �����������(not)
@g_or = ();			# �����������(or)
@g_title = ();			# �����������(title)
@g_url = ();			# �����������(url)
@g_and_i = ();			# ��������������Ӿ���(and)
@g_not_i = ();			# ��������������Ӿ���(not)
@g_or_i = ();			# ��������������Ӿ���(or)
@g_title_i = ();		# ��������������Ӿ���(title)
				# ���Ӿ���1 ��Ⱦ�ѱ�ʸ��
				# ����������2 ���ѣ�ʸ��
				# ����������0 �ʤ�

### ����ե������Ϣ
$g_config = "";                 # ����ե�����
$f_home = "";                   # �ۡ���ڡ���URL
$f_highlight = 1;               # �ϥ��饤�Ȥ��뤫�ɤ���
$f_highlight_deco = "<b>";      # �ϥ��饤�Ȥ���ˡ
$f_tzdiff = 0;                  # �����Хޥ���Ȥλ���

if($utf_mode) {                 # ��
 $f_notitle = '&#12479;&#12452;&#12488;&#12523;&#12394;&#12375;'; # '�����ȥ�ʤ�'��NCRs����ɽ�� ��
} else {
 $f_notitle = "�����ȥ�ʤ�";   # �����ȥ�ʤ��ξ���ɽ����ˡ
}

$f_log = 0;                     # ������Ϥ��뤫�ɤ���
$f_logfile = "./msearch.log";   # ���Υե�����̾

if($utf_mode) {                 # ��
  $f_logencoding = "utf-8";     # ���ե�����δ��������ɢ�UTF-8�Ǹ���
  $f_encoding    = "utf-8";     # HTML���ϴ���������      ��UTF-8�Ǹ���
  $f_extract_f = 20;            # ���ʸ����(��)
  $f_extract_b = 80;            # ���ʸ����(��)
} else {
  $f_logencoding = "euc-jp";    # ���ե�����δ���������
  $f_encoding    = "euc-jp";    # HTML���ϴ���������
  $f_extract_f = 40;            # ���ʸ����(��)
  $f_extract_b = 160;           # ���ʸ����(��)
}
$f_noresult = "";               # 0��ҥåȻ���ɽ�������å����� ��

if($utf_mode) {                 # ��
 $f_logformat = "date remote\n    ua\n    period\n    lang\n    hit".chr(0xE4).chr(0xBB).chr(0xB6)." query\n"; # ����
} else {
 $f_logformat = "date remote\n    ua\n    hit�� query\n"; # ����
}

$f_alllang   = 'All Languages';               # ��lang�����ʤ��Ǹ�����������$$lang$$���ִ�����ʸ����
$f_allperiod = 'Regardless of modified date'; # ��period�����ʤ��Ǹ�����������$$period$$���ִ�����ʸ����

$g_lock = "mslock";             # ��å��ǥ��쥯�ȥ�̾

if($utf_mode) {                 # ��
 my   @tmp=();
 push(@tmp,'year');
 push(@tmp,(chr(0xE5),chr(0xB9),chr(0xB4)));
 push(@tmp,'month');
 push(@tmp,(chr(0xE6),chr(0x9C),chr(0x88)));
 push(@tmp,'day');
 push(@tmp,(chr(0xE6),chr(0x97),chr(0xA5)));
 push(@tmp,' hour');
 push(@tmp,(chr(0xE6),chr(0x99),chr(0x82)));
 push(@tmp,'minute');
 push(@tmp,(chr(0xE5),chr(0x88),chr(0x86)));
 push(@tmp,'second');
 push(@tmp,(chr(0xE7),chr(0xA7),chr(0x92)));
 $f_dateformat = join('',@tmp);                               # ����ɽ����(UTF-8)
} else {
 $f_dateformat = "yearǯmonth��day�� hour��minuteʬsecond��"; # ����ɽ����
}

@f_page = ();                   # page
@f_pageindex = ();              # page�ν񼰥���ǥå���
$f_result = "";                 # result
$f_result_num = 10;             # result�η����֤����(=num)
$f_previous = "";               # previous
$f_next = "";                   # next
$f_pset = "";                   # pset
$f_pset_num = 5;                # pset�η����֤����
$f_cset = "";                   # cset
$f_nset = "";                   # nset
$f_nset_num = 5;                # nset�η����֤����
$f_help = "";                   # help
$f_exist_indexnum = 0;          # help�ե����ޥå����indexnum��ȤäƤ��뤫
$mes_format_error  = '&#12501;&#12457;&#12540;&#12510;&#12483;';  # '�ե����ޥåȤν񼰥��顼'��NCRs����ɽ�� ��
$mes_format_error .= '&#12488;&#12398;&#26360;&#24335;&#12456;&#12521;&#12540;';

### �ե����ޥå��ѿ�
$v_msearch = "msearch.cgi";     # cgi̾
$v_home = "";                   # �ۡ���ڡ�����URL
$v_query = "";                  # ���ߤθ�����
$v_hint  = "" if($utf_mode);    # ���ҥ��ʸ����
$v_index = "";                  # ����ǥå���̾
$v_config = "";                 # ����ե�����̾
$v_rpp = -1;                    # 1�ڡ����������ɽ�����
$v_set = 1;                     # ���ߤθ������å��ֹ�
$v_total = 0;                   # ����������
$v_from = 0;                    # ���ߥڡ�����ɽ���������Ƭ���
$v_to = 0;                      # ���ߥڡ�����ɽ�������������
$v_cputime = (times)[0];        # �����ä���������
$v_indexdate = "";              # ����ǥå����κǽ���������
$v_indexnum = 0;                # ����ǥå�������Ͽ����Ƥ���ڡ������
$v_nowdate = "";                # ��������
$v_msearchhp = "http://www.kiteya.net/script/msearch/"; # msearch�����ۥڡ���
$v_version = "1.52(U5)";        # msearch�ΥС������ ��

### �������, �������־����Ϣ ��
$v_lang    = '';                # �������(lang�������ͤ��Τޤ�)
$v_period  = '';                # �������־���(period�������ͤ��Τޤ�)
$val_lang  = '';                # lang������Ϳ����줿lang��(ʸ����)(���ߥ����κ�¦)
$cap_lang  = '';                # lang������Ϳ����줿,$$lang$$���ִ�����ʸ����(���ߥ����α�¦)
$val_period= 0;                 # period������Ϳ����줿,�����оݤȤ������(���ˤ�ñ��)�򼨤���(����)(���ߥ����κ�¦)
$cap_period= '';                # period������Ϳ����줿,$$period$$���ִ�����ʸ����(���ߥ����α�¦)

### ����ü����Ϣ ��
$termtype = '';                 # �����������Ƥ���ü���μ���
$fontbold = '';                 # ���ܸ�ե���Ȥ������������ʤ���ǽ�����������NG,�μ¤˸�������OK

### �����ɴ�Ϣ
$meta = '[\x24\x28-\x2B\x2D-\x2E\x3f\x5B-\x5E\x7B-\x7D]'; # �᥿����饯��
$han1 = '[\x00-\x7F]';		# EUCȾ��ʸ��������ɽ��
$hank = '\x8E[\xA0-\xDF]';	# EUCȾ�ѥ������ʤ�����ɽ��
$zen2 = '[\x8E\xA1-\xFE][\xA1-\xFE]'; # EUC����ʸ��(2�Х���)������ɽ��
$zen3 = '\x8F[\xA1-\xFE][\xA1-\xFE]'; # EUC����ʸ��(3�Х���)������ɽ��
$peuc = '[\xA1-\xFE][\xA1-\xFE]'; # ���ѣ�ʸ��������Ȥʤ�2�Х���ʸ��
$feuc = "($hank|$zen2|$zen3)*($han1|\$)"; # ���ѣ�ʸ����³��ʸ���������ɽ��

### UTF-8 1ʸ��������ɽ��($utf_mode�˴ط��ʤ����) ��
$utf8_1byte    = "[\x00-\x7f]";                                  # UTF-8�Ǥ�1�Х���ʸ��
$utf8_2byte    = "[\xc0-\xdf][\x80-\xbf]";                       # UTF-8�Ǥ�2�Х���ʸ��
$utf8_3byte    = "[\xe0-\xef][\x80-\xbf][\x80-\xbf]";            # UTF-8�Ǥ�3�Х���ʸ��
$utf8_4byte    = "[\xf0-\xf7][\x80-\xbf][\x80-\xbf][\x80-\xbf]"; # UTF-8�Ǥ�4�Х���ʸ��
$utf8_bom      = "\xEF\xBB\xBF";                                 # BOM for UTF-8

##################
### �ᥤ����� ###
##################

$io = select(STDOUT);
$| = 1;
select($io);

### �����μ����ȥѡ�����
$arg = getargument();
$qarg = parseargument($arg);

### �������ͤ��ѿ�����
# �����������(query),�������(lang),�������־���(period) ��
if($qarg->{'query'} ne "") {
    my $query = $qarg->{'query'};
    my $lang  = $qarg->{'lang'};   # ��
    my $period= $qarg->{'period'}; # ��
    my $kcode;

    ## �ҥ��ʸ�����Ȥä������꡼�δ���������Ƚ��
    ## special thanks  ��ή���֤���
    if($utf_mode) {  # ��
      if($qarg->{'hint'} ne "") {
        $kcode  = &utfjp::getcode(\$qarg->{'hint'});
        $v_hint = $qarg->{'hint'};
        &utfjp::convert(\$v_hint,"utf8",$kcode);
      }
    } else {
      $kcode = &jcode::getcode(\$qarg->{'hint'});
    }

    ## ����������¸
    if($utf_mode) {  # ��
      if($kcode eq "utf8") {
        # No Operation
      } elsif($kcode eq "euc") {
        &utfjp::convert(\$query, "utf8","euc");
        &utfjp::convert(\$lang,  "utf8","euc");
        &utfjp::convert(\$period,"utf8","euc");
      } elsif($kcode eq "sjis") {
        &utfjp::convert(\$query, "utf8","sjis");
        &utfjp::convert(\$lang,  "utf8","sjis");
        &utfjp::convert(\$period,"utf8","sjis");
      } elsif($kcode eq "jis") {
        &utfjp::convert(\$query, "utf8","jis");
        &utfjp::convert(\$lang,  "utf8","jis");
        &utfjp::convert(\$period,"utf8","jis");
      } else {
        # No Operation �ҥ��ʸ�����ɬ��.
      }
      &utfjp::del_all_tables;  # �� �ޥåԥ󥰥ơ��֥���
      $v_query = $query;
      $v_lang  = $lang;
      $v_period= $period;
    } else {
      if($kcode eq "sjis") {
        &jcode::sjis2euc(\$query);
      } elsif($kcode eq "jis") {
        &jcode::jis2euc(\$query);
      } elsif(undef($kcode)) {
        &jcode::convert(\$query,"euc");
      }
      $v_query = $query;
    }

    ## �����꡼�Υ��˥��饤��
    $query =~ s/</&lt;/g;
    $query =~ s/>/&gt;/g;

    ## �����꡼��������
    normalize(\$query);

    ## ������ɤβ��
    # OR���
    while(1) {
	if($query =~ s/\((.*?)\)//) {
	    my $tmp = $1;
	    $tmp =~ s/^,*//;
	    if($tmp =~ /,/) {
		z2h(\$tmp);
		push(@g_or,$tmp);
	    } else {
		z2h(\$tmp);
		push(@g_and,"($tmp)");
	    }
	} else {
	    last;
	}
    }
    $query =~ s/,+/,/g;
    $query =~ s/^,//;
    $foo = $query;
    my @keywords = split(/,/,$query); # ���٤ƤΥ������
    while(@keywords) {
	my $key = shift(@keywords); # ���ĤΥ������
	if($key =~ /^"(.*)"$/) {
	    # and����(�������Ȥ��줿���)
	    my $newkey = $1;
	    z2h(\$newkey);
	    push(@g_and,$newkey);
	} elsif($key =~ /^-(.*)$/) {
	    # not����
	    my $newkey = $1;
	    z2h(\$newkey);
	    push(@g_not,$newkey);
	} elsif($key =~ /^[tT]:(.*)$/) {
	    # title����
	    my $newkey = $1;
	    z2h(\$newkey);
	    push(@g_title,$newkey);
	} elsif($key =~ /^[uU]:(.*)$/) {
	    # url����
	    push(@g_url,$1);
	} else {
	    # and����
	    z2h(\$key);
	    push(@g_and,$key);
	}
    }
}

### �� �����������ѥơ��֥���
&utfjp::del_all_tables if($utf_mode);

### ������̤Υ��åȿ�
if($qarg->{'set'} ne "") {
    $v_set = $qarg->{'set'};
    $v_set++;
    $v_set--;
    $v_set = 1 if($v_set eq "");
}

### HTML��Content-type����Ϥ���
printcontenttype();

### ����ǥå���������ե��������ꤹ��
#require './allow.pl';
identifyindex();

### ����ü���б��������� ��
if($qarg->{'config'} eq "") {
    require './judgeua.pl';
    ($termtype, $fontbold) = &judgeua::get_terminfo(\$ENV{'HTTP_USER_AGENT'});
    if($termtype =~ /SPHONE/) {       # ���ޥ�ü���ξ��
       $g_config = "./sphone.cfg";
       # $g_indexfile = "./sphone.idx";
       # ���ޥ�ü������Υ�����������index�����λ���˴ؤ��ʤ�����Υ���ǥå�����Ȥ�����ͭ����
    } elsif($termtype =~ /TABLET/) {  # ���֥�å�ü���ξ��
       # �ѥ������Ʊ�������ˤ���Τǡ������Ǥϲ��⤷�ʤ���
    } elsif($termtype =~ /MOBILE/) {  # �������äξ��
       $g_config = "./mobile.cfg";
       # $g_indexfile = "./mobile.idx";
       # ����ü������Υ�����������index�����λ���˴ؤ��ʤ�����Υ���ǥå�����Ȥ�����ͭ����
    }
} 
### ����ü���б������ޤ� ��

### ����ե�������ɤ߹���
parseconfig();
$v_home = $f_home;
$v_rpp = $f_result_num;

### ������̰���ɽ����
if($qarg->{'num'} ne "") {
    # cgi������num�����ꤵ��Ƥ�����Ϥ����ͥ�褹��
    $v_rpp = $qarg->{'num'};
    $v_rpp++;
    $v_rpp--;
    $v_rpp = 10 if($v_rpp eq "");
}

### ���������μ���
$v_nowdate = getnowdate();

### ����ǥå����κǽ����������μ���
$v_indexdate = getindexdate();

### ���������뤫�ɤ����򸡺����ǥ����å�
$tmp = @g_and + @g_not + @g_or + @g_title + @g_url;

###
### �����ʤ��ǸƤФ줿���ν���
###
if($tmp == 0) {
    if($f_exist_indexnum == 1) {
	$v_indexnum = getindexnum();
    }
    getcputime();
    printhelp();
    exit;
}

###
### ��������ξ��ϰʲ�
###

my ($i, $j, $hl_open, $hl_close);
my ($mtime, $fsize, $url, $title, $contents, $part); # ��
my ($in, $flag, $d_start, $d_end);
my ($cgicall, $tset);

### �ѤʸƤӽФ��Υ����å�
checkinvalid();

### �ϥ��饤�Ȥ��Ĥ��륿���κ���
$hl_open = $f_highlight_deco;
$hl_close = $f_highlight_deco;
$hl_close =~ s/<(.*?)[\s>].*$/<\/\1>/;

### �������ȹ������־���ν��� ��
if($utf_mode) {
  my @tmp;

  @tmp = split(/;/,$v_lang);
  if(@tmp==2) {
    $val_lang =  lc($tmp[0]);     # ���줬$val_lang���������ڡ����Τ߸�������
    $val_lang =~ s/\s+//g;
    $val_lang =  '' if($val_lang eq 'all'); # $val_lang��'all'�λ��Ϥ��٤Ƥθ���򸡺�����
    $cap_lang =  $tmp[1];         # lang����(���ߥ����α�¦)�ǻ��ꤷ��ʸ����($$lang$$���ִ�����)
  } else {
    $val_lang = '';               # ���٤Ƥθ���򸡺�
    $cap_lang = $f_alllang;
  }

  @tmp = split(/;/,$v_period);
  if(@tmp==2) {
    if($tmp[0] < 0) {        # period����(���ߥ����κ�¦)���������ꤷ�����Ϲ��������˴ط��ʤ����٤ƤΥڡ����򸡺�
      $val_period=0;
    } else {
      my ($sec,$min,$hour);
      my $eptime=time+$f_tzdiff*3600;
      ($sec,$min,$hour) = localtime($eptime);
      # ���ݥå��������ͤ�$val_period�ʾ�Υڡ����Τ߸�������
      # period����(���ߥ����κ�¦)��0����ꤹ�������ʬ�Τߤθ���
      # period����(���ߥ����κ�¦)����������ꤹ��Ȥ����������λ����ʹߤθ���
      $val_period=$eptime-(($hour*3600+$min*60+$sec)+($tmp[0]*24*3600));
    }
    $cap_period=$tmp[1];     # period����(���ߥ����α�¦)�ǻ��ꤷ��ʸ����($$period$$���ִ�����)
  } else {
    $val_period = 0;         # ���ݥå��������ͤ˴ط��ʤ����٤ƤΥڡ����򸡺�
    $cap_period = $f_allperiod;
  }

} # END of if($utf_mode)

### ����ǥå������ɤ߹��� ��
# $v_indexnum = readindex() if(-f $g_indexfile);
if(-f $g_indexfile) {
  $v_indexnum = readindex();
} else {
  printerror("&#12452;&#12531;&#12487;&#12483;&#12463;&#12473;&#12364;&#12354;&#12426;&#12414;&#12379;&#12435;&#65294;"); # "����ǥå���������ޤ���" ��
}
if($v_indexnum == 0) { # ����ȹ������λ���ˤ�äƤϾ��˳�������ڡ������ʤ��ɤ߹��߷������ˤʤ뤳�Ȥ⤢�� ��
  getcputime();
#  undef @g_index;
  printpage();
  if($f_log == 1) {
      outputlog();
  }
  exit;
}

### ɽ�������ֹ�(��Ƭ���-1)��ɽ����λ�ֹ�(�������-1)�η׻�
if($v_rpp == 0) {
    $d_start = 0;
    $d_end = $v_indexnum - 1;
} else {
    $d_start = ($v_set - 1) * $v_rpp;
    $d_end = $v_set * $v_rpp - 1;
}

### ��������Υ᥿ʸ���Υ���������
escapequery();

###
### �Ƹ���������ɤǥ���ǥå����򸡺�
###
for($i=0;$i<$v_indexnum;$i++) {
    # �ƥѡ��Ĥ�ʬ��
    ($mtime,$fsize,$url,$title,$contents) = split(/\t/,$g_index[$i]); # ��

    # ��ʬ�ν����
    $part = "";

    # �ϰ��⤫�ɤ�����ͽ����Ƥ���
    if($v_total >= $d_start && $v_total <= $d_end) {
	$in = 1;
    } else {
	$in = 0;
    }

    ### �ƾ��ǥ����å�
    $flag = 1;		# �ޤ��ϥޥå������Ȳ��ꤹ��
    ### and���
    if($flag == 1 && @g_and > 0) {
	for($j=0;$j<@g_and&&$flag==1;$j++) {
	    if($g_and_i[$j] == 0) {
		## ���ѣ�ʸ���ʳ��ξ��
		if($title =~ /$g_and[$j]/) {
		    # ������ɤ����ä�(³����)
		    next;
		} elsif($contents =~ /$g_and[$j]/) {
		    # ������ɤ����ä�(³����)
		    if($in == 1 && $part eq "") {
			$prev = $`;
			$self = $&;
			$next = $';
			$part = "1";
		    }
		    next;
		} else {
		    # ������ɤ��ʤ��ä�(����)
		    $flag = 0;
		}
	    } else {
		## ���ѣ�ʸ���ξ��
		if($title =~ /$g_and[$j]$feuc/) {
		    next;
		} elsif($contents =~ /$g_and[$j]$feuc/) {
		    if($in == 1 && $part eq "") {
			$prev = $`;
			$self = $g_and[$j];
			$next = $& . $';
			$next =~ s/^$g_and[$j]//;
			$part = "1";
		    }
		    next;
		} else {
		    $flag = 0;
		}
	    }
	}
    }
    ### or���
    if($flag == 1 && @g_or > 0) {
	for($j=0;$j<@g_or&&$flag==1;$j++) {
	    if($g_or_i[$j] == 0) {
		## ���ѣ�ʸ���������ޤޤ�ʤ����
		if($title =~ /$g_or[$j]/) {
		    # ������ɤ����ä�(³����)
		    next;
		} elsif($contents =~ /$g_or[$j]/) {
		    # ������ɤ����ä�(³����)
		    if($in == 1 && $part eq "") {
			$prev = $`;
			$self = $&;
			$next = $';
			$part = "1";
		    }
		    next;
		} else {
		    # ������ɤ��ʤ��ä�(����)
		    $flag = 0;
		}
	    } else {
		## ���ѣ�ʸ�����ޤޤ����
		my $w;
		my $p = 0;
		my $f = 0;
		my @words = split(/\|/,$g_or[$j]);
		foreach $w ( @words ) {
		    $p = 1 if(($w =~ /^$peuc$/) && (!$utf_mode));  # ����������ѣ�ʸ����
		    if($p == 1) {
			# ���ѣ�ʸ��
			if($title =~ /$w$feuc/) {
			    $f = 1;
			    last;
			}
			if($contents =~ /$w$feuc/) {
			    if($in == 1 && $part eq "") {
				$prev = $`;
				$self = $w;
				$next = $& . $';
				$next =~ s/^$w//;
				$part = "1";
			    }
			    $f = 1;
			    last;
			}
		    } else {
			# ���ѣ�ʸ������ʤ�
			if($title =~ /$w/) {
			    $f = 1;
			    last;
			}
			if($contents =~ /$w/) {
			    if($in == 1 && $part eq "") {
				$prev = $`;
				$self = $&;
				$next = $';
				$part = "1";
			    }
			    $f = 1;
			    last;
			}
		    }
		}
		if($f == 1) {
		    # ������ɤ����ä�
		    next;
		} else {
		    # ������ɤ��ʤ��ä�
		    $flag = 0;
		    last;
		}
	    }
	}
    }
    ### not���
    if($flag == 1 && @g_not > 0) {
	for($j=0;$j<@g_not&&$flag==1;$j++) {
	    if($g_not_i[$j] == 0) {
		## ���ѣ�ʸ���ʳ��ξ��
		if($contents =~ /$g_not[$j]/ || $title =~ /$g_not[$j]/) {
		    # ������ɤ����ä�(����)
		    $flag = 0;
		} else {
		    # ������ɤ��ʤ��ä�(³����)
		    next;
		}
	    } else {
		## ���ѣ�ʸ���ξ��
		if($contents =~ /$g_not[$j]$feuc/ ||
		   $title =~ /$g_not[$j]$feuc/) {
		    # ������ɤ����ä�(����)
		    $flag = 0;
		} else {
		    # ������ɤ��ʤ��ä�(³����)
		    next;
		}
	    }
	}
    }
    ### title���
    if($flag == 1 && @g_title > 0) {
	for($j=0;$j<@g_title&&$flag==1;$j++) {
	    if($g_title_i[$j] == 0) {
		## ���ѣ�ʸ���ʳ��ξ��
		if($title =~ /$g_title[$j]/) {
		    # ������ɤ����ä�(³����)
		    next;
		} else {
		    # ������ɤ��ʤ��ä�(����)
		    $flag = 0;
		}
	    } else {
		## ���ѣ�ʸ���ξ��
		if($title =~ /$g_title[$j]$feuc/) {
		    # ������ɤ����ä�(³����)
		    next;
		} else {
		    # ������ɤ��ʤ��ä�(����)
		    $flag = 0;
		}
	    }
	}
    }
    ### url���
    if($flag == 1 && @g_url > 0) {
	for($j=0;$j<@g_url&&$flag==1;$j++) {
	    if($url =~ /$g_url[$j]/) {
		# ������ɤ����ä�(³����)
		next;
	    } else {
		# ������ɤ��ʤ��ä�(����)
		$flag = 0;
	    }
	}
    }

    ## ɽ���ϰϤΤ�ΤΤ�match�������¸����
    if($flag == 1 && $in == 1) {
	# �����ȥ���Υޥå�ʸ�����ϥ��饤�Ȳ�
	if($f_highlight == 1) {
            highlight(\$title,$hl_open,$hl_close,1);
	}

	# HTML��Ȥ���ʬ�����
	if($part eq "") {
          if($utf_mode) { # ��
            $part = $contents;
            &utfjp::utf8fold(\$part,$f_extract_f + $f_extract_b);
          } else {
            ($part,undef) = &fold($contents,$f_extract_f + $f_extract_b);
          }
	  $part .= ". . .";
	} else {
	  $part = extract(\$prev,\$self,\$next);
	}

	# �����ʬ�Υϥ��饤�Ȳ�
	if($f_highlight == 1) {
	    highlight(\$part,$hl_open,$hl_close,0);
	}

	# �������Ͽ
	push(@match,"$mtime\t$fsize\t$url\t$title\t$part"); # ��
    }
    $v_total++ if($flag == 1);
}

### �������֤Υ��å�
getcputime();

### ����ǥå������ݻ����Ƥ����ѿ����� ��
undef @g_index;

### ��
### ������set������num�������Ȥ߹�碌�ǸƤФ줿����0��ҥåȰ����ˤ���
### ����������ޤ����ǹ���������ꤷ��������Ԥä�����ȯ�������ǽ��������
### ����������ޤ����ȸ������������Ѳ�����(��������)���Ȥ��ͤ����뤿��
###
if(($v_total!=0)&&(@match==0)) {
  $v_total=0;
}

###
### ������̤�ɽ��
###
printpage();

### ���ν���
if($f_log == 1) {
    outputlog();
}

### ��λ
exit;

######################
### �����ط��δؿ� ###
######################

###
### �����μ���
###
sub getargument {
    my $arg;	# �������륯���꡼(�����)

    if($ENV{'REQUEST_METHOD'} eq 'GET') {
	$arg = $ENV{'QUERY_STRING'};
    } elsif ($ENV{'REQUEST_METHOD'} eq 'POST') {
	read(STDIN,$arg,$ENV{'CONTENT_LENGTH'});
    }
    
    return $arg;
}

###
### �����Υѡ���
###
sub parseargument {
    my $arg = $_[0];	# ���󥳡��ɤ��줿����(����)
    my %qarg;		# �ѡ�����̤Υϥå���(�����)
    my @avpairs;	# °��-�ͥڥ�������
    my $avpair;	# °��-�ͥڥ�
    my $attribute;	# °��
    my $value;	# ��
    
    @avpairs = split(/&/,$arg);
    for $avpair (@avpairs) {
	# ����Υǥ�����
	$avpair =~ tr/+/ /;
	# °�����ͤ�ʬ��
	($attribute,$value) = split(/=/,$avpair);
	# °���Υǥ�����
	$attribute =~ s/%([\da-fA-F]{2})/pack("C",hex($1))/ge;
	# �ͤΥǥ�����
	$value =~ s/%([\da-fA-F]{2})/pack("C",hex($1))/ge;
	# Ʊ��°����ʣ��������ϡ��������ͭ���ˤʤ�
	# query°���ξ���' '��Ϣ�뤹��
	if($attribute eq "query" && defined $qarg{$attribute}) {
	    $qarg{$attribute} .= " $value";
	} else {
	    $qarg{$attribute} = $value;
	}
    }
    return \%qarg;
}

###
### CGI�����Υ����å�
###
sub checkinvalid {
    if($v_rpp == 0 && $v_set != 1) {
	# ��̤�����ɽ���ʤΤ�2���ܰʾ�Υ��åȤ��׵ᤷ��
	printerror("&#26908;&#32034;&#32080;&#26524;&#31684;&#22258;&#22806;&#12391;&#12377;"); # "��������ϰϳ��Ǥ�" ��
    }
    if($v_set < 1 || $v_rpp < 0) {
	# ���åȤ�0�ʲ��ޤ���ɽ������0��꾮�����ƤӽФ�
	printerror("&#26908;&#32034;&#32080;&#26524;&#31684;&#22258;&#22806;&#12391;&#12377;"); # "��������ϰϳ��Ǥ�" ��
    }
}

###
### ����ǥå���������ե�����γ���
###
sub identifyindex {
    ### ����ǥå����γ���
    if($qarg->{'index'} eq "") {
	$g_indexfile = "./default.idx";
    } else {
	if($qarg->{'index'} =~ tr/a-zA-Z0-9//dc) {
	    printerror("&#105;&#110;&#100;&#101;&#120;&#20837;&#21147;&#12364;&#19981;&#27491;&#12391;&#12377;"); # "index���Ϥ������Ǥ�" ��
	}
	$g_indexfile = "./" . $qarg->{'index'} . ".idx";
	$v_index = $qarg->{'index'};
    }

    ### ����ե�����γ���
    if($qarg->{'config'} ne "") {
	if($qarg->{'config'} =~ tr/a-zA-Z0-9//dc) {
	    printerror("&#99;&#111;&#110;&#102;&#105;&#103;&#20837;&#21147;&#12364;&#19981;&#27491;&#12391;&#12377;"); # "config���Ϥ������Ǥ�" ��
	}
	$g_config = "./" . $qarg->{'config'} . ".cfg";
	$v_config = $qarg->{'config'};
    } else {
	if($qarg->{'index'} ne "") {
	    my $tmp_config = "./" . $qarg->{'index'} . ".cfg";
	    if(-e $tmp_config) {
		$g_config = $tmp_config;
	    } else {
		$g_config = "./default.cfg";
	    }
	} else {
	    $g_config = "./default.cfg";
	}
    }
}

##########################
### �����꡼�ط��δؿ� ###
##########################

###
### �����꡼��������
###
sub normalize {
    my $string = $_[0];		# �����꡼�ؤλ���(����)

    if($utf_mode) {             # ��
      &utfjp::utf8h2z_kana($string);
      my @from = (0x3000,0xFF0C,0xFF08,0xFF09);
      my @to   = (0x002C,0x002C,0x0028,0x0029);
      &utfjp::utf8tr_codepoint($string, \@from, \@to);
    } else {
      &jcode::h2z_euc($string);	# Ⱦ�ѥ��ʤ����Ѥ�
      &jcode::tr($string,'�����ʡ�',',,()');
    }
    $$string =~ s/\s/,/g;	# ����ʸ����ǥ�ߥ���
    $$string =~ s/,+/,/g;	# ���İʾ�³���ǥ�ߥ�����
}

###
### ���ѱѿ������Ⱦ�ѱѿ�������Ѵ�
###
sub z2h {
    my $string = $_[0];		# �Ѵ�����ʸ����ؤλ���(����)

    if($utf_mode) {             # ��
      &utfjp::utf8z2h_an($string);
      my @from = (0xFF0B,0xFF3D,0xFF3B,0xFF0E,0xFF08,0xFF09,0xFF1F,0xFF0F,0xFF20);
      my @to   = (0x002B,0x005D,0x005B,0x002E,0x0028,0x0029,0x003F,0x002F,0x0040);
      &utfjp::utf8tr_codepoint($string, \@from, \@to);
    } else {
      &jcode::tr($string,'��-����-�ڣ�-���ܡϡΡ��ʡˡ�����',
      '0-9A-Za-z+][.()?/@');
    }
}

###
### �����꡼�������ɽ���Υ᥿ʸ���Υ���������
###
sub escapequery {
    my ($i, $j);

    # $g_??_i[$i]�ΰ�̣�ϡ�
    # 1 = ����1ʸ������
    # 0 = ����¾

    # AND���
    for($i=0;$i<@g_and;$i++) {
	$g_and[$i] =~ s/($meta)/\\$1/g;
	if(($g_and[$i] =~ /^$peuc$/) && (!$utf_mode)) {  # ��
	    $g_and_i[$i] = 1;
	} else {
	    $g_and_i[$i] = 0;
	    $g_and[$i] =~ s/([a-zA-Z])/'[' . lc($1) . uc($1) . ']'/eg;
	}
    }

    # OR���
    for($i=0;$i<@g_or;$i++) {
	$g_or[$i] =~ s/($meta)/\\$1/g;
	$g_or[$i] =~ s/,/\|/g;
	my @words = split(/\|/,$g_or[$i]);
	$g_or_i[$i] = 0;
	for($j=0;$j<@words;$j++) {
	    if(($words[$j] =~ /^$peuc$/) && (!$utf_mode)) {  # ��
		$g_or_i[$i] = 1;
	    }
	    $words[$j] =~ s/([a-zA-Z])/'[' . lc($1) . uc($1) . ']'/eg;
	}
	$g_or[$i] = join('|',@words);
    }

    # NOT���
    for($i=0;$i<@g_not;$i++) {
	$g_not[$i] =~ s/($meta)/\\$1/g;
	if(($g_not[$i] =~ /^$peuc$/) && (!$utf_mode)) {  # ��
	    $g_not_i[$i] = 1;
	} else {
	    $g_not_i[$i] = 0;
	    $g_not[$i] =~ s/([a-zA-Z])/'[' . lc($1) . uc($1) . ']'/eg;
	}
    }

    # TITLE���
    for($i=0;$i<@g_title;$i++) {
	$g_title[$i] =~ s/($meta)/\\$1/g;
	if(($g_title[$i] =~ /^$peuc$/) && (!$utf_mode)) {  # ��
	    $g_title_i[$i] = 1;
	} else {
	    $g_title_i[$i] = 0;
	    $g_title[$i] =~ s/([a-zA-Z])/'[' . lc($1) . uc($1) . ']'/eg;
	}
    }

    # URL���
    for($i=0;$i<@g_url;$i++) {
	$g_url[$i] =~ s/($meta)/\\$1/g;
	$g_url[$i] =~ s/([a-zA-Z])/'[' . lc($1) . uc($1) . ']'/eg;
    }
}

###
### url��������ɽ���˻Ȥ����ͤ��Ѵ�
###
sub changeregexp {
    my $queries = $_[0];	# url�������ؤλ���(����)
    my $i;			# ���󥯥��󥿥����ѿ�

    for($i=0;$i<@$queries;$i++) {
	# . -> \.
	$queries->[$i] =~ s/\./\\./g;
	# / -> \/
	$queries->[$i] =~ s/\//\\\//g;
    }
}

##############################
### ����ǥå����ط��δؿ� ###
##############################

###
### ����ǥå������ɤ߹��� ��
###
sub readindex {
    my $lang;			# �������
    my $period;			# �������־���(�ºݤˤϥ��ݥå���������)
    my $value;			# �ե����륵����,URL,�����ȥ�,��ʸ
    my $i;			# ���󥯥��󥿥���
    my $match_lang;
    my $match_period;
    my @tmp;
    my $lg;

    # �ե�����Υ����ץ�
    open(FILE,"<$g_indexfile");

    # ����ǥå������ɤ߹��� ��
    @tmp = split(/,/,$val_lang);
    $i = 0;
    while(<FILE>) {
	# ���Ԥ���
	chomp;
	# �ե�����̾�ʳ�����ʬ����Ф�
	(undef,$lang,$period,$value) = split(/\t/,$_,4);
	# �������ȥ��ݥå����������򸫤��������Ͽ���뤫��Ƚ��
	$match_lang   = ($val_lang eq '');
	foreach $lg (@tmp) {
	  $match_lang = ( $match_lang || ($lang =~ m/(?:^|,)$lg(?:$|,)/i) );
	}
	$match_period = ($period >= $val_period);
	# �������Ͽ
	if($match_lang&&$match_period) {
	  $g_index[$i] = "$period\t$value";
	  $i++;
	}
    }

    # �ե�����Υ�����
    close(FILE);
    return($i);
}

###
### ����ǥå����η������
###
sub getindexnum {
    my $i;

    # �ե�����Υ����ץ�
    open(FILE,"<$g_indexfile");

    # ����ǥå������ɤ߹���
    $i = 0;
    while(<FILE>) {
	$i++;
    }

    # �ե�����Υ�����
    close(FILE);
    return($i);
}


##############################
### ���������дط��δؿ� ###
##############################

###
### �ޥå���ʬ�����
###
sub extract {
    my $front = $_[0];        # ����ʸ����ؤλ���(����)
    my $keyword = $_[1];      # �������ʸ����ؤλ���(����)
    my $back = $_[2];         # ����ʸ����ؤλ���(����)
    my $str = "";
    my $rev;
    my $tmp;

    if($utf_mode) {           # �� $$front, $$back��ľ���ѹ����Ƥ���������ա�(EUC-JP���Ȥϰۤʤ롣)
      &utfjp::utf8foldr($front,$f_extract_f);
      &utfjp::utf8fold($back,$f_extract_b);
#      $str = "$$front$$keyword$$back. . . ";
      $str = $$front . $$keyword . $$back . '. . . ';

    } else {
      $rev = reverse($$front);
      ($tmp,undef) = &fold($rev,$f_extract_f);
      $str .= reverse($tmp) . $$keyword;
      ($tmp,undef) = &fold($$back,$f_extract_b);
      $str .= "$tmp. . . ";

    }

    return($str);
}

###
### �ϥ��饤�Ȳ�
###
sub highlight {
    my $str = $_[0];        # �о�ʸ����ؤλ���
    my $hl_open = $_[1];
    my $hl_close = $_[2];
    my $istitle = $_[3];
    my @all = ();
    my $target;

    splice(@all,$#all+1,0,@g_and);
    splice(@all,$#all+1,0,@g_or);
    splice(@all,$#all+1,0,@g_title) if($istitle);
    $target = join("|",@all);
    return if($target eq "");

    if($utf_mode) {         # ��
      $$str =~ s/\G((?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)*?)($target)/$1$hl_open$2$hl_close/g;
    } else {
      $$str =~ s/\G((?:$han1|$hank|$zen2|$zen3)*?)($target)/$1$hl_open$2$hl_close/g;
    }

}

##############################
### ����ե�����ط��δؿ� ###
##############################

###
### ����ե�������ɤ߹��ߤȲ��
###
sub parseconfig {
    # �ե�����Υ����ץ�
    unless(open(FM,"<$g_config")) {
	printerror("&#35373;&#23450;&#12501;&#12449;&#12452;&#12523;&#12364;&#38283;&#12369;&#12414;&#12379;&#12435;"); # "����ե����뤬�����ޤ���" ��
    }

    # ������ɤ߹���
    my $i = 0;              # ��
    while(<FM>) {
	my $line = $_;
        $line =~ s/^$utf8_bom//o if(($i++ == 0) && $utf_mode);  # �� UTF-8��BOM�����
	next if($line =~ /^\#/ || $line =~ /^\n$/);
	if($line =~ /^set/) {
	    pf_set($line);
	    next;
	}
	if($line =~ /^begin (page|result|noresult|previous|next|pset|cset|nset|help)/) { # ��
	    my $type = $1;
	    pf_page($line) if($type eq "page");
	    pf_result($line) if($type eq "result");
	    pf_noresult($line) if(($type eq "noresult") && $utf_mode); # ��
	    pf_previous($line) if($type eq "previous");
	    pf_next($line) if($type eq "next");
	    pf_pset($line) if($type eq "pset");
	    pf_cset($line) if($type eq "cset");
	    pf_nset($line) if($type eq "nset");
	    pf_help($line) if($type eq "help");
	}
    }

    close(FM);
    if(@f_page <= 0) {
	printerror("$mes_format_error(no page definition)"); # ��
    }
    if($f_result eq "") {
	printerror("$mes_format_error(no result definition)"); # ��
    }
    if(($f_noresult eq "") && $utf_mode) { # ��
	printerror("$mes_format_error(no noresult definition)"); # ��
    }
    if($f_previous eq "" && existformat("previous")) {
	printerror("$mes_format_error(no previous definition)"); # ��
    }
    if($f_next eq "" && existformat("next")) {
	printerror("$mes_format_error(no next definition)"); # ��
    }
    if($f_pset eq "" && existformat("pset")) {
	printerror("$mes_format_error(no pset definition)"); # ��
    }
    if($f_cset eq "" && existformat("cset")) {
	printerror("$mes_format_error(no cset definition)"); # ��
    }
    if($f_nset eq "" && existformat("nset")) {
	printerror("$mes_format_error(no nset definition)"); # ��
    }
    if($f_help eq "") {
	printerror("$mes_format_error(no help definition)"); # ��
    }
}

###
### ���̥ե����ޥåȤ�¸�ߥ����å�
###
sub existformat {
    my $format = $_[0];
    my $f;

    foreach $f ( @f_page ) {
	if($f eq $format) {
	    return(1);
	}
    }
    return(0);
}

###
### �ѿ����
###
sub pf_set {
    my $line = $_[0];

    if($line =~
       /\$(home|highlight|highlight_deco|tzdiff|notitle|log|logfile|logencoding|logformat|dateformat|encoding|extract_f|extract_b|alllang|allperiod)=(.*)\n/) {  # ��
	my $var = $1;
	my $val = $2;

	if($var eq "home") {
	    $f_home = $val;
	} elsif($var eq "highlight") {
	    $f_highlight = $val;
	} elsif($var eq "highlight_deco") {
	    $f_highlight_deco = $val;
	} elsif($var eq "tzdiff") {
	    $f_tzdiff = $val;
	} elsif($var eq "notitle") {
	    $f_notitle = $val;
	} elsif($var eq "log") {
	    $f_log = $val;
	} elsif($var eq "logfile") {
	    $f_logfile = $val;
	} elsif($var eq "logencoding") {
	    $f_logencoding = $val unless($utf_mode); # ��
	} elsif($var eq "logformat") {
	    $f_logformat = $val;
	} elsif($var eq "dateformat") {
	    $f_dateformat = $val;
	} elsif($var eq "encoding") {
	    $f_encoding = $val    unless($utf_mode); # ��
	} elsif($var eq "extract_f") {
	    $f_extract_f = $val;
	} elsif($var eq "extract_b") {
	    $f_extract_b = $val;
	} elsif($var eq "alllang") { # ��
	    $f_alllang = $val;
	} elsif($var eq "allperiod") { # ��
	    $f_allperiod = $val;
	}

    }
}

###
### page�ե����ޥåȲ��
###
sub pf_page {
    my $str = "";

    # �ޤ�������Ͽ���ɤ���������å�����
    if(@f_page > 0) {
	printerror("$mes_format_error(page redefinition)"); # ��
    }

    # �Ȥꤢ����end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$str .= $line;
    }

    # ���̥ե����ޥåȤ򸫤Ĥ���
    while($str) {
	if($str =~ /\$\$(result|previous|next|pset|cset|nset)\$\$/) {
	    my $p = $`;
	    my $c = $1;
	    my $n = $';
	    # �ѿ����ޤޤ�Ƥ��뤫�Υ����å�
	    if($p =~ /\$\$[a-z]*\$\$/) {
		push(@f_pageindex,"V");
		push(@f_page,$p);
	    } else {
		if($p !~ /^\n*$/) {
		    push(@f_pageindex,"N");
		    push(@f_page,$p);
		}
	    }

	    # ���̥ե����ޥå�
	    push(@f_pageindex,"F");
	    push(@f_page,"$c");

	    $str = $n;
	} else {
	    # �ѿ����ޤޤ�Ƥ��뤫�Υ����å�
	    if($str =~ /\$\$[a-z]*\$\$/) {
		push(@f_pageindex,"V");
		push(@f_page,$str);
	    } else {
		if($str !~ /^\n*$/) {
		    push(@f_pageindex,"N");
		    push(@f_page,$str);
		}
	    }

	    $str = "";
	}
    }
}

###
### result�ե����ޥåȲ��
###
sub pf_result {
    my $line = $_[0];

    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_result != "") {
	printerror("$mes_format_error(result redefinition)"); # ��
    }

    # ɽ����������
    $line =~ /^begin result ([0-9]*)/;
    $f_result_num = $1;

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_result .= $line;
    }
}

###
### noresult�ե����ޥåȲ�� ��
###
sub pf_noresult {
    my $line = $_[0];

    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_noresult != "") {
	printerror("$mes_format_error(noresult redefinition)"); # ��
    }

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_noresult .= $line;
    }
}

###
### previous�ե����ޥåȲ��
###
sub pf_previous {
    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_previous != "") {
	printerror("$mes_format_error(previous redefinition)"); # ��
    }

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_previous .= $line;
    }
}

###
### next�ե����ޥåȲ��
###
sub pf_next {
    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_next != "") {
	printerror("$mes_format_error(next redefinition)"); # ��
    }

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_next .= $line;
    }
}

###
### pset�ե����ޥåȲ��
###
sub pf_pset {
    my $line = $_[0];

    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_pset != "") {
	printerror("$mes_format_error(pset redefinition)"); # ��
    }

    # ɽ����������
    $line =~ /^begin pset ([0-9]*)/;
    $f_pset_num = $1;

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_pset .= $line;
    }
}

###
### cset�ե����ޥåȲ��
###
sub pf_cset {
    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_cset != "") {
	printerror("$mes_format_error(cset redefinition)"); # ��
    }

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_cset .= $line;
    }
}

###
### nset�ե����ޥåȲ��
###
sub pf_nset {
    my $line = $_[0];

    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_nset != "") {
	printerror("$mes_format_error(nset redefinition)"); # ��
    }

    # ɽ����������
    $line =~ /^begin nset ([0-9]*)/;
    $f_nset_num = $1;

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_nset .= $line;
    }
}

###
### help�ե����ޥåȲ��
###
sub pf_help {
    # �ޤ�������Ͽ���ɤ���������å�����
    if($f_help != "") {
	printerror("$mes_format_error(help redefinition)"); # ��
    }

    # end�ޤ��ɤ߹���
    while(<FM>) {
	my $line = $_;
	next if($line =~ /^\#/);
	last if($line =~ /^end/);
	$f_help .= $line;
    }

    if($f_help =~ /\$\$indexnum\$\$/) {
	$f_exist_indexnum = 1;
    } else {
	$f_exist_indexnum = 0;
    }
}

##################################
### �ե����ޥå��ѿ��ط��δؿ� ###
##################################

###
### CPU���֤�¬��
###
sub getcputime {
    my $cpu_finish = (times)[0];
    $v_cputime = $cpu_finish - $v_cputime;
    $v_cputime = sprintf("%.2f",$v_cputime);     # ��
    if($v_cputime eq '0.00') { $v_cputime='0'; } # ��
}

###
### ����ǥå����κǽ����������μ���
###
sub getindexdate {
    my ($s, $m, $h, $d, $mon, $year);

    ($s,$m,$h,$d,$mon,$year) =
	localtime((stat($g_indexfile))[9] + $f_tzdiff * 3600);

    return(formatdate($f_dateformat,$year,$mon,$d,$h,$m,$s));
}

###
### ���������μ���
###
sub getnowdate {
    my ($s, $m, $h, $d, $mon, $year);

    ($s,$m,$h,$d,$mon,$year) = localtime(time + $f_tzdiff * 3600);

    return(formatdate($f_dateformat,$year,$mon,$d,$h,$m,$s));
}

###
### �ե�����κǽ��������� ��
###
sub getmodifytime {
    my $mtime = $_[0];
    my ($s, $m, $h, $d, $mon, $year);

    ($s,$m,$h,$d,$mon,$year) = localtime($mtime + $f_tzdiff * 3600);

    $year += 1900;
    $mon  += 1;
    $s     = "0$s"    if($s < 10);
    $m     = "0$m"    if($m < 10);
    $h     = "0$h"    if($h < 10);
    $d     = "0$d"    if($d < 10);
    $mon   = "0$mon"  if($mon < 10);

    return($year,$mon,$d,$h,$m,$s);
}

###
### ����ɽ���ե����ޥå�
###
sub formatdate {
    my $f = $_[0];
    my $year = $_[1];
    my $month = $_[2];
    my $day = $_[3];
    my $hour = $_[4];
    my $minute = $_[5];
    my $second = $_[6];

    $year += 1900;
    $month += 1;
    $second = "0$second" if($second < 10);
    $minute = "0$minute" if($minute < 10);
    $hour   = "0$hour"   if($hour < 10);
    $day    = "0$day"    if($day < 10);
    $month  = "0$month"  if($month < 10);

    $f =~ s/year/$year/g;
    $f =~ s/month/$month/g;
    $f =~ s/day/$day/g;
    $f =~ s/hour/$hour/g;
    $f =~ s/minute/$minute/g;
    $f =~ s/second/$second/g;

    return($f);
}


######################
### ���ϴط��δؿ� ###
######################

###
### HTML Content-type����
###
sub printcontenttype {

 if($utf_mode) {  # ��
  print "Content-type: text/html;charset=$f_encoding\n\n"; # UTF-8��BOM���դ��ʤ���
 } else {
  print "Content-type: text/html;charset=$f_encoding\n\n";
 }

}

###
### ���顼�ѽ���
###
### ��å�������ɬ��ASCIIʸ��������ɽ�����Ƥ�����������
### ����ʸ����ޤ���ʸ���������ޤ���
###
sub printerror {
    my $message = $_[0];	# ���顼��å�����(����)

    if($utf_mode) {             # ��
      # No operation
    } else {
      if($f_encoding eq "shift_jis") {
        &jcode::convert(\$message,"sjis");
      } elsif($f_encoding eq "iso-2022-jp") {
        &jcode::convert(\$message,"jis");
      }
    }
    print "<p><h2><font color=red>$message</font></h2>\n";
    print "</body></html>";
    exit;
}

###
### ������̥ڡ����ν���
###
sub printpage {
    my ($i, $q, $h, $lg, $pd); # ��

    # ɽ�����
    $v_displaynum = $#match + 1;

    # ɽ������Ƭ�����ֹ�ȸ��������ֹ�
    if($v_total == 0) {
	$v_from = 0;
    } else {
	$v_from = $d_start + 1;
    }
    $v_to = $d_start + $v_displaynum;

    # �����꡼�Υ��󥳡��ǥ���
    $q = $v_query;
    $q =~ s/([^\w ])/'%' . unpack('H2',$1)/eg;
    $q =~ tr/ /+/;

    # ���ҥ��ʸ����Υ��󥳡��ǥ���
    if($utf_mode && ($v_hint ne "")) {
      $h = $v_hint;
      $h =~ s/([^\w ])/'%' . unpack('H2',$1)/eg;
      $h =~ tr/ /+/;
    }

    # ���������Υ��󥳡��ǥ���
    if($utf_mode && ($v_lang ne "")) {
      $lg = $v_lang;
      $lg =~ s/([^\w ])/'%' . unpack('H2',$1)/eg;
      $lg =~ tr/ /+/;
    }

    # ���������־���Υ��󥳡��ǥ���
    if($utf_mode && ($v_period ne "")) {
      $pd = $v_period;
      $pd =~ s/([^\w ])/'%' . unpack('H2',$1)/eg;
      $pd =~ tr/ /+/;
    }

    # cgi�ƤӽФ��Ƕ��̤���ʬ
    $cgicall = "$v_msearch?";
    $cgicall .= "index=$v_index&amp;" if($v_index); # ��
    $cgicall .= "config=$v_config&amp;" if($v_config); # ��
    $cgicall .= "hint=$h&amp;" if($utf_mode && ($v_hint ne "")); # ��
    $cgicall .= "lang=$lg&amp;" if($utf_mode && ($v_lang ne "")); # ��
    $cgicall .= "period=$pd&amp;" if($utf_mode && ($v_period ne "")); # ��
    $cgicall .= "query=$q&amp;num=$v_rpp"; # ��

    # ���åȿ��η׻�
    if($v_rpp != 0) {
	$tset = int($v_total / $v_rpp) + 1;
	$tset-- if(($v_total % $v_rpp) == 0);
    } else {
	$tset = 1;
    }
    if($v_total == 0) {
	$tset = -1;
    }

    # �����꡼�Υ��˥�������
    $v_query =~ s/&/&amp;/g;
    $v_query =~ s/</&lt;/g;
    $v_query =~ s/>/&gt;/g;
    $v_query =~ s/"/&quot;/g;
    $v_query =~ s/'/&#39;/g;

    # ���������(���ߥ����α�¦)�Υ��˥�������
    $cap_lang =~ s/&/&amp;/g;
    $cap_lang =~ s/</&lt;/g;
    $cap_lang =~ s/>/&gt;/g;
    $cap_lang =~ s/"/&quot;/g;
    $cap_lang =~ s/'/&#39;/g;

    # ���������־���(���ߥ����α�¦)�Υ��˥�������
    $cap_period =~ s/&/&amp;/g;
    $cap_period =~ s/</&lt;/g;
    $cap_period =~ s/>/&gt;/g;
    $cap_period =~ s/"/&quot;/g;
    $cap_period =~ s/'/&#39;/g;

    # ���������(���ߥ����κ���ξ¦)�Υ��˥�������
    $v_lang =~ s/&/&amp;/g;
    $v_lang =~ s/</&lt;/g;
    $v_lang =~ s/>/&gt;/g;
    $v_lang =~ s/"/&quot;/g;
    $v_lang =~ s/'/&#39;/g;

    # ���������־���(���ߥ����κ���ξ¦)�Υ��˥�������
    $v_period =~ s/&/&amp;/g;
    $v_period =~ s/</&lt;/g;
    $v_period =~ s/>/&gt;/g;
    $v_period =~ s/"/&quot;/g;
    $v_period =~ s/'/&#39;/g;

    for($i=0;$i<@f_page;$i++) {
	if($f_pageindex[$i] eq "N") {
	    # �ե����ޥå��ѿ����ʤ���ʬ
            unless($utf_mode) {  # ��
              if($f_encoding eq "shift_jis") {
                &jcode::convert(\$f_page[$i],"sjis");
              } elsif($f_encoding eq "iso-2022-jp") {
                &jcode::convert(\$f_page[$i],"jis");
              }
            }
	    print $f_page[$i];
	} elsif($f_pageindex[$i] eq "V") {
	    # �ե����ޥå��ѿ���������ʬ
	    $f_page[$i] =~ s/\$\$encoding\$\$/$f_encoding/g;
	    $f_page[$i] =~ s/\$\$msearch\$\$/$v_msearch/g;
	    $f_page[$i] =~ s/\$\$home\$\$/$v_home/g;
	    $f_page[$i] =~ s/\$\$query\$\$/$v_query/g;
	    $f_page[$i] =~ s/\$\$index\$\$/$v_index/g;
	    $f_page[$i] =~ s/\$\$config\$\$/$v_config/g;
	    $f_page[$i] =~ s/\$\$rpp\$\$/$v_rpp/g;
	    $f_page[$i] =~ s/\$\$total\$\$/$v_total/g;
	    $f_page[$i] =~ s/\$\$set\$\$/$v_set/g;
	    $f_page[$i] =~ s/\$\$from\$\$/$v_from/g;
	    $f_page[$i] =~ s/\$\$to\$\$/$v_to/g;
	    $f_page[$i] =~ s/\$\$displaynum\$\$/$v_displaynum/g;
	    $f_page[$i] =~ s/\$\$cputime\$\$/$v_cputime/g;
	    $f_page[$i] =~ s/\$\$indexdate\$\$/$v_indexdate/g;
	    $f_page[$i] =~ s/\$\$indexnum\$\$/$v_indexnum/g;
	    $f_page[$i] =~ s/\$\$nowdate\$\$/$v_nowdate/g;
	    $f_page[$i] =~ s/\$\$msearchhp\$\$/$v_msearchhp/g;
	    $f_page[$i] =~ s/\$\$version\$\$/$v_version/g;
	    $f_page[$i] =~ s/\$\$fontbold\$\$/$fontbold/g;                   # ��
	    $f_page[$i] =~ s/\$\$langname\$\$/$cap_lang/g if($utf_mode);     # ��
	    $f_page[$i] =~ s/\$\$periodname\$\$/$cap_period/g if($utf_mode); # ��
	    $f_page[$i] =~ s/\$\$lang\$\$/$v_lang/g if($utf_mode);           # ��
	    $f_page[$i] =~ s/\$\$period\$\$/$v_period/g if($utf_mode);       # ��
        if($v_total == 0 && $utf_mode) { # �� <noresult>���������ν���
          $f_page[$i] =~ s{<noresult.*?>.*?</noresult>}{}gis;
        } else {
          $f_page[$i] =~ s{</?noresult.*?>}{}gi;
        }
        if($val_lang eq '' && $utf_mode) { # �� <lang>���������ν���
          $f_page[$i] =~ s{<lang.*?>.*?</lang>}{}gis;
        } else {
          $f_page[$i] =~ s{</?lang.*?>}{}gi;
        }
        if($val_period == 0 && $utf_mode) { # �� <period>���������ν���
          $f_page[$i] =~ s{<period.*?>.*?</period>}{}gis;
        } else {
          $f_page[$i] =~ s{</?period.*?>}{}gi;
        }
            unless($utf_mode) { # ��
              if($f_encoding eq "shift_jis") {
                &jcode::convert(\$f_page[$i],"sjis");
              } elsif($f_encoding eq "iso-2022-jp") {
                &jcode::convert(\$f_page[$i],"jis");
              }
            }
	    print $f_page[$i];
	} elsif($f_pageindex[$i] eq "F") {
	    # ���̥ե����ޥåȤξ��
	    if($f_page[$i] eq "result") {
		# result�ե����ޥåȤξ��
		printresult();
	    } elsif($f_page[$i] eq "previous") {
		# previous�ե����ޥåȤξ��
		printprevious();
	    } elsif($f_page[$i] eq "next") {
		# next�ե����ޥåȤξ��
		printnext();
	    } elsif($f_page[$i] eq "pset") {
		# pset�ե����ޥåȤξ��
		printpset();
	    } elsif($f_page[$i] eq "cset") {
		# cset�ե����ޥåȤξ��
		printcset();
	    } elsif($f_page[$i] eq "nset") {
		# nset�ե����ޥåȤξ��
		printnset();
	    }
	}
    }
}

###
### �إ�ץڡ����ν���
###
sub printhelp {
    $f_help =~ s/\$\$encoding\$\$/$f_encoding/g;
    $f_help =~ s/\$\$msearch\$\$/$v_msearch/g;
    $f_help =~ s/\$\$home\$\$/$v_home/g;
    $f_help =~ s/\$\$index\$\$/$v_index/g;
    $f_help =~ s/\$\$config\$\$/$v_config/g;
    $f_help =~ s/\$\$rpp\$\$/$v_rpp/g;
    $f_help =~ s/\$\$cputime\$\$/$v_cputime/g;
    $f_help =~ s/\$\$indexdate\$\$/$v_indexdate/g;
    $f_help =~ s/\$\$indexnum\$\$/$v_indexnum/g;
    $f_help =~ s/\$\$nowdate\$\$/$v_nowdate/g;
    $f_help =~ s/\$\$msearchhp\$\$/$v_msearchhp/g;
    $f_help =~ s/\$\$version\$\$/$v_version/g;
    $f_help =~ s/\$\$fontbold\$\$/$fontbold/g;  #  ��
    unless($utf_mode) {  # ��
      if($f_encoding eq "shift_jis") {
        &jcode::convert(\$f_help,"sjis");
      } elsif($f_encoding eq "iso-2022-jp") {
        &jcode::convert(\$f_help,"jis");
      }
    }
    print $f_help;
}

###
### result�ե����ޥåȤν���
###
sub printresult {
    my ($i, $orgurl, $format);
    my ($resultnum, $mtime, $fsize, $url, $title, $summary); # ��
    my ($year,$month,$day,$hour,$minute,$second); # ��
    my $reghl = "";           # URL�ϥ��饤�Ȳ�������ɽ��

    # 0��ҥåȻ��Υ�å���������  ��
    if($v_total == 0 && $utf_mode) {
      $format = $f_noresult;
      $format =~ s/\$\$query\$\$/$v_query/g;
      print "$format";
      return;
    }

    # URL�ϥ��饤���Ѥ�����ɽ������
    $reghl = join("|",@g_url) if(@g_url);

    for($i=0;$i<@match;$i++) {
	# �ե����ޥåȤν����
	$format = $f_result;

	# 1���ܼ��Ф�
	($mtime,$fsize,$orgurl,$title,$summary) = split(/\t/,$match[$i]); # ��

	# �Ĥ�Υե����ޥå��ѿ��ΥХ����
	$resultnum = $v_from + $i;
	$url = $orgurl;
	if($reghl ne "") {
	    $url =~ s/($reghl)/$hl_open\1$hl_close/g;
	}
	$title = $f_notitle if($title eq "");

	# �ǽ����������μ��� ��
	($year,$month,$day,$hour,$minute,$second) = getmodifytime($mtime);

	# �ե����륵������ñ���Ѵ� ��
	$fsize = int($fsize / 1024); # byte -> KByte

	# �ե����ޥå��ѿ����ִ�
	$format =~ s/\$\$resultnum\$\$/$resultnum/g;
	$format =~ s/\$\$url\$\$/$orgurl/g;
	$format =~ s/\$\$urldeco\$\$/$url/g;
	$format =~ s/\$\$title\$\$/$title/g;
	$format =~ s/\$\$summary\$\$/$summary/g;
	$format =~ s/\$\$rpp\$\$/$v_rpp/g;
	$format =~ s/\$\$mtyear\$\$/$year/g; # ��
	$format =~ s/\$\$mtmonth\$\$/$month/g; # ��
	$format =~ s/\$\$mtday\$\$/$day/g; # ��
	$format =~ s/\$\$mthour\$\$/$hour/g; # ��
	$format =~ s/\$\$mtminute\$\$/$minute/g; # ��
	$format =~ s/\$\$mtsecond\$\$/$second/g; # ��
	$format =~ s/\$\$filesize\$\$/$fsize/g; # ��

        unless($utf_mode) {  # ��
          if($f_encoding eq "shift_jis") {
            &jcode::convert(\$format,"sjis");
          } elsif($f_encoding eq "iso-2022-jp") {
            &jcode::convert(\$format,"jis");
          }
        }
	print $format;
    }
}

###
### previous�ե����ޥåȤν���
###
sub printprevious {
    my ($p, $previousurl, $format);

    # �����åȤ�1�ξ��Ͻ��Ϥ��ʤ�
    return if($v_set == 1);

    # ����ɽ���ξ��Ͻ��Ϥ��ʤ�
    return if($v_rpp == 0);

    # ������̤�0��ξ��Ͻ��Ϥ��ʤ�
    return if($tset == -1);

    # �ե����ޥå��ѿ��ΥХ����
    $p = $v_set - 1;
    $previousurl = "$cgicall&amp;set=$p"; # ��

    # �ե����ޥå��ѿ����ִ�
    $format = $f_previous;
    $format =~ s/\$\$previousurl\$\$/$previousurl/g;
    $format =~ s/\$\$rpp\$\$/$v_rpp/g;

    unless($utf_mode) {  # ��
      if($f_encoding eq "shift_jis") {
        &jcode::convert(\$format,"sjis");
      } elsif($f_encoding eq "iso-2022-jp") {
        &jcode::convert(\$format,"jis");
      }
    }
    print $format;
}

###
### next�ե����ޥåȤν���
###
sub printnext {
    my ($n, $nexturl, $format);

    # �����åȤ��ǽ����åȤξ��Ͻ��Ϥ��ʤ�
    return if($v_set == $tset);

    # ����ɽ���ξ��Ͻ��Ϥ��ʤ�
    return if($v_rpp == 0);

    # ������̤�0��ξ��Ͻ��Ϥ��ʤ�
    return if($tset == -1);

    # �ե����ޥå��ѿ��ΥХ����
    $n = $v_set + 1;
    $nexturl = "$cgicall&amp;set=$n"; # ��

    # �ե����ޥå��ѿ����ִ�
    $format = $f_next;
    $format =~ s/\$\$nexturl\$\$/$nexturl/g;
    $format =~ s/\$\$rpp\$\$/$v_rpp/g;

    unless($utf_mode) { # ��
      if($f_encoding eq "shift_jis") {
        &jcode::convert(\$format,"sjis");
      } elsif($f_encoding eq "iso-2022-jp") {
        &jcode::convert(\$format,"jis");
      }
    }
    print $format;
}

###
### pset�ե����ޥåȤν���
###
sub printpset {
    my ($i, $setnum, $seturl, $format);

    # ������̤�0��ξ��Ͻ��Ϥ��ʤ� ��(AM0����ޤ����Ǥι��������긡������ȯ�������륨�顼�к�)
    return if($tset == -1);

    for($i=0;$i<$f_pset_num;$i++) {
	$setnum = $v_set - $f_pset_num + $i;
	next if($setnum < 1);  # �裱���åȰ�����̵��
	$seturl = "$cgicall&amp;set=$setnum"; # ��

	# �ե����ޥå��ѿ����ִ�
	$format = $f_pset;
	$format =~ s/\$\$seturl\$\$/$seturl/g;
	$format =~ s/\$\$setnum\$\$/$setnum/g;
	$format =~ s/\$\$rpp\$\$/$v_rpp/g;
	$format =~ s/\n$//mg; # ��

        unless($utf_mode) { # ��
          if($f_encoding eq "shift_jis") {
            &jcode::convert(\$format,"sjis");
          } elsif($f_encoding eq "iso-2022-jp") {
            &jcode::convert(\$format,"jis");
          }
        }
	print $format;
    }
}

###
### cset�ե����ޥåȤν���
###
sub printcset {
    my $format;

    # ������̤�0�狼��̥��åȤ�1�ڡ����ξ��Ͻ��Ϥ��ʤ�
    return if($tset == -1 || $tset == 1);

    # ����ɽ���ξ��Ͻ��Ϥ��ʤ�
    return if($v_rpp == 0);

    # �ե����ޥå��ѿ����ִ�
    $format = $f_cset;
    $format =~ s/\$\$set\$\$/$v_set/g;
    $format =~ s/\$\$rpp\$\$/$v_rpp/g;

    unless($utf_mode) {  # ��
      if($f_encoding eq "shift_jis") {
        &jcode::convert(\$format,"sjis");
      } elsif($f_encoding eq "iso-2022-jp") {
        &jcode::convert(\$format,"jis");
      }
    }
    print $format;
}

###
### nset�ե����ޥåȤν���
###
sub printnset {
    my ($i, $setnum, $seturl, $format);

    # ������̤�0��ξ��Ͻ��Ϥ��ʤ� ��(AM0����ޤ����Ǥι��������긡������ȯ�������륨�顼�к�)
    return if($tset == -1);

    for($i=0;$i<$f_nset_num;$i++) {
	$setnum = $v_set + $i + 1;
	last if($setnum > $tset);  # �ǽ����åȰʹߤ�̵��
	$seturl = "$cgicall&amp;set=$setnum"; # ��

	# �ե����ޥå��ѿ����ִ�
	$format = $f_nset;
	$format =~ s/\$\$seturl\$\$/$seturl/g;
	$format =~ s/\$\$setnum\$\$/$setnum/g;
	$format =~ s/\$\$rpp\$\$/$v_rpp/g;
	$format =~ s/\n$//mg; # ��

        unless($utf_mode) {  # ��
          if($f_encoding eq "shift_jis") {
            &jcode::convert(\$format,"sjis");
          } elsif($f_encoding eq "iso-2022-jp") {
            &jcode::convert(\$format,"jis");
          }
        }
	print $format;
    }
}

###
### ���ν���
###
sub outputlog {
    my $ua = $ENV{'HTTP_USER_AGENT'};
    my ($str, $remote);

    $remote = gethostname($ENV{'REMOTE_ADDR'}) if($f_logformat =~ /remote/);

    # ��å�����
    if(mylock() != 1) {
	printerror("&#12525;&#12483;&#12463;&#12395;&#22833;&#25943;&#12375;&#12414;&#12375;&#12383;"); # "��å��˼��Ԥ��ޤ���" ��
    }

    # ���ե�����Υ����ץ�
    open(LF,">>$f_logfile") or printerror("&#12525;&#12464;&#12501;&#12449;&#12452;&#12523;&#12364;&#38283;&#12369;&#12414;&#12379;&#12435;"); # "���ե����뤬�����ޤ���" ��
    if($utf_mode) {  # �� ���ե�����ؤν����ϻ���UTF-8 BOM����ϡ�
      my @finfo = stat $f_logfile;
      if($finfo[7] == 0) { print LF "$utf8_bom"; }
    }

    # ���ν񤭽Ф�
    $str = $f_logformat;
    $str =~ s/date/$v_nowdate/g;
    $str =~ s/remote/$remote/g;
    $str =~ s/ua/$ua/g;
    $str =~ s/hit/$v_total/g;
    $str =~ s/query/$v_query/g;
    $str =~ s/lang/$cap_lang/g; # ��
    $str =~ s/period/$cap_period/g; # ��
    $str =~ s/\\n/\n/g;
    $str =~ s/\\t/\t/g;
    unless($utf_mode) {  # ��
      if($f_logencoding eq "shift_jis") {
        &jcode::convert(\$str,"sjis");
      } elsif($f_logencoding eq "iso-2022-jp") {
        &jcode::convert(\$str,"jis");
      }
    }
    print LF "$str";

    # ���ե�����Υ�����
    close(LF);

    myunlock();
}

###
### �ۥ���̾�εհ��� ��
###
sub gethostname {
    my $ip = $_[0];            # REMOTE_ADDR����
    my $packedaddr;
    my $host = '';

    if ($ip =~ /^\d+\.\d+\.\d+\.\d+$/) { # IPv4���ɥ쥹�ξ��Τߵհ������롣
      $packedaddr = pack("C4",split(/\./,$ip));
      ($host,undef,undef,undef,undef) = gethostbyaddr($packedaddr,2);
    }

    if($host ne "") {
	return("$host($ip)");
    } else {
	return($ip);
    }
}

###
### �����ʥ�ϥ�ɥ顼
###
sub sighandler {
    my $sig = $_[0];            # �����ʥ�μ���(����)

    if(-d $g_lock) {
        rmdir($g_lock);
    }
    exit;
}

###
### ��å�����(flock���ʤ��Ƥ�OK)
###
sub mylock {
    my ($alivetime, $i);

    # ��å���������Ԥ��Ƥ������������
    $alivetime = time() - (stat($g_lock))[9];
    if($alivetime > 60) {
        rmdir($g_lock);
    }

    # 3��(3��)�ޤǥ�å������Υ�ȥ饤����
    for($i=0;$i<3;$i++) {
        if(mkdir($g_lock,0777)) {
            # �����ʥ�ϥ�ɥ顼����Ͽ
            $SIG{'TERM'} = \&sighandler;
            $SIG{'INT'} = \&sighandler;
            $SIG{'PIPE'} = \&sighandler;
            $SIG{'HUP'} = \&sighandler;
            $SIG{'QUIT'} = \&sighandler;
            return(1);
        } else {
            sleep(1);           # �Ԥ�
        }
    }

    return(0);
}

###
### �����å�
###
sub myunlock {
    if(-d $g_lock) {
        rmdir($g_lock);
    }
}
