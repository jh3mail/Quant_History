#!/uer/bin/perl
use utf8;
use Excel::Writer::XLSX;
use Encode qw(decode);

sub TextGB {
    my $text = shift;
    return decode( 'gb2312', $text );
}
sub TextUTF {
    my $text = shift;
    return decode( 'utf-8', $text );
}


$txt_date_block_path   = "e:/test/date/txt/block/" ;
$txt_date_single_path  = "f:/test/"                ;
$xlsx_date_path        = "f:/test/xlsx/"           ;

opendir (DIR, $txt_date_single_path) or die "ERROR!!!! Can not open $txt_date_single_path \n";
@txt_date_single_flist = readdir DIR;
splice (@txt_date_single_flist, 0, 2);  

foreach my $txt_date_single_fname (@txt_date_single_flist) {

  $date_single_fname = $txt_date_single_fname;
  $date_block_abs_fname  = $txt_date_block_path.$date_single_fname   ;
  $date_single_abs_fname = $txt_date_single_path.$date_single_fname  ;

  $date_single_fname =~ s/\.txt//g;
  chomp($date_single_fname);
  $xlsx_fname      = $date_single_fname.".xlsx";
  $xlsx_abs_fname  = $xlsx_date_path.$xlsx_fname ;

  my $workbook = Excel::Writer::XLSX->new($xlsx_abs_fname);

  $block_sheet  = $workbook->add_worksheet('block' );
  $single_sheet = $workbook->add_worksheet('single');

  my $format_num6 = $workbook->add_format();
  $format_num6->set_num_format( '000000' );

  my $format_num = $workbook->add_format();
  $format_num->set_num_format( '0.00' );

  my $format_num_color = $workbook->add_format();
  $format_num_color->set_num_format( '[Red]0.00;[Blue]-0.00' );

  my $format_num_color_per = $workbook->add_format();
  $format_num_color_per->set_num_format( '[Red]0.00%;[Blue]-0.00%' );

  my $format_center = $workbook->add_format();
  $format_center->set_align( 'center' );

  $block_sheet->set_column('A:O',10.5);
  $single_sheet->set_column('A:O',10.5);

  open (date_block_fh,"<", $date_block_abs_fname);
  @date_block_lines  = <date_block_fh>;
  close date_block_fh;

  open (date_single_fh,"<", $date_single_abs_fname);
  @date_single_lines  = <date_single_fh>;
  close date_single_fh;

  # BLOCK STOCK
  $row_num = 0;
  foreach my $date_block_cline(@date_block_lines) {
    $date_block_cline =~ s/\s//g;
    @date_block_content = split(/,/,$date_block_cline);

    $col_num = 0;
    foreach my $cell_data(@date_block_content) {
      if($row_num>0 & $col_num==1) {
        $cell_data = TextGB($cell_data) ;
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


  # SINGLE STOCK
  $row_num = 0;
  foreach my $date_single_cline(@date_single_lines) {
    $date_single_cline =~ s/\s//g;
    @date_single_content = split(/,/,$date_single_cline);

    $col_num = 0;
    foreach my $cell_data(@date_single_content) {
      if($row_num>0 & $col_num==1) {
        $cell_data = TextUTF($cell_data) ;
      }

      if($row_num==0) {
        $single_sheet->write($row_num, $col_num, $cell_data, $format_center );
      }
      else{
        if($col_num==0) {
          $single_sheet->write($row_num, $col_num, $cell_data, $format_num6 );
        }
        else {
          if($col_num==3 | $col_num==4 | $col_num==5 | $col_num==6 | $col_num==7 | $col_num==10 | $col_num==12 | $col_num==19 ) { 
            $single_sheet->write($row_num, $col_num, $cell_data, $format_num_color_per );
          }
          elsif($col_num==18 ) {
            $single_sheet->write($row_num, $col_num, $cell_data);
          }
          else {
            $single_sheet->write($row_num, $col_num, $cell_data, $format_num );
          }
        }
      }
      $col_num ++;
    }
    $row_num ++;
  }


}

