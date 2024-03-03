%****************************************************************
%
%  VLASOV1m
%    One-dimensional electrostatic Vlasov code
%
%
%  FORTRAN Version (Ver.1)
%          developed by Takayuki Umeda
%          Solar-Terrestrial Environment Laboratory (STEL) and  
%          Institute for Space-Earth Environmental Research (ISEE), 
%          Nagoya University, Japan
%          Information Initiative Center, Hokkaido University, Japan
%          E-mail: umeda@iic.hokudai.ac.jp
%
%  MATLAB Version (Ver.2)
%          developed by Takayuki Umeda
%          for 11th International School for Space Simulations (ISSS-11)
%          July 21-28, 2013, National Central University, Taiwan
%
%  The original Graphical User Interface and Diagnoastics
%          developed by Koichi Shin and Yoshiharu Omura
%          for 7th International School for Space Simulations (ISSS-7)
%          March 26-31, 2005, Kyoto University, Japan
%
%  Copyright(c) 2006-
%  Takayuki Umeda, All rights reserved.
%
%  Version 2.0   July   20, 2013 for ISSS-11
%  Version 2.1   March  17, 2016 for MATLAB ver.2014b
%  Version 2.2   August 31, 2018 for ISSS-13
%  Version 2.3   March   3, 2024 for public repository in GitHub
%****************************************************************

function vlasov1_main(input_filename)

clear global
global flag_exit;
%warning('off')

%-- read parameters --
if ~exist('input_filename','file')
    input_filename = 'input_tmp.dat';  % default input filename
end
prm = input_param(input_filename);
if isempty(prm)
    return
end

%-- initialize --
hdiag = diagnostics_init(prm);
%--
[ff,gx,gv,ex,fex,ajx,xx,vx,kx,kv,prm,ifdiag]=initial(prm);
[rho]    = charge(ff,prm);
[ex,fex] = poisson(ex,rho,prm);

switch prm.scheme
    case 0
        %--- Linear ---
        [ff,ajx] = position_linear(ff,vx,prm);
    case 1
        %--- 2nd-order ---
        [ff,ajx] = position_2nd(ff,vx,prm);
    case 2
        %--- 4th-order ---
        [ff,ajx] = position_4th(ff,vx,prm);
    case 3
        %--- Cubic Spline [Cheng and Knorr JCP 1976] ---
        [ff]  = position_spline(ff,vx,prm);
        [ajx] = current(ff,vx,prm);
    case 4
        %--- FFT [e.g., Klimas JCP 1983] ---
        [ff]  = position_fft(ff,vx,kx,prm);
        [ajx] = current(ff,vx,prm);
    case 5
        %--- CIP3 [Nakamura & Yabe CPC 1999] ---
        [ff,gx,gv] = position_cip(ff,gx,gv,vx,prm);
        [ajx]      = current(ff,vx,prm);
    case 6
        %--- Central PIC4 [Umeda et al. CPC 2012] ---
        [ff,ajx] = position_pic4c(ff,vx,prm);
    otherwise
        %--- User's scheme ---
        [ff,ajx] = position(ff,vx,prm);
end

switch prm.efield
    case 2
        switch prm.scheme
            case {0 1 2 6}
                [ex,fex] = efield(ex,ajx,prm);
            otherwise
                errordlg(sprintf('ERROR: The scheme %d in not a conservative scheme!\n Switched to Charge + Poisson',prm.scheme),'ERROR');
                [ex,fex] = poisson(ex,rho,prm);
        end
    case 3
        [fex] = efield_f(fex,ajx,prm);
        
    otherwise
        [rho]    = charge(ff,prm);
        [ex,fex] = poisson(ex,rho,prm);
end

%return
%-----------
% Main loop
%-----------
jtime = 0;
jdiag = 1;

%-- diagnostics --
hdiag = diagnostics(prm,hdiag,jtime,jdiag,ifdiag,ff,fex,ajx,rho,xx,vx);
if prm.nplot == 0
    return
end

for jtime = 1:prm.ntime
    switch prm.scheme
        case 0
            %--- Linear ---
            [ff]     = velocity_linear(ff,fex,prm);
            [ff,ajx] = position_linear(ff,vx ,prm);
        case 1
            %--- 2nd-order ---
            [ff]     = velocity_2nd(ff,fex,prm);
            [ff,ajx] = position_2nd(ff,vx ,prm);
        case 2
            %--- 4th-order ---
            [ff]     = velocity_4th(ff,fex,prm);
            [ff,ajx] = position_4th(ff,vx ,prm);
        case 3
            %--- Cubic Spline [Cheng and Knorr JCP 1976] ---
            [ff]     = velocity_spline(ff,fex,prm);
            [ff]     = position_spline(ff,vx ,prm);
            [ajx]    = current(ff,vx,prm);
        case 4
            %--- FFT ---
            [ff]     = velocity_fft(ff,fex,kv,prm);
            [ff]     = position_fft(ff,vx ,kx,prm);
            [ajx]    = current(ff,vx,prm);
        case 5
            %--- CIP3 [Nakamura & Yabe CPC 1999] ---
            [ff,gx,gv] = velocity_cip(ff,gx,gv,fex,prm);
            [ff,gx,gv] = position_cip(ff,gx,gv,vx ,prm);
            [ajx]      = current(ff,vx,prm);
        case 6
            %--- Central PIC4 [Umeda et al. CPC 2012] ---
            [ff]     = velocity_pic4c(ff,fex,prm);
            [ff,ajx] = position_pic4c(ff,vx ,prm);
        otherwise
            %--- User's scheme ---
            [ff]     = velocity(ff,fex,prm);
            [ff,ajx] = position(ff,vx ,prm);
    end
    
    [rho] = charge(ff,prm);
    switch prm.efield
        case 2
            switch prm.scheme
                case {0 1 2 6}
                    [ex,fex] = efield(ex,ajx,prm);
                otherwise
                    [ex,fex] = poisson(ex,rho,prm);
            end
        case 3
            [fex] = efield_f(fex,ajx,prm);
        otherwise
            [ex,fex] = poisson(ex,rho,prm);
    end
    
    %-- diagnostics --
    if mod(jtime,ifdiag)==0
        jdiag = jdiag+1;
        hdiag = diagnostics(prm,hdiag,jtime,jdiag,ifdiag,ff,fex,ajx,rho,xx,vx);
    end

    if flag_exit
        break;
    end
end


%-- diagnostics --
if ~flag_exit
    diagnostics_last(hdiag, jtime, prm);
end

return
%
%*********************************************************************
%  Supported by Grant-In-Aid (KAKENHI) for
%               Young Scientist (Start Up) No.19840024
%               Young Scientist (B) No.21740352, No.23740367
%               Challenging Exploratory Research No.25610144
%*********************************************************************