function [ex,fex] = poisson(ex,rho,prm)

for ii = 4:prm.nx+3
    ex(ii)= ex(ii-1)+rho(ii);
end
ex(1:3)=ex(prm.nx+1:prm.nx+3);
ex(prm.nx+4:prm.nx+5)=ex(4:5);

ex0=sum(ex(4:prm.nx+3))/prm.nx;
ex(1:prm.nx+5)=ex(1:prm.nx+5)-ex0;

%%% Relocation %%%
for ii = 4:prm.nx+3
    fex(ii) =(ex(ii)+ex(ii-1))*0.5;
end
fex(1:3)=fex(prm.nx+1:prm.nx+3);
fex(prm.nx+4:prm.nx+6)=fex(4:6);
return
