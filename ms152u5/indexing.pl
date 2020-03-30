#=============================================================================#
#                  indexing.pl - ����ǥå��������⥸�塼��                   #
#        Copyright (C) 2000-2004, Katsushi Matsuda. All Right Reserved.       #
#                                                   Modified by ��ή����      #
#=============================================================================#

#=============================================================================#
# �� <- �ܲ��Ǥ��Ф��뽤�����ɵ��ս�ˤ��ܰ��Ȥ��ơ����դ��Ƥ��롣
# [��ջ���]
# �ܥ�����ץȤϡ�EUC+LF(ʸ�������ɡ�EUC�����ԥ����ɡ�LF)����¸���뤳�ȡ�
# ����ǥå����Υե����ޥåȤ��ѹ����Ƥ��뤿�ᡢ
# �ܥ⥸�塼���EUC-JP��msearch�ѤȤ��Ƥϻ��ѤǤ��ʤ���
# UTF-8��msearch���ѤǤ��롣
#=============================================================================#

####################
### �Ƽ��ѿ���� ###
####################

$g_index = "";			# �����륤��ǥå����ե�����
%g_index = ();			# ����ǥå����Υϥå���
				# key = �ե�����̾
				# val = ����,�ǽ���������,�ե����륵����,URL,�����ȥ�,HTML����� ��
$g_include_dir = "";		# ����ǥå����оݥǥ��쥯�ȥ�
$g_include_url = "";		# ����ǥå����оݥǥ��쥯�ȥ��URL
@g_suffix = ();			# ����ǥå����оݥե�����γ�ĥ��
@g_exclude_dir = ();		# �󥤥�ǥå����оݥǥ��쥯�ȥ�
@g_exclude_reg_dir = ();	# �󥤥�ǥå����оݥǥ��쥯�ȥ�(����ɽ��)
@g_exclude_file = ();		# �󥤥�ǥå����оݥե�����
@g_exclude_reg_file = ();	# �󥤥�ǥå����оݥե�����(����ɽ��)
$g_exclude_keys = "";		# �󥤥�ǥå����оݥ������
$g_sort = "";


###
### ����ǥå��������μ�ؿ�
###
sub makeindex {
    my $files;			# ����ǥå����оݥե�����ϥå���ؤλ���
    my $io;			# �Хåե�����ѥե�����ϥ�ɥ�
    my $i;			# ���󥯥��󥿥��ѿ�(�Ȥ��ޤ路)
    my $file;			# �ե�����̾
    my @del_files = ();		# ��������оݥե�����
    my @add_files = ();		# �ɲä����оݥե�����
    my @mod_files = ();		# ���������оݥե�����
    my $n_del = 0;		# ����ǥå��������������оݥե�����ο�
    my $n_add = 0;		# ����ǥå������ɲä����оݥե�����ο�
    my $n_mod = 0;		# ����ǥå����˹��������оݥե�����ο�
    my $t_pass = "";		# �ѥ����

    ### ����ǥå���̾�����
    if($qarg->{'index'} ne "") {
	$g_index = "./" . $qarg->{'index'} . ".idx";
    } else {
	$g_index = "./default.idx";
    }

    ### �������ͤ��ѿ�����
    # ����ǥå����оݥǥ��쥯�ȥ�
    if($qarg->{'includedir'} ne "") {
	$g_include_dir = $qarg->{'includedir'};
	# �Ǹ��"/"�ǽ�����ͤ�
	$g_include_dir .= "/" if($g_include_dir !~ /\/$/);
    }
    # ����ǥå����оݥե������URL
    if($qarg->{'includeurl'} ne "") {
	$g_include_url = $qarg->{'includeurl'};
	# �ǽ��"http"�ǻϤޤ��ͤ�
	$g_include_url = "http://" .
	    $g_include_url if($g_include_url !~ /^http/);
	# �Ǹ��"/"�ǽ�����ͤ�
	$g_include_url .= "/" if($g_include_url !~ /\/$/);
    }
    # ����ǥå����оݥե�����γ�ĥ��
    if($qarg->{'suffix'} ne "") {
	@g_suffix = split(/,/,$qarg->{'suffix'});
    } else {
	@g_suffix = split(/,/,".html,.htm");
    }
    # �󥤥�ǥå����оݥǥ��쥯�ȥ�
    if($qarg->{'excludedir'} ne "") {
	my @tarray = ();
	my $tmp;
	@tarray = split(/,/,$qarg->{'excludedir'});
	foreach $tmp ( @tarray ) {
	    if($tmp =~ /\((.*)\)/) {
		# ����ɽ�����ξ��
		push(@g_exclude_reg_dir,$1);
	    } else {
		# ������ɽ�����ξ��
		$tmp = $g_include_dir . $tmp;
		$tmp .= "/" if($tmp !~ /\/$/);
		push(@g_exclude_dir,$tmp);
	    }
	}
    }
    # �󥤥�ǥå����оݥե�����
    if($qarg->{'excludefile'} ne "") {
	my @tarray = ();
	my $tmp;
	@tarray = split(/,/,$qarg->{'excludefile'});
	foreach $tmp ( @tarray ) {
	    if($tmp =~ /\((.*)\)/) {
		# ����ɽ�����ξ��
		push(@g_exclude_reg_file,$1);
	    } else {
		# ������ɽ�����ξ��
		$tmp = $g_include_dir . $tmp;
		push(@g_exclude_file,$tmp);
	    }
	}
    }
    # �󥤥�ǥå����оݥ������
    if($qarg->{'excludekey'} ne "") {
	$g_exclude_keys = $qarg->{'excludekey'};
	if($utf_mode) { # ��
	  &utfjp::utf8h2z_kana(\$g_exclude_keys);
	  &utfjp::utf8z2h_an(\$g_exclude_keys);
	  my @from = (0xFF0B,0xFF3D,0xFF3B,0xFF0E,0xFF08,0xFF09,0xFF1F,0xFF0F,0xFF20,0xFF0D);
	  my @to   = (0x002B,0x005D,0x005B,0x002E,0x0028,0x0029,0x003F,0x002F,0x0040,0x002D);
	  &utfjp::utf8tr_codepoint(\$g_exclude_keys, \@from, \@to);
	} else {
	  &jcode::h2z_euc(\$g_exclude_keys);
	  &jcode::tr(\$g_exclude_keys,'��-����-�ڣ�-���ܡϡΡ��ʡˡ�������',
		     '0-9A-Za-z+][.()?/@-');
	}
	$g_exclude_keys =~ s/,/\|/g;
    }
    # ��󥭥���ˡ
    if($qarg->{'sort'} ne "") {
	$g_sort = $qarg->{'sort'};
    } else {
	$g_sort = "NONE";
    }

    printout("����ǥå��������򳫻Ϥ��ޤ�\n");
    # ��¸�Υ���ǥå�����������ɤ߹���(index��%g_index������)
    printout("��������¸�Υ���ǥå������ɤ߹��ߤޤ�\n");
    $i = readindex($g_index,\%g_index) if(-f $g_index);
    if(-f $g_index) {
	printout("��������λ($i�ե�����)\n");
    } else {
	printout("��������λ(0�ե�����)\n");
    }

    # ����ǥå����оݥե�����μ���
    printout("����������ǥå���������ե������������Ƥ��ޤ�\n");
    $files = collectfiles($g_include_dir,\@g_suffix,\@g_exclude_dir,
			  \@g_exclude_reg_dir,\@g_exclude_file,
			  \@g_exclude_reg_file);

    $i = keys(%$files);
    printout("��������λ($i�ե�����)\n");

    # ����ե�����ȹ����ե�����μ���
    printout("������¸����ǥå����Ȥ����\n") if($debug);
    foreach $file (keys %g_index) {
	if($files->{$file} eq "") {
	    # ����ǥå����ˤ��ꡤ�оݥե�����ˤʤ����
	    $n_del++;		# ������򥤥󥯥����
	    push(@del_files,$file);
	} else {
	    # ����ǥå����ˤ��оݥե�����ˤ⤢����
	    my $mtime;		# ����ǥå���������κǽ��������� ��
	    $mtime = (split(/\t/,$g_index{$file}))[1];
	    printout("��$file:��=$files->{$file}, ����=$mtime\n") if($debug);
	    if($files->{$file} > $mtime) {
		# �����������������
		$n_mod++;	# �������򥤥󥯥����
		push(@mod_files,$file);
	    }
	}
    }
    printout("������λ($n_mod�ե�����)\n") if($debug);

    # ����ե�����ν���
    printout("��������ǥå�������������ե�����\n") if($debug);
    while(@del_files) {
	my $file = shift(@del_files);
	printout("������ե�����:$file\n") if($debug);
	delete $g_index{$file}; # ����ǥå���������
    }
    printout("������λ\n") if($debug);
    printout("����������ǥå���������($n_del�ե�����)\n");

    # �����ե�����ν���
    printout("��������ǥå����ǹ�������ե�����\n") if($debug);
    while(@mod_files) {
	my ($i_lang,$i_mtime,$i_fsize,$i_url,$i_title,$i_contents); # ��
	my $file = shift(@mod_files);
	delete $g_index{$file};	# ����ǥå���������
	# ����ǥå������� ��
	($i_lang,$i_mtime,$i_fsize,$i_url,$i_title,$i_contents) =
	    makedata($file,$g_include_dir,$g_include_url,$g_exclude_keys);
	# ����ǥå������ɲ� ��
	$g_index{$file} = "$i_lang\t$i_mtime\t$i_fsize\t$i_url\t$i_title\t$i_contents";
	printout("�������ե�����:$file\n") if($debug);
    }
    printout("������λ($n_mod�ե�����)\n") if($debug);
    printout("����������ǥå����ι���($n_mod�ե�����)\n");
	
    # �����ե�����ν���
    printout("��������ǥå������ɲä���ե�����\n") if($debug);
    foreach $file (keys %$files) {
	if($g_index{$file} eq "") {
	    # �оݥե�����ˤ��ꡤ����ǥå����ˤʤ���� ��
	    my ($i_lang,$i_mtime,$i_fsize,$i_url,$i_title,$i_contents);
	    $n_add++;		# �ɲÿ��򥤥󥯥����
	    # ����ǥå������� ��
	    ($i_lang,$i_mtime,$i_fsize,$i_url,$i_title,$i_contents) =
		makedata($file,$g_include_dir,$g_include_url,$g_exclude_keys);
	    # ����ǥå������ɲ� ��
	    $g_index{$file} = "$i_lang\t$i_mtime\t$i_fsize\t$i_url\t$i_title\t$i_contents";
	    printout("���ɲåե�����:$file\n") if($debug);
	}
    }
    printout("����������ǥå������ɲ�($n_add�ե�����)\n");

    &utfjp::del_all_tables;  # �� �ޥåԥ󥰥ơ��֥롢�������ѥơ��֥�ʤɤ������롣

    # ����ǥå�����񤭽Ф�
    if($n_del > 0 || $n_mod > 0 || $n_add > 0) {
	printout("����������ǥå�������¸���Ƥ��ޤ�\n");
	$i = writeindex($g_index,\%g_index);
	printout("��������λ($i�ե�����)\n");
    } else {
	printout("����������ǥå����Ϻǿ��Ǥ�\n");
    }
    printout("����ǥå��������ϴ�λ���ޤ���\n");
}

###
### ����ǥå��������μ�ؿ�(���⡼��) ��
###
sub makeindex_onebyone {
    my $files;			# ����ǥå����оݥե�����ϥå���ؤλ���
    my $io;			# �Хåե�����ѥե�����ϥ�ɥ�
    my $i;			# ���󥯥��󥿥��ѿ�(�Ȥ��ޤ路)
    my $file;			# �ե�����̾
    my @del_files = ();		# ��������оݥե�����
    my @add_files = ();		# �ɲä����оݥե�����
    my @mod_files = ();		# ���������оݥե�����
    my $n_del = 0;		# ����ǥå��������������оݥե�����ο�
    my $n_add = 0;		# ����ǥå������ɲä����оݥե�����ο�
    my $n_mod = 0;		# ����ǥå����˹��������оݥե�����ο�
    my $t_pass = "";		# �ѥ����
    local *FILEOUT;		# �ե�����ϥ�ɥ� ��

    ### ����ǥå���̾�����
    if($qarg->{'index'} ne "") {
	$g_index = "./" . $qarg->{'index'} . ".idx";
    } else {
	$g_index = "./default.idx";
    }

    ### �������ͤ��ѿ�����
    # ����ǥå����оݥǥ��쥯�ȥ�
    if($qarg->{'includedir'} ne "") {
	$g_include_dir = $qarg->{'includedir'};
	# �Ǹ��"/"�ǽ�����ͤ�
	$g_include_dir .= "/" if($g_include_dir !~ /\/$/);
    }
    # ����ǥå����оݥե������URL
    if($qarg->{'includeurl'} ne "") {
	$g_include_url = $qarg->{'includeurl'};
	# �ǽ��"http"�ǻϤޤ��ͤ�
	$g_include_url = "http://" .
	    $g_include_url if($g_include_url !~ /^http/);
	# �Ǹ��"/"�ǽ�����ͤ�
	$g_include_url .= "/" if($g_include_url !~ /\/$/);
    }
    # ����ǥå����оݥե�����γ�ĥ��
    if($qarg->{'suffix'} ne "") {
	@g_suffix = split(/,/,$qarg->{'suffix'});
    } else {
	@g_suffix = split(/,/,".html,.htm");
    }
    # �󥤥�ǥå����оݥǥ��쥯�ȥ�
    if($qarg->{'excludedir'} ne "") {
	my @tarray = ();
	my $tmp;
	@tarray = split(/,/,$qarg->{'excludedir'});
	foreach $tmp ( @tarray ) {
	    if($tmp =~ /\((.*)\)/) {
		# ����ɽ�����ξ��
		push(@g_exclude_reg_dir,$1);
	    } else {
		# ������ɽ�����ξ��
		$tmp = $g_include_dir . $tmp;
		$tmp .= "/" if($tmp !~ /\/$/);
		push(@g_exclude_dir,$tmp);
	    }
	}
    }
    # �󥤥�ǥå����оݥե�����
    if($qarg->{'excludefile'} ne "") {
	my @tarray = ();
	my $tmp;
	@tarray = split(/,/,$qarg->{'excludefile'});
	foreach $tmp ( @tarray ) {
	    if($tmp =~ /\((.*)\)/) {
		# ����ɽ�����ξ��
		push(@g_exclude_reg_file,$1);
	    } else {
		# ������ɽ�����ξ��
		$tmp = $g_include_dir . $tmp;
		push(@g_exclude_file,$tmp);
	    }
	}
    }
    # �󥤥�ǥå����оݥ������
    if($qarg->{'excludekey'} ne "") {
	$g_exclude_keys = $qarg->{'excludekey'};
	if($utf_mode) { # ��
	  &utfjp::utf8h2z_kana(\$g_exclude_keys);
	  &utfjp::utf8z2h_an(\$g_exclude_keys);
	  my @from = (0xFF0B,0xFF3D,0xFF3B,0xFF0E,0xFF08,0xFF09,0xFF1F,0xFF0F,0xFF20,0xFF0D);
	  my @to   = (0x002B,0x005D,0x005B,0x002E,0x0028,0x0029,0x003F,0x002F,0x0040,0x002D);
	  &utfjp::utf8tr_codepoint(\$g_exclude_keys, \@from, \@to);
	} else {
	  &jcode::h2z_euc(\$g_exclude_keys);
	  &jcode::tr(\$g_exclude_keys,'��-����-�ڣ�-���ܡϡΡ��ʡˡ�������',
		     '0-9A-Za-z+][.()?/@-');
	}
	$g_exclude_keys =~ s/,/\|/g;
    }

    printout("���⡼�ɤǥ���ǥå��������򳫻Ϥ��ޤ�\n");

    # ����ǥå����оݥե�����μ���
    printout("����������ǥå���������ե������������Ƥ��ޤ�\n");
    $files = collectfiles($g_include_dir,\@g_suffix,\@g_exclude_dir,
			  \@g_exclude_reg_dir,\@g_exclude_file,
			  \@g_exclude_reg_file);
    $i = keys(%$files);
    printout("��������λ($i�ե�����)\n");

    # ����ǥå����ե�����Υ����ץ�(�˲�Ū)
    if(!open(FILEOUT,">$g_index")) {
	printout("�ե����륪���ץ󥨥顼(���⡼��)\n");
    }

    # ����ǥå����оݥե������ҤȤ��ɤ߹���ǤϽ��Ϥ��Ƥ���
    foreach $file (keys %$files) {
	my ($i_lang,$i_mtime,$i_fsize,$i_url,$i_title,$i_contents);
	$n_add++;		# �ɲÿ��򥤥󥯥����
	# ����ǥå������� ��
	($i_lang,$i_mtime,$i_fsize,$i_url,$i_title,$i_contents) =
	makedata($file,$g_include_dir,$g_include_url,$g_exclude_keys);
	# ����ǥå����˽��� ��
	print FILEOUT "$file\t$i_lang\t$i_mtime\t$i_fsize\t$i_url\t$i_title\t$i_contents\n";
	printout("���ɲåե�����:$file\n") if($debug);
    }
    printout("����������ǥå������ɲ�($n_add�ե�����)\n");

    # ����ǥå����ե�����Υ�����
    close(FILEOUT);
    printout("������λ($n_add�ե�����)\n") if($debug);

    &utfjp::del_all_tables;  # �� �ޥåԥ󥰥ơ��֥롢�������ѥơ��֥�ʤɤ������롣

    printout("����ǥå��������ϴ�λ���ޤ���\n");
} # END of makeindex_onebyone()

###
### ����ǥå������ɤ߹���
###
sub readindex {
    my $fn = $_[0];		# ����ǥå����Υե�����̾(����)
    my $index = $_[1];		# ����ǥå����ؤλ���(����)
    my $key;			# �ϥå���Υ���
    my $value;			# �ϥå������
    my $i;			# ���󥯥��󥿥���
    local *FILEIN;		# �ե�����ϥ�ɥ� ��

    # �ե�����Υ����ץ�
    open(FILEIN,"<$fn"); # ��

    printout("��������ǥå������ɤ߹���\n") if($debug);

    # ����ǥå������ɤ߹���
    $i = 0;
    while(<FILEIN>) { # ��
	# ���Ԥ���
	chomp;
	# �������ͤ�ʬ��
	($key,$value) = split(/\t/,$_,2);
	# �ϥå������Ͽ
	$index->{$key} = $value;
	$i++;
	printout("��Read:$key\n") if($debug);
    }

    # �ե�����Υ�����
    close(FILEIN); # ��
    printout("������λ($i�ե�����)\n") if($debug);
    return($i);
}

###
### ����ǥå����ν񤭹���
###
sub writeindex {
    my $fn = $_[0];		# ����ǥå����Υե�����̾(����)
    my $index = $_[1];		# ����ǥå����ؤλ���(����)
    my $key;			# �ϥå���Υ���
    my $value;			# �ϥå������
    my $i;			# ���󥯥��󥿥���
    my @unsort = ();
    my @sorted;
    local *FILEOUT;		# �ե�����ϥ�ɥ� ��

    # �ե�����Υ����ץ�(�˲�Ū)
    if(!open(FILEOUT,">$fn")) { # ��
	printout("�ե����륪���ץ󥨥顼\n");
    }

    # �ƥ���ǥå����ν񤭹���
    printout("��������ǥå����ν񤭹���\n") if($debug);

    # �ޤ��ϥå��������
    while(($key,$value) = each(%$index)) {
	push(@unsort,"$key\t$value");
    }
    printout("�����󲽴�λ\n") if($debug);

    # ������
    if($g_sort eq "MODIFY-DESC") {
	@sorted = sort sort_modify_desc @unsort;
    } elsif($g_sort eq "MODIFY-ASC") {
	@sorted = sort sort_modify_asc @unsort;
    } elsif($g_sort eq "TITLE-DESC") {
	@sorted = sort sort_title_desc @unsort;
    } elsif($g_sort eq "TITLE-ASC") {
	@sorted = sort sort_title_asc @unsort;
    } elsif($g_sort eq "URL-DESC") {
	@sorted = sort sort_url_desc @unsort;
    } elsif($g_sort eq "URL-ASC") {
	@sorted = sort sort_url_asc @unsort;
    } else {
	@sorted = @unsort;
    }
    printout("�������ȴ�λ\n") if($debug);

    printout("���񤭽Ф� ") if($debug);
    for($i=0;$i<$#sorted+1;$i++) {
	printout("*") if($debug);
	print FILEOUT "$sorted[$i]\n"; # ��
    }
    printout("\n") if($debug);

    # �ե�����Υ�����
    close(FILEOUT); # ��
    printout("������λ($i�ե�����)\n") if($debug);

    return($i);
}

###
### ����ǥå����оݥե�����μ���
###
sub collectfiles {
    my $dir = $_[0];		# ����ǥå����оݥǥ��쥯�ȥ�(����)
    my $suffix = $_[1];		# �оݥե�����γ�ĥ�Ҥؤλ���(����)
    my $ex_dir = $_[2];		# ���оݥǥ��쥯�ȥ�ؤλ���(����)
    my $ex_reg_dir = $_[3];	# ���оݥǥ��쥯�ȥ�(��)�ؤλ���(����)
    my $ex_file = $_[4];	# ���оݥե�����ؤλ���(����)
    my $ex_reg_file = $_[5];	# ���оݥե�����(��)�ؤλ���(����)
    local %files = ();		# �оݥե�����Υϥå���(�����)
				# key = �ե�����̾
				# val = �ǽ���������

    ## ����ǥå����оݥե�����μ���
    printout("�����оݥե������Ĵ��\n") if($debug);
    reccollect($dir,$suffix,$ex_dir,$ex_reg_dir,$ex_file,$ex_reg_file);

    # ���������оݥե�����Υϥå�����֤�
    printout("������λ\n") if($debug);
    return(\%files);
}

###
### ����ǥå����оݥե�����μ���(�Ƶ���)
###
sub reccollect {
    my $curdir = $_[0];		# �����ȥǥ��쥯�ȥ�(����)
    my $suffix = $_[1];		# �оݥե�����γ�ĥ�Ҥؤλ���(����)
    my $ex_dir = $_[2];		# ���оݥǥ��쥯�ȥ�ؤλ���(����)
    my $ex_reg_dir = $_[3];	# ���оݥǥ��쥯�ȥ�(��)�ؤλ���(����)
    my $ex_file = $_[4];	# ���оݥե�����ؤλ���(����)
    my $ex_reg_file = $_[5];	# ���оݥե�����(��)�ؤλ���(����)
    my @dirs = ();		# �����ȥǥ��쥯�ȥ�˴ޤޤ��ǥ��쥯�ȥ�
    my $file;			# �༡Ĵ������ե�����̾

    # �ǥ��쥯�ȥ�Υ����ץ�
    opendir(DIR,$curdir) or return;
    ## �ǥ��쥯�ȥꥨ��ȥ��Ĵ��
    while($file = readdir(DIR)) {
	my $fpath;

	# �����Ȥȿƥǥ��쥯�ȥ��̵��
	if($file eq "." || $file eq "..") {
	    next;
	}
	# �ǥ��쥯�ȥ���ߤΥե�����̾���Ѵ�
	$fpath = $curdir . $file;
	# �ǥ��쥯�ȥ꤫�ɤ����Υ����å�
	if(isdirectory($fpath) == 1) {
	    # �ե�����ϥǥ��쥯�ȥ�
	    if(isexcluderegdir($file,$ex_reg_dir) == 1) {
		# ���Υǥ��쥯�ȥ�����оݥǥ��쥯�ȥ�
		printout("�����оݥǥ��쥯�ȥ�:$fpath\n") if($debug);
		next;
	    }
	    $fpath .= "/";	# �ǥ��쥯�ȥ�κǸ��"/"���դ���
	    if(isexcludedir($fpath,$ex_dir) == 1) {
		# ���Υǥ��쥯�ȥ�����оݥǥ��쥯�ȥ�
		printout("�����оݥǥ��쥯�ȥ�:$fpath\n") if($debug);
		next;
	    } else {
		# ���Υǥ��쥯�ȥ�ϺƵ������뤿��˥����å�����¸
		push(@dirs,$fpath);
	    }
	} else {
	    # �ե�����ϥǥ��쥯�ȥ�ǤϤʤ�
	    if(isexcluderegfile($file,$ex_reg_file) == 1) {
		# ���Υե���������оݥե�����
		printout("�����оݥե�����:$fpath\n") if($debug);
		next;
	    } elsif(isexcludefile($fpath,$ex_file) == 1) {
		# ���Υե���������оݥե�����
		printout("�����оݥե�����:$fpath\n") if($debug);
		next;
	    } elsif(issuffix($fpath,$suffix) == 1) {
		# ���Υե�����γ�ĥ�Ҥ��оݥե�����γ�ĥ��
		my $mtime;	# �ǽ���������
		# �ǽ���������μ���
		$mtime = getmodifytime($fpath);
		# (�оݥե�����̾,�ǽ���������)�Υϥå������Ͽ
		$files{$fpath} = $mtime;
		printout("���оݥե�����:$fpath\n") if($debug);
	    } else {
		# ���Υե�����γ�ĥ�Ҥ��оݥե�����γ�ĥ�ҤǤϤʤ�
		printout("�����оݳ�ĥ��:$fpath\n") if($debug);
		next;
	    }
	}
    }
    # �ǥ��쥯�ȥ�Υ�����
    closedir(DIR);

    ## ��¸���Ƥ������ҥǥ��쥯�ȥ�ǺƵ�������
    while(@dirs) {
	my $childdir;
	# ��¸���Ƥ����ҥǥ��쥯�ȥ�Υ����å�����ݥå�(���եȤ�����)
	$childdir = shift(@dirs);
	## �Ƶ��ƤӽФ�
	reccollect($childdir,$suffix,$ex_dir,$ex_reg_dir,
		   $ex_file,$ex_reg_file);
    }
}

###
### �ǥ��쥯�ȥ꤫�ɤ���
###
sub isdirectory {
    my $file = $_[0];		# �ե�����̾(����)

    if(-d $file) {
	return(1);
    } else {
	return(0);
    }
}

###
### ���оݥǥ��쥯�ȥ꤫�ɤ���
###
sub isexcludedir {
    my $dir = $_[0];		# �ǥ��쥯�ȥ�̾(����)
    my $exclude_dir = $_[1];	# ���оݥǥ��쥯�ȥ�ؤλ���(����)
    my $i;

    for($i=0;$i<@$exclude_dir;$i++) {
	return(1) if($dir eq $exclude_dir->[$i]);
    }
    return(0);
}

###
### ���оݥǥ��쥯�ȥ꤫�ɤ���(����ɽ����)
###
sub isexcluderegdir {
    my $dir = $_[0];		# �ǥ��쥯�ȥꥨ��ȥ꡼(����)
    my $exclude_reg_dir = $_[1]; # ���оݥǥ��쥯�ȥ�ؤλ���(����)
    my $pat;
    my $result;
    my $i;

    for($i=0;$i<@$exclude_reg_dir;$i++) {
	$pat = $exclude_reg_dir->[$i];
	$result = eval { $dir =~ /$pat/ };
	return(1) if($result);
    }
    return(0);
}

###
### ���оݥե����뤫�ɤ���
###
sub isexcludefile {
    my $file = $_[0];		# �ե�����̾(����)
    my $exclude_file = $_[1];	# ���оݥե�����ؤλ���(����)
    my $i;

    for($i=0;$i<@$exclude_file;$i++) {
	return(1) if($file eq $exclude_file->[$i]);
    }
    return(0);
}

###
### ���оݥե����뤫�ɤ���(����ɽ����)
###
sub isexcluderegfile {
    my $file = $_[0];		# �ǥ��쥯�ȥꥨ��ȥ꡼(����)
    my $exclude_reg_file = $_[1]; # ���оݥե�����ؤλ���(����)
    my $pat;
    my $result;
    my $i;

    for($i=0;$i<@$exclude_reg_file;$i++) {
	$pat = $exclude_reg_file->[$i];
	$result = eval { $file =~ /$pat/ };
	return(1) if($result);
    }
    return(0);
}

###
### �оݥե�����γ�ĥ�Ҥ��ɤ���
###
sub issuffix {
    my $file = $_[0];		# �ե�����̾(����)
    my $suffix = $_[1];		# �оݥե�����γ�ĥ�Ҥؤλ���(����)
    my $flag;			# �ե饰
    my $i;

    for($i=0,$flag=0;$i<@$suffix;$i++) {
	my $pattern = $suffix->[$i];
	$pattern =~ s/\./\\\./;
	$flag = 1 if($file =~ /$pattern$/);
    }
    if($flag == 1) {
	return(1);
    } else {
	return(0);
    }
}

###
### �ե�����κǽ�������������
###
sub getmodifytime {
    my $file = $_[0];		# �ե�����̾(����)

    return((stat($file))[9]);
}

###
### �ե����륵��������� ��
###
sub getfilesize {
    my $file = $_[0];		# �ե�����̾(����)

    return((stat($file))[7]);
}

###
### ����ǥå����ѥǡ�������
###
sub makedata {
    my $file = $_[0];		# �ե�����̾(����)
    my $target_dir = $_[1];	# �оݥǥ��쥯�ȥ�(����)
    my $target_url = $_[2];	# �оݥǥ��쥯�ȥ��URL(����)
    my $exclude_keys = $_[3];	# ���оݥ�����ɷ�(����)
    my $mtime;			# �ǽ���������(�����)
    my $fsize;			# �ե����륵����(�����) ��
    my $lang='';		# lang°��(�����) ��
    my $url;			# URL(�����)
    my $title;			# �����ȥ�(�����)
    my $contents;		# ����ǥå����Ѥ�HTML�����(�����)
    local *FILEIN;		# �ե�����ϥ�ɥ� ��
if($utf_mode) {
    my $html_xml=0;             # ��HTML, XML(XHTML)�Ǥ���� 1
}

    ## �ǽ���������μ���
    $mtime = getmodifytime($file);

    ## �ե����륵�����μ��� ��
    $fsize = getfilesize($file);

    ## URL�κ���
    $url = $file;
    $url =~ s/^$target_dir/$target_url/;

    ## �ե�������ɤ߹���
    if($utf_mode) { # ��
      local $/ = undef;
      open(FILEIN,"<$file");
      binmode FILEIN;             # UTF-16, 32�ʤɰ����Υե�����ϥХ��ʥ꡼�⡼�ɤǤʤ���������ɤ߹���ʤ���
      $contents = <FILEIN>;
      close(FILEIN);
    } else {
      open(FILEIN,"<$file"); # ��
      $contents = "";
      while(<FILEIN>) { # ��
	  chomp;			# ���Ԥκ��
	  $contents .= $_;	# �Хåե��˹Ԥ��ɲ�
      }
      close(FILEIN); # ��
    }

    ## ���������ɤ��Ѵ�
    if($utf_mode) { # ��
      &utfjp::convert(\$contents, "utf8"); # UTF-8���Ѵ�
      &utfjp::chop_eol(\$contents,"utf8"); # ���Ԥκ��
      &utfjp::utf8h2z_kana(\$contents);    # Ⱦ�ѥ��ʤ����ѥ��ʤ��Ѵ�
    } else {
      &jcode::convert(\$contents, "euc", "", "z"); # Ⱦ�ѥ��ʤ����ѥ��ʤ��Ѵ�
    }

    ## �����ȥ���������
    $contents =~ /<title.*?>(.*?)<\/title>/i;
    $title = $1;
    $title =~ s/\s+/ /g;
    $title =~ s/^\s+//;
    if($utf_mode) { # ��
      &utfjp::ref_to_utf8(\$title);    # ʸ�����Ȥ�ʸ�����Τ�Τ��ִ�(title�����������Ƥ���Τ�HTML�ְ㤤�ʤ�)
      &utfjp::utf8z2h_an(\$title);
      my @from = (0xFF0B,0xFF3D,0xFF3B,0xFF0E,0xFF08,0xFF09,0xFF1F,0xFF0F,0xFF20,0xFF0D);
      my @to   = (0x002B,0x005D,0x005B,0x002E,0x0028,0x0029,0x003F,0x002F,0x0040,0x002D);
      &utfjp::utf8tr_codepoint(\$title, \@from, \@to);
    } else {
      &jcode::tr(\$title,'��-����-�ڣ�-���ܡϡΡ��ʡˡ�������',
                 '0-9A-Za-z+][.()?/@-');
    }

    ## �����ȥ�ʸ������ʸ�˴ޤ��
    $contents = $title . $contents;

    ## ������ץȤ䥿���ȥ������
    $contents =~ s/<[Ss][Cc][Rr][Ii][Pp][Tt].*?<\/[Ss][Cc][Rr][Ii][Pp][Tt]>|<[Tt][Ii][Tt][Ll][Ee].*?<\/[Tt][Ii][Tt][Ll][Ee]>|<[Ss][Tt][Yy][Ll][Ee].*?<\/[Ss][Tt][Yy][Ll][Ee]>|<[Cc][Oo][Dd][Ee].*?<\/[Cc][Oo][Dd][Ee]>|<\?.*?\?>|<%.*?%>/ /g;

    ## �����ȥ����ΰ����Ǥʤ� -- ��̵���� ��
    $contents =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

    ## ����Ҥ�ޤ�ƥ����Ȥ�����Ƚ���
    # special thanks  http://www.din.or.jp/~ohzaki/perl.htm
    $contents =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)/ /g;

    ## ̵�������줿 -- ���᤹ ��
    $contents =~ s/&#45;&#45;/--/gs;

    ## lang°������Ф���(���Ϥ�) ��
    $lang = &utfjp::getlang($contents);

    ## HTML, XML(XHTML)�Ǥ��뤫�ɤ����δʰ�Ƚ�� ��
    if($utf_mode) {
      $html_xml = &utfjp::is_html_or_xml(\$contents);
    }

    ## �󥤥�ǥå����ս�κ�� ��
    ## special thanks  ��ή���֤���
    $contents =~ s/<[Mm][Ss][Ee][Aa][Rr][Cc][Hh]>.*?<\/[Mm][Ss][Ee][Aa][Rr][Cc][Hh]>/ /g;

    ## alt°����ʸ����߽�
    if($qarg->{'rescuealt'}) {
	$altstr = "";
	while($contents =~ /alt=["'](.*?)["']/ig) {
	    $altstr .= " $1";
	}
	while($contents =~ /alt=([^"'].*?)[\s\t>]/ig) {
	    $altstr .= " $1";
	}
	$contents .= $altstr;
    }

    ## ����������
    $contents =~ s/<(?:[^"'>]|"[^"]*"|'[^']*')*>/ /g;

    ## ʸ�����Ȥ�ʸ�����Τ�Τ��ִ�(HTML, XML�ξ��Τ�) ��
    &utfjp::ref_to_utf8(\$contents) if ($html_xml);

    ## ����ʸ���κ��
    if($utf_mode) { # ��
      $contents =~ s/\x0D\x0A|\x0D|\x0A|\xE2\x80\xA8|\xE2\x80\xA9/ /g; # ���ԥ����ɤ�Ⱦ�Ѷ����
      my @from = (0x3000);
      my @to   = (0x0020);
      &utfjp::utf8tr_codepoint(\$contents, \@from, \@to);
    } else {
      $contents =~ s/\x0D\x0A|\x0D|\x0A/ /g; # �Ƽ���ԥ����ɤ�����
      &jcode::tr(\$contents,'��',' '); # ���Ѷ����Ⱦ�Ѷ����
    }
    $contents =~ s/\t/ /g;      # ���֤�Ⱦ�Ѷ����
    $contents =~ s/\s+/ /g;	# ���İʾ�³������ʸ����������

    ## ����ǥå����ν�����(Ⱦ�ѱѿ������ѱѿ����Ѵ�)
    if($utf_mode) { # ��
#      &utfjp::ref_to_utf8(\$contents) if ($html_xml);  # ʸ�����Ȥ�ʸ�����Τ�Τ��ִ�(HTML, XML�ξ��Τ�)
      &utfjp::utf8z2h_an(\$contents);
      my @from = (0xFF0B,0xFF3D,0xFF3B,0xFF0E,0xFF08,0xFF09,0xFF1F,0xFF0F,0xFF20,0xFF0D);
      my @to   = (0x002B,0x005D,0x005B,0x002E,0x0028,0x0029,0x003F,0x002F,0x0040,0x002D);
      &utfjp::utf8tr_codepoint(\$contents, \@from, \@to);
    } else {
      &jcode::tr(\$contents,'��-����-�ڣ�-���ܡϡΡ��ʡˡ�������',
                 '0-9A-Za-z+][.()?/@-');
    }

    ## ���оݥ�����ɤκ��
    if($exclude_keys ne "") {
	$contents =~ s/$exclude_keys//g;
    }

    return($lang,$mtime,$fsize,$url,$title,$contents); # ��
}

####################
### �������Ѵؿ� ###
####################

###
### �ǽ���������߽�(MODIFY-DESC) ��
###
sub sort_modify_desc {
    my ($aval, $bval);

    (undef,undef,$aval,undef,undef,undef,undef) = split(/\t/,$a);
    (undef,undef,$bval,undef,undef,undef,undef) = split(/\t/,$b);
    $bval <=> $aval;
}

###
### �ǽ��������ﾺ��(MODIFY-ASC) ��
###
sub sort_modify_asc {
    my ($aval, $bval);

    (undef,undef,$aval,undef,undef,undef,undef) = split(/\t/,$a);
    (undef,undef,$bval,undef,undef,undef,undef) = split(/\t/,$b);
    $aval <=> $bval;
}

###
### �����ȥ�߽�(TITLE-DESC) ��
###
sub sort_title_desc {
    my ($aval, $bval);

    (undef,undef,undef,undef,undef,$aval,undef) = split(/\t/,$a);
    (undef,undef,undef,undef,undef,$bval,undef) = split(/\t/,$b);
    $bval cmp $aval;
}

###
### �����ȥ뾺��(TITLE-ASC) ��
###
sub sort_title_asc {
    my ($aval, $bval);

    (undef,undef,undef,undef,undef,$aval,undef) = split(/\t/,$a);
    (undef,undef,undef,undef,undef,$bval,undef) = split(/\t/,$b);
    $aval cmp $bval;
}

###
### URL�߽�(URL-DESC) ��
###
sub sort_url_desc {
    my ($aval, $bval);

    (undef,undef,undef,undef,$aval,undef,undef) = split(/\t/,$a);
    (undef,undef,undef,undef,$bval,undef,undef) = split(/\t/,$b);
    $bval cmp $aval;
}

###
### URL����(URL-ASC) ��
###
sub sort_url_asc {
    my ($aval, $bval);

    (undef,undef,undef,undef,$aval,undef,undef) = split(/\t/,$a);
    (undef,undef,undef,undef,$bval,undef,undef) = split(/\t/,$b);
    $aval cmp $bval;
}

1;
