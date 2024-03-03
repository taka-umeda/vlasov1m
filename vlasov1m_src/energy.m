function eng = energy(ff,vx,ex,prm)
eng = zeros(1+prm.ns,1);

% electric
te = sum(ex(4:prm.nx+3).^2);
eng(1) = 0.5*te/prm.nx;

% kinetic
for kk=1:prm.ns
    tmp=zeros(prm.nx,1);
    for ii=4:prm.nx+3
        tmp(ii-3) = sum(ff(:,ii,kk).*vx(:,kk).^2);
    end
    eng(kk+1) = 0.5*sum(tmp)/prm.nx;
end
return