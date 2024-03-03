function [ff,gx,gv] = position_cip(ff,gx,gv,vx,prm)

dff=zeros(prm.nv+6,prm.nx+6);
dfx=zeros(prm.nv+6,prm.nx+6);
dfv=zeros(prm.nv+6,prm.nx+6);
for kk=1:prm.ns
    aa = vx(1:prm.nv+6,kk)/prm.dx*prm.dt;
    ss = sign(aa);
    ii = 4:prm.nx+3;
    for jj=1:prm.nv+6
        f1 =         (gx(jj,ii,kk)+gx(jj,ii-ss(jj),kk)) -ss(jj)*2*(ff(jj,ii,kk)-ff(jj,ii-ss(jj),kk));
        f2 =ss(jj)*(2*gx(jj,ii,kk)+gx(jj,ii-ss(jj),kk)) -       3*(ff(jj,ii,kk)-ff(jj,ii-ss(jj),kk));
        
        dff(jj,ii) =(-gx(jj,ii,kk)*aa(jj) +   f2*aa(jj)^2 - f1*aa(jj)^3);
        dfx(jj,ii) =         -2*f2*aa(jj) + 3*f1*aa(jj)^2;
    end
    for jj=2:prm.nv+5
        j1=jj+1;
        j2=jj-1;
        dfv(jj,ii) =-0.25*(aa(j1)*(dfx(j1,ii)+gx(j1,ii,kk)*2) ...
                         - aa(j2)*(dfx(j2,ii)+gx(j2,ii,kk)*2));
    end
    jj=2:prm.nv+5;
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