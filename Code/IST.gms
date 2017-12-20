$title  iron and steel sector in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read ist data
2) calibration of benchmark
3) covert from value unit (Yuan) to physical unit (GWh)
4) calibration of substitution elasticities between fixed factor and other inputs for elecpower

Revision Logs:
* the current version is far from finished
*0723, add backstop technologies for elec and ist

Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
Parameter Isprop(*,*) proportion of sub-IST sectors;
$GDXIN %DataPath%\IST_TR_Output.gdx
$LOAD Isprop
$GDXIN

*DISPLAY Isprop;

$Ontext
Isprop(i,"BOF")= 0.911;
Isprop("labor","BOF")= 0.911;
Isprop("capital","BOF")= 0.911;
Isprop("tax","BOF")= 0.911;
Isprop(i,"EAF")= 0.089;
Isprop("labor","EAF")= 0.089;
Isprop("capital","EAF")= 0.089;
Isprop("tax","EAF")= 0.089;
$offtext

parameter
         list0          labor in ist generation
         kist0          capital in ist generation
         intist0        intermediate input to ist generation
         taxist0
         outputist0     output of ist generation
         Toutputist0                                             ;


list0(sub_ist) =       isprop("labor",sub_ist)*fact0("labor","IST") ;
kist0(sub_ist) =       isprop("capital",sub_ist)*fact0("capital","IST")  ;
intist0(i,sub_ist) =   isprop(i,sub_ist)*int0(i,"IST")  ;
taxist0(sub_ist)=      isprop("tax",sub_ist)*sam("tax","IST");
outputist0(sub_ist)=   list0(sub_ist)+kist0(sub_ist)+sum(i,intist0(i,sub_ist))+taxist0(sub_ist);
taxist0(sub_ist)$outputist0(sub_ist)=taxist0(sub_ist)/outputist0(sub_ist);
Toutputist0         =   sum(sub_ist,outputist0(sub_ist));

*== set emission for electricity sector
parameter emissionist0(pollutant,pitem,*,*)  ist emission by source ;

emissionist0('co2','e',fe,sub_ist)=ccoef_p(fe)*intist0(fe,sub_ist);

parameter test;
test("labor")=sum(sub_ist,list0(sub_ist))-fact0("labor","IST");
test("capital")=sum(sub_ist,kist0(sub_ist))-fact0("capital","IST") ;
test(i)=sum(sub_ist,intist0(i,sub_ist))-int0(i,"IST") ;
test("tax")=sum(sub_ist,taxist0(sub_ist))-sam("tax","IST") ;
test("output")=sum(sub_ist,outputist0(sub_ist))-output0("IST") ;

display emissionist0,test;


parameter laborist0;
laborist0(lm,sub_ist)=list0(sub_ist)/labor_w0(lm,"ist")*labor_v0(lm,"IST")/sum(lmm,labor_v0(lmm,"IST"));

display list0,kist0,intist0,outputist0,taxist0,tx0;

parameter ts_ist0(sub_ist) technology shares for ist sector
		  ts_ist(sub_ist) technology shares for ist sector;
	ts_ist0(sub_ist)=outputist0(sub_ist)/output0("ist");
	ts_ist(sub_ist)=ts_ist0(sub_ist);



