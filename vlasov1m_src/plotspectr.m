function plotspectr(prm)

global field

fielddata = squeeze(field(1,1:prm.nx,:));

% omega
nw = floor(prm.nplot/2);
isdiag = prm.ntime/prm.nplot;
wmin = pi/(prm.dt)/nw/isdiag;
wmax = wmin*nw;
ww = 0:wmin:(wmax-wmin);

% wave number
nk = floor(prm.nx/2);
kmin = pi/(nk*prm.dx);
kmax = kmin*(nk);
kk = [-kmax:kmin:-kmin,0,kmin:kmin:kmax];


%
wk = wkfft(fielddata,prm.nx,prm.nplot,prm.nx,prm.nplot,0);
wk = [fliplr(wk(4:2:end,1:2:(end-1))'),wk(1:2:end,1:2:(end-1))'];
wk = log10(wk);
wkmax = max(max(wk));
wkmin = min(min(wk(2:nw,1:nk-1)));


%
imagesc(kk,ww,wk);
shading flat;
set(gca,'Yscale','linear');
xlabel('k');
ylabel('\omega');

caxis([wkmin, wkmax])

title(sprintf('log %s (min: %5.2g, max: %5.2g)','Ex',wkmin,wkmax))

wmaxplot = (wmax-wmin);
kmaxplot = kmax;
axis([-kmaxplot,kmaxplot,0,wmaxplot])


drawnow;
return;
