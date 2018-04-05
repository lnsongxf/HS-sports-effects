/************************************************************************
*** You may need to edit this code.                                  ***
***                                                                  ***
*** Please check all CD statements and USE statements before         ***
*** running this code.                                               ***
***                                                                  ***
*** You may have selected variables that contain missing data or     ***
*** valid skips. You may wish to recode one or both of these special ***
*** values. You need to consult the Variable Description to see if   ***
*** these special codes apply to your extracted variables. You can   ***
*** recode these special values to missing using the following       ***
*** sample code:                                                     ***
***                                                                  ***
*** replace {variable name} = . if {variable name} = {value};        ***
***                                                                  ***
*** Replace {variable name} above with the name of the variable you  ***
*** wish to recode. Replace {value} with the special value you wish  ***
*** to recode to missing.                                            ***
***                                                                  ***
*** It is important to retain full sample weights, replicate         ***
*** weights, and identification numbers as appropriate.              ***
************************************************************************/

#delimit;
set more off;
version 13.1;

/* Change working directory */
/* cd NOT NECESSARY */

log using NELS88_readin.log, text replace;

/* Clear everything */
clear all;

/* Increase memory size to allow for dataset */
set maxvar 10000;

/* Uncompress Stata dataset */
! unzip -o NELS_88_00_BYF4STU_V1_0.dta.zip;

/* Open Stata dataset */
use NELS_88_00_BYF4STU_V1_0.dta;

/* Compress Stata dataset */
! zip -u NELS_88_00_BYF4STU_V1_0.dta.zip NELS_88_00_BYF4STU_V1_0.dta;

/* Keep only selected variables */
keep
    F4UNIV1
    F4UNI2A
    F4UNI2B
    F4UNI2C
    F4UNI2D
    F4UNI2E
    BIRTHYR
    RACE
    SEX
    BYS8A
    BYS8C
    BYS12
    BYS34A
    BYS34B
    BYSCENRL
    G8MINOR
    BYGRADS
    BY2XRIRR
    BY2XMIRR
    F1S41AA
    F1S41AB
    F1S41AC
    F1S41AD
    F1S41AE
    F1S41AF
    F1S41AG
    F1S41AH
    F1S41AI
    F1S41BA
    F1S41BB
    F1S41BC
    F1S41BD
    F1S41BE
    F1S41BF
    F1S41BG
    F1S41BH
    F1S41BI
    F1S81
    F1S82
    F1S84
    F1S85
    F1S90A
    F1S90B
    F1S92A
    F1S92D
    F1STAT
    F1DOSTAT
    F1SEX
    F1RACE
    F1SES
    G10CTRL1
    G10URBAN
    G10REGON
    F1SCENRL
    G10ENROL
    F1SCH_ID
    F2S5AMO
    F2S5ADA
    F2S6A
    F2S30AA
    F2S30AB
    F2S30AC
    F2S30BA
    F2S30BB
    F2S30BC
    F2S30BD
    F2S30BE
    F2S30BF
    F2S30BG
    F2S86A
    F2S88
    F2F1SCFL
    BYSC13C
    BYSC13D
    BYRATIO
    F1C10
    F1C27F
    F1C30A
    F1C30I
    F1C71B
    F1C71C
    F1C71E
    F1C71N
    F1C71O
    F1C71P
    F1C71R
    F1C71S
    F1C71V
    F1C76
    F1C77
    F2C49
    BYP3A
    BYP4
    BYP80
    BYT1_2
    BYT1_4
    BYT1_10
    BYT1_12
    F4AACTF
    F4AACTH
    F4AEMPL
    F4AAFTN
    F4AAFNW
    F4BEVEM
    F4BWFOR
    F4BXOCCD
    F4BXINCD
    F4BWKSWK
    F4GMRS
    F4GNMRG
    F4GNCH
    F4GCH1
    G10COHRT
    F4SGPAR
    F4HSDIPL
    F4TYPEDG
    F4ATT4YR
    F4ATTPSE
    F4ENRL00
    STU_ID
    F4QWT
    F4BYPNWT
    F4PNLWT
    F4F1PNWT
    F4F2PNWT
    F4CXTWT
    F4PAQWT
    F4TRSCWT
    F4QWT92G
    F4EDGR1
    F4EDGR2
    F4EDGR3
    F4EDGR4
    F4EDGR5
    F4EDGR6
    F4EMJ1
    F4EMJ2
    F4EMJ3
    F4EMJ4
    F4EMJ5
    F4EMJ6
    F4ED1
    F4ED2
    F4ED3
    F4ED4
    F4ED5
    F4ED6
    FIRSTSXM
    FIRSTSXY
    ARRESTED
    F4HI99
    F4HHOSE
    F4IFITNS
    F4IRVOTE
    F4ISMOKE
    F4IBINGE
    NATELEC
    VOTEPRES
    F3VOTED
    F4IVPRE
   ;

/* Compress the data to save space */
compress;

/* Save dataset */
save "NELS88_short4.dta", replace;

describe;

log close;
