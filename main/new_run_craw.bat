@echo off
if "%1" == "h" goto begin 
:begin 
set /a zq_info=1
cls
@TITLE caiji_new_v1
@ECHO                           ┌───────────┐                  
@ECHO ┏━━━━━━━━━━━━┥    请不要关闭本窗口! ┝━━━━━━━━━━━━┓
@ECHO ┃   ━━━━━━━━━   └───────────┘   ━━━━━━━━━   ┃
@ECHO ┃   ━━━━━━━━━       每5-10分钟抓取一次         ━━━━━━━━━   ┃
@ECHO ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
@ECHO.
@ECHO.
echo 抓取第1次
ruby run_craw.rb
:zhuaqu
set /a zq_info =%zq_info%+1
set /a sleep_time = %random%%%600+300
ping -n %sleep_time% 127.1>nul
echo 抓取第%zq_info%次
ruby run_craw.rb
REM echo %sleep_time%
goto zhuaqu