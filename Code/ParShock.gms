$title calibration for general Parameters in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) initinalization for parameter on policy shocks

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2017
$offtext

*----------------------------------------------*
*//parameter for no-fossil share shock
*----------------------------------------------*
parameter nf2ff     coefficient from no-fossil to fossil
          GWh2J     coefficient for no-fossil electricity from GWh to Joule
          Y2J       coefficient for fossil fuel from Yuan to Joule
          nfs       shock for no-fossil share;

*//read energy consumption data
          eet("hydro")=28763.84705;
          eet("nuclear")=3304.682288;
          eet("wind")=3462.68846;
          eet("solar")=121.0260044;
          eet("Biomass")=1062.339372;

*// use output to calculate no-fossil share for simplification
          GWh2J=smax(sub_elec,eet(sub_elec)/outputelec0(sub_elec));
          Y2J(fe)=eet(fe)/output0(fe);

          nfs=0.3;
          nf2ff(fe)=Y2J(fe)*(1/(1/nfs-1))/GWh2J;

*----------------------------------------------*
*//parameter for emission shocks 
*----------------------------------------------*
parameter   clim          carbon emission allowance
            clim0         benchmark of carbon emission allowance
            clim_s(i)     sectoral carbon emission allowance
            clim_h        household carbon emission allowance
            clim_a        selected sectors carbon emission allowance
            clim_m(s)     selected sectors carbon emission allowance
            clim_ms       selected sectors carbon emission allowance

            slim          so2 emission limits million ton
            nlim          NOX emission limits million ton;
            ;

            slim         =    0;
            nlim         =    0;

            clim         =    0;
            clim_s(i)    =    0;
            clim_h       =    0;
            clim_a       =    0;
            clim0        =    1;

            clim_m(s)    =    0;
            clim_ms      =    0;

*----------------------------------------------*
*//parameter for technological change 
*----------------------------------------------*
parameter A   aeei;
          A   =    1;

*----------------------------------------------*
*//parameter for simulation options
*----------------------------------------------*
*// simu_s=1,GDP endogenous,simu_s=0,GDP exdogenous
*// tax_s=1,exdogenous renewable tax；tax_s=0，endogenous renewable tax；
*// re_s=1, fixed facor follow supply curve; re_s=1, fixed facor change endogenously to meet renewable target;
parameter simu_s  options for GDP calibration
          tax_s   options for renewable tax
          re_s    options for renewable fixed factor;

          simu_s    =    1;
          tax_s(sub_elec)     =    1;
          re_s      =    1;          