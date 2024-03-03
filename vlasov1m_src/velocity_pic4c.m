function ff =velocity_pic4c(ff,ex,prm)

flux = zeros(prm.nv+6,prm.nx+6);
for kk=1:prm.ns
    aa = ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    fa = floor(aa);
    ss = sign(aa);
    as = aa.*ss;
    aa1=  -(as+1).*(as-1).*(as-2);
    aa2= 2*(as+3).*(as-1).*(as-2);
    aa3=  -(as+2).*(as+1).*(as-1);
    for ii=1:prm.nx+6
        jj=3:prm.nv+3;
        j1=jj-fa(ii);
        
        fm2=ff(j1-ss(ii)-ss(ii),ii,kk);
        fm1=ff(j1-ss(ii)       ,ii,kk);
        fp0=ff(j1              ,ii,kk);
        fp1=ff(j1+ss(ii)       ,ii,kk);
        fp2=ff(j1+ss(ii)+ss(ii),ii,kk);
        
        hmax1=max(max(fm1,fp0),min(fm1*2-fm2,fp0*2-fp1));
        hmin1=min(min(fm1,fp0),max(fm1*2-fm2,fp0*2-fp1));
        hmax2=max(max(fp1,fp0),min(fp0*2-fm1,fp1*2-fp2));
        hmin2=min(min(fp1,fp0),max(fp0*2-fm1,fp1*2-fp2));
        
        hmax=max(hmax1,hmax2);
        hmin=max(min(hmin1,hmin2),0);
        
        ep3=-min(fm1-fp0,2.4*(fp0-hmin)).*(fp0<=fm1) ...
            +min(fp0-fm1,4.0*(hmax-fp0)).*(fp0> fm1);
        ep2= min(fp1-fp0,1.6*(fp0-hmin)).*(fp1>=fp0) ...
            -min(fp0-fp1,1.6*(hmax-fp0)).*(fp1< fp0);
        ep1= min(fp2-fp1,2.0*(fp0-hmin)).*(fp2>=fp1).*(ep2>=ep3) ...
            -min(fp1-fp2,1.1*(fp0-hmin)).*(fp2< fp1).*(ep2>=ep3) ...
            +min(fp2-fp1,0.8*(hmax-fp0)).*(fp2>=fp1).*(ep2< ep3) ...
            -min(fp1-fp2,1.9*(hmax-fp0)).*(fp2< fp1).*(ep2< ep3);
        
        flux(jj,ii) = aa(ii)*((ep1*aa1(ii)+ep2*aa2(ii)+ep3*aa3(ii))/24+fp0);
    end
    ff(4:prm.nv+3,1:prm.nx+6,kk) = ff(4:prm.nv+3,1:prm.nx+6,kk) ...
        - (flux(4:prm.nv+3,1:prm.nx+6)-flux(3:prm.nv+2,1:prm.nx+6));
end

return