function rho = charge(ff,prm)

rhos=zeros(1,prm.nx+6,prm.ns);
for kk=1:prm.ns
    for ii=1:prm.nx+6
        rhos(1,ii,kk)=sum(ff(1:prm.nv+6,ii,kk),1)*prm.qn(kk);
    end
end
rho=sum(rhos,3);
rho0=mean(rho(4:prm.nx+3));
rho(1:prm.nx+6)=rho(1:prm.nx+6)-rho0;
return
