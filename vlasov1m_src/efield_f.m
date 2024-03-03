function [fex] = efield_f(fex,ajx,prm)
fex(4:prm.nx+3) = fex(4:prm.nx+3) - ajx(4:prm.nx+3);

fex(1:3) = fex(prm.nx+1:prm.nx+3);
fex(prm.nx+4:prm.nx+6) = fex(4:6);
return