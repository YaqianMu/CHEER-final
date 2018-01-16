*----------------------------------------------*
*1206, to build the basic model for employment analysis
*0723, add backstop technologies for elec and ist
*1128，modify CHEER based on EPPA
*201712, use individual production functions for labor allocation and co2 constrains
*----------------------------------------------*

$ONTEXT
$Model:CHEER

$Sectors:
ya(i)                  !activity level for armington production
ye(i)                  !activity level for export production
y(i)                   !activity level for domestic production 
yelec(sub_elec)        !Activity level for electricity production
yist(sub_ist)          !Activity level for ist production

yv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i)) !activity level for vintage production
yv_elec(sub_elec)$(switch_vk and v_i("elec"))               !activity level for vintage production in elec
yv_ist(sub_ist)$(switch_vk and v_i("ist"))                  !activity level for vintage production in ist

consum                 !activity level for aggregate consumption
invest                 !activity level for aggregate physical capital investment
welf                   !activity level for aggregate welfare


ybt_elec(bt_elec)$Switch_bt(bt_elec)    !Activity level for backstop electricity production
bres_ngcap$(Switch_bt("ngcap"))         !Convert pbf_ngcc to pbf_ngcap
BT2T(bt_elec)$Switch_bt(bt_elec)        !Convert Pbt to pelec
ybt_ist(bt)$Switch_bt(bt)               !Activity level for backstop ist technologies

l_s(lm)                                 !Activity level for labor allocation
l_a(i)$(not elec(i) and not ist(i))     !Activity level for labor aggregation
l_elec(sub_elec)                        !Activity level for labor aggregation in elec
l_IST(sub_IST)                          !Activity level for labor aggregation in ist

yco2_i(fe,i)            !energy demand include carbon emission 
yco2_h(fe)              !energy demand include carbon emission 

$Commodities:
pa(i)                   !price inex for armington goods
py(i)                   !price inex for domestic goods
pelec(sub_elec)         !price inex for domestic subelec
pist(sub_ist)           !price inex for domestic subist
*pelec(sub_elec)$(not bse(sub_elec))         !domestic price inex for subelec
*pe_base                !domestic price inex for baseload elec

pm(i)                   !price inex for import goods
pe(i)                   !price inex for export goods
pfx(i)                  !price index for trade deficit

pa_c(fe,i)              !domestic price inex for energy goods include carbon emission
pa_ch(fe)               !domestic price inex for energy goods include carbon emission

pbt(bt_elec)$Switch_bt(bt_elec)             !domestic price inex for backstop electricity production

pls(lm)                                     !domestic price index for labor demand
pl(i)$(not elec(i) and not ist(i))          !domestic price index for aggregated labor demand
pl_ELEC(sub_elec)                           !domestic price index for aggregated labor demand in elec
pl_IST(sub_ist)                             !domestic price index for aggregated labor demand in ist
plo(lm,i)$(labor_q0(lm,i))                  !domestic price index for labor demand

pk                                                                !domestic price index for captial
pkv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i))      !domestic price index for vintage captial
pkv_elec(sub_elec)$(switch_vk and v_i("elec"))                    !domestic price index for vintage captial
pkv_ist(sub_ist)$(switch_vk and v_i("ist"))                       !domestic price index for vintage captial

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
pco2_ms$clim_ms

Pers$switch_nfs        !shadow Price for permits of electricity generation

$consumers:
ra                     !income level for representative agent
raf                    !income level for foreign representative agent     

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
*$prod:y(i)$elec(i)   s:0   b(s):0 a(b):0     c(a):0
        o:py(i)                               q:output0(i)                p:(1-ecf0)  a:ra  N:ecf$Switch_fee
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)     p:(costelec0(sub_elec))
        i:pelec(sub_elec)$cge(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  c:
        i:pelec("OIL_Power")                  q:outputelec0("OIL_Power")  p:(costelec0("OIL_Power"))  a:
        i:pelec(sub_elec)$hnb(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  a:
        i:pelec(sub_elec)$wse(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  a:
        i:pbt(bt)$Switch_bt(bt)               q:1    b:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:esub_elec("IT","T_D")      
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:pa(i)$(not e(i))       q:intelec0(i,sub_elec)
        i:pa(elec)               q:(intelec0(elec,sub_elec)*aeei("elec"))
        i:pa(fe)                 q:(intelec0(fe,sub_elec)*aeei("elec"))
        i:pl_elec(sub_elec)      q:(lelec0(sub_elec)*emkup(sub_elec))                     
        i:pk                     q:kelec0(sub_elec)


*       Production of fossile fuel electricity
$prod:yelec(sub_elec)$ffe(sub_elec) s:esub_elec("IT",sub_elec)   kle(s):esub_elec("KLE",sub_elec) kl(kle):esub_elec("KL",sub_elec) l(kl):esub_l("l")   ene(kle):esub_elec("E",sub_elec)
        o:pelec(sub_elec)                q:(outputelec0(sub_elec))                 p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:pa(i)$(not e(i))               q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:pa(elec)                       q:(intelec0(elec,sub_elec)*aeei("elec")*emkup(sub_elec))
        i:pl_elec(sub_elec)              q:(lelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:pk                             q:(kelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:pa_c(fe,"elec")                q:(intelec0(fe,sub_elec)*aeei("elec")*emkup(sub_elec))       kle:              
*        I:Pers$switch_nfs                     Q:((nfs/(1-nfs))*outputelec0(sub_elec))


*       Production of hybro and nuclear biomass electricity      va2 from wang ke
$prod:yelec(sub_elec)$hnb(sub_elec)  s:esub_elec("NR",sub_elec) a:esub_elec("IT",sub_elec) va(a):esub_elec("KL",sub_elec) l(va):esub_l("l")
        o:pelec(sub_elec)$hne(sub_elec)         q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        o:pelec(sub_elec)$wsb(sub_elec)         q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        o:Pers$switch_nfs                       Q:((outputelec0(sub_elec)))
        i:pa(i)$(not elec(i))                   q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              a:
        i:pa(elec)                              q:(intelec0(elec,sub_elec)*emkup(sub_elec))                                              a:
        i:pl_elec(sub_elec)                     q:(lelec0(sub_elec)*emkup(sub_elec))                      va:
        i:pk                                    q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)   q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1


*       Production of wind, solar  electricity      va2 from wang ke
$prod:yelec(sub_elec)$wse(sub_elec) s:esub_elec("NR",sub_elec) b:esub_elec("IT",sub_elec) va(b):esub_elec("KL",sub_elec) l(va):esub_l("l")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))               p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))  a:ra  N:t_re(sub_elec)
        O:Pers$switch_nfs             Q:(outputelec0(sub_elec))
        i:pa(i)$(not elec(i))    q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              b:
        i:pa(elec)               q:(intelec0(elec,sub_elec)*emkup(sub_elec))   b:
        i:pl_elec(sub_elec)      q:(lelec0(sub_elec)*emkup(sub_elec))                     va:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1

*// IST sector
$prod:y(i)$(switch_ist and ist(i))   s:0
        o:py(i)                  q:output0(i)       
        i:pist(sub_ist)          q:(output0(i)*ts_ist(sub_ist))     

$prod:yist(sub_ist)$switch_ist s:esub("IT","Ist")  kle:esub("KLE","Ist") kl(kle):esub("KL","Ist") e(kle):esub("E","Ist")  ne(e):esub("NELE","Ist")
        o:pist(sub_ist)          q:(outputist0(sub_ist))              p:(1-taxist0(sub_ist))  a:ra  t:taxist0(sub_ist)
        i:pa(i)$(not e(i))       q:intist0(i,sub_ist)
        i:pa(elec)               q:(intist0(elec,sub_ist)*aeei("IST"))  e:
        i:pa_c(fe,"ist")         q:(intist0(fe,sub_ist)*aeei("IST"))    ne:
        i:pl_IST(sub_IST)        q:lIST0(sub_IST)           kl:
        i:pk                     q:kist0(sub_ist)           kl:

*// other sectors
$prod:y(i)$(not elec(i) and not ist(i)) s:esub("TOP",i) a:esub("NR",i) b(a):esub("IT",i)  kle(b):esub("KLE",i) kl(kle):esub("KL",i) e(kle):esub("E",i)  ne(e):esub("NELE",i)
        o:py(i)                             q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:Pers$(fe(i) and switch_nfs)       Q:(nf2ff(i)*output0(i))
        i:pco2$clim                         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_s(i)$clim_s(i)               q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_a$(clim_a and cm(i))         q:(emission0("co2","e","process",i))      p:1e-5
        i:pco2_ms$clim_m(i)                 q:(emission0("co2","e","process",i))      p:1e-5
        i:pffact(i)$ffact0(i)               q:ffact0(i)                                           a:
        i:pa(j)$(not e(j))                  q:int0(j,i)                                         b:
        i:pa(fe)                            q:(int0(fe,i)*r_feed(fe,i))                     b:
        i:pk                                q:fact0("capital",i)                              kl:
        i:pl(i)                             q:fact0("labor",i)                                kl:
        i:pa(elec)                          q:(int0(elec,i)*aeei(i))                          e:
        i:pa_c(fe,i)                        q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))       ne:

*// armington index
$prod:ya(i) s:1
        o:pa(i)                             q:a0(i)
        i:py(i)                             q:output0(i)     
        i:pm(i)                             q:(-ximp0(i))

*// export index
$prod:ye(i) s:0
        o:pe(i)                             q:exp0(i)
        i:pa(i)                             q:exp0(i) 

*// energy demand include co2 emission
$prod:yco2_i(fe,i) s:0
        o:pa_c(fe,i)                        q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))
        i:pa(fe)                            q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))   
        i:pco2#(fe)$clim                    q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             
        i:pco2_s(i)#(fe)$clim_s(i)          q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5          
        i:pco2_a#(fe)$(clim_a and cm(i))    q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5           
        i:pco2_ms#(fe)$clim_m(i)            q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5            

$prod:yco2_h(fe) s:0
        o:pa_ch(fe)                         q:(cons0(fe)*aeei("fd"))
        i:pa(fe)                            q:(cons0(fe)*aeei("fd"))                 
        i:pco2#(fe)$clim                    q:(emission0("co2","e",fe,"fd")*aeei("fd"))      p:1e-5             
        i:pco2_h#(fe)$clim_h                q:(emission0("co2","e",fe,"fd")*aeei("fd"))      p:1e-5            
        i:pco2_ms#(fe)$clim_m("fd")         q:(emission0("co2","e",fe,"fd")*aeei("fd"))      p:1e-5             


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

*// consumption of goods and factors    based on EPPA
$prod:consum   s:esub_c("TOP")  a:esub_c("NE") e:esub_c("E") roil(e):0 coal(e):0 gas(e):0
         o:pcons                  q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:pa(i)$(not e(i))       q:cons0(i)                a:
         i:pa(i)$(elec(i))        q:(cons0(i)*aeei("fd"))                e:
         i:pa_ch(fe)              q:(cons0(fe)*aeei("fd"))                 fe.tl:

*// aggregate capital investment
$prod:invest   s:esub_inv
         o:pinv            q:(sum(i,inv0(i)))
         i:pa(i)            q:inv0(i)

*// welfare          Ke Wang=1, EPPA=0
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
        i:pa(j)$(not e(j))                  q:V_int(j,i)                                         
        i:pa(fe)                            q:(V_int(fe,i)*r_feed(fe,i))                                       
        i:pkv(i)                            q:V_K(i)                            
        i:pl(i)                             q:V_L(i)                              
        i:pa(elec)                          q:V_int(elec,i)                          
        i:pa_c(fe,i)                        q:(V_int(fe,i)*(1-r_feed(fe,i)))                            fe.tl:

$prod:yv_elec(sub_elec)$(switch_vk and v_i("elec")) s:0 
        o:pelec(sub_elec)$ffe(sub_elec)                      q:Velec_out(sub_elec)             p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        o:pelec(sub_elec)$TD(sub_elec)                       q:Velec_out(sub_elec)             p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)        
        o:pelec(sub_elec)$(not ffe(sub_elec) and not TD(sub_elec))                q:Velec_out(sub_elec)              p:((1-taxelec0(sub_elec)+subelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        o:Pers$(switch_nfs and cfe(sub_elec))                     Q:Velec_out(sub_elec)
        i:pa(i)$(not e(i))                                   q:Velec_int(i,sub_elec)
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:Velec_ff(sub_elec)
        i:pa(elec)                                           q:Velec_int(elec,sub_elec)
        i:pl_elec(sub_elec)                                  q:Velec_l(sub_elec)
        i:pkv_elec(sub_elec)                                 q:Velec_k(sub_elec)
        i:pa_c(fe,"elec")$intelec0(fe,sub_elec)              q:Velec_int(fe,sub_elec)
*        I:Pers$(switch_nfs and ffe(sub_elec))                     Q:((nfs/(1-nfs)))

$prod:yv_ist(sub_ist)$(switch_vk and v_i("ist")) s:0
        o:pist(sub_ist)                     q:Vist_out(sub_ist)              p:(1-taxist0(sub_ist))  a:ra  t:taxist0(sub_ist)
        i:pa(i)$(not e(i))                  q:Vist_int(i,sub_ist)
        i:pa(elec)                          q:Vist_int(elec,sub_ist)
        i:pa_c(fe,"ist")                    q:Vist_int(fe,sub_ist)
        i:pl_IST(sub_IST)                   q:Vist_L(sub_IST)          
        i:pkv_ist(sub_IST)                  q:Vist_K(sub_ist)

*//     Production of backstop technologices
$prod:ybt_elec(bt_elec)$Switch_bt(bt_elec)  s:0 sa(s):esub_bt("NR",bt_elec)   gva(sa):esub_bt("gva",bt_elec)  gl(gva):esub_l("l") sva(sa):esub_bt("SVA",bt_elec)  sl(sva):esub_l("l") roil(sa):0 coal(sa):0 gas(sa):0
        o:pbt(bt_elec)                               q:1
        i:pbf(bt_elec)                               q:(bsin("ffa",bt_elec)*bmkup(bt_elec))                    sa:
        i:plo(lm,"elec")$ll(lm)                      q:(bslin("gen",lm,bt_elec)*bmkup(bt_elec))                gl:
        i:plo(lm,"elec")$hl(lm)                      q:(bslin("gen",lm,bt_elec)*bmkup(bt_elec))                gl:
        i:pk                                         q:(bsin("k",bt_elec)*bmkup(bt_elec))                      gva:
        i:plo(lm,"elec")$ll(lm)                      q:(bslin("CCS",lm,bt_elec)*bmkup(bt_elec))                sl:
        i:plo(lm,"elec")$hl(lm)                      q:(bslin("CCS",lm,bt_elec)*bmkup(bt_elec))                sl:
        i:pk                                         q:(bsin("kseq",bt_elec)*bmkup(bt_elec))                   sva:
        i:pa_c(fe,"elec")                            q:(bsin(fe,bt_elec)*aeei("elec")*bmkup(bt_elec))                                                                fe.tl:

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

$prod:ybt_ist("BOFA")$Switch_bt("BOFA") s:0
        o:pist("BOF")            q:(outputist0("BOF"))              p:(1-taxist0("BOF"))  a:ra  t:taxist0("BOF")
        i:pa(i)$(not e(i))       q:(intist0(i,"BOF")*bsrist(i,"BOFA"))
        i:pa(elec)               q:(intist0(elec,"BOF")*aeei("IST")*bsrist(elec,"BOFA"))
        i:pa_c(fe,"ist")         q:(intist0(fe,"BOF")*aeei("IST")*bsrist(fe,"BOFA"))
        i:plo(lm,"ist")$ll(lm)   q:(laborist0(lm,"BOF")*bsrist(lm,"BOFA"))        p:labor_w0(lm,"ist")           
        i:plo(lm,"ist")$hl(lm)   q:(laborist0(lm,"BOF")*bsrist(lm,"BOFA"))        p:labor_w0(lm,"ist")           
        i:pk                     q:(kist0("BOF")*bsrist("capital","BOFA"))

$prod:ybt_ist("EAFA")$Switch_bt("EAFA") s:0
        o:pist("EAF")            q:(outputist0("EAF"))              p:(1-taxist0("EAF"))  a:ra  t:taxist0("EAF")
        i:pa(i)$(not e(i))       q:(intist0(i,"EAF")*bsrist(i,"EAFA"))
        i:pa(elec)               q:(intist0(elec,"EAF")*aeei("IST")*bsrist(elec,"EAFA"))
        i:pa_c(fe,"ist")         q:(intist0(fe,"EAF")*aeei("IST")*bsrist(fe,"EAFA"))
        i:plo(lm,"ist")$ll(lm)   q:(laborist0(lm,"EAF")*bsrist(lm,"EAFA"))        p:labor_w0(lm,"ist")           
        i:plo(lm,"ist")$hl(lm)   q:(laborist0(lm,"EAF")*bsrist(lm,"EAFA"))        p:labor_w0(lm,"ist")           
        i:pk                     q:(kist0("EAF")*bsrist("capital","EAFA"))

$demand:ra

*// demand for consumption,invest and rd
d:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))

*endowment of factor supplies

e:pk$switch_vk                           q:tmk                                     r:gprod
e:pk$(not switch_vk)                     q:fact("capital")                         r:gprod

e:pkv(i)$(switch_vk and v_i(i) and not elec(i) and not ist(i))          q:tvk(i)                                  r:gprod
e:pkv_elec(sub_elec)$(switch_vk and v_i("elec"))                        q:tvk_elec(sub_elec)                      r:gprod
e:pkv_ist(sub_ist)$(switch_vk and v_i("ist"))                           q:tvk_ist(sub_ist)                        r:gprod


e:pls(lm)                q:(tlabor_s0(lm))                                                 r:gprod
e:pls(lm)$Switch_um              q:(-tlabor_s0(lm))                  r:gprod2(lm)
e:pffact(x)          q:ffact0(x)                 r:sff(x)$ffact0(x)
e:pffelec(sub_elec)  q:(ffelec0(sub_elec)*emkup(sub_elec))         r:sffelec(sub_elec)$ffelec0(sub_elec)

*constraint on backstop technologies
e:pbf(bt_elec)$(Switch_bt(bt_elec)$bres(bt_elec)$(not ngcap(bt_elec)))       q:bres(bt_elec)

*exogenous endowment of net exports(include variances)
e:pfx(i)             q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)

*endowment of carbon emission allowances
e:pco2$clim         q:1                        r:tclim
e:pco2_s(i)$clim_s(i)    q:clim_s(i)
e:pco2_h$clim_h      q:clim_h
e:pco2_a$clim_a     q:1                        r:tclim_a
e:pco2_ms$clim_ms         q:1                        r:tclim_ms

$demand:raf
d:pe(i)     q:exp0(i)
d:pfx(i)    q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)
e:pm(i)     q:(-ximp0(i))

$report: 
v:qdexp(i)     d:pe(i)       demand:raf
v:qsimp(i)     i:pm(i)       prod:ya(i)
v:qsexp(i)     o:pe(i)       prod:ye(i)

*// supplement benchmark fixed-factor endowments according to assumed price elasticities of resource supply
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
*abort$(ABS(Smax(i,y.l(i)-1)) GT 1.E-4)
*            "*** CHEER benchmark does not calibrate";

CHEER.Savepoint = 1;

display CHEER.modelstat, CHEER.solvestat,ur.l,clim;