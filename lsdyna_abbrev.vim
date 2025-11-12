" Vim abbreviations for LS-DYNA input files
" This file provides code templates without requiring a snippet engine
" Works with plain Vim using built-in abbreviations
"
" Installation:
"   1. Copy this file to ~/.vim/after/ftplugin/lsdyna_abbrev.vim
"      OR
"   2. Source it manually: :source lsdyna_abbrev.vim
"      OR
"   3. Add to ~/.vimrc: autocmd FileType lsdyna source /path/to/lsdyna_abbrev.vim
"
" Usage: Type the abbreviation and press Space or Enter

" Only set abbreviations for lsdyna filetype
if &filetype !=# 'lsdyna'
  finish
endif

" Basic structure
iabbrev <buffer> lsdkeyword *KEYWORD<CR>$<CR>$ LS-DYNA Input Deck<CR>$<CR>*TITLE<CR>Simulation Title<CR><CR>*END

iabbrev <buffer> lsdtitle *TITLE<CR>Simulation Title

iabbrev <buffer> lsdcomment $<CR>$ Comment section<CR>$

" Node definition
iabbrev <buffer> lsdnode *NODE<CR>$#   nid               x               y               z      tc      rc<CR>       1             0.0             0.0             0.0       0       0

" Element definitions
iabbrev <buffer> lsdelsolid *ELEMENT_SOLID<CR>$#   eid     pid      n1      n2      n3      n4      n5      n6      n7      n8<CR>       1       1       1       2       3       4       5       6       7       8

iabbrev <buffer> lsdelshell *ELEMENT_SHELL<CR>$#   eid     pid      n1      n2      n3      n4<CR>       1       1       1       2       3       4

iabbrev <buffer> lsdelbeam *ELEMENT_BEAM<CR>$#   eid     pid      n1      n2      n3     rt1     rr1     rt2     rr2   local<CR>       1       1       1       2       0       0       0       0       0       0

" Part definition
iabbrev <buffer> lsdpart *PART<CR>Part Title<CR>$#     pid     secid       mid     eosid      hgid      grav    adpopt      tmid<CR>         1         1         1         0         0         0         0         0

" Section definitions
iabbrev <buffer> lsdsecshell *SECTION_SHELL<CR>$#   secid    elform      shrf       nip     propt   qr/irid     icomp     setyp<CR>         1         2       1.0         5       1.0         0         0         1<CR>$#      t1        t2        t3        t4      nloc     marea      idof    edgset<CR>       1.0       1.0       1.0       1.0       0.0       0.0       0.0         0

iabbrev <buffer> lsdsecsolid *SECTION_SOLID<CR>$#   secid    elform       aet<CR>         1         1         0

iabbrev <buffer> lsdsecbeam *SECTION_BEAM<CR>$#   secid    elform      shrf   qr/irid       cst     scoor       nsm<CR>         1         1       1.0         2         0       0.0       0.0

" Material definitions
iabbrev <buffer> lsdmatelastic *MAT_ELASTIC<CR>$#     mid        ro         e        pr        da        db<CR>         1    7850.0 2.1000E11      0.30       0.0       0.0

iabbrev <buffer> lsdmatpwl *MAT_PIECEWISE_LINEAR_PLASTICITY<CR>$#     mid        ro         e        pr      sigy      etan      fail      tdel<CR>         1    7850.0 2.1000E11      0.30 2.5000E08       0.0       0.0       0.0<CR>$#       c         p      lcss      lcsr        vp<CR>       0.0       0.0         0         0       0.0

iabbrev <buffer> lsdmatrigid *MAT_RIGID<CR>$#     mid        ro         e        pr         n    couple         m     alias<CR>         1    7850.0 2.1000E11      0.30       0.0       0.0       0.0<CR>$#     cmo      con1      con2<CR>         1         7         7

iabbrev <buffer> lsdmatjc *MAT_JOHNSON_COOK<CR>$#     mid        ro         g         e        pr       dtf        vp    rateop<CR>         1    7850.0 8.0000E10 2.1000E11      0.30       0.0       0.0       0.0<CR>$#       a         b         n         c         m        tm        tr      epso<CR> 7.9200E08 5.1000E08      0.26     0.014      1.03    1793.0     293.0       1.0

" Contact definitions
iabbrev <buffer> lsdcontactss *CONTACT_AUTOMATIC_SURFACE_TO_SURFACE<CR>$#     cid                                                                 title<CR>         0<CR>$#    ssid      msid     sstyp     mstyp    sboxid    mboxid       spr       mpr<CR>         1         2         0         0         0         0         0         0<CR>$#      fs        fd        dc        vc       vdc    penchk        bt        dt<CR>       0.0       0.0       0.0       0.0       0.0         0       0.0 1.0000E20

iabbrev <buffer> lsdcontactauto *CONTACT_AUTOMATIC_SINGLE_SURFACE<CR>$#     cid                                                                 title<CR>         0<CR>$#    ssid      msid     sstyp     mstyp    sboxid    mboxid       spr       mpr<CR>         1         0         0         0         0         0         0         0<CR>$#      fs        fd        dc        vc       vdc    penchk        bt        dt<CR>       0.0       0.0       0.0       0.0       0.0         0       0.0 1.0000E20

" Control cards
iabbrev <buffer> lsdcontrolterm *CONTROL_TERMINATION<CR>$#  endtim    endcyc     dtmin    endeng    endmas     nosol<CR>      10.0         0       0.0       0.0       0.0         0

iabbrev <buffer> lsdcontroltime *CONTROL_TIMESTEP<CR>$#  dtinit    tssfac      isdo    tslimt     dt2ms      lctm     erode     ms1st<CR>       0.0      0.90         0       0.0         0         0         0         0

iabbrev <buffer> lsdcontrolenergy *CONTROL_ENERGY<CR>$#    hgen      rwen    slnten     rylen<CR>         2         2         1         1

iabbrev <buffer> lsdcontrolhg *CONTROL_HOURGLASS<CR>$#     ihq        qh<CR>         4      0.10

iabbrev <buffer> lsdcontrolshell *CONTROL_SHELL<CR>$#  wrpang     esort     irnxx    istupd    theory       bwc     miter      proj<CR>      20.0         0        -1         0         2         2         1         0

iabbrev <buffer> lsdcontrolsolid *CONTROL_SOLID<CR>$#   esort    fmatrix    niptets   swlocl      psfail<CR>         0         0         0         0         0

iabbrev <buffer> lsdcontrolacc *CONTROL_ACCURACY<CR>$#     osu       inn    pidosu      iacc      exacc<CR>         0         4         0         0         0

" Database cards
iabbrev <buffer> lsdd3plot *DATABASE_BINARY_D3PLOT<CR>$#      dt      lcdt      beam     npltc    psetid<CR>     0.001         0         0         0         0<CR>$#   ioopt      rate    cutoff    window      type      pset<CR>         0       0.0       0.0       0.0         0         0

iabbrev <buffer> lsddbglstat *DATABASE_GLSTAT<CR>$#      dt    binary      lcur     ioopt<CR>     0.001         1         0         1

iabbrev <buffer> lsddbnodout *DATABASE_NODOUT<CR>$#      dt    binary      lcur     ioopt   option1   option2<CR>     0.001         1         0         1         0         0

iabbrev <buffer> lsddbelout *DATABASE_ELOUT<CR>$#      dt    binary      lcur     ioopt   option1   option2<CR>     0.001         1         0         1         0         0

" Define cards
iabbrev <buffer> lsddefcurve *DEFINE_CURVE<CR>$#    lcid      sidr       sfa       sfo      offa      offo    dattyp     lcint<CR>         1         0       1.0       1.0       0.0       0.0         0         0<CR>$#                a1                  o1<CR>                 0.0                 0.0<CR>                 1.0                 1.0

iabbrev <buffer> lsddeftable *DEFINE_TABLE<CR>$#    tbid<CR>         1<CR>$#               value<CR>                 1.0

" Set definitions
iabbrev <buffer> lsdsetnodelist *SET_NODE_LIST<CR>$#     sid       da1       da2       da3       da4    solver<CR>         1       0.0       0.0       0.0       0.0MECH<CR>$#    nid1      nid2      nid3      nid4      nid5      nid6      nid7      nid8<CR>         1         2         3         4         0         0         0         0

iabbrev <buffer> lsdsetpartlist *SET_PART_LIST<CR>$#     sid       da1       da2       da3       da4    solver<CR>         1       0.0       0.0       0.0       0.0MECH<CR>$#    pid1      pid2      pid3      pid4      pid5      pid6      pid7      pid8<CR>         1         0         0         0         0         0         0         0

iabbrev <buffer> lsdsetsegment *SET_SEGMENT<CR>$#     sid       da1       da2       da3       da4<CR>         1       0.0       0.0       0.0       0.0<CR>$#      n1        n2        n3        n4        a1        a2        a3        a4<CR>         1         2         3         4       0.0       0.0       0.0       0.0

" Boundary conditions
iabbrev <buffer> lsdboundaryspc *BOUNDARY_SPC_SET<CR>$#    nsid       cid      dofx      dofy      dofz     dofrx     dofry     dofrz<CR>         1         0         1         1         1         0         0         0

iabbrev <buffer> lsdboundarypm *BOUNDARY_PRESCRIBED_MOTION_SET<CR>$#    nsid       dof       vad      lcid        sf       vid     death     birth<CR>         1         1         2         1       1.0         0 1.0000E28       0.0

" Load definitions
iabbrev <buffer> lsdloadnode *LOAD_NODE_SET<CR>$#    nsid       dof      lcid        sf       cid<CR>         1         3         1       1.0         0

iabbrev <buffer> lsdloadseg *LOAD_SEGMENT_SET<CR>$#     sid      lcid        sf        at        dt<CR>         1         1       1.0       0.0       0.0

" Initial conditions
iabbrev <buffer> lsdinitvel *INITIAL_VELOCITY<CR>$#     nid       vx        vy        vz       vxr       vyr       vzr<CR>         1       0.0       0.0       0.0       0.0       0.0       0.0

iabbrev <buffer> lsdinitvelgen *INITIAL_VELOCITY_GENERATION<CR>$#     sid     styp       vx        vy        vz      icid<CR>         1         0       0.0       0.0       0.0         0

" Include
iabbrev <buffer> lsdinclude *INCLUDE<CR>filename.k

" Parameter
iabbrev <buffer> lsdparameter *PARAMETER<CR>R param_name 1.0

iabbrev <buffer> lsdparameterexpr *PARAMETER_EXPRESSION<CR>$#                                                                       title<CR>Parameter Expression Title<CR>R expression "param1 + param2 * 2.0"

" End
iabbrev <buffer> lsdend *END

echo "LS-DYNA abbreviations loaded. Use 'lsd' prefix + keyword name (e.g., lsdnode, lsdelsolid)"