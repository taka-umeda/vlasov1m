function ff =velocity_fft(ff,ex,kv,prm)

for kk=1:prm.ns
    aa = ex*prm.qm(kk)/prm.dv(kk)*prm.dt;
    for ii=1:prm.nx+6        
        jj =(1:prm.nv+6)';
        yy = fft(ff(jj,ii,kk));
        yy = yy.*exp(-1i*aa(ii)*kv);
        ff(jj,ii,kk) = real(ifft(yy));
    end
end

return