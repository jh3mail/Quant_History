#!/uer/bin/perl
use utf8;
use Encode qw/encode/;

$tradedate_file = "e:/test/TradeDateList1.txt" ;
$proc_data_path = "e:/test/proc/block"        ;
$date_data_path = "e:/test/date/block"        ;

open (date_fh,"<", $tradedate_file);
@date_list=<date_fh>;
close (date_fh);


opendir (DIR, $proc_data_path) or die "ERROR!!!! Can not open $proc_data_path \n";
@proc_filelist = readdir DIR;
splice (@proc_filelist, 0, 2);  


foreach my $trade_date (@date_list) {

  # Replace Space
  $trade_date =~ s/\s//g;
  chomp($trade_date);

  $head_line = "Code, Name, Close %, Close, LastClose, Open %, High %, Low %, Open, High, Low, Vol /w, Vol %, Amt /w, Amt % \n";
  push(@date_line_array, $head_line);
  foreach my $proc_data_fname (@proc_filelist) {
  
    $abs_proc_fname = $proc_data_path."/".$proc_data_fname;
    open (proc_fh,"<", $abs_proc_fname);
    @proc_line_array=<proc_fh>;
    close (proc_fh);
  
    @proc_fname_split = split(/[\s\.]/,$proc_data_fname);
    $code_num  = $proc_fname_split[0];
    $code_name = $proc_fname_split[1];
    $code_num  = $code_num  . " , " ;
  
    foreach my $proc_cline(@proc_line_array){
  
      @proc_line_content = split(/,/,$proc_cline);
  
      $proc_trade_date  = $proc_line_content[0];
      $proc_trade_date  =~ s/\s//g;  # Replace Space

      if($proc_trade_date == $trade_date) {
        $proc_cline  =~ s/$trade_date//g;  # Replace Date
        $date_cline = $code_num . $code_name . $proc_cline; 
        push(@date_line_array, $date_cline);
      }

    }

  }

  # Write File
  $date_fname = $trade_date . ".txt" ;
  $abs_date_fname = $date_data_path."/".$date_fname;
  open (date_file,">", $abs_date_fname);
  print date_file @date_line_array;
  close date_file;
  @date_line_array = ();


}

