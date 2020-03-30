#!/usr/local/bin/perl
#=============================================================================#
#                                                                             #
#                        msearch - mat's search program                       #
#                                 version 1.52(U5)                            #
#                                                                             #
#                  Ķ�ʰץ���ǥå����Ǹ������󥸥�ץ����                 #
#       Copyright (C) 2000-2016, Katsushi Matsuda. All Right Reserved.        #
#                                                  Modified by ��ή����       #
#                                                                             #
#=============================================================================#

#=============================================================================#
#                             ����ǥå�������CGI                             #
#=============================================================================#

#=============================================================================#
# �� <- �ܲ��Ǥ��Ф��뽤�����ɵ��ս�ˤ��ܰ��Ȥ��ơ����դ��Ƥ��롣
# [��ջ���]
#  �ܥ�����ץȤϡ�EUC+LF(ʸ�������ɡ�EUC�����ԥ����ɡ�LF)����¸���뤳�ȡ�
#
# [ư��⡼�ɤ����]
# $utf_mode=1��   UTF-8��msearch�Ȥ���ư�

$utf_mode=1;

#
#=============================================================================#

if($utf_mode) { # ��
  require './utfjp.pl';           # ���ܸ�ʸ��������-Unicode�Ѵ��饤�֥��
  &utfjp::mappingmode('j2u');     # �ޥåԥ󥰥ơ��֥��JIS ->Unicode�����Τߤˤ��롣
  require './indexing.pl';        # ����ǥå��������⥸�塼��
} else {
  require './jcode.pl';           # �����������Ѵ��ѥå�����
  require './indexing.pl';        # ����ǥå��������⥸�塼��
}

####################
### �ѹ���ǽ�ѿ� ###
####################

### �ǥХå����ˤΤ����ꤷ�Ʋ�������
### 0 - �ǥХå�������Ϥʤ�
### 1 - ���Ϥ���
$debug = 0;

### ����ǥå��������������Υѥ���ɤ����ꤷ�Ʋ�������
$g_password = "msearchpass";

$g_index = "default";           # �ǥե���ȥ���ǥå���̾
$body_background = "";		# �طʤβ���
$body_bgcolor = "white";	# �طʤο�
$body_text = "black";		# ʸ���ο�
$body_link = "blue";		# ̤��ã��󥯤ο�
$body_alink = "red";		# ��ư���󥯤ο�
$body_vlink = "blue";		# ��ã�ѥ�󥯤ο�
$title_generate = "msearch / genindex / ����ǥå��������ե�����";
$title_control = "msearch / genindex / ����ǥå���������˥塼";
$title_result = "msearch / genindex / �¹�";
$g_cgi = "genindex.cgi";	# ����CGI�ץ����
$g_cookie = "1";		# ���å�����Ȥ���
$g_cookie_span = "60";		# ���å�����ͭ������(����)

##################
### �ᥤ����� ###
##################

### �����μ����ȥѡ�����
$arg = getargument();
$qarg = parseargument($arg);

### ���å����μ����ȥѡ�����
$chash = parsecookie() if($g_cookie == 1);

### �Хåե���󥰤����
$io = select(STDOUT);
$| = 1;
select($io);

### �⡼������
if($qarg->{'mode'} eq "control") {
    ### ����ǥå�������ġ���⡼��
    if($qarg->{'action'} ne "") {
	## ����ġ��륳�ޥ�ɼ¹�(���å����Ͻ��Ϥ��ʤ�)
	# HTML��Content-type����Ϥ���
	printcontenttype();
	# �إå����ν���
	printheader($title_result);
	# �ѥ���ɤΥ����å�
	if(checkpassword() != 1) {
	    print "<font color=red>�ѥ���ɤ��㤤�ޤ�</font>\n";
	    exit;
	}
	## �ƥ��������ˤ�äƽ�����ʬ�� 
	if($qarg->{'action'} eq "get") {
	    ## �������
	    doget();
	} elsif($qarg->{'action'} eq "delete") {
	    ## ����ǥå������
	    dodelete();
	} elsif($qarg->{'action'} eq "make") {
	    ## ������ǥå�������
	    domake();
	} elsif($qarg->{'action'} eq "combine") {
	    ## ����ǥå������
	    docombine();
	} else {
	    ## �����ʥ��������
	}
	# �եå����ν���
	printfooter();
    } else {
	## ����ġ������(���å����Ͻ��Ϥ��ʤ�)
	# HTML��Content-type����Ϥ���
	printcontenttype();
	# �إå����ν���
	printheader($title_control);
	# ����ġ���ν���
	printmenu();
	# �եå����ν���
	printfooter();
    }
} else {
    ## ����ǥå��������⡼��
    if($qarg->{'includedir'} ne "" && $qarg->{'includeurl'} ne "" &&
       $qarg->{'conf'} ne "") {
	## ����ǥå�������(���å����Ͻ��Ϥ���)
	# �ǥХå��⡼�ɤΥ����å�
	if($qarg->{'debug'} ne "") {
	    $debug = $qarg->{'debug'};
	}
	# $qarg->{'rescuealt'}��indexing.pl��ľ�ܻ��Ȥ���
	# ���å�������Ϥ���
	printallcookie() if($g_cookie == 1);
	# HTML��Content-type����Ϥ���
	printcontenttype();
	# �إå����ν���
	printheader($title_result);
	# �ѥ���ɤΥ����å�
	if(checkpassword() != 1) {
	    print "<font color=red>�ѥ���ɤ��㤤�ޤ�</font>\n";
	    exit;
	}
	# �󥤥�ǥå����оݥ�����ɤ�UTF-8���Ѵ����� ��
	if($utf_mode) {
	    my $tmpstr = $qarg->{'excludekey'};
	    &utfjp::convert(\$tmpstr,"utf8","euc");
	    $qarg->{'excludekey'} = $tmpstr;
	}
	# ����ǥå��������ƤӽФ� ��
	if($qarg->{'onebyone'} ne "") {
	  makeindex_onebyone();
	} else {
	  makeindex();
	}
	# �եå����ν���
	printfooter();
    } else {
	## ����ǥå�����������(���å����Ͻ��Ϥ��ʤ�)
	# HTML��Content-type����Ϥ���
	printcontenttype();
	# �إå����ν���
	printheader($title_generate);
	# �����ե�����ν���
	printform();
	# �եå����ν���
	printfooter();
    }
}

### ��λ
exit;

################################
### genindex.cgi�˸�ͭ�δؿ� ###
################################

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
		$value =~ s/ //g;
		# Ʊ��°����ʣ���������','�ǷҤ�
		if(defined $qarg{$attribute}) {
			$qarg{$attribute} .= ",$value";
		} else {
			$qarg{$attribute} = $value;
		}
	}
	return \%qarg;
}

###
### ���å����Υѡ���
###
sub parsecookie {
    my %cookies;		# �ѡ�����̤Υϥå���(�����)
    my @avpairs;		# °��-�ͥڥ�������
    my $avpair;			# °��-�ͥڥ�
    my $attribute;		# °��
    my $value;			# ��

    @avpairs = split(/; /,$ENV{'HTTP_COOKIE'});
    for $avpair (@avpairs) {
	# °�����ͤ�ʬ��
	($attribute,$value) = split(/=/,$avpair);
	# ����Υǥ�����
	$value =~ tr/+/ /;
	# �ͤΥǥ�����
	$value =~ s/%([\da-fA-F]{2})/pack("C",hex($1))/ge;
	$cookies{$attribute} = $value;
    }
    return \%cookies;
}

###
### �ѥ���ɤΥ����å�
###
sub checkpassword {
    my $t_pass = "";

    if($qarg->{'conf'} ne "") {
	$t_pass = $qarg->{'conf'};
	&jcode::convert(\$t_pass,"euc","","");
	if($g_password eq $t_pass) {
	    # �ѥ���ɤ���äƤ���
	    return(1);
	} else {
	    # �ѥ���ɤ���äƤ���
	    return(0);
	}
    } else {
	# �ѥ���ɤ���äƤ���
	return(0);
    }
}

###
### ���ƤΥ��å�������Ϥ���
###
sub printallcookie {
    if($qarg->{'index'} ne "") {
	printcookie('index',$qarg->{'index'},$g_cookie_span);
    }
    if($qarg->{'includedir'} ne "") {
	printcookie('includedir',$qarg->{'includedir'},$g_cookie_span);
    }
    if($qarg->{'includeurl'} ne "") {
	printcookie('includeurl',$qarg->{'includeurl'},$g_cookie_span);
    }
    if($qarg->{'suffix'} ne "") {
	printcookie('suffix',$qarg->{'suffix'},$g_cookie_span);
    }
    if($qarg->{'excludedir'} ne "") {
	printcookie('excludedir',$qarg->{'excludedir'},$g_cookie_span);
    }
    if($qarg->{'excludefile'} ne "") {
	printcookie('excludefile',$qarg->{'excludefile'},$g_cookie_span);
    }
    if($qarg->{'excludekey'} ne "") {
	printcookie('excludekey',$qarg->{'excludekey'},$g_cookie_span);
    }
    if($qarg->{'sort'} ne "") {
	printcookie('sort',$qarg->{'sort'},$g_cookie_span);
    }
    if($qarg->{'rescuealt'} ne "") {
	printcookie('rescuealt',$qarg->{'rescuealt'},$g_cookie_span);
    }
}

###
### ���å����ν���
###
sub printcookie {
    my $attribute = $_[0];	# °��̾(����)
    my $value = $_[1];		# ��(����)
    my $timespan = $_[2];	# expire�ޤǤλ���(ñ��=��)(����)
    my @week = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
    my @month = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
    my ($sec,$min,$hour,$day,$mon,$year,$wday);

    # �ͤΥ��󥳡��ǥ���
    $value =~ s/(\W)/sprintf("%%%02X", unpack("C", $1))/ge;
    # expire���κ���
    ($sec,$min,$hour,$day,$mon,$year) = gmtime();
    $year += 1900;
    plusday(\$year,\$mon,\$day,$timespan); # ������η׻�
    $wday = $week[&dayweek($year,$mon,$day)]; # �����η׻�
    $mon = $month[$mon];
    $hour = "0" . $hour if($hour < 10);
    $min = "0" . $min if($min < 10);
    $sec = "0" . $sec if($sec < 10);

    # ����
    print "Set-Cookie: $attribute=$value; ";
    print "expires=$wday, $day-$mon-$year $hour:$min:$sec GMT;\n";
}

###
### �������֤��ؿ�
###
sub dayweek {
    my $year = $_[0];		# ǯ(����)
    my $month = $_[1];		# ��(����) [0....11]
    my $day = $_[2];		# ��(����)
    my $dayweek;		# ����(�����) [0...6]

    $month++;
    if($month < 3) {
	$year--;
	$month += 12;
    }
    $dayweek = ($year + $year/4 - $year/100 + $year/400 +
		(13 * $month + 8)/5 + $day) % 7;
    return($dayweek);
}

###
### ���뤦ǯ���ɤ������֤��ؿ�(1:��ǯ��0:ʿǯ)
###
sub isuruu {
    my $year = $_[0];		# ǯ(����)

    if(($year%4) == 0) {
	if(($year%400) == 0) {
	    return(1);
	} elsif(($year%100) == 0) {
	    return(0);
	} else {
	    return(1);
	}
    } else {
	return(0);
    }
}

###
### ���������鲿�����׻�����
###
sub plusday {
    my $year = $_[0];		# ǯ�ؤλ���(����)
    my $month = $_[1];		# ��ؤλ���(����) [0....11]
    my $day = $_[2];		# ���ؤλ���(����)
    my $span = $_[3];		# ­����(����)
    my @mday = (31,28,31,30,31,30,31,31,30,31,30,31);

    while($span > 0) {
	my $thismonth = $mday[$$month];	# ���ߤη�κǽ���
	$mday[1] += 1 if($$month == 1 && isuruu($$year) == 1); # ���뤦ǯ��2��

	if($thismonth - $$day < $span) {
	    # ���η��
	    $span -= $thismonth - $$day + 1;
	    $$day = 1;
	    $$month++;
	    if($$month > 11) {
		# ����ǯ��
		$$month = 0;
		$$year++;
	    }
	} else {
	    # ���η������­����
	    $$day += $span;
	    $span = 0;
	}
    }
}

###
### �������
###
sub doget {
    my @files = ();
    my $file = "";

    print "<font color=blue>����ġ���⡼�ɤؤϡ��֥饦���Ρ����פ���äƲ�������</font><p>\n";
    print "<b>SERVER_NAME</b> = $ENV{SERVER_NAME}<br>\n";
    print "<b>HTTP_HOST</b> = $ENV{HTTP_HOST}<br>\n";
    print "<b>SERVER_SOFTWARE</b> = $ENV{SERVER_SOFTWARE}<br>\n";
    print "<b>DOCUMENT_ROOT</b> = $ENV{DOCUMENT_ROOT}<br>\n";
    print "<b>SCRIPT_FILENAME</b> = $ENV{SCRIPT_FILENAME}<br>\n";
    print "<b>SCRIPT_NAME</b> = $ENV{SCRIPT_NAME}<br>\n";
    if(exists $ENV{MOD_PERL}) {
	print "<b>MOD_PERL VERSION</b> = $ENV{MOD_PERL}<br>\n";
    } else {
	print "<b>PERL VERSION</b> = $]<br>\n";
    }
    print "<b>PROCESS ID</b> = $$<br>\n";
    print "<b>REAL USER ID</b> = $<(" . user($<) . ")<br>\n";
    print "<b>EFFECTIVE USER ID</b> = $>(" . user($>) . ")<br>\n";
    print "<b>REAL GROUP ID</b> = $( " . group($() . "<br>\n";
    print "<b>EFFECTIVE GROUP ID</b> = $) " . group($)) . "<br>\n";
    print "<b>HTTP_USER_AGENT</b> = $ENV{HTTP_USER_AGENT}<br>\n";
    print "<b>CURRENT DIR</b> = " . mypwd() . "<br>\n";
    print "<p>\n";
    print "<table border=1 cellspacing=0 cellpadding=0 cols=1><tr><td>\n";
    print "<table border=0 cols=2>\n";
    print "<tr><th>index name</th><th>file name</th></tr>\n";
    opendir(P,".");
    @files = readdir(P);
    closedir(P);
    foreach $file (@files) {
	if($file =~ /\.idx$/i) {
	    my $i = $file;
	    $i =~ s/\.idx$//i;
	    print "<tr><td>$i</td><td>$file</td>\n";
	}
    }
    print "</table></td></tr></table>\n";
    print "<p>\n";
    print "<table border=1 cellspacing=0 cellpadding=0 cols=1><tr><td>\n";
    print "<table border=0 cols=6>\n";
    print "<tr><th>mode</th><th>user</th><th>group</th>";
    print "<th>size</th><th>last modified</th><th>file name</th></tr>\n";
    foreach $file (@files) {
	my @tmp = stat("./$file");
	print "<tr>\n";
	print "<td>" . getmode("./$file",$tmp[2]) . "</td>\n";
	print "<td>" . user($tmp[4]) . "</td>\n";
	print "<td>" . group($tmp[5]) . "</td>\n";
	print "<td align=right>$tmp[7]</td>\n";
	print "<td>" . formattime($tmp[9]) . "</td>\n";
	print "<td>$file</td>\n";
	print "</tr>\n";
    }
    print "</table></td></tr></table>\n";
}

###
### ����ǥå������
###
sub dodelete {
    my $index = $qarg->{'index'};
    my $file = "";

    print "<font color=blue>����ġ���⡼�ɤؤϡ��֥饦���Ρ����פ���äƲ�������</font><p>\n";

    $index = $g_index if($index eq "");
    $file = $index . ".idx";
    if(unlink($file)) {
	print "����ǥå���:$index�������ޤ�����";
    } else {
	print "����ǥå���:$index��������Τ˼��Ԥ��ޤ�����";
    }
}

###
### ������ǥå�������
###
sub domake {
    my $index = $qarg->{'index'};
    my $file = "";

    print "<font color=blue>����ġ���⡼�ɤؤϡ��֥饦���Ρ����פ���äƲ�������</font><p>\n";

    $index = $g_index if($index eq "");
    $file = $index . ".idx";

    # try 1
    if(open(FILE,">$file")) {
	print "������ǥå���:$index��������ޤ�����(try 1)";
	close(FILE);
	return;
    }
    # try 2
    if(sysopen(FILE,"$file",O_RDWR|O_CREAT)) {
	print "������ǥå���:$index��������ޤ�����(try 2)";
	close(FILE);
	return;
    }
    # try 3
    `touch $file`;
    if(-f $file && -z $file) {
	print "������ǥå���:$index��������ޤ�����(try 3)";
	return;
    }

    print "������ǥå����κ����˼��Ԥ��ޤ�����";
}

###
### ����ǥå������
###
sub docombine {
    my @files = ();
    my @indice = ();
    my ($file, $all);

    print "<font color=blue>����ġ���⡼�ɤؤϡ��֥饦���Ρ����פ���äƲ�������</font><p>\n";

    unlink("./$g_index.idx");
    opendir(P,".");
    @files = readdir(P);
    closedir(P);
    foreach $file (@files) {
	if($file =~ /\.idx$/i) {
	    push(@indice,$file);
	}
    }
    if($#indice == -1) {
	print "����ǥå������˼��Ԥ��ޤ���(����оݤΥ���ǥå�����¸�ߤ��ޤ���)��";
	return;
    }

    # try 1
    $all = join(" ",@indice);
    `cat $all>./$g_index.idx`;
    if(-f "./$g_index.idx" && -s "./$g_index.idx") {
	print "����ǥå��������������ޤ�����(try 1)";
	return;
    }

    # try 2
    if(!open(FILE,">./$g_index.idx")) {
	print "����ǥå������˼��Ԥ��ޤ���($g_index����ǥå�����������)��";
	return;
    }
    foreach $file (@indice) {
	if(!open(IN,"<$file")) {
	    print "����ǥå������˼��Ԥ��ޤ���($file����ǥå��������ץ󥨥顼)��";
	    return;
	}
	while(<IN>) {
	    print FILE $_;
	}
	close(IN);
    }
    close(FILE);
    if(-f "./$g_index.idx" && -s "./$g_index.idx") {
	print "����ǥå��������������ޤ�����(try 2)";
	return;
    } else {
	print "����ǥå������˼��Ԥ��ޤ���($g_index����ǥå����񤭹��ߥ��顼)��";
	return;
    }
}

###
### �ե�����̾�ȥ⡼�ɤ���-rwxr-xr-x�ߤ�����ʸ������֤�
###
sub getmode {
    my $filename = $_[0];
    my $mode = $_[1];

    if(-d $filename) {
	$str = "d";
    } elsif(-l $filename) {
	$str = "l";
    } else {
	$str = "-";
    }

    if($mode & 0400) {
	$str .= "r";
    } else {
	$str .= "-";
    }
    if($mode & 0200) {
	$str .= "w";
    } else {
	$str .= "-";
    }
    if($mode & 0100) {
	$str .= "x";
    } else {
	$str .= "-";
    }
    if($mode & 040) {
	$str .= "r";
    } else {
	$str .= "-";
    }
    if($mode & 020) {
	$str .= "w";
    } else {
	$str .= "-";
    }
    if($mode & 010) {
	$str .= "x";
    } else {
	$str .= "-";
    }
    if($mode & 04) {
	$str .= "r";
    } else {
	$str .= "-";
    }
    if($mode & 02) {
	$str .= "w";
    } else {
	$str .= "-";
    }
    if($mode & 01) {
	$str .= "x";
    } else {
	$str .= "-";
    }

    return($str);
}

###
### uid����桼��̾���֤�
###
sub user {
    return( (getpwuid($_[0]))[0] );
}

###
### gid���饰�롼��̾���֤�
###
sub group {
    return( (getgrgid($_[0]))[0] );
}

###
### ������ե����ޥåȤ���
###
sub formattime {
    my ($s,$m,$h,$d,$mon,$year);

    ($s,$m,$h,$d,$mon,$year) = localtime($_[0]);
    $year += 1900;
    $mon += 1;
    $s = "0$s" if($s < 10);
    $m = "0$m" if($m < 10);
    $h = "0$h" if($h < 10);
    $d = "0$d" if($d < 10);
    $mon = "0$mon" if($mon < 10);

    return("$yearǯ$mon��$d�� $h:$m");
}

###
### �����ȥǥ��쥯�ȥ�Υѥ������
###
sub mypwd {
    my @dirname = ();
    my ($p, $pi);
    my @stat;
    my $c = ".";
    my @cstat = stat($c);
    my $ci = $cstat[1];
    my $pwd = "";
    while(1) {
	$p = "$c/..";
	@stat = stat($p);
	$pi = $stat[1];
	opendir(P,"$p");
	@files = readdir(P);
	closedir(P);
	foreach $file (@files) {
	    next if($file eq "." || $file eq "..");
	    @stat = stat("$p/$file");
	    if($stat[1] eq $ci) {
		if($stat[0] eq $cstat[0]) {
		    push(@dirname,$file);
		}
	    }
	}
	if($pi eq $ci) {
	    foreach (@dirname) {
		$pwd = "/$_$pwd";
	    }
	    return($pwd);
	}
	$c = $p;
	$ci = $pi;
    }
}

###
### HTML Content-type����
###
sub printcontenttype {
  print "Content-type: text/html;charset=euc-jp\n\n"; # ��
}

###
### HTML�إå����ν���
###
sub printheader {
    my $title = $_[0];		# �����ȥ�(����)
    my $body_attr = "";		# body������°��

    print "<html>\n";
    print "<head>\n";
    print "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=x-euc-jp\">\n";
    print "<meta http-equiv=\"Content-Language\" content=\"ja\">\n";
    print "<title>$title</title>\n";
    print "</head>\n";
    $body_attr .= " background=\"$body_background\"" if $body_background;
    $body_attr .= " bgcolor=\"$body_bgcolor\"" if $body_bgcolor;
    $body_attr .= " text=\"$body_text\"" if $body_text;
    $body_attr .= " link=\"$body_link\"" if $body_link;
    $body_attr .= " alink=\"$body_alink\"" if $body_alink;
    $body_attr .= " vlink=\"$body_vlink\"" if $body_vlink;
    print "<body $body_attr>\n";
}

###
### HTML�եå������ν���
###
sub printfooter {
    print "</body>\n";
    print "</html>\n";
}

###
### �����ե�����ν���
###
sub printform {
    my $c_includedir = "";
    my $c_includeurl = "";
    my $c_suffix = "";
    my $c_excludedir = "";
    my $c_excludefile = "";
    my $c_excludekey = "";

    if($g_cookie == 1) {
	$c_index = $chash->{'index'};
	$c_includedir = $chash->{'includedir'};
	$c_includeurl = $chash->{'includeurl'};
	$c_suffix = $chash->{'suffix'};
	$c_excludedir = $chash->{'excludedir'};
	$c_excludefile = $chash->{'excludefile'};
	$c_excludekey = $chash->{'excludekey'};
	if($chash->{'sort'} eq "NONE") {
	    $s_nn = "selected";
	} elsif($chash->{'sort'} eq "MODIFY-DESC") {
	    $s_md = "selected";
	} elsif($chash->{'sort'} eq "MODIFY-ASC") {
	    $s_ma = "selected";
	} elsif($chash->{'sort'} eq "TITLE-DESC") {
	    $s_td = "selected";
	} elsif($chash->{'sort'} eq "TITLE-ASC") {
	    $s_ta = "selected";
	} elsif($chash->{'sort'} eq "URL-DESC") {
	    $s_ud = "selected";
	} elsif($chash->{'sort'} eq "URL-ASC") {
	    $s_ua = "selected";
	}
	if($chash->{'rescuealt'} eq "1") {
	    $s_rescue = "selected";
	} else {
	    $s_notrescue = "selected";
	}
    }

    print <<HERE_DOC;
<center>
<h3>
msearch�ѥ���ǥå��������ե�����
������
<a href="$g_cgi?mode=control">msearch�ѥ���ǥå�������ġ���</a>
</h3>
</center>
<p>
<center>
<form action="$g_cgi" method="post" accept-charset="x-euc-jp">
<table border=1>
<tr>
<td>����ǥå���̾<sup>��1</sup></td>
<td><input type="text" name="index" value="$c_index" size=50></td>
</tr>
<tr>
<td>�оݥǥ��쥯�ȥ�<sup>��2</sup><font color=blue>(ɬ��)</font></td>
<td><input type="text" name="includedir" value="$c_includedir" size=50></td>
</tr>
<tr>
<td>�оݥǥ��쥯�ȥ��URL<sup>��3</sup><font color=blue>(ɬ��)</font></td>
<td><input type="text" name="includeurl" value="$c_includeurl" size=50></td>
</tr>
<tr>
<td>�оݥե�����γ�ĥ��<sup>��4</sup></td>
<td><input type="text" name="suffix" value="$c_suffix" size=50></td>
</tr>
<tr>
<td>���оݥǥ��쥯�ȥ�<sup>��5</sup></td>
<td><input type="text" name="excludedir" value="$c_excludedir" size=50></td>
</tr>
<tr>
<td>���оݥե�����<sup>��6</sup></td>
<td><input type="text" name="excludefile" value="$c_excludefile" size=50></td>
</tr>
<tr>
<td>���оݥ������<sup>��7</sup></td>
<td><input type="text" name="excludekey" value="$c_excludekey" size=50></td>
</tr>
<tr>
<td>��󥭥���ˡ<sup>��8</sup></td>
<td>
<select name="sort">
<option value="NONE" $s_nn>��󥭥󥰤ʤ�
<option value="MODIFY-DESC" $s_md>�ǽ���������-�߽�
<option value="MODIFY-ASC" $s_ma>�ǽ���������-����
<option value="TITLE-DESC" $s_td>�����ȥ�-�߽�
<option value="TITLE-ASC" $s_ta>�����ȥ�-����
<option value="URL-DESC" $s_ud>URL-�߽�
<option value="URL-ASC" $s_ua>URL-����
</select></td>
</tr>
<tr>
<td>altʸ�����ɲ�<sup>��9</sup></td>
<td>
<select name="rescuealt">
<option value="1" $s_rescue>�ɲä���
<option value="0" $s_notrescue>�ɲä��ʤ�
</select></td>
</tr>
<tr>
<td>�ѥ����<sup>��10</sup><font color=blue>(ɬ��)</font></td>
<td><input type="password" name="conf" value="" size=50>
</tr>
<tr>
<td colspan=2 align=right>
<input type="checkbox" name="debug" value="1">
�ǥХå��⡼��<sup>��11</sup>����
<input type="checkbox" name="onebyone" value="1"> <!-- �� -->
���⡼��<sup>��12</sup>����
<input type="submit" value="����ǥå�������">
</td>
</tr>
</table>
</form>
<p>
<table border=0 width=80%>
<tr>
<td nowrap=true valign=top><small>��1</small></td>
<td><small>�������륤��ǥå�����̾�Ρ����ꤷ�ʤ����ϥǥե������(default)
    ��̾�ΤȤʤ롥����ǥå������ڤ��ؤ��Ƹ���������ˤϡ����줾��θ���
    �о���˥���ǥå�����̾�Τ��դ��롥����ǥå����Υե�����̾��
    ����ǥå���̾�ˡ�.idx�٤Ȥ�����ĥ��(suffix)����ưŪ���դ�����Τǡ�
    �����Ǥϳ�ĥ�Ҥ���ꤷ�ƤϤʤ�ʤ���</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��2</small></td>
<td><small>����ǥå���������HTML�ե����뤬����ǥ��쥯�ȥꡥɬ��1�ǥ��쥯��
    ��Τ߻��ꤷ�ʤ���Фʤ�ʤ������Хѥ��ǤϤʤ������Υץ����
    (genindex.cgi)�Τ���ǥ��쥯�ȥ꤫������Хѥ��⤷���ϡ����Хѥ��ǻ���
    ���롥���Υץ����ϡ����λ��ꤵ�줿�ǥ��쥯�ȥ�ʲ��Τ��٤Ƥ�HTML
    �ե�����򥤥�ǥå��������롥</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��3</small></td>
<td><small>����оݥǥ��쥯�ȥ꤬URL�Ǥ�ɽ����뤫����ꤹ�롥�㤨�С��о�
    �ǥ��쥯�ȥ꤬��"../public_html"�Ǥ��ꡤ����URL��
    "http://www.foo.co.jp/~user/"���ͤ˻��ꤹ�롥</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��4</small></td>
<td><small>����ǥå���������HTML�ե�����γ�ĥ�Ҥ���ꤹ�롥������ꤷ�ʤ�
    ���ϡ�".html"��".htm"�����ꤹ����ϡ����Υǥե�����ͤ��񤭤����
    �ǡ���դ�ɬ�ס�".html,.shtml"���ͤ�Ⱦ�ѤΥ���ޤ�Ȥ���ʣ������Ǥ���
    (�ºݤˤϥ��֥륯�����ơ������Ϥ���ʤ�)��</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��5</small></td>
<td><small>����оݥǥ��쥯�ȥ����ǥ���ǥå��������ʤ��ǥ��쥯�ȥ�����
    ���롥�㤨�С�"../public_html/cgi-bin"�ʲ��򥤥�ǥå��������ʤ����ϡ�
    "cgi-bin"���ͤ��оݥǥ��쥯�ȥ꤫������Хѥ��ǻ��ꤹ�롥Ⱦ�ѥ���ޤ�
    �Ȥ���ʣ������Ǥ��롥<br>�ޤ������оݥǥ��쥯�ȥ�ˤ������ǥ��쥯�ȥ�
    ̾������ɽ����Ȥäƻ��ꤹ�뤳�Ȥ��Ǥ��롥�����������ξ�硤�оݥǥ���
    ���ȥ꤫������Хѥ��ǤϤʤ����ǥ��쥯�ȥ�̾�Τߤ�����ɽ���ǻ��ꤹ�롥
    �㤨�С��оݥǥ��쥯�ȥ�ʲ��ˤ������Ƥ�"_vti_cnf"�Ȥ����ǥ��쥯�ȥ��
    ����ǥå������������ʤ�����"(_vti_cnf)"�Ȥ��롥"("��")"�ϡ��������
    ����ɽ�����Ȼ��ꤹ�뤿���ɬ�פǤ���"(_vti_cnf)"�������"(^_.*)"��
    �褦�˵��Ҥ��Ƥ⹽���ޤ���</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��6</small></td>
<td><small>����оݥǥ��쥯�ȥ����ǡ�������оݥǥ��쥯�ȥ�ʳ��ǥ���ǥ�
    ���������ʤ��ե��������ꤹ�롥�㤨�С�"../public_html/secret.html"
    �ե�����򥤥�ǥå������������ʤ����ϡ�"secret.html"���ͤ��оݥǥ���
    ���ȥ꤫������Хѥ��ǻ��ꤹ�롥Ⱦ�ѥ���ޤ�Ȥ���ʣ������Ǥ��롥<br>
    �ޤ������оݥǥ��쥯�ȥ��Ʊ�ͤ����оݥե�����Ȥ������ե�����̾������
    ɽ����Ȥäƻ��ꤹ�뤳�Ȥ��Ǥ��롥����ɽ����"("��")"�ǰϤäƻ��ꤹ�롥
    </small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��7</small></td>
<td><small>�����оݤ����줿���ʤ�������ɤ���ꤷ�ޤ��������ǻ��ꤷ������
    ��ɤǸ���������硤������̤�0��Ȥʤ�ޤ���Ⱦ�ѥ���ޤ�Ȥ���ʣ��
    ����Ǥ��ޤ����㤨�С��֥��󥿡��ͥåȡפȡָ����פȤ���������ɤ�
    �����оݤˤ������ʤ����ϡ�"���󥿡��ͥå�,����"�Ȼ��ꤷ�ޤ���������
    ���ꤷ��������ɤϸ�����̤ΰ���ɽ���ˤ�ФƤ��ޤ���Τ���դ��Ʋ�������
    �������������ȥ�˴ޤޤ�륭����ɤϺ�����ޤ���</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��8</small></td>
<td><small>������̤Υ�󥭥�(������)��ˡ����ꤷ�ޤ�����󥭥󥰤ϥ���
    �ǥå���������˷��ꤷ�ʤ���Фʤ�ޤ���</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��9</small></td>
<td><small>����������å�����ȡ�alt°�����ʸ����⸡���оݤ˴ޤ�ޤ���
    </small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��10</small></td>
<td><small>����CGI��ư�������Ȥ������ͤ���ꤹ�뤿��Υѥ���ɤǤ�����
    �Υѥ���ɥǡ���������ޤ��Τǡ�����֤�����ǽ��������ޤ���</small>
    </td>
</tr>
<tr>
<td nowrap=true valign=top><small>��11</small></td>
<td><small>����������å�����ȡ��ǥХå����󤬽��Ϥ���ޤ��������
    ����ǥå�������������ʤ����ξ������İ����뤿���ͭ�פʾ���ɽ��
    ����ޤ���</small></td>
</tr>
<tr>
<td nowrap=true valign=top><small>��12</small></td> <!-- �� -->
<td><small>����������å�����ȡ�����ǥå����ե�����ؤν񤭽Ф���
    �оݥե�����򤹤٤��ɤ߹���Ǥ���ǤϤʤ���1���ɤ߹�����˹Ԥ��ޤ���
    ����ǥå�������������ǻߤޤäƤ��ޤ����ʤɤ˥����å����ƤߤƤ���������
    �ܥ⡼�ɤ�Ȥ��Ȥ��ϥǥХå��⡼�ɤˤ�����å�������뤳�Ȥ�侩���ޤ���
    �ʤ����⡼�ɤǤϥ�󥭥�(������)�ϹԤ��ޤ���
    �ޤ���ʬ�����ϹԤ鷺����󿷵������ˤʤ�ޤ���
    ���⡼�ɤǺ�����������ǥå���������ġ���Ƿ�礷�Ƥ����ꤢ��ޤ���
    </small></td>
</tr>
</table>
</center>
HERE_DOC
}

###
### ����ġ���ν���
###
sub printmenu {
    print <<HERE_DOC;
<center>
<h3>
<a href="$g_cgi?mode=generate">msearch�ѥ���ǥå��������ե�����</a>
������
msearch�ѥ���ǥå�������ġ���
</h3>
</center>
<p>
<center>

<form action="$g_cgi" method="post" accept-charset="x-euc-jp">
<table border=1 cols=2>
<tr>
<td colspan=2 align=center><b>�Ƽ����μ���</b></td>
<tr>
<td>�ѥ����<font color=blue>(ɬ��)</font></td>
<td><input type="password" name="conf" value="" size=50></td>
</tr>
<tr>
<td colspan=2 align=right><input type="submit" value="�������"></td>
</tr>
</table>
<input type="hidden" name="mode" value="control">
<input type="hidden" name="action" value="get">
<table border=0 width=50%>
<tr><td>
<font size=-1>����ǥå�����ޤ�msearch��Ϣ�Υե��������CGI�μ¹Ծ���
�ǥ��쥯�ȥ����ʤɤ�������ޤ���</font><br>
<font size=-1 color=red>
�������ƥ�����ʾ����������ޤ��Τǡ�����ա�</font><br>
</td></tr>
</table>
</form>

<p>

<form action="$g_cgi" method="post" accept-charset="x-euc-jp">
<table border=1 cols=2>
<tr>
<td colspan=2 align=center><b>����ǥå����κ��</b></td>
<tr>
<td>����ǥå���̾</td>
<td><input type="text" name="index" value="" size=50></td>
</tr>
<tr>
<td>�ѥ����<font color=blue>(ɬ��)</font></td>
<td><input type="password" name="conf" value="" size=50></td>
</tr>
<tr>
<td colspan=2 align=right><input type="submit" value="����ǥå������"></td>
</tr>
</table>
<input type="hidden" name="mode" value="control">
<input type="hidden" name="action" value="delete">
<table border=0 width=50%>
<tr><td>
<font size=-1>����ǥå����оݥե�������ѹ����ʤ�������ǥå�������ľ��
�������(��󥭥���ˡ���ѹ���altʸ�����ɲá����оݥ�����ɤ��ɲ���)�䡤
����ǥå����˸ߴ������������msearch�ΥС�����󥢥å׻��ˤϡ�����ǥå���
�������ơ������˥���ǥå�����������Ʋ�������
genindex.cgi�Υ���ǥå������������ϥ���ǥå����оݥե�����ι��������Τ�
�򸫤Ƥ��ޤ���</font>
<br>
<font size=-1 color=red>����ǥå���̾�˲�����ꤷ�ʤ��ȡ��ǥե���Ȥ�
����ǥå���(default)������оݤȤʤ�ޤ���
��ĥ��(.idx)���դ��ʤ��ǲ�������</font>
</td></tr>
</table>
</form>

<p>

<form action="$g_cgi" method="post" accept-charset="x-euc-jp">
<table border=1 cols=2>
<tr>
<td colspan=2 align=center><b>������ǥå����κ���</b></td>
<tr>
<td>����ǥå���̾</td>
<td><input type="text" name="index" value="" size=50></td>
</tr>
<tr>
<td>�ѥ����<font color=blue>(ɬ��)</font></td>
<td><input type="password" name="conf" value="" size=50></td>
</tr>
<tr>
<td colspan=2 align=right><input type="submit" value="������ǥå�������"></td>
</tr>
</table>
<input type="hidden" name="mode" value="control">
<input type="hidden" name="action" value="make">
<table border=0 width=50%>
<tr><td>
<font size=-1>���餫�θ����ǡ�����ǥå����������Ǥ��ʤ����ϡ�
���Υ���ǥå������äƤߤƲ�������</font><br>
<font size=-1 color=red>
���ꤵ�줿����ǥå���(���ꤵ��ʤ��ä����ϥǥե���ȥ���ǥå���(default))
������¸�ߤ�����ϡ����Υ���ǥå��������ˤʤ�ޤ�������ա�
��ĥ��(.idx)���դ��ʤ��ǲ�������</font><br>
<font size=-1>����Ū�ˡ�genindex.cgi�ǥ���ǥå��������ʤ����ϡ�
���Υ��ޥ�ɤǤ������ǥå��������ʤ���ǽ�����⤤�Ǥ���
������ä�������ˡ���ƤߤƤ��ޤ��������ޤ���Ԥ��ʤ��ǲ�������
</font>
</td></tr>
</table>
</form>

<p>

<form action="$g_cgi" method="post" accept-charset="x-euc-jp">
<table border=1 cols=2>
<tr>
<td colspan=2 align=center><b>����ǥå����η��</b></td>
<tr>
<td>�ѥ����<font color=blue>(ɬ��)</font></td>
<td><input type="password" name="conf" value="" size=50></td>
</tr>
<tr>
<td colspan=2 align=right><input type="submit" value="����ǥå������"></td>
</tr>
</table>
<input type="hidden" name="mode" value="control">
<input type="hidden" name="action" value="combine">
<table border=0 width=50%>
<tr><td>
<font size=-1>�ǥե���ȥ���ǥå���(default)�ʳ��Υ���ǥå������礷��
�ǥե���ȥ���ǥå���(default)����ޤ���
����ǥå����оݥե����뤬¿�����ơ�������­��genindex.cgi��ư��ʤ�
���ϡ����֥ǥ��쥯�ȥ�ñ�����Ǿ����ʥ���ǥå������ꡤ��礷�Ƥߤ�
��������</font><br>
<font size=-1 color=red>
��¸�Υǥե���ȥ���ǥå���������¸�ߤ�����ϡ���񤭤���ޤ�������ա�<br>
�ޤ�����縵�Υ���ǥå����Ϻ������ޤ���
</font><br>
</td></tr>
</table>
</form>

</center>
HERE_DOC
}

###
### ���ϴؿ�
###
sub printout {
    my $str = $_[0];             # ʸ����(����)

    $str =~ s/\n/<br>/g;
    print "$str\n";
}

