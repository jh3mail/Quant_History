% History TimeChart
clc; clear;
format long g

date = '2017-09-13' ;


time_begin = strcat(date, ' 09:30:00') ;
time_end   = strcat(date, ' 15:00:00') ;

ret = gm.InitMD('jh3mail@163.com', '159753', MDMode.MD_MODE_NULL);
if ret ~= 0
  disp('Initial Failed !!!');
  disp(ret);
  return;
end

code_file_path = 'f:\codelist.txt';
code_list_num  =  textread(code_file_path);
code_list_str  =  textread(code_file_path, '%s');
code_total_num =  length(code_list_num) ;

figure;
for i=1:code_total_num

  if(code_list_num(i) >= 600000) 
    exchange_code = 'SHSE';
    code_str(i) = strcat('SHSE.',code_list_str(i));
  else
    exchange_code = 'SZSE';
    code_str(i) = strcat('SZSE.',code_list_str(i));
  end

  instruments = gm.GetInstruments(exchange_code, 1, 0);
  code_name   = instruments(strcmp( instruments.symbol, code_str(i) ),{'sec_name'});
  title_name  = strcat(code_list_str(i), '-', code_name.sec_name) ;

  daily_bars  = gm.GetDailyBars(code_str{i},date,date);
  minute_bars = gm.GetBars(code_str{i}, 60, time_begin, time_end);
  
  minute_bars_price   = minute_bars.close;
  minute_bars_percent = (minute_bars_price/daily_bars.pre_close - 1) * 100;

  minute_bars_vol     = minute_bars.volume/10000;
  minute_bars_amt     = minute_bars.amount/10000/100;

  switch(i) 
    case 1 
            left   = 0.03;
            bottom = 0.70;
    case 2 
            left   = 0.37;
            bottom = 0.70;
    case 3 
            left   = 0.70;
            bottom = 0.70;
    case 4 
            left   = 0.03;
            bottom = 0.37;
    case 5 
            left   = 0.37;
            bottom = 0.37;
    case 6 
            left   = 0.70;
            bottom = 0.37;
    case 7 
            left   = 0.03;
            bottom = 0.03;
    case 8 
            left   = 0.37;
            bottom = 0.03;
    case 9 
            left   = 0.70;
            bottom = 0.03;
    otherwise
  end
  
  set(gcf,'Position',get(0,'ScreenSize'))
  
  amount_position = [left, bottom     , 0.28, 0.08];
  subplot('Position',amount_position)
  bar(minute_bars_amt,0.2)
  axis([0,240,0,max(minute_bars_amt)*1.1]) 
  set(gca,'XTick',[0,30,60,90,120,150,180,210,240])
  grid on
  
  price_position  = [left, bottom+0.1, 0.28, 0.17];
  subplot('Position',price_position)
  plot(minute_bars_percent)
  title(title_name)
  axis([0,240,-max(abs(minute_bars_percent))-0.5,max(abs(minute_bars_percent))+0.5])
  set(gca,'XTick',[0,30,60,90,120,150,180,210,240])
  grid on


     
end


