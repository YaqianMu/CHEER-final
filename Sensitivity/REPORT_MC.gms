* --------------------------------------------------------------------
* --
* -- Trade Integrated Global Energy and Resources Model - TIGER
* --
* --            David Roland-Holst
* --            UC Berkeley
* --
* --------------------------------------------------------------------
* Put all model results in an Excel readable CSV file
* --------------------------------------------------------------------
if(ifCSV ne 0,

   put csv ;

   if(ord(sim) eq 1 and years(t) eq 2010,

      if(ifCSVhdr ne 0,
         put 'Scenario,isen, iisen, iiisen, Region,Variable,Sector,Qual1,Qual2,Year,Value' / ;
      ) ;

*     Setup the parameters for csv

      csv.pc   = 5 ;
      csv.pw = 255 ;
      csv.nj =   1 ;
      csv.nw =  15 ;
      csv.nd =   9 ;
      csv.nz =   0 ;
      csv.nr =   0 ;
   ) ;

* ----- loop over the regions and output the data

   loop(r,
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gdpmp',      '', '', '', t.tl, gdpmpt(r,t)     / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'rgdpmp',     '', '', '', t.tl, rgdpmpt(r,t)    / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'rgdp',       '', '', '', t.tl, rgdpt(r,t)      / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'rgdpmp_ppp', '', '', '', t.tl, rgdpmp_ppp(r,t) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ToT%',       '', '', '', t.tl, (totPT(r,t)) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gdp_pc',     '', '', '', t.tl, gdp_pc(r,t)     / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gdp_pc_ppp', '', '', '', t.tl, gdp_pc_ppp(r,t) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'tkaps',      '', '', '', t.tl, tkapsT(r,t)     / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'tlabs',      '', '', '', t.tl, (rscale*sum((lm,l,rt),(1-ue.l(r,lm,l,rt))*ls.l(r,lm,l,rt))) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'cons',       '', '', '', t.tl, const(r,t)      / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gov',        '', '', '', t.tl, govt(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'inv',        '', '', '', t.tl, invt(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'invsh',      '', '', '', t.tl, (invsh.l(r)) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'savsh',      '', '', '', t.tl, (savsh.l(r)) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'chiSav',     '', '', '', t.tl, (chiSav.l(r)) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'chiInv',     '', '', '', t.tl, (chiInv.l(r)) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'exp',        '', '', '', t.tl, expt(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'imp',        '', '', '', t.tl, impt(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'depr',       '', '', '', t.tl, (100*depr(r))  / ;

      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pgdpmp',     '', '', '', t.tl, pgdpmpt(r,t)    / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pgdp',       '', '', '', t.tl, pgdpt(r,t)      / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pabs',       '', '', '', t.tl, pabst(r,t)      / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'cpi',        '', '', '', t.tl, (100*cpi.l(r))  / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gpi',        '', '', '', t.tl, gpit(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'zpi',        '', '', '', t.tl, zpit(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'epi',        '', '', '', t.tl, epit(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'mpi',        '', '', '', t.tl, mpit(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'api',        '', '', '', t.tl, apit(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'tot',        '', '', '', t.tl, tott(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'totv',       '', '', '', t.tl, tot.l(r)        / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'aRent',      '', '', '', t.tl, arentT(r,t)     / ;

      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ssuf',        '', '', '', t.tl, ssuft(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'fsec',        '', '', '', t.tl, fsect(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'fsaf',        '', '', '', t.tl, fsaft(r,t)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'fvul',        '', '', '', t.tl, fvult(r,t)       / ;

      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'savg',       '', '', '', t.tl, savgT(r,t)      / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'savf',       '', '', '', t.tl, (rscale*savfT(r,t)) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'psavw',      '', '', '', t.tl, (psavw.l)       / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wrr',        '', '', '', t.tl, (wrr.l)         / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'tland',      '', '', '', t.tl, tlandT(r,t)     / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ptland',     '', '', '', t.tl, ptland.l(r)     / ;
      if(leps0(r) ne inf and landmax(r) eq inf and tland0(r) ne 0,
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'leps',      '', '', '', t.tl, leps0(r)     / ;
      ) ;
      if(leps0(r) ne inf and landmax(r) ne inf and tland0(r) ne 0,
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'leps',      '', '', '', t.tl, (gammats(r)*ats(r)*(ptland.l(r)/pabs.l(r))
            /(ats(r) + exp(gammats(r)*(ptland.l(r)/pabs.l(r)))))      / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'landMax',   '', '', '', t.tl, (landMax(r)/tland.l(r)) / ;
      ) ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'chik',       '', '', '', t.tl, (chik.l(r))     / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'Walras',     '', '', '', t.tl, WalrasT(r,t)    / ;

      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'kstock',     '', '', '', t.tl, kstockT(r,t)    / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gk',         '', '', '', t.tl, gkT(r,t)        / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'gl',         '', '', '', t.tl, glT(r,t)        / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ssgl',       '', '', '', t.tl, ssglT(r,t)      / ;

$ontext
      put sim.tl, r.tl, 'lalloc',     '', '', '', t.tl, lalloc(r,t)     / ;
      put sim.tl, r.tl, 'kalloc',     '', '', '', t.tl, kalloc(r,t)     / ;
      put sim.tl, r.tl, 'talloc',     '', '', '', t.tl, talloc(r,t)     / ;
      put sim.tl, r.tl, 'lprod',      '', '', '', t.tl, lprod(r,t)      / ;
      put sim.tl, r.tl, 'kprod',      '', '', '', t.tl, kprod(r,t)      / ;
      put sim.tl, r.tl, 'tprod',      '', '', '', t.tl, tprod(r,t)      / ;
      put sim.tl, r.tl, 'fprod',      '', '', '', t.tl, fprod(r,t)      / ;
      put sim.tl, r.tl, 'lgrowth',    '', '', '', t.tl, lgrowth(r,t)    / ;
      put sim.tl, r.tl, 'kgrowth',    '', '', '', t.tl, kgrowth(r,t)    / ;
      put sim.tl, r.tl, 'tgrowth',    '', '', '', t.tl, tgrowth(r,t)    / ;
      put sim.tl, r.tl, 'fgrowth',    '', '', '', t.tl, fgrowth(r,t)    / ;
$offtext


$ontext
	put sim.tl, r.tl, 'emitot', '', '', '', t.tl, emitotT(r,t) / ;
     put sim.tl, r.tl, 'emitax', '', '', '', t.tl, emitaxT(r,t) / ;

     put sim.tl, r.tl, 'ergtot', '', '', '', t.tl, ergtotT(r,t) / ;
     put sim.tl, r.tl, 'ergtax', '', '', '', t.tl, ergtaxT(r,t) / ;
     loop(i,
        put sim.tl, r.tl, 'emitaxad'  i.tl, '',  t.tl, emitaxadT(r,i,t)  / ; ) ;
$offtext

      loop(tranche, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pop',    tranche.tl, '', '', t.tl, (pop.l(r,tranche)) / ; )
      loop(tranche, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'deprat', tranche.tl, '', '', t.tl, (deprat.l(r,tranche)) / ; )

      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'hpop',  h.tl, '', '',  t.tl, hpopT(r,h,t)  / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'savh',  h.tl, '', '',  t.tl, savhT(r,h,t)  / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'aps',   h.tl, '', '',  t.tl, (aps.l(r,h))  / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'deprY', h.tl, '', '',  t.tl, deprYT(r,h,t) / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'yd',    h.tl, '', '',  t.tl, ydT(r,h,t)    / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'hcpi',  h.tl, '', '',  t.tl, (hcpi.l(r,h)) / ; ) ;

      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ryd',   h.tl, '', '',  t.tl, rydT(r,h,t)   / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'E1',    h.tl, '', '',  t.tl, E1T(r,h,t)    / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'E2',    h.tl, '', '',  t.tl, E2T(r,h,t)    / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'E3',    h.tl, '', '',  t.tl, E3T(r,h,t)    / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'E4',    h.tl, '', '',  t.tl, E4T(r,h,t)    / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'E5',    h.tl, '', '',  t.tl, E5T(r,h,t)    / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'E6',    h.tl, '', '',  t.tl, E6T(r,h,t)    / ; ) ;

      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'AE1',   h.tl, '', '',  t.tl, AE1T(r,h,t)   / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'AE2',   h.tl, '', '',  t.tl, AE2T(r,h,t)   / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'AE3',   h.tl, '', '',  t.tl, AE3T(r,h,t)   / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'AE4',   h.tl, '', '',  t.tl, AE4T(r,h,t)   / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'u',     h.tl, '', '',  t.tl, u1(r,h,t)     / ; ) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'Au',    h.tl, '', '',  t.tl, Au1(r,h,t)    / ; ) ;

      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'GE1',   '', '', '',  t.tl, GE1T(r,t)   / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'GE2',   '', '', '',  t.tl, GE2T(r,t)   / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'GE3',   '', '', '',  t.tl, GE3T(r,t)   / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'GE4',   '', '', '',  t.tl, GE4T(r,t)   / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'Gu',    '', '', '',  t.tl, gu1(r,t)    / ;
      
      loop(agric, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'acreage'    , agric.tl, '', '', t.tl, AcreageT(r,agric,t)    / ; ) ;

      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ld'    , i.tl, '', '', t.tl, ldT(r,i,t)    / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'kapd'  , i.tl, '', '', t.tl, kapdT(r,i,t)  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'rent'  , i.tl, '', '', t.tl, rentT(r,i,t)  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'nrent' , i.tl, '', '', t.tl, (rentT(r,i,t)/(1+KapTx.l(r,i,"Old")+KapTs.l(r,i,"Old")))  / ; ) ;
      loop(i$(td.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'td' , i.tl, '', '', t.tl, (td.l(r,i))  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pt'    , i.tl, '', '', t.tl, ptT(r,i,t)     / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'npt'   , i.tl, '', '', t.tl, (npt.l(r,i))   / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'px',     i.tl, '', '', t.tl, pxT(r,i,t)     / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ac',     i.tl, '', '', t.tl, ac.l(r,i)      / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'uvc',    i.tl, '', '', t.tl, uvc.l(r,i)     / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'markup', i.tl, '', '', t.tl, markup.l(r,i)  / ; ) ;
      loop(i$(ac.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'cdr',    i.tl, '', '', t.tl, (1-uvc.l(r,i)/ac.l(r,i)) / ; ) ;
      loop(i$(xp.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'fc',    i.tl, '', '', t.tl,
         (nfirm.l(r,i)*(sum(l,swage.l(r,l,i)*sldf.l(r,l,i)) + rent.l(r,i,"old")*kapdf.l(r,i))/xp.l(r,i)) / ; ) ;

$ontext
      loop(gz, put sim.tl, r.tl, 'va1',  gz.tl, '', '', t.tl, va1T(r,gz,t)   / ; ) ;
      loop(gz, put sim.tl, r.tl, 'rva1', gz.tl, '', '', t.tl, rva1T(r,gz,t)  / ; ) ;
      loop(gz, put sim.tl, r.tl, 'va2',  gz.tl, '', '', t.tl, va2T(r,gz,t)   / ; ) ;
      loop(gz, put sim.tl, r.tl, 'rva2', gz.tl, '', '', t.tl, rva2T(r,gz,t)  / ; ) ;


      loop(gz, put sim.tl, r.tl, 'pp1', gz.tl,  '', '', t.tl, pp1T(r,gz,t)  / ; ) ;
      loop(gz, put sim.tl, r.tl, 'pa1', gz.tl,  '', '', t.tl, pa1T(r,gz,t)  / ; ) ;
$offtext

      loop(i$(ffT(r,i,t) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pf', i.tl, '', '', t.tl, pfT(r,i,t) / ; ) ;
      loop(i$(ffT(r,i,t) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ff', i.tl, '', '', t.tl, ffT(r,i,t) / ; ) ;

      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'exprod', i.tl, '', '', t.tl, exprodT(r,i,t) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'avgexp', i.tl, '', '', t.tl, avgexpT(r,i,t) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'chip',   i.tl, '', '', t.tl, chipT(r,i,t)   / ; ) ;

      loop(l$(ord(l) eq 1), loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'lambdal', i.tl, '', '', t.tl, (lambdal.l(r,l,i)) / ; ) ; ) ;
      loop(v$(ord(v) eq 1),   loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'lambdak', i.tl, '', '', t.tl, (lambdak.l(r,i,v))  / ; ) ; ) ;

      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'swage', i.tl, '', '', t.tl, swageT(r,i,t) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'srent', i.tl, '', '', t.tl, srentT(r,i,t) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'spap',  i.tl, '', '', t.tl, spapT(r,i,t)  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'slab',  i.tl, '', '', t.tl, slabT(r,i,t)  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'skap',  i.tl, '', '', t.tl, skapT(r,i,t)  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'sland', i.tl, '', '', t.tl, slandT(r,i,t) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'sfact', i.tl, '', '', t.tl, sfactT(r,i,t) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'snd',   i.tl, '', '', t.tl, sndT(r,i,t)   / ; ) ;

      loop((rp,i), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'tar',   i.tl, rp.tl, '', t.tl, tar.l(rp,r,i)   / ; ) ;

      loop(ia,
         work = sum(i$mapi(ia,i), pp0(r,i)*xpT(r,i,t)) ;
         if (work ne 0, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xp'   , ia.tl, '', '', t.tl, (work) / ; ) ;
      ) ;
      loop(ia,
         work = sum(i$mapi(ia,i), esT(r,i,t)) ;
         if (work ne 0, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'es_total'   , ia.tl, '', '', t.tl, (work) / ; ) ;
      ) ;
      loop(ia,
         work = sum(i$mapi(ia,i), esT0(r,i,t)) ;
         if (work ne 0, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'es'   , ia.tl, '', '', t.tl, (work) / ; ) ;
      ) ;
      loop(ia,
         work = sum(i$mapi(ia,i), xmtT(r,i,t)) ;
         if (work ne 0, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xm'   , ia.tl, '', '', t.tl, (work) / ; ) ;
      ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xd'   , i.tl, '', '', t.tl, xdT(r,i,t)    / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xa'   , i.tl, '', '', t.tl, xaT(r,i,t)    / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pp'   , i.tl, '', '', t.tl, ppT(r,i,t)    / ; ) ;
      loop((i,v), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pva'  , i.tl, v.tl, '', t.tl, pva.l(r,i,v)    / ; ) ;
*     loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ac'   , i.tl, '', '', t.tl, ac.l(r,i)     / ; ) ;
*     loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'px'   , i.tl, '', '', t.tl, px.l(r,i)     / ; ) ;
*     loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'uvc'  , i.tl, '', '', t.tl, uvc.l(r,i)    / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ppe'  , i.tl, '', '', t.tl, ppeT(r,i,t)   / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pd'   , i.tl, '', '', t.tl, pdT(r,i,t)    / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pmt'  , i.tl, '', '', t.tl, pmtT(r,i,t)   / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pa'   , i.tl, '', '', t.tl, paT(r,i,t)    / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'profit', i.tl, '', '', t.tl, (rscale*profit.l(r,i)) / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'nfirm',  i.tl, '', '', t.tl, (nfirm.l(r,i)) / ; ) ;

      loop(ia, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'SectExp', ia.tl, '', '', t.tl, (rscale*sum(i$mapi(ia,i),sum(rp,wpe0(r,rp,i)*wtf.l(r,rp,i)))) / ; ) ;
      loop(ia, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'SectImp', ia.tl, '', '', t.tl, (rscale*sum(i$mapi(ia,i),sum(rp,wpm0(rp,r,i)*wtf.l(rp,r,i)))) / ; ) ;

      loop(i$(kaptx.l(r,i,"Old") ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'KapTx', i.tl, '', '', t.tl,  (KapTx.l(r,i,"Old"))  / ; ) ;
      loop(i$(kapts.l(r,i,"Old") ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'KapTs', i.tl, '', '', t.tl,  (KapTs.l(r,i,"Old"))  / ; ) ;
      loop(i$(LndTx.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'LndTx', i.tl, '', '', t.tl,  (LndTx.l(r,i))  / ; ) ;
      loop(i$(LndTs.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'LndTs', i.tl, '', '', t.tl,  (LndTs.l(r,i))  / ; ) ;
      loop(i$(ptax.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ptax', i.tl, '', '', t.tl,  (ptax.l(r,i))  / ; ) ;

      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wepit', i.tl, '', '', t.tl, wepiT(r,i,t)  / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wmpit', i.tl, '', '', t.tl, wmpiT(r,i,t)  / ; ) ;

      loop(i,
         work = sum(rp$(ord(rp) ne ord(r)),wpe0(r,rp,i)*wtf0(r,rp,i)) ;
        if (work ne 0,
           put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wepitx', i.tl, '', '', t.tl,
              (sum(rp$(ord(rp) ne ord(r)), wpe.l(r,rp,i)*wtf0(r,rp,i))/work)  / ;
        ) ;
      ) ;

      loop(i,
         work = sum(rp$(ord(rp) ne ord(r)),wpm0(rp,r,i)*lambdaw(rp,r,i)*wtf0(rp,r,i)) ;
         if (work ne 0,
            put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wmpitx', i.tl, '', '', t.tl,
               (sum(rp$(ord(rp) ne ord(r)), wpm.l(rp,r,i)*lambdaw(rp,r,i)*wtf0(rp,r,i))/work)  / ;
         ) ;
      ) ;

      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xap'  , i.tl, '', '', t.tl, xapT(r,i,t)   / ; ) ;
      loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xaf'  , i.tl, '', '', t.tl, xafT(r,i,t)   / ; ) ;

$ontext
      loop(gz, loop(l$(labs0(r,l,gz) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'labs',  l.tl, gz.tl, t.tl, (rscale*labs.l(r,l,gz))  / ; )) ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, "labfpr",    '', '', '', t.tl, (rscale*sum(l,sum(gs,labs.l(r,l,gs)))/pop.l(r,"P1565")) / ;
      put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, "labfprtot", '', '', '', t.tl, (rscale*sum(l,sum(gs,labs.l(r,l,gs)))/pop.l(r,"PTOTL")) / ;
      loop((ia,l),
         work = sum(i$mapi(ia,i), labdv.l(r,l,i)+nfirm.l(r,i)*labdf.l(r,l,i)) ;
         if (work ne 0, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'labd',  l.tl, ia.tl,  t.tl, (rscale*work)  / ; ) ;
      ) ;
      loop(i,  loop(l$(labdv0(r,l,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wage',  l.tl, i.tl,  t.tl, (wage.l(r,l,i))  / ; )) ;
      loop(gz, loop(l$(labs0(r,l,gz) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'twage', l.tl, gz.tl, t.tl, twage.l(r,l,gz) / ; )) ;
      loop(gz, loop(l$(labs0(r,l,gz) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'awage', l.tl, gz.tl, t.tl, avgw.l(r,l,gz) / ; )) ;
      loop(gz, loop(l$(labs0(r,l,gz) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ue',    l.tl, gz.tl, t.tl, ue.l(r,l,gz) / ; )) ;
      loop(gz, loop(l$(labs0(r,l,gz) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wmin',  l.tl, gz.tl, t.tl, wmin.l(r,l,gz) / ; )) ;
      loop(l, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, "migr", l.tl, "L1", t.tl, (rscale*migr.l(r,l)) / ; ) ;
$offtext
      loop((l,rt)$(migr.l(r,l,rt) ne 0),
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, "migr", l.tl, '', rt.tl, t.tl, (pscale*migr.l(r,l,rt)) / ;
      ) ;

*!!!! temporary

      loop((l,lm,rt)$(ls0(r,lm,l,rt) ne 0),
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'awage', l.tl, lm.tl, rt.tl, t.tl, awage.l(r,lm,l,rt) / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ue',    l.tl, lm.tl, rt.tl, t.tl, (100*ue.l(r,lm,l,rt)) / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wmin',  l.tl, lm.tl, rt.tl, t.tl, wmin.l(r,lm,l,rt) / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ls',    l.tl, lm.tl, rt.tl, t.tl, ls.l(r,lm,l,rt) / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ld',    l.tl, lm.tl, rt.tl, t.tl, (sum(gz$maplm(gz,lm), tldr.l(r, gz, l, rt)))  / ;
      ) ;
      loop((gz,l,rt)$(tldr0(r,gz,l,rt) ne 0),
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'tldr', l.tl, gz.tl, rt.tl, t.tl, (tldr.l(r, gz, l, rt))  / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'wage', l.tl, gz.tl, rt.tl, t.tl, (wage.l(r, gz, l, rt))  / ;
      ) ;

      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xc'   ,  k.tl, h.tl, '', t.tl, xcT(r,k,h,t)   / ; )) ;
      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pc'   ,  k.tl, h.tl, '', t.tl, pcT(r,k,h,t)   / ; )) ;
      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'mpc'   , k.tl, h.tl, '', t.tl, mpcT(r,k,h,t)   / ; )) ;
      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'theta' , k.tl, h.tl, '', t.tl, (rscale*thetaT(r,k,h,t)) / ; )) ;
      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'cshr' ,  k.tl, h.tl, '', t.tl, (cshrT(r,k,h,t)) / ; )) ;
      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'eta'   , k.tl, h.tl, '', t.tl, etaT(r,k,h,t)   / ; )) ;
      loop(k,loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ued'   , k.tl, h.tl, '', t.tl, uedT(r,k,k,h,t)   / ; )) ;
      loop(h, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'frisch'   , h.tl, '', '', t.tl, frisch(r,h)   / ; ) ;

      if(0 and ord(t) eq 1,
         loop(i,loop(j$(xap0(r,i,j) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xap',   i.tl, j.tl, 'Benchmark', (rscale*xap.l(r,i,j)) / ; )) ;
         loop(i,loop(j$(patax0(r,i,j) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'patax', i.tl, j.tl, 'Benchmark',  patax.l(r,i,j)      / ; )) ;
         loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl,        'pa',    i.tl, '',   'Benchmark', (pa.l(r,i))          / ; ) ;

         loop(i$(kaptx.l(r,i,"Old") ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'KapTx', i.tl, '', 'Benchmark',  KapTx.l(r,i,"Old")                   / ; ) ;
         loop(i$(kapts.l(r,i,"Old") ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'KapTs', i.tl, '', 'Benchmark',  KapTs.l(r,i,"Old")                   / ; ) ;
         loop(i$(kapdT(r,i,t) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'nrent',  i.tl, '', 'Benchmark', (rentT(r,i,t)/(1+KapTx.l(r,i,"Old")+KapTs.l(r,i,"Old"))) / ; ) ;
         loop(i$(kapdT(r,i,t) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'kapd',   i.tl, '', 'Benchmark', (kapdT(r,i,t))                   / ; ) ;

         loop(i$(LndTx.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'LndTx', i.tl, '', 'Benchmark',  LndTx.l(r,i)                 / ; ) ;
         loop(i$(LndTs.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'LndTs', i.tl, '', 'Benchmark',  LndTs.l(r,i)                 / ; ) ;
         loop(i$(td.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'pt',     i.tl, '', 'Benchmark', (ptT(r,i,t)/(1+LndTx.l(r,i)+LndTs.l(r,i))) / ; ) ;
         loop(i$(td.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'td',     i.tl, '', 'Benchmark', (rscale*td.l(r,i))              / ; ) ;

         loop(i$(ptax.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'ptax', i.tl, '', 'Benchmark', ptax.l(r,i)       / ; ) ;
         loop(i$(xp.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'px',   i.tl, '', 'Benchmark', px.l(r,i)         / ; ) ;
         loop(i$(xp.l(r,i) ne 0), put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'xp',   i.tl, '', 'Benchmark', (rscale*xp.l(r,i)) / ; ) ;
      ) ;


      loop(gi,loop(gts, put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'GovAcct' , gi.tl, gts.tl,  '', t.tl, GovAcctT(r,gi,gts,t)   / ; )) ;

*     Model parameters
	  loop(i, 
	  	 put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'g', i.tl, '', '', t.tl, g(r,i) / ;
	  ) ;
	  
      loop(i,
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'yelasArmM', i.tl, '', '', t.tl, yelasArmM(r,i) / ;
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'sigmam',    i.tl, '', '', t.tl, sigmam(r,i) / ;
*        put sim.tl, r.tl, 'prodshft',  i.tl, '', '', t.tl, (100*prodshftT(r,i,t)/(1-alphap(r,i))) / ;
      ) ;

*     put sim.tl, r.tl, 'cadj', '', '', '', t.tl, cadj(r,t) / ;


      if (ifELES eq 3,

*        AIDADS

         loop(h,
            psiT(r,h,t) = sum(k$(cshrT(r,k,h,t) ne 0),(betaAD(r,k,h)-alphaAD(r,k,h))*log(xcT(r,k,h,t)/hpopT(r,h,t)-thetaT(r,k,h,t)))
                       -  ((1+exp(uadT(r,h,t)))**2)/exp(uadT(r,h,t)) ;
            psiT(r,h,t) = 1/psiT(r,h,t) ;

            loop(k$(cshrT(r,k,h,t) ne 0),
               work = (alphaAD(r,k,h)+betaAD(r,k,h)*exp(uadT(r,h,t)))/(1+exp(uadT(r,h,t))) ;
               put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'mu_ad', k.tl, '', '', t.tl, (100*work) / ;
               s_a(r,k) = (work-(betaAD(r,k,h)-alphaAD(r,k,h))*psiT(r,h,t))/cshrT(r,k,h,t) ;
               put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'eta_ad', k.tl, '', '', t.tl, (s_a(r,k)) / ;
               s_a(r,k) = (work - 1)*work*supyT(r,h,t)/(cshrT(r,k,h,t)*ycT(r,h,t)) - cshrT(r,k,h,t)*s_a(r,k) ;
               put sim.tl, isen.tl, iisen.tl, iiisen.tl, r.tl, 'eps_ad', k.tl, '', '', t.tl, (s_a(r,k)) / ;
            ) ;
         ) ;
      ) ;

*  End of r loop

   ) ;

*  Global variables

   loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, 'GBL', 'AWP',   i.tl, '', '', t.tl, AWPT(i,t) / ; ) ;
   loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, 'GBL', 'WP',    i.tl, '', '', t.tl, WP.l(i) / ; ) ;
   loop(i, put sim.tl, isen.tl, iisen.tl, iiisen.tl, 'GBL', 'chifs', i.tl, '', '', t.tl, chifs.l(i) / ; ) ;
   loop(i,
      work = sum(r,sum(rp$(ord(r) ne ord(rp)), wpe0(r,rp,i)*wtf0(r,rp,i))) ;
      if (work ne 0,
         put sim.tl, isen.tl, iisen.tl, iiisen.tl, 'GBL', 'AWPX', i.tl, '', '', t.tl,
            (sum(r,sum(rp$(ord(r) ne ord(rp)),wpe.l(r,rp,i)*wtf0(r,rp,i)))/work) / ;
      ) ;
   ) ;
   put sim.tl, isen.tl, iisen.tl, iiisen.tl, 'GBL', 'ifEles', '', '', '', t.tl, ifEles / ;

*  End of ifCSV
) ;
