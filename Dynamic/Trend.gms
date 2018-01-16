$title  trend parameters in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read trend  data
2) calibration of benchmark


Revision Logs:
**0317 加入GDP趋势，劳动力趋势
**0131 trend parameters include:
  1)GDP
  2)population
  3)installed capacity of renewable energy
  4)supply of fixed factor
  5)Feed-in-tarrif
  6)carbon price
  7)markup factors
  8)TFP
  9)aeei

Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*

*----------------------------------------------*
*// Read trend data
*----------------------------------------------*
Parameter   PAT(*,*)            parameters with trend
            RET1(*,*)           renewable electricity trend
            RET2(*,*)           renewable electricity trend
            sffelec_b(*,*)      benchmark fixed factor trend
            sffelec_bau(*,*)    benchmark fixed factor trend
            subsidy_b(*,*)      benchmark renewable tax trend
            subsidy_h(*,*)      higher renewable tax trend
            price_co2_t(*)      exogenous carbon price trend;

$GDXIN      %DataPath%\trend_TR_output.gdx
$LOAD       PAT RET1 RET2 sffelec_b sffelec_bau subsidy_b subsidy_h
$GDXIN

*============================macro parameter with trend=========================
Parameter   rgdp_b(t)      real gdp pathway
            rgdp0          benchmark real gdp
            gprod_b(*)     productivity index pathway
            gprod0         benchmark productivity index
            lgrowth_b(t)   labor growth rate
            aeei(s)        auto energy effiency index;

            rgdp_b(t)       =   PAT(t,"rgdp");
            rgdp0           =   rgdp_b("2012");

            gprod_b(t)      =   PAT(t,"gprod");
*            gprod0=gprod_b("2012");
            gprod0          =   1;
            lgrowth_b(t)    =   PAT(t,"lgrowth");

            price_co2_t(t)  =   PAT(t,"PCO2");

            aeei(i)         =   1;
            aeei("fd")      =   1;

*============================elec parameter with trend=========================
Parameter   ret0                    renewable electricity trend
            ret_b(t,*)              benchmark renewable electricity trend
            mkup_t(t,sub_elec)      markup factor trend
            sffelec0                benchmark fixed factor trend
            sffelec1                benchmark fixed factor trend in BAU;

            mkup_t(t,sub_elec)    =   1;

            sffelec0(sub_elec)    =   1;
            sffelec1(sub_elec)    =   1;

*//base Scenario
            ret_b(t,sub_elec)     =   RET1(t,sub_elec);

*//high share scenatio
*           ret_b(t,sub_elec)     =   RET2(t,sub_elec);

            ret0(sub_elec)        =   ret_b("2012",sub_elec);

display     aeei,PAT,rgdp0,ret0,ret_b;

*============================labor parameter with trend=========================
parameter   tlprop(t,lm)    share of each labor in total supply;

            tlprop("2012",lm)     =   tlabor_s0(lm)/tqlabor_s0;

*============================emission parameter with trend=========================
parameter   clim_t        trend of carbon emission allowance
            price_co2     exogenous carbon price
            ;
$ontext
* before 1218,excluding cement production emission
table climit(*,*)     input of emission cap
        lower           higher
2012    1               1
2015    0.902952812     0.873965611
2016    0.872743734     0.835588509
2017    0.843545328     0.798896602
2018    0.81532378      0.763815889
2019    0.788046408     0.730275622
2020    0.761681625     0.698208157
2021    0.731415826     0.667352749
2022    0.702352653     0.637860911
2023    0.67444432      0.609672385
2024    0.647644938     0.582729575
2025    0.621910443     0.556977428
2026    0.597198521     0.532363328
2027    0.57346854      0.50883698
2028    0.550681481     0.486350315
2029    0.528799877     0.464857388
2030    0.50778775      0.444314281
;
$offtext
*2015        0.898062425        0.869232219

table       climit(*,*)     input of emission cap
            lower           higher
2012        1                   1
2015        1.155953355         1.155953355
2016        0.866447064        0.829559907
2017        0.83594469        0.791698264
2018        0.806516119        0.755564651
2019        0.778123552        0.721080199
2020        0.750730515        0.688169639
2021        0.720899863        0.657757856
2022        0.692254547        0.628690039
2023        0.664747467        0.600906795
2024        0.638333395        0.574351355
2025        0.612968899        0.548969461
2026        0.588612274        0.524709251
2027        0.565223471        0.501521155
2028        0.542764034        0.479357793
2029        0.521197034        0.458173881
2030        0.50048701        0.437926134
;

            clim_t(t)    =    climit(t,"lower");
            price_co2    =    0;

display     climit,clim_t,Temission1,Temission2;

