#!/uer/bin/perl
use utf8;
use Excel::Writer::XLSX;
use Encode qw(decode);

sub T {
    my $text = shift;
    return decode( 'gb2312', $text );
}

$txt_block_data_path   = "e:/test/date/txt/block/"     ;
$txt_single_data_path  = "e:/test/date/txt/single/"    ;
$xlsx_data_path        = "e:/test/date/xlsx/"          ;

opendir (DIR, $txt_block_data_path) or die "ERROR!!!! Can not open $txt_block_data_path \n";
@txt_block_filelist = readdir DIR;
splice (@txt_block_filelist, 0, 2);  

foreach my $txt_block_fn (@txt_block_filelist) {

  $date_fn = $txt_block_fn;
  $date_block_abs_fn  = $txt_block_data_path.$date_fn   ;
  $date_single_abs_fn = $txt_single_data_path.$date_fn  ;

  $txt_block_fn =~ s/\.txt//g;
  chomp($txt_block_fn);
  $xlsx_fn      = $txt_block_fn.".xlsx";
  $xlsx_abs_fn  = $xlsx_data_path.$xlsx_fn ;

  my $workbook = Excel::Writer::XLSX->new($xlsx_abs_fn);

  $block_sheet  = $workbook->add_worksheet('block' );
  $single_sheet = $workbook->add_worksheet('single');

  my $format_txt = $workbook->add_format();
  $format_txt->set_num_format( '000000' );

  my $format_num = $workbook->add_format();
  $format_num->set_num_format( '0.00' );

  my $format_num_color = $workbook->add_format();
  $format_num_color->set_num_format( '[Red]0.00;[Blue]-0.00' );

  $block_sheet->set_column('A:O',10.5);
  $single_sheet->set_column('A:O',10.5);

  open (data_block_fh,"<", $date_block_abs_fn);
  @data_block_lines  = <data_block_fh>;
  close data_block_fh;

  open (data_single_fh,"<", $date_single_abs_fn);
  @data_single_lines  = <data_single_fh>;
  close data_single_fh;

  $row_num = 0;
  foreach my $data_block_cline(@data_block_lines) {
    $data_block_cline =~ s/\s//g;
    @data_block_content = split(/,/,$data_block_cline);

    $col_num = 0;
    foreach my $cell_data(@data_block_content) {
      if($row_num>0 & $col_num==1) {
        $cell_data = T($cell_data) ;
      }
      if($col_num==0) {
        $block_sheet->write($row_num, $col_num, $cell_data, $format_txt );
      }
      else {
        if($col_num==2 | $col_num==5 | $col_num==6 | $col_num==7) {
          $block_sheet->write($row_num, $col_num, $cell_data, $format_num_color );
        }
        else {
          $block_sheet->write($row_num, $col_num, $cell_data, $format_num );
        }
      }
      $col_num ++;
    }
    $row_num ++;
  }

  $row_num = 0;
  foreach my $data_single_cline(@data_single_lines) {
    $data_single_cline =~ s/\s//g;
    @data_single_content = split(/,/,$data_single_cline);

    $col_num = 0;
    foreach my $cell_data(@data_single_content) {
      if($row_num>0 & $col_num==1) {
        $cell_data = T($cell_data) ;
      }
      if($col_num==0) {
        $single_sheet->write($row_num, $col_num, $cell_data, $format_txt );
      }
      else {
        if($col_num==2 | $col_num==5 | $col_num==6 | $col_num==7) {
          $single_sheet->write($row_num, $col_num, $cell_data, $format_num_color );
        }
        else {
          $single_sheet->write($row_num, $col_num, $cell_data, $format_num );
        }
      }
      $col_num ++;
    }
    $row_num ++;
  }


}

