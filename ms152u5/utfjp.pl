package utfjp;
#
# utfjp.pl ���ܸ�ʸ�������� <-> Unicode������Ѵ��饤�֥��
#
# Ver 1.02 2016/05/08
#
# Copyright(C) 2004-2016 ��ή����. All rights reserved.
#
#
# Unicode̤�б���Perl��Unicode�򰷤�����Υ饤�֥��
#
#
# �ܥ��եȥ������ϰʲ������ѵ����Ʊ�դ������Τ߻��Ѥ��뤳�Ȥ��Ǥ��ޤ���
# �ʲ������ѵ�����Ʊ�դ������Τߡ�
# �ܥ��եȥ������λ��Ѹ���������(��ή����)������Ϳ����뤳�Ȥˤʤ�ޤ���
# (�����ޤǤ���ѵ����Ǥ��ꡢ���Ѹ������Ϥ����櫓�ǤϤ���ޤ���)
#
# [���ѵ���]
# (1)�ܥ饤�֥�ꡦ���եȥ�����(utfjp.pl)�ϥե꡼���եȥ������Ǥ���
#    ����Ϻ����ԡ���ή���֡ˤ˵�°�������٤Ƥθ�����α�ݤ���Ƥ��ޤ���
# (2)�ܥ饤�֥�ꡦ���եȥ���������Ѥ������Ȥˤ�뤤���ʤ�»�����ȥ�֥롢»������̤ˤĤ��Ƥ�
#    �����Ԥ���Ǥ���餤�ޤ���
# (3)�ܥ饤�֥�ꡦ���եȥ�����(utfjp.pl)������ɽ�������ѵ���������뤳�ȤϤǤ��ޤ���
# (4)�ܥ饤�֥�ꡦ���եȥ�������������Ū�ˤ����Ƥϼ�ͳ�ˤ��Ȥ����������ޤ���
# (5)�ܥ饤�֥�ꡦ���եȥ�����������Ū�ǻȤ��ˤϡ������Ԥ�����̤Ǥε��Ĥ����������ɬ�פ�����ޤ���
# (6)���Ѥ��ʤ����֤Ǥ�utfjp.pl�κ����ۤϼ�ͳ�Ǥ��������ۤ˺ݤ��ơ�
#    �����Ԥλ���������ξ���������ɬ�פϤ���ޤ��󤷡������Ԥ�Ϣ����ɬ�פϤ���ޤ���
# (7)���Ѥ�����utfjp.pl�κ����ۤϡ����Ѥ���Ƥ��뤳�Ȥ���������Ƥ��ꡢ
#    ����˲��Ѳս꤬��������Ƥ�����Τ߲�ǽ�Ǥ���
#    ���ξ��κ����ۤˤĤ��Ƥ⡢�����Ԥλ���������ξ���������ɬ�פϤ���ޤ��󤷡������Ԥ�Ϣ����ɬ�פϤ���ޤ���
# (8)��(6),(7)��κ����ۤ�ȼ�ä�ȯ�����������ʤ�»�����ȥ�֥롢»������̤ˤĤ��Ƥ�
#    �����ԡ���ή���֡ˤ���Ǥ���餤�ޤ���
# (9)�ܥ饤�֥�ꡦ���եȥ������ΥХ����Զ��ˤˤĤ��ƺ����ԤϽ��������̳���餤�ޤ���
# (10)�����Ԥ��ܥ饤�֥�ꡦ���եȥ������˴ؤ�����ꡦ������������̳���餤�ޤ���
# (11)�ܥ饤�֥�ꡦ���եȥ�������HP����ʸ�������󥸥�msearch��Unicode���б������뤳�Ȥ�տޤ���
#     ���줿��ΤǤ��ꡢ�������ϰ��ڹ�θ����Ƥ��ޤ���
#     �ޤ����͡����󥿡��ե���������ͽ��ʤ��ѹ����뤳�Ȥ�����ޤ���
#
#
# ���ܥե������ɬ��EUC+LF��ʸ��������:EUC�����ԥ�����:LF�ˤ���¸���Ƥ�����������
#
#
# [��ջ���]
# (1)�ץ������Ǥ�Ⱦ�ѱѿ�����(ASCII)�Τߤ���Ѥ��Ƥ���������
# ����ʸ���ϥ�������ǤΤ߻��Ѥ���褦�ˤ��Ƥ���������
# �����EUC-JP����¸����¹Ԥ���Ƥ���Perl������ץȤ���Ǥ��ܥ饤�֥�����ѤǤ���褦�ˤ��뤿��Ǥ���
#
# (2)�ܥ饤�֥���ư��ˤ�jcode.pl��ɬ�פǤ���
# jcode.pl��Ʊ���ǥ��쥯�ȥ��utfjp.pl,utfjpmap.txt,utfjpent.txt���֤��Ƥ���������
# utfjpsup���֥ǥ��쥯�ȥ��jcode.pl��Ʊ���ǥ��쥯�ȥ���֤��Ƥ���������
# �ʤ����ܥ饤�֥���require����������ץȤǤϡ�jcode.pl�Υ��֥롼�����
# ľ�ܡ���ͳ�˸ƤӽФ����Ȥ��Ǥ��ޤ���
#
# [����]
#
# Ver 1.00 2004/04/15 �ǽ�ΥС������
#
# Ver 1.01 2012/01/29 HTML5�б��Τ���ν���
#   sub _get_html_encoding()���ʸ��������̾��вս��HTML5���б��Ǥ���褦�˽���������
#
# Ver 1.02 2016/05/08 ������
#   my������оݤ�2�ѿ��ʾ夢�����ɬ�פʳ�̤��ɵ������� (��) my $a,$b; -> my ($a,$b);
#
# use bytes;  # Unicode�б���Perl��(character semantics�Ǥʤ�)byte semantics�������롣

# ������롼���󤬤ޤ��ƤФ�Ƥ��ʤ��Ȥ���init()��¹Ԥ��롣
&_init unless defined $utfjp_init_done;



###
###   sub _init()
###
###   ������롼����
###
sub _init {
  require './jcode.pl';
  $utfjp_init_done = 1;

  # �ޥåԥ󥰥ơ��֥�Υե�����̾
  $mappingju  = './utfjpmap.txt';  # JIS<->Unicode �ޥåԥ󥰥ơ��֥�
  $mappingent = './utfjpent.txt';  # ʸ�����λ���  �ޥåԥ󥰥ơ��֥�
  $supfolder  = './utfjpsup/';     # SBCS, DBCS�ѥޥåԥ󥰥ơ��֥���֤��ǥ��쥯�ȥ�̾

  # �ޥåԥ󥰥ơ��֥������ѥե饰(�ѹ�����������sub mappingmode��Ȥ���)
  $mapping_j2u=1;  # JIS -> Unicode�����Υޥåԥ󥰥ơ��֥��������롣
  $mapping_u2j=1;  # Unicode -> JIS�����Υޥåԥ󥰥ơ��֥��������롣

  # UTF���󥳡��ǥ��󥰤�BOM
  $utf8_bom      = "\xEF\xBB\xBF";      # BOM for UTF-8
  $utf16le_bom   = "\xFF\xFE";          # BOM for UTF-16LE
  $utf16be_bom   = "\xFE\xFF";          # BOM for UTF-16BE
  $utf32le_bom   = "\xFF\xFE\x00\x00";  # BOM for UTF-32LE
  $utf32be_bom   = "\x00\x00\xFE\xFF";  # BOM for UTF-32BE

  # UTF���󥳡��ǥ���ʸ���γƼ�����ɽ��
  $utf8_1byte    = "[\x00-\x7F]";                                  # UTF-8�Ǥ�1�Х���ʸ��
  $utf8_2byte    = "[\xC0-\xDF][\x80-\xBF]";                       # UTF-8�Ǥ�2�Х���ʸ��
  $utf8_3byte    = "[\xE0-\xEF][\x80-\xBF][\x80-\xBF]";            # UTF-8�Ǥ�3�Х���ʸ��
  $utf8_4byte    = "[\xF0-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF]"; # UTF-8�Ǥ�4�Х���ʸ��
#  # UTF-8���󥳡��ǥ��󥰤θ�̩������ɽ����̤���ѡ�
#  $utf8_2byte    = "[\xC2-\xDF][\x80-\xBF]";                                       # UTF-8�Ǥ�2�Х���ʸ��
#  $utf8_3byte    = "\xE0[\xA0-\xBF][\x80-\xBF]|[\xE1-\xEC][\x80-\xBF][\x80-\xBF]|".
#                   "\xED[\x80-\x9F][\x80-\xBF]|[\xEE-\xEF][\x80-\xBF][\x80-\xBF]"; # UTF-8�Ǥ�3�Х���ʸ��
#  $utf8_4byte    = "\xF0[\x90-\xBF][\x80-\xBF][\x80-\xBF]|".
#                   "[\xF1-\xF3][\x80-\xBF][\x80-\xBF][\x80-\xBF]|".
#                   "\xF4[\x80-\x8F][\x80-\xBF][\x80-\xBF]";                        # UTF-8�Ǥ�4�Х���ʸ��
  $utf8_hira     = "\xE3\x81[\x81-\xBF]|\xE3\x82[\x80-\x93]";      # UTF-8�ǤΤҤ餬�ʤ�����ɽ��
  $utf8_kata     = "\xE3\x82[\xA1-\xBF]|\xE3\x83[\x80-\xB6]";      # UTF-8�Ǥ����ѥ������ʤ�����ɽ��
  $utf8_hkdaku   = "\xEF\xBD[\xB6-\xBF]\xEF\xBE\x9E|"
                  ."\xEF\xBE[\x80-\x84\x8A-\x8E]\xEF\xBE\x9E|"
                  ."\xEF\xBE[\x8A-\x8E]\xEF\xBE\x9F|"
                  ."\xEF\xBD\xB3\xEF\xBE\x9E|"
                  ."\xEF\xBD\xA6\xEF\xBE\x9E|"
                  ."\xEF\xBE\x9C\xEF\xBE\x9E";                     # UTF-8�Ǥ�Ⱦ�ѥ������ʡ�������Ⱦ�����ˤ�����ɽ��
  $utf8_nl       = "\x0D|\x0A|\x0D\x0A|\xE2\x80\xA8|\xE2\x80\xA9"; # UTF-8�Ǥβ���ʸ��������ɽ��(U+2028,U+2029)

  $utf16le_2byte = "[\x00-\xFF][\x00-\xD7\xE0-\xFF]";              # UTF-16LE�Ǥ�1ʸ��(BMP��ʸ��)
  $utf16be_2byte = "[\x00-\xD7\xE0-\xFF][\x00-\xFF]";              # UTF-16BE�Ǥ�1ʸ��(BMP��ʸ��)
  $utf16le_4byte = "[\x00-\xFF][\xD8-\xDB][\x00-\xFF][\xDC-\xDF]"; # UTF-16LE�Ǥ�1ʸ��(Surrogate�ΰ��ʸ��)
  $utf16be_4byte = "[\xD8-\xDB][\x00-\xFF][\xDC-\xDF][\x00-\xFF]"; # UTF-16BE�Ǥ�1ʸ��(Surrogate�ΰ��ʸ��)
  $utf32le_4byte = "[\x00-\xFF][\x00-\xFF][\x00-\x10]\x00";        # UTF-32LE�Ǥ�1ʸ��
  $utf32be_4byte = "\x00[\x00-\x10][\x00-\xFF][\x00-\xFF]";        # UTF-32BE�Ǥ�1ʸ��

#  # UTF���󥳡��ǥ��󥰥ƥ����Ȥ�����ɽ����̤���ѡ�
#  $utf16be       = "^$utf16be_bom(?:$utf16be_2byte|$utf16be_4byte)+\$";  # BOM��UTF-16BE�ƥ����Ȥ�����ɽ��
#  $utf16le       = "^$utf16le_bom(?:$utf16le_2byte|$utf16le_4byte)+\$";  # BOM��UTF-16LE�ƥ����Ȥ�����ɽ��
#  $utf32be       = "^$utf32be_bom(?:$utf32be_4byte)+\$";                 # BOM��UTF-32BE�ƥ����Ȥ�����ɽ��
#  $utf32le       = "^$utf32le_bom(?:$utf32le_4byte)+\$";                 # BOM��UTF-32LE�ƥ����Ȥ�����ɽ��
#  $utf8          = "^(?:$utf8_bom)?(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)+\$";  # UTF-8�ƥ����Ȥ�����ɽ��

  # EUC-JPʸ���γƼ�����ɽ��
  $euc_1byte     = "[\x00-\x7F]";		                           # EUC�Ǥ�JIS X 0201 ASCII
  $euc_hkana     = "\x8E[\xA1-\xDF]";	                           # EUC�Ǥ�JIS X 0201 Ⱦ�ѥ�������
  $euc_kan2      = "[\xA1-\xFE][\xA1-\xFE]";                       # EUC�Ǥ�JIS X 0208 ����ʸ��
  $euc_kan3      = "\x8F[\xA1-\xFE][\xA1-\xFE]";                   # EUC�Ǥ�JIS X 0211 ����ʸ��

  # ISO-2022-JPʸ���γƼ�����ɽ��
  $esc_hkana     = "\x1B\x28\x49";                                 # ISO-2022-JP ESC�������� Ⱦ�ѥ���
  $esc_ascii     = "\x1B\x28\x42";                                 # ISO-2022-JP ESC�������� ASCII
  $jis_so        = "\x0E";                                         # ISO-2022-JP SO(Shift Out)
  $jis_si        = "\x0F";                                         # ISO-2022-JP SI(Shift In)

 # SBCSʸ��������ɽ��
  $sbcs_1char    = "[\x00-\xFF]";                                  # SBCS(ISO8859, CodePage, etc)�Ǥ�1ʸ��


} ## END of sub _init()



###
###   sub del_all_tables
###
###   �Ѵ������ѤγƼ�ơ��֥����(̤�������)�ˤ��롣
###   �ä���Unicode <-> Unicode�֤��Ѵ�����λ�����顢®�䤫�˸ƤӽФ��ƥ����������褦�ˤ��롣
###
sub del_all_tables {

 # UTF-8<->EUC ��Ϣ
 undef $table_exist;
 undef %tbl_utf8toeuc;
 undef %tbl_euctoutf8;

 # SBCS <->UTF-8 ��Ϣ
 undef $tbl_sbcs_now;
 undef %tbl_sbcs2utf8;
 undef %tbl_utf8tosbcs;

 # Ⱦ�ѥ������� -> ���ѥ������� ��Ϣ
 undef $tbl_h2z_kana_exist;
 undef %tbl_h2z_kana_daku;
 undef %tbl_h2z_kana;

 # ���ѱѿ� -> Ⱦ�ѱѿ� ��Ϣ
 undef $tbl_z2h_an_exist;
 undef %tbl_z2h_an;

 # ʸ������ -> UTF-8 ��Ϣ
 undef $tbl_ref_to_utf8_exist;
 undef %tbl_ref_to_utf8;
 undef $bitstr_numref_except;

} ## END of sub del_all_tables



### -------------------------------------
### �ʲ���ʸ��������Ƚ��Υ��֥롼���� 
### -------------------------------------



###
###   sub getcode()
###
###   ʸ�����ʸ�������ɤ��֤���
###
###   �ޤ�Unicode�����Ǥ��뤫��Ĵ�١�������������
###   �ʲ��Τ����줫���֤���
###
###   'utf32be'    : UTF-32 Big Endian
###   'utf32le'    : UTF-32 Little Endian
###   'utf16be'    : UTF-16 Big Endian
###   'utf16le'    : UTF-16 Little Endian
###   'utf8'       : UTF-8
###
###   UTF-32LE��UTF-16LE�Ǥ���ȸ�Ƚ�ꤹ��Τ��ɻߤ��뤿�ᡢ
###   UTF-32�Ǥ��뤫�ɤ�����Ƚ���UTF-16�Ǥ��뤫�ɤ�����Ƚ�������˹Ԥ���
###
sub getcode {
  local(*s)   = @_;  # Ƚ���о�ʸ����ʻ����Ϥ���
  my $matched = 0;
  my $code    ='';
  my @judge   =();
  my $guess   = 0;

  if($s =~ /^$utf32be_bom/o) {
	$matched = 1;
	$code = 'utf32be';

  } elsif($s =~ /^$utf32le_bom/o) {
	$matched = 1;
	$code = 'utf32le';

  } elsif($s =~ /^$utf16be_bom/o) {
	$matched = 1;
	$code = 'utf16be';

  } elsif($s =~ /^$utf16le_bom/o) {
	$matched = 1;
	$code = 'utf16le';

  } else {
    # UTF-8, SJIS, EUC�֤�Ƚ��Ͽ��Ť˹Ԥ���
#    if($s =~ /$utf8/o) { push(@judge, 'utf8'); }  # UTF-8�Ȥ��ƹ��פ��뤫?
#    ($guess,$code)    =  &jcode::getcode(\$s);    # jcode.pl��Ƚ��
#    if($guess)         { push(@judge, $code) unless($code eq ''); }

    if(@judge==1) {
      $matched =1;
      $code    =$judge[0];
      return(wantarray ? ($matched, $code) : $code);

    } else {
      ($guess,$code)    = &_get_html_encoding($s); # HTML���󥳡��ǥ��󥰤Υ����å�
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }

      ($guess,$code)    = &_get_xml_encoding($s);  # XML(XHTML)���󥳡��ǥ��󥰤Υ����å�
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }

      if($s =~ /^$utf8_bom/o) {                    # UTF-8��BOM�����ä��顢UTF-8�Ǥ�������ꤹ�롣
        $matched = 1;
        $code    = 'utf8';
        return(wantarray ? ($matched, $code) : $code);
      }

      ($guess,$code)    = &_check_kana(\$s);       # UTF-8���ʥ����å�(UTF-8N����ޡ������å����ܸ�ƥ����Ȥ򽦤�����)
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }

      ($guess,$code)    = &_check_kana_multi(\$s); # UTF-8���ʥ����å�2(UTF-8N����ޡ������å����ܸ�ƥ����Ȥ򽦤�����)
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }
    } ## END of if(@judge==1)...

    # ����Ǥ�Ƚ�ꤷ����ʤ����(���֤�SJIS��EUC����ޡ������åץƥ�����)��jcode.pl��Ƚ���̤򤽤Τޤ��֤���
    ($matched,$code) = &jcode::getcode(\$s);

  }  ## END of if($s=~ /^$utf32be_bom/o)...

  return(wantarray ? ($matched, $code) : $code);
}  ## END of sub getcode()



###
###   sub _check_kana()
###
###   UTF-8�ǤҤ餬�ʡ����ѥ������ʥ����å����ߡ�Ƚ���̤��֤���(Ϣ³4ʸ����1��ʾ�и����뤳��)
###
###   UTF-8�˱�����Ҥ餬��(���ѥ�������)4ʸ���ΥХ��Ȥ��¤Ӥ�SJIS,EUC�ǤϤޤ��и������ʤ��Ȥιͤ��˴�Ť���
###
###   &_check_kana(\$line)
###
sub _check_kana {
  local(*s)   = @_;   # Ƚ���о�ʸ����ʻ����Ϥ���
  my $matched = 0;
  my $code    ='';

  if($s =~ /(?:$utf8_hira|$utf8_kata){4}/o) {
    $matched = 1;
    $code    = 'utf8';
  }

  return(wantarray ? ($matched, $code) : $code);
} ## END of sub _check_kana



###
###   sub _check_kana_multi()
###
###   UTF-8�ǤҤ餬�ʡ����ѥ������ʥ����å����ߡ�Ƚ���̤��֤���(Ϣ³3ʸ����4��ʾ�и����뤳��)
###
###   _check_kana_multi(\$line)
###
sub _check_kana_multi {
  local(*s)   = @_;   # Ƚ���о�ʸ����ʻ����Ϥ���
  my $matched = 0;
  my $code    ='';
  my $count   = 0;

  $count = $s =~ s/((?:$utf8_hira|$utf8_kata){3})/$1/go;

  if($count >= 4) {
    $matched = 1;
    $code    = 'utf8';
  }

  return(wantarray ? ($matched, $code) : $code);
} ## END of sub _check_kana_multi



###
###   sub _get_html_encoding()
###
###   HTML��charset��Ĵ�٤��֤���
###   �о�ʸ�����ʸ�������ɤ�ASCII�ϥ��󥳡��ǥ��󥰤Ǥ��뤳�ȡ�(UTF-16, 32���Բġ�)
###   ʸ�������ɤ�Ƚ�ꤹ�뤿���sub�ʤΤǡ��ɤ�ʸ�������ɤ�ʸ���󤬤�äƤ��뤫�Ϥ狼��ʤ���
###   UTF-8��BOM���Ĥ��Ƥ��뤫�⤷��ʤ���
###
###   _get_html_encoding($line)
###
sub _get_html_encoding {
  my $s       = $_[0];   # Ƚ���о�ʸ��������Ϥ���
  my $mime    = '';
  my $matched = 0;
  my $code    = '';

  # �����Υ���������
  # idea by �ޤäȤ���
  $s =~ s{<script.*?</script>|<style.*?</style>|<code.*?</code>|<\?.*?\?>|<%.*?%>}{ }ig;

  # �����ȥ����ΰ����Ǥʤ� -- ��̵����
  $s =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

  # �����Ƚ��������ҥ������б���
  # Tack sa mycket!  http://www.din.or.jp/~ohzaki/perl.htm
  $s =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)//gs;

  # ̵�������줿 -- ���᤹
  $s =~ s/&#45;&#45;/--/gs;

  # <html>���������ä���HTML�Ȥߤʤ���
  # <meta>�����ǻ��ꤵ�줿ʸ��������̾����Ф��롣
  if($s =~ m{<html.*?>}is) {
    #    $s =~ m{<meta\s[^>]*?text/html\s*?;\s*?charset\s*?=(.*?)['"]}is;
    $s =~ m{<meta\s[^>]*?charset\s*?=(.*?)['"]}is;
    $mime = $1;
    $mime =~ s/\s+//g;
    ($matched, $code) = &_mime_to_sname($mime);
  }

  return(wantarray ? ($matched, $code) : $code);
} ## END of sub _get_html_encoding



###
###   sub _get_xml_encoding()
###
###   XML(�� XHTML)��encoding��Ĵ�٤��֤���
###   �о�ʸ�����ʸ�������ɤ�ASCII�ϥ��󥳡��ǥ��󥰤Ǥ��뤳�ȡ�(UTF-16, 32���Բġ�)
###   ʸ�������ɤ�Ƚ�ꤹ�뤿���sub�ʤΤǡ��ɤ�ʸ�������ɤ�ʸ���󤬤�äƤ��뤫�Ϥ狼��ʤ���
###   UTF-8��BOM���Ĥ��Ƥ��뤫�⤷��ʤ���
###
###   _get_xml_encoding($line)
###
sub _get_xml_encoding {
  my $s       = $_[0];   # Ƚ���о�ʸ��������Ϥ���
  my $mime    = '';
  my $matched = 0;
  my $code    = '';

  # �����Υ���������
  # idea by �ޤäȤ���
  $s =~ s{<script.*?</script>|<style.*?</style>|<code.*?</code>|<%.*?%>}{ }ig; # <\?.*?\?> �ϳ�������

  # �����ȥ����ΰ����Ǥʤ� -- ��̵����
  $s =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

  # �����Ƚ��������ҥ������б���
  # Tack sa mycket!  http://www.din.or.jp/~ohzaki/perl.htm
  $s =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)//gs;

  # ̵�������줿 -- ���᤹
  $s =~ s/&#45;&#45;/--/gs;

  # XML��������ä���XML�Ȥߤʤ���
  # encoding����ǻ��ꤵ�줿ʸ��������̾����Ф��롣
  if($s =~ m{<\?xml\s[^>?]*?version[^>?]*?\?>}) {
    $s =~ m{<\?xml\s[^>?]*?encoding\s*?=\s*?['"](.*?)['"]}s;
    $mime = $1;
    $mime =~ s/\s+//g;
    ($matched, $code) = &_mime_to_sname($mime);
  }

  return(wantarray ? ($matched, $code) : $code);
} ## END of sub _get_xml_encoding



###
###   sub _mime_to_sname()
###
###   ���󥳡��ǥ��󥰤�MIME̾(IANAɽ��̾)��û��̾���ѹ����롣
###
###   _mime_to_sname($iana_name)
###
sub _mime_to_sname {
  my $s       = $_[0];   # IANAɽ���Υ��󥳡��ǥ���̾�����Ϥ���
  my $matched = 0;
  my $code    = '';

  if($s =~ /^(?:shift_jis|x-sjis)$/i) {
    $matched = 1;
    $code    = 'sjis';

  } elsif($s =~ /^(?:iso-2022-jp|csISO2022JP)$/i) {
    $matched = 1;
    $code    = 'jis';

  } elsif($s =~ /^(?:euc-jp|x-euc-jp)$/i) {
    $matched = 1;
    $code    = 'euc';

  } elsif($s =~ /^utf-8$/i) {
    $matched = 1;
    $code    = 'utf8';

  } elsif($s =~ /^utf-16le$/i) {  # �ºݤˤ�����
    $matched = 1;
    $code    = 'utf16le';

  } elsif($s =~ /^utf-16be$/i) {  # �ºݤˤ�����
    $matched = 1;
    $code    = 'utf16be';

  } elsif($s =~ /^utf-32le$/i) {  # �ºݤˤ�����
    $matched = 1;
    $code    = 'utf32le';

  } elsif($s =~ /^utf-32be$/i) {  # �ºݤˤ�����
    $matched = 1;
    $code    = 'utf32be';

  } elsif($s =~ /^iso-8859-1$/i) { # $���դ��Ƥ���Τ� ISO-8859-10�ʤɤ˴ְ㤨�ƥޥå������ʤ����ᡣ
    $matched = 1;
    $code    = 'iso885901';

  } elsif($s =~ /^iso-8859-2$/i) {
    $matched = 1;
    $code    = 'iso885902';

  } elsif($s =~ /^iso-8859-3$/i) {
    $matched = 1;
    $code    = 'iso885903';

  } elsif($s =~ /^iso-8859-4$/i) {
    $matched = 1;
    $code    = 'iso885904';

  } elsif($s =~ /^iso-8859-5$/i) {
    $matched = 1;
    $code    = 'iso885905';

  } elsif($s =~ /^(?:iso-8859-6|asmo-708)$/i) {  # ASMO-708(����ӥ���)��ISO-8859-6�Ȥߤʤ���(RFC-1345)
    $matched = 1;
    $code    = 'iso885906';

  } elsif($s =~ /^iso-8859-7$/i) {
    $matched = 1;
    $code    = 'iso885907';

  } elsif($s =~ /^iso-8859-8$/i) {
    $matched = 1;
    $code    = 'iso885908';

  } elsif($s =~ /^iso-8859-9$/i) {
    $matched = 1;
    $code    = 'iso885909';

  } elsif($s =~ /^iso-8859-10$/i) {
    $matched = 1;
    $code    = 'iso885910';

  } elsif($s =~ /^iso-8859-11$/i) {
    $matched = 1;
    $code    = 'iso885911';

  } elsif($s =~ /^iso-8859-13$/i) {
    $matched = 1;
    $code    = 'iso885913';

  } elsif($s =~ /^iso-8859-14$/i) {
    $matched = 1;
    $code    = 'iso885914';

  } elsif($s =~ /^iso-8859-15$/i) {
    $matched = 1;
    $code    = 'iso885915';

  } elsif($s =~ /^iso-8859-16$/i) {
    $matched = 1;
    $code    = 'iso885916';

  } elsif($s =~ /^windows-874$/i) {
    $matched = 1;
    $code    = 'wincp0874';

  } elsif($s =~ /^windows-1250$/i) {
    $matched = 1;
    $code    = 'wincp1250';

  } elsif($s =~ /^windows-1251$/i) {
    $matched = 1;
    $code    = 'wincp1251';

  } elsif($s =~ /^windows-1252$/i) {
    $matched = 1;
    $code    = 'wincp1252';

  } elsif($s =~ /^windows-1253$/i) {
    $matched = 1;
    $code    = 'wincp1253';

  } elsif($s =~ /^windows-1254$/i) {
    $matched = 1;
    $code    = 'wincp1254';

  } elsif($s =~ /^windows-1255$/i) {
    $matched = 1;
    $code    = 'wincp1255';

  } elsif($s =~ /^windows-1256$/i) {
    $matched = 1;
    $code    = 'wincp1256';

  } elsif($s =~ /^windows-1257$/i) {
    $matched = 1;
    $code    = 'wincp1257';

  } elsif($s =~ /^windows-1258$/i) {
    $matched = 1;
    $code    = 'wincp1258';

  } elsif($s =~ /^windows-sami-2$/i) {
    $matched = 1;
    $code    = 'winsami2';

  } elsif($s =~ /^armscii-8$/i) {
    $matched = 1;
    $code    = 'armscii8';

  } elsif($s =~ /^geostd8$/i) {
    $matched = 1;
    $code    = 'geostd8';

  } elsif($s =~ /^iso-ir-111$/i) {
    $matched = 1;
    $code    = 'isoir111';

  } elsif($s =~ /^koi8-r$/i) {
    $matched = 1;
    $code    = 'koi8r';

  } elsif($s =~ /^koi8-u$/i) {
    $matched = 1;
    $code    = 'koi8u';

  } elsif($s =~ /^tis-620$/i) {
    $matched = 1;
    $code    = 'tis620';

  } elsif($s =~ /^us-ascii$/i) {
    $matched = 1;
    $code    = 'usascii';

  } elsif($s =~ /^x-ia5$/i) {
    $matched = 1;
    $code    = 'ia5irv';

  } elsif($s =~ /^x-ia5-Germany$/i) {
    $matched = 1;
    $code    = 'ia5de';

  } elsif($s =~ /^x-ia5-Norwegian$/i) {
    $matched = 1;
    $code    = 'ia5no';

  } elsif($s =~ /^x-ia5-Swedish$/i) {
    $matched = 1;
    $code    = 'ia5se';

  } elsif($s =~ /^x-viet-tcvn5712$/i) {
    $matched = 1;
    $code    = 'tcvn';

  } elsif($s =~ /^viscii$/i) {
    $matched = 1;
    $code    = 'viscii';

  } elsif($s =~ /^x-viet-vps$/i) {
    $matched = 1;
    $code    = 'vps';

  } elsif($s =~ /^(?:ibm-?|cp)437$/i) {
    $matched = 1;
    $code    = 'ibmcp0437';

  } elsif($s =~ /^(?:ibm-?|cp|dos-?)720$/i) {
    $matched = 1;
    $code    = 'ibmcp0720';

  } elsif($s =~ /^(?:ibm-?|cp)737$/i) {
    $matched = 1;
    $code    = 'ibmcp0737';

  } elsif($s =~ /^(?:ibm-?|cp)775$/i) {
    $matched = 1;
    $code    = 'ibmcp0775';

  } elsif($s =~ /^(?:ibm-?|cp)850$/i) {
    $matched = 1;
    $code    = 'ibmcp0850';

  } elsif($s =~ /^(?:ibm-?|cp)852$/i) {
    $matched = 1;
    $code    = 'ibmcp0852';

  } elsif($s =~ /^(?:ibm-?|cp)855$/i) {
    $matched = 1;
    $code    = 'ibmcp0855';

  } elsif($s =~ /^(?:ibm-?|cp)857$/i) {
    $matched = 1;
    $code    = 'ibmcp0857';

  } elsif($s =~ /^(?:ibm-?00|cp)858$/i) {   # IBM858�Ǥ�ǧ������ʤ���IBM00858�Ǥʤ��ȥ��ᡣ
    $matched = 1;
    $code    = 'ibmcp0858';

  } elsif($s =~ /^(?:ibm-?|cp)860$/i) {
    $matched = 1;
    $code    = 'ibmcp0860';

  } elsif($s =~ /^(?:ibm-?|cp)861$/i) {
    $matched = 1;
    $code    = 'ibmcp0861';

  } elsif($s =~ /^(?:ibm-?|cp|dos-?)862$/i) {
    $matched = 1;
    $code    = 'ibmcp0862';

  } elsif($s =~ /^(?:ibm-?|cp)863$/i) {
    $matched = 1;
    $code    = 'ibmcp0863';

  } elsif($s =~ /^(?:ibm-?|cp)864$/i) {
    $matched = 1;
    $code    = 'ibmcp0864';

  } elsif($s =~ /^(?:ibm-?|cp)865$/i) {
    $matched = 1;
    $code    = 'ibmcp0865';

  } elsif($s =~ /^(?:ibm-?|cp)866$/i) {
    $matched = 1;
    $code    = 'ibmcp0866';

  } elsif($s =~ /^(?:ibm-?|cp)869$/i) {
    $matched = 1;
    $code    = 'ibmcp0869';

  } ## END of if()..elsif()

  return(wantarray ? ($matched, $code) : $code);

} ## END of sub _mime_to_sname



###
###   sub is_html_or_xml()
###
###   HTML��XML�Ǥ��ä��顢�����֤���
###
###   ������
###   �����Ȥϴ��˽����Ƥ��뤳�ȡ�
###   �о�ʸ�����BOM̵UTF-8���Ѵ�����Ƥ��뤳�ȡ�
###   ����ʸ���ϴ��˽����Ƥ��뤳�ȡ�(�� U+2028, U+2029)
###
###   is_html_or_xml(\$line)
###
sub is_html_or_xml {
  local(*s)   = @_;   # Ƚ���о�ʸ����ʻ����Ϥ���
  my $matched = 0;

  if($s =~ m{<html.*?>}i) {
    $matched = 1;
  } elsif($s =~ m{<\?xml\s[^>?]*?version[^>?]*?\?>}) {
    $matched = 1;
  }

  return($matched);

}  ## END of sub is_html_or_xml



### ---------------------------------------------
### �ʲ�������(lang°���ʤ�)�ط��Υ��֥롼���� 
### ---------------------------------------------



###
###   sub getlang()
###
###   HTML,XML(�� XHTML)��lang°����Ĵ�٤��֤���
###   lang°�����ʤ����ϡ�'und'(ISO639-2��Undetermined�ΰ�̣)���֤���
###   �о�ʸ�����ʸ�������ɤ�ASCII�ϥ��󥳡��ǥ��󥰤Ǥ��뤳�ȡ�(UTF-16, 32���Բġ�)
###   �ɤ�ʸ�������ɤ�ʸ���󤬤�äƤ��뤫�Ϥ狼��ʤ���
###   UTF-8��BOM���Ĥ��Ƥ��뤫�⤷��ʤ���
###
###   getlang($line)
###
sub getlang {
  my $s       = $_[0];   # Ƚ���о�ʸ��������Ϥ���
  my $matched = 0;
  my $lang    = '';

  # �����Υ���������
  # idea by �ޤäȤ���
  $s =~ s{<script.*?</script>|<style.*?</style>|<code.*?</code>|<\?.*?\?>|<%.*?%>}{ }ig;

  # �����ȥ����ΰ����Ǥʤ� -- ��̵����
  $s =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

  # �����Ƚ��������ҥ������б���
  # Tack sa mycket!  http://www.din.or.jp/~ohzaki/perl.htm
  $s =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)//gs;

  # ̵�������줿 -- ���᤹
  $s =~ s/&#45;&#45;/--/gs;

  if(!($matched)) {
    $s =~ m{<meta\s[^>]*?http-equiv\s*?=\s*?['"]\s*?Content-Language\s*?['"][^>]*?content\s*?=\s*?['"](.*?)['"]}is;
    $lang = $1;
    $lang =~ s/\s+//g;
    if($lang) { $matched=1; }
  }

  if(!($matched)) {
    $s =~ m{<meta\s[^>]*?content\s*?=\s*?['"](.*?)['"][^>]*?http-equiv\s*?=\s*?['"]\s*?Content-Language\s*?['"]}is;
    $lang = $1;
    $lang =~ s/\s+//g;
    if($lang) { $matched=1; }
  }

  if(!($matched)) {
    $s =~ m{<html\s[^>]*?lang\s*?=\s*?['"](.*?)['"]}is;
    $lang = $1;
    $lang =~ s/\s+//g;
    if($lang) { $matched=1; }
  }

  if(!($matched)) {
    $s =~ m{<[^>]*?\sxml:lang\s*?=\s*?['"](.*?)['"]}s;
    $lang = $1;
    $lang =~ s/\s+//g;
    if($lang) { $matched=1; }
  }

  if(!($matched)) {
    $lang='und';
    $matched=1;
  }

  return(lc($lang));
} ## END of sub getlang()



### -------------------------------------
### �ʲ���ʸ���������Ѵ��Υ��֥롼���� 
### -------------------------------------



###
### sub mappingmode()
###
### sub _maketable()�Ǻ�������ޥåԥ󥰥ơ��֥�Υ⡼�ɤ��ѹ����롣
### �ǥե���Ȥ�bidi���������˥⡼�ɡ�(&init�򸫤衣)
### SBCS�ѥޥåԥ󥰥ơ��֥�ϱƶ�������ʤ���(�ܥ⡼�ɤ�����˴ؤ��ʤ�����������⡼��)
###
### &mappingmode('j2u');  # �ޥåԥ󥰥ơ��֥��JIS -> Unicode�����Τߺ������롣
### &mappingmode('u2j');  # �ޥåԥ󥰥ơ��֥��Unicode -> JIS�����Τߺ������롣
### &mappingmode('bidi'); # �ޥåԥ󥰥ơ��֥��JIS <-> Unicode�������ˤĤ��ƺ������롣
###
### (��1) JIS -> Unicode�����Τߤǽ�ʬ�ʾ��ϡ�require�ƽ�ľ����ѹ����롣
###
### require './utfjp.pl';
### &utfjp::mappingmode('j2u');
###
### (��2) ���ˤ���ޥåԥ󥰥ơ��֥���ѹ�����ˤϡ����٥ơ��֥����������˥⡼�ɤ��ѹ����롣
###
### (�����������Υơ��֥뤬���롣)
### &utfjp::del_all_tables;
### &utfjp::mappingmode('j2u');
### (�ޥåԥ󥰥ơ��֥��ɬ�פˤʤä������Ǽ�ưŪ�˺��������)
###
sub mappingmode {
  my $mode = $_[0];

  if ($mode =~ /j2u/i) {
   $mapping_j2u=1;
   undef $mapping_u2j;
  } elsif ($mode =~ /u2j/i) {
   undef $mapping_j2u;
   $mapping_u2j=1;
  } elsif ($mode =~ /bidi/i) {
   $mapping_j2u=1;
   $mapping_u2j=1;
   }

} ## END of sub mappingmode



###
### sub _maketable()
###
### UTF-8<->EUC���Ѵ��򤹤뤿��Υޥåԥ󥰥ơ��֥��������롣
###
sub _maketable {
  local *IN;
  my    @tmp=();

  $table_exist=1; # �ơ��֥뤬�����Ѥߤ��ɤ����򼨤��ե饰

  if (!open(IN, "<$mappingju")) {
      &printoutstr("Error: $mappingju does not exist.\n");
      exit(1);
  }

  while(<IN>) {
    if(/^\s*#/o) {next;}
    chomp;
    s/^\s+//o;
    s/#.*//o;
    @tmp = split /\s+/o;
    if (!(2<=@tmp && @tmp<=3))  {next;}

    $tmp[0] = lc($tmp[0]);
    $tmp[1] = lc($tmp[1]);
    if($tmp[0] =~ /h/o) {                                  # JIS X 0212 ��������ξ��
      $tmp[0] =~ tr/h//d;
#      $tmp[0] =  pack("C*",0x8F,((hex($tmp[0])+0x8080)>>8) & 0xFF, (hex($tmp[0])+0x8080) & 0xFF);
      $tmp[0] = chr(0x8F).pack("n",hex($tmp[0])+0x8080);

    } elsif(hex($tmp[0])>0xDF) {                           # JIS X 0208 �����ξ��
#      $tmp[0] = pack("C*",((hex($tmp[0])+0x8080)>>8) & 0xFF, (hex($tmp[0])+0x8080) & 0xFF);
      $tmp[0] = pack("n",hex($tmp[0])+0x8080);

    } elsif(0xA1<=hex($tmp[0]) && hex($tmp[0])<=0xDF) {    # JIS X 0201 Ⱦ�ѥ��ʤξ��
#      $tmp[0] = pack("C*",0x8E,hex($tmp[0]));
      $tmp[0] = chr(0x8E).chr(hex($tmp[0]));

    } elsif(0x00<=hex($tmp[0]) && hex($tmp[0])<=0x7F) {    # JIS X 0201 Ⱦ�ѱѿ�����ξ��
#      $tmp[0] = pack("C*",hex($tmp[0]));
      $tmp[0] = chr(hex($tmp[0]));
    }

    $tmp[1] = &_32n_8c(hex($tmp[1]));

    if(@tmp==2) {
      $tbl_utf8toeuc{$tmp[1]} = $tmp[0] if($mapping_u2j);   # �Ѵ��ơ��֥�κ��� UTF-8 -> EUC
      $tbl_euctoutf8{$tmp[0]} = $tmp[1] if($mapping_j2u);   # �Ѵ��ơ��֥�κ��� EUC -> UTF-8
    } elsif(@tmp==3) {
      if(lc($tmp[2]) eq 'u2j') {
        $tbl_utf8toeuc{$tmp[1]} = $tmp[0] if($mapping_u2j); # �Ѵ��ơ��֥�κ��� UTF-8 -> EUC(�������Τ�)
      }
      if(lc($tmp[2]) eq 'j2u') {
        $tbl_euctoutf8{$tmp[0]} = $tmp[1] if($mapping_j2u); # �Ѵ��ơ��֥�κ��� EUC -> UTF-8(�������Τ�)
      }
    }

  } # END of while()

  close(IN);

} ## END of sub _maketable()



###
### sub _maketable_sbcs()
###
### SBCS<->UTF-8���Ѵ��򤹤�ơ��֥��������롣
###
### &_maketable_sbcs('iso885901')
###
sub _maketable_sbcs {
  my $encode = $_[0];  # ���Υ��󥳡��ǥ��󥰤�UTF-8�֤Υޥåԥ󥰥ơ��֥�(������)��������롣
  my $infile = '';
  local *IN;
  my    @tmp=();

  $infile = $supfolder.$encode.'.txt';

  if (!open(IN, "<$infile")) {
      &printoutstr("Error: $infile does not exist.\n");
      exit(1);
  }

  $tbl_sbcs_now=$encode;   # �Ѵ��ϥå���˸��߳�Ǽ����Ƥ��륨�󥳡��ǥ���
  undef %tbl_sbcs2utf8;    # SBCS->UTF-8�Ѵ��ѥϥå���϶��Ѥ��롣
  undef %tbl_utf8tosbcs;   # UTF-8->SBCS�Ѵ��ѥϥå���϶��Ѥ��롣

  while(<IN>) {
    if(/^\s*#/o) {next;}
    chomp;
    s/^\s+//o;
    s/#.*//o;
    @tmp = split /\s+/o;
    if (!(@tmp==2))  {next;}

    $tmp[0] = lc($tmp[0]);
    $tmp[1] = lc($tmp[1]);
    if(0x00<=hex($tmp[0]) && hex($tmp[0])<=0xFF) {
#      $tmp[0] = pack("C*",hex($tmp[0]));
      $tmp[0] = chr(hex($tmp[0]));
    }

    $tmp[1] = &_32n_8c(hex($tmp[1]));

    $tbl_sbcs2utf8{$tmp[0]}  = $tmp[1];   # �Ѵ��ơ��֥�κ��� SBCS  -> UTF-8
    $tbl_utf8tosbcs{$tmp[1]} = $tmp[0];   # �Ѵ��ơ��֥�κ��� UTF-8 -> SBCS

  } # END of while()

  close(IN);

} ## END of sub _maketable_sbcs()



###
###   sub convert()
###
###   ʸ�������ɤ��Ѵ����롣
###
###   �Ѵ���ʸ�������ɤ�ưȽ�ꤵ������
###   convert(\$line, yyy);
###
###      yyy: �Ѵ���ʸ��������
###
###   �Ѵ���ʸ�������ɤ�����Ū�˻��ꤹ����
###   convert(\$line, yyy, xxx);
###
###      yyy: �Ѵ���ʸ��������
###      xxx: �Ѵ���ʸ��������
###
###   UTF-8�ؤ��Ѵ������ǥե���ȤǤ�BOM���ղä���ʤ���
###   UTF-16LE,16BE,32LE,32BE���Ѵ������ǥե���Ȥ�BOM���ղä���롣
###
###   UTF-8�ؤ��Ѵ�����BOM���ղä�������Ѵ���ʸ�������ɤ�ưȽ�ꤵ�������
###   convert(\$line, 'utf8', '', 'bom');
###
###   UTF-8�ؤ��Ѵ�����BOM���ղä�������Ѵ���ʸ�������ɤ�����Ū�˻��ꤹ�����
###   convert(\$line, 'utf8', 'euc', 'bom');
###
###   UTF-16LE,16BE,32LE,32BE�ؤ��Ѵ�����BOM���ղä��ʤ������Ѵ���ʸ�������ɤ�ưȽ�ꤵ�������
###   convert(\$line, 'utf16le', '', 'nobom');
###
###   UTF-16LE,16BE,32LE,32BE�ؤ��Ѵ�����BOM���ղä��ʤ������Ѵ���ʸ�������ɤ�����Ū�˻��ꤹ�����
###   convert(\$line, 'utf16le', 'euc', 'nobom');
###
###   xxx,yyy�ˤ�
###   'euc'
###   'sjis'
###   'jis'
###   'utf8'
###   'utf16le'
###   'utf16be'
###   'utf32le'
###   'utf32be'
###   'iso885901'����¾
###   ����ꤹ�롣
###
###   ��ջ���
###   ��������ץ���ǤΥƥ����Ƚ�����EUC��UTF-8�ǹԤ���
###     �ե�����ؽ��Ϥ���ľ����UTF-16LE,16BE,32LE,32BE���Ѵ����뤳�ȡ�
###   ��Windows�ץ�åȥե������UTF-16LE,16BE,32LE,32BE��ե�����ؽ��Ϥ���Ȥ��ϡ�
###     ɬ���Х��ʥ꡼�⡼�ɤǤν��Ϥˤʤ�褦�ˤ��뤳�ȡ�
###
sub convert {
  local(*s, $ocode, $icode, $opt) = @_;
  my $code;

  if($icode) {
    $code = $icode;
  } else {
    $code = &getcode(\$s);
  }

  if(($code =~ /(?:sjis|jis|euc)/) && ($ocode =~ /utf/)) {
    &_maketable unless defined $table_exist;   # �Ѵ��ѥơ��֥�̤�����Ǥ���С��������롣
  } elsif(($code =~ /utf/) && ($ocode =~ /(?:sjis|jis|euc)/)) {
    &_maketable unless defined $table_exist;   # �Ѵ��ѥơ��֥�̤�����Ǥ���С��������롣
  }

  if($code eq 'sjis' && $ocode eq 'utf8') {             # ------------- SJIS     -> UTF-8
    &jcode::sjis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/$tbl_euctoutf8{$1}/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'jis' && $ocode eq 'utf8') {         # ------------- JIS      -> UTF-8
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/$tbl_euctoutf8{$1}/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'euc' && $ocode eq 'utf8') {         # ------------- EUC      -> UTF-8
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/$tbl_euctoutf8{$1}/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'utf8' && $ocode eq 'utf8') {        # ------------- UTF-8    -> UTF-8
    $s =~ s/^$utf8_bom//o;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'utf16le' && $ocode eq 'utf8') {     # ------------- UTF-16LE -> UTF-8
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/&_32n_8c(&_16lec_32n($1))/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'utf16be' && $ocode eq 'utf8') {     # ------------- UTF-16BE -> UTF-8
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/&_32n_8c(&_16bec_32n($1))/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'utf32le' && $ocode eq 'utf8') {     # ------------- UTF-32LE -> UTF-8
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/&_32n_8c(&_32lec_32n($1))/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'utf32be' && $ocode eq 'utf8') {     # ------------- UTF-32BE -> UTF-8
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/&_32n_8c(&_32bec_32n($1))/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885901' && $ocode eq 'utf8') {   # ------------- ISO-8859-1 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885902' && $ocode eq 'utf8') {   # ------------- ISO-8859-2 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885903' && $ocode eq 'utf8') {   # ------------- ISO-8859-3 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885904' && $ocode eq 'utf8') {   # ------------- ISO-8859-4 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885905' && $ocode eq 'utf8') {   # ------------- ISO-8859-5 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885906' && $ocode eq 'utf8') {   # ------------- ISO-8859-6 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885907' && $ocode eq 'utf8') {   # ------------- ISO-8859-7 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885908' && $ocode eq 'utf8') {   # ------------- ISO-8859-8 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885909' && $ocode eq 'utf8') {   # ------------- ISO-8859-9 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885910' && $ocode eq 'utf8') {   # ------------- ISO-8859-10 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885911' && $ocode eq 'utf8') {   # ------------- ISO-8859-11 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885913' && $ocode eq 'utf8') {   # ------------- ISO-8859-13 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885914' && $ocode eq 'utf8') {   # ------------- ISO-8859-14 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885915' && $ocode eq 'utf8') {   # ------------- ISO-8859-15 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'iso885916' && $ocode eq 'utf8') {   # ------------- ISO-8859-16 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp0874' && $ocode eq 'utf8') {   # ------------- Windows-874 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1250' && $ocode eq 'utf8') {   # ------------- Windows-1250 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1251' && $ocode eq 'utf8') {   # ------------- Windows-1251 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1252' && $ocode eq 'utf8') {   # ------------- Windows-1252 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1253' && $ocode eq 'utf8') {   # ------------- Windows-1253 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1254' && $ocode eq 'utf8') {   # ------------- Windows-1254 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1255' && $ocode eq 'utf8') {   # ------------- Windows-1255 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1256' && $ocode eq 'utf8') {   # ------------- Windows-1256 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1257' && $ocode eq 'utf8') {   # ------------- Windows-1257 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'wincp1258' && $ocode eq 'utf8') {   # ------------- Windows-1258 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'winsami2' && $ocode eq 'utf8') {    # ------------- Windows-Sami-2 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'armscii8'  && $ocode eq 'utf8') {   # ------------- ARMSCII-8 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'geostd8'  && $ocode eq 'utf8') {    # ------------- GEOSTD8 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'isoir111'  && $ocode eq 'utf8') {   # ------------- ISO-IR-111 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'koi8r'  && $ocode eq 'utf8') {      # ------------- KOI8-R -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'koi8u'  && $ocode eq 'utf8') {      # ------------- KOI8-U -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'tis620'  && $ocode eq 'utf8') {     # ------------- TIS-620 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'usascii'  && $ocode eq 'utf8') {    # ------------- US-ASCII -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ia5irv'  && $ocode eq 'utf8') {     # ------------- x-IA5 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ia5de'  && $ocode eq 'utf8') {      # ------------- x-IA5-Germany -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ia5no'  && $ocode eq 'utf8') {      # ------------- x-IA5-Norwegian -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ia5se'  && $ocode eq 'utf8') {      # ------------- x-IA5-Swedish -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'tcvn'  && $ocode eq 'utf8') {       # ------------- x-viet-tcvn5712 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'viscii'  && $ocode eq 'utf8') {     # ------------- viscii -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'vps'  && $ocode eq 'utf8') {        # ------------- x-viet-vps -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0437'  && $ocode eq 'utf8') {  # ------------- IBM437 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0720'  && $ocode eq 'utf8') {  # ------------- IBM720 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0737'  && $ocode eq 'utf8') {  # ------------- IBM737 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0775'  && $ocode eq 'utf8') {  # ------------- IBM775 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0850'  && $ocode eq 'utf8') {  # ------------- IBM850 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0852'  && $ocode eq 'utf8') {  # ------------- IBM852 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0855'  && $ocode eq 'utf8') {  # ------------- IBM855 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0857'  && $ocode eq 'utf8') {  # ------------- IBM857 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0858'  && $ocode eq 'utf8') {  # ------------- IBM858 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0860'  && $ocode eq 'utf8') {  # ------------- IBM860 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0861'  && $ocode eq 'utf8') {  # ------------- IBM861 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0862'  && $ocode eq 'utf8') {  # ------------- IBM862 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0863'  && $ocode eq 'utf8') {  # ------------- IBM863 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0864'  && $ocode eq 'utf8') {  # ------------- IBM864 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0865'  && $ocode eq 'utf8') {  # ------------- IBM865 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0866'  && $ocode eq 'utf8') {  # ------------- IBM866 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'ibmcp0869'  && $ocode eq 'utf8') {  # ------------- IBM869 -> UTF-8
    $s =~ s/($sbcs_1char)/&_sbcs_to_utf8($1,$code)/geo;
    $s = $utf8_bom.$s if ($opt eq 'bom');

  } elsif($code eq 'utf8' && $ocode eq 'iso885901') {   # ------------- UTF-8 -> ISO-8859-1
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885902') {   # ------------- UTF-8 -> ISO-8859-2
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885903') {   # ------------- UTF-8 -> ISO-8859-3
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885904') {   # ------------- UTF-8 -> ISO-8859-4
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885905') {   # ------------- UTF-8 -> ISO-8859-5
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885906') {   # ------------- UTF-8 -> ISO-8859-6
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885907') {   # ------------- UTF-8 -> ISO-8859-7
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885908') {   # ------------- UTF-8 -> ISO-8859-8
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885909') {   # ------------- UTF-8 -> ISO-8859-9
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885910') {   # ------------- UTF-8 -> ISO-8859-10
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885911') {   # ------------- UTF-8 -> ISO-8859-11
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885913') {   # ------------- UTF-8 -> ISO-8859-13
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885914') {   # ------------- UTF-8 -> ISO-8859-14
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885915') {   # ------------- UTF-8 -> ISO-8859-15
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'iso885916') {   # ------------- UTF-8 -> ISO-8859-16
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp0874') {   # ------------- UTF-8 -> Windows-874
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1250') {   # ------------- UTF-8 -> Windows-1250
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1251') {   # ------------- UTF-8 -> Windows-1251
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1252') {   # ------------- UTF-8 -> Windows-1252
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1253') {   # ------------- UTF-8 -> Windows-1253
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1254') {   # ------------- UTF-8 -> Windows-1254
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1255') {   # ------------- UTF-8 -> Windows-1255
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1256') {   # ------------- UTF-8 -> Windows-1256
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1257') {   # ------------- UTF-8 -> Windows-1257
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'wincp1258') {   # ------------- UTF-8 -> Windows-1258
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'winsami2') {    # ------------- UTF-8 -> Windows-Sami-2
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'armscii8') {    # ------------- UTF-8 -> ARMSCII-8
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'geostd8') {     # ------------- UTF-8 -> GEOSTD8
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'isoir111') {    # ------------- UTF-8 -> ISO-IR-111
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'koi8r') {       # ------------- UTF-8 -> KOI8-R
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'koi8u') {       # ------------- UTF-8 -> KOI8-U
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'tis620') {      # ------------- UTF-8 -> TIS-620
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'usascii') {     # ------------- UTF-8 -> US-ASCII
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ia5irv') {      # ------------- UTF-8 -> x-IA5
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ia5de') {       # ------------- UTF-8 -> x-IA5-Germany
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ia5no') {       # ------------- UTF-8 -> x-IA5-Norwegian
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ia5se') {       # ------------- UTF-8 -> x-IA5-Swedish
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'tcvn') {        # ------------- UTF-8 -> x-viet-tcvn5712
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'viscii') {      # ------------- UTF-8 -> viscii
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'vps') {         # ------------- UTF-8 -> x-viet-vps
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0437') {   # ------------- UTF-8 -> IBM437
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0720') {   # ------------- UTF-8 -> IBM720
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0737') {   # ------------- UTF-8 -> IBM737
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0775') {   # ------------- UTF-8 -> IBM775
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0850') {   # ------------- UTF-8 -> IBM850
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0852') {   # ------------- UTF-8 -> IBM852
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0855') {   # ------------- UTF-8 -> IBM855
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0857') {   # ------------- UTF-8 -> IBM857
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0858') {   # ------------- UTF-8 -> IBM858
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0860') {   # ------------- UTF-8 -> IBM860
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0861') {   # ------------- UTF-8 -> IBM861
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0862') {   # ------------- UTF-8 -> IBM862
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0863') {   # ------------- UTF-8 -> IBM863
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0864') {   # ------------- UTF-8 -> IBM864
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0865') {   # ------------- UTF-8 -> IBM865
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0866') {   # ------------- UTF-8 -> IBM866
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'utf8' && $ocode eq 'ibmcp0869') {   # ------------- UTF-8 -> IBM869
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_utf8_to_sbcs($1,$ocode)/geo;

  } elsif($code eq 'jis' && $ocode eq 'euc') {          # ------------- JIS      -> EUC
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2euc(\$s);

  } elsif($code eq 'sjis' && $ocode eq 'euc') {         # ------------- SJIS     -> EUC
    &jcode::sjis2euc(\$s);

  } elsif($code eq 'euc' && $ocode eq 'euc') {          # ------------- EUC      -> EUC
    # No Operation

  } elsif($code eq 'utf8' && $ocode eq 'euc') {         # ------------- UTF-8    -> EUC
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/$tbl_utf8toeuc{$1}/geo;

  } elsif($code eq 'utf16le' && $ocode eq 'euc') {      # ------------- UTF-16LE -> EUC
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/$tbl_utf8toeuc{&_32n_8c(&_16lec_32n($1))}/geo;

  } elsif($code eq 'utf16be' && $ocode eq 'euc') {      # ------------- UTF-16BE -> EUC
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/$tbl_utf8toeuc{&_32n_8c(&_16bec_32n($1))}/geo;

  } elsif($code eq 'utf32le' && $ocode eq 'euc') {      # ------------- UTF-32LE -> EUC
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/$tbl_utf8toeuc{&_32n_8c(&_32lec_32n($1))}/geo;

  } elsif($code eq 'utf32be' && $ocode eq 'euc') {      # ------------- UTF-32BE -> EUC
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/$tbl_utf8toeuc{&_32n_8c(&_32bec_32n($1))}/geo;

  } elsif($code eq 'sjis' && $ocode eq 'utf16le') {     # ------------- SJIS     -> UTF-16LE
    &jcode::sjis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_16lec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'jis' && $ocode eq 'utf16le') {      # ------------- JIS      -> UTF-16LE
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_16lec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'euc' && $ocode eq 'utf16le') {      # ------------- EUC      -> UTF-16LE
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_16lec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf8' && $ocode eq 'utf16le') {     # ------------- UTF-8    -> UTF-16LE
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_32n_16lec(&_8c_32n($1))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf16le' && $ocode eq 'utf16le') {  # ------------- UTF-16LE -> UTF-16LE
    $s =~ s/^$utf16le_bom//o;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf16be' && $ocode eq 'utf16le') {  # ------------- UTF-16BE -> UTF-16LE
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/&_32n_16lec(&_16bec_32n($1))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32le' && $ocode eq 'utf16le') {  # ------------- UTF-32LE -> UTF-16LE
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/&_32n_16lec(&_32lec_32n($1))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32be' && $ocode eq 'utf16le') {  # ------------- UTF-32BE -> UTF-16LE
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/&_32n_16lec(&_32bec_32n($1))/geo;
    $s = $utf16le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'sjis' && $ocode eq 'utf16be') {     # ------------- SJIS     -> UTF-16BE
    &jcode::sjis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_16bec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'jis' && $ocode eq 'utf16be') {      # ------------- JIS      -> UTF-16BE
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_16bec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'euc' && $ocode eq 'utf16be') {      # ------------- EUC      -> UTF-16BE
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_16bec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf8' && $ocode eq 'utf16be') {     # ------------- UTF-8    -> UTF-16BE
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_32n_16bec(&_8c_32n($1))/geo;
    $s = $utf16be_bom.$s unless($opt eq 'nobom');

  } elsif($code eq 'utf16le' && $ocode eq 'utf16be') {  # ------------- UTF-16LE -> UTF-16BE
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/&_32n_16bec(&_16lec_32n($1))/geo;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf16be' && $ocode eq 'utf16be') {  # ------------- UTF-16BE -> UTF-16BE
    $s =~ s/^$utf16be_bom//o;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32le' && $ocode eq 'utf16be') {  # ------------- UTF-32LE -> UTF-16BE
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/&_32n_16bec(&_32lec_32n($1))/geo;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32be' && $ocode eq 'utf16be') {  # ------------- UTF-32BE -> UTF-16BE
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/&_32n_16bec(&_32bec_32n($1))/geo;
    $s = $utf16be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'sjis' && $ocode eq 'utf32le') {     # ------------- SJIS     -> UTF-32LE
    &jcode::sjis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_32lec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'jis' && $ocode eq 'utf32le') {      # ------------- JIS      -> UTF-32LE
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_32lec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'euc' && $ocode eq 'utf32le') {      # ------------- EUC      -> UTF-32LE
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_32lec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf8' && $ocode eq 'utf32le') {     # ------------- UTF-8    -> UTF-32LE
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_32n_32lec(&_8c_32n($1))/geo;
    $s = $utf32le_bom.$s unless($opt eq 'nobom');

  } elsif($code eq 'utf16le' && $ocode eq 'utf32le') {  # ------------- UTF-16LE -> UTF-32LE
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/&_32n_32lec(&_16lec_32n($1))/geo;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf16be' && $ocode eq 'utf32le') {  # ------------- UTF-16BE -> UTF-32LE
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/&_32n_32lec(&_16bec_32n($1))/geo;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32le' && $ocode eq 'utf32le') {  # ------------- UTF-32LE -> UTF-32LE
    $s =~ s/^$utf32le_bom//o;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32be' && $ocode eq 'utf32le') {  # ------------- UTF-32BE -> UTF-32LE
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/&_32n_32lec(&_32bec_32n($1))/geo;
    $s = $utf32le_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'sjis' && $ocode eq 'utf32be') {     # ------------- SJIS     -> UTF-32BE
    &jcode::sjis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_32bec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'jis' && $ocode eq 'utf32be') {      # ------------- JIS      -> UTF-32BE
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2euc(\$s);
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_32bec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'euc' && $ocode eq 'utf32be') {      # ------------- EUC      -> UTF-32BE
    $s =~ s/($euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/&_32n_32bec(&_8c_32n($tbl_euctoutf8{$1}))/geo;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf8' && $ocode eq 'utf32be') {     # ------------- UTF-8    -> UTF-32BE
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/&_32n_32bec(&_8c_32n($1))/geo;
    $s = $utf32be_bom.$s unless($opt eq 'nobom');

  } elsif($code eq 'utf16le' && $ocode eq 'utf32be') {  # ------------- UTF-16LE -> UTF-32BE
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/&_32n_32bec(&_16lec_32n($1))/geo;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf16be' && $ocode eq 'utf32be') {  # ------------- UTF-16BE -> UTF-32BE
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/&_32n_32bec(&_16bec_32n($1))/geo;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32le' && $ocode eq 'utf32be') {  # ------------- UTF-32LE -> UTF-32BE
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/&_32n_32bec(&_32lec_32n($1))/geo;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'utf32be' && $ocode eq 'utf32be') {  # ------------- UTF-32BE -> UTF-32BE
    $s =~ s/^$utf32be_bom//o;
    $s = $utf32be_bom.$s unless ($opt eq 'nobom');

  } elsif($code eq 'jis' && $ocode eq 'sjis') {         # ------------- JIS      -> SJIS
    $s =~ s/$jis_so/$esc_hkana/geo;
    $s =~ s/$jis_si/$esc_ascii/geo;
    &jcode::jis2sjis(\$s);

  } elsif($code eq 'sjis' && $ocode eq 'sjis') {        # ------------- SJIS     -> SJIS
    # No Operation

  } elsif($code eq 'euc' && $ocode eq 'sjis') {         # ------------- EUC      -> SJIS
    &jcode::euc2sjis(\$s);

  } elsif($code eq 'utf8' && $ocode eq 'sjis') {        # ------------- UTF-8    -> SJIS
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/$tbl_utf8toeuc{$1}/geo;
    &jcode::euc2sjis(\$s);

  } elsif($code eq 'utf16le' && $ocode eq 'sjis') {     # ------------- UTF-16LE -> SJIS
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/$tbl_utf8toeuc{&_32n_8c(&_16lec_32n($1))}/geo;
    &jcode::euc2sjis(\$s);

  } elsif($code eq 'utf16be' && $ocode eq 'sjis') {     # ------------- UTF-16BE -> SJIS
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/$tbl_utf8toeuc{&_32n_8c(&_16bec_32n($1))}/geo;
    &jcode::euc2sjis(\$s);

  } elsif($code eq 'utf32le' && $ocode eq 'sjis') {     # ------------- UTF-32LE -> SJIS
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/$tbl_utf8toeuc{&_32n_8c(&_32lec_32n($1))}/geo;
    &jcode::euc2sjis(\$s);

  } elsif($code eq 'utf32be' && $ocode eq 'sjis') {     # ------------- UTF-32BE -> SJIS
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/$tbl_utf8toeuc{&_32n_8c(&_32bec_32n($1))}/geo;
    &jcode::euc2sjis(\$s);

  } elsif($code eq 'jis' && $ocode eq 'jis') {          # ------------- JIS      -> JIS
    # No Operation

  } elsif($code eq 'sjis' && $ocode eq 'jis') {         # ------------- SJIS     -> JIS
    &jcode::sjis2jis(\$s);

  } elsif($code eq 'euc' && $ocode eq 'jis') {          # ------------- EUC      -> JIS
    &jcode::euc2jis(\$s);

  } elsif($code eq 'utf8' && $ocode eq 'jis') {         # ------------- UTF-8    -> JIS
    $s =~ s/^$utf8_bom//o;
    $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/$tbl_utf8toeuc{$1}/geo;
    &jcode::euc2jis(\$s);

  } elsif($code eq 'utf16le' && $ocode eq 'jis') {      # ------------- UTF-16LE -> JIS
    $s =~ s/^$utf16le_bom//o;
    $s =~ s/($utf16le_2byte|$utf16le_4byte)/$tbl_utf8toeuc{&_32n_8c(&_16lec_32n($1))}/geo;
    &jcode::euc2jis(\$s);

  } elsif($code eq 'utf16be' && $ocode eq 'jis') {      # ------------- UTF-16BE -> JIS
    $s =~ s/^$utf16be_bom//o;
    $s =~ s/($utf16be_2byte|$utf16be_4byte)/$tbl_utf8toeuc{&_32n_8c(&_16bec_32n($1))}/geo;
    &jcode::euc2jis(\$s);

  } elsif($code eq 'utf32le' && $ocode eq 'jis') {      # ------------- UTF-32LE -> JIS
    $s =~ s/^$utf32le_bom//o;
    $s =~ s/($utf32le_4byte)/$tbl_utf8toeuc{&_32n_8c(&_32lec_32n($1))}/geo;
    &jcode::euc2jis(\$s);

  } elsif($code eq 'utf32be' && $ocode eq 'jis') {      # ------------- UTF-32BE -> JIS
    $s =~ s/^$utf32be_bom//o;
    $s =~ s/($utf32be_4byte)/$tbl_utf8toeuc{&_32n_8c(&_32bec_32n($1))}/geo;
    &jcode::euc2jis(\$s);

  } else {                                              # ------------- ����¾�ξ��ϲ��⤷�ʤ���
    # No Operation
  }

}  ## END of sub convert()



###
###   sub _sbcs_to_utf8()
###
###   SBCS�ϥ��󥳡��ǥ��󥰳Ƽ�ʸ����UTF-8ʸ�����Ѵ����롣
###   �ѥ�����ޥå����ִ���������뼰
###
sub _sbcs_to_utf8 {

  my $inchar = $_[0];  # SBCSʸ���ʰ��������Ϥ���
  my $incode = $_[1];  # SBCS���󥳡��ǥ���̾�ʰ��������Ϥ���

  &_maketable_sbcs($incode) unless($tbl_sbcs_now eq $incode);

  return($tbl_sbcs2utf8{$inchar}); # UTF-8ʸ�������͡�

}  ## END of sub _sbcs_to_utf8()



###
###   sub _utf8_to_sbcs()
###
###   UTF-8ʸ����SBCSʸ�����Ѵ����롣
###   �ѥ�����ޥå����ִ���������뼰
###
sub _utf8_to_sbcs {

  my $inchar = $_[0];  # UTF-8ʸ���ʰ��������Ϥ���
  my $incode = $_[1];  # SBCS���󥳡��ǥ���̾�ʰ��������Ϥ���

  &_maketable_sbcs($incode) unless($tbl_sbcs_now eq $incode);

  return($tbl_utf8tosbcs{$inchar}); # SBCSʸ�������͡�

}  ## END of sub _utf8_to_sbcs()



###
###   sub _8c_32n()
###
###   UTF-8ʸ����UTF-32�ֹ���Ѵ����롣
###
sub _8c_32n {

  my $utfchar= $_[0];  # UTF-8ʸ���ʰ��������Ϥ���
  my @tmp;
  my $size;            # $utfchar��Ĺ����byteñ�̡�
  my $code;            # UTF-32�ֹ�

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $size=@tmp;
  if ($size == 1) {
    $code = ord($tmp[0]);
  } elsif($size == 2) {
    $code = ((ord($tmp[0]) & 31) << 6) | (ord($tmp[1]) & 63);             # UTF-32�ֹ�򻻽�
  } elsif($size == 3) {
    $code = ((ord($tmp[0]) & 15) << 12) | ((ord($tmp[1]) & 63) << 6) |
            (ord($tmp[2]) & 63);                                          # UTF-32�ֹ�򻻽�
  } elsif($size == 4) {
    $code = ((ord($tmp[0]) & 7)  << 18) | ((ord($tmp[1]) & 63) << 12) |
            ((ord($tmp[2]) & 63) << 6) | (ord($tmp[3]) & 63);             # UTF-32�ֹ�򻻽�
  }

  return($code);

}  ## END of sub _8c_32n()



###
###   sub _16lec_32n()
###
###   UTF-16LEʸ����UTF-32�ֹ���Ѵ����롣
###
sub _16lec_32n {

  my $utfchar= $_[0];  # UTF-16LEʸ���ʰ��������Ϥ���
  my @tmp;
  my $size;            # $utfchar��Ĺ����byteñ�̡�
  my $code;            # UTF-32�ֹ�
  my ($c1,$c2);        # ����ѿ�

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $size=@tmp;
  if ($size == 2) {
    $code = ord($tmp[1])*256+ord($tmp[0]);             # UTF-32�ֹ�򻻽�
#    $code = unpack("n",$utfchar);
  } elsif($size == 4) {
    $c1 = ord($tmp[1])*256+ord($tmp[0]);
    $c2 = ord($tmp[3])*256+ord($tmp[2]);
    $code = (($c1-55296)*1024)+($c2-56320)+65536;      # UTF-32�ֹ�򻻽�
  }

  return($code);

}  ## END of sub _16lec_32n()



###
###   sub _16bec_32n()
###
###   UTF-16BEʸ����UTF-32�ֹ���Ѵ����롣
###
sub _16bec_32n {

  my $utfchar= $_[0];  # UTF-16BEʸ���ʰ��������Ϥ���
  my @tmp;
  my $size;            # $utfchar��Ĺ����byteñ�̡�
  my $code;            # UTF-32�ֹ�
  my ($c1,$c2);        # ����ѿ�

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $size=@tmp;
  if ($size == 2) {
    $code = ord($tmp[0])*256+ord($tmp[1]);             # UTF-32�ֹ�򻻽�
#    $code = unpack("n",$utfchar);
  } elsif($size == 4) {
    $c1 = ord($tmp[0])*256+ord($tmp[1]);
    $c2 = ord($tmp[2])*256+ord($tmp[3]);
    $code = (($c1-55296)*1024)+($c2-56320)+65536;      # UTF-32�ֹ�򻻽�
  }

  return($code);

}  ## END of sub _16bec_32n()



###
###   sub _32lec_32n()
###
###   UTF-32LEʸ����UTF-32�ֹ���Ѵ����롣
###
sub _32lec_32n {

  my $utfchar= $_[0];  # UTF-32LEʸ���ʰ��������Ϥ���
  my @tmp;
  my $code;            # UTF-32�ֹ�
  my ($c1,$c2);        # ����ѿ�

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $c1 = ord($tmp[3])*256+ord($tmp[2]);
  $c2 = ord($tmp[1])*256+ord($tmp[0]);
  $code = ($c1*65536)+$c2;                             # UTF-32�ֹ�򻻽�

  return($code);

}  ## END of sub _32lec_32n()



###
###   sub _32bec_32n()
###
###   UTF-32BEʸ����UTF-32�ֹ���Ѵ����롣
###
sub _32bec_32n {

  my $utfchar= $_[0];  # UTF-32BEʸ���ʰ��������Ϥ���
  my @tmp;
  my $code;            # UTF-32�ֹ�
  my ($c1,$c2);        # ����ѿ�

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $c1 = ord($tmp[0])*256+ord($tmp[1]);
  $c2 = ord($tmp[2])*256+ord($tmp[3]);
  $code = ($c1*65536)+$c2;                             # UTF-32�ֹ�򻻽�

  return($code);

}  ## END of sub _32bec_32n()



###
###   sub _32n_8c()
###
###   UTF-32�ֹ��UTF-8ʸ�����Ѵ����롣
###
sub _32n_8c {
  my $code=$_[0];          # UTF-32�ֹ�
  my $utfchar;             # UTF-8ʸ��

  if($code <= 127)           {                      # U+0000-U+007F
      $utfchar = chr($code);

  } elsif($code <= 2047)     {                      # U+0080-U+07FF
      $utfchar = pack("C*", 192|($code>>6 ), 128|($code & 63));

  } elsif($code <= 65535)    {                      # U+0800-U+FFFF
      $utfchar = pack("C*", 224|($code>>12), 128|(($code>>6 ) & 63), 128|($code & 63));

  } elsif($code <= 1114111)  {                      # U+010000-U+10FFFF
      $utfchar = pack("C*", 240|($code>>18), 128|(($code>>12) & 63), 128|(($code>>6) & 63), 128|($code & 63));
  }

  return($utfchar);

}  ## END of sub _32n_8c()



###
###   sub _32n_16lec()
###
###   UTF-32�ֹ��UTF-16LEʸ�����Ѵ����롣
###
###   ���
###   pack("v*", $a, $b); �Ȥ�����硢(VAX order = little endian)
###    $b����byte, $b���byte, $a����byte, $a���byte
###   �ν���ǽ��Ϥ���롣
###
sub _32n_16lec {
  my $code=$_[0];          # UTF-32�ֹ�
  my $utfchar;             # UTF-16LEʸ��

  if($code <= 65535)           {                      # U+0000-U+FFFF
      $utfchar = pack("v*", $code);
  } elsif($code <= 1114111)  {                        # U+010000-U+10FFFF
      $utfchar = pack("v*", ((($code-65536)/1024)+55296), (($code%1024)+56320));
  }

  return($utfchar);

}  ## END of sub _32n_16lec()



###
###   sub _32n_16bec()
###
###   UTF-32�ֹ��UTF-16BEʸ�����Ѵ����롣
###
###   ���
###   pack("n*", $a, $b); �Ȥ�����硢(network order = big endian)
###    $a���byte, $a����byte, $b���byte, $b����byte
###   �ν���ǽ��Ϥ���롣
###
sub _32n_16bec {
  my $code=$_[0];          # UTF-32�ֹ�
  my $utfchar;             # UTF-16BEʸ��

  if($code <= 65535)           {                      # U+0000-U+FFFF
      $utfchar = pack("n*", $code);
  } elsif($code <= 1114111)  {                        # U+010000-U+10FFFF
      $utfchar = pack("n*", ((($code-65536)/1024)+55296),(($code%1024)+56320));
  }

  return($utfchar);

}  ## END of sub _32n_16bec()



###
###   sub _32n_32lec()
###
###   UTF-32�ֹ��UTF-32LEʸ�����Ѵ����롣
###
sub _32n_32lec {
  my $code=$_[0];          # UTF-32�ֹ�
  my $utfchar;             # UTF-32LEʸ��

  $utfchar = pack("V*", $code);

  return($utfchar);

}  ## END of sub _32n_32lec()



###
###   sub _32n_32bec()
###
###   UTF-32�ֹ��UTF-32BEʸ�����Ѵ����롣
###
sub _32n_32bec {
  my $code=$_[0];          # UTF-32�ֹ�
  my $utfchar;             # UTF-32BEʸ��

  $utfchar = pack("N*", $code);

  return($utfchar);

}  ## END of sub _32n_32bec()



###
###   sub _16_rev()
###
###   UTF-16LEʸ����UTF-16BEʸ�����Ѵ����롣
###   �⤷����
###   UTF-16BEʸ����UTF-16LEʸ�����Ѵ����롣
###
#sub _16_rev {
#  my $inchar=$_[0];          # UTF-16ʸ���ʰ��������Ϥ���
#  my @tmp=();
#  my $size;
#
#  @tmp = $inchar =~ /[\x00-\xFF]/go;
#  $size=@tmp;
#  if($size == 2) {
#    ($tmp[0],$tmp[1]) = ($tmp[1],$tmp[0]);
#  } elsif($size == 4) {
#    ($tmp[0],$tmp[1],$tmp[2],$tmp[3]) = ($tmp[1],$tmp[0],$tmp[3],$tmp[2]);
#  }
#  return(join('',@tmp));
#
#}  ## END of sub _16_rev()



###
###   sub _32_rev()
###
###   UTF-32LEʸ����UTF-32BEʸ�����Ѵ����롣
###   �⤷����
###   UTF-32BEʸ����UTF-32LEʸ�����Ѵ����롣
###
#sub _32_rev {
#  my $inchar=$_[0];          # UTF-32ʸ���ʰ��������Ϥ���
#  my @tmp=();
#
#  @tmp = $inchar =~ /[\x00-\xFF]/go;
#  ($tmp[0],$tmp[1],$tmp[2],$tmp[3]) = ($tmp[3],$tmp[2],$tmp[1],$tmp[0]);
#  return(join('',@tmp));
#
#}  ## END of sub _32_rev()



### ---------------------------------
### �ʲ���ʸ��������Υ��֥롼���� 
### ---------------------------------



###
###   sub utf8length()
###
###   UTF-8�Ѥ�length()
###
###   �Ȥ���
###   utf8length(\$line)
###
###   \$line: ʸ�������������ʸ����ʻ����Ϥ���
###                                   ^^^^^^^^
###
sub utf8length {
  local(*s) = @_;
  my $count = 0;

  $count = $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/$1/go;

  return($count);

}  ## END of sub utf8length()



###
###   sub utf8fold()
###
###   UTF-8�Ѥ�fold()
###
###   �Ȥ���
###   utf8fold(\$line,$width)
###
###   \$line: fold������ʸ����ʻ����Ϥ���
###   $width: fold����ʸ������byteñ�̤ǤϤʤ��������ޤǤ�ʸ������
###   ʸ�������Ƭ���������$widthʸ�����ΤȤ����fold����롣
###           ^^^^
###
sub utf8fold {
  local(*s,$width) = @_;

  if($s =~ m/^((?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width})/) {
    $s = $1;
  }

# �̤���ˡ
#
# (1)�������Ȥ�Ȥ�ʤ���ˡ(���Ū������Perl�ʤ�Ȥ���Ϥ�)
#  $s =~ m/^(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width}/;
#  $s = substr($s, $-[0], $+[0]-$-[0]);
#
# (2)�����󥿤�Ȥ���ˡ(�٤�)
#  my $i=0;
#  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/(($i++)>=$width)? '' : $1/geo;
#

}  ## END of sub utf8fold()



###
###   sub utf8foldr()
###
###   UTF-8�Ѥ�fold()��Reverse��
###
###   �Ȥ���
###   utf8foldr(\$line,$width)
###
###   \$line: fold������ʸ����ʻ����Ϥ���
###   $width: fold����ʸ������byteñ�̤ǤϤʤ��������ޤǤ�ʸ������
###   ʸ������������������$widthʸ�����ΤȤ����fold����롣
###           ^^^^
###
sub utf8foldr {
  local(*s,$width) = @_;

  if($s =~ m/((?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width})$/) {
    $s = $1;
  }

# �̤���ˡ
#
# (1)�������Ȥ�Ȥ�ʤ���ˡ(���Ū������Perl�ʤ�Ȥ���Ϥ�)
#  $s =~ m/(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width}$/;
#  $s = substr($s, $-[0], $+[0]-$-[0]);
#
# (2)�����󥿤�Ȥ���ˡ(�٤�)
#  my $len = &utf8length(\$s);
#  my $i=0;
#  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/(($i++)>=($len-$width))? $1 : ''/geo;
#

}  ## END of sub utf8foldr()



###
###   sub utf8tr()
###
###   UTF-8�Ѥ�tr()
###
###   utf8tr(\$line,$from,$to)
###
###   \$line: tr����������ʸ����ʻ����Ϥ���
###    $from: �Ѵ���ʸ����
###    $to:   �Ѵ���ʸ����
###
###  (��)
###   &utf8tr(\$line, 'abcd', 'ABCD');
###
sub utf8tr {
  local(*s,$from,$to)=@_;
  my (@froma,@toa);
  my %table_tr;

  @froma = $from =~ /(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/go;
  @toa   = $to   =~ /(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/go;
  push(@toa, ($toa[$#toa]) x (@froma - @toa)) if @toa < @froma;
  @table_tr{@froma} = @toa;

  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/defined($table_tr{$1}) ? $table_tr{$1} : $1/geo;

}  ## END of sub utf8tr()



###
###   sub utf8tr_codepoint
###
###   utf8tr()���Ѵ������Ѵ���ʸ�����ʸ���ֹ�ǻ��ꤹ��褦�ˤ������
###
###   utf8tr_codepoint(\$line, \@from, \@to);
###
###   \$line: tr����������ʸ����ʻ����Ϥ���
###   \@from: �Ѵ���UTF-32ʸ���ֹ������ʥ�ե�����Ϥ���
###   \@to:   �Ѵ���UTF-32ʸ���ֹ������ʥ�ե�����Ϥ���
###
###  (��)
###  �ۻ��Τ�"��"(U+9ED1)��"��"(U+9ED2)��
###  �ۻ��Τ�"��"(U+9AD9)��"��"(U+9AD8)������������ΤǤ����,
###  ������������UTF-8ʸ�����$line����������
###
###   @from=(0x9ED1,0x9AD9);
###   @to  =(0x9ED2,0x9AD8);
###   &utf8tr_codepoint(\$line, \@from, \@to);
###
###  �Ȥ��롣
###
sub utf8tr_codepoint {
  local(*s,$from,$to) = @_;
  my @froma;
  my @toa;
  my %table_tr;

  @froma = @$from;
  @toa   = @$to;
  push(@toa, ($toa[$#toa]) x (@froma - @toa)) if @toa < @froma;
  foreach (@froma) { $_ = &_32n_8c($_);}
  foreach (@toa)   { $_ = &_32n_8c($_);}
  @table_tr{@froma} = @toa;

  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/defined($table_tr{$1}) ? $table_tr{$1} : $1/geo;

} ## END of sub utf8tr_codepoint



###
###   sub utf8h2z_kana()
###
###   UTF-8�ѤΥ��������Ѵ���Ⱦ�Ѥ������Ѥء�
###
###   �Ȥ���
###   utf8h2z_kana(\$line)
###
###   \$line: �Ѵ�����������ʸ����ʻ����Ϥ���
###
###   ��ջ���
###   ������Ⱦ������Ⱦ�ѥ������ʤ��Ѵ��������
###   ������Ⱦ�ѥ������ʤ��Ѵ����뤳�ȡ���������Ⱦ������Unicode2ʸ����ɽ������뤿�ᡣ��
###
sub utf8h2z_kana {
  local(*s)=@_;

  &_maketable_h2z_kana unless defined $tbl_h2z_kana_exist;   # �Ѵ��ѥơ��֥�̤�����Ǥ���С��������롣

  $s =~ s/($utf8_hkdaku)/defined($tbl_h2z_kana_daku{$1}) ? $tbl_h2z_kana_daku{$1} : $1/geo;
  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/defined($tbl_h2z_kana{$1}) ? $tbl_h2z_kana{$1} : $1/geo;

}  ## END of sub utf8h2z_kana()



###
###   sub _maketable_h2z_kana()
###
###   �Ѵ��ơ��֥������UTF-8�ѤΥ��������Ѵ���Ⱦ�Ѥ������Ѥء�
###
###   �Ȥ���
###   _maketable_h2z_kana
###
###   ��ջ���
###   U+FF9E(HALF WIDTH KATAKANA VOICED SOUND MARK)��U+3099�ǤϤʤ�U+309B(JIS:212B)���Ѵ����Ƥ��롣
###   U+FF9F(HALF WIDTH KATAKANA SEMI-VOICED SOUND MARK)��U+309A�ǤϤʤ�U+309C(JIS:212C)���Ѵ����Ƥ��롣
###   U+3099,U+309A�Τ������MS��ī,MS UI Gothic�Υե���Ȥ˴ޤޤ�Ƥ��ʤ���
###
sub _maketable_h2z_kana {
  my (@from,@to);
  my @from_tmp;
  my $i;

  $tbl_h2z_kana_exist=1; # �ơ��֥뤬�����Ѥߤ��ɤ����򼨤��ե饰

# ������Ⱦ������Ⱦ�ѥ�������(Unicode��2ʸ����ɽ�������)�Ѥ��Ѵ��ơ��֥����
# ���ѥ������ʤ�Unicode��1ʸ����ɽ������뤳�Ȥ���ա�
  @from_tmp  = (0xFF76,0xFF9E,0xFF77,0xFF9E,0xFF78,0xFF9E,0xFF79,0xFF9E,0xFF7A,0xFF9E,
                0xFF7B,0xFF9E,0xFF7C,0xFF9E,0xFF7D,0xFF9E,0xFF7E,0xFF9E,0xFF7F,0xFF9E,
                0xFF80,0xFF9E,0xFF81,0xFF9E,0xFF82,0xFF9E,0xFF83,0xFF9E,0xFF84,0xFF9E,
                0xFF8A,0xFF9E,0xFF8B,0xFF9E,0xFF8C,0xFF9E,0xFF8D,0xFF9E,0xFF8E,0xFF9E,
                0xFF8A,0xFF9F,0xFF8B,0xFF9F,0xFF8C,0xFF9F,0xFF8D,0xFF9F,0xFF8E,0xFF9F,
                0xFF73,0xFF9E,0xFF66,0xFF9E,0xFF9C,0xFF9E);
  @to        = (0x30AC,0x30AE,0x30B0,0x30B2,0x30B4,
                0x30B6,0x30B8,0x30BA,0x30BC,0x30BE,
                0x30C0,0x30C2,0x30C5,0x30C7,0x30C9,
                0x30D0,0x30D3,0x30D6,0x30D9,0x30DC,
                0x30D1,0x30D4,0x30D7,0x30DA,0x30DD,
                0x30F4,0x30FA,0x30F7);
  foreach $i (@from_tmp) { $i=&_32n_8c($i); }
  foreach $i (@to      ) { $i=&_32n_8c($i); }
  for($i=1;$i<=(@from_tmp/2);$i++) {
    push(@from, $from_tmp[($i-1)*2].$from_tmp[($i-1)*2+1]);
  }
  @tbl_h2z_kana_daku{@from} = @to;

# ������Ⱦ�ѥ�������(Unicode��1ʸ����ɽ�������)�Ѥ��Ѵ��ơ��֥����
  @from      = (0xFF61..0xFF9F);
  @to        = (0x3002,0x300C,0x300D,0x3001,0x30FB,0x30F2,0x30A1,0x30A3,0x30A5,
                0x30A7,0x30A9,0x30E3,0x30E5,0x30E7,0x30C3,0x30FC,0x30A2,0x30A4,
                0x30A6,0x30A8,0x30AA,0x30AB,0x30AD,0x30AF,0x30B1,0x30B3,0x30B5,
                0x30B7,0x30B9,0x30BB,0x30BD,0x30BF,0x30C1,0x30C4,0x30C6,0x30C8,
                0x30CA,0x30CB,0x30CC,0x30CD,0x30CE,0x30CF,0x30D2,0x30D5,0x30D8,
                0x30DB,0x30DE,0x30DF,0x30E0,0x30E1,0x30E2,0x30E4,0x30E6,0x30E8,
                0x30E9,0x30EA,0x30EB,0x30EC,0x30ED,0x30EF,0x30F3,0x309B,0x309C);
  foreach $i (@from) { $i=&_32n_8c($i); }
  foreach $i (@to  ) { $i=&_32n_8c($i); }
  @tbl_h2z_kana{@from} = @to;

}  ## END of sub _maketable_h2z_kana()



###
###   sub utf8z2h_an()
###
###   UTF-8�Ѥαѿ��Ѵ������Ѥ���Ⱦ�Ѥء�
###
###   �Ȥ���
###   utf8z2h_an(\$line)
###
###   \$line: �Ѵ�����������ʸ����ʻ����Ϥ���
###
sub utf8z2h_an {
  local(*s)=@_;

  &_maketable_z2h_an unless defined $tbl_z2h_an_exist;   # �Ѵ��ѥơ��֥�̤�����Ǥ���С��������롣

  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/defined($tbl_z2h_an{$1}) ? $tbl_z2h_an{$1} : $1/geo;

}  ## END of sub utf8z2h_an()



###
###   sub _maketable_z2h_an()
###
###   �Ѵ��ơ��֥������UTF-8�Ѥαѿ��Ѵ������Ѥ���Ⱦ�Ѥء�
###
###   �Ȥ���
###   _maketable_utf8z2h_an
###
sub _maketable_z2h_an {
  my (@from,@to);
  my $i;

  $tbl_z2h_an_exist=1; # �ơ��֥뤬�����Ѥߤ��ɤ����򼨤��ե饰

  @from=(0xFF10..0xFF19, 0xFF21..0xFF3A, 0xFF41..0xFF5A);  # ���ѿ��������ѱ�ʸ������ʸ���ˡ����ѱ�ʸ���ʾ�ʸ����
  @to  =(0x0030..0x0039, 0x0041..0x005A, 0x0061..0x007A);  # Ⱦ�ѿ�����Ⱦ�ѱ�ʸ������ʸ���ˡ�Ⱦ�ѱ�ʸ���ʾ�ʸ����
  foreach $i (@from) { $i=&_32n_8c($i); }
  foreach $i (@to  ) { $i=&_32n_8c($i); }
  @tbl_z2h_an{@from} = @to;

}  ## END of sub _maketable_z2h_an()



###
###   sub ref_to_utf8()
###
###   UTF-8ʸ�������ʸ�����ȡʿ���ʸ�����ȡ�ʸ�����λ��ȡˤ�ʸ�����Τ�Τ��ִ����롣
###   ̤����⤷����������ʸ�����Ȥ��ִ����줺�ˤ��Τޤ޻Ĥ롣
###
sub ref_to_utf8 {
  local(*s) = @_;

  $s =~ s/(&[a-zA-Z0-9]+;|&#[xX][a-fA-F0-9]{1,8};|&#[0-9]{1,7};)/&_ref_to_utf8($1)/geo;

} ## END of sub ref_to_utf8()



###
###   sub _ref_to_utf8()
###
###   ʸ������(����ʸ������,ʸ�����λ���)ʸ�����UTF-8ʸ��(ʸ�����Τ��)���Ѵ����롣
###
sub _ref_to_utf8 {
  my $s = $_[0];
  my $tmp;
  my $val;
  my $utfchar;

  &_maketable_ref_to_utf8 unless defined $tbl_ref_to_utf8_exist;

  $tmp=$s;
  if($tmp =~ /^&#/o) {  # ����ʸ�����ȷ���
    $tmp     =~ tr/&#;//d;
    $val     =  ($tmp =~ /^x/io)  ? hex(lc($tmp))      : $tmp;
    $utfchar =  ($val<=0x10FFFF && vec($bitstr_numref_except,$val,1)!=1) ? &_32n_8c($val) : $s;
  } else {            # ʸ�����λ��ȷ���
    $tmp     =~ tr/&;//d;
    $utfchar =  defined($tbl_ref_to_utf8{$tmp}) ? $tbl_ref_to_utf8{$tmp} : $s;
  }

  return($utfchar);

} ## END of sub _ref_to_utf8()



###
###   sub _maketable_ref_to_utf8
###
###   ʸ�����λ���(&��;��ޤޤʤ�ʸ����)����ʸ�����Τ��(UTF-8ʸ��)�ؤ��Ѵ��ơ��֥��������롣
###   �Ѵ��оݳ��ο���ʸ�����ȤΥꥹ�ȡʥӥåȥ��ȥ�󥰡ˤ�������롣
###
sub _maketable_ref_to_utf8 {
  local *IN;
  my    @from;
  my    @to;
  my    @tmp;

  $tbl_ref_to_utf8_exist=1; # �ơ��֥뤬�����Ѥߤ��ɤ����򼨤��ե饰

  if (!open(IN, "<$mappingent")) {
      &printoutstr("Error: $mappingent does not exist.\n");
      exit(1);
  }

  undef $bitstr_numref_except; # ǰ�Τ���

  while(<IN>) {
    if(/^\s*#/o) {next;}
    chomp;
    s/^\s+//o;
    s/#.*//o;
    if(/^\$numerical_char_reference_exception/io) {
      s/^.+=//o;
      tr/()//d;
      s/\s+//go;
      @tmp = split /,/o;
      foreach (@tmp) {
        $_ = (/^0x/io) ? hex(lc($_)) : $_;
        vec($bitstr_numref_except, $_, 1)=1;       
      }
      next;
    } # END of if(/^\$numerical_char_reference_exception/o)
    @tmp = split /\s+/o;
    if (@tmp!=2)  {next;}

    push(@from, $tmp[0]);
    push(@to,   &_32n_8c(($tmp[1] =~ /^0x/io) ? hex(lc($tmp[1])): $tmp[1]));

  }
  close(IN);

  @tbl_ref_to_utf8{@from}=@to;

} ## END of sub _maketable_ref_to_utf8



###
###   sub utf8_to_ref()
###
###   UTF-8ʸ�������2,3,4�Х���ʸ�������ʸ������(10�ʷ���, &#XXXXX;)���ִ����롣
###   1�Х���ʸ�����ִ����줺�ˤ��Τޤ޻Ĥ롣
###
sub utf8_to_ref {
  local(*s) = @_;

  $s =~ s/($utf8_2byte|$utf8_3byte|$utf8_4byte)/'&#'.&_8c_32n($1).';'/geo;

} ## END of sub utf8_to_ref()



### ---------------------------
### �ʲ�������¾�Υ��֥롼���� 
### ---------------------------



###
###   sub chop_eol()
###
###   ����ʸ�������롣
###
###   chop_eol(\$line)
###   chop_eol(\$line,'utf8')
###
###   �����о�
###   SJIS,JIS,EUC:  0x0D,0x0A
###   UTF-8:         0x0D,0x0A,U+2028,U+2029
###
sub chop_eol {
  local(*s,$icode) = @_;  # �о�ʸ����ʻ����Ϥ��ˡ��Ѵ���ʸ�������ɡʾ�ά�ġ�
  my $code;

  if($icode) {
    $code = $icode;
  } else {
    $code = &getcode(\$s);
  }

  if($code eq 'sjis' || $code eq 'jis') {
    $s =~ tr/\x0D\x0A//d;
  } elsif($code eq 'euc') {
    $s =~ tr/\x0D\x0A//d;
  } elsif($code eq 'utf8'){
    $s =~ s/(?:$utf8_nl)//go;
  }

}  ## END of sub chop_eol()



###
### UTF-8ʸ������Υ��ߤ����롣
###
sub sanitize_utf8 {
  local(*s) = @_;   # �о�ʸ����ʻ����Ϥ���
  my    @tmp=();

  @tmp = $s =~ /(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/go;
  $s = join('',@tmp);

}  ## END of sub sanitize_utf8()



###
### EUCʸ������Υ��ߤ����롣
###
sub sanitize_euc {
  local(*s) = @_;   # �о�ʸ����ʻ����Ϥ���
  my    @tmp=();

  @tmp = $s =~ /(?:$euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/go;
  $s = join('',@tmp);

}  ## END of sub sanitize_euc()



###
### sub printoutstr()
###
### ���ϴؿ�
###
### �Ȥ���
### printoutstr(" msearch is a search engine script.")
###
### ��ջ���
### Ⱦ�ѱѿ�����ʳ���ʸ���ϰ�����ʸ����˴ޤ�ʤ��Ǥ��������������ꤷ�Ƥ��ޤ��󡣡�
###
###
sub printoutstr {
    my $str = $_[0];		# ʸ����(���������Ϥ�)

	print $str;

} ## END of sub printoutstr



1;
