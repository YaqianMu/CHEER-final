*----------------------------------------------*
*1206, to build the basic model for employment analysis
*0723, add backstop technologies for elec and ist
*1128，modify CHEER based on EPPA
*----------------------------------------------*
parameter      A                      /1/         ;

parameter simu_s,tax_s,re_s;
*simu_s=1,GDP endogenous,simu_s=0,GDP exdogenous
*tax_s=1,exdogenous renewable tax；tax_s=0，endogenous renewable tax；

simu_s=1;
tax_s(sub_elec)=1;
re_s=1;

parameter          phi        percentage target of permits energy;
parameter          pflag        flag for electricity permits             /0/         ;


$ONTEXT
$Model:CHEER

$Sectors:
y(i)                   !activity level for domestic production
yv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i)) !activity level for vintage production
yv_elec(sub_elec)$(switch_vk and v_i("elec"))
yv_ist(sub_ist)$(switch_vk and v_i("ist"))

consum                 !activity level for aggregate consumption
invest                 !activity level for aggregate physical capital investment
welf                   !activity level for aggregate welfare

yelec(sub_elec)                                            !Activity level for electricity production
ybt_elec(bt_elec)$Switch_bt(bt_elec)                       !Activity level for backstop electricity production
bres_ngcap$(Switch_bt("ngcap"))                            !Convert pbf_ngcc to pbf_ngcap
BT2T(bt_elec)$Switch_bt(bt_elec)                           !Convert Pbt to pelec

yist(sub_ist)                   !Activity level for ist production
ybt_ist(bt)$Switch_bt(bt)       !Activity level for backstop ist technologies

l_s(lm)                         !Activity level for labor allocation
l_a(i)$(not elec(i) and not ist(i))                          !Activity level for labor aggregation
l_elec(sub_elec)
l_IST(sub_IST)

$Commodities:
py(i)                  !domestic price inex for goods

pelec(sub_elec)        !domestic price inex for subelec
pbt(bt_elec)$Switch_bt(bt_elec)                       !domestic price inex for backstop electricity production
*pelec(sub_elec)$(not bse(sub_elec))         !domestic price inex for subelec
*pe_base                !domestic price inex for baseload elec

pist(sub_ist)           !domestic price inex for subist

pls(lm)                  !domestic price index for labor demand
pl(i)$(not elec(i) and not ist(i))                    !domestic price index for aggregated labor demand
pl_ELEC(sub_elec)
pl_IST(sub_ist)
plo(lm,i)$(labor_q0(lm,i))                 !domestic price index for labor demand

pk                     !domestic price index for captial
pkv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i))                 !domestic price index for vintage captial
pkv_elec(sub_elec)$(switch_vk and v_i("elec"))               !domestic price index for vintage captial
pkv_ist(sub_ist)$(switch_vk and v_i("ist"))                 !domestic price index for vintage captial

pffact(i)$ffact0(i)                                !domestic price index for fixed factors
pffelec(sub_elec)$ffelec0(sub_elec)                !domestic price index for fixed factors in electric sector
pbf(bt_elec)$Switch_bt(bt_elec)                    !domestic price index for fixed factors in backstop sector

pcons                  !price index for aggregate consumption
pinv                   !price index for aggregate physical capital investment
pu                     !price index for utility

pco2$clim              !shadow value of carbon all sectors covered
pco2_a$clim_a          !shadow value of carbon selected sectors covered
pco2_s(i)$clim_s(i)    !shadow value of carbon sector by sector
pco2_h$clim_h          !shadow value of carbon for household sector

*pco2_m(s)$clim_m(s)              !shadow value of carbon all sectors covered
pco2_ms$clim_ms

Pers$pflag             ! Price for permits of electricity generation

$consumers:
ra                     !income level for representative agent

$auxiliary:
sff(x)$ffact0(x)                            !side constraint modelling supply of fixed factor
sffelec(sub_elec)$ffelec0(sub_elec)         !side constraint modelling supply of fixed factors

ur(lm)$Switch_um                   !unemployment rate

t_re(sub_elec)$cfe(sub_elec)       !FIT for renewable energy

ecf$Switch_fee           !additional electricity consumption fees to cover renewable subsidy

rgdp                     !real gdp
gprod                    !productivity index
gprod2(lm)$Switch_um     !productivity index to identify unemployment rate


tclim$clim               ! carbon limit all sectors
tclim_a$clim_a           ! carbon limit selected sectors
tclim_ms$clim_ms         ! carbon limit selected sectors


*// electriricy sector
*// the nested structure of electricity is to be checked
$prod:y(i)$elec(i)   s:esub_gt   b(s):0 a(b):esub_pe     c(a):esub_be
        o:py(i)                               q:output0(i)                p:(1-ecf0)  a:ra  N:ecf$Switch_fee
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)     p:(costelec0(sub_elec))
        i:pelec(sub_elec)$cge(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  c:
        i:pelec("OIL_Power")                  q:outputelec0("OIL_Power")  p:(costelec0("OIL_Power"))  a:
        i:pelec(sub_elec)$hnb(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  a:
        i:pelec(sub_elec)$wse(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  a:
*        i:pbt(bt)$Switch_bt(bt)               q:1    b:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:esub_elec("IT","T_D")      
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))       q:intelec0(i,sub_elec)
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec"))
        i:py(fe)                 q:(intelec0(fe,sub_elec)*aeei("elec"))
        i:pl_elec(sub_elec)      q:(lelec0(sub_elec)*emkup(sub_elec))                     
        i:pk                     q:kelec0(sub_elec)


*       Production of fossile fuel electricity
$prod:yelec(sub_elec)$ffe(sub_elec) s:esub_elec("IT",sub_elec)   kle(s):esub_elec("KLE",sub_elec) kl(kle):esub_elec("KL",sub_elec) l(kl):esub_l("l")   ene(kle):esub_elec("E",sub_elec) roil(ene):0 coal(ene):0 gas(ene):0
        o:pelec(sub_elec)                q:(outputelec0(sub_elec))                 p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))               q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:py(elec)                       q:(intelec0(elec,sub_elec)*aeei("elec")*emkup(sub_elec))
        i:pl_elec(sub_elec)              q:(lelec0(sub_elec)*emkup(sub_elec))                      kl:
        i:pk                             q:(kelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:py(fe)$intelec0(fe,sub_elec)   q:(intelec0(fe,sub_elec)*aeei("elec")*emkup(sub_elec))                            fe.tl:
        i:pco2#(fe)$clim                 q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_s("elec")#(fe)$clim_s("elec")         q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm("elec"))        q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        I:Pers$pflag                                 Q:((phi/(1-phi))*outputelec0(sub_elec))
        i:pco2_ms#(fe)$clim_m("elec")                q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:


*       Production of hybro and nuclear biomass electricity      va2 from wang ke
$prod:yelec(sub_elec)$hnb(sub_elec)  s:esub_elec("NR",sub_elec) a:esub_elec("IT",sub_elec) va(a):esub_elec("KL",sub_elec) l(va):esub_l("l")
        o:pelec(sub_elec)$hne(sub_elec)  q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        o:pelec(sub_elec)$wsb(sub_elec)  q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        o:Pers$pflag                     Q:(1*(outputelec0(sub_elec)))
        i:py(i)$(not elec(i))                 q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              a:
        i:py(elec)                  q:(intelec0(elec,sub_elec)*emkup(sub_elec))                                              a:
        i:pl_elec(sub_elec)                  q:(lelec0(sub_elec)*emkup(sub_elec))                      va:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1


*       Production of wind, solar  electricity      va2 from wang ke
$prod:yelec(sub_elec)$wse(sub_elec) s:esub_elec("NR",sub_elec) b:esub_elec("IT",sub_elec) va(b):esub_elec("KL",sub_elec) l(va):esub_l("l")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))               p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))  a:ra  N:t_re(sub_elec)
        O:Pers$pflag             Q:(1*(outputelec0(sub_elec)))
        i:py(i)$(not elec(i))    q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              b:
        i:py(elec)               q:(intelec0(elec,sub_elec)*emkup(sub_elec))   b:
        i:pl_elec(sub_elec)      q:(lelec0(sub_elec)*emkup(sub_elec))                     va:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1

*     Production of backstop technologices
$prod:ybt_elec(bt_elec)$Switch_bt(bt_elec)  s:0 sa(s):esub_bt("NR",bt_elec)   gva(sa):esub_bt("gva",bt_elec)  gl(gva):esub_l("l") sva(sa):esub_bt("SVA",bt_elec)  sl(sva):esub_l("l") roil(sa):0 coal(sa):0 gas(sa):0
    o:pbt(bt_elec)                               q:1
    i:pbf(bt_elec)                               q:(bsin("ffa",bt_elec)*bmkup(bt_elec))                    sa:
    i:plo(lm,"elec")$ll(lm)                      q:(bslin("gen",lm,bt_elec)*bmkup(bt_elec))                gl:
    i:plo(lm,"elec")$hl(lm)                      q:(bslin("gen",lm,bt_elec)*bmkup(bt_elec))                gl:
    i:pk                                         q:(bsin("k",bt_elec)*bmkup(bt_elec))                      gva:
    i:plo(lm,"elec")$ll(lm)                      q:(bslin("CCS",lm,bt_elec)*bmkup(bt_elec))                sl:
    i:plo(lm,"elec")$hl(lm)                      q:(bslin("CCS",lm,bt_elec)*bmkup(bt_elec))                sl:
    i:pk                                         q:(bsin("kseq",bt_elec)*bmkup(bt_elec))                   sva:
    i:py(fe)                                     q:(bsin(fe,bt_elec)*aeei("elec")*bmkup(bt_elec))                                                                fe.tl:
    i:pco2#(fe)$clim                             q:(emissionelec0("co2","e",fe,bt_elec)*aeei("elec")*bmkup(bt_elec)*(1-bsin("frseq",bt_elec)))     p:1e-5             fe.tl:
    i:pco2_s("elec")#(fe)$clim_s("elec")         q:(emissionelec0("co2","e",fe,bt_elec)*aeei("elec")*bmkup(bt_elec)*(1-bsin("frseq",bt_elec)))     p:1e-5             fe.tl:
    i:pco2_a#(fe)$(clim_a and cm("elec"))        q:(emissionelec0("co2","e",fe,bt_elec)*aeei("elec")*bmkup(bt_elec)*(1-bsin("frseq",bt_elec)))     p:1e-5             fe.tl:
    i:pco2_ms#(fe)$clim_m("elec")                q:(emissionelec0("co2","e",fe,bt_elec)*aeei("elec")*bmkup(bt_elec)*(1-bsin("frseq",bt_elec)))      p:1e-5            fe.tl:

$prod:bres_ngcap$(Switch_bt("ngcap"))
        o:pbf("ngcap")                                          q:bres("ngcc")
        i:pbf("ngcc")                                           q:bres("ngcc")

$prod:BT2T("ngcc")$(Switch_bt("ngcc"))
        o:pelec("Gas_Power")                                    q:1
        i:pbt("ngcc")                                           q:1

$prod:BT2T("ngcap")$(Switch_bt("ngcap"))
        o:pelec("Gas_Power")                                    q:1
        i:pbt("ngcap")                                          q:1

$prod:BT2T("igcap")$(Switch_bt("igcap"))
        o:pelec("coal_Power")                                   q:1
        i:pbt("igcap")                                          q:1                

*// IST sector
$prod:y(i)$(switch_ist and ist(i))   s:0
        o:py(i)                  q:output0(i)       
        i:pist(sub_ist)          q:(output0(i)*ts_ist(sub_ist))     

$prod:yist(sub_ist)$switch_ist s:esub("IT","Ist")  kle:esub("KLE","Ist") kl(kle):esub("KL","Ist") e(kle):esub("E","Ist")  ne(e):esub("NELE","Ist")   coal(ne):0 roil(ne):0 gas(ne):0
        o:pist(sub_ist)          q:(outputist0(sub_ist))              p:(1-taxist0(sub_ist))  a:ra  t:taxist0(sub_ist)
        i:py(i)$(not e(i))       q:intist0(i,sub_ist)
        i:py(elec)               q:(intist0(elec,sub_ist)*aeei("IST"))  e:
        i:py(fe)                 q:(intist0(fe,sub_ist)*aeei("IST"))    fe.tl:
        i:pl_IST(sub_IST)        q:lIST0(sub_IST)           kl:
        i:pk                     q:kist0(sub_ist)           kl:
        i:pco2#(fe)$clim         q:(emissionist0('co2','e',fe,sub_ist)*aeei("IST"))      p:1e-5             
        i:pco2_s(i)#(fe)$clim_s("IST")         q:(emissionist0('co2','e',fe,sub_ist)*aeei("IST"))      p:1e-5             
        i:pco2_a#(fe)$(clim_a and cm("IST"))         q:(emissionist0('co2','e',fe,sub_ist)*aeei("IST"))      p:1e-5             
        i:pco2_ms#(fe)$clim_m("IST")        q:(emissionist0('co2','e',fe,sub_ist)*aeei("IST"))      p:1e-5             

$prod:ybt_ist("BOFA")$Switch_bt("BOFA") s:0
        o:pist("BOF")            q:(outputist0("BOF"))              p:(1-taxist0("BOF"))  a:ra  t:taxist0("BOF")
        i:py(i)$(not e(i))       q:(intist0(i,"BOF")*bsrist(i,"BOFA"))
        i:py(elec)               q:(intist0(elec,"BOF")*aeei("IST")*bsrist(elec,"BOFA"))
        i:py(fe)                 q:(intist0(fe,"BOF")*aeei("IST")*bsrist(fe,"BOFA"))
        i:plo(lm,"ist")$ll(lm)   q:(laborist0(lm,"BOF")*bsrist(lm,"BOFA"))        p:labor_w0(lm,"ist")           
        i:plo(lm,"ist")$hl(lm)   q:(laborist0(lm,"BOF")*bsrist(lm,"BOFA"))        p:labor_w0(lm,"ist")           
        i:pk                     q:(kist0("BOF")*bsrist("capital","BOFA"))
        i:pco2#(fe)$clim         q:(emissionist0('co2','e',fe,"BOF")*aeei("IST")*bsrist(fe,"BOFA"))      p:1e-5             
        i:pco2_s(i)#(fe)$clim_s("IST")         q:(emissionist0('co2','e',fe,"BOF")*aeei("IST")*bsrist(fe,"BOFA"))      p:1e-5             
        i:pco2_a#(fe)$(clim_a and cm("IST"))         q:(emissionist0('co2','e',fe,"BOF")*aeei("IST")*bsrist(fe,"BOFA"))      p:1e-5             
        i:pco2_ms#(fe)$clim_m("IST")        q:(emissionist0('co2','e',fe,"BOF")*aeei("IST")*bsrist(fe,"BOFA"))      p:1e-5             

$prod:ybt_ist("EAFA")$Switch_bt("EAFA") s:0
        o:pist("EAF")            q:(outputist0("EAF"))              p:(1-taxist0("EAF"))  a:ra  t:taxist0("EAF")
        i:py(i)$(not e(i))       q:(intist0(i,"EAF")*bsrist(i,"EAFA"))
        i:py(elec)               q:(intist0(elec,"EAF")*aeei("IST")*bsrist(elec,"EAFA"))
        i:py(fe)                 q:(intist0(fe,"EAF")*aeei("IST")*bsrist(fe,"EAFA"))
        i:plo(lm,"ist")$ll(lm)    q:(laborist0(lm,"EAF")*bsrist(lm,"EAFA"))        p:labor_w0(lm,"ist")           
        i:plo(lm,"ist")$hl(lm)    q:(laborist0(lm,"EAF")*bsrist(lm,"EAFA"))        p:labor_w0(lm,"ist")           
        i:pk                     q:(kist0("EAF")*bsrist("capital","EAFA"))
        i:pco2#(fe)$clim         q:(emissionist0('co2','e',fe,"EAF")*aeei("IST")*bsrist(fe,"EAFA"))      p:1e-5             
        i:pco2_s(i)#(fe)$clim_s("IST")         q:(emissionist0('co2','e',fe,"EAF")*aeei("IST")*bsrist(fe,"EAFA"))      p:1e-5             
        i:pco2_a#(fe)$(clim_a and cm("IST"))         q:(emissionist0('co2','e',fe,"EAF")*aeei("IST")*bsrist(fe,"EAFA"))      p:1e-5             
        i:pco2_ms#(fe)$clim_m("IST")        q:(emissionist0('co2','e',fe,"EAF")*aeei("IST")*bsrist(fe,"EAFA"))      p:1e-5             

*// other sectors
$prod:y(i)$(not elec(i) and not ist(i)) s:esub("TOP",i) a:esub("NR",i) b(a):esub("IT",i)  kle(b):esub("KLE",i) kl(kle):esub("KL",i) e(kle):esub("E",i)  ne(e):esub("NELE",i)   coal(ne):0 roil(ne):0 gas(ne):0
        o:py(i)                             q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:pco2$clim                         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_s(i)$clim_s(i)               q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_a$(clim_a and cm(i))         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_ms$clim_m(i)                 q:(emission0("co2","e","process",i))      p:1e-5
        i:pffact(i)$ffact0(i)               q:ffact0(i)                                           a:
        i:py(j)$(not e(j))                  q:int0(j,i)                                         b:
        i:py(fe)                            q:(int0(fe,i)*r_feed(fe,i))                     b:
        i:pk                                q:fact0("capital",i)                              kl:
        i:pl(i)                             q:fact0("labor",i)                                kl:
        i:py(elec)                          q:(int0(elec,i)*aeei(i))                          e:
        i:py(fe)                            q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))                            fe.tl:
        i:pco2#(fe)$clim                    q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)          q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm(i))    q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_ms#(fe)$clim_m(i)            q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:

*// sectoral allocation of labor 
$prod:l_s(lm)       t:esub_LabDist(lm)
         o:plo(lm,i)      q:labor_q0(lm,i)       p:labor_w0(lm,i)
         i:pls(lm)       q:tlabor_q0(lm)        p:awage_e(lm)

*// aggregation of labor 
$prod:l_a(i)$(not elec(i) and not ist(i))       l:esub_l("l")
         o:pl(i)                              q:fact0("labor",i)            
         i:plo(lm,i)$ll(lm)                   q:labor_q0(lm,i)              p:labor_w0(lm,i)             l:
         i:plo(lm,i)$hl(lm)                   q:labor_q0(lm,i)              p:labor_w0(lm,i)             l:

$prod:l_elec(sub_elec)       l:esub_l("l")
         o:pl_elec(sub_elec)                  q:(lelec0(sub_elec)*emkup(sub_elec))           
         i:plo(lm,"elec")$ll(lm)              q:(laborelec0(lm,sub_elec)*emkup(sub_elec))      p:labor_w0(lm,"elec")    l:              
         i:plo(lm,"elec")$hl(lm)              q:(laborelec0(lm,sub_elec)*emkup(sub_elec))      p:labor_w0(lm,"elec")    l:           

$prod:l_IST(sub_IST)       l:esub_l("l")
         o:pl_IST(sub_IST)                    q:lIST0(sub_IST)           
         i:plo(lm,"ist")$ll(lm)               q:laborist0(lm,sub_ist)        p:labor_w0(lm,"ist")      l:     
         i:plo(lm,"ist")$hl(lm)               q:laborist0(lm,sub_ist)        p:labor_w0(lm,"ist")      l:

*//        consumption of goods and factors    based on EPPA
$prod:consum   s:esub_c("TOP")  a:esub_c("NE") e:esub_c("E") roil(e):0 coal(e):0 gas(e):0
         o:pcons                  q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:py(i)$(not e(i))       q:cons0(i)                a:
         i:py(i)$(elec(i))        q:(cons0(i)*aeei("fd"))                e:
         i:py(fe)                 q:(cons0(fe)*aeei("fd"))                 fe.tl:
         i:pco2#(fe)$clim         q:(emission0("co2","e",fe,"fd")*aeei("fd"))      p:1e-5             fe.tl:
         i:pco2_h#(fe)$clim_h     q:(emission0("co2","e",fe,"fd")*aeei("fd"))      p:1e-5             fe.tl:
         i:pco2_ms#(fe)$clim_m("fd")        q:(emission0("co2","e",fe,"fd")*aeei("fd"))     p:1e-5             fe.tl:

*//        aggregate capital investment
$prod:invest   s:esub_inv
         o:pinv            q:(sum(i,inv0(i)))
         i:py(i)            q:inv0(i)

*//        welfare          Ke Wang=1, EPPA=0
$prod:welf    s:esub_wf
         o:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))
         i:pcons              q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:pinv               q:(sum(i,inv0(i))+sum(f,invf0(f)))

*// vintage production
$prod:yv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i)) s:0 coal:0 roil:0 gas:0
        o:py(i)                             q:1                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:pco2$clim                         q:(emission0("co2","e","process",i)/output0(i))      p:1e-5
        i:pco2_s(i)$clim_s(i)               q:(emission0("co2","e","process",i)/output0(i))      p:1e-5
        i:pco2_a$(clim_a and cm(i))         q:(emission0("co2","e","process",i)/output0(i))      p:1e-5
        i:pco2_ms$clim_m(i)                 q:(emission0("co2","e","process",i)/output0(i))      p:1e-5
        i:pffact(i)$ffact0(i)               q:V_ff(i)                                           
        i:py(j)$(not e(j))                  q:V_int(j,i)                                         
        i:py(fe)                            q:(V_int(fe,i)*r_feed(fe,i))                                       
        i:pkv(i)                            q:V_K(i)                            
        i:pl(i)                             q:V_L(i)                              
        i:py(elec)                          q:V_int(elec,i)                          
        i:py(fe)                            q:(V_int(fe,i)*(1-r_feed(fe,i)))                            fe.tl:
        i:pco2#(fe)$clim                    q:V_CO2(fe,i)      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)          q:V_CO2(fe,i)      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm(i))    q:V_CO2(fe,i)      p:1e-5             fe.tl:
        i:pco2_ms#(fe)$clim_m(i)            q:V_CO2(fe,i)      p:1e-5             fe.tl:

*       Production of T&D electricity
$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec") and TD(sub_elec)) s:0      
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))       q:intelec0(i,sub_elec)
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec"))
        i:py(fe)                 q:(intelec0(fe,sub_elec)*aeei("elec"))
        i:pl_elec(sub_elec)      q:(lelec0(sub_elec)*emkup(sub_elec))                     
        i:pkv_elec(sub_elec)     q:kelec0(sub_elec)


*       Production of fossile fuel electricity
$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec") and ffe(sub_elec)) s:0 coal:0 roil:0 gas:0
        o:pelec(sub_elec)                   q:(outputelec0(sub_elec))                 p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))                  q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:py(elec)                          q:(intelec0(elec,sub_elec)*aeei("elec")*emkup(sub_elec))
        i:pl_elec(sub_elec)                 q:(lelec0(sub_elec)*emkup(sub_elec))                    
        i:pkv_elec(sub_elec)                q:(kelec0(sub_elec)*emkup(sub_elec))                        
        i:py(fe)$intelec0(fe,sub_elec)      q:(intelec0(fe,sub_elec)*aeei("elec")*emkup(sub_elec))                            fe.tl:
        i:pco2#(fe)$clim                    q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_s("elec")#(fe)$clim_s("elec")         q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm("elec"))        q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_ms#(fe)$clim_m("elec")                q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:

$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec") and hnb(sub_elec))  s:0 
        o:pelec(sub_elec)$hne(sub_elec)  q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        o:pelec(sub_elec)$wsb(sub_elec)  q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        i:py(i)$(not elec(i))            q:(intelec0(i,sub_elec)*emkup(sub_elec))                                             
        i:py(elec)                       q:(intelec0(elec,sub_elec)*emkup(sub_elec))                                              
        i:pl_elec(sub_elec)              q:(lelec0(sub_elec)*emkup(sub_elec))                      
        i:pkv_elec(sub_elec)             q:(kelec0(sub_elec)*emkup(sub_elec))                                                 
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))   


*       Production of wind, solar  electricity      va2 from wang ke
$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec") and wse(sub_elec)) s:0 coal:0 roil:0 gas:0
        o:pelec(sub_elec)                   q:(outputelec0(sub_elec))               p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))  a:ra  N:t_re(sub_elec)
        i:py(i)$(not elec(i))               q:(intelec0(i,sub_elec)*emkup(sub_elec))                                           
        i:py(elec)                          q:(intelec0(elec,sub_elec)*emkup(sub_elec))  
        i:pl_elec(sub_elec)                 q:(lelec0(sub_elec)*emkup(sub_elec))                     
        i:pkv_elec(sub_elec)                q:(kelec0(sub_elec)*emkup(sub_elec))                                                
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      


$prod:yv_ist(sub_ist)$(switch_vk and v_i("ist")) s:0
        o:pist(sub_ist)                         q:Vist_out(sub_ist)              p:(1-taxist0(sub_ist))  a:ra  t:taxist0(sub_ist)
        i:py(i)$(not e(i))                      q:Vist_int(i,sub_ist)
        i:py(elec)                              q:Vist_int(elec,sub_ist)
        i:py(fe)                                q:Vist_int(fe,sub_ist)
        i:pl_IST(sub_IST)                       q:Vist_L(sub_IST)          
        i:pkv_ist(sub_IST)                     q:Vist_K(sub_ist)
        i:pco2#(fe)$clim                       q:Vist_CO2(fe,sub_ist)      p:1e-5             
        i:pco2_s(i)#(fe)$clim_s("IST")         q:Vist_CO2(fe,sub_ist)      p:1e-5             
        i:pco2_a#(fe)$(clim_a and cm("IST"))   q:Vist_CO2(fe,sub_ist)      p:1e-5             
        i:pco2_ms#(fe)$clim_m("IST")           q:Vist_CO2(fe,sub_ist)      p:1e-5   

$demand:ra

*// demand for consumption,invest and rd
d:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))

*endowment of factor supplies

e:pk$switch_vk                           q:tmk                                     r:gprod
e:pk$(not switch_vk)                     q:fact("capital")                         r:gprod

e:pkv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i))          q:tvk(i)                                  r:gprod
e:pkv_elec(sub_elec)$(switch_vk and v_i("elec"))        q:tvk_elec(sub_elec)                                  r:gprod
e:pkv_ist(sub_ist)$(switch_vk and v_i("ist"))           q:tvk_ist(sub_ist)                                  r:gprod


e:pls(lm)                q:(tlabor_s0(lm))                                                 r:gprod
e:pls(lm)$Switch_um              q:(-tlabor_s0(lm))                  r:gprod2(lm)
e:pffact(x)          q:ffact0(x)                 r:sff(x)$ffact0(x)
e:pffelec(sub_elec)  q:(ffelec0(sub_elec)*emkup(sub_elec))         r:sffelec(sub_elec)$ffelec0(sub_elec)

*constraint on backstop technologies
e:pbf(bt_elec)$(Switch_bt(bt_elec)$bres(bt_elec)$(not ngcap(bt_elec)))       q:bres(bt_elec)

*exogenous endowment of net exports(include variances)

e:py(i)              q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)

*endowment of carbon emission allowances
e:pco2$clim         q:1                        r:tclim
e:pco2_s(i)$clim_s(i)    q:clim_s(i)
e:pco2_h$clim_h      q:clim_h
e:pco2_a$clim_a     q:1                        r:tclim_a
e:pco2_ms$clim_ms         q:1                        r:tclim_ms


*supplement benchmark fixed-factor endowments according to assumed price elasticities of resource supply

$constraint:sff(x)$ffact0(x)
     sff(x)    =e= (pffact(x)/pu)**eta(x);

$constraint:sffelec(sub_elec)$(ffelec0(sub_elec) and hne(sub_elec))
    sffelec(sub_elec) =e=  (pffelec(sub_elec)/pu)**eta(sub_elec);

$constraint:sffelec(sub_elec)$(wsb(sub_elec) and re_s eq 1)
        sffelec(sub_elec) =e=  (pffelec(sub_elec)/pu)**eta(sub_elec);

$constraint:sffelec(sub_elec)$(wsb(sub_elec) and re_s eq 0)
   yelec(sub_elec) =e=ret0(sub_elec);
*     sffelec(sub_elec) =e= 1;

* wage curve for skilled labor
$constraint:ur(lm)$(Switch_um  and hl(lm))
      (pls(lm)/pu)/(awage_e(lm)/pu) =E=(ur(lm)/ur0(lm))**(-0.1);
*      pls(lm) =e= awage_e(lm);

* rigid wage for unskilled labor
$constraint:ur(lm)$(Switch_um  and ll(lm))
      (pls(lm)/pu)/(awage_e(lm)/pu) =E=(ur(lm)/ur0(lm))**(-0.1);
*      pls(lm) =e= awage_e(lm);

*== indentification of FIT
$constraint:t_re(sub_elec)$( tax_s(sub_elec) eq 0)
        yelec(sub_elec) =e=ret0(sub_elec);

$constraint:t_re(sub_elec)$(tax_s(sub_elec) eq 1)
         t_re(sub_elec) =e=taxelec0(sub_elec) -subelec0(sub_elec);

$constraint:ecf$Switch_fee
sum(sub_elec,yelec(sub_elec)*outputelec0(sub_elec)*costelec0(sub_elec)*pelec(sub_elec)*(taxelec0(sub_elec)-t_re(sub_elec)-subelec_b(sub_elec)))=e= y("elec")*output0("elec") *py("elec")*ecf;


$constraint:rgdp
  pu*rgdp =e= pcons*(sum(i,cons0(i))+sum(f,consf0(f)))*consum+pinv*(sum(i,inv0(i)))*invest+sum(i,py(i)*((nx0(i)+xinv0(i)+xcons0(i))*xscale))   ;


$constraint:gprod$(simu_s eq 0)
  rgdp =e= rgdp0;

$constraint:gprod$(simu_s ne 0)
  gprod =e= gprod0;

$constraint:gprod2(lm)$(Switch_um  and simu_s eq 0)
 gprod2(lm) =e= gprod*ur(lm);

$constraint:gprod2(lm)$(Switch_um  and simu_s ne 0)
  gprod2(lm) =e= gprod0*ur(lm);

*== total co2 accounting
$constraint:tclim$(clim eq 1)
pco2 =e=1e-5;

*== national co2 market
$constraint:tclim$(clim eq 2 )
*== quantity target
tclim =l= clim0*temission2("co2");

$constraint:tclim$(clim eq 3 )
*== intensity target
tclim =l= clim0*temission2("co2")/rgdp0*rgdp;

*== recycling to renewables
$constraint:tclim$(clim eq 4)
pco2*tclim =e=sum(sub_elec,yelec(sub_elec)*outputelec0(sub_elec)*costelec0(sub_elec)*pelec(sub_elec)*(taxelec0(sub_elec)-t_re(sub_elec) -subelec_b(sub_elec)));


$constraint:tclim_ms$(clim_ms eq 1)
*== exogenous carbon price
pco2_ms =e= price_co2;
$constraint:tclim_ms$(clim_ms eq 2)
*== quantity target
tclim =l= clim0*temission2("co2");
$constraint:tclim_ms$(clim_ms eq 3)
*== intensity target
tclim =e= clim0*temission2("co2")/rgdp0*rgdp;

*== quantity target
*tclim_ms =e= clim0*temission2("co2");
*== intensity target
*  tclim_ms =e= clim0*temission2("co2")/rgdp0*rgdp;

$constraint:tclim_a$clim_a
*== quantity target
tclim_a =e= clim0*sum(cm,temission0("co2",cm));


$report:

v:qdout(j)             o:py(j)       prod:y(j)     !output by sector(domestic market)

v:qc(i)                i:py(i)       prod:consum   !consumpiton of final commodities
v:grosscons            o:pcons       prod:consum   !aggregate consumpiton

v:qinvk(i)             i:py(i)       prod:invest   !physical capital investment by non-energy sectors
v:grossinvk            o:pinv        prod:invest   !aggregate physical capital investment


v:util                 o:pu          prod:welf       !welf

v:qin(i,j)             i:py(i)       prod:y(j)      !inputs of intermediate goods
v:qin_ele(i,sub_elec)  i:py(i)       prod:yelec(sub_elec)      !inputs of intermediate goods to fossil fuel fired generation

v:qkin(j)              i:pk          prod:y(j)        !capital inputs
v:qlin(lm,j)           i:plo(lm,j)      prod:y(j)        !labor inputs
v:qlin_ele(lm,sub_elec)      i:plo(lm,"elec")      prod:yelec(sub_elec)        !labor inputs
v:qkin_ele(sub_elec)   i:pk          prod:yelec(sub_elec)        !capital inputs
v:qffin(j)$x(j)        i:pffact(j)   prod:y(j)        !fixed factor inputs

v:qffelec(sub_elec)$cfe(sub_elec)    i:pffelec(sub_elec)     prod:yelec(sub_elec)      !fixed factor inputs

V:qelec(sub_elec)        o:pelec(sub_elec)       prod:yelec(sub_elec)

v:qkvin(j)              i:pkv(j)          prod:yv(j)        !vintage capital inputs

v:ECO2(i)              i:pco2         prod:y(i)
v:ECO2_elec(sub_elec)              i:pco2        prod:yelec(sub_elec)
v:eco2_h                i:pco2        prod:consum
v:ECO2_s(i)              i:pco2_s(i)        prod:y(i)
v:ECO2_s_elec(sub_elec)              i:pco2_s("elec")        prod:yelec(sub_elec)
v:ECO2_m(i)              i:pco2_ms         prod:y(i)
v:ECO2_m_elec(sub_elec)             i:pco2_ms        prod:yelec(sub_elec)
v:eco2_m_fd                i:pco2_ms       prod:consum

v:dpermits(sub_elec)              i:pers        prod:yelec(sub_elec)
v:spermits(sub_elec)              o:pers        prod:yelec(sub_elec)

v:labors(lm)                i:pls(lm)       prod:l_s(lm)
v:laborss(lm,i)              o:plo(lm,i)        prod:l_s(lm)


$offtext
$sysinclude mpsgeset CHEER

*carbon has zero price in the benchmark

*initialize constraints

sff.l(x)$ffact0(x)  =1;
t_re.l(sub_elec) = -subelec0(sub_elec)+taxelec0(sub_elec);
t_re.lo(sub_elec) =-inf;
ecf.l$Switch_fee= ecf0;
ecf.lo$Switch_fee=-inf;
yv.l(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i))=phi_vk0(i);
yv_elec.l(sub_elec)$(switch_vk and v_i("elec"))=phi_vk0("elec");
yv_ist.l(sub_ist)$(switch_vk and v_i("ist"))=phi_vk0("ist");
pu.fx=1;

tclim.l=temission2("co2");
*pco2.fx=0;

pco2_ms.l=price_co2;

pelec.l(sub_elec)=(costelec0(sub_elec));

*== switch for umemployment
ur0(lm)$(1-switch_um)=0;
ur.l(lm)=ur0(lm);
ur.lo(lm)=ur0(lm);

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

*== switch for renewable quota
pflag=0;
phi=0.1;

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

CHEER.iterlim =100000;

$include CHEER.gen

*EXECUTE_LOADPOINT 'CHEER_p';
solve CHEER using mcp;

CHEER.Savepoint = 1;

display CHEER.modelstat, CHEER.solvestat,ur.l,clim;

*check2 =   (tlabor_q0(lm)/(1-ur0(lm))*ur.l(lm))-
*check2(lm) = (1-ur.l(lm))*tlabor_s0(lm)-    sum(j,qlin.l(lm,j))- sum(sub_elec, qlin_ele.l(lm,sub_elec));
parameter check;
check(sub_elec)= outputelec0(sub_elec)*(1-taxelec0(sub_elec))*costelec0(sub_elec)-sum(i,intelec0(i,sub_elec)*emkup(sub_elec))
                                -sum(lm,laborelec0(lm,sub_elec)*emkup(sub_elec)*labor_w0(lm,"elec"))
                                -kelec0(sub_elec)*emkup(sub_elec)
                                -ffelec0(sub_elec)*emkup(sub_elec)
                                ;
display check;

$ontext
$prod:y(i)$(not fe(i) and not elec(i) and not ist(i) ) s:esub("TOP",i) a:esub("NR",i) b(a):esub("IT",i)  kle(b):esub("KLE",i) kl(kle):esub("KL",i)  l(kl):esub_l("l") e(kle):esub("E",i)  ne(e):esub("NELE",i)   coal(ne):0 roil(ne):0 gas(ne):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:pco2$clim         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_s(i)$clim_s(i)         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_a$(clim_a and cm(i))         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_ms$clim_m(i)        q:(emission0("co2","e","process",i))      p:1e-5
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                           a:
        i:py(j)$(not e(j))       q:int0(j,i)                                         b:
        i:py(fe)                 q:(int0(fe,i)*r_feed(fe,i))                     b:
        i:pk                     q:fact0("capital",i)                              kl:
        i:plo(lm,i)$ll(lm)        q:labor_q0(lm,i)              p:labor_w0(lm,i)             l:
        i:plo(lm,i)$hl(lm)        q:labor_q0(lm,i)              p:labor_w0(lm,i)             l:
        i:py(elec)               q:(int0(elec,i)*aeei(i))                          e:
        i:py(fe)                 q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))                            fe.tl:
        i:pco2#(fe)$clim         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm(i))         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_ms#(fe)$clim_m(i)        q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:

$prod:y(i)$(fe(i) ) s:esub("NR",i) b(s):esub("IT",i)  kle(b):esub("KLE",i) kl(kle):esub("KL",i)  l(kl):esub_l("l") e(kle):esub("E",i)  ne(e):esub("NELE",i)  coal(ne):0 roil(ne):0 gas(ne):0
                o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
                i:pffact(i)$ffact0(i)    q:ffact0(i)
                i:py(j)$(not e(j))       q:int0(j,i)                                         b:
                i:py(fe)                 q:(int0(fe,i)*r_feed(fe,i))                            b:
                i:pk                     q:fact0("capital",i)                              kl:
                i:plo(lm,i)$ll(lm)        q:labor_q0(lm,i)              p:labor_w0(lm,i)             l:
                i:plo(lm,i)$hl(lm)        q:labor_q0(lm,i)              p:labor_w0(lm,i)             l:
                i:py(elec)               q:(int0(elec,i)*aeei(i))                          e:
                i:py(fe)                 q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))                            fe.tl:
                i:pco2#(fe)$clim         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
                i:pco2_s(i)#(fe)$clim_s(i)         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
                i:pco2_a#(fe)$(clim_a and cm(i))         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
                i:pco2_ms#(fe)$clim_m(i)        q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:

$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec")) s:0 coal:0 roil:0 gas:0
        o:pelec(sub_elec)$ffe(sub_elec)                      q:outputelec0(sub_elec)             p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        o:pelec(sub_elec)$TD(sub_elec)                       q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)        
        o:pelec(sub_elec)$(not ffe(sub_elec) and not TD(sub_elec))                q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        i:py(i)$(not e(i))                                  q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:pffelec(sub_elec)$ffelec0(sub_elec)   q:(ffelec0(sub_elec)*emkup(sub_elec))
        i:py(elec)                              q:(intelec0(elec,sub_elec)*emkup(sub_elec))
        i:pl_elec(sub_elec)                     q:(lelec0(sub_elec)*emkup(sub_elec))                      
        i:pkv_elec(sub_elec)                    q:(Kelec0(sub_elec)*emkup(sub_elec))                      
        i:py(fe)$intelec0(fe,sub_elec)          q:(intelec0(fe,sub_elec)*emkup(sub_elec))                            fe.tl:
        i:pco2#(fe)$clim                        q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_s("elec")#(fe)$clim_s("elec")    q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm("elec"))   q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_ms#(fe)$clim_m("elec")           q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec))      p:1e-5             fe.tl:

*$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec")) s:0 coal:0 roil:0 gas:0
*        o:pelec(sub_elec)$ffe(sub_elec)                      q:1              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
*        o:pelec(sub_elec)$TD(sub_elec)                       q:1              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)        
*        o:pelec(sub_elec)$(not ffe(sub_elec) and not TD(sub_elec))                q:1              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
*        i:py(i)$(not e(i))                                  q:Velec_int(i,sub_elec)
*        i:pffelec(sub_elec)$ffelec0(sub_elec)   q:Velec_ff(sub_elec)
*        i:py(elec)                              q:Velec_int(elec,sub_elec)
*        i:pl_elec(sub_elec)                     q:Velec_l(sub_elec)                      
*        i:pkv_elec(sub_elec)                    q:Velec_k(sub_elec)                      
*        i:py(fe)$intelec0(fe,sub_elec)          q:Velec_int(fe,sub_elec)                            fe.tl:
*        i:pco2#(fe)$clim                        q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec)/outputelec0(sub_elec))      p:1e-5             fe.tl:
*        i:pco2_s("elec")#(fe)$clim_s("elec")    q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec)/outputelec0(sub_elec))      p:1e-5             fe.tl:
*        i:pco2_a#(fe)$(clim_a and cm("elec"))   q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec)/outputelec0(sub_elec))      p:1e-5             fe.tl:
*        I:Pers$pflag                            Q:((phi/(1-phi)))
*        i:pco2_ms#(fe)$clim_m("elec")           q:(emissionelec0("co2","e",fe,sub_elec)*emkup(sub_elec)/outputelec0(sub_elec))      p:1e-5             fe.tl:




$offtext