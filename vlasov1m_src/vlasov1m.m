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
%
% VLASOV1m Application M-file for vlasov1m.fig
%
function varargout = vlasov1m(varargin)
 VLASOV_VERSION = 'VLASOV1m Version 2.3';

if nargin == 0  % LAUNCH GUI
    %-- Startup --

    % splash_screen
    % try
    %     hsp = splash_screen;
    %     if verLessThan('matlab','8.4')
    %         hspfig = hsp;
    %     else
    %         hspfig = hsp.Number;
    %     end
    %     ht = timer('TimerFcn',sprintf('delete(%d)',hspfig),'StartDelay',3);
    %     start(ht)
    %     %set(hspfig,'KeyPressFcn','delete(gcbo)');
    %     %set(hspfig,'ButtonDownFcn','delete(gcbo)');
    % catch
    %     return;
    %     %   hspfig = 0;
    % end
    hspfig = 0;
    %
    fig = openfig(mfilename,'reuse','invisible');
    %fig = openfig(mfilename,'reuse');
    % Generate a structure of handles to pass to callbacks, and store it.
    handles = guihandles(fig);
    
    %
    handles.prm = [];
    
    filename = 'input_tmp.dat';
    prm = input_param(filename); % input_paramt.m
    if isempty(prm)
        return;
    end
    handles = param_set(handles, prm);
    
    str = {'f(Vx)'; ...
        'Ex(X)'; ...
        'Rho(X)'; ...
        'Jx(X)'; ...
        'Ex(k)'; ...
        'Ex(w,k)'; ...
        'Ex(t,X)'; ...
        'Ex(t,k)'; ...
        'Energy'; ...
        };
    for k = 1:prm.ns
        str = [str;sprintf('X - Vx : Sp %2d',k)];
    end
    set(handles.popup_plot1,'String',str);
    set(handles.popup_plot2,'String',str);
    set(handles.popup_plot3,'String',str);
    set(handles.popup_plot4,'String',str);
    set(handles.popup_plot5,'String',str);
    set(handles.popup_plot6,'String',str);
    
    if hspfig
        try
            uiwait(hspfig)
        catch
        end
    end
    set(fig,'Visible','on')
    %--
    
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end
    
else
    if ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
        
        try
            if (nargout)
                [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
            else
                feval(varargin{:}); % FEVAL switchyard
            end
        catch
            %disp(lasterr);
            %errordlg(lasterr);
            errordlg('ERROR: Please check parameters!','ERROR');
        end
        
    end
    return;
end

return;

%--------------------------------------------------------------------
% EDIT_BOX: number species
%--------------------------------------------------------------------
function varargout = edit_ns_Callback(h, eventdata, handles, varargin)

% save previous parameters for species
nsold = handles.prm.ns;
handles = get_species(handles, handles.prm.sp);

%
ns = fix(str2double(get(handles.edit_ns,'String')));

if ns == nsold
    return;
end
if ns <= 0
    errordlg('Error: NS');
    return;
end

% create new species
if ns > nsold;
    for k = (nsold+1):ns
        handles.prm.wp(k) = handles.prm.wp(k-1);
        handles.prm.qm(k) = handles.prm.qm(k-1);
        handles.prm.vt(k) = handles.prm.vt(k-1);
        handles.prm.vd(k) = handles.prm.vd(k-1);
        handles.prm.vmax(k)= handles.prm.vmax(k-1);
        handles.prm.vmin(k)= handles.prm.vmin(k-1);
    end
end

%
set(handles.popup_sp,'Value',ns);
str = '';
for k = 1:ns
    str = [str;sprintf('Species %2d',k)];
end
set(handles.popup_sp,'String',str);

%
handles.prm.ns = ns;
handles.prm.sp = ns;

%
set_species(handles, ns);


%
prm.diagtype(1) = get(handles.popup_plot1,'Value');
prm.diagtype(2) = get(handles.popup_plot2,'Value');
prm.diagtype(3) = get(handles.popup_plot3,'Value');
prm.diagtype(4) = get(handles.popup_plot4,'Value');
prm.diagtype(5) = get(handles.popup_plot5,'Value');
prm.diagtype(6) = get(handles.popup_plot6,'Value');
prm.diagtype(1) = min([prm.diagtype(1),9+ns]);
prm.diagtype(2) = min([prm.diagtype(2),9+ns]);
prm.diagtype(3) = min([prm.diagtype(3),9+ns]);
prm.diagtype(4) = min([prm.diagtype(4),9+ns]);
prm.diagtype(5) = min([prm.diagtype(5),9+ns]);
prm.diagtype(6) = min([prm.diagtype(6),9+ns]);
%
str = {'f(Vx)'; ...
    'Ex(X)'; ...
    'Rho(X)'; ...
    'Jx(X)'; ...
    'Ex(k)'; ...
    'Ex(w,k)'; ...
    'Ex(t,X)'; ...
    'Ex(t,k)'; ...
    'Energy'; ...
    };
for k = 1:ns
    str = [str;sprintf('X - Vx: Sp %2d',k)];
end
set(handles.popup_plot1,'String',str);
set(handles.popup_plot2,'String',str);
set(handles.popup_plot3,'String',str);
set(handles.popup_plot4,'String',str);
set(handles.popup_plot5,'String',str);
set(handles.popup_plot6,'String',str);
try set(handles.popup_plot1,'Value',prm.diagtype(1));catch;end;
try set(handles.popup_plot2,'Value',prm.diagtype(2));catch;end;
try set(handles.popup_plot3,'Value',prm.diagtype(3));catch;end;
try set(handles.popup_plot4,'Value',prm.diagtype(4));catch;end;
try set(handles.popup_plot5,'Value',prm.diagtype(5));catch;end;
try set(handles.popup_plot6,'Value',prm.diagtype(6));catch;end;

%
guidata(gcf, handles);
return;

%--------------------------------------------------------------------
% EDIT_BOX: number species
%--------------------------------------------------------------------
function varargout = edit_nmode_Callback(h, eventdata, handles, varargin)

% save previous parameters for species
nmold = handles.prm.nmode;
handles = get_noise(handles, handles.prm.mode);

%
nmode = fix(str2double(get(handles.edit_nmode,'String')));

if nmode == nmold
    return;
end
if nmode <= 0
    errordlg('Error: NMODE');
    return;
end
if nmode > (handles.prm.nx)/2
    errordlg('Error: NMODE should be less than Nx/2');
    return;
end

% create new species
if nmode > nmold;
    for k = (nmold+1):nmode
        handles.prm.pamp(k) = 0;
        handles.prm.namp(k) = 0;
        handles.prm.pphs(k) = 0;
        handles.prm.nphs(k) = 0;
    end
end

%
set(handles.popup_mode,'Value',nmode);
str = '';
for k = 1:nmode
    str = [str;sprintf('Mode %2d',k)];
end
set(handles.popup_mode,'String',str);

%
handles.prm.nmode = nmode;
handles.prm.mode  = nmode;

%
set_noise(handles, nmode);

%
guidata(gcf, handles);
return;


%--------------------------------------------------------------------
% POPUP_MENU: Species No.
%--------------------------------------------------------------------
function varargout = popup_sp_Callback(h, eventdata, handles, varargin)

% save previous parameters for species
sp = handles.prm.sp;
handles = get_species(handles,sp);

% set parameters for species
n = get(h,'Value');
set_species(handles, n);
handles.prm.sp = n;

%
guidata(gcf, handles);
return;


%--------------------------------------------------------------------
% POPUP_MENU: Noise No.
%--------------------------------------------------------------------
function varargout = popup_mode_Callback(h, eventdata, handles, varargin)

% save previous parameters for noise
mode = handles.prm.mode;
handles = get_noise(handles,mode);

% set parameters for noise
n = get(h,'Value');
set_noise(handles, n);
handles.prm.mode = n;

%
guidata(gcf, handles);
return;



%--------------------------------------------------------------------
% get parameters
%--------------------------------------------------------------------
function prm = param_get(handles)

sp = get(handles.popup_sp,'Value');
handles = get_species(handles, sp);
mode = get(handles.popup_mode,'Value');
handles = get_noise(handles, mode);

prm = handles.prm;
prm.ns = str2double(get(handles.edit_ns,'String'));
prm.nmode = str2double(get(handles.edit_nmode,'String'));

%
prm.dx = str2double(get(handles.edit_dx,'String'));
prm.dt = str2double(get(handles.edit_dt,'String'));
prm.nx = str2double(get(handles.edit_nx,'String'));
prm.nv = str2double(get(handles.edit_nv,'String'));
prm.ntime = str2double(get(handles.edit_ntime,'String'));

%
if get(handles.radio_scheme0,'Value')
    prm.scheme = 0;
elseif get(handles.radio_scheme2,'Value')
    prm.scheme = 2;
elseif get(handles.radio_scheme3,'Value')
    prm.scheme = 3;
elseif get(handles.radio_scheme4,'Value')
    prm.scheme = 4;
elseif get(handles.radio_scheme5,'Value')
    prm.scheme = 5;
elseif get(handles.radio_scheme6,'Value')
    prm.scheme = 6;
elseif get(handles.radio_scheme7,'Value')
    prm.scheme = 7;
else
    prm.scheme = 1;
end

%
if get(handles.radio_efield2,'Value')
    prm.efield = 2;
elseif get(handles.radio_efield3,'Value')
    prm.efield = 3;
else
    prm.efield = 1;
end

%
prm.nplot= str2double(get(handles.edit_nplot,'String'));
prm.emax = str2double(get(handles.edit_emax,'String'));

%
prm.diagtype(1) = get(handles.popup_plot1,'Value');
prm.diagtype(2) = get(handles.popup_plot2,'Value');
prm.diagtype(3) = get(handles.popup_plot3,'Value');
prm.diagtype(4) = get(handles.popup_plot4,'Value');
prm.diagtype(5) = get(handles.popup_plot5,'Value');
prm.diagtype(6) = get(handles.popup_plot6,'Value');

%
if get(handles.radio_noise1,'Value')
    prm.noise = 1;
elseif get(handles.radio_noise2,'Value')
    prm.noise = 2;
else
    prm.noise = 3;
end

return

%--------------------------------------------------------------------
% BUTTTON:
%--------------------------------------------------------------------
function varargout = btn_ok_Callback(h, eventdata, handles, varargin)

prm = param_get(handles);

if prm.ntime < prm.nplot
    errordlg('NTIME < NPLOT','Error')
    return
end
if (prm.ntime/prm.nplot) - fix(prm.ntime/prm.nplot) ~= 0
    errordlg('NTIME/NPLOT must be INTEGER')
    return
end
if prm.dx <= max([abs(prm.vmax) abs(prm.vmin)])*prm.dt
    errordlg('Courant condition is not satisfied.','Error')
    return
end

filename = 'input_tmp.dat';
save_param(filename,prm);

vlasov1_main(filename);

return;

%--------------------------------------------------------------------
% get parameters for species
%--------------------------------------------------------------------
function handles = get_species(handles, sp)

handles.prm.ns = str2double(get(handles.edit_ns,'String'));
handles.prm.wp(sp) = str2double(get(handles.edit_wp,'String'));
handles.prm.qm(sp) = str2double(get(handles.edit_qm,'String'));
handles.prm.vt(sp) = str2double(get(handles.edit_vt,'String'));
handles.prm.vd(sp) = str2double(get(handles.edit_vd,'String'));
handles.prm.vmax(sp) = str2double(get(handles.edit_vmax,'String'));
handles.prm.vmin(sp) = str2double(get(handles.edit_vmin,'String'));

return;

%--------------------------------------------------------------------
% set parameters for species
%--------------------------------------------------------------------
function set_species(handles, sp)

(set(handles.edit_wp,'String',handles.prm.wp(sp)));
(set(handles.edit_qm,'String',handles.prm.qm(sp)));
(set(handles.edit_vt,'String',handles.prm.vt(sp)));
(set(handles.edit_vd,'String',handles.prm.vd(sp)));
(set(handles.edit_vmax,'String',handles.prm.vmax(sp)));
(set(handles.edit_vmin,'String',handles.prm.vmin(sp)));

return;

%--------------------------------------------------------------------
% get parameters for noise
%--------------------------------------------------------------------
function handles = get_noise(handles, mode)

handles.prm.nx = str2double(get(handles.edit_nx,'String'));
handles.prm.nmode = str2double(get(handles.edit_nmode,'String'));
handles.prm.pamp(mode) = str2double(get(handles.edit_pamp,'String'));
handles.prm.namp(mode) = str2double(get(handles.edit_namp,'String'));
handles.prm.pphs(mode) = str2double(get(handles.edit_pphs,'String'));
handles.prm.nphs(mode) = str2double(get(handles.edit_nphs,'String'));

return;

%--------------------------------------------------------------------
% set parameters for noise
%--------------------------------------------------------------------
function set_noise(handles, mode)

(set(handles.edit_pamp,'String',handles.prm.pamp(mode)));
(set(handles.edit_namp,'String',handles.prm.namp(mode)));
(set(handles.edit_pphs,'String',handles.prm.pphs(mode)));
(set(handles.edit_nphs,'String',handles.prm.nphs(mode)));

return;

%--------------------------------------------------------------------
% save parameters
%--------------------------------------------------------------------
function save_param(filename, prm)

fid = fopen(filename,'w');

fprintf(fid,'%%  Vlasov1 / input parameters\n\n');

%
fprintf(fid,'%% --  --\n');
fprintf(fid,'dx = %f;\n',prm.dx);
fprintf(fid,'dt = %f;\n',prm.dt);
fprintf(fid,'nx = %f;\n',prm.nx);
fprintf(fid,'nv = %f;\n',prm.nv);
fprintf(fid,'ntime = %f;\n',prm.ntime);
fprintf(fid,'\n');

% species
fprintf(fid,'%% -- species --\n');
fprintf(fid,'ns = %f;\n', prm.ns );

l = sprintf('%f, ',prm.wp(1:prm.ns));
fprintf(fid,'wp = [%s];\n',l);
l = sprintf('%f, ',prm.qm(1:prm.ns));
fprintf(fid,'qm = [%s];\n',l);
l = sprintf('%f, ',prm.vt(1:prm.ns));
fprintf(fid,'vt = [%s];\n',l);
l = sprintf('%f, ',prm.vd(1:prm.ns));
fprintf(fid,'vd = [%s];\n',l);
l = sprintf('%f, ',prm.vmax(1:prm.ns));
fprintf(fid,'vmax = [%s];\n',l);
l = sprintf('%f, ',prm.vmin(1:prm.ns));
fprintf(fid,'vmin = [%s];\n',l);
fprintf(fid,'\n');

fprintf(fid,'%% -- scheme --\n');
fprintf(fid,'scheme = %f;\n',prm.scheme);
fprintf(fid,'efield = %f;\n',prm.efield);
fprintf(fid,'\n');

% noise
fprintf(fid,'%% -- noise --\n');
fprintf(fid,'noise = %f;\n',prm.noise);
fprintf(fid,'\n');
fprintf(fid,'nmode = %f;\n', prm.nmode );

l = sprintf('%f, ',prm.pamp(1:prm.nmode));
fprintf(fid,'pamp = [%s];\n',l);
l = sprintf('%f, ',prm.namp(1:prm.nmode));
fprintf(fid,'namp = [%s];\n',l);
l = sprintf('%f, ',prm.pphs(1:prm.nmode));
fprintf(fid,'pphs = [%s];\n',l);
l = sprintf('%f, ',prm.nphs(1:prm.nmode));
fprintf(fid,'nphs = [%s];\n',l);
fprintf(fid,'\n');

% diag.
fprintf(fid,'%% -- diagnostics --\n');
fprintf(fid,'nplot = %f;\n',prm.nplot);
fprintf(fid,'emax = %f;\n',prm.emax);

l = sprintf('%f, ',prm.diagtype);
fprintf(fid,'diagtype = [%s];\n',l);

fclose(fid);
return;

%--------------------------------------------------------------------
% set parameters to GUI
%--------------------------------------------------------------------
function handles = param_set(handles,prm)

%
try set(handles.edit_dx,'String',num2str(prm.dx));catch;end;
try set(handles.edit_dt,'String',num2str(prm.dt));catch;end;
try set(handles.edit_nx,'String',num2str(prm.nx));catch;end;
try set(handles.edit_nv,'String',num2str(prm.nv));catch;end;
try set(handles.edit_ntime,'String',num2str(prm.ntime));catch;end;


try
    set(handles.radio_scheme0,'Value',0);
    set(handles.radio_scheme1,'Value',0);
    set(handles.radio_scheme2,'Value',0);
    set(handles.radio_scheme3,'Value',0);
    set(handles.radio_scheme4,'Value',0);
    set(handles.radio_scheme5,'Value',0);
    set(handles.radio_scheme6,'Value',0);
    set(handles.radio_scheme7,'Value',0);
    switch prm.scheme
        case 0
            set(handles.radio_scheme0,'Value',1);
        case 2
            set(handles.radio_scheme2,'Value',1);
        case 3
            set(handles.radio_scheme3,'Value',1);
        case 4
            set(handles.radio_scheme4,'Value',1);
        case 5
            set(handles.radio_scheme5,'Value',1);
        case 6
            set(handles.radio_scheme6,'Value',1);
        case 7
            set(handles.radio_scheme7,'Value',1);
        otherwise
            set(handles.radio_scheme1,'Value',1);
    end
catch
end

try
    set(handles.radio_efield1,'Value',0);
    set(handles.radio_efield2,'Value',0);
    set(handles.radio_efield3,'Value',0);
    switch prm.scheme
        case 2
            set(handles.radio_efield2,'Value',1);
        case 3
            set(handles.radio_efield3,'Value',1);
        otherwise
            set(handles.radio_efield1,'Value',1);
    end
catch
end

%
try set(handles.edit_nplot,'String',num2str(prm.nplot));catch;end;
try set(handles.edit_emax,'String',num2str(prm.emax));catch;end;

%
try set(handles.popup_plot1,'Value',prm.diagtype(1));catch;end;
try set(handles.popup_plot2,'Value',prm.diagtype(2));catch;end;
try set(handles.popup_plot3,'Value',prm.diagtype(3));catch;end;
try set(handles.popup_plot4,'Value',prm.diagtype(4));catch;end;
try set(handles.popup_plot5,'Value',prm.diagtype(5));catch;end;
try set(handles.popup_plot6,'Value',prm.diagtype(6));catch;end;


%
try set(handles.edit_ns,'String',num2str(prm.ns));catch;end;

handles.prm.ns = prm.ns;
handles.prm.qm = prm.qm;
handles.prm.wp = prm.wp;
handles.prm.vt = prm.vt;
handles.prm.vd = prm.vd;
handles.prm.vmax = prm.vmax;
handles.prm.vmin = prm.vmin;

sp = 1; %current species number
handles.prm.sp = sp;
set_species(handles,sp);

%
for k = 1:prm.ns
    ls(k) = {sprintf('Species %2d',k)};
end
try set(handles.popup_sp,'Value' ,sp);catch;end;
try set(handles.popup_sp,'String',ls);catch;end;

%
try
    set(handles.radio_noise1,'Value',0);
    set(handles.radio_noise2,'Value',0);
    set(handles.radio_noise3,'Value',0);
    switch prm.noise
        case 1
            set(handles.radio_noise1,'Value',1);
        case 2
            set(handles.radio_noise2,'Value',1);
        otherwise
            set(handles.radio_noise3,'Value',1);
    end
catch
end

%
try set(handles.edit_nmode,'String',num2str(prm.nmode));catch;end;

handles.prm.nmode = prm.nmode;
handles.prm.pamp = prm.pamp;
handles.prm.namp = prm.namp;
handles.prm.pphs = prm.pphs;
handles.prm.nphs = prm.nphs;

mode = 1; %current mode number
handles.prm.mode = mode;
set_noise(handles,mode);

%
for k = 1:prm.nmode
    lm(k) = {sprintf('Mode %2d',k)};
end
try set(handles.popup_mode,'Value' ,mode);catch;end;
try set(handles.popup_mode,'String',lm);catch;end;

%
guidata(handles.figure1, handles);

return;

%--------------------------------------------------------------------
% BUTTON: exit
%--------------------------------------------------------------------
function varargout = btn_cancel_Callback(h, eventdata, handles, varargin)

close all
delete(gcf)

return;

%--------------------------------------------------------------------
% BUTTON: load parameters
%--------------------------------------------------------------------
function varargout = btn_load_Callback(h, eventdata, handles, varargin)

[filename, pathname] = uigetfile('*.dat');
if filename
    input_filename = [pathname,filename];
    prm = input_param(input_filename);
    handles = param_set(handles, prm);
    
    str = {'f(Vx)'; ...
        'Ex(X)'; ...
        'Rho(X)'; ...
        'Jx(X)'; ...
        'Ex(k)'; ...
        'Ex(w,k)'; ...
        'Ex(t,X)'; ...
        'Ex(t,k)'; ...
        'Energy'; ...
        };
    for k = 1:prm.ns
        str = [str;sprintf('X - Vx : Sp %2d',k)];
    end
    set(handles.popup_plot1,'String',str);
    set(handles.popup_plot2,'String',str);
    set(handles.popup_plot3,'String',str);
    set(handles.popup_plot4,'String',str);
    set(handles.popup_plot5,'String',str);
    set(handles.popup_plot6,'String',str);
end


return;

%--------------------------------------------------------------------
% BUTTON: save parameters
%--------------------------------------------------------------------
function varargout = btn_save_Callback(h, eventdata, handles, varargin)

%prm = param_get(handles);
[filename, pathname] = uiputfile('*.dat');
if filename
    save_filename = [pathname,filename];
    
    prm = param_get(handles);
    save_param(save_filename,prm);
end

return;


%--------------------------------------------------------------------
% BUTTON: preview parameters
%--------------------------------------------------------------------
function varargout = btn_preview_Callback(h, eventdata, handles, varargin)

prm = param_get(handles);

%make dialog box

fig = dialog('Units','characters','Color',[1,1,1]);
pos = get(fig,'Position');
posstr = [5,5,(4+prm.ns*7)*2,10*1.5];
pos = [pos(1),pos(2),posstr(1)*2+posstr(3),posstr(2)+posstr(4)+2];
set(fig,'Position',pos);
uicontrol(fig,'String','OK','CallBack','delete(gcf)');

%
k = 1:prm.ns;
str(1) = {['NS  :' sprintf(' %g',prm.ns)]};
str(2) = {''};
str(3) = {['No. :' sprintf(' %6.4g',k)]};
str(4) = {['QM  :' sprintf(' %6.4g',prm.qm(k))]};
str(5) = {['WP  :' sprintf(' %6.4g',prm.wp(k))]};
str(6) = {['VT  :' sprintf(' %6.4g',prm.vt(k))]};
str(7) = {['VD  :' sprintf(' %6.4g',prm.vd(k))]};
str(8) = {['VMAX:' sprintf(' %6.4g',prm.vmax(k))]};
str(9) = {['VMIN:' sprintf(' %6.4g',prm.vmin(k))]};

%
if prm.dx <= max([abs(prm.vmax) abs(prm.vmin)])*prm.dt
    str(10)= {''};
    str(11)= {'Warning: Courant condition is not satisfied.'};
    
    posstr(4) = 13*1.5;
    pos = [pos(1),pos(2),posstr(1)*2+posstr(3),posstr(2)+posstr(4)+2];
    set(fig,'Position',pos);
end

%
h = uicontrol(fig,'style','text','String',str, ...
    'Units','characters', 'Position',posstr, ...
    'FontName','FixedWidth','HorizontalAlignment','left', ...
    'FontSize',10,'BackgroundColor',[1,1,1]);

return;

%--------------------------------------------------------------------
% BUTTON: preview parameters
%--------------------------------------------------------------------
function varargout = btn_prevnoise_Callback(h, eventdata, handles, varargin)

prm = param_get(handles);

%make dialog box

fig = dialog('Units','characters','Color',[1,1,1]);
pos = get(fig,'Position');
posstr = [5,5,(4+prm.nmode*7)*2,10*1.5];
pos = [pos(1),pos(2),posstr(1)*2+posstr(3),posstr(2)+posstr(4)+2];
set(fig,'Position',pos);
uicontrol(fig,'String','OK','CallBack','delete(gcf)');

switch prm.noise
    case 3
        moden  = sprintf(' %g',floor(prm.nx*0.5));
        number = '    All';
        pamp   = sprintf(' %6.4g ',max(prm.pamp(1),prm.namp(1)));
        namp   = pamp;
        pphs   = ' Random';
        nphs   = ' Random';
    case 2
        str0 = '';
        for k=1:prm.nmode
            str0 = [str0 ' Random '];
        end
        k = 1:prm.nmode;
        moden  = sprintf(' %g',prm.nmode);
        number = sprintf(' %6.4g ',k);
        pamp   = sprintf(' %6.4g ',prm.pamp(k));
        namp   = sprintf(' %6.4g ',prm.namp(k));
        pphs   = str0;
        nphs   = str0;
    otherwise
        k = 1:prm.nmode;
        moden  = sprintf(' %g',prm.nmode);
        number = sprintf(' %6.4g ',k);
        pamp   = sprintf(' %6.4g ',prm.pamp(k));
        namp   = sprintf(' %6.4g ',prm.namp(k));
        pphs   = sprintf(' %6.4g ',prm.pphs(k));
        nphs   = sprintf(' %6.4g ',prm.nphs(k));
end
%
str(1) = {['Nmode  :' moden]};
str(2) = {''};
str(3) = {['No.    :' number]};
str(4) = {['P.Amp  :' pamp]};
str(5) = {['P.Phase:' pphs]};
str(6) = {['N.Amp  :' namp]};
str(7) = {['N.Phase:' nphs]};


%
h = uicontrol(fig,'style','text','String',str, ...
    'Units','characters', 'Position',posstr, ...
    'FontName','FixedWidth','HorizontalAlignment','left', ...
    'FontSize',10,'BackgroundColor',[1,1,1]);

return;


%--------------------------------------------------------------------
% RADIO_BUTTON: scheme
%--------------------------------------------------------------------
function varargout = radio_scheme0_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',1)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme1_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',1)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme2_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',1)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme3_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',1)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme4_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',1)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme5_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',1)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme6_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',1)
set(handles.radio_scheme7,'Value',0)
return

function varargout = radio_scheme7_Callback(h, eventdata, handles, varargin)
set(handles.radio_scheme0,'Value',0)
set(handles.radio_scheme1,'Value',0)
set(handles.radio_scheme2,'Value',0)
set(handles.radio_scheme3,'Value',0)
set(handles.radio_scheme4,'Value',0)
set(handles.radio_scheme5,'Value',0)
set(handles.radio_scheme6,'Value',0)
set(handles.radio_scheme7,'Value',1)
return

%--------------------------------------------------------------------
% RADIO_BUTTON: efield
%--------------------------------------------------------------------
function varargout = radio_efield1_Callback(h, eventdata, handles, varargin)
set(handles.radio_efield1,'Value',1)
set(handles.radio_efield2,'Value',0)
set(handles.radio_efield3,'Value',0)
return

function varargout = radio_efield2_Callback(h, eventdata, handles, varargin)
set(handles.radio_efield1,'Value',0)
set(handles.radio_efield2,'Value',1)
set(handles.radio_efield3,'Value',0)
return

function varargout = radio_efield3_Callback(h, eventdata, handles, varargin)
set(handles.radio_efield1,'Value',0)
set(handles.radio_efield2,'Value',0)
set(handles.radio_efield3,'Value',1)
return


%--------------------------------------------------------------------
% RADIO_BUTTON: noise
%--------------------------------------------------------------------
function varargout = radio_noise1_Callback(h, eventdata, handles, varargin)
set(handles.radio_noise1,'Value',1)
set(handles.radio_noise2,'Value',0)
set(handles.radio_noise3,'Value',0)
return

function varargout = radio_noise2_Callback(h, eventdata, handles, varargin)
set(handles.radio_noise1,'Value',0)
set(handles.radio_noise2,'Value',1)
set(handles.radio_noise3,'Value',0)
return

function varargout = radio_noise3_Callback(h, eventdata, handles, varargin)
set(handles.radio_noise1,'Value',0)
set(handles.radio_noise2,'Value',0)
set(handles.radio_noise3,'Value',1)
return


%--------------------------------------------------------------------
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function about_Callback(hObject, eventdata, handles)

try
    hfig = splash_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)');
    uiwait(hfig);
catch
end

return

%--------------------------------------------------------------------
function hfig = splash_screen

% global VLASOV_VERSION

img = imread('about.png');
imgsize = size(img);

hfig = figure;
set(hfig,'menu','none');
set(hfig,'WindowStyle','modal');
set(hfig,'resize','off');
pos = get(hfig,'Position');
set(hfig,'Position',[pos(1) pos(2) imgsize(2) imgsize(1)]);

himag = image(img);
set(gca,'position',[0,0,1,1]);
axis off;

% h = uicontrol(hfig,'Style','Text', ...
%     'BackgroundColor',[0,0,0], ...
%     'Position',[80,0,imgsize(2)-80,20], ...
%     'HorizontalAlignment','right', ...
%     'String',VLASOV_VERSION);

drawnow
return;


%--------------------------------------------------------------------
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function paramlist1_Callback(hObject, eventdata, handles)

try
    hfig = paramlist1_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)', ...
                   'Units','normalized','Position', [0.02 0.93 0.1 0.05]);
    uiwait(hfig);
catch
end

return
function paramlist2_Callback(hObject, eventdata, handles)

try
    hfig = paramlist2_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)', ...
                   'Units','normalized','Position', [0.02 0.93 0.1 0.05]);
    uiwait(hfig);
catch
end

return
function paramlist3_Callback(hObject, eventdata, handles)

try
    hfig = paramlist3_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)', ...
                   'Units','normalized','Position', [0.02 0.93 0.1 0.05]);
    uiwait(hfig);
catch
end

return
function paramlist4_Callback(hObject, eventdata, handles)

try
    hfig = paramlist4_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)', ...
                   'Units','normalized','Position', [0.02 0.93 0.1 0.05]);
    uiwait(hfig);
catch
end

return

%--------------------------------------------------------------------
function hfig = paramlist1_screen

img = imread('paramlist1.png');
imgsize = size(img);

hfig = figure;
set(hfig,'WindowStyle','modal');
set(hfig,'resize','off');
set(hfig,'Position',[50 50 imgsize(2) imgsize(1)]);
% 
himag = image(img);
set(gca,'position',[0,0,1,1]);
axis off;
axis image;

drawnow
return
function hfig = paramlist2_screen

img = imread('paramlist2.png');
imgsize = size(img);

hfig = figure;
set(hfig,'WindowStyle','modal');
set(hfig,'resize','off');
set(hfig,'Position',[50 50 imgsize(2) imgsize(1)]);
% 
himag = image(img);
set(gca,'position',[0,0,1,1]);
axis off;
axis image;

drawnow
return
function hfig = paramlist3_screen

img = imread('paramlist3.png');
imgsize = size(img);

hfig = figure;
set(hfig,'WindowStyle','modal');
set(hfig,'resize','off');
set(hfig,'Position',[50 50 imgsize(2) imgsize(1)]);
% 
himag = image(img);
set(gca,'position',[0,0,1,1]);
axis off;
axis image;

drawnow
return
function hfig = paramlist4_screen

img = imread('paramlist4.png');
imgsize = size(img);

hfig = figure;
set(hfig,'WindowStyle','modal');
set(hfig,'resize','off');
set(hfig,'Position',[50 50 imgsize(2) imgsize(1)]);
% 
himag = image(img);
set(gca,'position',[0,0,1,1]);
axis off;
axis image;

drawnow
return


%--------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
btn_load_Callback([], [], handles)
return

%--------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
btn_save_Callback([], [], handles)
return

%--------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
btn_cancel_Callback([], [], handles)
return

%
%*********************************************************************
%  Supported by Grant-In-Aid (KAKENHI) for
%               Young Scientist (Start Up) No.19840024
%               Young Scientist (B) No.21740352, No.23740367
%               Challenging Exploratory Research No.25610144
%*********************************************************************