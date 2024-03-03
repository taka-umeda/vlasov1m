function [ff,ajx] = position_pic4c(ff,vx,prm)

ajxs = zeros(1,prm.nx+6,prm.ns);
flux = zeros(prm.nv+6,prm.nx+6);
for kk=1:prm.ns
    aa = vx(1:prm.nv+6,kk)/prm.dx*prm.dt;
    fa = floor(aa);
    ss = sign(aa);
    as = aa.*ss;
    aa1 =  -(as+1).*(as-1).*(as-2);
    aa2 = 2*(as+3).*(as-1).*(as-2);
    aa3 =  -(as+2).*(as+1).*(as-1);
    for ii=3:prm.nx+3
        jj=1:prm.nv+6;
        i1=ii-fa(jj);
        
        fm2=diag(ff(jj,i1-ss(jj)-ss(jj),kk));
        fm1=diag(ff(jj,i1-ss(jj)       ,kk));
        fp0=diag(ff(jj,i1              ,kk));
        fp1=diag(ff(jj,i1+ss(jj)       ,kk));
        fp2=diag(ff(jj,i1+ss(jj)+ss(jj),kk));
        
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
        
        flux(jj,ii) = aa.*((ep1.*aa1+ep2.*aa2+ep3.*aa3)/24+fp0);
    end
    ff(4:prm.nv+3,4:prm.nx+3,kk) = ff(4:prm.nv+3,4:prm.nx+3,kk) ...
                              - (flux(4:prm.nv+3,4:prm.nx+3)-flux(4:prm.nv+3,3:prm.nx+2));
    
    ajxs(1,4:prm.nx+3,kk)=sum(flux(1:prm.nv+6,4:prm.nx+3),1)*prm.qn(kk);
end
ff(4:prm.nv+3,1:3,1:prm.ns)=ff(4:prm.nv+3,prm.nx+1:prm.nx+3,1:prm.ns);
ff(4:prm.nv+3,prm.nx+4:prm.nx+6,1:prm.ns)=ff(4:prm.nv+3,4:6,1:prm.ns);

ajx=sum(ajxs,3);
ajx(1:3)=ajx(prm.nx+1:prm.nx+3);
ajx(prm.nx+4:prm.nx+6)=ajx(4:6);
ajx0=mean(ajx(4:prm.nx+3));
ajx(1:prm.nx+6)=ajx(1:prm.nx+6)-ajx0;
return