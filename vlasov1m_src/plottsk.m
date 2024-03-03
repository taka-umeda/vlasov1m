function hdiag = plottsk(hdiag,jdiag,ifdiag,prm)
global kspec

kspecdata = squeeze(abs(kspec(:,:)));

mmax = max(max(kspecdata(2:end,:)));
mmin = max(min(kspecdata(2:end,:)));
if mmax == 0
    mmax = 0.002;
    mmin = 0.001;
end
mmax=10^ceil(log10(mmax));
mmin=10^floor(log10(mmin));

kspecdata = log10(kspecdata);

nk = floor(prm.nx/2);
if jdiag == 1
    hold on;
    
    tt = (0:ifdiag:prm.ntime)*prm.dt;
    kmin = pi/(nk*prm.dx);
    kmax = kmin*(nk);
    kk = 0:kmin:(kmax-kmin);
    hdiag.plt(hdiag.nplt).hplot = imagesc(kk,tt,kspecdata');
    xlabel('k');
    ylabel('Time');
    
    axis([0, kmax, 0,tt(end)]);
    
    hold off;
else
    set(hdiag.plt(hdiag.nplt).hplot,'cdata',kspecdata');
end

caxis([log10(mmin), log10(mmax)]);
title(sprintf('log %s (min: %4.1f, max: %4.1f)', ...
    'Ex',log10(mmin),log10(mmax)));

return
