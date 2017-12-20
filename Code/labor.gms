$title labor market  in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read electricity data
2) calibration of benchmark
3) covert from value unit (Yuan) to physical unit (person)

Revision Logs:
*20161204, update: extend the types of labor to 28 by gender by region by education

Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*

*----------------------------------------------*
*==Read labor data
*----------------------------------------------*
parameter
                lvat      aggregated labor compensation value  in  10 Thousand Yuan
                lqat      aggregated labor quantity in 10 Thousand person
                lwat      aggregated labor wage  Yuan per  person
                labordata(*,*) original wage and umemployment data

*$GDXIN %DataPath%\labor_%ExpPath%_%datagg%.gdx
$GDXIN %DataPath%\labor_%ExpPath%_oilgas.gdx
$LOAD lvat  lqat lwat labordata
$GDXIN

Parameter labor_v0(*,*)  sectoral labor costs value by labor type in billion  yuan;
Parameter labor_q0(*,*)  sectoral labor quantity by labor type;
Parameter labor_w0(*,*)  sectoral labor wage value by labor type in billion yuan per thousand person;
parameter labordata(*,*);

*=== transfer unit from 10 Thousand Yuan to billion yuan
labor_v0(lmo,i)=lvat(lmo,i)/100000;

labor_v0(lm,i)=sum(lmo$(maplmo (lmo,lm)),labor_v0(lmo,i));

*=== transfer unit from 10 Thousand people to thousand people
labor_q0(lmo,i)=lqat(lmo,i)*10;

labor_q0(lm,i) = sum(lmo$maplmo(lmo,lm),labor_q0(lmo,i))  ;

labor_w0(lm,i)$labor_q0(lm,i) =labor_v0(lm,i)/labor_q0(lm,i);
labor_w0(lm,i)$(labor_q0(lm,i) eq 0) = 0.001;

*----------------------------------------------*
*==calibration of benchmark
*----------------------------------------------*

*parameter tlprop(*,*)  the proportion of total labor supply by year;
parameter bwage(*)    the average wage of labor by type from micro data in yuan per people;
parameter bur(*)     the benchmark unemployment rate ;


bwage(lmo) =   labordata('wage',lmo);
bwage(lm)  =   sum(lmo$maplmo(lmo,lm),labordata('wage',lmo)*sum(i,labor_q0(lmo,i)))/sum(i,labor_q0(lm,i));

bur(lmo)  =   labordata('ul',lmo);
bur(lm)  =   1-sum(i,labor_q0(lm,i))/sum(lmo$maplmo(lmo,lm),sum(i,labor_q0(lmo,i))/(1-bur(lmo)));

DISPLAY lvat,  lqat, lwat, labordata, labor_v0,labor_q0,labor_w0,bur,bwage;

*== set relative wage factor

parameter fwage_s(lm,i)  factor of average wage among sectors  ;
parameter awage_e(lm)  average wage among education in billion yuan per thousand person;

awage_e(lm) = sum(i,labor_w0(lm,i)*labor_q0(lm,i))/sum(i,labor_q0(lm,i));

fwage_s(lm,i) =  labor_w0(lm,i)/awage_e(lm);


display fwage_s,awage_e;


parameter tlabor_q0(lm)   total employment by sub_labor
          tqlabor0       total employment ;

tlabor_q0(lm)=sum(i,labor_q0(lm,i));
tqlabor0=sum(lm,tlabor_q0(lm));

parameter tlabor_v0(lm)   total employment value by sub_labor
          tvlabor0       total employment value;

tlabor_v0(lm)=sum(i,labor_v0(lm,i));
tvlabor0=sum(lm,tlabor_v0(lm));


display labor_q0,tlabor_q0,tqlabor0,labor_v0,tlabor_v0,tvlabor0;



parameter ur0      the benchmark unemployment rate
          tlabor_s0(lm)   total labor supply by sub_labor
          tqlabor_s0      total labor supply;

ur0(lm)=bur(lm);
ur0(lm)$(1-Switch_um)=0;

tlabor_s0(lm)=(tlabor_v0(lm)/(1-ur0(lm)));
tqlabor_s0=sum(lm,tlabor_s0(lm));

tlabor_s0(lm)=(tlabor_q0(lm)/(1-ur0(lm)));
tqlabor_s0=sum(lm,tlabor_s0(lm));

*shock �Ͷ��������ṹ�ı仯
*tlabor_s0(lm)=tqlabor_s0*tlprop("2030",lm);

display ur0,tlabor_s0,tqlabor_s0;
