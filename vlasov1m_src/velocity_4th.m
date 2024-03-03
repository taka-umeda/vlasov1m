function ff =velocity_4th(ff,ex,prm)

flux = zeros(prm.nv+6,prm.nx+6);
jj=3:prm.nv+3;
for kk=1:prm.ns
    aa=ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    for ii=1:prm.nx+6        
        flux(jj,ii) = aa(ii)    .* (-ff(jj+2,ii,kk)+ 7*ff(jj+1,ii,kk)+ 7*ff(jj,ii,kk)-ff(jj-1,ii,kk))/12 ...
                     +aa(ii).^2 .* ( ff(jj+2,ii,kk)-15*ff(jj+1,ii,kk)+15*ff(jj,ii,kk)-ff(jj-1,ii,kk))/24 ...
                     +aa(ii).^3 .* ( ff(jj+2,ii,kk)-   ff(jj+1,ii,kk)-   ff(jj,ii,kk)+ff(jj-1,ii,kk))/12 ...
                     +aa(ii).^4 .* (-ff(jj+2,ii,kk)+ 3*ff(jj+1,ii,kk)- 3*ff(jj,ii,kk)+ff(jj-1,ii,kk))/24;
    end
    ff(2:prm.nv+5,1:prm.nx+6,kk) = ff(2:prm.nv+5,1:prm.nx+6,kk) ...
                              - (flux(2:prm.nv+5,1:prm.nx+6)-flux(1:prm.nv+4,1:prm.nx+6));
end

return