function ff =velocity_2nd(ff,ex,prm)

flux = zeros(prm.nv+6,prm.nx+6);
jj=1:prm.nv+5;
for kk=1:prm.ns
    aa=ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    for ii=1:prm.nx+6        
        flux(jj,ii) = aa(ii) * (ff(jj+1,ii,kk)+ff(jj,ii,kk))*0.5 ...
              -aa(ii)*aa(ii) * (ff(jj+1,ii,kk)-ff(jj,ii,kk))*0.5;
    end
    ff(2:prm.nv+5,1:prm.nx+6,kk) = ff(2:prm.nv+5,1:prm.nx+6,kk) ...
                              - (flux(2:prm.nv+5,1:prm.nx+6)-flux(1:prm.nv+4,1:prm.nx+6));
end

return