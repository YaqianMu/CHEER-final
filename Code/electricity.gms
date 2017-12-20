$title  electricity sector in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read electricity data
2) calibration of benchmark
3) covert from value unit (Yuan) to physical unit (GWh)
4) calibration of substitution elasticities between fixed factor and other inputs for elecpower

Revision Logs:
*20151215 ���������޸ĺ󣬴���΢Сƫ���ffactor�йأ��Ժ�����
*20161201,����2012�����ݣ�ʹ���µĲ��ַ�����ԭ������electricity�ļ���

Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*

*----------------------------------------------*
*==Read electricity data
*----------------------------------------------*
Parameter sam_elec(*,*) input data of sub-electricity sectors
                laborelec0(*,*) employment quantity of sub-electricity sectors by labor types in  thousand persons
                laborelec_v0(*,*) labor compensation of sub-electricity sectors by labor types in  thousand persons
*Parameter elec_t(*,*)  electricity generation trend in 100 million kwh;
*Parameter mkup_t(*,*)  markup trend;
$GDXIN %DataPath%\electricity_%ExpPath%_%datagg%.gdx
*$GDXIN %DataPath%\electricity_%ExpPath%_oilgas.gdx
$LOAD sam_elec laborelec0 laborelec_v0

*----------------------------------------------*
*==calibration of benchmark
*----------------------------------------------*
parameter
          emkup           electricity markup
          emkup0          base year electricity markup
          p_ff            proportion of fix-factor;


*=== transfer unit from 10 thousand yuan to billion yuan
sam_elec(i,sub_elec)=sam_elec(i,sub_elec)/100000;
sam_elec(f,sub_elec)=sam_elec(f,sub_elec)/100000;
sam_elec('tax',sub_elec)=sam_elec('tax',sub_elec)/100000;

*=== transfer unit from 10 thousand person to thousand people
laborelec0(lmo,sub_elec)=laborelec0(lmo,sub_elec)*10;
laborelec0(lm,sub_elec)=sum(lmo$(maplmo(lmo,lm)),laborelec0(lmo,sub_elec));

DISPLAY sam_elec,laborelec0;

parameter
         ffshr           fraction of electric sector capital as fixed factor
         lelec0          labor in electricity generation
         kelec0          capital in electricity generation
         ffelec0         fixed factor in electricity generation
         intelec0        intermediate input to electricity generation
         taxelec0
         subelec0     Total subsidy in billion yuan
         outputelec0     output of electricity generation
         Toutputelec0
         subelec_b
         ecf0  initinal electricity comsumption fee to cover the renewable subsidy;

*== markup factor
         emkup(sub_elec)       =      1;
*         emkup("wind")    =      1.3;
*         emkup("solar")   =      2.5;
*         emkup("Biomass")     =      1.8;

         emkup0(sub_elec)      =      emkup(sub_elec);

        lelec0(sub_elec) =       sam_elec("labor",sub_elec)/emkup(sub_elec);
        kelec0(sub_elec) =       sam_elec("capital",sub_elec)/emkup(sub_elec);
        intelec0(i,sub_elec) =   sam_elec(i,sub_elec)/emkup(sub_elec);
        taxelec0(sub_elec)=      sam_elec("tax",sub_elec);

*==fixed factors for elecpower
*==to be updata
parameter theta_elec(sub_elec)     imputed fixed factor share of capital      from Sue Wing 2006


table ff_data(*,*) cost structure from Sue Wing
                 hydro      nuclear    Wind       Solar      Biomass
labor            24         13         17         7          19
capital          56         60         64         73         59
ff               19         27         20         20         22
;
theta_elec(sub_elec) =0;
theta_elec(sub_elec)$ff_data("ff",sub_elec) = ff_data("ff",sub_elec)/(ff_data("ff",sub_elec)+ff_data("capital",sub_elec));

ffelec0(sub_elec)   =    0;

ffelec0(sub_elec)   = theta_elec(sub_elec)*kelec0(sub_elec);
kelec0(sub_elec)   =(1-theta_elec(sub_elec))*kelec0(sub_elec);

display taxelec0,ffelec0;

*----------------------------------------------*
*==covert from value unit (Yuan) to physical unit (GWh)
*----------------------------------------------*
parameter q_gen(*) data for power generation by  technology in GWhfrom Stats
                subsidy(*)  total value of subsidy by technologies  in  10 thousand yuan
                P_elec(*)  Feed in tariff Price Yuan per kwh   Source Qi 2014 Energy Policy;

$LOAD q_gen subsidy P_elec
$GDXIN

*convert subsidy from 10 thousand yuan to billion yuan
subelec0(sub_elec) = subsidy(sub_elec)/100000;

*subelec0(sub_elec) =0;

*== Feed in tariff data
parameter FIT(sub_elec)  price of electricity generation by technologies    in yuan per kwh    ;
FIT(sub_elec)=P_elec(sub_elec);

*== update the gross tax = net tax + subsidy
taxelec0(sub_elec) = taxelec0(sub_elec)+subelec0(sub_elec)  ;

display  subelec0, taxelec0;

*convert q from MWh to GWh
q_gen(sub_elec)=q_gen(sub_elec)/1000;

display q_gen;

*==update outputelec0
outputelec0(sub_elec)=   emkup(sub_elec)*(lelec0(sub_elec)+kelec0(sub_elec)+ffelec0(sub_elec)+sum(i,intelec0(i,sub_elec)))+(taxelec0(sub_elec)-subelec0(sub_elec));

Toutputelec0         =   sum(sub_elec,outputelec0(sub_elec));

taxelec0(sub_elec)$outputelec0(sub_elec)=taxelec0(sub_elec)/outputelec0(sub_elec);
subelec0(sub_elec)$outputelec0(sub_elec)=subelec0(sub_elec)/outputelec0(sub_elec);

subelec_b(sub_elec) = subelec0(sub_elec);
p_ff(sub_elec)    =      emkup(sub_elec)*ffelec0(sub_elec)/((1-taxelec0(sub_elec))*outputelec0(sub_elec));

*check1=output0("elec")-sum(sub_elec,outputelec0(sub_elec));

*== key debug points=======
*emarkup

fact('capital')=fact('capital')-sum(sub_elec,ffelec0(sub_elec)*emkup(sub_elec));

display lelec0,kelec0,intelec0,outputelec0,taxelec0,subelec0,tx0,emission0,p_ff,Toutputelec0;

*== transfer elecoutput from value to physical

parameter   costelec0(sub_elec) unit generation cost by technomogy in billion yuan per TWH;

costelec0(sub_elec) =outputelec0(sub_elec)/q_gen(sub_elec)*1000;

outputelec0(sub_elec)=q_gen(sub_elec)/1000;

*== set emission for electricity sector
parameter emissionelec0(pollutant,pitem,*,*)  electricity emission by source ;

emissionelec0('co2','e',fe,sub_elec)=ccoef_p(fe)*intelec0(fe,sub_elec)*(1-r_feed(fe,"elec"));


*==EPPA 6 elecpower substitution elasticity between fixed factor and other inputs
esub(sub_elec,"ff")=0.2;
esub("nuclear","ff")=0.6*p_ff("nuclear")/(1-p_ff("nuclear"));
esub("hydro","ff")=0.5*p_ff("hydro")/(1-p_ff("hydro"));
esub("wind","ff")=0.25;
*esub(sub_elec,"ff")=0.4;


display costelec0,outputelec0,esub,emissionelec0, esub;

*== electricity comsumption tax rate = total subsidy/ total electricity consumption
*ecf0=sum(sub_elec,subelec0(sub_elec)*outputelec0(sub_elec))/(sum(i,int0('elec',i))+cons0('elec'));
*ecf0=sum(sub_elec,subelec0(sub_elec)*costelec0(sub_elec) *outputelec0(sub_elec))/output0('elec');
ecf0=0;
*taxelec0(sub_elec)=taxelec0(sub_elec)-ecf0;
*tx0(i)$Switch_fee=(tx0(i)*output0(i)-ecf0*int0('elec',i))/output0(i);

*display tx0,ecf0;
parameter check_l;
check_l(lm,sub_elec)=laborelec0(lm,sub_elec)/sum(lmm,laborelec0(lmm,sub_elec));
display check_l;
