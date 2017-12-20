
parameters

pdom         domesitic price of commodities
pamt         armington price of energy commodities(gross of carbon taxes)
pdk          domestic capital prices
pdl          domestic labor prices
pfdem        prices of final demand activities
pff          prices of fixed factors

unem         unemployment rate

pcarbon      shadow price of carbon(2005 Chinese Yuan per ton)
psulfur      shadow price of sulfur

gdp          GDP at factor cots(2005 Chinese 100million Yuan)
gdp_comp     component of gdp (2005 Chinese 100million Yuan)
welfare      consumers income (2005 Chinese 100million Yuan)

fact_supp    factor supplies(2005 Chinese 100million Yuan)
ffact_supp   fixed factor supplies(2005 Chinese 100million Yuan)
fact_dem     factor demands(2005 Chinese 100million Yuan)

demand       demand for armington aggregate commodities(2005 Chinese 100million Yuan)
output       sectoral output quantities(2005 Chinese 100million Yuan)
input        sectoral input quantities(2005 Chinese 100million Yuan)
cons         consumption quantities(2005 Chinese 100million Yuan)
consf        consumption of factors(2005 Chinese 100million Yuan)

output_elec  sectoral output quantities of sub electricity sectors

elecshare    share of different elecutil type(%)
euse         aggregate energy use (million tce)
cfree_elec   non-carbon electric output
carb_elec    carbon-based electric output
carb_emit    carbon emissions (million tonnes)
sulf_emit    sulfur emissions
cqutta       carbon emission quota (million tonnes)
squtta       carbon emission quota (million tonnes)


parameter
invk         sectoral physical capital investment(2005 Chinese 100million Yuan)

invfk        physical capital investment by factors(2005 Chinese 100million Yuan)

kstock       physical capital stock(2005 Chinese 100million Yuan)
invest_k     aggregate gorss physical capital investment(2005 Chinese 100million Yuan)
jk           aggregate net physical capital investment(2005 Chinese 100million Yuan)



scalars

zetak     adjustment threshold of capital stock /0.044/

betak     speed of adjustment of capital stock  /32.2/


gammak    growth rate of pysical capital in initial period /0.10/


deltak    annual rate of physical capital depreciation /0.03/


rk0       benchmark net marginal product of capital

rork0     benchmark net return to physical capital

kstock0   benchmark capital stock


;

parameter AEEI_t    AEEI trend
                xscale_t   xscale trend
                sub_t        subsidy trend

*==parameter for learning curve
parameter elecout_t(t,sub_elec)
                bata(sub_elec)   learning coefficient
                          ;
                bata(sub_elec) = 0;
                bata("wind")  = -0.1265928;
                bata("solar")  = -0.198229;
* to update
*                bata("hydro")  = -0.2315684;
                bata("biomass")  =   (bata("wind")+bata("solar"))/2;

*== switch for learning curve *=on
*                bata(sub_elec) = 0;

*test sensitivity of emissions to fixed factor supply elasticitiy

*eta("coal")=1.0;
*eta("oilgas")=0.5;
*==========save benchmark data ===========

invest_k("2012")=grossinvk.l;
fact_supp("capital","2012")= fact("capital") ;
fact_supp("labor","2012")= tqlabor_s0 ;
AEEI_t(s,"2012") =aeei(s);
xscale_t("2012") = xscale;
mkup_t("2012",sub_elec) =emkup(sub_elec);
sub_t("2012",sub_elec) =  t_re.l(sub_elec);
price_co2_t(t) =0;

elecout_t("2012",sub_elec)=qelec.l(sub_elec);

display fact, fact_supp;

rk0$((gammak+deltak) le zetak)= (gammak+deltak)*fact("capital")/invest_k("2012")-deltak;
rk0$((gammak+deltak) > zetak) =(betak/2*(gammak+deltak-zetak)**2+gammak+deltak)*fact("capital")/invest_k("2012")-deltak;
rork0= rk0+deltak;
kstock0 =fact("capital")/rork0;


*emissions restriction policies,with or without inducement of innovation
parameters
tax_s
cquota
UNEM
Pwage
Pcom;

cquota(t) =0;

*===========================parameter for report ========================

parameter Header Flag determining whether to output header records in output files ;
Header = 1 ;

*----- Declare the output file names

file reportfile / "Output/output.csv" / ;

* ----- Model output options
display "Begin output listing" ;

options limcol=000, limrow=000 ;
*options solprint=off ;
*option solvelink=2;

put reportfile ;
if (Header eq 1, put 'Scenario,year,variable,sector,sector2,subsector,labor,qualifier,value,solvestat' / ; ) ;

*        print control (.pc)     5 Formatted output; Non-numeric output is quoted, and each item is delimited with commas.
reportfile.pc   = 5 ;
*        page width (.pw)
reportfile.pw = 255 ;
*        .nj numeric justification (default 1)
reportfile.nj =   1 ;
*        .nw numeric field width (default 12)
reportfile.nw =  15 ;
*        number of decimals displayed (.nd)
reportfile.nd =   9 ;
*        numeric zero tolerance (.nz)
reportfile.nz =   0 ;
*        numeric zero tolerance (.nz)
reportfile.nr =   0 ;

file screen / 'con' / ;


*=============================== Scenarios block=============================
* S1 = proposed regulation

set
scn          / BAU,ECF,LST,ETS /
bscn(scn) / BAU /
pscn(scn) / ECF,LST,ETS /
*Scenarios with electricity consumption fees
pscna(scn) / ECF/
*Scenarios with lump-sum tax
pscnb(scn) /LST/
*Scenarios with emission trading scheme
pscnc(scn) / ETS/


parameter clim_scn,clim_ms_scn,clim_m_scn,clim_trend_scn,tax_scn,renewable_scn,ecf_scn;
*clim ---------------- switch for national carbon market 0=off,1=accounting; 2= quantity target;3 = intensity target;
*clim_ms ---------------------- switch for sectoral carbon market 0=off,1=exogenous carbon price; 2= quantity target;3 = intensity target;
*clim_m ---------------------- switch for sector in the sectoral carbon market 0=not in, 1 = in;

clim_scn(scn)=0;
clim_scn(pscna)=1;
clim_scn(pscnb)=1;
clim_scn(pscnc)=4;

clim_ms_scn(scn) =0;

clim_m_scn(s,scn)=0;

clim_trend_scn(t,scn) = climit(t,"lower");

tax_scn(scn,sub_elec)=1;
tax_scn(pscn,"wind")=0;
tax_scn(pscn,"solar")=0;

ecf_scn(scn)=1;
ecf_scn(pscna)=1;
ecf_scn(pscnb)=0;
ecf_scn(pscnc)=0;

renewable_scn(t,sub_elec,"BAU")=RET1(t,sub_elec);
renewable_scn(t,sub_elec,pscn)=RET2(t,sub_elec);

parameter
report1    reporting variable
report2    reporting variable
report3    reporting variable
report4    reporting variable
report5
report6
report7
report8
report9
report10
report11
report12

EI1
EI2
EI3
;
