
!========================================================================
!
!                   S P E C F E M 2 D  Version 5.1
!                   ------------------------------
!
!                         Dimitri Komatitsch
!          Universite de Pau et des Pays de l'Adour, France
!
!                          (c) January 2005
!
!========================================================================

  subroutine plotpost(displ,coord,vpext,x_source,z_source,st_xval,st_zval,it,dt,coorg, &
          xinterp,zinterp,shapeint,Uxinterp,Uzinterp,flagrange,density,elastcoef,knods,kmato,ibool, &
          numabs,codeabs,anyabs,stitle,npoin,npgeo,vpmin,vpmax,nrec, &
          colors,numbers,subsamp,vecttype,interpol,meshvect,modelvect, &
          boundvect,read_external_model,cutvect,sizemax_arrows,nelemabs,numat,pointsdisp,nspec,ngnod,ELASTIC, &
          plot_lowerleft_corner_only)

!
! routine affichage postscript
!

  implicit none

  include "constants.h"

! color palette
  integer, parameter :: NUM_COLORS = 236
  double precision, dimension(NUM_COLORS) :: red,green,blue

  integer it,nrec,nelemabs,numat,pointsdisp,pointsdisp_loop,nspec
  integer i,npoin,npgeo,ngnod

  integer kmato(nspec),knods(ngnod,nspec)
  integer ibool(NGLLX,NGLLZ,nspec)

  double precision xinterp(pointsdisp,pointsdisp),zinterp(pointsdisp,pointsdisp)
  double precision shapeint(ngnod,pointsdisp,pointsdisp)
  double precision Uxinterp(pointsdisp,pointsdisp)
  double precision Uzinterp(pointsdisp,pointsdisp)
  double precision flagrange(NGLLX,pointsdisp)
  double precision density(numat),elastcoef(4,numat)

  double precision dt,timeval,x_source,z_source
  double precision displ(NDIM,npoin),coord(NDIM,npoin)
  double precision vpext(npoin)

  double precision coorg(NDIM,npgeo)
  double precision, dimension(nrec) :: st_xval,st_zval

  integer numabs(nelemabs),codeabs(4,nelemabs)
  logical anyabs,ELASTIC,plot_lowerleft_corner_only

  double precision xmax,zmax,height,xw,zw,usoffset,sizex,sizez,vpmin,vpmax

  character(len=100) name
  character ch1(100),ch2(100)
  equivalence (name,ch1)
  logical first

  double precision convert,x1,rlamda,rmu,denst,rKvol,cploc,xa,za,xb,zb
  double precision z1,x2,z2,d,d1,d2,dummy,theta,thetaup,thetadown

  integer k,j,ispec,material,is,ir,imat,icol,l,longueur
  integer indice,ii,ipoin,in,nnum,ispecabs,ideb,ifin,ibord

  integer colors,numbers,subsamp,vecttype
  logical interpol,meshvect,modelvect,boundvect,read_external_model
  double precision cutvect,sizemax_arrows

  double precision rapp_page,dispmax,xmin,zmin

! title of the plot
  character(len=60) stitle

! papier A4 ou US letter
  if(US_LETTER) then
    usoffset = 1.75d0
    sizex = 27.94d0
    sizez = 21.59d0
  else
    usoffset = 0.d0
    sizex = 29.7d0
    sizez = 21.d0
  endif

! define color palette in random order

! red
  red(1) = 1.00000000000000
  green(1) = 0.000000000000000E+000
  blue(1) = 0.000000000000000E+000

! DodgerBlue2
  red(2) = 0.109803921568627
  green(2) = 0.525490196078431
  blue(2) = 0.933333333333333

! Bisque3
  red(3) = 0.803921568627451
  green(3) = 0.717647058823529
  blue(3) = 0.619607843137255

! springgreen
  red(4) = 0.000000000000000E+000
  green(4) = 1.00000000000000
  blue(4) = 0.500000000000000

! NavajoWhite
  red(5) = 1.00000000000000
  green(5) = 0.870588235294118
  blue(5) = 0.678431372549020

! SteelBlue3
  red(6) = 0.309803921568627
  green(6) = 0.580392156862745
  blue(6) = 0.803921568627451

! Ivory3
  red(7) = 0.803921568627451
  green(7) = 0.803921568627451
  blue(7) = 0.756862745098039

! SkyBlue4
  red(8) = 0.290196078431373
  green(8) = 0.439215686274510
  blue(8) = 0.545098039215686

! Snow
  red(9) = 0.980392156862745
  green(9) = 0.980392156862745
  blue(9) = 0.980392156862745

! SteelBlue
  red(10) = 0.274509803921569
  green(10) = 0.509803921568627
  blue(10) = 0.705882352941177

! gold
  red(11) = 1.00000000000000
  green(11) = 0.840000000000000
  blue(11) = 0.000000000000000E+000

! Salmon
  red(12) = 0.980392156862745
  green(12) = 0.501960784313725
  blue(12) = 0.447058823529412

! SlateBlue2
  red(13) = 0.478431372549020
  green(13) = 0.403921568627451
  blue(13) = 0.933333333333333

! NavajoWhite2
  red(14) = 0.933333333333333
  green(14) = 0.811764705882353
  blue(14) = 0.631372549019608

! MediumBlue
  red(15) = 0.000000000000000E+000
  green(15) = 0.000000000000000E+000
  blue(15) = 0.803921568627451

! LightCoral
  red(16) = 0.941176470588235
  green(16) = 0.501960784313725
  blue(16) = 0.501960784313725

! FloralWhite
  red(17) = 1.00000000000000
  green(17) = 0.980392156862745
  blue(17) = 0.941176470588235

! Cornsilk3
  red(18) = 0.803921568627451
  green(18) = 0.784313725490196
  blue(18) = 0.694117647058824

! GhostWhite
  red(19) = 0.972549019607843
  green(19) = 0.972549019607843
  blue(19) = 1.00000000000000

! blue
  red(20) = 0.000000000000000E+000
  green(20) = 0.000000000000000E+000
  blue(20) = 1.00000000000000

! Linen
  red(21) = 0.980392156862745
  green(21) = 0.941176470588235
  blue(21) = 0.901960784313726

! peachpuff
  red(22) = 1.00000000000000
  green(22) = 0.850000000000000
  blue(22) = 0.730000000000000

! Cornsilk1
  red(23) = 1.00000000000000
  green(23) = 0.972549019607843
  blue(23) = 0.862745098039216

! LightSalmon
  red(24) = 1.00000000000000
  green(24) = 0.627450980392157
  blue(24) = 0.478431372549020

! DeepSkyBlue1
  red(25) = 0.000000000000000E+000
  green(25) = 0.749019607843137
  blue(25) = 1.00000000000000

! LemonChiffon4
  red(26) = 0.545098039215686
  green(26) = 0.537254901960784
  blue(26) = 0.439215686274510

! PeachPuff1
  red(27) = 1.00000000000000
  green(27) = 0.854901960784314
  blue(27) = 0.725490196078431

! BlanchedAlmond
  red(28) = 1.00000000000000
  green(28) = 0.921568627450980
  blue(28) = 0.803921568627451

! SlateBlue3
  red(29) = 0.411764705882353
  green(29) = 0.349019607843137
  blue(29) = 0.803921568627451

! LightSkyBlue1
  red(30) = 0.690196078431373
  green(30) = 0.886274509803922
  blue(30) = 1.00000000000000

! DarkViolet
  red(31) = 0.580392156862745
  green(31) = 0.000000000000000E+000
  blue(31) = 0.827450980392157

! Azure3
  red(32) = 0.756862745098039
  green(32) = 0.803921568627451
  blue(32) = 0.803921568627451

! LavenderBlush3
  red(33) = 0.803921568627451
  green(33) = 0.756862745098039
  blue(33) = 0.772549019607843

! Honeydew1
  red(34) = 0.941176470588235
  green(34) = 1.00000000000000
  blue(34) = 0.941176470588235

! Ivory2
  red(35) = 0.933333333333333
  green(35) = 0.933333333333333
  blue(35) = 0.878431372549020

! RosyBrown
  red(36) = 0.737254901960784
  green(36) = 0.560784313725490
  blue(36) = 0.560784313725490

! Thistle
  red(37) = 0.847058823529412
  green(37) = 0.749019607843137
  blue(37) = 0.847058823529412

! Orange
  red(38) = 1.00000000000000
  green(38) = 0.647058823529412
  blue(38) = 0.000000000000000E+000

! DarkSeaGreen
  red(39) = 0.560784313725490
  green(39) = 0.737254901960784
  blue(39) = 0.560784313725490

! Moccasin
  red(40) = 1.00000000000000
  green(40) = 0.894117647058824
  blue(40) = 0.709803921568627

! DeepSkyBlue2
  red(41) = 0.000000000000000E+000
  green(41) = 0.698039215686274
  blue(41) = 0.933333333333333

! SlateGray4
  red(42) = 0.423529411764706
  green(42) = 0.482352941176471
  blue(42) = 0.545098039215686

! Beige
  red(43) = 0.960784313725490
  green(43) = 0.960784313725490
  blue(43) = 0.862745098039216

! Gold
  red(44) = 1.00000000000000
  green(44) = 0.843137254901961
  blue(44) = 0.000000000000000E+000

! SlateBlue
  red(45) = 0.415686274509804
  green(45) = 0.352941176470588
  blue(45) = 0.803921568627451

! SteelBlue1
  red(46) = 0.388235294117647
  green(46) = 0.721568627450980
  blue(46) = 1.00000000000000

! SaddleBrown
  red(47) = 0.545098039215686
  green(47) = 0.270588235294118
  blue(47) = 7.450980392156863E-002

! Pink
  red(48) = 1.00000000000000
  green(48) = 0.752941176470588
  blue(48) = 0.796078431372549

! Black
  red(49) = 0.000000000000000E+000
  green(49) = 0.000000000000000E+000
  blue(49) = 0.000000000000000E+000

! SlateGrey
  red(50) = 0.439215686274510
  green(50) = 0.501960784313725
  blue(50) = 0.564705882352941

! Ivory
  red(51) = 1.00000000000000
  green(51) = 1.00000000000000
  blue(51) = 0.941176470588235

! OliveDrab
  red(52) = 0.419607843137255
  green(52) = 0.556862745098039
  blue(52) = 0.137254901960784

! Ivory1
  red(53) = 1.00000000000000
  green(53) = 1.00000000000000
  blue(53) = 0.941176470588235

! SkyBlue
  red(54) = 0.529411764705882
  green(54) = 0.807843137254902
  blue(54) = 0.921568627450980

! MistyRose3
  red(55) = 0.803921568627451
  green(55) = 0.717647058823529
  blue(55) = 0.709803921568627

! LimeGreen
  red(56) = 0.196078431372549
  green(56) = 0.803921568627451
  blue(56) = 0.196078431372549

! Purple
  red(57) = 0.627450980392157
  green(57) = 0.125490196078431
  blue(57) = 0.941176470588235

! SkyBlue2
  red(58) = 0.494117647058824
  green(58) = 0.752941176470588
  blue(58) = 0.933333333333333

! Red
  red(59) = 1.00000000000000
  green(59) = 0.000000000000000E+000
  blue(59) = 0.000000000000000E+000

! DarkKhaki
  red(60) = 0.741176470588235
  green(60) = 0.717647058823529
  blue(60) = 0.419607843137255

! MediumTurquoise
  red(61) = 0.282352941176471
  green(61) = 0.819607843137255
  blue(61) = 0.800000000000000

! Grey
  red(62) = 0.745098039215686
  green(62) = 0.745098039215686
  blue(62) = 0.745098039215686

! Coral
  red(63) = 1.00000000000000
  green(63) = 0.498039215686275
  blue(63) = 0.313725490196078

! NavajoWhite4
  red(64) = 0.545098039215686
  green(64) = 0.474509803921569
  blue(64) = 0.368627450980392

! SlateBlue4
  red(65) = 0.278431372549020
  green(65) = 0.235294117647059
  blue(65) = 0.545098039215686

! RoyalBlue4
  red(66) = 0.152941176470588
  green(66) = 0.250980392156863
  blue(66) = 0.545098039215686

! YellowGreen
  red(67) = 0.603921568627451
  green(67) = 0.803921568627451
  blue(67) = 0.196078431372549

! DeepSkyBlue3
  red(68) = 0.000000000000000E+000
  green(68) = 0.603921568627451
  blue(68) = 0.803921568627451

! goldenrod
  red(69) = 0.854901960784314
  green(69) = 0.647058823529412
  blue(69) = 0.125490196078431

! AntiqueWhite4
  red(70) = 0.545098039215686
  green(70) = 0.513725490196078
  blue(70) = 0.470588235294118

! lemonchiffon
  red(71) = 1.00000000000000
  green(71) = 0.980000000000000
  blue(71) = 0.800000000000000

! GreenYellow
  red(72) = 0.678431372549020
  green(72) = 1.00000000000000
  blue(72) = 0.184313725490196

! LightSlateGray
  red(73) = 0.466666666666667
  green(73) = 0.533333333333333
  blue(73) = 0.600000000000000

! RoyalBlue
  red(74) = 0.254901960784314
  green(74) = 0.411764705882353
  blue(74) = 0.882352941176471

! DarkGreen
  red(75) = 0.000000000000000E+000
  green(75) = 0.392156862745098
  blue(75) = 0.000000000000000E+000

! NavajoWhite3
  red(76) = 0.803921568627451
  green(76) = 0.701960784313725
  blue(76) = 0.545098039215686

! Azure1
  red(77) = 0.941176470588235
  green(77) = 1.00000000000000
  blue(77) = 1.00000000000000

! PowderBlue
  red(78) = 0.690196078431373
  green(78) = 0.878431372549020
  blue(78) = 0.901960784313726

! slateblue
  red(79) = 0.420000000000000
  green(79) = 0.350000000000000
  blue(79) = 0.800000000000000

! MediumOrchid
  red(80) = 0.729411764705882
  green(80) = 0.333333333333333
  blue(80) = 0.827450980392157

! turquoise
  red(81) = 0.250000000000000
  green(81) = 0.880000000000000
  blue(81) = 0.820000000000000

! Snow1
  red(82) = 1.00000000000000
  green(82) = 0.980392156862745
  blue(82) = 0.980392156862745

! violet
  red(83) = 0.930000000000000
  green(83) = 0.510000000000000
  blue(83) = 0.930000000000000

! DeepPink
  red(84) = 1.00000000000000
  green(84) = 7.843137254901961E-002
  blue(84) = 0.576470588235294

! MistyRose4
  red(85) = 0.545098039215686
  green(85) = 0.490196078431373
  blue(85) = 0.482352941176471

! PeachPuff3
  red(86) = 0.803921568627451
  green(86) = 0.686274509803922
  blue(86) = 0.584313725490196

! MediumSeaGreen
  red(87) = 0.235294117647059
  green(87) = 0.701960784313725
  blue(87) = 0.443137254901961

! Honeydew4
  red(88) = 0.513725490196078
  green(88) = 0.545098039215686
  blue(88) = 0.513725490196078

! Tan
  red(89) = 0.823529411764706
  green(89) = 0.705882352941177
  blue(89) = 0.549019607843137

! DarkGoldenrod
  red(90) = 0.721568627450980
  green(90) = 0.525490196078431
  blue(90) = 4.313725490196078E-002

! Blue2
  red(91) = 0.000000000000000E+000
  green(91) = 0.000000000000000E+000
  blue(91) = 0.933333333333333

! Maroon
  red(92) = 0.690196078431373
  green(92) = 0.188235294117647
  blue(92) = 0.376470588235294

! LightSkyBlue3
  red(93) = 0.552941176470588
  green(93) = 0.713725490196078
  blue(93) = 0.803921568627451

! LemonChiffon2
  red(94) = 0.933333333333333
  green(94) = 0.913725490196078
  blue(94) = 0.749019607843137

! Snow3
  red(95) = 0.803921568627451
  green(95) = 0.788235294117647
  blue(95) = 0.788235294117647

! Ivory4
  red(96) = 0.545098039215686
  green(96) = 0.545098039215686
  blue(96) = 0.513725490196078

! AntiqueWhite3
  red(97) = 0.803921568627451
  green(97) = 0.752941176470588
  blue(97) = 0.690196078431373

! Bisque4
  red(98) = 0.545098039215686
  green(98) = 0.490196078431373
  blue(98) = 0.419607843137255

! Snow2
  red(99) = 0.933333333333333
  green(99) = 0.913725490196078
  blue(99) = 0.913725490196078

! SlateGray1
  red(100) = 0.776470588235294
  green(100) = 0.886274509803922
  blue(100) = 1.00000000000000

! Seashell2
  red(101) = 0.933333333333333
  green(101) = 0.898039215686275
  blue(101) = 0.870588235294118

! Aquamarine
  red(102) = 0.498039215686275
  green(102) = 1.00000000000000
  blue(102) = 0.831372549019608

! SlateGray2
  red(103) = 0.725490196078431
  green(103) = 0.827450980392157
  blue(103) = 0.933333333333333

! White
  red(104) = 1.00000000000000
  green(104) = 1.00000000000000
  blue(104) = 1.00000000000000

! LavenderBlush
  red(105) = 1.00000000000000
  green(105) = 0.941176470588235
  blue(105) = 0.960784313725490

! DodgerBlue3
  red(106) = 9.411764705882353E-002
  green(106) = 0.454901960784314
  blue(106) = 0.803921568627451

! RoyalBlue3
  red(107) = 0.227450980392157
  green(107) = 0.372549019607843
  blue(107) = 0.803921568627451

! LightYellow
  red(108) = 1.00000000000000
  green(108) = 1.00000000000000
  blue(108) = 0.878431372549020

! DeepSkyBlue
  red(109) = 0.000000000000000E+000
  green(109) = 0.749019607843137
  blue(109) = 1.00000000000000

! AntiqueWhite2
  red(110) = 0.933333333333333
  green(110) = 0.874509803921569
  blue(110) = 0.800000000000000

! CornflowerBlue
  red(111) = 0.392156862745098
  green(111) = 0.584313725490196
  blue(111) = 0.929411764705882

! PeachPuff4
  red(112) = 0.545098039215686
  green(112) = 0.466666666666667
  blue(112) = 0.396078431372549

! SpringGreen
  red(113) = 0.000000000000000E+000
  green(113) = 1.00000000000000
  blue(113) = 0.498039215686275

! Honeydew
  red(114) = 0.941176470588235
  green(114) = 1.00000000000000
  blue(114) = 0.941176470588235

! Honeydew2
  red(115) = 0.878431372549020
  green(115) = 0.933333333333333
  blue(115) = 0.878431372549020

! LightSeaGreen
  red(116) = 0.125490196078431
  green(116) = 0.698039215686274
  blue(116) = 0.666666666666667

! NavyBlue
  red(117) = 0.000000000000000E+000
  green(117) = 0.000000000000000E+000
  blue(117) = 0.501960784313725

! Azure4
  red(118) = 0.513725490196078
  green(118) = 0.545098039215686
  blue(118) = 0.545098039215686

! MediumAquamarine
  red(119) = 0.400000000000000
  green(119) = 0.803921568627451
  blue(119) = 0.666666666666667

! SkyBlue3
  red(120) = 0.423529411764706
  green(120) = 0.650980392156863
  blue(120) = 0.803921568627451

! LavenderBlush2
  red(121) = 0.933333333333333
  green(121) = 0.878431372549020
  blue(121) = 0.898039215686275

! Bisque1
  red(122) = 1.00000000000000
  green(122) = 0.894117647058824
  blue(122) = 0.768627450980392

! DarkOrange
  red(123) = 1.00000000000000
  green(123) = 0.549019607843137
  blue(123) = 0.000000000000000E+000

! LightSteelBlue
  red(124) = 0.690196078431373
  green(124) = 0.768627450980392
  blue(124) = 0.870588235294118

! SteelBlue2
  red(125) = 0.360784313725490
  green(125) = 0.674509803921569
  blue(125) = 0.933333333333333

! LemonChiffon3
  red(126) = 0.803921568627451
  green(126) = 0.788235294117647
  blue(126) = 0.647058823529412

! DarkSlateBlue
  red(127) = 0.282352941176471
  green(127) = 0.239215686274510
  blue(127) = 0.545098039215686

! Seashell
  red(128) = 1.00000000000000
  green(128) = 0.960784313725490
  blue(128) = 0.933333333333333

! Firebrick
  red(129) = 0.698039215686274
  green(129) = 0.133333333333333
  blue(129) = 0.133333333333333

! LightGray
  red(130) = 0.827450980392157
  green(130) = 0.827450980392157
  blue(130) = 0.827450980392157

! Blue
  red(131) = 0.000000000000000E+000
  green(131) = 0.000000000000000E+000
  blue(131) = 1.00000000000000

! Bisque2
  red(132) = 0.933333333333333
  green(132) = 0.835294117647059
  blue(132) = 0.717647058823529

! WhiteSmoke
  red(133) = 0.960784313725490
  green(133) = 0.960784313725490
  blue(133) = 0.960784313725490

! SeaGreen
  red(134) = 0.180392156862745
  green(134) = 0.545098039215686
  blue(134) = 0.341176470588235

! Burlywood
  red(135) = 0.870588235294118
  green(135) = 0.721568627450980
  blue(135) = 0.529411764705882

! RoyalBlue2
  red(136) = 0.262745098039216
  green(136) = 0.431372549019608
  blue(136) = 0.933333333333333

! RoyalBlue1
  red(137) = 0.282352941176471
  green(137) = 0.462745098039216
  blue(137) = 1.00000000000000

! SteelBlue4
  red(138) = 0.211764705882353
  green(138) = 0.392156862745098
  blue(138) = 0.545098039215686

! AliceBlue
  red(139) = 0.941176470588235
  green(139) = 0.972549019607843
  blue(139) = 1.00000000000000

! LightSlateBlue
  red(140) = 0.517647058823529
  green(140) = 0.439215686274510
  blue(140) = 1.00000000000000

! MistyRose1
  red(141) = 1.00000000000000
  green(141) = 0.894117647058824
  blue(141) = 0.882352941176471

! SandyBrown
  red(142) = 0.956862745098039
  green(142) = 0.643137254901961
  blue(142) = 0.376470588235294

! DarkOliveGreen
  red(143) = 0.333333333333333
  green(143) = 0.419607843137255
  blue(143) = 0.184313725490196

! Yellow
  red(144) = 1.00000000000000
  green(144) = 1.00000000000000
  blue(144) = 0.000000000000000E+000

! SlateGray3
  red(145) = 0.623529411764706
  green(145) = 0.713725490196078
  blue(145) = 0.803921568627451

! HotPink
  red(146) = 1.00000000000000
  green(146) = 0.411764705882353
  blue(146) = 0.705882352941177

! Violet
  red(147) = 0.933333333333333
  green(147) = 0.509803921568627
  blue(147) = 0.933333333333333

! LightSkyBlue
  red(148) = 0.529411764705882
  green(148) = 0.807843137254902
  blue(148) = 0.980392156862745

! Cornsilk2
  red(149) = 0.933333333333333
  green(149) = 0.909803921568627
  blue(149) = 0.803921568627451

! MidnightBlue
  red(150) = 9.803921568627451E-002
  green(150) = 9.803921568627451E-002
  blue(150) = 0.439215686274510

! AntiqueWhite
  red(151) = 0.980392156862745
  green(151) = 0.921568627450980
  blue(151) = 0.843137254901961

! PaleGreen
  red(152) = 0.596078431372549
  green(152) = 0.984313725490196
  blue(152) = 0.596078431372549

! MedSpringGreen
  red(153) = 0.000000000000000E+000
  green(153) = 0.980392156862745
  blue(153) = 0.603921568627451

! DodgerBlue1
  red(154) = 0.117647058823529
  green(154) = 0.564705882352941
  blue(154) = 1.00000000000000

! Blue3
  red(155) = 0.000000000000000E+000
  green(155) = 0.000000000000000E+000
  blue(155) = 0.803921568627451

! Cyan
  red(156) = 0.000000000000000E+000
  green(156) = 1.00000000000000
  blue(156) = 1.00000000000000

! LemonChiffon
  red(157) = 1.00000000000000
  green(157) = 0.980392156862745
  blue(157) = 0.803921568627451

! mediumorchid
  red(158) = 0.730000000000000
  green(158) = 0.330000000000000
  blue(158) = 0.830000000000000

! Turquoise
  red(159) = 0.250980392156863
  green(159) = 0.878431372549020
  blue(159) = 0.815686274509804

! IndianRed
  red(160) = 0.803921568627451
  green(160) = 0.360784313725490
  blue(160) = 0.360784313725490

! DodgerBlue
  red(161) = 0.117647058823529
  green(161) = 0.564705882352941
  blue(161) = 1.00000000000000

! Seashell3
  red(162) = 0.803921568627451
  green(162) = 0.772549019607843
  blue(162) = 0.749019607843137

! BlueViolet
  red(163) = 0.541176470588235
  green(163) = 0.168627450980392
  blue(163) = 0.886274509803922

! DeepSkyBlue4
  red(164) = 0.000000000000000E+000
  green(164) = 0.407843137254902
  blue(164) = 0.545098039215686

! PaleVioletRed
  red(165) = 0.858823529411765
  green(165) = 0.439215686274510
  blue(165) = 0.576470588235294

! Azure2
  red(166) = 0.878431372549020
  green(166) = 0.933333333333333
  blue(166) = 0.933333333333333

! greenyellow
  red(167) = 0.680000000000000
  green(167) = 1.00000000000000
  blue(167) = 0.180000000000000

! LightGoldenrod
  red(168) = 0.933333333333333
  green(168) = 0.866666666666667
  blue(168) = 0.509803921568627

! MistyRose
  red(169) = 1.00000000000000
  green(169) = 0.894117647058824
  blue(169) = 0.882352941176471

! LightSkyBlue4
  red(170) = 0.376470588235294
  green(170) = 0.482352941176471
  blue(170) = 0.545098039215686

! OrangeRed
  red(171) = 1.00000000000000
  green(171) = 0.270588235294118
  blue(171) = 0.000000000000000E+000

! DimGrey
  red(172) = 0.411764705882353
  green(172) = 0.411764705882353
  blue(172) = 0.411764705882353

! MediumVioletRed
  red(173) = 0.780392156862745
  green(173) = 8.235294117647059E-002
  blue(173) = 0.521568627450980

! DarkSlateGray
  red(174) = 0.184313725490196
  green(174) = 0.309803921568627
  blue(174) = 0.309803921568627

! yellow
  red(175) = 1.00000000000000
  green(175) = 1.00000000000000
  blue(175) = 0.000000000000000E+000

! Plum
  red(176) = 0.866666666666667
  green(176) = 0.627450980392157
  blue(176) = 0.866666666666667

! DarkTurquoise
  red(177) = 0.000000000000000E+000
  green(177) = 0.807843137254902
  blue(177) = 0.819607843137255

! DodgerBlue4
  red(178) = 6.274509803921569E-002
  green(178) = 0.305882352941176
  blue(178) = 0.545098039215686

! Cornsilk
  red(179) = 1.00000000000000
  green(179) = 0.972549019607843
  blue(179) = 0.862745098039216

! SkyBlue1
  red(180) = 0.529411764705882
  green(180) = 0.807843137254902
  blue(180) = 1.00000000000000

! Seashell1
  red(181) = 1.00000000000000
  green(181) = 0.960784313725490
  blue(181) = 0.933333333333333

! lavender
  red(182) = 0.901960784313726
  green(182) = 0.901960784313726
  blue(182) = 0.980392156862745

! Snow4
  red(183) = 0.545098039215686
  green(183) = 0.537254901960784
  blue(183) = 0.537254901960784

! Peru
  red(184) = 0.803921568627451
  green(184) = 0.521568627450980
  blue(184) = 0.247058823529412

! PeachPuff
  red(185) = 1.00000000000000
  green(185) = 0.854901960784314
  blue(185) = 0.725490196078431

! Green
  red(186) = 0.000000000000000E+000
  green(186) = 1.00000000000000
  blue(186) = 0.000000000000000E+000

! Blue1
  red(187) = 0.000000000000000E+000
  green(187) = 0.000000000000000E+000
  blue(187) = 1.00000000000000

! Seashell4
  red(188) = 0.545098039215686
  green(188) = 0.525490196078431
  blue(188) = 0.509803921568627

! dodgerblue
  red(189) = 0.120000000000000
  green(189) = 0.560000000000000
  blue(189) = 1.00000000000000

! MistyRose2
  red(190) = 0.933333333333333
  green(190) = 0.835294117647059
  blue(190) = 0.823529411764706

! Tomato
  red(191) = 1.00000000000000
  green(191) = 0.388235294117647
  blue(191) = 0.278431372549020

! Wheat
  red(192) = 0.960784313725490
  green(192) = 0.870588235294118
  blue(192) = 0.701960784313725

! LightBlue
  red(193) = 0.678431372549020
  green(193) = 0.847058823529412
  blue(193) = 0.901960784313726

! Chocolate
  red(194) = 0.823529411764706
  green(194) = 0.411764705882353
  blue(194) = 0.117647058823529

! Blue4
  red(195) = 0.000000000000000E+000
  green(195) = 0.000000000000000E+000
  blue(195) = 0.545098039215686

! LavenderBlush1
  red(196) = 1.00000000000000
  green(196) = 0.941176470588235
  blue(196) = 0.960784313725490

! Magenta
  red(197) = 1.00000000000000
  green(197) = 0.000000000000000E+000
  blue(197) = 1.00000000000000

! darkturquoise
  red(198) = 0.000000000000000E+000
  green(198) = 0.810000000000000
  blue(198) = 0.820000000000000

! blueviolet
  red(199) = 0.540000000000000
  green(199) = 0.170000000000000
  blue(199) = 0.890000000000000

! MintCream
  red(200) = 0.960784313725490
  green(200) = 1.00000000000000
  blue(200) = 0.980392156862745

! PaleGoldenrod
  red(201) = 0.933333333333333
  green(201) = 0.909803921568627
  blue(201) = 0.666666666666667

! MediumPurple
  red(202) = 0.576470588235294
  green(202) = 0.439215686274510
  blue(202) = 0.858823529411765

! PapayaWhip
  red(203) = 1.00000000000000
  green(203) = 0.937254901960784
  blue(203) = 0.835294117647059

! LavenderBlush4
  red(204) = 0.545098039215686
  green(204) = 0.513725490196078
  blue(204) = 0.525490196078431

! Cornsilk4
  red(205) = 0.545098039215686
  green(205) = 0.533333333333333
  blue(205) = 0.470588235294118

! LtGoldenrodYello
  red(206) = 0.980392156862745
  green(206) = 0.980392156862745
  blue(206) = 0.823529411764706

! limegreen
  red(207) = 0.200000000000000
  green(207) = 0.800000000000000
  blue(207) = 0.200000000000000

! LemonChiffon1
  red(208) = 1.00000000000000
  green(208) = 0.980392156862745
  blue(208) = 0.803921568627451

! DarkOrchid
  red(209) = 0.600000000000000
  green(209) = 0.196078431372549
  blue(209) = 0.800000000000000

! SlateBlue1
  red(210) = 0.513725490196078
  green(210) = 0.435294117647059
  blue(210) = 1.00000000000000

! chartreuse
  red(211) = 0.500000000000000
  green(211) = 1.00000000000000
  blue(211) = 0.000000000000000E+000

! PaleTurquoise
  red(212) = 0.686274509803922
  green(212) = 0.933333333333333
  blue(212) = 0.933333333333333

! NavajoWhite1
  red(213) = 1.00000000000000
  green(213) = 0.870588235294118
  blue(213) = 0.678431372549020

! LightSkyBlue2
  red(214) = 0.643137254901961
  green(214) = 0.827450980392157
  blue(214) = 0.933333333333333

! VioletRed
  red(215) = 0.815686274509804
  green(215) = 0.125490196078431
  blue(215) = 0.564705882352941

! mocassin
  red(216) = 1.00000000000000
  green(216) = 0.890000000000000
  blue(216) = 0.710000000000000

! OldLace
  red(217) = 0.992156862745098
  green(217) = 0.960784313725490
  blue(217) = 0.901960784313726

! deeppink
  red(218) = 1.00000000000000
  green(218) = 8.000000000000000E-002
  blue(218) = 0.580000000000000

! Honeydew3
  red(219) = 0.756862745098039
  green(219) = 0.803921568627451
  blue(219) = 0.756862745098039

! Gainsboro
  red(220) = 0.862745098039216
  green(220) = 0.862745098039216
  blue(220) = 0.862745098039216

! DarkSalmon
  red(221) = 0.913725490196078
  green(221) = 0.588235294117647
  blue(221) = 0.478431372549020

! AntiqueWhite1
  red(222) = 1.00000000000000
  green(222) = 0.937254901960784
  blue(222) = 0.858823529411765

! LightCyan
  red(223) = 0.878431372549020
  green(223) = 1.00000000000000
  blue(223) = 1.00000000000000

! ForestGreen
  red(224) = 0.133333333333333
  green(224) = 0.545098039215686
  blue(224) = 0.133333333333333

! Orchid
  red(225) = 0.854901960784314
  green(225) = 0.439215686274510
  blue(225) = 0.839215686274510

! PeachPuff2
  red(226) = 0.933333333333333
  green(226) = 0.796078431372549
  blue(226) = 0.678431372549020

! LightPink
  red(227) = 1.00000000000000
  green(227) = 0.713725490196078
  blue(227) = 0.756862745098039

! Sienna
  red(228) = 0.627450980392157
  green(228) = 0.321568627450980
  blue(228) = 0.176470588235294

! darkorchid
  red(229) = 0.600000000000000
  green(229) = 0.200000000000000
  blue(229) = 0.800000000000000

! MediumSlateBlue
  red(230) = 0.482352941176471
  green(230) = 0.407843137254902
  blue(230) = 0.933333333333333

! CadetBlue
  red(231) = 0.372549019607843
  green(231) = 0.619607843137255
  blue(231) = 0.627450980392157

! LawnGreen
  red(232) = 0.486274509803922
  green(232) = 0.988235294117647
  blue(232) = 0.000000000000000E+000

! Chartreuse
  red(233) = 0.498039215686275
  green(233) = 1.00000000000000
  blue(233) = 0.000000000000000E+000

! Brown
  red(234) = 0.647058823529412
  green(234) = 0.164705882352941
  blue(234) = 0.164705882352941

! Azure
  red(235) = 0.941176470588235
  green(235) = 1.00000000000000
  blue(235) = 1.00000000000000

! Bisque
  red(236) = 1.00000000000000
  green(236) = 0.894117647058824
  blue(236) = 0.768627450980392

! recherche des positions maximales des points de la grille
  xmax=maxval(coord(1,:))
  zmax=maxval(coord(2,:))
  write(IOUT,*) 'Max X = ',xmax
  write(IOUT,*) 'Max Z = ',zmax

! limite du repere physique
  xmin=0.d0
  zmin=0.d0

! rapport taille page/taille domaine physique
  rapp_page = min(rpercentz*sizez/(zmax-zmin),rpercentx*sizex/(xmax-xmin)) / 100.d0

! recherche de la valeur maximum de la norme du deplacement
  dispmax = maxval(sqrt(displ(1,:)**2 + displ(2,:)**2))
  write(IOUT,*) 'Max norme = ',dispmax

! hauteur des numeros de domaine en CM
  height = 0.25d0

!
!---- ouverture du fichier PostScript
!
  write(name,"('OUTPUT_FILES/vect',i6.6,'.ps')") it
  open(unit=24,file=name,status='unknown')

!
!---- ecriture de l'entete du fichier PostScript
!
  write(24,10) stitle
  write(24,*) '/CM {28.5 mul} def'
  write(24,*) '/LR {rlineto} def'
  write(24,*) '/LT {lineto} def'
  write(24,*) '/L {lineto} def'
  write(24,*) '/MR {rmoveto} def'
  write(24,*) '/MV {moveto} def'
  write(24,*) '/M {moveto} def'
  write(24,*) '/MK {mark} def'
  write(24,*) '/ST {stroke} def'
  write(24,*) '/CP {closepath} def'
  write(24,*) '/RG {setrgbcolor} def'
  write(24,*) '/GF {gsave fill grestore} def'
  write(24,*) '/GG {0 setgray ST} def'
  write(24,*) '/GC {Colmesh ST} def'
  write(24,*) '/RF {setrgbcolor fill} def'
  write(24,*) '/SF {setgray fill} def'
  write(24,*) '/GS {gsave} def'
  write(24,*) '/GR {grestore} def'
  write(24,*) '/SLW {setlinewidth} def'
  write(24,*) '/SCSF {scalefont setfont} def'
  write(24,*) '% differents symboles utiles'
  write(24,*) '/Point {2 0 360 arc CP 0 setgray fill} def'
  write(24,*) '/VDot {-0.75 -1.5 MR 1.5 0 LR 0 3. LR -1.5 0 LR'
  write(24,*) 'CP fill} def'
  write(24,*) '/HDot {-1.5 -0.75 MR 3. 0 LR 0 1.5 LR -3. 0 LR'
  write(24,*) 'CP fill} def'
  write(24,*) '/Cross {GS 0.05 CM SLW'
  write(24,*) 'GS 3 3 MR -6. -6. LR ST GR'
  write(24,*) 'GS 3 -3 MR -6. 6. LR ST GR'
  write(24,*) '0.01 CM SLW} def'
  write(24,*) '/SmallLine {MV 0.07 CM 0 rlineto} def'
  write(24,*) '/Losange {GS 0.05 CM SLW 0 4.2 MR'
  write(24,*) '-3 -4.2 LR 3 -4.2 LR 3 4.2 LR CP ST'
  write(24,*) 'GR 0.01 CM SLW} def'
  write(24,*) '%'
  write(24,*) '% niveaux de gris pour le modele de vitesse'
  write(24,*) '/BK {setgray fill} def'
  write(24,*) '% version noir et blanc'
  write(24,*) '%/BK {pop 1 setgray fill} def'
  write(24,*) '%'
  write(24,*) '% magenta pour les vecteurs deplacement'
  write(24,*) '/Colvects {0.01 CM SLW 1. 0. 1. RG} def'
  write(24,*) '% version noir et blanc'
  write(24,*) '%/Colvects {0.01 CM SLW 0. setgray} def'
  write(24,*) '%'
  write(24,*) '% chartreuse pour le maillage des macroblocs'
  write(24,*) '/Colmesh {0.02 CM SLW 0.5 1. 0. RG} def'
  write(24,*) '% version noir et blanc'
  write(24,*) '%/Colmesh {0.02 CM SLW 0. setgray} def'
  write(24,*) '%'
  write(24,*) '% cyan pour les sources et recepteurs'
  write(24,*) '/Colreceiv {0. 1. 1. RG} def'
  write(24,*) '% version noir et blanc'
  write(24,*) '%/Colreceiv {0. setgray} def'
  write(24,*) '%'
  write(24,*) '% macro dessin fleche'
  write(24,*) '/F {MV LR gsave LR ST grestore LR ST} def'
  write(24,*) '% macro dessin contour elements'
  write(24,*) '/CO {M counttomark 2 idiv {L} repeat cleartomark CP} def'
  write(24,*) '%'
  write(24,*) '.01 CM SLW'
  write(24,*) '/Times-Roman findfont'
  write(24,*) '.35 CM SCSF'
  write(24,*) '%'
  write(24,*) '/vshift ',-height/2,' CM def'
  write(24,*) '/Rshow { currentpoint stroke MV'
  write(24,*) 'dup stringwidth pop neg vshift MR show } def'
  write(24,*) '/Cshow { currentpoint stroke MV'
  write(24,*) 'dup stringwidth pop -2 div vshift MR show } def'
  write(24,*) '/fN {/Helvetica-Bold findfont ',height,' CM SCSF} def'
  write(24,*) '%'
  write(24,*) 'gsave newpath 90 rotate'
  write(24,*) '0 ',-sizez,' CM translate 1. 1. scale'
  write(24,*) '%'

!
!--- ecriture des legendes du fichier PostScript
!
  write(24,*) '0 setgray'
  write(24,*) '/Times-Roman findfont'
  write(24,*) '.5 CM SCSF'

  if(legendes) then
  write(24,*) '24. CM 1.2 CM MV'
  write(24,610) usoffset,it
  write(24,*) '%'

  write(24,*) '24. CM 1.95 CM MV'
  timeval = it*dt
  if(timeval >= 1.d-3) then
    write(24,600) usoffset,timeval
  else
    write(24,601) usoffset,timeval
  endif
  write(24,*) '%'
  write(24,*) '24. CM 2.7 CM MV'
  write(24,640) usoffset,dispmax
  write(24,*) '%'
  write(24,*) '24. CM 3.45 CM MV'
  write(24,620) usoffset,cutvect*100.d0

  write(24,*) '%'
  write(24,*) '/Times-Roman findfont'
  write(24,*) '.6 CM SCSF'
  if(colors == 1) write(24,*) '.4 .9 .9 setrgbcolor'
  write(24,*) '11 CM 1.1 CM MV'
  write(24,*) '(X axis) show'
  write(24,*) '%'
  write(24,*) '1.4 CM 9.5 CM MV'
  write(24,*) 'currentpoint gsave translate 90 rotate 0 0 moveto'
  write(24,*) '(Y axis) show'
  write(24,*) 'grestore'
  write(24,*) '%'
  write(24,*) '/Times-Roman findfont'
  write(24,*) '.7 CM SCSF'
  if(colors == 1) write(24,*) '.8 0 .8 setrgbcolor'
  write(24,*) '24.35 CM 18.9 CM MV'
  write(24,*) usoffset,' CM 2 div neg 0 MR'
  write(24,*) 'currentpoint gsave translate -90 rotate 0 0 moveto'
  if(vecttype == 1) then
    write(24,*) '(Displacement vector field) show'
  else if(vecttype == 2) then
    write(24,*) '(Velocity vector field) show'
  else if(vecttype == 3) then
    write(24,*) '(Acceleration vector field) show'
  else
    stop 'Bad field code in PostScript display'
  endif
  write(24,*) 'grestore'
  write(24,*) '25.35 CM 18.9 CM MV'
  write(24,*) usoffset,' CM 2 div neg 0 MR'
  write(24,*) 'currentpoint gsave translate -90 rotate 0 0 moveto'
  write(24,*) '(',stitle,') show'
  write(24,*) 'grestore'
  write(24,*) '26.45 CM 18.9 CM MV'
  write(24,*) usoffset,' CM 2 div neg 0 MR'
  write(24,*) 'currentpoint gsave translate -90 rotate 0 0 moveto'

  if(ELASTIC) then
    write(24,*) '(Elastic Wave 2D - Spectral Element Method) show'
  else
    write(24,*) '(Acoustic Wave 2D - Spectral Element Method) show'
  endif

  write(24,*) 'grestore'

  endif

  write(24,*) '%'
  write(24,*) scalex,' ',scalez,' scale'
  write(24,*) '%'

!
!---- print the spectral elements mesh in PostScript
!

  write(IOUT,*) 'Shape functions based on ',ngnod,' control nodes'

  convert = pi/180.d0

!
!----  draw the velocity model in background
!
  if(modelvect) then

  do ispec=1,nspec
    do i=1,NGLLX-subsamp,subsamp
          do j=1,NGLLX-subsamp,subsamp

  if((vpmax-vpmin)/vpmin > 0.02d0) then
  if(read_external_model) then
    x1 = (vpext(ibool(i,j,ispec))-vpmin)/ (vpmax-vpmin)
  else
    material = kmato(ispec)
    rlamda = elastcoef(1,material)
    rmu    = elastcoef(2,material)
    denst  = density(material)
    rKvol  = rlamda + 2.d0*rmu/3.d0
    cploc = sqrt((rKvol + 4.d0*rmu/3.d0)/denst)
    x1 = (cploc-vpmin)/(vpmax-vpmin)
  endif
  else
    x1 = 0.5d0
  endif

! rescaler pour eviter gris trop sombre
  x1 = x1*0.7 + 0.2
  if(x1 > 1.d0) x1=1.d0

! inverser echelle : blanc = vpmin, gris = vpmax
  x1 = 1.d0 - x1

  xw = coord(1,ibool(i,j,ispec))
  zw = coord(2,ibool(i,j,ispec))
  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  write(24,500) xw,zw

  xw = coord(1,ibool(i+subsamp,j,ispec))
  zw = coord(2,ibool(i+subsamp,j,ispec))
  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  write(24,499) xw,zw

  xw = coord(1,ibool(i+subsamp,j+subsamp,ispec))
  zw = coord(2,ibool(i+subsamp,j+subsamp,ispec))
  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  write(24,499) xw,zw

  xw = coord(1,ibool(i,j+subsamp,ispec))
  zw = coord(2,ibool(i,j+subsamp,ispec))
  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  write(24,499) xw,zw
  write(24,604) x1

          enddo
    enddo
  enddo

  endif

!
!---- draw spectral element mesh
!

  if(meshvect) then

  write(24,*) '%'
  write(24,*) '% spectral element mesh'
  write(24,*) '%'

  do ispec=1,nspec

  write(24,*) '% elem ',ispec

  do i=1,pointsdisp
  do j=1,pointsdisp
  xinterp(i,j) = 0.d0
  zinterp(i,j) = 0.d0
  do in = 1,ngnod
    nnum = knods(in,ispec)
      xinterp(i,j) = xinterp(i,j) + shapeint(in,i,j)*coorg(1,nnum)
      zinterp(i,j) = zinterp(i,j) + shapeint(in,i,j)*coorg(2,nnum)
  enddo
  enddo
  enddo

  is = 1
  ir = 1
  x1 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
  z1 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
  x1 = x1 * centim
  z1 = z1 * centim
  write(24,*) 'MK'
  write(24,681) x1,z1

  if(ngnod == 4) then

! tracer des droites si elements 4 noeuds

  ir=pointsdisp
  x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
  z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
  x2 = x2 * centim
  z2 = z2 * centim
  write(24,681) x2,z2

  ir=pointsdisp
  is=pointsdisp
  x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
  z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
  x2 = x2 * centim
  z2 = z2 * centim
  write(24,681) x2,z2

  is=pointsdisp
  ir=1
  x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
  z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
  x2 = x2 * centim
  z2 = z2 * centim
  write(24,681) x2,z2

  ir=1
  is=2
  x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
  z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
  x2 = x2 * centim
  z2 = z2 * centim
  write(24,681) x2,z2

  else

! tracer des courbes si elements 9 noeuds
  do ir=2,pointsdisp
    x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
    z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
    x2 = x2 * centim
    z2 = z2 * centim
    write(24,681) x2,z2
  enddo

  ir=pointsdisp
  do is=2,pointsdisp
    x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
    z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
    x2 = x2 * centim
    z2 = z2 * centim
    write(24,681) x2,z2
  enddo

  is=pointsdisp
  do ir=pointsdisp-1,1,-1
    x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
    z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
    x2 = x2 * centim
    z2 = z2 * centim
    write(24,681) x2,z2
  enddo

  ir=1
  do is=pointsdisp-1,2,-1
    x2 = (xinterp(ir,is)-xmin)*rapp_page + orig_x
    z2 = (zinterp(ir,is)-zmin)*rapp_page + orig_z
    x2 = x2 * centim
    z2 = z2 * centim
    write(24,681) x2,z2
  enddo

  endif

  write(24,*) 'CO'

  if(colors == 1) then

! use a different color for each material set
  imat = kmato(ispec)
  icol = mod(imat - 1,NUM_COLORS) + 1

  write(24,680) red(icol),green(icol),blue(icol)

  endif

  if(modelvect) then
  write(24,*) 'GC'
  else
  write(24,*) 'GG'
  endif

! write the element number, the group number and the material number inside the element
  if(numbers == 1) then

  xw = (coorg(1,knods(1,ispec)) + coorg(1,knods(2,ispec)) + &
          coorg(1,knods(3,ispec)) + coorg(1,knods(4,ispec))) / 4.d0
  zw = (coorg(2,knods(1,ispec)) + coorg(2,knods(2,ispec)) + &
          coorg(2,knods(3,ispec)) + coorg(2,knods(4,ispec))) / 4.d0
  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  if(colors == 1) write(24,*) '1 setgray'

  write(24,500) xw,zw

!--- ecriture numero de l'element
  write(24,502) ispec

  endif

  enddo

  endif

!
!----  draw the boundary conditions
!

  if(anyabs .and. boundvect) then

  write(24,*) '%'
  write(24,*) '% boundary conditions on the mesh'
  write(24,*) '%'

  write(24,*) '0.05 CM SLW'

!--- bords absorbants

  if(anyabs) then

  do ispecabs = 1,nelemabs
  ispec = numabs(ispecabs)

!--- une couleur pour chaque condition absorbante
!--- bord absorbant de type "haut"   : orange
!--- bord absorbant de type "bas"    : vert clair
!--- bord absorbant de type "gauche" : rose clair
!--- bord absorbant de type "droite" : turquoise

  do ibord = 1,4

  if(codeabs(ibord,ispecabs) /= 0) then

  if(ibord == ITOP) then
    write(24,*) '1. .85 0. RG'
    ideb = 3
    ifin = 4
  else if(ibord == IBOTTOM) then
    write(24,*) '.4 1. .4 RG'
    ideb = 1
    ifin = 2
  else if(ibord == ILEFT) then
    write(24,*) '1. .43 1. RG'
    ideb = 4
    ifin = 1
  else if(ibord == IRIGHT) then
    write(24,*) '.25 1. 1. RG'
    ideb = 2
    ifin = 3
  else
    stop 'Wrong absorbing boundary code'
  endif

  x1 = (coorg(1,knods(ideb,ispec))-xmin)*rapp_page + orig_x
  z1 = (coorg(2,knods(ideb,ispec))-zmin)*rapp_page + orig_z
  x2 = (coorg(1,knods(ifin,ispec))-xmin)*rapp_page + orig_x
  z2 = (coorg(2,knods(ifin,ispec))-zmin)*rapp_page + orig_z
  x1 = x1 * centim
  z1 = z1 * centim
  x2 = x2 * centim
  z2 = z2 * centim
  write(24,602) x1,z1,x2,z2

  endif
  enddo

  enddo

  endif

  write(24,*) '0 setgray'
  write(24,*) '0.01 CM SLW'

  endif

!
!----  draw the normalized displacement field
!

! return if the maximum displacement equals zero (no source)
  if(dispmax == 0.d0) then
    write(IOUT,*) ' null displacement : returning !'
    return
  endif

  write(24,*) '%'
  write(24,*) '% vector field'
  write(24,*) '%'

! fleches en couleur si modele de vitesse en background
  if(modelvect) then
        write(24,*) 'Colvects'
  else
        write(24,*) '0 setgray'
  endif

  if(interpol) then

  write(IOUT,*) 'Interpolating the vector field...'

  do ispec=1,nspec

! interpolation sur grille reguliere
  if(mod(ispec,1000) == 0) write(IOUT,*) 'Interpolation uniform grid element ',ispec

! option to plot only lowerleft corner value to avoid very large files if dense meshes
  if(plot_lowerleft_corner_only) then
    pointsdisp_loop = 1
  else
    pointsdisp_loop = pointsdisp
  endif

  do i=1,pointsdisp_loop
  do j=1,pointsdisp_loop

  xinterp(i,j) = 0.d0
  zinterp(i,j) = 0.d0
  do in = 1,ngnod
    nnum = knods(in,ispec)
      xinterp(i,j) = xinterp(i,j) + shapeint(in,i,j)*coorg(1,nnum)
      zinterp(i,j) = zinterp(i,j) + shapeint(in,i,j)*coorg(2,nnum)
  enddo

  Uxinterp(i,j) = 0.d0
  Uzinterp(i,j) = 0.d0

  do k=1,NGLLX
  do l=1,NGLLX

  Uxinterp(i,j) = Uxinterp(i,j) + &
                displ(1,ibool(k,l,ispec))*flagrange(k,i)*flagrange(l,j)
  Uzinterp(i,j) = Uzinterp(i,j) + &
                displ(2,ibool(k,l,ispec))*flagrange(k,i)*flagrange(l,j)

  enddo
  enddo

  x1 =(xinterp(i,j)-xmin)*rapp_page
  z1 =(zinterp(i,j)-zmin)*rapp_page

  x2 = Uxinterp(i,j)*sizemax_arrows/dispmax
  z2 = Uzinterp(i,j)*sizemax_arrows/dispmax

  d = sqrt(x2**2 + z2**2)

! ignorer si vecteur trop petit
  if(d > cutvect*sizemax_arrows) then

  d1 = d * rapport
  d2 = d1 * cos(angle*convert)

  dummy = x2/d
  if(dummy > 0.9999d0) dummy = 0.9999d0
  if(dummy < -0.9999d0) dummy = -0.9999d0
  theta = acos(dummy)

  if(z2 < 0.d0) theta = 360.d0*convert - theta
  thetaup = theta - angle*convert
  thetadown = theta + angle*convert

! tracer le vecteur proprement dit
  x1 = (orig_x+x1) * centim
  z1 = (orig_z+z1) * centim
  x2 = x2 * centim
  z2 = z2 * centim
  xa = -d2*cos(thetaup)
  za = -d2*sin(thetaup)
  xa = xa * centim
  za = za * centim
  xb = -d2*cos(thetadown)
  zb = -d2*sin(thetadown)
  xb = xb * centim
  zb = zb * centim
  write(name,700) xb,zb,xa,za,x2,z2,x1,z1

! filtrer les blancs inutiles pour diminuer taille fichier PostScript
  longueur = 49
  indice = 1
  first = .false.
  do ii=1,longueur-1
    if(ch1(ii) /= ' ' .or. first) then
      if(ch1(ii) /= ' ' .or. ch1(ii+1) /= ' ') then
        ch2(indice) = ch1(ii)
        indice = indice + 1
        first = .true.
      endif
    endif
  enddo
  ch2(indice) = ch1(longueur)
  write(24,"(80(a1))") (ch2(ii),ii=1,indice)

  endif

  enddo
  enddo
  enddo

  else
! tracer les vecteurs deplacement aux noeuds du maillage

  do ipoin=1,npoin

  x1 =(coord(1,ipoin)-xmin)*rapp_page
  z1 =(coord(2,ipoin)-zmin)*rapp_page

  x2 = displ(1,ipoin)*sizemax_arrows/dispmax
  z2 = displ(2,ipoin)*sizemax_arrows/dispmax

  d = sqrt(x2**2 + z2**2)

! ignorer si vecteur trop petit
  if(d > cutvect*sizemax_arrows) then

  d1 = d * rapport
  d2 = d1 * cos(angle*convert)

  dummy = x2/d
  if(dummy > 0.9999d0) dummy = 0.9999d0
  if(dummy < -0.9999d0) dummy = -0.9999d0
  theta = acos(dummy)

  if(z2 < 0.d0) theta = 360.d0*convert - theta
  thetaup = theta - angle*convert
  thetadown = theta + angle*convert

! tracer le vecteur proprement dit
  x1 = (orig_x+x1) * centim
  z1 = (orig_z+z1) * centim
  x2 = x2 * centim
  z2 = z2 * centim
  xa = -d2*cos(thetaup)
  za = -d2*sin(thetaup)
  xa = xa * centim
  za = za * centim
  xb = -d2*cos(thetadown)
  zb = -d2*sin(thetadown)
  xb = xb * centim
  zb = zb * centim
  write(name,700) xb,zb,xa,za,x2,z2,x1,z1

! filtrer les blancs inutiles pour diminuer taille fichier PostScript
  longueur = 49
  indice = 1
  first = .false.
  do ii=1,longueur-1
    if(ch1(ii) /= ' ' .or. first) then
      if(ch1(ii) /= ' ' .or. ch1(ii+1) /= ' ') then
        ch2(indice) = ch1(ii)
        indice = indice + 1
        first = .true.
      endif
    endif
  enddo
  ch2(indice) = ch1(longueur)
  write(24,"(80(a1))") (ch2(ii),ii=1,indice)

  endif

  enddo

  endif

  write(24,*) '0 setgray'

! sources et recepteurs en couleur si modele de vitesse
  if(modelvect) then
    write(24,*) 'Colreceiv'
  else
    write(24,*) '0 setgray'
  endif

!
!----  write position of the source
!
  xw = x_source
  zw = z_source
  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  write(24,510) xw,zw
  if(isymbols) then
    write(24,*) 'Cross'
  else
    write(24,*) '(S) show'
  endif

!
!----  write position of the receivers
!
  do i=1,nrec
  if(i == 1) write(24,*) '% debut ligne recepteurs'
  if(i == nrec) write(24,*) '% fin ligne recepteurs'

  xw = st_xval(i)
  zw = st_zval(i)

  xw = (xw-xmin)*rapp_page + orig_x
  zw = (zw-zmin)*rapp_page + orig_z
  xw = xw * centim
  zw = zw * centim
  write(24,510) xw,zw
  if(isymbols) then
    if(nrec > ndots .and. i /= 1 .and. i /= nrec) then
      write(24,*) 'VDot'
    else
      write(24,*) 'Losange'
    endif
  else
  write(24,*) '(R',i,') show'
  endif
  enddo

  write(24,*) '%'
  write(24,*) 'grestore'
  write(24,*) 'showpage'

  close(24)

 10   format('%!PS-Adobe-2.0',/,'%%',/,'%% Title: ',a50,/, &
          '%% Created by: Specfem2D',/, &
          '%% Author: Dimitri Komatitsch',/,'%%')
 510  format(f5.1,1x,f5.1,' M')
 600  format(f6.3,' neg CM 0 MR (Time =',f6.3,' s) show')
 601  format(f6.3,' neg CM 0 MR (Time =',1pe10.3,' s) show')
 610  format(f6.3,' neg CM 0 MR (Time step = ',i7,') show')
 620  format(f6.3,' neg CM 0 MR (Cut =',f5.2,' \%) show')
 640  format(f6.3,' neg CM 0 MR (Max norm =',1pe10.3,') show')

 499  format(f5.1,1x,f5.1,' L')
 500  format(f5.1,1x,f5.1,' M')
 502  format('fN (',i4,') Cshow')
 680  format(f12.6,1x,f12.6,1x,f12.6,' RG GF')
 681  format(f6.2,1x,f6.2)
 602  format(f6.2,1x,f6.2,' M ',f6.2,1x,f6.2,' L ST')
 604  format('CP ',f12.6,' BK')
 700  format(8(f5.1,1x),'F')

  end subroutine plotpost

