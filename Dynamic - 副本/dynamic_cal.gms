*----------------------------------------------*
*this file is used to calibrate the baseline
*----------------------------------------------*

*simu=0,calibration; simu_s=1,GDP endogenous,simu_s=0,GDP exdogenous˰
simu_s =0;

tax_s(sub_elec)  =1;

re_s=1;
*== switch for learning curve *=on
bata(sub_elec)$(1-switch_learn) =0;

*options solprint=off ;
loop(t$(ord(t) le card(t)),

fact("capital") = fact_supp("capital",t);

tqlabor_s0 = fact_supp("labor",t);
*same population share as base year
tlabor_s0(lm)                           =fact_supp("labor",t)*tlprop("2012",lm);
*change population share
*tlabor_s0(lm)                           =tqlabor_s0*tlprop(t+1,lm);
*ur.lo(lm)=0.85*ur.l(lm);

aeei(s)=AEEI_t(s,t);

xscale = xscale_t(t);

*gprod0$(simu_s ne 0)=gprod_b(t);

rgdp0$(simu_s eq 0)=rgdp_b(t);
ret0(sub_elec)=renewable_scn(t,sub_elec,"BAU");

yelec.fx(cfe)=renewable_scn(t,cfe,"BAU");

*==============parameter for policy shock===============
clim=0;

*tax_s("wind")=0;
*tax_s("solar")=0;
*tax_s("nuclear")=0;
*tax_s("biomass")=0;
*tax_s("hydro")=0;

*re_s=0;

Switch_fee=1;

*==code for learning curve

mkup_t(t,sub_elec)$(ord(t) eq 1) = ((elecout_t(t,sub_elec))/elecout_t("2012",sub_elec))**bata(sub_elec)*mkup_t("2012",sub_elec) ;

mkup_t(t,sub_elec)$(ord(t) gt 1) = ((elecout_t(t-1,sub_elec))/elecout_t("2012",sub_elec))**bata(sub_elec)*mkup_t("2012",sub_elec) ;

*mkup_t(t,sub_elec)=1;
emkup(sub_elec)=mkup_t(t,sub_elec);



$include CHEER.gen


EXECUTE_LOADPOINT 'CHEER_p';
solve CHEER using mcp;

display CHEER.modelstat, CHEER.solvestat,clim,cquota,t;


*-------------
*sore results
*-------------

*stocks

invest_k(t)                  =   grossinvk.l;
kstock(t)$(ord(t)=1)         =   kstock0;

*------------------
*update endowments
*------------------

*=======capita  update  =========
jk(t)$(invest_k(t)/kstock(t) ge zetak)  = kstock(t)/betak*
                                           (betak*zetak-1+sqrt(1+2*betak*(invest_k(t)/kstock(t)-zetak)));
jk(t)$(invest_k(t)/kstock(t) le zetak)  = invest_k(t);

*card(t) returns the number of elements in set t

kstock(t+1)$(ord(t) eq 1)                  =3*jk(t)+(1-deltak)**3*kstock(t);
kstock(t+1)$(ord(t) gt  1)                  =5*jk(t)+(1-deltak)**5*kstock(t);

fact_supp("capital",t+1)                         =rork0*kstock(t+1);

*=======labor  update =========
*need population analysis                   2005-2014年均人口增长率为0.005019 劳动参与率平均为0.58   劳动参与率恒定时，人口增长率与劳动供给增长率相等
fact_supp("labor",t+1) $(ord(t) eq 1)                    =fact_supp("labor",t)  *(1+lgrowth_b(t+1))**3;
fact_supp("labor",t+1) $(ord(t) gt 1)                     =fact_supp("labor",t)  *(1+lgrowth_b(t+1))**5;


*=======energy effiency  update =========

*aeei(i)$(not elec(i))          =  aeei(i)/(1+0.01)**5;
*aeei("fd")       =  aeei("fd")/(1+0.01)**5;
*aeei("elec") =  aeei("elec")/(1+0.01)**5;

AEEI_t(i,t+1)$(ord(t) eq 1)  = AEEI_t(i,t)/(1+0.01)**3;
AEEI_t("fd",t+1)$(ord(t) eq 1)  =  AEEI_t("fd",t)/(1+0.01)**3;
AEEI_t("elec",t+1)$(ord(t) eq 1)  =  AEEI_t("elec",t)/(1+0.01)**3;

AEEI_t(i,t+1)$(ord(t) gt 1)  =  AEEI_t(i,t)/(1+0.01)**5;
AEEI_t("fd",t+1)$(ord(t) gt 1)  =  AEEI_t("fd",t)/(1+0.01)**5;
AEEI_t("elec",t+1)$(ord(t) gt 1)  =  AEEI_t("elec",t)/(1+0.01)**5;

*=======exogenous trade balance  =========
*trade imbalance and stock change phased out at 1% per year
xscale_t(t+1)$(ord(t) eq 1)                                  =0.99**(3*(ord(t)));
xscale_t(t+1)$(ord(t) gt 1)                                   =0.99**(5*(ord(t)));

*=======electricity Output===============
elecout_t(t,sub_elec)=qelec.l(sub_elec);

*=======calibrate the TFP  =========
gprod_b(t)=gprod.l;

*=======calibrate the sub  =========
sub_t(t,sub_elec) =  t_re.l(sub_elec);

*=======calibrate the fixed-factor  =========
sffelec_b(t,sub_elec)=sffelec.l(sub_elec);

*sffelec_bau(t,sub_elec)$(simu_s eq 0)=sffelec.l(sub_elec);

display tqlabor_s0,tlabor_s0,cquota,rgdp.l,gprod.l,emkup,ret0,fact,bata;
);

display fact_supp,AEEI_t,xscale_t,mkup_t,elecout_t,sub_t,gprod_b;
*=============set parameter for repoer====================

*parameter caldata;
*caldata(t,"gprod")=gprod_b(t);
*caldata(t,"subsidy")=sub_t(t,sub_elec);
*caldata(t,"sffelec")=sffelec_b(t,sub_elec);
*execute_unload %DataPath%/trend_TR_output.gdx
*execute_unload "%DataPath%/trend_TR_output.gdx" gprod_b sub_t sffelec_b;
*execute 'gdxxrw.exe caldata.gdx par=caldata rng=A1 ';
PAT(t,"gprod")=gprod_b(t);
subsidy_b(t,sub_elec)=sub_t(t,sub_elec);
execute_unload "%DataPath%/trend_TR_output.gdx" PAT RET1 RET2 sffelec_b   sffelec_BAU subsidy_b subsidy_h
*execute 'gdxxrw.exe trend.gdx par=PAT rng=A1:E18   par=RET1 rng=A26:I35   par=RET2 rng=A37:I46 par=sffelec_b rng=A47 par=sffelec_BAU rng=A58 par=subsidy_b rng=A69';
