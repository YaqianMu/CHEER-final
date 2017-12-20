$title calibration for general Parameters in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read SAM data
2) calibration of general Parameters

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
*==read IO data from gdx
*----------------------------------------------*
*$CALL GDXXRW.EXE %DataPath%\data.xlsx o=%DataPath%\data.gdx par=sam rng=A1

Parameter IOTR(*,*) IO data gegerated from the data process;
$GDXIN %DataPath%\IO_%ExpPath%_%datagg%.gdx
*$GDXIN %DataPath%\IO_%ExpPath%_oilgas.gdx
$LOAD IOTR
$GDXIN

*----------------------------------------------*
*=== transfer unit to billion yuan
*----------------------------------------------*
Parameter SAM(*,*);
sam(i,j)=IOTR(i,j)/100000;
sam(f,i)=IOTR(f,i)/100000;
sam(i,fd)=IOTR(i,fd)/100000;
sam('tax',i)=IOTR('tax',i)/100000;

DISPLAY SAM;

*----------------------------------------------*
*==definition  of benchmark parameters
*----------------------------------------------*

parameters
*==parameters to extract the benchmark

int0           intermediate inputs
fact0          factor inputs to industry sectors
tax0           net tax payments to industry sectors
tx0            tax rate on industry output
output0        sectoral gross output
fact           aggregate factor supplies

inv0           sectoral investment in physical capital
invf0          factor investment in physical capital
xinv0          exogenous(negative) sectoral investment in physical capital
xinvf0         exogenous(negative) factor investment in physical capital

cons0          consumption of conmmodities
consf0         direct consumption of factor services
xcons0         exogenous(negative) consumption of commodities
xconsf0        exogenous(negative) consumption of factor services

exp0           benchmark commodity exports
imp0           benchmark commodity imports


xexp0          exogenous(negative) benchmark commodity exports
ximp0          exogenous(negative) benchmark commodity imports

expf0          benchmark factor exports
impf0          benchmark factor imports

xexpf0         exogenous(negative) benchmark factor exports
ximpf0         exogenous(negative) benchmark factor imports

nx0            net commodity exports
nxf0           net factor exports

*==fixed factor parameters

theta(x)     imputed fixed factor share of capital      from GTAP-E
/coal       0.68
 Oilgas     0.51
 mine       0.07
 agri       0.28
 gas        0.59
/
ffact0        benchmark fixed factor supply

*==parameter to scale exogenous endowments
xscale;

*----------------------------------------------*
*==calibrate benchmark quantities
*----------------------------------------------*

int0(i,j)   = sam(i,j);
fact0(f,j)  = sam(f,j);
ffact0(x)   = theta(x)*sam("capital",x);
fact0("capital",x) =(1-theta(x))*sam("capital",x);

display ffact0,fact0,int0;

inv0(i)     =max(0,sam(i,"investment"));
invf0(f)    =max(0,sam(f,"investment"));

xinv0(i)     =min(0,sam(i,"investment"));
xinvf0(f)    =min(0,sam(f,"investment"));

cons0(i)    =max(0,sam(i,"Household"))+max(0,sam(i,"GOVERNMENT"));
consf0(f)   =max(0,sam(f,"Household"))+max(0,sam(f,"GOVERNMENT"));

xcons0(i)    =min(0,sam(i,"Household"))+min(0,sam(i,"GOVERNMENT"));
xconsf0(f)   =min(0,sam(f,"Household"))+min(0,sam(f,"GOVERNMENT"));

exp0(i)    =max(0,sam(i,"export"));
expf0(f)   =max(0,sam(f,"export"));

xexp0(i)    =min(0,sam(i,"export"));
xexpf0(f)   =min(0,sam(f,"export"));

imp0(i)    =max(0,-sam(i,"import"));
impf0(f)   =max(0,-sam(f,"import"));

ximp0(i)    =min(0,-sam(i,"import"));
ximpf0(f)   =min(0,-sam(f,"import"));

nx0(i)      =exp0(i)-imp0(i)-(xexp0(i)-ximp0(i));
nxf0(f)     =expf0(f)-impf0(f)-(xexpf0(f)-ximpf0(f));

output0(i)  =sum(j,sam(i,j))+inv0(i)+cons0(i)+nx0(i)+(xinv0(i)+xcons0(i));

fact(f)     =sum(j,fact0(f,j))+invf0(f)+consf0(f)+nxf0(f)+(xinvf0(f)+xconsf0(f));

display inv0,xinv0,cons0,xcons0,nx0,output0,xexp0,exp0,fact;


tax0(j)    =sam("tax",j);

display   tax0;

tx0(j)$output0(j)     =tax0(j)/output0(j);

display   tx0;

xscale     =1;

parameter
etemp;
etemp(e)    =(output0(e)-(nx0(e)+xinv0(e)+xcons0(e)));

*==armington good
parameter a0;
a0(i)     =output0(i)-ximp0(i);
display a0,output0,imp0,ximp0,nx0,inv0,cons0,xinv0,xcons0,sub_elec;


