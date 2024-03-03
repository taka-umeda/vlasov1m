function ajx = current(ff,vx,prm)

ajxs=zeros(1,prm.nx+6,prm.ns);
for kk=1:prm.ns
    aa = vx(1:prm.nv+6,kk)/prm.dx*prm.dt;
    for ii=1:prm.nx+6
        ajxs(1,ii,kk)=sum((ff(1:prm.nv+6,ii,kk).*aa),1)*prm.qn(kk);
    end
end
ajx=sum(ajxs,3);
ajx0=mean(ajx(4:prm.nx+3));
ajx(1:prm.nx+6)=ajx(1:prm.nx+6)-ajx0;
return
