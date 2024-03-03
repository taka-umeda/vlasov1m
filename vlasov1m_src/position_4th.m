function [ff,ajx] = position_4th(ff,vx,prm)

ajxs = zeros(1,prm.nx+6,prm.ns);
flux = zeros(prm.nv+6,prm.nx+6);
jj=1:prm.nv+6;
for kk=1:prm.ns
    for ii=3:prm.nx+3
        aa=vx(1:prm.nv+6,kk)/prm.dx*prm.dt;
        flux(jj,ii) = aa(jj)    .* (-ff(jj,ii+2,kk)+ 7*ff(jj,ii+1,kk)+ 7*ff(jj,ii,kk)-ff(jj,ii-1,kk))/12 ...
                     +aa(jj).^2 .* ( ff(jj,ii+2,kk)-15*ff(jj,ii+1,kk)+15*ff(jj,ii,kk)-ff(jj,ii-1,kk))/24 ...
                     +aa(jj).^3 .* ( ff(jj,ii+2,kk)-   ff(jj,ii+1,kk)-   ff(jj,ii,kk)+ff(jj,ii-1,kk))/12 ...
                     +aa(jj).^4 .* (-ff(jj,ii+2,kk)+ 3*ff(jj,ii+1,kk)- 3*ff(jj,ii,kk)+ff(jj,ii-1,kk))/24;
    end
    ff(1:prm.nv+6,4:prm.nx+3,kk) = ff(1:prm.nv+6,4:prm.nx+3,kk) ...
                              - (flux(1:prm.nv+6,4:prm.nx+3)-flux(1:prm.nv+6,3:prm.nx+2));

    ajxs(1,4:prm.nx+3,kk)=sum(flux(1:prm.nv+6,4:prm.nx+3),1)*prm.qn(kk);
end
ff(1:prm.nv+6,1:3,1:prm.ns)=ff(1:prm.nv+6,prm.nx+1:prm.nx+3,1:prm.ns);
ff(1:prm.nv+6,prm.nx+4:prm.nx+6,1:prm.ns)=ff(1:prm.nv+6,4:6,1:prm.ns);

ajx=sum(ajxs,3);
ajx(1:3)=ajx(prm.nx+1:prm.nx+3);
ajx(prm.nx+4:prm.nx+6)=ajx(4:6);
ajx0=mean(ajx(4:prm.nx+3));
ajx(1:prm.nx+6)=ajx(1:prm.nx+6)-ajx0;
return