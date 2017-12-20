$Title Proto_Global_CGE
$comment *
$Oninline
$inlinecom { }
$eolcom !
* --------------------------------------------------------------------
* --
* -- Trade Integrated Global Energy and Resources - TIGER Model
* --
* --            David Roland-Holst
* --            UC Berkeley
* --
* --------------------------------------------------------------------
* --            September, 2011
* --------------------------------------------------------------------
*  Dynamic Calibration -- BaU Scenario
*  ------------------------------------
*  Based on GTAP Version 8.0
* --------------------------------------------------------------------

$ if not set indata $set indata EBI15x5Land
$ if not set target $set target EBI15x5_SSA

set allsim / Baseline, B2, B3, B4/ ;
set sim(allsim) / Baseline, B2/ ;
*set sim(allsim) / Baseline/ ;

* -- Scenarios
* Baseline - Consensus growth rates (including regional ag productivity growth assumptions)
* B2- Baseline with stochastic ag productivity growth rates
* B3- Baseline with stochastic land-feed substitution
* B4- Baseline with stochastic ag prod. and land-feed substitution

set
     FScen/1*22/
     fuelin/BaseGlobal,     BaseAsia,     ModSave,     HIghSave/
;
* --

* ----- Output files

file csv           / 'output/%target%.csv' /
scalar ifCSV       / 1 / ;
scalar ifCSVhdr    / 1 / ;

file csv_LandOnly       /'output/%target%_LandOnly.csv' /
scalar ifCSV_LandOnly   /1/;
scalar ifCSVhdr_LandOnly        /1/;

file tab           / 'output/%target%Tab.csv' /
scalar iftab       / 0 / ;
scalar ifTabhdr    / 1 / ;

file wtfcsv        / 'output/WTF%target%.csv' /
scalar ifWTF       / 1 / ;
scalar ifWTFhdr    / 1 / ;

file samcsv        / 'output/SAM%target%.csv' /
scalar ifSAM       / 0 / ;
scalar ifSAMhdr    / 0 / ;

file PROTOout           / 'output/%target%out.dat' /
scalar ifPROTO       / 1 / ;
PROTOout.ap = 0 ;

file yelascsv      / 'output/Yelas%target%.csv' /
scalar ifYelas     / 1 / ;
scalar ifYelashdr  / 1 / ;

file savecal       / 'reftrn.gms' /

file debug         / 'output/debug.csv' / ;
scalar ifDebug     / 1 / ;

if (ifDebug,
   put debug ;
   put "Exporter,Importer,Sector,Variable,Year,Value" / ;

   debug.pc   = 5 ;
   debug.pw = 255 ;
   debug.nj =   1 ;
   debug.nw =  15 ;
   debug.nd =   9 ;
   debug.nz =   0 ;
   debug.nr =   0 ;
) ;

* --------------------------------------------------------------------
*
*  Define the time horizon -- 2007 is the base
*
* --------------------------------------------------------------------

 Sets
   t       Time framework       / 2007*2030 /
   tt(t)   Simulation periods   / 2008*2030 /
   t0(t)   Base year            / 2007 /
   tr(t)   Reporting years      / 2010, 2015, 2020, 2025, 2030 /
   term(t)   Terminal year      / 2030 /
   ;

 Parameters
   ybase
   gap      Step size
   gapT(t)
   work
   iter3    Iteration counter
   stp      Normalization of productivity sources
   gconv    Convergent Growth Rate /.093/
   csp      Speed of convergence /1/
        fz              foreign savings max share of gdp /.15/
         ;
stp = 0 ;
gapt(t) = 1 ;
*gconv = .05 ;

 parameter years(t) ; years(t) = 2006 + ord(t) ;

* ----- Scale options

scalar bscale Model scale      / 1e-06 / ;
scalar rscale Output scale     / 1e+06 / ;
scalar pscale Population scale / 1e-03 / ;
scalar ivb Verbose Reporting /0/ ;

scalar bconv convergent upper growth rate /6/ ;
* ----- Input data files
$ if not set target $set target Data/EBI22x5

$include "data/%indata%.dat"
$include "data/%indata%prm.dat"
$include "data/%indata%scn.dat"
$include "data/oilin.dat"

set

fdp(i) /
Crops
Livestk
OtherAg
/

agfd(i) /
Crops
Livestk
OtherAg
MtDairy
ProcFd
/

nagfd(i)

kagfd(k) /
Crops
Livestk
OtherAg
MtDairy
ProcFd
/

set ifuel(i) Fuel sectors /
Coal
Petro
NatGas
/

set kfuel(k) Fuel commodities /
Coal
Petro
NatGas
/

set ek(k) Energy commodities /
Coal
Petro
NatGas
ElGasDist
/

ne(i) nonenergy sectors
nkfuel(k) nonfuel commodities
inoil(i)
knoil(k)
;

ne(i) = yes ;
ne(i)$e(i) = no ;

nkfuel(k) = yes ;
nkfuel(k)$kfuel(k) = no ;
alias (nkfuel,nnkfuel) ;

inoil(i) = yes ;
inoil(i)$i("petro") = no ;
knoil(k) = yes ;
knoil(k)$k("petro") = no ;
alias (knoil,kknoil) ;

nagfd(i) = yes ;
nagfd(i)$agfd(i) = no ;

parameter
feff(fscen,t,r) Oil Use efficiency
oeff(allsim,t,r) Oil efficieny by country and scenario
;

feff(fscen,t,r) = 1 ;
*display feff ;

parameter egro (r) /
chi             7.53
/ ;
egro(r) = .01*egro(r) ;

parameter esub0(r,i) ;
esub0(r,i) = 0 ;

* Modify land supply elasticities
leps0("bra") = 0.082 ;
leps0("usa") = 0.029 ;
leps0("e28") = 0.025 ;
leps0("row") = 0.25 ;
*omegatl1(r) = 0.2 ;
*omegatl2(r,lt) = 0.5 ;

omegatl1("usa") = 0.02 ;
omegatl1("e28") = 0.02 ;
omegatl1("bra") = 0.20 ;
omegatl1("chi") = 0.20 ;
omegatl1("row") = 0.10 ;

omegatl2("usa",lt) = 0.75 ;
omegatl2("e28",lt) = 0.75 ;
omegatl2("bra",lt) = 0.75 ;
omegatl2("chi",lt) = 0.25 ;
omegatl2("row",lt) = 0.25 ;

* Define agricultural TFP growth rates
parameter g00(r,i) ;
   g00("usa", fdp) = 1+0.0224 ;
   g00("bra", fdp) = 1+0.0403 ;
   g00("e28", fdp) = 1+0.0198 ;
   g00("chi", fdp) = 1+0.0305 ;
   g00("row", fdp) = 1+0.0184 ;

* ----- Cut the shocked years into small pieces for convergence reasons
parameter niter(t, allsim) Iteration steps ; niter(t,sim) = 1 ;
*niter(t,"fdi")$(years(t) gt 2027) = 4 ;


* ----- Specification flags
*
*  Set ArmFlag to 1 to have agent specific Armington decomposition
*      ArmFlag to 0 to have aggregate Armington specification
*

scalar ArmFlag / 0 / ;

*  Set CalFlag to 1 for dynamic calibration
*      CalFlag to 0 for pre-calibrated trends

scalar CalFlag  / 1 / ;


*  Set KProdFlag to 1 to determine endogenously K productivity
*      KProdFlag to 0 for exogenous K productivity

scalar KProdFlag  / 0 / ;

*  Set CompFlag to 1 to delete capital accumulation equations
*      CompFlag to 0 to include capital accumulation equations

scalar CompFlag / 0 / ;

*  Set KFlowFlag to 0 for exogenous capital flows
*      KFlowFlag to 1 for endogenous capital flows

scalar KFlowFlag / 0 / ;

*  Consumer demand system flag
*  ifELES eq 1 Use the ELES system
*  ifELES eq 2 Use the LES system
*  ifELES eq 3 Use the AIDADS system

scalar ifELES consumer demand system flag / 1 / ;

* Sensitivity analysis flag, set to 1 if using Gaussian Quadrature sensitivity analysis
*                                                        set to 0 if using other experiments/simulations

scalar SensFlag /1/ ;

* ---- Market structure flags

*      0 -- CRTS and perfect competition, includes constant markup
*      1 -- IRTS and contestable markets

parameter marketFlag(r,i) Type of market structure ;
marketFlag(r,i) = 0 ;

parameter AIDSFlag(r,i) Flag to determine import specification ;
AIDSFlag(r,i) = 0 ;

*  AIDS flag set to 1 to implement AIDS in import demand
*  AIDS flag set to 0 for nested CES implementation

parameter AIDSFlag(r,i) Flag to determine import specification ;
AIDSFlag(r,i) = 0 ;

*  Wage bargaining flag, set to 1 to have endogenous wage distribution
*                        set to 0 to have exogenoug relative wages

parameter wageBarg(r,l,i) Wage bargaining flag ;
wageBarg(r,l,i) = 0 ;


* ---- Gaussian Quadrature Sensitivity Analysis set-up
set
sen/1*60/
isen(sen)/1*5/
;
* Create an alias for every parameter you want to loop over (creates joint distributions)
alias (sen,ssen), (isen,iisen,iiisen) ;

$include "data/Sens_dat.gms"

sets
   v(v1)   Useful vintage       / Old, New /
   old(v1) Old capital vintage  / Old /
   new(v1) New capital vintage
   vc(v1)  Calibration vintage  / New /
   agfd(i)
   ;
new(v1)  = not Old(v1) ;

parameter
a00(r,i,j,v)
eta00(r,k,h)
axe0(r,i)
giter(r) iterative scaling factor
mut0(r,k,h,t)
;
eta00(r,k,h) = eta0(r,k,h) ;
mut0(r,k,h,t) = 0 ;

$include "model/decl.gms"
$include "model/stats.gms"
xct0(r,k,h,t) = 0 ;
xapt0(r,i,j,t) = 0 ;

pland0(r,lt) = 1 ;

agfd(i) = ag(i) + fdp(i) ;
ik(i) = not(ag(i)+fdp(i)) ;
ink(i)  = not ik(i) ;

$include "model/cal.gms"
$include "model/init.gms"
*$goto outofhere

$include "model/model.gms"

scalar ifLoad / 0 / ;

sets
   rlib(r)     Liberalizing region
   plib(r)     Beneficiary region
   ilib(i)     Liberalizing sector
;

scalar reduction  Percent size of reduction / 100 / ;
scalar finalLev ;
finalLev = 1 - 0.01*reduction ;

rlib(r)$(mapr("wlt",r)) = yes ;
plib(r)$(mapr("wlt",r)) = yes ;
ilib(i) = yes ;

TarT(r,rp,i,t)  = tar0(r,rp,i) ;
etaxT(r,rp,i,t) = etax0(r,rp,i) ;

options limcol=0, limrow=0 ;
options solprint=off ;

* ---- Loop over the number of separate scenarios
loop(sim,

isen(sen) = no ;
isen("1") = yes ;

if(ord(sim) gt 1,
isen(sen)$(ord(sen) le 5) = yes ;
);

loop((isen,iisen,iiisen),       !Start sensitivity loop

*   g(r,i) = 1 ;
   axe0(r,i) = axe(r,i) ;
   ybase = 2004 ;
   gap  = 1 ;

calflag$(ord(sim) ne 1) = 0 ;

   if (CalFlag eq 0,
*     Load the reference trends
$include "model/cal.gms"
$include "model/init.gms"
$batinclude "model/savtrn.gms" 1 reftrn 0
   ) ;

*  ----- Solve dynamically

   loop(t$(years(t) le 2010),

*     Load the standard looping statements here

      if (years(t) eq 2008,
         etap(r,i) = 0 ;
      ) ;

     if (ord(t) gt 1,

$include "model/recal.gms"
$include "model/iterLoop.gms"

*                       giter(r) = g(r,"oil") ;

  for(iter3=1 to niter(t, sim) by 1,

*## B2 -  Stochastic Agricultural Productivity Growth Rates
                if(ord(sim) eq 2,
                alphacde.fx("usa",k,h) = 1.2 ;
                        g("usa",fdp) = (hernodes(isen,'5')*0.01) + g00("usa",fdp) ;
                        g("bra",fdp) = (hernodes(isen,'5')*0.01) + g00("bra",fdp) ;
                        g("chi",fdp) = (hernodes(isen,'5')*0.01) + g00("chi",fdp) ;
                        g("row",fdp) = (hernodes(isen,'5')*0.01) + g00("row",fdp) ;
                        sigmaf("usa",cr,v1) = (hernodes(iisen,'5')*.1) + 0.40 ;
                        sigmaf("bra",cr,v1) = (hernodes(iisen,'5')*.1) + 0.60 ;
                        sigmaf("usa",lv,v1) = (hernodes(iisen,'5')*.1) + 0.40 ;
                        sigmaf("bra",lv,v1) = (hernodes(iisen,'5')*.1) + 0.60 ;
                        leps0("usa") = (hernodes(iiisen,'5')*0.01) + 0.029 ;
                        leps0("bra") = (hernodes(iiisen,'5')*0.01) + 0.082 ;
        ) ;

            solve comp using mcp ;

            put screen ;
            put //, "End of solver: Sim - ", sim.tl, "  Year - ", t.tl, " Iteration - ", iter3:2:0, " of ", niter(t, sim):2:0, " iterations" // ;
            putclose ;

            if (comp.solvestat ne 1 or comp.modelstat gt 2,
               Abort$(1) "Model did not solve, aborting..."
            ) ;
  display savft, savfbar.l ;
        ) ;
) ;

*     ---- End of current period, calulate end of period stats and produce reports

display npt.l, ts.l, td.l, omegatl2, pLand.l, aLnd, ptLand.l, tLand.l ;
*display npr.l, ws.l, wd.l, omegatw2, ws1.l, pWater.l, aWat, ptWater.l, tWater.l ;

$include "model/postsim.gms"
        if (tr(t),
                if (SensFlag eq 1,
$include "model/report_MC.gms" ;
$include "model/report_MC_LandOnly.gms" ;
                        else
$include "model/report.gms" ;
                                );
        ) ;
        if (term(t),
*$include "model/wtf.gms"
$include "model/sam.gms"
        ) ;
        if (calflag eq 1,
xct0(r,k,h,t) = xc.l(r,k,h) ;
xapt0(r,i,j,t) = xap.l(r,i,j) ;
mut0(r,k,h,t) = mu.l(r,k,h) ;
        );
   ) ;

display savft, savfbar.l ;

*  ----- End of current dynamic simulation

*  ----- Save trends if this is a BAU simulation
        if (calflag eq 1,
$batinclude "model/savtrn.gms" 0 reftrn 0
$batinclude "model/gdxrw.gms" 0 bau
        ) ;             !End Dynamic Loop
        ) ;             !End Sensitivity Loop
) ;                             !End Simulation Loop
$label outofhere
