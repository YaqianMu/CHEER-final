$title backstop technology  in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read electricity data

Backstop Technologies:
NGCC 天然气联合循环


Revision Logs:
**backstop technology     
** to be finished
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*

*----------------------------------------------*

parameter active(bt);

active(bt)=0;
active("ngcap")=0;
active("igcap")=0;
table bsin(*,bt)   backstop input structure  for China
        ngcc         ngcap        igcap
gas     0.732        0.590
coal                              0.231
k       0.207        0.141        0.271
l       0.051        0.035        0.061
kseq                 0.199        0.045
lseq                 0.025        0.382
ffa     0.010        0.010        0.010
frseq                0.900        0.900
;

parameter bslin base labor input share for backstop technologies;
bslin("gen",lm,bt)=bsin("l",bt)*sum(sub_elec,laborelec0(lm,sub_elec))/sum((lmm,sub_elec),laborelec0(lmm,sub_elec));
bslin("CCS",lm,bt)=bsin("lseq",bt)*sum(sub_elec,laborelec0(lm,sub_elec))/sum((lmm,sub_elec),laborelec0(lmm,sub_elec));

parameter emissionbt0 base emission for backstop technologies;
emissionbt0('co2','e',fe,bt)=ccoef_p(fe)*bsin(fe,bt);

*== delete the T&D cost in the original EPPA data
$ontext
table bsin(bt,*,*)   backstop input structure

                        usa     can     mex     jpn     anz     eur     roe     rus     asi     chn     ind     bra     afr     mes     lam     rea     kor     idz
ngcc    .       gas     0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695  0.5695
ngcc    .       k       0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611  0.1611
ngcc    .       l       0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396  0.0396
ngcc    .       ktd     0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465  0.1465
ngcc    .       ltd     0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733  0.0733
ngcc    .       ffa     0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100

ngcap   .       gas     0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936  0.4936
ngcap   .       k       0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180  0.1180
ngcap   .       l       0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290  0.0290
ngcap   .       kseq    0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670  0.1670
ngcap   .       lseq    0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213  0.0213
ngcap   .       ktd     0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074  0.1074
ngcap   .       ltd     0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537  0.0537
ngcap   .       ffa     0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100
ngcap   .       frseq   0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000

igcap   .       coal    0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962  0.1962
igcap   .       k       0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303  0.2303
igcap   .       l       0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515  0.0515
igcap   .       lseq    0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381  0.0381
igcap   .       kseq    0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237  0.3237
igcap   .       ktd     0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001  0.1001
igcap   .       ltd     0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500  0.0500
igcap   .       ffa     0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100  0.0100
igcap   .       frseq   0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000  0.9000
;

$offtext

parameter  bmkup(bt)  backstop markup factor       /
ngcc        1.058
ngcap       1.445
igcap       1.55     /
;

*bmkup(bt)=bmkup(bt)*10;

table esub_bt(*,*) substitution elasticity for backstop technologies

        ngcc         ngcap        igcap
NR      0.2          0.15         0.2
GVA     0.5          0.5          0.5
SVA     0.5          0.5          0.5
;

* specify backstop penetration pattern:

* backstop level at t is no more than "inish" of energy level
* (conventional + backstop) in t-1.
* have tried logistic smoothing and other schemes, dropped later.

parameters

inish(bt)     initial share of backstop penetration
bbres(bt,t)     BAU backstop resource supply by t
bres(bt)     backstop resource supply by t
;

* old inish from EPPA5
*inish(bt,r)      = 0.003;
* new inish from Jen and John.  YHC: 20140821
inish(bt)      = 0.014;


* For backstop technologies (ngcc and ngcap share the same resource supply)
bbres(bt,"2012")     = max(0.00001, bsin("ffa",bt)*inish(bt)*output0("elec"));

bres(bt)= bbres(bt,"2012");


*backstop technologies for IST sector
$ontext
*Schumacher, 2007
			BOF		BOFA	EAF		EAFA
electricity	5.13	4.87	11.78	8.05
coal		4.54	4.08		
coke		9.88	8.89	
$offtext	


parameter bsrist(*,bt)   backstop input reduction proporation;
bsrist(i,bt)=1;
bsrist(lm,bt)=1;
bsrist("capital",bt)=1;

bsrist("elec","BOFA")=0.949;
bsrist("coal","BOFA")=0.899;
bsrist("elec","EAFA")=0.683;
bsrist("oilgas","EAFA")=0;
bsrist("gas","EAFA")=0;