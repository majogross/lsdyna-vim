" Vim syntax file
" Language: LS-DYNA input file
" Maintainer: Auto-generated
" Latest Revision: 2025

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" LS-DYNA keywords are case-insensitive but typically written in uppercase
syn case ignore

" Comments - lines starting with dollar sign
syn match lsdynaComment "^\$.*$"

" Keywords - lines starting with asterisk
syn match lsdynaKeyword "^\*[A-Z_][A-Z0-9_]*"

" Specific important keywords
syn keyword lsdynaControl *KEYWORD *END contained
syn match lsdynaControl "^\*KEYWORD\>"
syn match lsdynaControl "^\*END\>"

" Node and element definitions
syn match lsdynaNode "^\*NODE\>"
syn match lsdynaElement "^\*ELEMENT_SOLID\>"
syn match lsdynaElement "^\*ELEMENT_SHELL\>"
syn match lsdynaElement "^\*ELEMENT_BEAM\>"
syn match lsdynaElement "^\*ELEMENT_DISCRETE\>"
syn match lsdynaElement "^\*ELEMENT_MASS\>"
syn match lsdynaElement "^\*ELEMENT_SPRING\>"
syn match lsdynaElement "^\*ELEMENT_DAMPER\>"
syn match lsdynaElement "^\*ELEMENT_SEATBELT\>"
syn match lsdynaElement "^\*ELEMENT_TSHELL\>"

" Part and section definitions
syn match lsdynaPart "^\*PART\>"
syn match lsdynaSection "^\*SECTION_SOLID\>"
syn match lsdynaSection "^\*SECTION_SHELL\>"
syn match lsdynaSection "^\*SECTION_BEAM\>"
syn match lsdynaSection "^\*SECTION_DISCRETE\>"
syn match lsdynaSection "^\*SECTION_SPRING\>"
syn match lsdynaSection "^\*SECTION_[A-Z_]*"

" Material definitions
syn match lsdynaMaterial "^\*MAT_ELASTIC\>"
syn match lsdynaMaterial "^\*MAT_PLASTIC_KINEMATIC\>"
syn match lsdynaMaterial "^\*MAT_PIECEWISE_LINEAR_PLASTICITY\>"
syn match lsdynaMaterial "^\*MAT_RIGID\>"
syn match lsdynaMaterial "^\*MAT_JOHNSON_COOK\>"
syn match lsdynaMaterial "^\*MAT_[A-Z_0-9]*"

" Contact definitions
syn match lsdynaContact "^\*CONTACT_AUTOMATIC_SINGLE_SURFACE\>"
syn match lsdynaContact "^\*CONTACT_AUTOMATIC_SURFACE_TO_SURFACE\>"
syn match lsdynaContact "^\*CONTACT_NODES_TO_SURFACE\>"
syn match lsdynaContact "^\*CONTACT_ERODING_[A-Z_]*"
syn match lsdynaContact "^\*CONTACT_[A-Z_]*"

" Control keywords
syn match lsdynaControl "^\*CONTROL_ACCURACY\>"
syn match lsdynaControl "^\*CONTROL_BULK_VISCOSITY\>"
syn match lsdynaControl "^\*CONTROL_CONTACT\>"
syn match lsdynaControl "^\*CONTROL_ENERGY\>"
syn match lsdynaControl "^\*CONTROL_HOURGLASS\>"
syn match lsdynaControl "^\*CONTROL_OUTPUT\>"
syn match lsdynaControl "^\*CONTROL_SHELL\>"
syn match lsdynaControl "^\*CONTROL_SOLID\>"
syn match lsdynaControl "^\*CONTROL_TERMINATION\>"
syn match lsdynaControl "^\*CONTROL_TIMESTEP\>"
syn match lsdynaControl "^\*CONTROL_[A-Z_]*"

" Database output keywords
syn match lsdynaDatabase "^\*DATABASE_BINARY_D3PLOT\>"
syn match lsdynaDatabase "^\*DATABASE_BINARY_D3THDT\>"
syn match lsdynaDatabase "^\*DATABASE_NODOUT\>"
syn match lsdynaDatabase "^\*DATABASE_ELOUT\>"
syn match lsdynaDatabase "^\*DATABASE_GLSTAT\>"
syn match lsdynaDatabase "^\*DATABASE_MATSUM\>"
syn match lsdynaDatabase "^\*DATABASE_RCFORC\>"
syn match lsdynaDatabase "^\*DATABASE_[A-Z_0-9]*"

" Define keywords
syn match lsdynaDefine "^\*DEFINE_CURVE\>"
syn match lsdynaDefine "^\*DEFINE_CURVE_TRIM\>"
syn match lsdynaDefine "^\*DEFINE_TABLE\>"
syn match lsdynaDefine "^\*DEFINE_FUNCTION\>"
syn match lsdynaDefine "^\*DEFINE_TRANSFORMATION\>"
syn match lsdynaDefine "^\*DEFINE_[A-Z_]*"

" Set keywords
syn match lsdynaSet "^\*SET_NODE_LIST\>"
syn match lsdynaSet "^\*SET_NODE_COLUMN\>"
syn match lsdynaSet "^\*SET_ELEMENT_SOLID\>"
syn match lsdynaSet "^\*SET_ELEMENT_SHELL\>"
syn match lsdynaSet "^\*SET_PART_LIST\>"
syn match lsdynaSet "^\*SET_SEGMENT\>"
syn match lsdynaSet "^\*SET_[A-Z_]*"

" Boundary conditions
syn match lsdynaBoundary "^\*BOUNDARY_SPC_SET\>"
syn match lsdynaBoundary "^\*BOUNDARY_SPC_NODE\>"
syn match lsdynaBoundary "^\*BOUNDARY_PRESCRIBED_MOTION_SET\>"
syn match lsdynaBoundary "^\*BOUNDARY_PRESCRIBED_MOTION_NODE\>"
syn match lsdynaBoundary "^\*BOUNDARY_[A-Z_]*"

" Load keywords
syn match lsdynaLoad "^\*LOAD_NODE_SET\>"
syn match lsdynaLoad "^\*LOAD_NODE_POINT\>"
syn match lsdynaLoad "^\*LOAD_SEGMENT_SET\>"
syn match lsdynaLoad "^\*LOAD_BODY_[A-Z_]*"
syn match lsdynaLoad "^\*LOAD_[A-Z_]*"

" Initial conditions
syn match lsdynaInitial "^\*INITIAL_VELOCITY\>"
syn match lsdynaInitial "^\*INITIAL_VELOCITY_GENERATION\>"
syn match lsdynaInitial "^\*INITIAL_STRESS\>"
syn match lsdynaInitial "^\*INITIAL_TEMPERATURE\>"
syn match lsdynaInitial "^\*INITIAL_[A-Z_]*"

" Include files
syn match lsdynaInclude "^\*INCLUDE\>"
syn match lsdynaInclude "^\*INCLUDE_PATH\>"
syn match lsdynaInclude "^\*INCLUDE_TRANSFORM\>"

" Parameter definitions
syn match lsdynaParameter "^\*PARAMETER\>"
syn match lsdynaParameter "^\*PARAMETER_EXPRESSION\>"

" Constrained keywords
syn match lsdynaConstrained "^\*CONSTRAINED_NODAL_RIGID_BODY\>"
syn match lsdynaConstrained "^\*CONSTRAINED_RIGID_BODIES\>"
syn match lsdynaConstrained "^\*CONSTRAINED_JOINT_[A-Z_]*"
syn match lsdynaConstrained "^\*CONSTRAINED_[A-Z_]*"

" Numbers - integers, floats, scientific notation
syn match lsdynaNumber "\<\d\+\>"
syn match lsdynaNumber "\<\d\+\.\d*\>"
syn match lsdynaNumber "\.\d\+\>"
syn match lsdynaNumber "\<\d\+[eE][+-]\?\d\+\>"
syn match lsdynaNumber "\<\d\+\.\d*[eE][+-]\?\d\+\>"
syn match lsdynaNumber "\.\d\+[eE][+-]\?\d\+\>"
syn match lsdynaNumber "[+-]\d\+\>"
syn match lsdynaNumber "[+-]\d\+\.\d*\>"
syn match lsdynaNumber "[+-]\.\d\+\>"
syn match lsdynaNumber "[+-]\d\+[eE][+-]\?\d\+\>"
syn match lsdynaNumber "[+-]\d\+\.\d*[eE][+-]\?\d\+\>"
syn match lsdynaNumber "[+-]\.\d\+[eE][+-]\?\d\+\>"

" Define highlight groups
hi def link lsdynaComment Comment
hi def link lsdynaKeyword Keyword
hi def link lsdynaControl PreProc
hi def link lsdynaNode Type
hi def link lsdynaElement Structure
hi def link lsdynaPart Identifier
hi def link lsdynaSection Define
hi def link lsdynaMaterial Constant
hi def link lsdynaContact Special
hi def link lsdynaDatabase StorageClass
hi def link lsdynaDefine Macro
hi def link lsdynaSet Label
hi def link lsdynaBoundary Conditional
hi def link lsdynaLoad Statement
hi def link lsdynaInitial PreCondit
hi def link lsdynaInclude Include
hi def link lsdynaParameter Typedef
hi def link lsdynaConstrained Operator
hi def link lsdynaNumber Number

let b:current_syntax = "lsdyna"