function [ex,fex] = efield(ex,ajx,prm)
ex(4:prm.nx+3) = ex(4:prm.nx+3) - ajx(4:prm.nx+3);

ex(1:3) = ex(prm.nx+1:prm.nx+3);
ex(prm.nx+4:prm.nx+5) = ex(4:5);

%%% Relocation %%%
for ii = 4:prm.nx+3
    fex(ii) =(ex(ii)+ex(ii-1))*0.5;
end
fex(1:3)=fex(prm.nx+1:prm.nx+3);
fex(prm.nx+4:prm.nx+6)=fex(4:6);
return