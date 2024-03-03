function hdiag = plotfield(hdiag, jdiag, fex, xx, prm, flag)
if jdiag == 1
    hdiag.plt(hdiag.nplt).hplot = plot(xx, fex, 'k','LineWidth',1);
        
    %
    set(gca,'xlim',[0 prm.nx*prm.dx]);
    if prm.emax > 0
        set(gca,'ylim',[-prm.emax prm.emax]);
    end
    
    %
    xlabel('X');
    switch flag
        case 3
            ylabel('Jx');
        case 2
            ylabel('\rho');
        otherwise
            ylabel('Ex');
    end    
else
    set(hdiag.plt(hdiag.nplt).hplot,'ydata',fex)
end
return
