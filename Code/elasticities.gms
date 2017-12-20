$title  elasticity in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) substitution elasticities in the production blocks
2) supply elasticities for factors

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext

*----------------------------------------------*
*==substitution elasticities
*----------------------------------------------*

*==subsititution elasticities from Ke Wang
table esub(*,*)     elasticity of substitution in the production functions
          Elec       Coal       Oil        Roil       Gas        Agri       mine       Food       Paper      Chem       CM         IST        NFM        EII        OM         Air        Tran       Serv
TOP       0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0
NR        0.3        0.5        0.5        0.3        0.5        0.3        0.3        0.3        0.3        0.3        0.3        0.3        0.3        0.3        0.3        0.3        0.3        0.3
IT        0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0
KLE       0.1        0.8        0.8        0.8        0.8        0.6        1          1          1          1          1          1          1          1          1          1          1          1
KL        1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1
E         0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5        0.5
NELE      1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1
;

parameter
           esub_inv     elasticity of substitution among inputs to investment
           esub_c       elasticity of substitution among inputs to consumption
           esub_wf      elasticity of substitution of investment and consumption in the welf function
;

esub_c("TOP")     =0.25 ;
esub_c("NE")     =0.3 ;
esub_c("E")     =0.4 ;

esub_inv   =5;

*wangke=1；EPPA=0
*esub_wf    =1;
esub_wf    =0;


*==electricity sector
*==substitution elasticity between fixed factor and other inputs is calibrated in electricity block
*parameter   enesta   substitution elasticity between different sub_elec    from EPPA 6; enesta=1.5;

parameter   esub_gt substitution elasticity between generation and T&D
            esub_pe   substitution elasticity between peak load technologies
            esub_be   substitution elasticity between base load technologies
;
esub_gt=0;
esub_pe=1.5;
esub_be=1.5;


table esub_elec(*,*)   substitution elasticity in electricity sector
        T_D         Coal_Power         Gas_Power         Oil_Power         Nuclear         Hydro         Wind         Solar         Biomass
NR                                                                         0.6             0.5           0.25         0.2           0.2
*NR                                                                         0.2             0.2           0.1         0.2           0.1
IT       0              0                  0                 0             1               1             1            1             1
KLE                     0.1                0.1               0.1
KL                      1                  1                 1             1               1             1            1             1
E                       1.5                1.5               1.5

;
*==labor market
parameter esub_LabDist  substitution elasticity in the CET founction to allocate labor among sectors
          esub_l        substitution elasticity between different labor inputs ;

esub_LabDist(lm) = 1;
esub_l("l")      = 1;
esub_l("ll")=1.5;
esub_l("lh")=1.5;

*eslm("l")=1;
*eslm("ll")=0;
*eslm("lh")=0;

*----------------------------------------------*
*==supply elasticities
*----------------------------------------------*
parameter
eta           fixed factor supply elasticity;

eta("coal") =2.0;
eta("Oil")=1.0;
eta("agri")=0.5;
eta("mine")=2.0;
eta("gas")=1.0 ;
eta("elec")= 1;

eta("biomass")= 0.5 ;
eta("hydro")= 0.1;
eta("wind")= 1.5 ;
eta("solar")= 1.5 ;
eta("nuclear")= 0.5 ;
