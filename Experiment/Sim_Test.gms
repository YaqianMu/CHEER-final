*//file for model test
*updated on 2018/01/16

*== policy shock for static model ==============================================

*== national emission cap
clim=1;
clim0 = 0.9;

*== sectoral emission cap
clim_s(i)=0;
*clim_s("construction")=0.5*Temission0('co2',"construction");
*clim_s("transport")=1*Temission0('co2',"transport");
*clim_s("EII")=0.5*Temission0('co2',"EII");
*clim_s("cm")=0.7*Temission0('co2',"cm");

*== switch for emission cap
clim_h=0;
*clim_h=0.9*Temission0('co2',"fd");


*== multisectoral emission cap
clim_a=0;
*clim0 = 0.5;

*== national emission cap with selected sectors
clim_ms=0;
*clim_m(s) = 0;
clim_m(cm) = 0;
*pco2_ms.fx(i)$(not cm(i) )=0;
*clim_m("fd") = 0;
*clim0 =0.8;
*tclim.fx=clim0*temission2("co2");

*== FIT
*pelec.fx(sub_elec)$wsb(sub_elec)=1.1*costelec0(sub_elec);

*== subsidy
*subelec0(sub_elec)=subelec0(sub_elec);

*== technilical change
*emkup(sub_elec)$wsb(sub_elec)=emkup(sub_elec)*0.1;

*yelec.fx("wind")  = 20;

*tax_s("wind")=0;

*ret0("wind") =1+(outputelec0("wind")+200)/outputelec0("wind");
*clim=4;
*Switch_fee=0;

*aeei(i)=0.5;

tx0(i)=tx0(i);


*inv_elec.fx("wind")=(1*ConEff("TWH2GW","wind")*InvCost("wind")+sum(i,elecinv0(i,"wind")))/sum(i,elecinv0(i,"wind"));
*yelec.fx("wind")=(outputelec0("wind")+500)/outputelec0("wind");
 
*tlabor_s0("labsk")=tlabor_s0("labsk")+1000;
*tlabor_s0("labUn")=tlabor_s0("labUn")+1000;

CHEER.iterlim =100000;

$include CHEER.gen

*EXECUTE_LOADPOINT 'CHEER_p';
solve CHEER using mcp;
*abort$(ABS(Smax(i,y.l(i)-1)) GT 1.E-4)
*            "*** CHEER benchmark does not calibrate";

CHEER.Savepoint = 1;

display CHEER.modelstat, CHEER.solvestat,ur.l,clim;

parameter check;
check= sum(cfe,qelec.l(cfe)*GWh2J)/
        (sum(cfe,qelec.l(cfe)*GWh2J)
        +sum(fe,qdout.l(fe)*Y2J(fe)))
                                ;
*check = sum(sub_elec,eet(sub_elec))/
*       (sum(sub_elec,eet(sub_elec))
*        +sum(fe,eet(fe)))
display check;



