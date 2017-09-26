% Single History 
clc; clear;
format long g

date_file_path   = 'f:\TradeDateList1.txt' ;
code_file_path   = 'f:\codelist.txt'       ;
export_file_path = 'f:\test\'              ;

export_date_type = 0 ; % 0: stock type; 1: date type;

ret = gm.InitMD('jh3mail@163.com', '159753', MDMode.MD_MODE_NULL);
if ret ~= 0
  disp('Initial Failed !!!');
  disp(ret);
  return;
end

code_list_num  =  textread(code_file_path)       ;
code_list_str  =  textread(code_file_path, '%s') ;
code_total_num =  length(code_list_num)          ;

date_list_str  =  textread(date_file_path, '%s') ;
date_total_num =  length(date_list_str)          ;

%date_type
if(export_date_type) 

  for i=1:date_total_num
  
    today_date  = date_list_str{i};
    today_str   = [today_date(1:4), '-', today_date(5:6), '-',today_date(7:end)];

    if(i==1) 
      yeday_date = today_date ;   %Require The date_file is ALL TradeDate List
      yeday_str  = today_str  ;
    end

    file_name  = strcat(export_file_path, today_date, '.txt') ;
    date_fh    = fopen(file_name, 'w+', 'n', 'UTF-8');
    fprintf(date_fh, 'Code, CodeName, Close, Close%%, Amp%%, TurnOver%%, Amt/w, Amt%%, Vol/w, Vol%%, Flow-Market/y, Open%%, High%%, Low%%, Pre-Close%%, Total-Market/y, Open, High, Low, YeDate, Pre-Close, Pre-Vol/w, Pre-amt/w \n');

    for j=1:code_total_num
    
      if(code_list_num(j) >= 600000) 
        exchange_code = 'SHSE';
        code_str(j) = strcat('SHSE.',code_list_str(j));
      else
        exchange_code = 'SZSE';
        code_str(j) = strcat('SZSE.',code_list_str(j));
      end
    
      instruments = gm.GetInstruments(exchange_code, 1, 0);
      code_name   = instruments(strcmp( instruments.symbol, code_str(j) ),{'sec_name'});
      % file_name  = strcat(code_list_str(j), code_name.sec_name, '.txt') ;
    
      share_bar   = gm.GetShareIndex(code_str{j}, today_str, today_str);
      today_bar   = gm.GetDailyBars (code_str{j}, today_str, today_str);
      yeday_bar   = gm.GetDailyBars (code_str{j}, yeday_str, yeday_str);
      tobar_size  = size(today_bar) ; 
      tobar_exist = tobar_size(1);
    
      if(tobar_exist)
        today_close        = today_bar.close                            ;
        today_open         = today_bar.open                             ;
        today_high         = today_bar.high                             ;
        today_low          = today_bar.low                              ;
        today_vol          = today_bar.volume / 10000                   ; %w
        today_amt          = today_bar.amount / 10000                   ; %w  
        today_flow_vol     = share_bar.flow_a_share / 10000             ; %w        
        today_total_vol    = share_bar.total_share  / 10000             ; %w        
        today_flow_market  = today_close * today_flow_vol  / 10000      ; %y        
        today_total_market = today_close * today_total_vol / 10000      ; %y  
        yeday_close        = yeday_bar.close                            ;
        yeday_vol          = yeday_bar.volume / 10000                   ; %w        
        yeday_amt          = yeday_bar.amount / 10000                   ; %w        
        yeday_pre_close    = yeday_bar.pre_close                        ;
  
        today_close_per    = (today_close / yeday_close - 1 ) * 100     ;
        today_open_per     = (today_open  / yeday_close - 1 ) * 100     ;
        today_high_per     = (today_high  / yeday_close - 1 ) * 100     ;
        today_low_per      = (today_low   / yeday_close - 1 ) * 100     ;
        today_vol_per      = (today_vol   / yeday_vol   - 1 ) * 100     ;
        today_amt_per      = (today_amt   / yeday_amt   - 1 ) * 100     ;
  
        today_amp_per      = abs(today_high_per - today_low_per)        ;
  
        today_turnover     = today_vol / today_flow_vol  * 100          ;
  
        yeday_close_per    = (yeday_close / yeday_pre_close - 1 ) * 100 ;
  
        fprintf(date_fh, '%s, '  , code_list_str{j}   ) ;
        fprintf(date_fh, '%s, '  , code_name.sec_name{1} ) ;
        fprintf(date_fh, '%.2f, ', today_close        ) ;
        fprintf(date_fh, '%.2f, ', today_close_per    ) ;
        fprintf(date_fh, '%.2f, ', today_amp_per      ) ;
        fprintf(date_fh, '%.2f, ', today_turnover     ) ;
        fprintf(date_fh, '%.2f, ', today_amt          ) ;
        fprintf(date_fh, '%.2f, ', today_amt_per      ) ;
        fprintf(date_fh, '%.2f, ', today_vol          ) ;
        fprintf(date_fh, '%.2f, ', today_vol_per      ) ;
        fprintf(date_fh, '%.2f, ', today_flow_market  ) ;
        fprintf(date_fh, '%.2f, ', today_open_per     ) ;
        fprintf(date_fh, '%.2f, ', today_high_per     ) ;
        fprintf(date_fh, '%.2f, ', today_low_per      ) ;
        fprintf(date_fh, '%.2f, ', yeday_close_per    ) ;
        fprintf(date_fh, '%.2f, ', today_total_market ) ;
        fprintf(date_fh, '%.2f, ', today_open         ) ;
        fprintf(date_fh, '%.2f, ', today_high         ) ;
        fprintf(date_fh, '%.2f, ', today_low          ) ;
        fprintf(date_fh, '%s, '  , yeday_date         ) ;
        fprintf(date_fh, '%.2f, ', yeday_close        ) ;
        fprintf(date_fh, '%.2f, ', yeday_vol          ) ;
        fprintf(date_fh, '%.2f\n', yeday_amt          ) ;
      end
         
    end

    yeday_date = today_date;   %Require The date_file is ALL TradeDate List
    yeday_str  = today_str ;   %Require The date_file is ALL TradeDate List

    fclose(date_fh);
  
  end

else 
  for j=1:code_total_num
    if(code_list_num(j) >= 600000) 
      exchange_code = 'SHSE';
      code_str(j) = strcat('SHSE.',code_list_str(j));
    else
      exchange_code = 'SZSE';
      code_str(j) = strcat('SZSE.',code_list_str(j));
    end
    
    instruments = gm.GetInstruments(exchange_code, 1, 0);
    code_name   = instruments(strcmp( instruments.symbol, code_str(j) ),{'sec_name'});
    file_name   = strcat(export_file_path, code_list_str(j), code_name.sec_name{1}, '.txt') ;
    date_fh     = fopen(file_name{1}, 'w+', 'n', 'UTF-8');

    fprintf(date_fh, 'TradeDate, Close, Close%%, Amp%%, TurnOver%%, Amt/w, Amt%%, Vol/w, Vol%%, Flow-Market/y, Open%%, High%%, Low%%, Pre-Close%%, Total-Market/y, Open, High, Low  \n');

    
    for k=1:date_total_num
      today_date  = date_list_str{k};
      today_str   = [today_date(1:4), '-', today_date(5:6), '-',today_date(7:end)];

      if(k==1) 
        yeday_date = today_date ;   %Require The date_file is ALL TradeDate List
        yeday_str  = today_str  ;
      end

      share_bar   = gm.GetShareIndex(code_str{j}, today_str, today_str);
      today_bar   = gm.GetDailyBars (code_str{j}, today_str, today_str);
      yeday_bar   = gm.GetDailyBars (code_str{j}, yeday_str, yeday_str);
      tobar_size  = size(today_bar) ; 
      tobar_exist = tobar_size(1);
    
      if(tobar_exist)
        today_close        = today_bar.close                            ;
        today_open         = today_bar.open                             ;
        today_high         = today_bar.high                             ;
        today_low          = today_bar.low                              ;
        today_vol          = today_bar.volume / 10000                   ; %w
        today_amt          = today_bar.amount / 10000                   ; %w  
        today_flow_vol     = share_bar.flow_a_share / 10000             ; %w        
        today_total_vol    = share_bar.total_share  / 10000             ; %w        
        today_flow_market  = today_close * today_flow_vol  / 10000      ; %y        
        today_total_market = today_close * today_total_vol / 10000      ; %y  
        yeday_close        = yeday_bar.close                            ;
        yeday_vol          = yeday_bar.volume / 10000                   ; %w        
        yeday_amt          = yeday_bar.amount / 10000                   ; %w        
        yeday_pre_close    = yeday_bar.pre_close                        ;
  
        today_close_per    = (today_close / yeday_close - 1 ) * 100     ;
        today_open_per     = (today_open  / yeday_close - 1 ) * 100     ;
        today_high_per     = (today_high  / yeday_close - 1 ) * 100     ;
        today_low_per      = (today_low   / yeday_close - 1 ) * 100     ;
        today_vol_per      = (today_vol   / yeday_vol   - 1 ) * 100     ;
        today_amt_per      = (today_amt   / yeday_amt   - 1 ) * 100     ;
  
        today_amp_per      = abs(today_high_per - today_low_per)        ;
  
        today_turnover     = today_vol / today_flow_vol  * 100          ;
  
        yeday_close_per    = (yeday_close / yeday_pre_close - 1 ) * 100 ;
  
        fprintf(date_fh, '%s, '  , today_date         ) ;
        fprintf(date_fh, '%.2f, ', today_close        ) ;
        fprintf(date_fh, '%.2f, ', today_close_per    ) ;
        fprintf(date_fh, '%.2f, ', today_amp_per      ) ;
        fprintf(date_fh, '%.2f, ', today_turnover     ) ;
        fprintf(date_fh, '%.2f, ', today_amt          ) ;
        fprintf(date_fh, '%.2f, ', today_amt_per      ) ;
        fprintf(date_fh, '%.2f, ', today_vol          ) ;
        fprintf(date_fh, '%.2f, ', today_vol_per      ) ;
        fprintf(date_fh, '%.2f, ', today_flow_market  ) ;
        fprintf(date_fh, '%.2f, ', today_open_per     ) ;
        fprintf(date_fh, '%.2f, ', today_high_per     ) ;
        fprintf(date_fh, '%.2f, ', today_low_per      ) ;
        fprintf(date_fh, '%.2f, ', yeday_close_per    ) ;
        fprintf(date_fh, '%.2f, ', today_total_market ) ;
        fprintf(date_fh, '%.2f, ', today_open         ) ;
        fprintf(date_fh, '%.2f, ', today_high         ) ;
        fprintf(date_fh, '%.2f\n', today_low          ) ;
      end
         
      yeday_date = today_date;   %Require The date_file is ALL TradeDate List
      yeday_str  = today_str ;   %Require The date_file is ALL TradeDate List

    end

    fclose(date_fh);

  end
 
end



