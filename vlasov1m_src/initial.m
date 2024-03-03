function [ff,gx,gv,ex,fex,ajx,xx,vx,kx,kv,prm,ifdiag]=initial(prm)
%
ifdiag = ceil(prm.ntime/prm.nplot);

% coordinates
xx = (-3:prm.nx+2)*prm.dx;
vx = zeros(prm.nv+6,prm.ns);
for kk=1:prm.ns
    vx(1:prm.nv+6,kk) = linspace(prm.vmin(kk),prm.vmax(kk),prm.nv+6);
end

prm.dv = zeros(1,prm.ns);
for kk=1:prm.ns
    prm.dv(kk) = vx(2,kk)-vx(1,kk);
end
prm.qn=prm.dv./prm.qm.*prm.wp.^2*prm.dx;

kx=zeros(1,prm.nx);
kv=zeros(prm.nv+6,1);
nkx=floor(prm.nx*0.5);
nkv=floor(prm.nv*0.5)+3;
kx(1:nkx)=(0:nkx-1)/(prm.nx*prm.dx)*2*pi;
kv(1:nkv)=(0:nkv-1)/(prm.nv+6)     *2*pi;
for ii=nkx+1:prm.nx
    kx(ii)=-kx(2*nkx+2-ii);
end
for jj=nkv+1:prm.nv+6
    kv(jj)=-kv(2*nkv+2-jj);
end

%-- Field Initialization --
fex = zeros(1,prm.nx+6); % Full integer grids
ajx = zeros(1,prm.nx+6);
ex  = (fex(1:prm.nx+5)+fex(2:prm.nx+6))*0.5; % Half integer grids

%-- Particle Initialization --
ff = zeros(prm.nv+6,prm.nx+6,prm.ns);
gx = zeros(prm.nv+6,prm.nx+6,prm.ns);
gv = zeros(prm.nv+6,prm.nx+6,prm.ns);
gam = 3;
wpe = sqrt(sum(prm.wp.^2 .* (prm.qm < 0)));
for kk=1:prm.ns
    
    if prm.qm(kk) < 0
        ww = sqrt(wpe^2+gam*prm.vt(kk)^2*kx.^2);        
    else
        ww = prm.vd(kk)*kx;
        prm.noise=3; 
    end
    if prm.noise==3 % white noise
        prm.nmode = nkx;
        amp = max(max(prm.pamp),max(prm.namp));
        pamp(1:prm.nmode)=amp/prm.nx;
        namp(1:prm.nmode)=amp/prm.nx;
        pphs(1:prm.nmode)=rand(1,prm.nmode)*360;
        nphs(1:prm.nmode)=rand(1,prm.nmode)*360;
    elseif prm.noise==2
        pamp(1:prm.nmode)=prm.pamp(1:prm.nmode);
        namp(1:prm.nmode)=prm.namp(1:prm.nmode);
        pphs(1:prm.nmode)=rand(1,prm.nmode)*360;
        nphs(1:prm.nmode)=rand(1,prm.nmode)*360;
    else
        pamp(1:prm.nmode)=prm.pamp(1:prm.nmode);
        namp(1:prm.nmode)=prm.namp(1:prm.nmode);
        pphs(1:prm.nmode)=prm.pphs(1:prm.nmode);
        nphs(1:prm.nmode)=prm.nphs(1:prm.nmode);
    end
    dn_noise = ones(1,prm.nx+6); % Full integer grids
    dd_noise =zeros(1,prm.nx+6); % Full integer grids
    vd_noise = ones(1,prm.nx+6)*prm.vd(kk);
    vt_noise = ones(1,prm.nx+6)*prm.vt(kk);
      
    for ll=1:prm.nmode
        dn_noise = dn_noise - pamp(ll)*sin(-kx(1+ll)*xx+pphs(ll)/180*pi)*kx(1+ll) ...
                            + namp(ll)*sin( kx(1+ll)*xx+nphs(ll)/180*pi)*kx(1+ll);
        dd_noise = dd_noise + pamp(ll)*cos(-kx(1+ll)*xx+pphs(ll)/180*pi)*kx(1+ll)^2 ...
                            + namp(ll)*cos( kx(1+ll)*xx+nphs(ll)/180*pi)*kx(1+ll)^2;
        vd_noise = vd_noise - pamp(ll)*sin(-kx(1+ll)*xx+pphs(ll)/180*pi)*(ww(1+ll)-prm.vd(kk)*kx(1+ll))...
                            - namp(ll)*sin( kx(1+ll)*xx+nphs(ll)/180*pi)*(ww(1+ll)+prm.vd(kk)*kx(1+ll));
    end
    
    for ii=1:prm.nx+6
        for jj=1:prm.nv+6
            ff(jj,ii,kk) = exp(-(vx(jj,kk)-vd_noise(ii)).^2/(2*vt_noise(ii).^2)) ...
                /(sqrt(2*pi)*vt_noise(ii))*dn_noise(ii);
            gx(jj,ii,kk) = exp(-(vx(jj,kk)-vd_noise(ii)).^2/(2*vt_noise(ii).^2)) ...
                /(sqrt(2*pi)*vt_noise(ii))*dd_noise(ii)           *prm.dx;
            gv(jj,ii,kk) =-exp(-(vx(jj,kk)-vd_noise(ii)).^2/(2*vt_noise(ii).^2)) ...
                /(sqrt(2*pi)*vt_noise(ii))*dn_noise(ii) ...
                * (vx(jj,kk)-vd_noise(ii))/(vt_noise(ii).^2)      *prm.dv(kk);
        end
    end
end

return
