* --
* -- PANDA - PRC Aggregate National Development Assessment Model
* --
* --           All rights reserved
* --
* --           David Roland-Holst, Samuel G. Evans
* --           Cecilia Han Springer, and MU Yaqian
* --
* --           Berkeley Energy and Resources, BEAR LLC
* --           1442A Walnut Street, Suite 108
* --           Berkeley, CA 94705 USA
* --
* --           Email: dwrh@berkeley.edu
* --           Tel: 510-220-4567
* --           Fax: 510-524-4591
* --
* --           October, 2016

* --

* -- postscn.gms
* --
* -- This file produces scnulation results in Excel compatible CSV files
* -- Two files are produced for each interval, a reportfile containing desired scnulation variables,
* --      and a samfile containing complete Social Accounting Matrices
* --


*=====================================generation of accounting scalar====================

*=====================================transfer to csv file================================

* ----- Output the results


put reportfile ;


* ----- Sectoral results

loop(i,
  put sce.tl, rate(z),'2012', 'output', i.tl, '','','output', (qdout.l(i)),CHEER.modelstat / ;

  put sce.tl, rate(z),'2012', 'Sectoral price', i.tl, '','','price', (py.l(i)),CHEER.modelstat / ;
  loop(lm,
  put sce.tl, rate(z),'2012', 'employment', i.tl, '',lm.tl,'employment', (qlin.l(lm,i)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'Sectoral wage', i.tl, '',lm.tl,'Sectoral wage', (pl.l(lm,i)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'employment intensity', i.tl, '',lm.tl,'employment intensity', (report4(z,lm,i)),CHEER.modelstat / ;
      );
  put sce.tl, rate(z),'2012', 'employment intensity', i.tl, '','total','employment intensity', (report4(z,'total',i)),CHEER.modelstat / ;
) ;

loop(sub_elec,
  put sce.tl, rate(z),'2012', 'elec_output', '', sub_elec.tl,'','elec_output' , (qelec.l(sub_elec)),CHEER.modelstat / ;
  loop(lm,
  put sce.tl, rate(z),'2012', 'employment','', sub_elec.tl ,lm.tl,'employment', (qlin_ele.l(lm,sub_elec)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'employment intensity', '', sub_elec.tl,lm.tl,'employment intensity', (report4(z,lm,sub_elec)),CHEER.modelstat / ;
      );
  put sce.tl, rate(z),'2012', 'employment intensity', '', sub_elec.tl,'total','employment intensity', (report4(z,'total',sub_elec)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'output', '', sub_elec.tl,'','output', (qelec.l(sub_elec)),CHEER.modelstat / ;
) ;

* ----- emission results

loop(i,
  put sce.tl, rate(z),'2012', 'ECO2', i.tl, '','','ECO2', (report2(z,i)),CHEER.modelstat / ;
) ;

put sce.tl, rate(z),'2012', 'ECO2', 'fd', '','','ECO2', (report2(z,"fd")),CHEER.modelstat / ;
put sce.tl, rate(z),'2012', 'ECO2', '','total' ,'','ECO2', (report2(z,"total")),CHEER.modelstat / ;

loop(i,
  put sce.tl, rate(z),'2012', 'ESO2', i.tl, '','','ESO2', (report1(z,'so2',i)),CHEER.modelstat / ;
) ;

put sce.tl, rate(z),'2012', 'ESO2', 'fd', '','','ESO2', (report1(z,'so2',"fd")),CHEER.modelstat / ;
put sce.tl, rate(z),'2012', 'ESO2','' ,'total' ,'','ESO2', (report1(z,'so2',"total")),CHEER.modelstat / ;

loop(i,
  put sce.tl, rate(z),'2012', 'ENOX', i.tl, '','','ENOX', (report1(z,'NOX',i)),CHEER.modelstat / ;
) ;

put sce.tl, rate(z),'2012', 'ENOX', 'fd','' ,'','ENOX', (report1(z,'NOX',"fd")),CHEER.modelstat / ;
put sce.tl, rate(z),'2012', 'ENOX', '','total' ,'','ENOX', (report1(z,'NOX',"total")),CHEER.modelstat / ;

loop(sub_elec,
  put sce.tl, rate(z),'2012', 'elec_CO2','', sub_elec.tl ,'','elec_CO2' , (report3(z,sub_elec)),CHEER.modelstat / ;
) ;


* ----- employment results
loop(i,
loop(sub_elec,
put sce.tl, rate(z),'2012', 'IEE_id', i.tl, sub_elec.tl,'','IEE_id', (IEE_id(z,i,sub_elec)),CHEER.modelstat / ;
))
loop(lm,
  put sce.tl, rate(z),'2012', 'unemployment','' , '',lm.tl,'ur', (UR.l(lm)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'total employment', '', '',lm.tl,'total employment', (report6(z,lm,"total")),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'aggregated wage', lm.tl, '',lm.tl,'aggregated wage', (pls.l(lm)),CHEER.modelstat / ;
  loop(i,
  put sce.tl, rate(z),'2012', 'TEE', i.tl, '',lm.tl,'TEE', (TEE(z,lm,i)),CHEER.modelstat / ;
  loop(sub_elec,
  put sce.tl, rate(z),'2012', 'IEE', i.tl, sub_elec.tl,lm.tl,'IEE', (IEE(z,lm,i,sub_elec)),CHEER.modelstat / ;
  )
  )
  loop(sub_elec,
  put sce.tl, rate(z),'2012', 'DEE', '', sub_elec.tl,lm.tl,'DEE', (DEE(z,lm,sub_elec)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'TEE', '', sub_elec.tl,lm.tl,'TEE', (TEE(z,lm,sub_elec)),CHEER.modelstat / ;
  )
  put sce.tl, rate(z),'2012', 'TEE', '', 'total',lm.tl,'TEE', (TEE(z,lm,"total")),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'TEE_DE', '', '',lm.tl,'TEE_DE', (TEE_DE(z,lm,"total")),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'TEE_WE', '', '',lm.tl,'TEE_WE', (TEE_WE(z,lm,"Total")),CHEER.modelstat / ;
  loop(i,
  put sce.tl, rate(z),'2012', 'TEE_DE', i.tl, '',lm.tl,'TEE_DE', (TEE_DE(z,lm,i)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'TEE_WE', i.tl, '',lm.tl,'TEE_WE', (TEE_WE(z,lm,i)),CHEER.modelstat / ;
  )
  loop(sub_elec,
  put sce.tl, rate(z),'2012', 'TEE_DE', '', sub_elec.tl,lm.tl,'TEE_DE', (TEE_DE(z,lm,sub_elec)),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'TEE_WE', '', sub_elec.tl,lm.tl,'TEE_WE', (TEE_WE(z,lm,sub_elec)),CHEER.modelstat / ;
  )

);


* ----- macro results
  put sce.tl, rate(z),'2012', 'GDP', '', '','','GDP', rgdp.l,CHEER.modelstat / ;

*------- policy shock
loop(sub_elec,
  put sce.tl, rate(z),'2012', 'subsidy_b', '', sub_elec.tl,'','subsidy_b', subelec0(sub_elec),CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'subsidy', '', sub_elec.tl,'','subsidy0', t_re.l(sub_elec),CHEER.modelstat / ;
) ;
  put sce.tl, rate(z),'2012', 'pco2_ms', '', '','','carbon price', pco2_ms.l,CHEER.modelstat / ;
  put sce.tl, rate(z),'2012', 'pco2', '', '','','carbon price', pco2.l,CHEER.modelstat / ;
