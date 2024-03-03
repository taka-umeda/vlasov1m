function [ff] = position_spline(ff,vx,prm)

for kk=1:prm.ns
    aa = vx(1:prm.nv+6,kk)/prm.dx*prm.dt;
    for jj=1:prm.nv+6
        ii = 4:prm.nx+3;
        is = ii-aa(jj);
        yy = ff(jj,1:prm.nx+6,kk);
        ff(jj,4:prm.nx+3,kk) = spline(1:prm.nx+6,yy,is);
    end
end

ff(4:prm.nv+3,1:3,1:prm.ns)=ff(4:prm.nv+3,prm.nx+1:prm.nx+3,1:prm.ns);
ff(4:prm.nv+3,prm.nx+4:prm.nx+6,1:prm.ns)=ff(4:prm.nv+3,4:6,1:prm.ns);
return