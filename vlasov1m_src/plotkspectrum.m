function hdiag = plotkspectrum(hdiag, jdiag, ex, prm)

nk   = floor(prm.nx/2);
spec = fft(ex(4:prm.nx+3));
ksp  = abs(spec(1:nk))/nk;

%
if jdiag == 1
    kmin = pi/(nk*prm.dx);
    kmax = kmin*(nk);
    kk = 0:kmin:(kmax-kmin);
    hdiag.plt(hdiag.nplt).kmax = kmax;
    hdiag.plt(hdiag.nplt).kmin = kmin;
    hdiag.plt(hdiag.nplt).hplot = plot(kk,ksp,'k-');
    
    set(gca,'Yscale','log');
    set(gca,'YTick',[10^-16 10^-14 10^-12 10^-10 10^-8 10^-6 10^-4 10^-2 10^0 10^2 10^4]);
    xlabel('k');
    ylabel('Ex');
else
    set(hdiag.plt(hdiag.nplt).hplot,'ydata',ksp);
end

%
mmax = max(ksp);
mmin = min(ksp(2:nk));
if mmax == 0
    mmax = 1;
    mmin = 0.01;
end
mmax=10^ceil(log10(mmax));
mmin=max(10^-9,10^floor(log10(mmin)));
kmax = hdiag.plt(hdiag.nplt).kmax;
kmin = hdiag.plt(hdiag.nplt).kmin;
axis([0 kmax mmin mmax]);

return
