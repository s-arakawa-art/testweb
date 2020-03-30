package utfjp;
#
# utfjp.pl 日本語文字コード <-> Unicode間相互変換ライブラリ
#
# Ver 1.02 2016/05/08
#
# Copyright(C) 2004-2016 毛流麦花. All rights reserved.
#
#
# Unicode未対応のPerlでUnicodeを扱うためのライブラリ
#
#
# 本ソフトウェアは以下の利用規定に同意した場合のみ使用することができます。
# 以下の利用規程に同意した場合のみ、
# 本ソフトウェアの使用権が作成者(毛流麦花)から貸与されることになります。
# (あくまでも使用許諾であり、使用権が譲渡されるわけではありません。)
#
# [利用規定]
# (1)本ライブラリ・ソフトウェア(utfjp.pl)はフリーソフトウェアですが
#    著作権は作成者（毛流麦花）に帰属し、すべての権利は留保されています。
# (2)本ライブラリ・ソフトウェアを使用したことによるいかなる損害、トラブル、損失、結果についても
#    作成者は責任を負いません。
# (3)本ライブラリ・ソフトウェア(utfjp.pl)内の著作権表記、利用規定を削除することはできません。
# (4)本ライブラリ・ソフトウェアは非商用目的においては自由にお使いいただけます。
# (5)本ライブラリ・ソフトウェアを商用目的で使うには、作成者から書面での許可を事前に得る必要があります。
# (6)改変がない状態でのutfjp.plの再配布は自由です。再配布に際して、
#    作成者の事前・事後の承諾を得る必要はありませんし、作成者に連絡する必要はありません。
# (7)改変があるutfjp.plの再配布は、改変されていることが明記されており、
#    さらに改変箇所が明記されている場合のみ可能です。
#    この場合の再配布についても、作成者の事前・事後の承諾を得る必要はありませんし、作成者に連絡する必要はありません。
# (8)前(6),(7)項の再配布に伴って発生したいかなる損害、トラブル、損失、結果についても
#    作成者（毛流麦花）は責任を負いません。
# (9)本ライブラリ・ソフトウェアのバグ（不具合）について作成者は修正する義務を負いません。
# (10)作成者は本ライブラリ・ソフトウェアに関する依頼・質問に答える義務を負いません。
# (11)本ライブラリ・ソフトウェアはHP内全文検索エンジンmsearchをUnicodeに対応させることを意図して
#     作られたものであり、汎用性は一切考慮されていません。
#     また仕様・インターフェース等は予告なく変更することがあります。
#
#
# ■本ファイルは必ずEUC+LF（文字コード:EUC、改行コード:LF）で保存してください。■
#
#
# [注意事項]
# (1)プログラム内では半角英数記号(ASCII)のみを使用してください。
# 全角文字はコメント内でのみ使用するようにしてください。
# これはEUC-JPで保存され実行されているPerlスクリプトからでも本ライブラリを使用できるようにするためです。
#
# (2)本ライブラリの動作にはjcode.plが必要です。
# jcode.plと同じディレクトリにutfjp.pl,utfjpmap.txt,utfjpent.txtを置いてください。
# utfjpsupサブディレクトリもjcode.plと同じディレクトリに置いてください。
# なお、本ライブラリをrequireしたスクリプトでは、jcode.plのサブルーチンを
# 直接、自由に呼び出すことができます。
#
# [履歴]
#
# Ver 1.00 2004/04/15 最初のバージョン
#
# Ver 1.01 2012/01/29 HTML5対応のための修正
#   sub _get_html_encoding()内の文字コード名抽出箇所をHTML5に対応できるように修正した。
#
# Ver 1.02 2016/05/08 誤記修正
#   myで宣言対象が2変数以上ある場合に必要な括弧を追記した。 (例) my $a,$b; -> my ($a,$b);
#
# use bytes;  # Unicode対応のPerlで(character semanticsでなく)byte semanticsを強制する。

# 初期化ルーチンがまだ呼ばれていないときはinit()を実行する。
&_init unless defined $utfjp_init_done;



###
###   sub _init()
###
###   初期化ルーチン
###
sub _init {
  require './jcode.pl';
  $utfjp_init_done = 1;

  # マッピングテーブルのファイル名
  $mappingju  = './utfjpmap.txt';  # JIS<->Unicode マッピングテーブル
  $mappingent = './utfjpent.txt';  # 文字実体参照  マッピングテーブル
  $supfolder  = './utfjpsup/';     # SBCS, DBCS用マッピングテーブルを置くディレクトリ名

  # マッピングテーブル制御用フラグ(変更したい場合はsub mappingmodeを使う。)
  $mapping_j2u=1;  # JIS -> Unicode方向のマッピングテーブルを作成する。
  $mapping_u2j=1;  # Unicode -> JIS方向のマッピングテーブルを作成する。

  # UTFエンコーディングのBOM
  $utf8_bom      = "\xEF\xBB\xBF";      # BOM for UTF-8
  $utf16le_bom   = "\xFF\xFE";          # BOM for UTF-16LE
  $utf16be_bom   = "\xFE\xFF";          # BOM for UTF-16BE
  $utf32le_bom   = "\xFF\xFE\x00\x00";  # BOM for UTF-32LE
  $utf32be_bom   = "\x00\x00\xFE\xFF";  # BOM for UTF-32BE

  # UTFエンコーディング文字の各種正規表現
  $utf8_1byte    = "[\x00-\x7F]";                                  # UTF-8での1バイト文字
  $utf8_2byte    = "[\xC0-\xDF][\x80-\xBF]";                       # UTF-8での2バイト文字
  $utf8_3byte    = "[\xE0-\xEF][\x80-\xBF][\x80-\xBF]";            # UTF-8での3バイト文字
  $utf8_4byte    = "[\xF0-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF]"; # UTF-8での4バイト文字
#  # UTF-8エンコーディングの厳密な正規表現（未使用）
#  $utf8_2byte    = "[\xC2-\xDF][\x80-\xBF]";                                       # UTF-8での2バイト文字
#  $utf8_3byte    = "\xE0[\xA0-\xBF][\x80-\xBF]|[\xE1-\xEC][\x80-\xBF][\x80-\xBF]|".
#                   "\xED[\x80-\x9F][\x80-\xBF]|[\xEE-\xEF][\x80-\xBF][\x80-\xBF]"; # UTF-8での3バイト文字
#  $utf8_4byte    = "\xF0[\x90-\xBF][\x80-\xBF][\x80-\xBF]|".
#                   "[\xF1-\xF3][\x80-\xBF][\x80-\xBF][\x80-\xBF]|".
#                   "\xF4[\x80-\x8F][\x80-\xBF][\x80-\xBF]";                        # UTF-8での4バイト文字
  $utf8_hira     = "\xE3\x81[\x81-\xBF]|\xE3\x82[\x80-\x93]";      # UTF-8でのひらがなの正規表現
  $utf8_kata     = "\xE3\x82[\xA1-\xBF]|\xE3\x83[\x80-\xB6]";      # UTF-8での全角カタカナの正規表現
  $utf8_hkdaku   = "\xEF\xBD[\xB6-\xBF]\xEF\xBE\x9E|"
                  ."\xEF\xBE[\x80-\x84\x8A-\x8E]\xEF\xBE\x9E|"
                  ."\xEF\xBE[\x8A-\x8E]\xEF\xBE\x9F|"
                  ."\xEF\xBD\xB3\xEF\xBE\x9E|"
                  ."\xEF\xBD\xA6\xEF\xBE\x9E|"
                  ."\xEF\xBE\x9C\xEF\xBE\x9E";                     # UTF-8での半角カタカナ（濁音・半濁音）の正規表現
  $utf8_nl       = "\x0D|\x0A|\x0D\x0A|\xE2\x80\xA8|\xE2\x80\xA9"; # UTF-8での改行文字の正規表現(U+2028,U+2029)

  $utf16le_2byte = "[\x00-\xFF][\x00-\xD7\xE0-\xFF]";              # UTF-16LEでの1文字(BMPの文字)
  $utf16be_2byte = "[\x00-\xD7\xE0-\xFF][\x00-\xFF]";              # UTF-16BEでの1文字(BMPの文字)
  $utf16le_4byte = "[\x00-\xFF][\xD8-\xDB][\x00-\xFF][\xDC-\xDF]"; # UTF-16LEでの1文字(Surrogate領域の文字)
  $utf16be_4byte = "[\xD8-\xDB][\x00-\xFF][\xDC-\xDF][\x00-\xFF]"; # UTF-16BEでの1文字(Surrogate領域の文字)
  $utf32le_4byte = "[\x00-\xFF][\x00-\xFF][\x00-\x10]\x00";        # UTF-32LEでの1文字
  $utf32be_4byte = "\x00[\x00-\x10][\x00-\xFF][\x00-\xFF]";        # UTF-32BEでの1文字

#  # UTFエンコーディングテキストの正規表現（未使用）
#  $utf16be       = "^$utf16be_bom(?:$utf16be_2byte|$utf16be_4byte)+\$";  # BOM付UTF-16BEテキストの正規表現
#  $utf16le       = "^$utf16le_bom(?:$utf16le_2byte|$utf16le_4byte)+\$";  # BOM付UTF-16LEテキストの正規表現
#  $utf32be       = "^$utf32be_bom(?:$utf32be_4byte)+\$";                 # BOM付UTF-32BEテキストの正規表現
#  $utf32le       = "^$utf32le_bom(?:$utf32le_4byte)+\$";                 # BOM付UTF-32LEテキストの正規表現
#  $utf8          = "^(?:$utf8_bom)?(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)+\$";  # UTF-8テキストの正規表現

  # EUC-JP文字の各種正規表現
  $euc_1byte     = "[\x00-\x7F]";		                           # EUCでのJIS X 0201 ASCII
  $euc_hkana     = "\x8E[\xA1-\xDF]";	                           # EUCでのJIS X 0201 半角カタカナ
  $euc_kan2      = "[\xA1-\xFE][\xA1-\xFE]";                       # EUCでのJIS X 0208 全角文字
  $euc_kan3      = "\x8F[\xA1-\xFE][\xA1-\xFE]";                   # EUCでのJIS X 0211 全角文字

  # ISO-2022-JP文字の各種正規表現
  $esc_hkana     = "\x1B\x28\x49";                                 # ISO-2022-JP ESCシーケンス 半角カナ
  $esc_ascii     = "\x1B\x28\x42";                                 # ISO-2022-JP ESCシーケンス ASCII
  $jis_so        = "\x0E";                                         # ISO-2022-JP SO(Shift Out)
  $jis_si        = "\x0F";                                         # ISO-2022-JP SI(Shift In)

 # SBCS文字の正規表現
  $sbcs_1char    = "[\x00-\xFF]";                                  # SBCS(ISO8859, CodePage, etc)での1文字


} ## END of sub _init()



###
###   sub del_all_tables
###
###   変換処理用の各種テーブルを削除(未定義状態)にする。
###   特に非Unicode <-> Unicode間の変換が完了したら、速やかに呼び出してメモリを開放するようにする。
###
sub del_all_tables {

 # UTF-8<->EUC 関連
 undef $table_exist;
 undef %tbl_utf8toeuc;
 undef %tbl_euctoutf8;

 # SBCS <->UTF-8 関連
 undef $tbl_sbcs_now;
 undef %tbl_sbcs2utf8;
 undef %tbl_utf8tosbcs;

 # 半角カタカナ -> 全角カタカナ 関連
 undef $tbl_h2z_kana_exist;
 undef %tbl_h2z_kana_daku;
 undef %tbl_h2z_kana;

 # 全角英数 -> 半角英数 関連
 undef $tbl_z2h_an_exist;
 undef %tbl_z2h_an;

 # 文字参照 -> UTF-8 関連
 undef $tbl_ref_to_utf8_exist;
 undef %tbl_ref_to_utf8;
 undef $bitstr_numref_except;

} ## END of sub del_all_tables



### -------------------------------------
### 以下、文字コード判定のサブルーチン集 
### -------------------------------------



###
###   sub getcode()
###
###   文字列の文字コードを返す。
###
###   まずUnicode形式であるかを調べ、該当した場合は
###   以下のいずれかを返す。
###
###   'utf32be'    : UTF-32 Big Endian
###   'utf32le'    : UTF-32 Little Endian
###   'utf16be'    : UTF-16 Big Endian
###   'utf16le'    : UTF-16 Little Endian
###   'utf8'       : UTF-8
###
###   UTF-32LEをUTF-16LEであると誤判定するのを防止するため、
###   UTF-32であるかどうかの判定をUTF-16であるかどうかの判定よりも先に行う。
###
sub getcode {
  local(*s)   = @_;  # 判定対象文字列（参照渡し）
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
    # UTF-8, SJIS, EUC間の判定は慎重に行う。
#    if($s =~ /$utf8/o) { push(@judge, 'utf8'); }  # UTF-8として合致するか?
#    ($guess,$code)    =  &jcode::getcode(\$s);    # jcode.plの判定
#    if($guess)         { push(@judge, $code) unless($code eq ''); }

    if(@judge==1) {
      $matched =1;
      $code    =$judge[0];
      return(wantarray ? ($matched, $code) : $code);

    } else {
      ($guess,$code)    = &_get_html_encoding($s); # HTMLエンコーディングのチェック
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }

      ($guess,$code)    = &_get_xml_encoding($s);  # XML(XHTML)エンコーディングのチェック
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }

      if($s =~ /^$utf8_bom/o) {                    # UTF-8のBOMがあったら、UTF-8であると断定する。
        $matched = 1;
        $code    = 'utf8';
        return(wantarray ? ($matched, $code) : $code);
      }

      ($guess,$code)    = &_check_kana(\$s);       # UTF-8かなチェック(UTF-8Nの非マークアップ日本語テキストを拾うため)
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }

      ($guess,$code)    = &_check_kana_multi(\$s); # UTF-8かなチェック2(UTF-8Nの非マークアップ日本語テキストを拾うため)
      if($guess) {
        $matched = 1;
        return(wantarray ? ($matched, $code) : $code);
      }
    } ## END of if(@judge==1)...

    # これでも判定しきれない場合(たぶんSJISかEUCの非マークアップテキスト)、jcode.plの判定結果をそのまま返す。
    ($matched,$code) = &jcode::getcode(\$s);

  }  ## END of if($s=~ /^$utf32be_bom/o)...

  return(wantarray ? ($matched, $code) : $code);
}  ## END of sub getcode()



###
###   sub _check_kana()
###
###   UTF-8でひらがな・全角カタカナチェックを試み、判定結果を返す。(連続4文字が1回以上出現すること)
###
###   UTF-8に於けるひらがな(全角カタカナ)4文字のバイトの並びはSJIS,EUCではまず出現し得ないとの考えに基づく。
###
###   &_check_kana(\$line)
###
sub _check_kana {
  local(*s)   = @_;   # 判定対象文字列（参照渡し）
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
###   UTF-8でひらがな・全角カタカナチェックを試み、判定結果を返す。(連続3文字が4回以上出現すること)
###
###   _check_kana_multi(\$line)
###
sub _check_kana_multi {
  local(*s)   = @_;   # 判定対象文字列（参照渡し）
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
###   HTMLのcharsetを調べて返す。
###   対象文字列の文字コードはASCII系エンコーディングであること。(UTF-16, 32は不可。)
###   文字コードを判定するためのsubなので、どの文字コードの文字列がやってくるかはわからない。
###   UTF-8はBOMがついているかもしれない。
###
###   _get_html_encoding($line)
###
sub _get_html_encoding {
  my $s       = $_[0];   # 判定対象文字列（値渡し）
  my $mime    = '';
  my $matched = 0;
  my $code    = '';

  # 一部のタグを除去する
  # idea by まっとさん
  $s =~ s{<script.*?</script>|<style.*?</style>|<code.*?</code>|<\?.*?\?>|<%.*?%>}{ }ig;

  # コメントタグの一部でない -- を無害化
  $s =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

  # コメント除去（入れ子コメント対応）
  # Tack sa mycket!  http://www.din.or.jp/~ohzaki/perl.htm
  $s =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)//gs;

  # 無害化された -- を戻す
  $s =~ s/&#45;&#45;/--/gs;

  # <html>タグがあったらHTMLとみなし、
  # <meta>タグで指定された文字コード名を抽出する。
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
###   XML(含 XHTML)のencodingを調べて返す。
###   対象文字列の文字コードはASCII系エンコーディングであること。(UTF-16, 32は不可。)
###   文字コードを判定するためのsubなので、どの文字コードの文字列がやってくるかはわからない。
###   UTF-8はBOMがついているかもしれない。
###
###   _get_xml_encoding($line)
###
sub _get_xml_encoding {
  my $s       = $_[0];   # 判定対象文字列（値渡し）
  my $mime    = '';
  my $matched = 0;
  my $code    = '';

  # 一部のタグを除去する
  # idea by まっとさん
  $s =~ s{<script.*?</script>|<style.*?</style>|<code.*?</code>|<%.*?%>}{ }ig; # <\?.*?\?> は外した。

  # コメントタグの一部でない -- を無害化
  $s =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

  # コメント除去（入れ子コメント対応）
  # Tack sa mycket!  http://www.din.or.jp/~ohzaki/perl.htm
  $s =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)//gs;

  # 無害化された -- を戻す
  $s =~ s/&#45;&#45;/--/gs;

  # XML宣言があったらXMLとみなし、
  # encoding宣言で指定された文字コード名を抽出する。
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
###   エンコーディングのMIME名(IANA表記名)を短縮名に変更する。
###
###   _mime_to_sname($iana_name)
###
sub _mime_to_sname {
  my $s       = $_[0];   # IANA表記のエンコーディング名（値渡し）
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

  } elsif($s =~ /^utf-16le$/i) {  # 実際には不要
    $matched = 1;
    $code    = 'utf16le';

  } elsif($s =~ /^utf-16be$/i) {  # 実際には不要
    $matched = 1;
    $code    = 'utf16be';

  } elsif($s =~ /^utf-32le$/i) {  # 実際には不要
    $matched = 1;
    $code    = 'utf32le';

  } elsif($s =~ /^utf-32be$/i) {  # 実際には不要
    $matched = 1;
    $code    = 'utf32be';

  } elsif($s =~ /^iso-8859-1$/i) { # $を付けているのは ISO-8859-10などに間違えてマッチさせないため。
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

  } elsif($s =~ /^(?:iso-8859-6|asmo-708)$/i) {  # ASMO-708(アラビア語)はISO-8859-6とみなす。(RFC-1345)
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

  } elsif($s =~ /^(?:ibm-?00|cp)858$/i) {   # IBM858では認識されない。IBM00858でないとダメ。
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
###   HTMLかXMLであったら、真を返す。
###
###   前提条件
###   コメントは既に除去されていること。
###   対象文字列はBOM無UTF-8に変換されていること。
###   改行文字は既に除去されていること。(含 U+2028, U+2029)
###
###   is_html_or_xml(\$line)
###
sub is_html_or_xml {
  local(*s)   = @_;   # 判定対象文字列（参照渡し）
  my $matched = 0;

  if($s =~ m{<html.*?>}i) {
    $matched = 1;
  } elsif($s =~ m{<\?xml\s[^>?]*?version[^>?]*?\?>}) {
    $matched = 1;
  }

  return($matched);

}  ## END of sub is_html_or_xml



### ---------------------------------------------
### 以下、言語(lang属性など)関係のサブルーチン集 
### ---------------------------------------------



###
###   sub getlang()
###
###   HTML,XML(含 XHTML)のlang属性を調べて返す。
###   lang属性がない場合は、'und'(ISO639-2でUndeterminedの意味)を返す。
###   対象文字列の文字コードはASCII系エンコーディングであること。(UTF-16, 32は不可。)
###   どの文字コードの文字列がやってくるかはわからない。
###   UTF-8はBOMがついているかもしれない。
###
###   getlang($line)
###
sub getlang {
  my $s       = $_[0];   # 判定対象文字列（値渡し）
  my $matched = 0;
  my $lang    = '';

  # 一部のタグを除去する
  # idea by まっとさん
  $s =~ s{<script.*?</script>|<style.*?</style>|<code.*?</code>|<\?.*?\?>|<%.*?%>}{ }ig;

  # コメントタグの一部でない -- を無害化
  $s =~ s/([^<][^!])(--)([^>])/$1&#45;&#45;$3/gs;

  # コメント除去（入れ子コメント対応）
  # Tack sa mycket!  http://www.din.or.jp/~ohzaki/perl.htm
  $s =~ s/<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)//gs;

  # 無害化された -- を戻す
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
### 以下、文字コード変換のサブルーチン集 
### -------------------------------------



###
### sub mappingmode()
###
### sub _maketable()で作成するマッピングテーブルのモードを変更する。
### デフォルトはbidi（双方向）モード。(&initを見よ。)
### SBCS用マッピングテーブルは影響を受けない。(本モードの設定に関わりなく常に双方向モード)
###
### &mappingmode('j2u');  # マッピングテーブルをJIS -> Unicode方向のみ作成する。
### &mappingmode('u2j');  # マッピングテーブルをUnicode -> JIS方向のみ作成する。
### &mappingmode('bidi'); # マッピングテーブルをJIS <-> Unicode双方向について作成する。
###
### (例1) JIS -> Unicode方向のみで充分な場合は、require呼出直後に変更する。
###
### require './utfjp.pl';
### &utfjp::mappingmode('j2u');
###
### (例2) 既にあるマッピングテーブルを変更するには、一度テーブルを削除した後にモードを変更する。
###
### (既に双方向のテーブルがある。)
### &utfjp::del_all_tables;
### &utfjp::mappingmode('j2u');
### (マッピングテーブルは必要になった時点で自動的に作成される)
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
### UTF-8<->EUCの変換をするためのマッピングテーブルを作成する。
###
sub _maketable {
  local *IN;
  my    @tmp=();

  $table_exist=1; # テーブルが作成済みかどうかを示すフラグ

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
    if($tmp[0] =~ /h/o) {                                  # JIS X 0212 補助漢字の場合
      $tmp[0] =~ tr/h//d;
#      $tmp[0] =  pack("C*",0x8F,((hex($tmp[0])+0x8080)>>8) & 0xFF, (hex($tmp[0])+0x8080) & 0xFF);
      $tmp[0] = chr(0x8F).pack("n",hex($tmp[0])+0x8080);

    } elsif(hex($tmp[0])>0xDF) {                           # JIS X 0208 漢字の場合
#      $tmp[0] = pack("C*",((hex($tmp[0])+0x8080)>>8) & 0xFF, (hex($tmp[0])+0x8080) & 0xFF);
      $tmp[0] = pack("n",hex($tmp[0])+0x8080);

    } elsif(0xA1<=hex($tmp[0]) && hex($tmp[0])<=0xDF) {    # JIS X 0201 半角カナの場合
#      $tmp[0] = pack("C*",0x8E,hex($tmp[0]));
      $tmp[0] = chr(0x8E).chr(hex($tmp[0]));

    } elsif(0x00<=hex($tmp[0]) && hex($tmp[0])<=0x7F) {    # JIS X 0201 半角英数記号の場合
#      $tmp[0] = pack("C*",hex($tmp[0]));
      $tmp[0] = chr(hex($tmp[0]));
    }

    $tmp[1] = &_32n_8c(hex($tmp[1]));

    if(@tmp==2) {
      $tbl_utf8toeuc{$tmp[1]} = $tmp[0] if($mapping_u2j);   # 変換テーブルの作成 UTF-8 -> EUC
      $tbl_euctoutf8{$tmp[0]} = $tmp[1] if($mapping_j2u);   # 変換テーブルの作成 EUC -> UTF-8
    } elsif(@tmp==3) {
      if(lc($tmp[2]) eq 'u2j') {
        $tbl_utf8toeuc{$tmp[1]} = $tmp[0] if($mapping_u2j); # 変換テーブルの作成 UTF-8 -> EUC(片方向のみ)
      }
      if(lc($tmp[2]) eq 'j2u') {
        $tbl_euctoutf8{$tmp[0]} = $tmp[1] if($mapping_j2u); # 変換テーブルの作成 EUC -> UTF-8(片方向のみ)
      }
    }

  } # END of while()

  close(IN);

} ## END of sub _maketable()



###
### sub _maketable_sbcs()
###
### SBCS<->UTF-8の変換をするテーブルを作成する。
###
### &_maketable_sbcs('iso885901')
###
sub _maketable_sbcs {
  my $encode = $_[0];  # このエンコーディングとUTF-8間のマッピングテーブル(双方向)を作成する。
  my $infile = '';
  local *IN;
  my    @tmp=();

  $infile = $supfolder.$encode.'.txt';

  if (!open(IN, "<$infile")) {
      &printoutstr("Error: $infile does not exist.\n");
      exit(1);
  }

  $tbl_sbcs_now=$encode;   # 変換ハッシュに現在格納されているエンコーディング
  undef %tbl_sbcs2utf8;    # SBCS->UTF-8変換用ハッシュは共用する。
  undef %tbl_utf8tosbcs;   # UTF-8->SBCS変換用ハッシュは共用する。

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

    $tbl_sbcs2utf8{$tmp[0]}  = $tmp[1];   # 変換テーブルの作成 SBCS  -> UTF-8
    $tbl_utf8tosbcs{$tmp[1]} = $tmp[0];   # 変換テーブルの作成 UTF-8 -> SBCS

  } # END of while()

  close(IN);

} ## END of sub _maketable_sbcs()



###
###   sub convert()
###
###   文字コードを変換する。
###
###   変換元文字コードを自動判定させる場合
###   convert(\$line, yyy);
###
###      yyy: 変換先文字コード
###
###   変換元文字コードを明示的に指定する場合
###   convert(\$line, yyy, xxx);
###
###      yyy: 変換先文字コード
###      xxx: 変換元文字コード
###
###   UTF-8への変換時、デフォルトではBOMが付加されない。
###   UTF-16LE,16BE,32LE,32BEへ変換時、デフォルトでBOMが付加される。
###
###   UTF-8への変換時にBOMを付加する場合（変換元文字コードを自動判定させる場合）
###   convert(\$line, 'utf8', '', 'bom');
###
###   UTF-8への変換時にBOMを付加する場合（変換元文字コードを明示的に指定する場合）
###   convert(\$line, 'utf8', 'euc', 'bom');
###
###   UTF-16LE,16BE,32LE,32BEへの変換時にBOMを付加しない場合（変換元文字コードを自動判定させる場合）
###   convert(\$line, 'utf16le', '', 'nobom');
###
###   UTF-16LE,16BE,32LE,32BEへの変換時にBOMを付加しない場合（変換元文字コードを明示的に指定する場合）
###   convert(\$line, 'utf16le', 'euc', 'nobom');
###
###   xxx,yyyには
###   'euc'
###   'sjis'
###   'jis'
###   'utf8'
###   'utf16le'
###   'utf16be'
###   'utf32le'
###   'utf32be'
###   'iso885901'その他
###   を指定する。
###
###   注意事項
###   ・スクリプト内でのテキスト処理はEUCかUTF-8で行い、
###     ファイルへ出力する直前にUTF-16LE,16BE,32LE,32BEへ変換すること。
###   ・WindowsプラットフォームでUTF-16LE,16BE,32LE,32BEをファイルへ出力するときは、
###     必ずバイナリーモードでの出力になるようにすること。
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
    &_maketable unless defined $table_exist;   # 変換用テーブル未作成であれば、作成する。
  } elsif(($code =~ /utf/) && ($ocode =~ /(?:sjis|jis|euc)/)) {
    &_maketable unless defined $table_exist;   # 変換用テーブル未作成であれば、作成する。
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

  } else {                                              # ------------- その他の場合は何もしない。
    # No Operation
  }

}  ## END of sub convert()



###
###   sub _sbcs_to_utf8()
###
###   SBCS系エンコーディング各種文字をUTF-8文字に変換する。
###   パターンマッチの置換部に入れる式
###
sub _sbcs_to_utf8 {

  my $inchar = $_[0];  # SBCS文字（引数、値渡し）
  my $incode = $_[1];  # SBCSエンコーディング名（引数、値渡し）

  &_maketable_sbcs($incode) unless($tbl_sbcs_now eq $incode);

  return($tbl_sbcs2utf8{$inchar}); # UTF-8文字（返値）

}  ## END of sub _sbcs_to_utf8()



###
###   sub _utf8_to_sbcs()
###
###   UTF-8文字をSBCS文字に変換する。
###   パターンマッチの置換部に入れる式
###
sub _utf8_to_sbcs {

  my $inchar = $_[0];  # UTF-8文字（引数、値渡し）
  my $incode = $_[1];  # SBCSエンコーディング名（引数、値渡し）

  &_maketable_sbcs($incode) unless($tbl_sbcs_now eq $incode);

  return($tbl_utf8tosbcs{$inchar}); # SBCS文字（返値）

}  ## END of sub _utf8_to_sbcs()



###
###   sub _8c_32n()
###
###   UTF-8文字をUTF-32番号に変換する。
###
sub _8c_32n {

  my $utfchar= $_[0];  # UTF-8文字（引数、値渡し）
  my @tmp;
  my $size;            # $utfcharの長さ（byte単位）
  my $code;            # UTF-32番号

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $size=@tmp;
  if ($size == 1) {
    $code = ord($tmp[0]);
  } elsif($size == 2) {
    $code = ((ord($tmp[0]) & 31) << 6) | (ord($tmp[1]) & 63);             # UTF-32番号を算出
  } elsif($size == 3) {
    $code = ((ord($tmp[0]) & 15) << 12) | ((ord($tmp[1]) & 63) << 6) |
            (ord($tmp[2]) & 63);                                          # UTF-32番号を算出
  } elsif($size == 4) {
    $code = ((ord($tmp[0]) & 7)  << 18) | ((ord($tmp[1]) & 63) << 12) |
            ((ord($tmp[2]) & 63) << 6) | (ord($tmp[3]) & 63);             # UTF-32番号を算出
  }

  return($code);

}  ## END of sub _8c_32n()



###
###   sub _16lec_32n()
###
###   UTF-16LE文字をUTF-32番号に変換する。
###
sub _16lec_32n {

  my $utfchar= $_[0];  # UTF-16LE文字（引数、値渡し）
  my @tmp;
  my $size;            # $utfcharの長さ（byte単位）
  my $code;            # UTF-32番号
  my ($c1,$c2);        # 一時変数

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $size=@tmp;
  if ($size == 2) {
    $code = ord($tmp[1])*256+ord($tmp[0]);             # UTF-32番号を算出
#    $code = unpack("n",$utfchar);
  } elsif($size == 4) {
    $c1 = ord($tmp[1])*256+ord($tmp[0]);
    $c2 = ord($tmp[3])*256+ord($tmp[2]);
    $code = (($c1-55296)*1024)+($c2-56320)+65536;      # UTF-32番号を算出
  }

  return($code);

}  ## END of sub _16lec_32n()



###
###   sub _16bec_32n()
###
###   UTF-16BE文字をUTF-32番号に変換する。
###
sub _16bec_32n {

  my $utfchar= $_[0];  # UTF-16BE文字（引数、値渡し）
  my @tmp;
  my $size;            # $utfcharの長さ（byte単位）
  my $code;            # UTF-32番号
  my ($c1,$c2);        # 一時変数

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $size=@tmp;
  if ($size == 2) {
    $code = ord($tmp[0])*256+ord($tmp[1]);             # UTF-32番号を算出
#    $code = unpack("n",$utfchar);
  } elsif($size == 4) {
    $c1 = ord($tmp[0])*256+ord($tmp[1]);
    $c2 = ord($tmp[2])*256+ord($tmp[3]);
    $code = (($c1-55296)*1024)+($c2-56320)+65536;      # UTF-32番号を算出
  }

  return($code);

}  ## END of sub _16bec_32n()



###
###   sub _32lec_32n()
###
###   UTF-32LE文字をUTF-32番号に変換する。
###
sub _32lec_32n {

  my $utfchar= $_[0];  # UTF-32LE文字（引数、値渡し）
  my @tmp;
  my $code;            # UTF-32番号
  my ($c1,$c2);        # 一時変数

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $c1 = ord($tmp[3])*256+ord($tmp[2]);
  $c2 = ord($tmp[1])*256+ord($tmp[0]);
  $code = ($c1*65536)+$c2;                             # UTF-32番号を算出

  return($code);

}  ## END of sub _32lec_32n()



###
###   sub _32bec_32n()
###
###   UTF-32BE文字をUTF-32番号に変換する。
###
sub _32bec_32n {

  my $utfchar= $_[0];  # UTF-32BE文字（引数、値渡し）
  my @tmp;
  my $code;            # UTF-32番号
  my ($c1,$c2);        # 一時変数

  @tmp = $utfchar =~ /[\x00-\xFF]/g;
  $c1 = ord($tmp[0])*256+ord($tmp[1]);
  $c2 = ord($tmp[2])*256+ord($tmp[3]);
  $code = ($c1*65536)+$c2;                             # UTF-32番号を算出

  return($code);

}  ## END of sub _32bec_32n()



###
###   sub _32n_8c()
###
###   UTF-32番号をUTF-8文字に変換する。
###
sub _32n_8c {
  my $code=$_[0];          # UTF-32番号
  my $utfchar;             # UTF-8文字

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
###   UTF-32番号をUTF-16LE文字に変換する。
###
###   注意
###   pack("v*", $a, $b); とした場合、(VAX order = little endian)
###    $b下位byte, $b上位byte, $a下位byte, $a上位byte
###   の順序で出力される。
###
sub _32n_16lec {
  my $code=$_[0];          # UTF-32番号
  my $utfchar;             # UTF-16LE文字

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
###   UTF-32番号をUTF-16BE文字に変換する。
###
###   注意
###   pack("n*", $a, $b); とした場合、(network order = big endian)
###    $a上位byte, $a下位byte, $b上位byte, $b下位byte
###   の順序で出力される。
###
sub _32n_16bec {
  my $code=$_[0];          # UTF-32番号
  my $utfchar;             # UTF-16BE文字

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
###   UTF-32番号をUTF-32LE文字に変換する。
###
sub _32n_32lec {
  my $code=$_[0];          # UTF-32番号
  my $utfchar;             # UTF-32LE文字

  $utfchar = pack("V*", $code);

  return($utfchar);

}  ## END of sub _32n_32lec()



###
###   sub _32n_32bec()
###
###   UTF-32番号をUTF-32BE文字に変換する。
###
sub _32n_32bec {
  my $code=$_[0];          # UTF-32番号
  my $utfchar;             # UTF-32BE文字

  $utfchar = pack("N*", $code);

  return($utfchar);

}  ## END of sub _32n_32bec()



###
###   sub _16_rev()
###
###   UTF-16LE文字をUTF-16BE文字に変換する。
###   もしくは
###   UTF-16BE文字をUTF-16LE文字に変換する。
###
#sub _16_rev {
#  my $inchar=$_[0];          # UTF-16文字（引数、値渡し）
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
###   UTF-32LE文字をUTF-32BE文字に変換する。
###   もしくは
###   UTF-32BE文字をUTF-32LE文字に変換する。
###
#sub _32_rev {
#  my $inchar=$_[0];          # UTF-32文字（引数、値渡し）
#  my @tmp=();
#
#  @tmp = $inchar =~ /[\x00-\xFF]/go;
#  ($tmp[0],$tmp[1],$tmp[2],$tmp[3]) = ($tmp[3],$tmp[2],$tmp[1],$tmp[0]);
#  return(join('',@tmp));
#
#}  ## END of sub _32_rev()



### ---------------------------------
### 以下、文字列処理のサブルーチン集 
### ---------------------------------



###
###   sub utf8length()
###
###   UTF-8用のlength()
###
###   使い方
###   utf8length(\$line)
###
###   \$line: 文字数を数えたい文字列（参照渡し）
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
###   UTF-8用のfold()
###
###   使い方
###   utf8fold(\$line,$width)
###
###   \$line: foldしたい文字列（参照渡し）
###   $width: foldする文字数（byte単位ではなく、あくまでも文字数）
###   文字列の先頭から数えて$width文字数のところでfoldされる。
###           ^^^^
###
sub utf8fold {
  local(*s,$width) = @_;

  if($s =~ m/^((?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width})/) {
    $s = $1;
  }

# 別の方法
#
# (1)後方参照を使わない方法(比較的新しいPerlなら使えるはず)
#  $s =~ m/^(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width}/;
#  $s = substr($s, $-[0], $+[0]-$-[0]);
#
# (2)カウンタを使う方法(遅い)
#  my $i=0;
#  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/(($i++)>=$width)? '' : $1/geo;
#

}  ## END of sub utf8fold()



###
###   sub utf8foldr()
###
###   UTF-8用のfold()、Reverse版
###
###   使い方
###   utf8foldr(\$line,$width)
###
###   \$line: foldしたい文字列（参照渡し）
###   $width: foldする文字数（byte単位ではなく、あくまでも文字数）
###   文字列の末尾から数えて$width文字数のところでfoldされる。
###           ^^^^
###
sub utf8foldr {
  local(*s,$width) = @_;

  if($s =~ m/((?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width})$/) {
    $s = $1;
  }

# 別の方法
#
# (1)後方参照を使わない方法(比較的新しいPerlなら使えるはず)
#  $s =~ m/(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte){$width}$/;
#  $s = substr($s, $-[0], $+[0]-$-[0]);
#
# (2)カウンタを使う方法(遅い)
#  my $len = &utf8length(\$s);
#  my $i=0;
#  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/(($i++)>=($len-$width))? $1 : ''/geo;
#

}  ## END of sub utf8foldr()



###
###   sub utf8tr()
###
###   UTF-8用のtr()
###
###   utf8tr(\$line,$from,$to)
###
###   \$line: tr処理したい文字列（参照渡し）
###    $from: 変換元文字列
###    $to:   変換先文字列
###
###  (例)
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
###   utf8tr()の変換元・変換先文字列を文字番号で指定するようにしたもの
###
###   utf8tr_codepoint(\$line, \@from, \@to);
###
###   \$line: tr処理したい文字列（参照渡し）
###   \@from: 変換元UTF-32文字番号の配列（リファレンス渡し）
###   \@to:   変換先UTF-32文字番号の配列（リファレンス渡し）
###
###  (例)
###  異字体の"黒"(U+9ED1)を"黒"(U+9ED2)に
###  異字体の"高"(U+9AD9)を"高"(U+9AD8)に正規化するのであれば,
###  正規化したいUTF-8文字列を$lineに代入し、
###
###   @from=(0x9ED1,0x9AD9);
###   @to  =(0x9ED2,0x9AD8);
###   &utf8tr_codepoint(\$line, \@from, \@to);
###
###  とする。
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
###   UTF-8用のカタカナ変換（半角から全角へ）
###
###   使い方
###   utf8h2z_kana(\$line)
###
###   \$line: 変換処理したい文字列（参照渡し）
###
###   注意事項
###   濁音・半濁音の半角カタカナを変換した後で
###   清音の半角カタカナを変換すること。（濁音・半濁音はUnicode2文字で表現されるため。）
###
sub utf8h2z_kana {
  local(*s)=@_;

  &_maketable_h2z_kana unless defined $tbl_h2z_kana_exist;   # 変換用テーブル未作成であれば、作成する。

  $s =~ s/($utf8_hkdaku)/defined($tbl_h2z_kana_daku{$1}) ? $tbl_h2z_kana_daku{$1} : $1/geo;
  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/defined($tbl_h2z_kana{$1}) ? $tbl_h2z_kana{$1} : $1/geo;

}  ## END of sub utf8h2z_kana()



###
###   sub _maketable_h2z_kana()
###
###   変換テーブル作成：UTF-8用のカタカナ変換（半角から全角へ）
###
###   使い方
###   _maketable_h2z_kana
###
###   注意事項
###   U+FF9E(HALF WIDTH KATAKANA VOICED SOUND MARK)はU+3099ではなくU+309B(JIS:212B)に変換している。
###   U+FF9F(HALF WIDTH KATAKANA SEMI-VOICED SOUND MARK)はU+309AではなくU+309C(JIS:212C)に変換している。
###   U+3099,U+309AのいずれもMS明朝,MS UI Gothicのフォントに含まれていない。
###
sub _maketable_h2z_kana {
  my (@from,@to);
  my @from_tmp;
  my $i;

  $tbl_h2z_kana_exist=1; # テーブルが作成済みかどうかを示すフラグ

# 濁音・半濁音の半角カタカナ(Unicodeの2文字で表現される)用の変換テーブル作成
# 全角カタカナはUnicodeの1文字で表現されることに注意。
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

# 清音の半角カタカナ(Unicodeの1文字で表現される)用の変換テーブル作成
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
###   UTF-8用の英数変換（全角から半角へ）
###
###   使い方
###   utf8z2h_an(\$line)
###
###   \$line: 変換処理したい文字列（参照渡し）
###
sub utf8z2h_an {
  local(*s)=@_;

  &_maketable_z2h_an unless defined $tbl_z2h_an_exist;   # 変換用テーブル未作成であれば、作成する。

  $s =~ s/($utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/defined($tbl_z2h_an{$1}) ? $tbl_z2h_an{$1} : $1/geo;

}  ## END of sub utf8z2h_an()



###
###   sub _maketable_z2h_an()
###
###   変換テーブル作成：UTF-8用の英数変換（全角から半角へ）
###
###   使い方
###   _maketable_utf8z2h_an
###
sub _maketable_z2h_an {
  my (@from,@to);
  my $i;

  $tbl_z2h_an_exist=1; # テーブルが作成済みかどうかを示すフラグ

  @from=(0xFF10..0xFF19, 0xFF21..0xFF3A, 0xFF41..0xFF5A);  # 全角数字、全角英文字（大文字）、全角英文字（小文字）
  @to  =(0x0030..0x0039, 0x0041..0x005A, 0x0061..0x007A);  # 半角数字、半角英文字（大文字）、半角英文字（小文字）
  foreach $i (@from) { $i=&_32n_8c($i); }
  foreach $i (@to  ) { $i=&_32n_8c($i); }
  @tbl_z2h_an{@from} = @to;

}  ## END of sub _maketable_z2h_an()



###
###   sub ref_to_utf8()
###
###   UTF-8文字列内の文字参照（数値文字参照、文字実体参照）を文字そのものに置換する。
###   未定義もしくは不正な文字参照は置換されずにそのまま残る。
###
sub ref_to_utf8 {
  local(*s) = @_;

  $s =~ s/(&[a-zA-Z0-9]+;|&#[xX][a-fA-F0-9]{1,8};|&#[0-9]{1,7};)/&_ref_to_utf8($1)/geo;

} ## END of sub ref_to_utf8()



###
###   sub _ref_to_utf8()
###
###   文字参照(数値文字参照,文字実体参照)文字列をUTF-8文字(文字そのもの)に変換する。
###
sub _ref_to_utf8 {
  my $s = $_[0];
  my $tmp;
  my $val;
  my $utfchar;

  &_maketable_ref_to_utf8 unless defined $tbl_ref_to_utf8_exist;

  $tmp=$s;
  if($tmp =~ /^&#/o) {  # 数値文字参照形式
    $tmp     =~ tr/&#;//d;
    $val     =  ($tmp =~ /^x/io)  ? hex(lc($tmp))      : $tmp;
    $utfchar =  ($val<=0x10FFFF && vec($bitstr_numref_except,$val,1)!=1) ? &_32n_8c($val) : $s;
  } else {            # 文字実体参照形式
    $tmp     =~ tr/&;//d;
    $utfchar =  defined($tbl_ref_to_utf8{$tmp}) ? $tbl_ref_to_utf8{$tmp} : $s;
  }

  return($utfchar);

} ## END of sub _ref_to_utf8()



###
###   sub _maketable_ref_to_utf8
###
###   文字実体参照(&と;を含まない文字列)から文字そのもの(UTF-8文字)への変換テーブルを作成する。
###   変換対象外の数値文字参照のリスト（ビットストリング）も作成する。
###
sub _maketable_ref_to_utf8 {
  local *IN;
  my    @from;
  my    @to;
  my    @tmp;

  $tbl_ref_to_utf8_exist=1; # テーブルが作成済みかどうかを示すフラグ

  if (!open(IN, "<$mappingent")) {
      &printoutstr("Error: $mappingent does not exist.\n");
      exit(1);
  }

  undef $bitstr_numref_except; # 念のため

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
###   UTF-8文字列内の2,3,4バイト文字を数値文字参照(10進形式, &#XXXXX;)に置換する。
###   1バイト文字は置換されずにそのまま残る。
###
sub utf8_to_ref {
  local(*s) = @_;

  $s =~ s/($utf8_2byte|$utf8_3byte|$utf8_4byte)/'&#'.&_8c_32n($1).';'/geo;

} ## END of sub utf8_to_ref()



### ---------------------------
### 以下、その他のサブルーチン 
### ---------------------------



###
###   sub chop_eol()
###
###   改行文字を除去する。
###
###   chop_eol(\$line)
###   chop_eol(\$line,'utf8')
###
###   除去対象
###   SJIS,JIS,EUC:  0x0D,0x0A
###   UTF-8:         0x0D,0x0A,U+2028,U+2029
###
sub chop_eol {
  local(*s,$icode) = @_;  # 対象文字列（参照渡し）、変換元文字コード（省略可）
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
### UTF-8文字列中のゴミを除去する。
###
sub sanitize_utf8 {
  local(*s) = @_;   # 対象文字列（参照渡し）
  my    @tmp=();

  @tmp = $s =~ /(?:$utf8_1byte|$utf8_2byte|$utf8_3byte|$utf8_4byte)/go;
  $s = join('',@tmp);

}  ## END of sub sanitize_utf8()



###
### EUC文字列中のゴミを除去する。
###
sub sanitize_euc {
  local(*s) = @_;   # 対象文字列（参照渡し）
  my    @tmp=();

  @tmp = $s =~ /(?:$euc_1byte|$euc_hkana|$euc_kan2|$euc_kan3)/go;
  $s = join('',@tmp);

}  ## END of sub sanitize_euc()



###
### sub printoutstr()
###
### 出力関数
###
### 使い方
### printoutstr(" msearch is a search engine script.")
###
### 注意事項
### 半角英数記号以外の文字は引数の文字列に含めないでください。（想定していません。）
###
###
sub printoutstr {
    my $str = $_[0];		# 文字列(引数、値渡し)

	print $str;

} ## END of sub printoutstr



1;
