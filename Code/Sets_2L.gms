$title Sets for China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
$offlisting
$offsymxref

*----------------------------------------------*
*==sets for sectors
*----------------------------------------------*
SETS
    s  all labels in SAM
      /Elec
       Coal
       Oilgas
       Roil
       Gas
       Agri
       mine
       Food
       Paper
       Chem
       CM
       IST
       NFM
       EII
       OM
       Air
       Tran
       Serv

       fd

       Labor "Labour"
       capital "Physical capital"

       Household,GOVERNMENT,INVESTMENT,export,import
       /

    i(s) commodities in SAM table(produced goods represented by sector name
      /Elec
       Coal
       Oilgas
       Roil
       Gas
       Agri
       mine
       Food
       Paper
       Chem
       CM
       IST
       NFM
       EII
       OM
       Air
       Tran
       Serv
       /

*// subset for specific sector groups 
    e(i)    energy supply sectors
      /Elec,Coal,Roil,Gas/

    fe(i)   fuel energy supply sectors
      /Coal,roil,gas/

    x(i)    exhaustible resource sectors
      /agri,coal,Oilgas,Mine,gas/

    elec(i) electrici power sector
      /elec/

    ist(i)  ist sector
      /ist/

    cm(i)   sectors selected in carbon market
      /roil,elec,Paper, Chem,CM,IST,NFM,Air/

    agrmine(i)  agriculture and non-energy mine
      /agri,mine/

    mfg(i)      manufacturing
      /Food,Paper,Chem,CM,IST,NFM,EII,OM/

    Trans(i)    transport
      /Tran/

    Serv(i)     services
      /serv/

alias (i,j),(e,ee),(fe,fee);
*----------------------------------------------*
*==sets for factors and final demands
*----------------------------------------------*
sets
    f(s)    primary factors
    /Labor  "Labour"
    capital "Physical capital"/

    lab(f)  labor 
    /labor/

    fd(s)   final demands 
    /Household,GOVERNMENT,INVESTMENT,export,import/

    h(fd)   households 
    /Household,GOVERNMENT/
    ;

*----------------------------------------------*
*==sets for dynamic process
*----------------------------------------------*
sets
    yr      time in years   /2005*2050/
    t(yr)   time in 5 years periods   /2012,2015,2020,2025,2030/
    baseyear(yr) baseyear   /2012/
    year years within each time period  /1*5/
;

*----------------------------------------------*
*==sets for disaggregated electricity sector
*----------------------------------------------*
set      sub_elec       /T_D, Coal_Power, Gas_Power, Oil_Power, Nuclear, Hydro, Wind, Solar, Biomass/
         TD(sub_elec)   transport and distribution /T_D/
         gen(sub_elec)  /Coal_Power, Gas_Power, Oil_Power, Nuclear, Hydro, Wind, Solar, Biomass/
         bse(sub_elec)  base load electricity /Coal_Power, Gas_Power, Oil_Power, Nuclear, Hydro, Biomass/
         ffe(sub_elec)  fossil fuel electricity /Coal_Power, Gas_Power, Oil_Power/
         cge(sub_elec)  fossil fuel electricity /Coal_Power, Gas_Power/
         cfe(sub_elec)  carbon free electricity /Nuclear, Hydro, Wind, Solar, Biomass/
         hnb(sub_elec)  hydro and nuclear biomass electricity /Nuclear, Hydro,Biomass/
         wse(sub_elec)  wind and solar /Wind, Solar/
         hne(sub_elec)  hydro and nuclear electricity /Nuclear, Hydro/
         wsb(sub_elec)  wind and solar biomass/Wind, Solar, Biomass/;

alias   (sub_elec,sub_elecc),(gen,genn);

*----------------------------------------------*
*==sets for disaggregated IST sector
*----------------------------------------------*
set     sub_ist /BOF,EAF/

alias   (sub_ist,sub_istt);

*----------------------------------------------*
*==sets for Backstop technologies
*----------------------------------------------*
set bt  /ngcc,ngcap,igcap,BOFA,EAFA,DRP/
    bt_elec(bt) /ngcc,ngcap,igcap/
    ngcap(bt_elec) /ngcap/
    bt_ist(bt)  /BOFA,EAFA/;

*----------------------------------------------*
*==sets for labor market
*----------------------------------------------*
set lmo original labor type /
        L1              LabMUUL
        L2              LabMUES
        L3              LabMUMS
        L4              LabMUHS
        L5              LabMUJC
        L6              LabMURC
        L7              LabMUPG
        L8              LabMRUL
        L9              LabMRES
        L10             LabMRMS
        L11             LabMRHS
        L12             LabMRJC
        L13             LabMRRC
        L14             LabMRPG
        L15             LabFUUL
        L16             LabFUES
        L17             LabFUMS
        L18             LabFUHS
        L19             LabFUJC
        L20             LabFURC
        L21             LabFUPG
        L22             LabFRUL
        L23             LabFRES
        L24             LabFRMS
        L25             LabFRHS
        L26             LabFRJC
        L27             LabFRRC
        L28             LabFRPG/;

*== change here to do other labor aggregation
set lm   aggregared labor type
       /LabSk
        LabUn/;

alias (lm,lmm);

display lm;

set maplmo (lmo,lm) /
              L1      .       LabUn
              L2      .       LabUn
              L3      .       LabUn
              L4      .       LabUn
              L5      .       LabSk
              L6      .       LabSk
              L7      .       LabSk
              L8      .       LabUn
              L9      .       LabUn
              L10     .       LabUn
              L11     .       LabUn
              L12     .       LabSk
              L13     .       LabSk
              L14     .       LabSk
              L15     .       LabUn
              L16     .       LabUn
              L17     .       LabUn
              L18     .       LabUn
              L19     .       LabSk
              L20     .       LabSk
              L21     .       LabSk
              L22     .       LabUn
              L23     .       LabUn
              L24     .       LabUn
              L25     .       LabSk
              L26     .       LabSk
              L27     .       LabSk
              L28     .       LabSk
                /;
set ll(lm) low level labor type 
      /LabUn/;

set hl(lm) high level labor type ;

      hl(lm)$(not ll(lm)) = 1;

display ll,hl;
