function hdiag = plotts(hdiag,jdiag,ifdiag,xx,prm)

  global field

  fielddata = squeeze(field(1,:,:));
  
  if jdiag == 1
    hold on;

    tt = (0:ifdiag:prm.ntime)*prm.dt;

    hdiag.plt(hdiag.nplt).hplot = imagesc(xx+prm.dx*0.5,tt,fielddata');
    xlabel('X');
    ylabel('Time');
    title(sprintf('%s (min: %g, max: %g)','Ex',-prm.emax,prm.emax));
  
    axis([0, prm.nx*prm.dx, 0, tt(end)]);
    caxis([-prm.emax, prm.emax]);
    
    hold off;
  else
    set(hdiag.plt(hdiag.nplt).hplot,'cdata',fielddata');
  end

  if prm.emax <= 0
    m = max(max(abs(fielddata)));
    caxis([-m, m]);
    title(sprintf('%s (min: %5.3g, max: %5.3g)',char(str(n)),-m,m));
  end
return