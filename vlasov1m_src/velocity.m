function ff =velocity(ff,ex,prm)

flux = zeros(prm.nv+6,prm.nx+6);
jj=1:prm.nv+5;
for kk=1:prm.ns
    % should be relocated!! %
    aa = ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    %%%%%%%%%%%%%%%%%%%%%%%%%
    fa =floor(aa);
    for ii=1:prm.nx+6
        js = jj-fa(ii);
        flux(jj,ii) =aa(ii) * ff(js,ii,kk);
    end
    ff(2:prm.nv+5,1:prm.nx+6,kk) = ff(2:prm.nv+5,1:prm.nx+6,kk) ...
                              - (flux(2:prm.nv+5,1:prm.nx+6)-flux(1:prm.nv+4,1:prm.nx+6));
end

return