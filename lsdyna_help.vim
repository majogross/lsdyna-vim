" Vim help system for LS-DYNA cards
" Shows field descriptions for LS-DYNA keywords
"
" Installation: Place in ~/.vim/after/ftplugin/lsdyna_help.vim
"
" Usage: Press K (shift-k) when cursor is on an LS-DYNA keyword line
"        Or use :LSDynaHelp to show help for current line

if &filetype !=# 'lsdyna'
  finish
endif

" Set up keyword lookup
setlocal keywordprg=:call\ LSDynaShowHelp()

" Define the help database
let s:lsdyna_help = {}

" Basic keywords
let s:lsdyna_help['*KEYWORD'] = [
  \ 'KEYWORD - Start of LS-DYNA input deck',
  \ '',
  \ 'This marks the beginning of an LS-DYNA input file.',
  \ 'All keyword-based input must start with *KEYWORD.',
  \ '',
  \ 'Usage: Place at the very start of your input file.',
  \ ]

let s:lsdyna_help['*TITLE'] = [
  \ 'TITLE - Model title/description',
  \ '',
  \ 'Provides a descriptive title for the analysis.',
  \ 'Limited to 80 characters.',
  \ '',
  \ 'Format:',
  \ '  *TITLE',
  \ '  Your model description here',
  \ ]

let s:lsdyna_help['*NODE'] = [
  \ 'NODE - Node definitions',
  \ '',
  \ 'Defines node coordinates in the finite element mesh.',
  \ '',
  \ 'Format:',
  \ '  *NODE',
  \ '  $#   nid               x               y               z      tc      rc',
  \ '       1             0.0             0.0             0.0       0       0',
  \ '',
  \ 'Fields:',
  \ '  nid - Node ID (integer, unique)',
  \ '  x   - X coordinate (real)',
  \ '  y   - Y coordinate (real)',
  \ '  z   - Z coordinate (real)',
  \ '  tc  - Translation constraint (integer, 0=free)',
  \ '  rc  - Rotation constraint (integer, 0=free)',
  \ ]

let s:lsdyna_help['*ELEMENT_SOLID'] = [
  \ 'ELEMENT_SOLID - 8-node solid element',
  \ '',
  \ 'Defines hexahedral (brick) solid elements.',
  \ '',
  \ 'Format:',
  \ '  *ELEMENT_SOLID',
  \ '  $#   eid     pid      n1      n2      n3      n4      n5      n6      n7      n8',
  \ '       1       1       1       2       3       4       5       6       7       8',
  \ '',
  \ 'Fields:',
  \ '  eid - Element ID (integer, unique)',
  \ '  pid - Part ID (integer, references *PART)',
  \ '  n1-n8 - Node IDs defining element (8 corner nodes)',
  \ '',
  \ 'Node ordering: Bottom face (n1-n4) counter-clockwise,',
  \ '                top face (n5-n8) counter-clockwise',
  \ ]

let s:lsdyna_help['*ELEMENT_SHELL'] = [
  \ 'ELEMENT_SHELL - 4-node shell element',
  \ '',
  \ 'Defines quadrilateral shell elements for thin structures.',
  \ '',
  \ 'Format:',
  \ '  *ELEMENT_SHELL',
  \ '  $#   eid     pid      n1      n2      n3      n4',
  \ '       1       1       1       2       3       4',
  \ '',
  \ 'Fields:',
  \ '  eid - Element ID (integer, unique)',
  \ '  pid - Part ID (integer, references *PART)',
  \ '  n1-n4 - Node IDs in counter-clockwise order',
  \ '',
  \ 'Normal direction: Right-hand rule from node sequence',
  \ ]

let s:lsdyna_help['*PART'] = [
  \ 'PART - Part definition',
  \ '',
  \ 'Groups elements and assigns material and section properties.',
  \ '',
  \ 'Format:',
  \ '  *PART',
  \ '  Part description',
  \ '  $#     pid     secid       mid     eosid      hgid      grav    adpopt      tmid',
  \ '         1         1         1         0         0         0         0         0',
  \ '',
  \ 'Fields:',
  \ '  pid - Part ID (integer, unique, referenced by elements)',
  \ '  secid - Section ID (references *SECTION_*)',
  \ '  mid - Material ID (references *MAT_*)',
  \ '  eosid - Equation of state ID (0=none)',
  \ '  hgid - Hourglass ID (0=use CONTROL_HOURGLASS)',
  \ '  grav - Gravity load curve ID (0=none)',
  \ '  adpopt - Adaptive remeshing (0=off)',
  \ '  tmid - Thermal material ID (0=none)',
  \ ]

" Material Models
let s:lsdyna_help['*MAT_ELASTIC'] = [
  \ 'MAT_ELASTIC - Linear elastic material (MAT_001)',
  \ '',
  \ 'Simple linear elastic material model.',
  \ '',
  \ 'Format:',
  \ '  *MAT_ELASTIC',
  \ '  $#     mid        ro         e        pr        da        db',
  \ '         1    7850.0 2.1000E11      0.30       0.0       0.0',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID (integer, unique)',
  \ '  ro  - Mass density (mass/volume)',
  \ '  e   - Youngs modulus (stress units)',
  \ '  pr  - Poissons ratio (0.0-0.5)',
  \ '  da  - Damping constant a (0.0=none)',
  \ '  db  - Damping constant b (0.0=none)',
  \ '',
  \ 'Common values:',
  \ '  Steel: ro=7850, E=2.1E11 Pa, nu=0.30',
  \ '  Aluminum: ro=2700, E=7.0E10 Pa, nu=0.33',
  \ ]

let s:lsdyna_help['*MAT_RIGID'] = [
  \ 'MAT_RIGID - Rigid material (MAT_020)',
  \ '',
  \ 'Defines rigid body with mass properties.',
  \ '',
  \ 'Format:',
  \ '  *MAT_RIGID',
  \ '  $#     mid        ro         e        pr         n    couple         m     alias',
  \ '         1    7850.0 2.1000E11      0.30       0.0       0.0       0.0',
  \ '  $#     cmo      con1      con2',
  \ '         1         7         7',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  e   - Youngs modulus (for contact stiffness)',
  \ '  pr  - Poissons ratio',
  \ '  n   - Bulk viscosity flag',
  \ '  cmo - Center of mass option: 0=default, 1=user-defined',
  \ '  con1 - Constraint option for translation: 7=all fixed',
  \ '  con2 - Constraint option for rotation: 7=all fixed',
  \ '',
  \ 'Notes:',
  \ '  - Use for rigid tools, supports, or very stiff parts',
  \ '  - All elements with this MID move together',
  \ '  - con1/con2: Sum DOF numbers (x=1, y=2, z=4)',
  \ ]

let s:lsdyna_help['*MAT_PLASTIC_KINEMATIC'] = [
  \ 'MAT_PLASTIC_KINEMATIC - Elasto-plastic material (MAT_003)',
  \ '',
  \ 'Isotropic and kinematic hardening plasticity.',
  \ '',
  \ 'Format:',
  \ '  *MAT_PLASTIC_KINEMATIC',
  \ '  $#     mid        ro         e        pr      sigy      etan      fail      tdel',
  \ '         1    7850.0 2.1000E11      0.30 2.5000E08       0.0       0.0       0.0',
  \ '  $#       c         p      lcss      lcsr        vp',
  \ '       0.0       0.0         0         0       0.0',
  \ '',
  \ 'Fields:',
  \ '  mid  - Material ID',
  \ '  ro   - Mass density',
  \ '  e    - Youngs modulus',
  \ '  pr   - Poissons ratio',
  \ '  sigy - Yield stress',
  \ '  etan - Tangent modulus (hardening slope)',
  \ '  fail - Failure strain (0=no failure)',
  \ '  c    - Strain rate parameter C',
  \ '  p    - Strain rate parameter p',
  \ '  lcss - Load curve for stress-strain (0=use etan)',
  \ '  vp   - Formulation: 0=isotropic, 1=kinematic',
  \ '',
  \ 'Cowper-Symonds strain rate: sigma_y = sigy * (1 + (e_dot/C)^(1/p))',
  \ ]

let s:lsdyna_help['*MAT_PIECEWISE_LINEAR_PLASTICITY'] = [
  \ 'MAT_PIECEWISE_LINEAR_PLASTICITY - Elasto-plastic (MAT_024)',
  \ '',
  \ 'Most commonly used metal plasticity model.',
  \ '',
  \ 'Format:',
  \ '  *MAT_PIECEWISE_LINEAR_PLASTICITY',
  \ '  $#     mid        ro         e        pr      sigy      etan      fail      tdel',
  \ '         1    7850.0 2.1000E11      0.30 2.5000E08       0.0       0.0       0.0',
  \ '  $#       c         p      lcss      lcsr        vp',
  \ '       40.4      5.0         1         0       0.0',
  \ '',
  \ 'Fields:',
  \ '  mid  - Material ID',
  \ '  ro   - Mass density',
  \ '  e    - Youngs modulus',
  \ '  pr   - Poissons ratio',
  \ '  sigy - Yield stress (used if lcss=0)',
  \ '  etan - Tangent modulus',
  \ '  fail - Failure plastic strain (0=no failure)',
  \ '  c    - Strain rate parameter C (s^-1)',
  \ '  p    - Strain rate parameter p',
  \ '  lcss - Load curve: effective stress vs plastic strain',
  \ '  lcsr - Load curve: strain rate scaling',
  \ '  vp   - Formulation: 0=default scale, 1=viscoplastic',
  \ '',
  \ 'Notes:',
  \ '  - Define *DEFINE_CURVE for lcss with stress-strain pairs',
  \ '  - Recommended for most metal forming applications',
  \ ]

let s:lsdyna_help['*MAT_JOHNSON_COOK'] = [
  \ 'MAT_JOHNSON_COOK - High strain rate plasticity (MAT_015)',
  \ '',
  \ 'Johnson-Cook model for high velocity impact.',
  \ '',
  \ 'Format:',
  \ '  *MAT_JOHNSON_COOK',
  \ '  $#     mid        ro         g         e        pr       dtf        vp    rateop',
  \ '         1    7850.0 8.0000E10 2.1000E11      0.30       0.0       0.0       0.0',
  \ '  $#       a         b         n         c         m        tm        tr      epso',
  \ ' 7.9200E08 5.1000E08      0.26     0.014      1.03    1793.0     293.0       1.0',
  \ '  $#      cp        pc     spall        it        d1        d2        d3        d4',
  \ '     452.0       0.0       2.0       0.0      0.05      3.44     -2.12     0.002',
  \ '  $#      d5      c2/p      erod      efmin',
  \ '       0.0       0.0       0.0       0.0',
  \ '',
  \ 'Constitutive equation:',
  \ '  sigma = [A + B*eps^n] * [1 + C*ln(eps_dot*)] * [1 - T*^m]',
  \ '  where T* = (T-Tr)/(Tm-Tr)',
  \ '',
  \ 'Key parameters:',
  \ '  a  - Yield stress',
  \ '  b  - Hardening constant',
  \ '  n  - Hardening exponent',
  \ '  c  - Strain rate constant',
  \ '  m  - Thermal softening exponent',
  \ '  tm - Melting temperature',
  \ '  tr - Room temperature',
  \ '  d1-d5 - Damage parameters',
  \ '',
  \ 'Applications: Ballistic impact, crash, metal cutting',
  \ ]

let s:lsdyna_help['*MAT_HONEYCOMB'] = [
  \ 'MAT_HONEYCOMB - Honeycomb material (MAT_026)',
  \ '',
  \ 'Orthotropic crushable material for honeycomb cores.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  e   - Youngs modulus in longitudinal direction',
  \ '  pr  - Poissons ratio',
  \ '  sigy - Yield stress in normal direction',
  \ '  vf  - Relative volume at full compaction',
  \ '',
  \ 'Applications:',
  \ '  - Aluminum honeycomb cores',
  \ '  - Energy absorption structures',
  \ '  - Sandwich panel cores',
  \ ]

let s:lsdyna_help['*MAT_CRUSHABLE_FOAM'] = [
  \ 'MAT_CRUSHABLE_FOAM - Isotropic foam material (MAT_063)',
  \ '',
  \ 'Low density urethane foam with volumetric hardening.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  e   - Youngs modulus',
  \ '  pr  - Poissons ratio',
  \ '  lcid - Load curve: stress vs volumetric strain',
  \ '',
  \ 'Applications:',
  \ '  - Foam padding',
  \ '  - Energy absorbers',
  \ '  - Seat cushions',
  \ '  - Packaging materials',
  \ '',
  \ 'Note: Define *DEFINE_CURVE with compression test data',
  \ ]

let s:lsdyna_help['*MAT_COMPOSITE_DAMAGE'] = [
  \ 'MAT_COMPOSITE_DAMAGE - Composite material (MAT_022)',
  \ '',
  \ 'Orthotropic material with Chang-Chang failure.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  ea  - Youngs modulus in a-direction',
  \ '  eb  - Youngs modulus in b-direction',
  \ '  pr  - Poissons ratio ba',
  \ '  gab - Shear modulus',
  \ '  xt  - Tensile strength in a-direction',
  \ '  xc  - Compressive strength in a-direction',
  \ '  yt  - Tensile strength in b-direction',
  \ '  yc  - Compressive strength in b-direction',
  \ '  sc  - Shear strength',
  \ '',
  \ 'Applications:',
  \ '  - Carbon fiber composites',
  \ '  - Glass fiber laminates',
  \ '  - Woven fabrics',
  \ ]

let s:lsdyna_help['*MAT_MOONEY-RIVLIN_RUBBER'] = [
  \ 'MAT_MOONEY-RIVLIN_RUBBER - Hyperelastic rubber (MAT_027)',
  \ '',
  \ 'Mooney-Rivlin hyperelastic material model.',
  \ '',
  \ 'Format:',
  \ '  *MAT_MOONEY-RIVLIN_RUBBER',
  \ '  $#     mid        ro        pr         a         b        ref',
  \ '         1    1100.0      0.49       0.5       0.1       0.0',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  pr  - Poissons ratio (0.49-0.4999 for incompressibility)',
  \ '  a   - Mooney-Rivlin constant A',
  \ '  b   - Mooney-Rivlin constant B (B < A typically)',
  \ '  ref - Use reference geometry flag',
  \ '',
  \ 'Strain energy: W = A(I1-3) + B(I2-3)',
  \ '',
  \ 'Applications:',
  \ '  - Rubber seals',
  \ '  - Tires',
  \ '  - Elastomers',
  \ ]

let s:lsdyna_help['*MAT_BLATZ-KO_RUBBER'] = [
  \ 'MAT_BLATZ-KO_RUBBER - Foam rubber material (MAT_007)',
  \ '',
  \ 'Compressible foam rubber model.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  g   - Shear modulus',
  \ '',
  \ 'Applications:',
  \ '  - Polyurethane foam',
  \ '  - Compressible rubber',
  \ ]

let s:lsdyna_help['*MAT_NULL'] = [
  \ 'MAT_NULL - Null material (MAT_009)',
  \ '',
  \ 'Material with no deviatoric strength, used with EOS.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  pc  - Pressure cutoff (tension)',
  \ '',
  \ 'Applications:',
  \ '  - Fluids (with *EOS)',
  \ '  - Gases',
  \ '  - Explosives (with *EOS_JWL)',
  \ '',
  \ 'Note: Must be used with equation of state',
  \ ]

let s:lsdyna_help['*MAT_VISCOELASTIC'] = [
  \ 'MAT_VISCOELASTIC - Viscoelastic material (MAT_006)',
  \ '',
  \ 'Linear viscoelastic model with relaxation.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  bulk - Bulk modulus',
  \ '  g0 - Short time shear modulus',
  \ '  gi - Long time shear modulus',
  \ '  beta - Decay constant',
  \ '',
  \ 'Applications:',
  \ '  - Polymers',
  \ '  - Damping materials',
  \ '  - Time-dependent behavior',
  \ ]

let s:lsdyna_help['*MAT_SOIL_AND_FOAM'] = [
  \ 'MAT_SOIL_AND_FOAM - Soil/foam material (MAT_005)',
  \ '',
  \ 'Soil model with pressure-dependent yield.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  g   - Shear modulus',
  \ '  bulk - Bulk modulus',
  \ '  a0, a1, a2 - Yield function parameters',
  \ '  pc - Pressure cutoff',
  \ '',
  \ 'Applications:',
  \ '  - Soil mechanics',
  \ '  - Granular materials',
  \ '  - Low density foam',
  \ ]

let s:lsdyna_help['*MAT_SIMPLIFIED_RUBBER'] = [
  \ 'MAT_SIMPLIFIED_RUBBER - Simple rubber model (MAT_077)',
  \ '',
  \ 'Simplified rubber material for efficiency.',
  \ '',
  \ 'Fields:',
  \ '  mid - Material ID',
  \ '  ro  - Mass density',
  \ '  e   - Youngs modulus',
  \ '  pr  - Poissons ratio (0.495 typical)',
  \ '  n   - Strain hardening exponent',
  \ '  sigy - Initial yield stress',
  \ '',
  \ 'Applications:',
  \ '  - Simple rubber parts',
  \ '  - When detailed hyperelastic model not needed',
  \ ]

let s:lsdyna_help['*SECTION_SHELL'] = [
  \ 'SECTION_SHELL - Shell section properties',
  \ '',
  \ 'Defines thickness and integration for shell elements.',
  \ '',
  \ 'Format:',
  \ '  *SECTION_SHELL',
  \ '  $#   secid    elform      shrf       nip     propt   qr/irid     icomp     setyp',
  \ '         1         2       1.0         5       1.0         0         0         1',
  \ '  $#      t1        t2        t3        t4      nloc     marea      idof    edgset',
  \ '       1.0       1.0       1.0       1.0       0.0       0.0       0.0         0',
  \ '',
  \ 'Key Fields:',
  \ '  secid - Section ID (integer, unique)',
  \ '  elform - Element formulation:',
  \ '           1=Hughes-Liu, 2=Belytschko-Tsay (default)',
  \ '           16=fully integrated',
  \ '  shrf - Shear correction factor (1.0 default)',
  \ '  nip - Number of integration points through thickness:',
  \ '        2=2 points, 3=3 points, 5=5 points (recommended)',
  \ '  t1-t4 - Shell thickness at nodes 1-4',
  \ ]

let s:lsdyna_help['*CONTACT_AUTOMATIC_SURFACE_TO_SURFACE'] = [
  \ 'CONTACT_AUTOMATIC_SURFACE_TO_SURFACE',
  \ '',
  \ 'Penalty-based contact between two surfaces.',
  \ '',
  \ 'Format:',
  \ '  *CONTACT_AUTOMATIC_SURFACE_TO_SURFACE',
  \ '  $#     cid                                                                 title',
  \ '         0',
  \ '  $#    ssid      msid     sstyp     mstyp    sboxid    mboxid       spr       mpr',
  \ '         1         2         0         0         0         0         0         0',
  \ '  $#      fs        fd        dc        vc       vdc    penchk        bt        dt',
  \ '       0.0       0.0       0.0       0.0       0.0         0       0.0 1.0000E20',
  \ '',
  \ 'Key Fields:',
  \ '  ssid - Slave segment set ID',
  \ '  msid - Master segment set ID',
  \ '  fs - Static friction coefficient (0.0=frictionless)',
  \ '  fd - Dynamic friction coefficient',
  \ '  dc - Exponential decay coefficient',
  \ '  vc - Coefficient for viscous friction',
  \ '',
  \ 'Tips:',
  \ '  - Slave surface: finer mesh, softer material',
  \ '  - Master surface: coarser mesh, stiffer material',
  \ ]

let s:lsdyna_help['*CONTROL_TERMINATION'] = [
  \ 'CONTROL_TERMINATION - Analysis termination controls',
  \ '',
  \ 'Defines when the analysis should stop.',
  \ '',
  \ 'Format:',
  \ '  *CONTROL_TERMINATION',
  \ '  $#  endtim    endcyc     dtmin    endeng    endmas     nosol',
  \ '      10.0         0       0.0       0.0       0.0         0',
  \ '',
  \ 'Fields:',
  \ '  endtim - Termination time (required)',
  \ '  endcyc - Termination cycle number (0=use time)',
  \ '  dtmin - Minimum time step (0=no limit)',
  \ '  endeng - % energy error limit (0=no limit)',
  \ '  endmas - % mass change limit (0=no limit)',
  \ '  nosol - 1=model check only, 0=full analysis',
  \ ]

let s:lsdyna_help['*CONTROL_TIMESTEP'] = [
  \ 'CONTROL_TIMESTEP - Time step size control',
  \ '',
  \ 'Controls automatic time step calculation.',
  \ '',
  \ 'Format:',
  \ '  *CONTROL_TIMESTEP',
  \ '  $#  dtinit    tssfac      isdo    tslimt     dt2ms      lctm     erode     ms1st',
  \ '       0.0      0.90         0       0.0         0         0         0         0',
  \ '',
  \ 'Key Fields:',
  \ '  dtinit - Initial time step (0=automatic)',
  \ '  tssfac - Scale factor for computed time step:',
  \ '           0.9=default (conservative)',
  \ '           0.67=more stable, 0.95=faster but risky',
  \ '  isdo - Time step calculation:',
  \ '        0=automatic, -1=user-defined curve',
  \ '',
  \ 'Stability: dt < L / c (element size / wave speed)',
  \ ]

let s:lsdyna_help['*DATABASE_BINARY_D3PLOT'] = [
  \ 'DATABASE_BINARY_D3PLOT - Binary plot file output',
  \ '',
  \ 'Controls d3plot file output for post-processing.',
  \ '',
  \ 'Format:',
  \ '  *DATABASE_BINARY_D3PLOT',
  \ '  $#      dt      lcdt      beam     npltc    psetid',
  \ '     0.001         0         0         0         0',
  \ '  $#   ioopt      rate    cutoff    window      type      pset',
  \ '         0       0.0       0.0       0.0         0         0',
  \ '',
  \ 'Key Fields:',
  \ '  dt - Time interval between outputs',
  \ '  lcdt - Load curve for variable dt (0=constant)',
  \ '  ioopt - 0=state files only, 1=state + extras',
  \ '',
  \ 'Tips:',
  \ '  - Smaller dt = more frames, larger files',
  \ '  - Typical: dt = endtim/100 for 100 frames',
  \ '  - For 10s simulation: dt=0.1 gives 100 frames',
  \ ]

let s:lsdyna_help['*BOUNDARY_SPC_SET'] = [
  \ 'BOUNDARY_SPC_SET - Fixed boundary conditions',
  \ '',
  \ 'Constrains degrees of freedom for a node set.',
  \ '',
  \ 'Format:',
  \ '  *BOUNDARY_SPC_SET',
  \ '  $#    nsid       cid      dofx      dofy      dofz     dofrx     dofry     dofrz',
  \ '         1         0         1         1         1         0         0         0',
  \ '',
  \ 'Fields:',
  \ '  nsid - Node set ID (references *SET_NODE_*)',
  \ '  cid - Coordinate system ID (0=global)',
  \ '  dofx - Constrain X translation (0=free, 1=fixed)',
  \ '  dofy - Constrain Y translation (0=free, 1=fixed)',
  \ '  dofz - Constrain Z translation (0=free, 1=fixed)',
  \ '  dofrx - Constrain X rotation (0=free, 1=fixed)',
  \ '  dofry - Constrain Y rotation (0=free, 1=fixed)',
  \ '  dofrz - Constrain Z rotation (0=free, 1=fixed)',
  \ '',
  \ 'Example: Fixed support: dofx=dofy=dofz=1',
  \ ]

let s:lsdyna_help['*DEFINE_CURVE'] = [
  \ 'DEFINE_CURVE - Load curve definition',
  \ '',
  \ 'Defines time-dependent or parametric curves.',
  \ '',
  \ 'Format:',
  \ '  *DEFINE_CURVE',
  \ '  $#    lcid      sidr       sfa       sfo      offa      offo    dattyp     lcint',
  \ '         1         0       1.0       1.0       0.0       0.0         0         0',
  \ '  $#                a1                  o1',
  \ '                 0.0                 0.0',
  \ '                 1.0                 1.0',
  \ '',
  \ 'Fields:',
  \ '  lcid - Load curve ID (integer, unique)',
  \ '  sfa - Scale factor for abscissa (x-axis)',
  \ '  sfo - Scale factor for ordinate (y-axis)',
  \ '  offa - Offset for abscissa',
  \ '  offo - Offset for ordinate',
  \ '  a1, o1 - Data points (time, value) pairs',
  \ '',
  \ 'Tips:',
  \ '  - Linear interpolation between points',
  \ '  - Extrapolates with last value',
  \ ]

" Main help function
function! LSDynaShowHelp()
  " Get the current line
  let line = getline('.')
  
  " Extract keyword (line starting with *)
  let keyword = matchstr(line, '^\*[A-Z_][A-Z0-9_-]*')
  
  if empty(keyword)
    echo "No LS-DYNA keyword found on current line"
    return
  endif
  
  " Look up help for this keyword
  if has_key(s:lsdyna_help, keyword)
    call s:DisplayHelp(keyword, s:lsdyna_help[keyword])
  else
    " Try to provide generic help
    call s:DisplayGenericHelp(keyword)
  endif
endfunction

" Display help in a split window
function! s:DisplayHelp(keyword, helptext)
  " Create or reuse help window
  let helpwin = bufwinnr('__LSDynaHelp__')
  
  if helpwin > 0
    " Window exists, switch to it
    execute helpwin . 'wincmd w'
  else
    " Create new split window
    silent! split __LSDynaHelp__
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nowrap
    setlocal filetype=help
    resize 15
  endif
  
  " Clear and write help content
  setlocal modifiable
  silent! %delete _
  call setline(1, a:helptext)
  setlocal nomodifiable
  
  " Return to original window
  wincmd p
endfunction

" Generic help for unknown keywords
function! s:DisplayGenericHelp(keyword)
  let generic_help = [
    \ a:keyword . ' - LS-DYNA keyword',
    \ '',
    \ 'No detailed help available for this keyword.',
    \ '',
    \ 'This is an LS-DYNA keyword card.',
    \ 'Refer to the LS-DYNA manual for detailed information.',
    \ '',
    \ 'Common keyword categories:',
    \ '  *NODE, *ELEMENT_* - Mesh definitions',
    \ '  *PART, *SECTION_*, *MAT_* - Material properties',
    \ '  *CONTACT_* - Contact definitions',
    \ '  *CONTROL_* - Analysis control',
    \ '  *DATABASE_* - Output control',
    \ '  *BOUNDARY_*, *LOAD_* - Boundary conditions',
    \ '  *DEFINE_* - Curves, functions, etc.',
    \ '  *SET_* - Entity sets',
    \ ]
  
  call s:DisplayHelp(a:keyword, generic_help)
endfunction

" Command to show help
command! -buffer LSDynaHelp call LSDynaShowHelp()

" Map K to show help
nnoremap <buffer> K :call LSDynaShowHelp()<CR>

echo "LS-DYNA help loaded. Press K on a keyword line to show help"