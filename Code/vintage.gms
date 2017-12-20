$title calibration for general Parameters in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) calibration for vintage production

based on zhangda/MIT-EPPA
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2017
$offtext


*// original setting for vintage production
set v_i(i) sectors with vintage production;

      v_i(i)=0;
*      v_i(i)$(not elec(i))=1;          
      v_i(i)=1;

parameter       tmk         total supply of malleable capital
                tvk         total supply of vintage capital
                phi_vk0(i)  share of vintage capital in the base year
                phi_vk(i)   share of new vintage capital which is frozen in each period
;
                phi_vk0(i)$(switch_vk and v_i(i))=0.3;
                phi_vk0(elec)$(switch_vk and v_i("elec"))=0.7;

*//initialization of vintage input coeficients for general sectors
parameter   V_ff(i)     vintage coefficient for fixed factor
            V_int(j,i)  vintage coefficient for intermidiate input
            V_K(i)      vintage coefficient for capital
            V_L(i)      vintage coefficient for labor
            V_CO2       vintage coefficient for co2 emission
          ;
            V_ff(i)=ffact0(i)/output0(i);                                    
            V_int(j,i)=int0(j,i)/output0(i);
            V_K(i)=fact0("capital",i)/output0(i);  
            V_L(i)=fact0("labor",i)/output0(i);
            V_CO2(fe,i)=emission0("co2","e",fe,i)/(int0(fe,i)*(1-r_feed(fe,i)));
            
            tvk(i)$(not elec(i) and not ist(i))=fact0("capital",i)*phi_vk0(i);

*//initialization of vintage input coeficients for elec sectors
parameter   Velec_out(sub_elec)    vintage coefficient for output
            Velec_ff(sub_elec)     vintage coefficient for fixed factor
            Velec_int(i,sub_elec)  vintage coefficient for intermidiate input
            Velec_K(sub_elec)      vintage coefficient for capital
            Velec_L(sub_elec)      vintage coefficient for labor
            tvk_elec(sub_elec)	   total supply of vintage capital in elec
          ;
            Velec_out(sub_elec)=1;
            Velec_ff(sub_elec)=(ffelec0(sub_elec)*emkup(sub_elec))/outputelec0(sub_elec);                                    
            Velec_int(i,sub_elec)=(intelec0(i,sub_elec)*emkup(sub_elec))/outputelec0(sub_elec);
            Velec_L(sub_elec)=(lelec0(sub_elec)*emkup(sub_elec))/outputelec0(sub_elec);  
            Velec_K(sub_elec)=(kelec0(sub_elec)*emkup(sub_elec)) /outputelec0(sub_elec);
     
            tvk_elec(sub_elec)=kelec0(sub_elec)*phi_vk0("elec");

*//initialization of vintage input coeficients for ist sectors
parameter   Vist_out(sub_ist)      vintage coefficient for output
			      Vist_int(i,sub_ist)    vintage coefficient for intermidiate input
            Vist_K(sub_ist)        vintage coefficient for capital
            Vist_L(sub_ist)        vintage coefficient for labor
            Vist_CO2(fe,sub_ist)	 vintage coefficient for co2
            tvk_ist(sub_ist)	     total supply of vintage capital in elec
          ; 
            Vist_out(sub_ist)=1;                                        
            Vist_int(i,sub_ist)=(intist0(i,sub_ist)/outputist0(sub_ist));
            Vist_L(sub_ist)=list0(sub_ist)/outputist0(sub_ist);  
            Vist_K(sub_ist)=kist0(sub_ist)/outputist0(sub_ist);
            Vist_CO2(fe,sub_ist)$intist0(fe,sub_ist)=emissionist0('co2','e',fe,sub_ist)/intist0(fe,sub_ist);

            tvk_ist(sub_ist)=kist0(sub_ist)*phi_vk0("ist");

*//update capital endowment
            tvk(i)$(not elec(i) and not ist(i))=fact0("capital",i)*phi_vk0(i);
            tmk=fact("capital")-sum(i,tvk(i))
                -sum(sub_elec,tvk_elec(sub_elec))
                -sum(sub_ist,tvk_ist(sub_ist));

parameter check_vk;

*check_vk(sub_elec)=Velec_ff(sub_elec)+sum(i,Velec_int(i,sub_elec))+Velec_K(sub_elec)+Velec_L(sub_elec);
check_vk=fact("capital")-(tmk+sum(sub_elec,tvk_elec(sub_elec)));
display check_vk;