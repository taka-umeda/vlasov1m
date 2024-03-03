function ff =velocity_spline(ff,ex,prm)

for kk=1:prm.ns
    aa = ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    for ii=1:prm.nx+6        
        jj =(1:prm.nv+6)';
        js = jj-aa(ii);
        yy = ff(jj,ii,kk);
        ff(jj,ii,kk) = spline(jj,yy,js);
    end
end

return