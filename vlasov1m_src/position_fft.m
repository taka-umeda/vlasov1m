function [ff] = position_fft(ff,vx,kx,prm)

for kk=1:prm.ns
    aa = vx(1:prm.nv+6,kk)*prm.dt;
    for jj=1:prm.nv+6
        ii = 4:prm.nx+3;
        yy = fft(ff(jj,ii,kk));
        yy = yy.*exp(-1i*aa(jj)*kx);
        ff(jj,ii,kk) = real(ifft(yy));
    end
end

ff(4:prm.nv+3,1:3,1:prm.ns)=ff(4:prm.nv+3,prm.nx+1:prm.nx+3,1:prm.ns);
ff(4:prm.nv+3,prm.nx+4:prm.nx+6,1:prm.ns)=ff(4:prm.nv+3,4:6,1:prm.ns);
return