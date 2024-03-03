function [ff,gx,gv] =velocity_cip(ff,gx,gv,ex,prm)

dff=zeros(prm.nv+6,prm.nx+6);
dfx=zeros(prm.nv+6,prm.nx+6);
dfv=zeros(prm.nv+6,prm.nx+6);
for kk=1:prm.ns
    aa = ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    ss = sign(aa);
    jj =(2:prm.nv+5);
    for ii=3:prm.nx+4
        f1 =         (gv(jj,ii,kk)+gv(jj-ss(ii),ii,kk)) -ss(ii)*2*(ff(jj,ii,kk)-ff(jj-ss(ii),ii,kk));
        f2 =ss(ii)*(2*gv(jj,ii,kk)+gv(jj-ss(ii),ii,kk)) -       3*(ff(jj,ii,kk)-ff(jj-ss(ii),ii,kk));
        dff(jj,ii) =(-gv(jj,ii,kk)*aa(ii) +    f2*aa(ii)^2 - f1*aa(ii)^3);
        dfv(jj,ii) =         -2*f2*aa(ii) + 3*f1*aa(ii)^2;
    end
    for ii=4:prm.nx+3
        i1=ii+1;
        i2=ii-1;
        dfx(jj,ii) =-0.25*(aa(i1)*(dfv(jj,i1)+gv(jj,i1,kk)*2) ...
                         - aa(i2)*(dfv(jj,i2)+gv(jj,i2,kk)*2));
    end
    ii=4:prm.nx+3;
    ff(jj,ii,kk) = ff(jj,ii,kk) + dff(jj,ii);
    gx(jj,ii,kk) = gx(jj,ii,kk) + dfx(jj,ii);
    gv(jj,ii,kk) = gv(jj,ii,kk) + dfv(jj,ii);
end

ff(2:prm.nv+5,1:3,1:prm.ns)=ff(2:prm.nv+5,prm.nx+1:prm.nx+3,1:prm.ns);
gx(2:prm.nv+5,1:3,1:prm.ns)=gx(2:prm.nv+5,prm.nx+1:prm.nx+3,1:prm.ns);
gv(2:prm.nv+5,1:3,1:prm.ns)=gv(2:prm.nv+5,prm.nx+1:prm.nx+3,1:prm.ns);
ff(2:prm.nv+5,prm.nx+4:prm.nx+6,1:prm.ns)=ff(2:prm.nv+5,4:6,1:prm.ns);
gx(2:prm.nv+5,prm.nx+4:prm.nx+6,1:prm.ns)=gx(2:prm.nv+5,4:6,1:prm.ns);
gv(2:prm.nv+5,prm.nx+4:prm.nx+6,1:prm.ns)=gv(2:prm.nv+5,4:6,1:prm.ns);
return