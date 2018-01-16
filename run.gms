$Title           Run CHEER model
*=============================================================================
$ontext
This file is wrote to link all the files of CHEER model and run the simulation
*check before run

*===========labor============
*rigid wage?  ---core
*labor type   ---labor market
*labor q or v?   ---labor market
*umemployment  ---core
*labor structure ---dynamic

*===========learning curve===
*--- dynamic

*===========renewable========
*fixed subsidy? exogenous subsidy? renewable quota?

*===========emission cap========
*the quantity of emission cap
*the coverage of sectors

By Yaqian Mu
Please send comments to muyaqian13@gmail.com
January 2017
$offtext

*========Path Variable========
$if not set CalPath $set CalPath code
$if not set DataPath $set DataPath data
$if not set ModPath $set ModPath model
$if not set DynPath $set DynPath dynamic
$if not set RepPath $set RepPath report
$if not set OutPath $set OutputPath Output
$if not set SimPath $set SimPath Experiment

$if not set ExpPath $set ExpPath TR
*$if not set ExpPath $set ExpPath experiment


parameter Switch_labor(*) switch for labor aggregation ;
Switch_labor("gender")=0;
Switch_labor("region")=0;
Switch_labor("education")=1;

*== bridge variable for labor aggregation
$if not set Labagg $set labagg _2L

*== bridge variable for data aggregation
*$if not set datagg $set datagg output
*gas is split from oilgas
$if not set datagg $set datagg oilgas

*== bridge variable for model choice
$if not set modstr $set modstr _Developing

*== bridge variable for simulation choice
$if not set simsce $set simsce _RE

*========workflows========
*== definition of sets
$include %CalPath%/sets%labagg%

*========Switch variable========
parameter Switch_urban(*) switch for urban emission ;
switch_urban(i)=1;
switch_urban('fd')=1;

parameter Switch_feed switch for feedstock ;
Switch_feed=1;

parameter Switch_learn switch for learning effect ;
Switch_learn=1;

parameter Switch_um switch for umemployment ;
Switch_um=1;

parameter Switch_umc switch for umemployment cost;
Switch_umc=1;

parameter Switch_bt switch for backstop technologies ;
Switch_bt(bt)=0;
*Switch_bt(bt_ist)=1;

parameter Switch_pc switch for process co2 emission ;
Switch_pc(i)=0;
Switch_pc("cm")=1;

parameter Switch_fee switch for additional renewable fees  ;
*1=endogenous; 2=exogenous;
Switch_fee=1;

parameter switch_ist switch for disaggregated ist production;
switch_ist=1;

parameter switch_vk switch for vintage production;
switch_vk=0;

parameter switch_nfs switch for non-fossil share;
switch_nfs=0;

parameter switch_inv switch for elec investment;
switch_inv=1;

*== in the data process to change the feed stock rate
*parameter Switch_feed switch for feedstock ;


*== data and calibration
$include %CalPath%/cal
$include %CalPath%/elasticities
$include %CalPath%/emission
$include %CalPath%/labor
$include %CalPath%/electricity
$include %CalPath%/ist
$include %CalPath%/backstop
$include %CalPath%/vintage
$include %CalPath%/ParShock
$include %DynPath%/trend

*// core model
$include %ModPath%/core%modstr%
$include %SimPath%/Sim_Test

*========static simulation========
*$include %SimPath%/sim%simsce%

*========dynamic simulation========
*$include %DynPath%/dyncal
*=======calibration of BAU
*1st run
*$include %DynPath%/dynamic_cal
*$include %DynPath%/dynamic_BAU

*=======Policy shock
*$include %DynPath%/dynamic_shock

*2nd run
*$include %DynPath%/dynamic_BAU2
*$include%DynPath%/ dynamic_shock2

*$include %DynPath%/dynamic_shock3



$stop
