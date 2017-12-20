
*==This file is used to initialize the parameter for report

*===========================policy shock on static model========================

UNEM(lm,z)=UR.l(lm);
pwage(lm,i,z)=pl.l(lm,i);

report1(z,'so2',i)=scoef_e('process',i)*qdout.l(i) ;
report1(z,'so2','fd')=scoef_e('process','fd')*sum(i,qc.l(i)) ;
report1(z,'so2','total')=sum(i,report1(z,'so2',i))+report1(z,'so2','fd') ;

report1(z,'NOX',i)=ncoef_e('process',i)*qdout.l(i) ;
report1(z,'NOX','fd')=ncoef_e('process','fd')*sum(i,qc.l(i)) ;
report1(z,'NOX','total')=sum(i,report1(z,'NOX',i))+report1(z,'NOX','fd') ;

report2(z,i)=sum(fe,ccoef_p(fe)*qin.l(fe,i)*(1-r_feed(fe,i)));
report2(z,"elec")=sum(sub_elec,sum(fe,ccoef_p(fe)*qin_ele.l(fe,sub_elec)));
report2(z,"fd")=sum(fe,ccoef_h(fe)*qc.l(fe));
report2(z,"Total")=sum(i,report2(z,i))+report2(z,"fd");

report3(z,sub_elec)=sum(fe,ccoef_p(fe)*qin_ele.l(fe,sub_elec)*(1-r_feed(fe,"elec")));

report6(z,lm,"total")= sum(i,qlin.l(lm,i))+sum(sub_elec,qlin_ele.l(lm,sub_elec));
report6(z,lm,i)= qlin.l(lm,i);
report6(z,lm,"elec")= sum(sub_elec,qlin_ele.l(lm,sub_elec));
report6(z,lm,sub_elec)= qlin_ele.l(lm,sub_elec);

*==the unit for sub_elec is K people/ GWh
*==the unit for othersector is K people/ billion yuan
report4(z,lm,i) = qlin.l(lm,i)/qdout.l(i);
report4(z,lm,"elec") =sum(sub_elec, qlin_ele.l(lm,sub_elec))/qdout.l("elec");
report4(z,lm,sub_elec) = qlin_ele.l(lm,sub_elec)/qelec.l(sub_elec);
report4(z,"total",i) = sum(lm,qlin.l(lm,i))/qdout.l(i);
report4(z,"total","elec") =sum(lm, report4(z,lm,"elec"));

report4(z,"total",sub_elec) = sum(lm,qlin_ele.l(lm,sub_elec))/qelec.l(sub_elec);

report3(z,sub_elec) = taxelec0(sub_elec)-t_re.l(sub_elec);

*==Direct employment impact
DEE(z,lm,gen)  = (qelec.l(gen)-outputelec0(gen))*laborelec0(lm,gen)/outputelec0(gen);

IEE_id(z,i,gen)  =  (qin_ele.l(i,gen)-intelec0(i,gen));

IEE(z,lm,i,gen)  =  (qin_ele.l(i,gen)-intelec0(i,gen))*labor_q0(lm,i)/output0(i);

report9(lm,i)=labor_q0(lm,i)/output0(i);

*IEE(z,lm,gen)  =  (qelec.l(gen)-outputelec0(gen))*laborelec0(lm,gen)/outputelec0(gen)
*                               - (qelec.l(gen)-outputelec0(gen))*sum(genn,laborelec0(lm,genn))/sum(genn,outputelec0(genn));

TEE(z,lm,i) = qlin.l(lm,i)-labor_q0(lm,i);
TEE(z,lm,sub_elec) = qlin_ele.l(lm,sub_elec)-laborelec0(lm,sub_elec);
TEE(z,lm,"elec") = sum(sub_elec,qlin_ele.l(lm,sub_elec)-laborelec0(lm,sub_elec));
TEE(z,lm,"total") = sum(i,qlin.l(lm,i)-labor_q0(lm,i))- (qlin.l(lm,"elec")-labor_q0(lm,"elec"))+sum(sub_elec,qlin_ele.l(lm,sub_elec)-laborelec0(lm,sub_elec));


TEE_DE(z,lm,i) =  (qdout.l(i)-output0(i))*labor_q0(lm,i)/output0(i);
TEE_DE(z,lm,sub_elec) =  (qelec.l(sub_elec)-outputelec0(sub_elec))*laborelec0(lm,sub_elec)/outputelec0(sub_elec);
TEE_DE(z,lm,"elec") =  sum(sub_elec,(qelec.l(sub_elec)-outputelec0(sub_elec))*laborelec0(lm,sub_elec)/outputelec0(sub_elec));
TEE_DE(z,lm,"total") = sum(i, (qdout.l(i)-output0(i))*labor_q0(lm,i)/output0(i))
                    +sum(sub_elec,(qelec.l(sub_elec)-outputelec0(sub_elec))*laborelec0(lm,sub_elec)/outputelec0(sub_elec));

TEE_WE(z,lm,i) =  output0(i)*(qlin.l(lm,i)/qdout.l(i)-labor_q0(lm,i)/output0(i));
TEE_WE(z,lm,sub_elec) =  outputelec0(sub_elec)*(qlin_ele.l(lm,sub_elec)/qelec.l(sub_elec)-laborelec0(lm,sub_elec)/outputelec0(sub_elec));
TEE_WE(z,lm,"elec") =  sum(sub_elec,TEE_WE(z,lm,sub_elec));
TEE_WE(z,lm,"total") = sum(i,TEE_WE(z,lm,i))
                    +sum(sub_elec,TEE_WE(z,lm,sub_elec));
