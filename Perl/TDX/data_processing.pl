#!/uer/bin/perl
use utf8;
use Encode qw/encode/;

$org_data_path  = "e:/test/org/single"     ;
$proc_data_path = "e:/test/proc/single"    ;

opendir (DIR, $org_data_path) or die "ERROR!!!! Can not open $org_data_path \n";
@filelist = readdir DIR;
splice (@filelist, 0, 2);  

foreach my $org_fname (@filelist) {

  $abs_org_fname = $org_data_path."/".$org_fname;

  open (org_fh,"<", $abs_org_fname);
  @line_list=<org_fh>;
  close (org_fh);

  @proc_line_array = ();
  $index = 0;

  foreach my $org_cline(@line_list){

    $index++;

    chomp($org_cline);

    if($index==1) {

      @line_content = split(/ /,$org_cline);

      $code_name = $line_content[1];


      if($#line_content >=4) {
        for my $line_index (2..($#line_content-2)) {
          $code_name .= $line_content[$line_index];
        }
      }

      next;
    }
    
    if($index==2) {
      $proc_cline = "TradeDate, Close %, Close, LastClose, Open %, High %, Low %, Open, High, Low, Vol /w, Vol %, Amt /w, Amt % \n";
      push(@proc_line_array, $proc_cline);
      next;
    }

    if( $org_cline =~ /:/ ) {
      last;
    }
    
    @line_content = split(/,/,$org_cline);

    $today_trade_date  = $line_content[0]                  ;
    $today_open_price  = $line_content[1]                  ;
    $today_high_price  = $line_content[2]                  ;
    $today_low_price   = $line_content[3]                  ;
    $today_close_price = $line_content[4]                  ;
    $today_vol_number  = $line_content[5] / 10000          ;
    $today_amt_number  = $line_content[6] / 10000          ;
    $today_vol_number  = sprintf "%.3f", $today_vol_number ;
    $today_amt_number  = sprintf "%.3f", $today_amt_number ;

    if($index==3) {
      $yeday_trade_date    = $today_trade_date    ;
      $yeday_open_price    = $today_open_price    ;
      $yeday_high_price    = $today_high_price    ;
      $yeday_low_price     = $today_low_price     ;
      $yeday_close_price   = $today_open_price    ;
      $yeday_vol_number    = $today_vol_number    ;
      $yeday_amt_number    = $today_amt_number    ;
      $yeday_open_percent  = $today_open_percent  ;
      $yeday_high_percent  = $today_high_percent  ;
      $yeday_low_percent   = $today_low_percent   ;
      $yeday_close_percent = $today_close_percent ;
      $yeday_vol_percent   = $today_vol_percent   ;
      $yeday_amt_percent   = $today_amt_percent   ;
    }

    if($yeday_close_price == 0) {
      $today_open_percent  = 999999                                                    ;
      $today_high_percent  = 999999                                                    ;
      $today_low_percent   = 999999                                                    ;
      $today_close_percent = 999999                                                    ;
    }
    else {
      $today_open_percent  = ( ( $today_open_price  / $yeday_close_price ) - 1 ) * 100 ;
      $today_high_percent  = ( ( $today_high_price  / $yeday_close_price ) - 1 ) * 100 ;
      $today_low_percent   = ( ( $today_low_price   / $yeday_close_price ) - 1 ) * 100 ;
      $today_close_percent = ( ( $today_close_price / $yeday_close_price ) - 1 ) * 100 ;
    }
    if($yeday_vol_number == 0) {
      $today_vol_percent   = 999999                                                    ;
    }
    else {
      $today_vol_percent   =   $today_vol_number / $yeday_vol_number                   ;
    }
    if($yeday_amt_number == 0) {
      $today_amt_percent   = 999999                                                    ;
    }
    else {
      $today_amt_percent   =   $today_amt_number / $yeday_amt_number                   ;
    }

    $today_open_percent  = sprintf "%.2f", $today_open_percent  ;
    $today_high_percent  = sprintf "%.2f", $today_high_percent  ;
    $today_low_percent   = sprintf "%.2f", $today_low_percent   ;
    $today_close_percent = sprintf "%.2f", $today_close_percent ;
    $today_vol_percent   = sprintf "%.3f", $today_vol_percent   ; 
    $today_amt_percent   = sprintf "%.3f", $today_amt_percent   ; 

    $proc_cline = $today_trade_date   . " , " . $today_close_percent . " , " . $today_close_price . " , " . $yeday_close_price  . " , " .
                  $today_open_percent . " , " . $today_high_percent  . " , " . $today_low_percent . " , " . $today_open_price   . " , " .
                  $today_high_price   . " , " . $today_low_price     . " , " . $today_vol_number  . " , " . $today_vol_percent  . " , " .
                  $today_amt_number   . " , " . $today_amt_percent   . " \n" ;

    push(@proc_line_array, $proc_cline);

    $yeday_trade_date    = $today_trade_date    ;
    $yeday_open_price    = $today_open_price    ;
    $yeday_high_price    = $today_high_price    ;
    $yeday_low_price     = $today_low_price     ;
    $yeday_close_price   = $today_close_price   ;
    $yeday_vol_number    = $today_vol_number    ;
    $yeday_amt_number    = $today_amt_number    ;
    $yeday_open_percent  = $today_open_percent  ;
    $yeday_high_percent  = $today_high_percent  ;
    $yeday_low_percent   = $today_low_percent   ;
    $yeday_close_percent = $today_close_percent ;
    $yeday_vol_percent   = $today_vol_percent   ;
    $yeday_amt_percent   = $today_amt_percent   ;

  }

  # print @proc_line_array;

  # Write File
  $proc_fname = $org_fname . " " . $code_name ;
  $proc_fname =~ s/\.txt//g;
  $proc_fname = $proc_fname . ".txt" ;
  $abs_proc_fname = $proc_data_path."/".$proc_fname;
  # print $abs_proc_fname;
  open (proc_file,">", $abs_proc_fname);
  print proc_file @proc_line_array;
  close proc_file;

}



