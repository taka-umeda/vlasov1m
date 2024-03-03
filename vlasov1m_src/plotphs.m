function hdiag = plotphs(hdiag, jdiag, n, ff, xx, vx, prm, ren)
if jdiag == 1
    hplot = pcolor(xx,vx(:,n),ff(:,:,n));shading flat
    
    axis([0 prm.nx*prm.dx prm.vmin(n),prm.vmax(n)]);
    xlabel('X');
    str=sprintf('Vx: Sp%2d',n);
    ylabel(str);
    
    hdiag.plt(hdiag.nplt).hplot = hplot;
else
    set(hdiag.plt(hdiag.nplt).hplot,'cdata',ff(:,:,n));    
end
return
