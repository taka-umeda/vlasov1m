%
% read input parameters
%
function prm = input_param(input_filename)

  prm = [];

  try
    [str1, str2] = textread(input_filename, ...
                            '%s%s','delimiter','=;','commentstyle','matlab');
  catch
    errordlg(sprintf('Can''t open input file: %s',input_filename),'Error')
    return
  end
  
  for l = 1:length(str1)
    value = eval(char(str2(l)));
    prmname= char(strread(char(str1(l)),'%s'));
    switch prmname
    case 'dx'
      prm.dx = value;
    case 'dt'
      prm.dt = value;
    case 'nx'
      prm.nx = value;
    case 'nv'
      prm.nv = value;
    case 'ntime'
      prm.ntime = value;
    case 'nplot'
      prm.nplot = value;
    case 'emax'
      prm.emax = value;
    case 'scheme'
      prm.scheme = value;
    case 'efield'
      prm.efield = value;
    case 'ns'
      prm.ns = value;
    case 'wp'
      prm.wp = value;
    case 'qm'
      prm.qm = value;
    case 'vt'
      prm.vt = value;
    case 'vd'
      prm.vd = value;
    case 'vmax'
      prm.vmax = value;
    case 'vmin'
      prm.vmin = value;
    case 'nmode'
      prm.nmode = value;
    case 'pamp'
      prm.pamp = value;
    case 'namp'
      prm.namp = value;
    case 'pphs'
      prm.pphs = value;
    case 'nphs'
      prm.nphs = value;
    case 'noise'
      prm.noise = value;
    case 'diagtype'
      prm.diagtype = value;
    otherwise
      %disp(sprintf('Plese check input parameter %s.',prmname))
    end
  end

return;
