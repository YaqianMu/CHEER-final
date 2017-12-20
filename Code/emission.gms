$title  emission data in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) GHG emission
2) Air pollutants emission

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
*----------------------------------------------*
*==sets for emission
*----------------------------------------------*
sets
ef  effluent categories /CO2,SO2,NOX/

ghg(ef) greenhouse gases /CO2/

crit(ef) criteria pollutants /NOX,SO2/

pollutant /CO2,SO2,NOX/
air_p(pollutant) /SO2,NOX/
Pitem pollutant items /
       e emission
       g generation
       a abatement/
Psource /
        coal from coal conbustion
        roil from refined oil conbustion
        gas  from gas conbustion
        process from production process/
;

*----------------------------------------------*
*==read emission data from gdx
*----------------------------------------------*
Set        fuel fossul fuel source /coal, oil, gas/;
set        mapif(fuel,fe) maping from sectors to fuel/
           Coal    .    Coal
           Oil     .    Roil
           Gas     .    Gas/
parameter
           Emission(fuel)           China total CO2 emission from the combustion of fuel in 2012 in 100 million tonnes CO2 equivalent
           C(fuel)                  Carbon intensity per unit of energy released from the combustion of fuel    in 100 Million tonnes carbon per EJ
           eet(fuel)                The quantity of fuel combustion in China in 10 000 tce according to coal equivalent calculation(Mt)
           emissionfactor(fuel)     Emission factor by fuel  (100 million tonnes CO2 equivalent per 10 thousand Yuan Input)
           CO2at                    Aggregated co2 emission (100 million tonnes CO2 equivalent)
           Sat_feedstock            Feedstock rate for aggregated sectors;

$GDXIN %DataPath%\CO2_%ExpPath%_%datagg%.gdx
$LOAD  CO2at emissionfactor Sat_feedstock Emission  C  eet
$GDXIN

*==parameters for emission accounts
parameter
          ccoef_pro                        carbon coefficient of process (billion T per Billion yuan)
          ccoef_P                          carbon coefficient of production(billion T per Billion yuan)
          ccoef_h                          carbon coefficient of consumption(billion T per Billion yuan)
          r_feed                           share of energy input use as feedstock in specific sectors
          emission0(pollutant,pitem,*,*)   sectoral emission by source (Billion tonnes CO2 equivalent )
          Temission0                       Total emission by sector (Billion tonnes CO2 equivalent )
          Temission1                       Total emission by fuel (Billion tonnes CO2 equivalent )
          Temission2                       total emission (Billion tonnes CO2 equivalent )
          ;

          ccoef_P(fe)   = sum(fuel$mapif(fuel,fe), emissionfactor(fuel))/10*10**5;
          ccoef_h(fe)   = ccoef_P(fe);
          r_feed(fe,i)  = Sat_feedstock(fe,i);

          emission0('co2','e',fe,i)=ccoef_p(fe)*int0(fe,i)*(1-r_feed(fe,i));
          emission0('co2','e',fe,'fd')=ccoef_h(fe)*cons0(fe);

*==CO2 emission from cement Production from Liu, Zhu.China's Carbon Emissions Report 2015. Cambridge, Mass.: Report for Sustainability Science Program, Mossavar-Rahmani Center for Business and Government, Harvard Kennedy School, Energy Technology Innovation Policy research group, Belfer Center for Science and International Affairs, Harvard Kennedy School, May 2015.
          emission0('co2','e','process',i)$Switch_pc(i)=0.6838308725;

          ccoef_pro(i)=emission0('co2','e','process',i)/output0(i);

display emission0, ccoef_p,ccoef_h,ccoef_pro, r_feed;


*== air pollutant emission data  SO2 and NOX based on Global Emissions EDGAR v4.3.1 from   Non-CO2 Emission by sector 2010.xlsx in emission fold
parameter urban(*,*)         urban pollutant emission by sector in Gg   10^9 g 1000 tonnes;

$GDXIN %DataPath%\urban_%ExpPath%_output.gdx
$LOAD urban
$GDXIN

parameter ncoef_e(*,*)        NOX emission million ton per billion yuan
          nlim                        NOX emission limits million ton;
parameter scoef_e(*,*)        SO2 emission million ton per billion yuan
          slim                        so2 emission limits million ton;

parameter ncoef_e(*,*)        NOX emission million ton per billion yuan
          nlim                        NOX emission limits million ton;


scoef_e('process',i)     =urban('SO2',i)/output0(i);
scoef_e('process','fd')     =urban('SO2','household')/sum(i,cons0(i));

ncoef_e('process',i)     =urban('NOX',i)/output0(i);
ncoef_e('process','fd')     =urban('NOX','household')/sum(i,cons0(i));

scoef_e('process',i)$(1-switch_urban(i))    = 0;
scoef_e('process','fd')$(1-switch_urban('fd'))       =0;

ncoef_e('process',i)$(1-switch_urban(i))       =0;
ncoef_e('process','fd')$(1-switch_urban('fd'))       =0;


emission0('so2','e','process',i)=scoef_e('process',i)*output0(i) ;
emission0('so2','e','process','fd')=scoef_e('process','fd')*sum(i,cons0(i)) ;

emission0('NOX','e','process',i)=ncoef_e('process',i)*output0(i) ;
emission0('NOX','e','process','fd')=ncoef_e('process','fd')*sum(i,cons0(i)) ;


display scoef_e,ncoef_e,emission0,ccoef_pro;

*==emission account
Temission0('co2',i)=sum(fe,emission0("co2","e",fe,i))+emission0('co2','e','process',i);
Temission0('co2','fd')=sum(fe,emission0('co2','e',fe,'fd'));

Temission0('so2',i)=emission0('so2','e','process',i);
Temission0('so2','fd')=emission0('so2','e','process','fd');

Temission0('NOX',i)=emission0('NOX','e','process',i);
Temission0('NOX','fd')=emission0('NOX','e','process','fd');

Temission1('co2')=sum(i,Temission0('co2',i))+Temission0('co2','fd');
Temission1('so2')=sum(i,Temission0('so2',i))+Temission0('So2','fd');
Temission1('NOX')=sum(i,Temission0('NOX',i))+Temission0('NOX','fd');
Temission2('co2')=sum((i,fe),emission0("co2","e",fe,i))+sum(i,emission0('co2','e','process',i))+sum(fe,emission0("co2","e",fe,"fd"));

display     Temission0,Temission1,Temission2;
