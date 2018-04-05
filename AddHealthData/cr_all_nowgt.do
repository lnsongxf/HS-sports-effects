version 13.1
clear all
set more off
capture log close
log using "cr_all_nowgt.log", replace

global ahpvtdatapath "../Data/In Home Interview Files/"
global wgtdatapath "../Data/Grand Sample Weights/"
global schdatapath "../Data/School Files/"
global datapath "../Data/In Home Interview Files/"

set maxvar 32000

*-------------------------------------------------
* Create all permanent variables and save all data
*-------------------------------------------------
tempfile weight1
import sasxport "${wgtdatapath}Homewt1", clear
save `weight1', replace
d
ds, alpha

tempfile weight2
import sasxport "${wgtdatapath}Homewt2", clear
save `weight2', replace
d
ds, alpha

tempfile weight3
import sasxport "${wgtdatapath}weights3", clear
save `weight3', replace
d
ds, alpha

tempfile weight4
import sasxport "${wgtdatapath}weights4", clear
save `weight4', replace
d
ds, alpha

tempfile ahpvt
import sasxport "${ahpvtdatapath}ahpvt3", clear
merge 1:1 aid using `weight1'
recode pvtstd1 (995 = .n)
qui sum pvtstd1 
gen meanahpvt = `r(mean)'
gen sdahpvt = `r(sd)'
gen ahpvt_std = (pvtstd1 - meanahpvt)/sdahpvt
sum ahpvt_std, d
keep aid ahpvt_std
save `ahpvt', replace
d
ds, alpha

tempfile Schinfo
import sasxport "${schdatapath}School Information Data/Schinfo", clear
save `Schinfo', replace
d
ds, alpha

tempfile Schadm1
import sasxport "${schdatapath}School Administrator Questionnaire- Wave I/Schadm1", clear
ren aschlcde scid
save `Schadm1', replace
d
ds, alpha

tempfile Schadm2
import sasxport "${schdatapath}School Administrator Questionnaire- Wave II/Schadm2", clear
ren bschlcde scid
save `Schadm2', replace
d
ds, alpha

tempfile wave1
import sasxport "${datapath}allwave1", clear
save `wave1', replace
d
ds, alpha

tempfile wave2
import sasxport "${datapath}wave2", clear
save `wave2', replace
d
ds, alpha

tempfile wave3
import sasxport "${datapath}wave3", clear
save `wave3', replace
d
ds, alpha

tempfile wave4
import sasxport "${datapath}wave4", clear
save `wave4', replace
d
ds, alpha

use `wave1', clear
merge 1:1 aid  using `ahpvt'  , keep(match master) nogen
merge m:1 scid using `Schinfo', keep(match master) nogen
merge m:1 scid using `Schadm1', keep(match master) nogen keepusing(a7)
merge 1:1 aid  using `weight1', keep(match master) nogen keepusing(gsw*)
merge 1:1 aid  using `weight2', keep(match master) nogen keepusing(gsw*)
merge 1:1 aid  using `weight3', keep(match master) nogen keepusing(gsw*)
merge 1:1 aid  using `weight4', keep(match master) nogen keepusing(gsw*)
forvalues x=2/4 {
	merge 1:1 aid using `wave`x'', nogen
}
destring h4lm8  , force replace ignore("-")
destring h4lm18 , force replace ignore("-")
destring h3lm25 , force replace ignore("-")
destring h3lm26a, force replace ignore("-")
destring h3lm26b, force replace ignore("-")
destring h3lm26c, force replace ignore("-")
destring h3ed16 , force replace ignore("-")
destring h3ed17 , force replace ignore("-")

local famvars   s11 s12 s14 s15 s17 s18 s20 s21 pa1 pa12 pb2 pb8
local schvars   n_roster n_inschl grades size schtype metro qpwht region a7
local biovars   h1gh59a h1gh59b h2gh52f h2gh52i h2ws16hf h2ws16hi h3da43f h3da43i h3hgt_f h3hgt_i h3hgt_pi h4gh5f h4gh5i h1gh60 h2gh53 h2ws16w h3da44 h3wgt h4gh6
local clubvars  s44*
local demogvars ahpvt_std h1gi1m h1gi1y imonth* iday* iyear* bio_sex h1gi4 h1gi6a h1gi6b h1gi6c h1gi6d h1gi6e gsw*
local educvars  h3ed5 h3ed6 h3ed7 h3ed8 h3ed16 h3ed17 h4ed1 h4ed2 h4ed3a h4ed4a h4ed6
local workvars  h3ec4 h3ec5 h3lm2 h3lm7 h3lm13m h3lm13y h3lm14 h3lm15m h3lm15y h3lm16 h3lm17 h3lm18 h3lm19 h3lm20 h3lm21 h3lm22 h3lm23 h3lm25 h3lm26a h3lm26b h3lm26c h4lm1 h4lm2 h4lm3 h4lm4 h4lm5 h4lm6 h4lm7 h4lm8 h4lm9y h4lm9m h4lm11 h4lm12 h4lm13 h4lm14 h4lm15m h4lm15y h4lm16m h4lm16y h4lm17 h4lm18 h4lm19 h4lm20 h4lm22 h4lm25 h3lm55 h3lm58 h3lm59 h3lm62 h3lm63 h3lm66 h3lm67 h3lm70 h3lm71 h3lm74 h3lm75 h3lm78 h3lm79 h3lm82 h4ec2 h4ec3 h4mi1 h4mi3
local subsvars  h4cj1 h4tr1 h4tr2 h4tr3 h4tr9 h4se7 h4to3 h4to4 h4to5 h4to33 h4to34 h4to35 h4to38 h4to46 h4to47 h4to48 h4to65a h4to65b h4to65c h4to65d h4to65e h4to63
local commvars  h4da26 h4da27 h4da28
local tracvars  mv_w1w4 tac09002
local excsvars  h1da10 h2da10 h3da5 h4da23 h4da13 h3da14 h4da8 h3da9 h4da3 h3da13 h4da7 h3da10 h4da4 h3da11 h4da5 h3da12 h4da6 h3da8 h4da2 h3gh5

keep aid scid `famvars' `schvars' `demogvars' `biovars' `clubvars' `educvars' `workvars' `subsvars' `commvars' `excsvars'
local onevars bio_sex h1gi4 h1gi6a h1gi6b h1gi6c h1gi6d h1gi6e s11 s15 s17 s21 h3ed5 h3ed6 h3ed7 h3ed8 h3hgt_pi h3lm55 h3lm58 h3lm59 h3lm62 h3lm63 h3lm66 h3lm67 h3lm70 h3lm71 h3lm74 h3lm75 h3lm78 h3lm79 h3lm82 h4ed1 h4ed6 h4cj1 h4tr1 h4to3 h4to33 h4to46 h4to47 h4to48 h4to65a h4to65b h4to65c h4to65d h4to65e h4to63 pa1 pb2 h4lm11 h4mi1 h4mi3 h4lm25 h4lm11 h4lm6 h3lm2 h3lm7
local twovars h1gi1m h1gi1y s12 s14 s18 s20 h1gh59a h1gh59b iyear2 h2gh52f h2gh52i h2ws16hf h2ws16hi h3da43f h3da43i h3hgt_f h3hgt_i h3ec5 h3lm15m h3lm16 h3lm17 h4da26 h4da27 h4da28 h4gh5f h4gh5i h4ed2 h4ed3a h4lm5 h4lm15m h4lm20 h4ec3 h4to4 h4to5 h4to34 h4to35 h4to38 pa12 pb8 h4lm14 h4lm22 h4lm17 h4lm16m h4lm12 h4lm9y h4lm9m h3lm13m h3lm13y h3lm14 h4tr2 h4tr3 h4tr9 h4se7 h2da10 h4da13 h4da8 h3da14 h3da9 h4da3 h3da13 h4da7 h3da10 h4da4 h3da11 h4da5 h3da12 h4da6 h3da8 h4da2 h3gh5
local thrvars h1gh60 h2gh53 h2ws16w h4gh6 h4lm19 h3da44 h3wgt h3lm18 h3lm19 h4lm13 h1da10 h3da5 h4da23
local forvars h3lm15y h4ed4a h4lm15y h4lm16y
local fivvars h3lm20 h3lm21 h3lm22 h3lm23
local sixvars h3ec4
local sevvars h4lm8 h4lm18 h4ec2 h3ed16 h3ed17 h3lm25 h3lm26a h3lm26b h3lm26c
sum `onevars' `twovars' `thrvars' `forvars' `sevvars', sep(0)
recode `onevars' (5       = .d) (6       = .r) (7       = .v) (8       = .d) (9       = .i) (. = .n)
recode `twovars' (95      = .d) (96      = .r) (97      = .v) (98      = .d) (99      = .i) (. = .n)
recode `thrvars' (995     = .d) (996     = .r) (997     = .v) (998     = .d) (999     = .i) (. = .n)
recode `forvars' (9995    = .d) (9996    = .r) (9997    = .v) (9998    = .d) (9999    = .i) (. = .n)
recode `fivvars' (99995   = .d) (99996   = .r) (99997   = .v) (99998   = .d) (99999   = .i) (. = .n)
recode `sixvars' (999995  = .d) (999996  = .r) (999997  = .v) (999998  = .d) (999999  = .i) (. = .n)
recode `sevvars' (9999995 = .d) (9999996 = .r) (9999997 = .v) (9999998 = .d) (9999999 = .i) (. = .n)
sum `onevars' `twovars' `thrvars' `forvars' `sevvars', sep(0)
egen id = group(aid)

* School characteristics
ren a7 avgClassSize
lab def vlmetro 1 "Urban" 2 "Suburban" 3 "Rural"
lab val metro vlmetro
lab def vlregion 1 "West" 2 "Midwest" 3 "South" 4 "Northeast"
lab val region vlregion
lab def vlqpwht 1 "0%" 2 "1-66%" 3 "67-93%" 4 "94-100%"
lab val qpwht vlqpwht
lab def vlschtype 1 "Public" 2 "Catholic" 3 "Private"
lab val schtype vlschtype

* Family background variables
rename  s11 liveWithMoth14
rename  s17 liveWithFath14
* rename  s12 hgcMoth
* rename  s18 hgcFath
* rename  s14 occMoth
* rename  s20 occFath
rename  s15 workingMoth
rename  s21 workingFath

generat hgcMoth = pa12 if pa1==2
replace hgcMoth = pb8  if pa1==1
generat hgcFath = pa12 if pa1==1
replace hgcFath = pb8  if pa1==2

recode hgcMoth hgcFath (1 2 3 10 = 1) (4 5 = 2) (6 7 = 3) (8 = 4) (9 = 5) (11 12 = .)
genera m_hgcMoth = mi(hgcMoth)
genera m_hgcFath = mi(hgcFath)
recode hgcMoth hgcFath (. .d .r .v .i .n = 6)

lab def vlhgcP 1 "HS dropout" 2 "HS grad" 3 "Some college" 4 "4-year graduate" 5 "Advanced degree" 6 "Missing" 
lab val hgcMoth vlhgcP
lab val hgcFath vlhgcP

genera m_liveWithMoth14 = mi(liveWithMoth14)
genera m_liveWithFath14 = mi(liveWithFath14)
recode liveWithMoth14 liveWithFath14 (. .d .r .v .i .n = 2)

lab def vllivewithP 0 "No" 1 "Yes" 2 "Missing" 
lab val hgcMoth vlhgcP
lab val hgcFath vlhgcP

* recode  hgcMoth hgcFath (1 = 4.5) (2 = 10) (3 4 = 12) (5 6 = 14) (7 = 16) (8 = 19) (9 11 = .d) (10 = 0)

gen momCol = inlist(hgcMoth,4,5)

* DOB variables
rename  h1gi1m birthMo
rename  h1gi1y birthYr
replace birthYr = 1900+birthYr
generat dob = ym(birthYr,birthMo)
lab var dob "Date of birth (Stata day format)"

* Interview date variables
ren imonth imonth1
ren iday   iday1
ren iyear  iyear1
replace iyear1 = 1900+iyear1
replace iyear2 = 1996
forvalues x=1/4{
	gen intvw`x' = ym(iyear`x',imonth`x')
	lab var intvw`x' "Wave `x' interview date (Stata month format)"
	gen ageD`x'  = (intvw`x'-dob)/12
	lab var ageD`x' "Age in year decimals at wave `x' interview"
	gen age`x'   = iyear`x'-birthYr
	lab var age`x' "Age in years at wave `x' interview"
}

* Demographic variables (sex, race)
generat female = bio_sex==2
replace female = . if mi(bio_sex)
generat latin = h1gi4 ==1  /* S1Q6A RACE-WHITE-W1            */
generat white = h1gi6a==1  /* S1Q6A RACE-WHITE-W1            */
generat black = h1gi6b==1  /* S1Q6B RACE-AFRICAN AMERICAN-W1 */
generat natam = h1gi6c==1  /* S1Q6C RACE-AMERICAN INDIAN-W1  */
generat asian = h1gi6d==1  /* S1Q6D RACE-ASIAN-W1            */
generat other = h1gi6e==1  /* S1Q6E RACE-OTHER-W1            */
drop bio_sex h1gi4 h1gi6a h1gi6b h1gi6c h1gi6d h1gi6e

generat race = .
replace race = 1 if white==1 & black==0 & latin==0 & natam==0 & asian==0 & other==0
replace race = 2 if black==1 & white==0 & latin==0 & natam==0 & asian==0 & other==0
replace race = 3 if latin==1
replace race = 4 if race==.
lab def vlrace 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
lab val race vlrace
lab var race "Race (4-categories, whites and blacks are non-Hispanic)"
drop white black latin natam asian other


* Pregnancy/sex variables
ren h4se7 ageFirstSex
gen everPregnant = inrange(h4tr9,1,30)
gen everRiskyPregnant = inrange(h4tr3,1,30)

* Height and weight variables
ren h1gh59a  heightFt1                /* S3Q59A HEIGHT-FEET-W1           */
ren h2gh52f  heightFt2                /* S3Q52 HEIGHT-FEET-W2            */
ren h3da43f  heightFt3                /* S33Q43 HEIGHT-FEET-W3           */
ren h4gh5f   heightFt4                /* S4Q5F HEIGHT-FEET-W4            */
ren h1gh59b  heightIn1                /* S3Q59B HEIGHT-INCHES-W1         */
ren h2gh52i  heightIn2                /* S3Q52 HEIGHT-INCHES-W2          */
ren h3da43i  heightIn3                /* S33Q43 HEIGHT-INCHES-W3         */
ren h4gh5i   heightIn4                /* S4Q5I HEIGHT-INCHES-W4          */
ren h1gh60   weightLbs1               /* S3Q60 WEIGHT-W1                 */
ren h2gh53   weightLbs2               /* S3Q53 WEIGHT-W2                 */
ren h3da44   weightLbs3               /* S33Q44 WEIGHT-LBS-W3            */
ren h4gh6    weightLbs4               /* S4Q6 WEIGHT-LBS-W4              */
ren h2ws16hf heightFtMeasured2        /* S38Q16 MEASURED HEIGHT-FEET-W2  */
ren h3hgt_f  heightFtMeasured3        /* MEASURED HEIGHT,FEET-W3         */
ren h2ws16hi heightInMeasured2        /* S38Q16 MEASURED HEIGHT-INCHES-W2*/
ren h3hgt_i  heightInMeasured3        /* MEASURED HEIGHT,INCHES-W3       */
ren h3hgt_pi heightPartialInMeasured3 /* MEASURED HEIGHT,PARTIAL INCH-W3 */
ren h2ws16w  weightLbsMeasured2       /* S38Q16 MEASURED WEIGHT-LBS-W2   */
ren h3wgt    weightLbsMeasured3       /* MEASURED WEIGHT-W3              */

forvalues x=1/4{
	gen height`x'     = heightFt`x'*12 + heightIn`x'
	if `x'==2 {
		gen heightMeas`x' = heightFtMeasured`x'*12 + heightInMeasured`x'
		replace weightLbsMeasured`x' = .i if weightLbsMeasured`x'>400
	}
	else if `x'==3 {
		gen heightMeas`x' = heightFtMeasured`x'*12 + heightInMeasured`x' + heightPartialInMeasured`x'
		replace weightLbsMeasured`x' = .i if weightLbsMeasured`x'>400
	}
	replace weightLbs`x' = .i if weightLbs`x'>400
}
tab heightFt1 if height1>100
tab heightIn1 if height1>100
drop heightFt* heightIn* heightPa*
ren weightLbsMeasured2 weightLbsMeas2
ren weightLbsMeasured3 weightLbsMeas3

forvalues x=1/4 {
	gen bmi`x'         = weightLbs`x'/(height`x'^2)*703
	gen overweight`x'  = inrange(bmi`x',25,29.99999999) if !mi(bmi`x')
	gen obese`x'       = inrange(bmi`x',30,100)         if !mi(bmi`x')
	gen ovrwgtObese`x' = inrange(bmi`x',25,100)         if !mi(bmi`x')
}

* Exercise / time use variables
ren h1da10 HrsVidGamesPastWk1
ren h2da10 HrsVidGamesPastWk2
ren h3da5  HrsVidGamesPastWk3
ren h4da23 HrsVidGamesPastWk4
ren h3gh5  TimesWkUseGym3
ren h4da13 TimesWkUseGym4
ren h3da14 TimesWkWalkExcs3
ren h4da8  TimesWkWalkExcs4
ren h3da9  TimesWkBoardRqtSports3
ren h4da3  TimesWkBoardRqtSports4
ren h3da13 TimesWkGolfBaseFishSports3
ren h4da7  TimesWkGolfBaseFishSports4
ren h3da10 TimesWkStrenTmSports3
ren h4da4  TimesWkStrenTmSports4
ren h3da11 TimesWkStrenIndivSports3
ren h4da5  TimesWkStrenIndivSports4
ren h3da12 TimesWkGymnastLifting3
ren h4da6  TimesWkGymnastLifting4
ren h3da8  TimesWkBikeDanceHikeYard3
ren h4da2  TimesWkBikeDanceHikeYard4

egen TimesWkExercise3 = rowtotal(TimesWkUseGym3 TimesWkWalkExcs3 TimesWkBoardRqtSports3 TimesWkGolfBaseFishSports3 TimesWkStrenTmSports3 TimesWkStrenIndivSports3 TimesWkGymnastLifting3 TimesWkBikeDanceHikeYard3), mi
egen TimesWkExercise4 = rowtotal(TimesWkUseGym4 TimesWkWalkExcs4 TimesWkBoardRqtSports4 TimesWkGolfBaseFishSports4 TimesWkStrenTmSports4 TimesWkStrenIndivSports4 TimesWkGymnastLifting4 TimesWkBikeDanceHikeYard4), mi

* HS clubs/athletics variables (wave 1 only)
ren s44a1  frenchClub     /* 44.1  FRENCH CLUB                         */
ren s44a2  germanClub     /* 44.2  GERMAN CLUB                         */
ren s44a3  latinClub      /* 44.3  LATIN CLUB                          */
ren s44a4  spanishClub    /* 44.4  SPANISH CLUB                        */
ren s44a5  bookClub       /* 44.5  BOOK CLUB                           */
ren s44a6  computerClub   /* 44.6  COMPUTER CLUB                       */
ren s44a7  debateTeam     /* 44.7  DEBATE TEAM                         */
ren s44a8  dramaClub      /* 44.8  DRAMA CLUB                          */
ren s44a9  FFAclub        /* 44.9  FUTURE FARMERS                      */
ren s44a10 historyClub    /* 44.10 HISTORY CLUB                        */
ren s44a11 mathClub       /* 44.11 MATH CLUB                           */
ren s44a12 scienceClub    /* 44.12 SCIENCE CLUB                        */
ren s44a13 band           /* 44.13 BAND                                */
ren s44a14 cheerDanceClub /* 44.14 CHEERLEADER/DANCE                   */
ren s44a15 choir          /* 44.15 CHORUS OR CHOIR                     */
ren s44a16 orchestra      /* 44.16 ORCHESTRA                           */
ren s44a17 otherClub      /* 44.17 OTHER CLUB OR ORG                   */
ren s44a18 baseball       /* 44.18 BASEBALL/SOFTBALL                   */
ren s44a19 basketball     /* 44.19 BASKETBALL                          */
ren s44a20 fieldHockey    /* 44.20 FIELD HOCKEY                        */
ren s44a21 football       /* 44.21 FOOTBALL                            */
ren s44a22 hockey         /* 44.22 ICE HOCKEY                          */
ren s44a23 soccer         /* 44.23 SOCCER                              */
ren s44a24 swimming       /* 44.24 SWIMMING                            */
ren s44a25 tennis         /* 44.25 TENNIS                              */
ren s44a26 trackField     /* 44.26 TRACK                               */
ren s44a27 volleyball     /* 44.27 VOLLEYBALL                          */
ren s44a28 wrestling      /* 44.28 WRESTLING                           */
ren s44a29 otherSports    /* 44.29 OTHER SPORT                         */
ren s44a30 newspaper      /* 44.30 NEWSPAPER                           */
ren s44a31 NHSclub        /* 44.31 HONOR SOCIETY                       */
ren s44a32 studentCouncil /* 44.32 STUDENT COUNCIL                     */
ren s44a33 yearbook       /* 44.33 YEARBOOK                            */
ren s44    noClubs        /* 44.   DOES NOT PART. ANY CLUBS,ORGS,TEAMS */

*** Group detailed extracurriculars into broader groups:
generat hobbyClub = frenchClub==1 | germanClub==1 | latinClub==1 | spanishClub==1 | bookClub==1 | computerClub==1 | historyClub==1 | mathClub==1 | scienceClub==1
* studentCouncil (done)
generat yrbookPaper = yearbook==1 | newspaper==1
generat performArts = debateTeam==1 | dramaClub==1 | band==1 | choir==1 | orchestra==1 | cheerDanceClub==1
generat nhs = NHSclub==1
replace otherClub = otherClub==1 | FFAclub==1
* noClubs (done)

generat sports          =                     baseball==1 | basketball==1 | fieldHockey==1 | football==1 | hockey==1 | soccer==1 | swimming==1 | tennis==1 | trackField==1 | volleyball==1 | wrestling==1 | otherSports==1
generat sportsA         = cheerDanceClub==1 | baseball==1 | basketball==1 | fieldHockey==1 | football==1 | hockey==1 | soccer==1 | swimming==1 | tennis==1 | trackField==1 | volleyball==1 | wrestling==1 | otherSports==1
generat indivSports     = swimming==1 | tennis==1 | trackField==1 | wrestling==1 | otherSports==1
generat indivSportsA    = swimming==1 | tennis==1 | trackField==1 | wrestling==1 | otherSports==1
generat teamSports      =                     baseball==1 | basketball==1 | fieldHockey==1 | football==1 | hockey==1 | soccer==1 | volleyball==1
generat teamSportsA     = cheerDanceClub==1 | baseball==1 | basketball==1 | fieldHockey==1 | football==1 | hockey==1 | soccer==1 | volleyball==1
egen    numSportsIncl0  = rowtotal(baseball basketball fieldHockey football hockey soccer swimming tennis trackField volleyball wrestling otherSports)
egen    numSportsAincl0 = rowtotal(cheerDanceClub baseball basketball fieldHockey football hockey soccer swimming tennis trackField volleyball wrestling otherSports)
egen    numSports       = rowtotal(baseball basketball fieldHockey football hockey soccer swimming tennis trackField volleyball wrestling otherSports) if sports==1
egen    numSportsA      = rowtotal(cheerDanceClub baseball basketball fieldHockey football hockey soccer swimming tennis trackField volleyball wrestling otherSports) if sportsA==1
generat multSports      = inrange(numSportsIncl0,2,15)
replace sports          = .n if baseball==.n
replace sportsA         = .n if baseball==.n
replace indivSports     = .n if baseball==.n
replace indivSportsA    = .n if baseball==.n
replace teamSports      = .n if baseball==.n
replace teamSportsA     = .n if baseball==.n
replace numSports       = .n if baseball==.n
replace numSportsA      = .n if baseball==.n
replace multSports      = .n if baseball==.n

count if scid=="080" &  female
count if scid=="080" & !female
sum height1, d

preserve
	tempfile peers
	collapse (count) nPeers=id nPeersHeight=height1 nPeersSports=sports (sum) totSports=sports totSportsA=sportsA totNumSports=numSports totNumSportsIncl0=numSportsIncl0 totNumSportsAincl0=numSportsAincl0 totHeightA=height1 (mean) cheerDanceClub baseball basketball fieldHockey football hockey soccer swimming tennis trackField volleyball wrestling otherSports, by(scid female)
	sum nPeers, d
	sum totHeightA, d
	gen cheerDanceClubA = cheerDanceClub>0
	gen baseballA       = baseball>0
	gen basketballA     = basketball>0
	gen fieldHockeyA    = fieldHockey>0
	gen footballA       = football>0
	gen hockeyA         = hockey>0
	gen soccerA         = soccer>0
	gen swimmingA       = swimming>0
	gen tennisA         = tennis>0
	gen trackFieldA     = trackField>0
	gen volleyballA     = volleyball>0
	gen wrestlingA      = wrestling>0
	gen otherSportsA    = otherSports>0
	egen sportsVariety  = rowtotal(baseballA basketballA fieldHockeyA footballA hockeyA soccerA swimmingA tennisA trackFieldA volleyballA wrestlingA otherSportsA)
	egen sportsVarietyA = rowtotal(cheerDanceClubA baseballA basketballA fieldHockeyA footballA hockeyA soccerA swimmingA tennisA trackFieldA volleyballA wrestlingA otherSportsA)
	drop cheerDanceClubA baseballA basketballA fieldHockeyA footballA hockeyA soccerA swimmingA tennisA trackFieldA volleyballA wrestlingA otherSportsA 
	save `peers', replace
restore

merge m:1 scid female using `peers', keep(match master) nogen
l scid female height1 totHeightA if nPeers<10, sepby(scid female)
l scid female height1 totHeightA sports totSports if scid=="080", sepby(scid female)
replace nPeers               = nPeers             - 1
replace nPeersHeight         = nPeersHeight       - 1
replace nPeersSports         = nPeersSports       - 1
generat totHeight            = totHeightA         - 1*height1
replace totSports            = totSports          - 1*sports
replace totSportsA           = totSportsA         - 1*sportsA
replace totNumSports         = totNumSports       - 1*numSports
replace totNumSportsA        = totNumSportsA      - 1*numSportsA
replace totNumSportsIncl0    = totNumSportsIncl0  - 1*numSportsIncl0
replace totNumSportsAincl0   = totNumSportsAincl0 - 1*numSportsAincl0
generat peerheight           = totHeight          / nPeersHeight
generat peerFracSports       = totSports          / nPeersSports
generat peerFracSportsA      = totSportsA         / nPeersSports
generat peerNumSports        = totNumSports       / nPeersSports
generat peerNumSportsA       = totNumSportsA      / nPeersSports
generat peerNumSportsIncl0   = totNumSportsIncl0  / nPeersSports
generat peerNumSportsAincl0  = totNumSportsAincl0 / nPeersSports

preserve
	tempfile peersPVT
	qui tab hgcMoth, gen(momdum)
	replace momdum5 = . if momdum6==1
	collapse (count) nPeersPVT=ahpvt_std nMomCol=momdum5 (sum) totPVT=ahpvt_std totMomCol=momCol, by(scid)
	save `peersPVT', replace
restore

merge m:1 scid using `peersPVT', keep(match master) nogen
l scid female height1 totHeightA momCol totMomCol ahpvt_std totPVT if nPeers<10, sepby(scid female)
l scid female height1 totHeightA momCol totMomCol ahpvt_std totPVT sports totSports if scid=="080", sepby(scid female)
replace nPeersPVT  = nPeersPVT - 1
replace totPVT     = totPVT    - 1*ahpvt_std
generat peerPVT    = totPVT    / nPeersPVT
replace nMomCol    = nMomCol   - 1
replace totMomCol  = totMomCol - 1*momCol
generat peerMomCol = totMomCol / nMomCol


l scid female sports totSports peerFracSports if scid=="080", sepby(scid female)
l scid female height1 totHeightA peerheight ahpvt_std totPVT peerPVT if scid=="080", sepby(scid female)

tab id if mi(scid) & !female


* Civic engagement variables
rename  h4da26 hrsCommSvcPastYr4
recode  hrsCommSvcPastYr4 (1 = 0) (2 = 10) (3 = 30) (4 = 60) (5 = 120) (6 = 200)
rename  h4da27 oftenVoteLocElection4
recode  oftenVoteLocElection4 (1 2 = 0) (3 4 = 1)
rename  h4da28 liberality4
recode  liberality4 (1 = -2) (2 = -1) (3 = 0) (4 = 1) (5 = 2)


* Substance abuse / risky behavior variables
generat everRegularlySmoked4 = h4to3==1 // code valid skips as 0's since these people don't smoke
replace everRegularlySmoked4 = .n if h4to3==.n
replace everRegularlySmoked4 = .d if h4to3==.d
replace everRegularlySmoked4 = .r if h4to3==.r
drop h4to3

rename  h4to4 ageFirstRegularlySmoked4
rename  h4to5 numDaysSmokeRecently4
recode  numDaysSmokeRecently4 (.v = 0)

rename  h4to33 everDrinkAlc4
rename  h4to34 ageFirstDrinkAlc4
rename  h4to35 numDaysDrinkAlcPastYr4
recode  numDaysDrinkAlcPastYr4 (.v = 0) (2 = 7) (3 = 25) (4 = 75) (5 = 200) (6 = 350)
rename  h4to38 numDaysDrunkPastYr4
recode  numDaysDrunkPastYr4 (.v = 0) (2 = 7) (3 = 25) (4 = 75) (5 = 200) (6 = 350)
rename  h4to46 alcEverInterfereWork4
recode  alcEverInterfereWork4 (.v = 0) (2 = 1) (5 = .)
rename  h4to47 alcEverRisky4
recode  alcEverRisky4 (.v = 0) (2 = 1) (5 = .)
rename  h4to48 alcEverLegalProbs4
recode  alcEverLegalProbs4 (.v = 0) (2 = 1) (5 = .)

gen     heavyDrunk4 = inrange(numDaysDrunkPastYr4,25,.) if !mi(numDaysDrunkPastYr4)

generat everUsedIllegalDrugs4 = h4to65a==1 | h4to65b==1 | h4to65c==1 | h4to65d==1 | h4to65e==1
replace everUsedIllegalDrugs4 = .r if h4to65a==1 | h4to65b==.r | h4to65c==.r | h4to65d==.r | h4to65e==.r
replace everUsedIllegalDrugs4 = .d if h4to65a==1 | h4to65b==.d | h4to65c==.d | h4to65d==.d | h4to65e==.d

rename  h4to63 everAbusedRxDrugs4

rename  h4cj1 everArrested4

rename  h4tr1 everMarried4
replace everMarried4 = 1 if inrange(everMarried4,1,5)

rename h4tr2 numPartners4
genera everCohabitated4 = numPartners4>0

* Education variables
lab def vlmajor 1 "Agriculture, Agriculture Operations, and Related Sciences" 3 "Natural Resources and Conservation" 4 "Architecture and Related Services" 5 "Area, Ethnic, Cultural, and Gender Studies" 9 "Communication, Journalism, and Related Programs" 10 "Communications Technologies/Technicians and Support Services" 11 "Computer and Information Sciences and Support Services" 12 "Personal and Culinary Services" 13 "Education" 14 "Engineering" 15 "Engineering Technologies/Technicians" 16 "Foreign Languages, Literatures, and Linguistics" 19 "Family and Consumer Sciences/Human Sciences" 21 "Technology Education/Industrial Arts" 22 "Legal Professions and Studies" 23 "English Language and Literature/Letters" 24 "Liberal Arts and Sciences, General Studies and Humanities" 25 "Library Science" 26 "Biological and Biomedical Sciences" 27 "Mathematics and Statistics" 28 "Reserve Officer Training Corps (JROTC, ROTC)" 29 "Military Technologies" 30 "Multi/Interdisciplinary Studies" 31 "Parks, Recreation, Leisure, and Fitness Studies" 32 "Basic Skills" 33 "Citizenship Activities" 34 "Health-Related Knowledge and Skills" 35 "Interpersonal and Social Skills" 36 "Leisure and Recreational Activities" 37 "Personal Awareness and Self-Improvement" 38 "Philosophy and Religious Studies" 39 "Theology and Religious Vocations" 40 "Physical Sciences" 41 "Science Technologies/Technicians" 42 "Psychology" 43 "Security and Protective Services" 44 "Public Administration and Social Service Professions" 45 "Social Sciences" 46 "Construction Trades" 47 "Mechanic and Repair Technologies/Technicians" 48 "Precision Production" 49 "Transportation and Materials Moving" 50 "Visual and Performing Arts" 51 "Health Professions and Related Clinical Sciences" 52 "Business, Management, Marketing, and Related Support Services" 53 "High School/Secondary Diplomas and Certificates" 54 "History" 60 "Dental/Medical Residency Programs"
* Economics major codes:
* 45.06
* 45.0601
* 45.0602
* 45.0603
* 45.0604
* 45.0605
* 45.0699
* recode major1 (45.06 =
rename  h3ed16 major1
rename  h3ed17 major2
generat major1_2dig = round(major1)
generat major2_2dig = round(major2)
generat stemMaj = inlist(major1_2dig,14,26,27,40) | ///
			      inlist(major2_2dig,14,26,27,40) | ///
			      inlist(major1,1.0308,1.0901,1.0902,1.0903,1.0904,1.0905,1.0906,1.0907,1.0999,1.1001,1.1002,1.1099,1.1101,1.1102,1.1103,1.1104,1.1105,1.1106,1.1199,1.1201,1.1202,1.1203,1.1299,3.0101,3.0103,3.0104,3.0199,3.0205,3.0502,3.0508,3.0509,3.0601,4.0902,9.0702,10.0304,11.0101,11.0102,11.0103,11.0104,11.0199,11.0201,11.0202,11.0203,11.0299,11.0301,11.0401,11.0501,11.0701,11.0801,11.0802,11.0803,11.0804,11.0899,11.0901,11.1001,11.1002,11.1003,11.1004,11.1005,11.1006,11.1099,13.0501,13.0601,13.0603,15,15.0101,15.0201,15.0303,15.0304,15.0305,15.0306,15.0399,15.0401,15.0403,15.0404,15.0405,15.0406,15.0499,15.0501,15.0503,15.0505,15.0506,15.0507,15.0508,15.0599,15.0607,15.0611,15.0612,15.0613,15.0614,15.0615,15.0616,15.0699,15.0701,15.0702,15.0703,15.0704,15.0799,15.0801,15.0803,15.0805,15.0899,15.0901,15.0903,15.0999,15.1001,15.1102,15.1103,15.1199,15.1201,15.1202,15.1203,15.1204,15.1299,15.1301,15.1302,15.1303,15.1304,15.1305,15.1306,15.1399,15.1401,15.1501,15.1502,15.1503,15.1599,15.1601,15.9999,28.0501,28.0502,28.0505,29.0201,29.0202,29.0203,29.0204,29.0205,29.0206,29.0207,29.0299,29.0301,29.0302,29.0303,29.0304,29.0305,29.0306,29.0307,29.0399,29.0401,29.0402,29.0403,29.0404,29.0405,29.0406,29.0407,29.0408,29.0409,29.0499,29.9999,30.0101,30.0601,30.0801,30.1001,30.1701,30.1801,30.1901,30.2501,30.2701,30.3001,30.3101,30.3201,30.3301,41,41.0101,41.0204,41.0205,41.0299,41.0301,41.0303,41.0399,41.9999,42.2701,42.2702,42.2703,42.2704,42.2705,42.2706,42.2707,42.2708,42.2709,42.2799,43.0106,43.0116,45.0301,45.0603,45.0702,49.0101,51.1002,51.1005,51.1401,51.2003,51.2004,51.2005,51.2006,51.2007,51.2009,51.201,51.2202,51.2205,51.2502,51.2503,51.2504,51.2505,51.2506,51.251,51.2511,51.2706,52.1301,52.1302,52.1304,52.1399) | ///
			      inlist(major2,1.0308,1.0901,1.0902,1.0903,1.0904,1.0905,1.0906,1.0907,1.0999,1.1001,1.1002,1.1099,1.1101,1.1102,1.1103,1.1104,1.1105,1.1106,1.1199,1.1201,1.1202,1.1203,1.1299,3.0101,3.0103,3.0104,3.0199,3.0205,3.0502,3.0508,3.0509,3.0601,4.0902,9.0702,10.0304,11.0101,11.0102,11.0103,11.0104,11.0199,11.0201,11.0202,11.0203,11.0299,11.0301,11.0401,11.0501,11.0701,11.0801,11.0802,11.0803,11.0804,11.0899,11.0901,11.1001,11.1002,11.1003,11.1004,11.1005,11.1006,11.1099,13.0501,13.0601,13.0603,15,15.0101,15.0201,15.0303,15.0304,15.0305,15.0306,15.0399,15.0401,15.0403,15.0404,15.0405,15.0406,15.0499,15.0501,15.0503,15.0505,15.0506,15.0507,15.0508,15.0599,15.0607,15.0611,15.0612,15.0613,15.0614,15.0615,15.0616,15.0699,15.0701,15.0702,15.0703,15.0704,15.0799,15.0801,15.0803,15.0805,15.0899,15.0901,15.0903,15.0999,15.1001,15.1102,15.1103,15.1199,15.1201,15.1202,15.1203,15.1204,15.1299,15.1301,15.1302,15.1303,15.1304,15.1305,15.1306,15.1399,15.1401,15.1501,15.1502,15.1503,15.1599,15.1601,15.9999,28.0501,28.0502,28.0505,29.0201,29.0202,29.0203,29.0204,29.0205,29.0206,29.0207,29.0299,29.0301,29.0302,29.0303,29.0304,29.0305,29.0306,29.0307,29.0399,29.0401,29.0402,29.0403,29.0404,29.0405,29.0406,29.0407,29.0408,29.0409,29.0499,29.9999,30.0101,30.0601,30.0801,30.1001,30.1701,30.1801,30.1901,30.2501,30.2701,30.3001,30.3101,30.3201,30.3301,41,41.0101,41.0204,41.0205,41.0299,41.0301,41.0303,41.0399,41.9999,42.2701,42.2702,42.2703,42.2704,42.2705,42.2706,42.2707,42.2708,42.2709,42.2799,43.0106,43.0116,45.0301,45.0603,45.0702,49.0101,51.1002,51.1005,51.1401,51.2003,51.2004,51.2005,51.2006,51.2007,51.2009,51.201,51.2202,51.2205,51.2502,51.2503,51.2504,51.2505,51.2506,51.251,51.2511,51.2706,52.1301,52.1302,52.1304,52.1399)
generat gradHS4 = inlist(h4ed1,1,2,3) if !mi(h4ed1)
replace gradHS4 = . if mi(iyear4)
generat attCol4 = inrange(h4ed2,6,13) if !mi(h4ed2) // i.e. this is defined as "enrolled in 4-year college"
generat yrsSchool = h4ed2
recode h4ed2 (1 2 = 1) (3 = 2) (4 5 6 = 3) (7 8 = 4) (9 10 11 12 13 = 5)
recode  yrsSchool  (1 = 6) (2 = 10.5) (3 = 12) (4 5 = 13) (6 = 14) (7 = 16) (8 = 17) (9 = 18) (10 = 19) (11 12 13 = 20) (98 = .d)
rename  h4ed2  hgc4
lab def vlhgc 1 "HS Dropout" 2 "HS grad"  3 "Some college"  4 "College graduate" 5 "Advanced degree"
lab val hgc4 vlhgc
replace hgc4 = . if mi(iyear4)
recode  h4ed3a (2 3 5 = 2) (4 = 3) (6 = 4) (7 8 = 5)
rename  h4ed3a highDeg4
replace highDeg4 = . if mi(iyear4)
recode  h4ed4a (9997  = .v) (9998 = .d)
rename  h4ed4a yrGradHighDeg4
replace yrGradHighDeg4 = . if mi(iyear4)
recode  h4ed6  (6 = .r) (8 = .d)
rename  h4ed6  currEnrolled4
replace currEnrolled4 = . if mi(iyear4)

generat grad4yr3 = (h3ed5==1 | h3ed6==1 | h3ed7==1 | h3ed8==1) if !mi(h3ed5) & !mi(h3ed6) & !mi(h3ed7) & !mi(h3ed8)
generat grad4yr4 = inlist(highDeg4,3,4,5) if !mi(highDeg4)
lab var grad4yr4 "Graduated college (or higher)"

generat grad4yrCondlAttCol4 = inlist(highDeg4,3,4,5) if attCol4==1
lab var grad4yrCondlAttCol4 "Graduated college (or higher)"

lab def vlhighdeg 1 "HS diploma or less" 2 "Some college" 3 "BA" 4 "MA" 5 "PhD/Prof"
lab val highDeg4 vlhighdeg

gen advDeg4 = inlist(highDeg4,4,5)


* Labor market variables (waves 3 and 4, but wave 4 is likely to be most useful)
generat inLF4 = (h4mi3==1 | inlist(h4lm14,1,3,5) | h4lm11==1)
generat everMilitary = h4mi1==1
generat currMilitary = h4mi3==1
drop h4mi3 h4lm14 h4lm11

rename  h4lm5   ageEnterLF
rename  h3lm15m mnthStartCurrJob3
rename  h3lm15y yearStartCurrJob3
generat startDateCurrJob3 = ym(yearStartCurrJob3,mnthStartCurrJob3)
generat tenure3 = intvw3 - startDateCurrJob3
replace tenure3 = 0 if tenure3<0
replace tenure3 = tenure3/12
rename  h4lm15m mnthStartCurrJob4
rename  h4lm15y yearStartCurrJob4
generat startDateCurrJob4 = ym(yearStartCurrJob4,mnthStartCurrJob4)
generat tenure4 = intvw4 - startDateCurrJob4
replace tenure4 = 0 if tenure4<0
replace tenure4 = tenure4/12

rename h4lm19  hrsCurrJob4
rename h4lm8   firstOcc
rename h3lm26c occ3
rename h4lm18  occ4
rename h3ec4   earn3
rename h3ec5   earnGuess3
rename h4ec2   earn4
rename h4ec3   earnGuess4

codebook earn4 if female
mdesc    earn4 if female
tab      earn4 if female, mi

tab earnGuess3, mi
recode earnGuess3 (1 = 5000) (2 = 12500) (3 = 17500) (4 = 25000) (5 = 35000) (6 = 45000) (7 = 62500) (8 = 100000) (96 = .r) (97 = .v) (98 = .d)
replace earn3 = earnGuess3 if earn3==.d
tab earnGuess4, mi
recode earnGuess4 (1 = 2500) (2 = 7500) (3 = 12500) (4 = 17500) (5 = 22500) (6 = 27500) (7 = 35000) (8 = 45000) (9 = 62500) (10 = 87500) (11 = 125000) (12 = 200000) (96 = .r) (97 = .v) (98 = .d)
replace earn4 = earnGuess4 if earn4==.d
codebook earn4
mdesc earn4

egen earnCutHi = pctile(earn3), p(99) by(female)
egen earnCutLo = pctile(earn3), p(5)  by(female)
gen  earnCodedFlag3  = (earn3>=earnCutHi | earn3<=earnCutLo) & ~mi(earn3) & earn3>0
replace earn3  = earnCutHi if earn3>=earnCutHi & ~mi(earn3)
replace earn3  = earnCutLo if earn3<=earnCutLo & ~mi(earn3) & earn3>0
drop earnCutHi earnCutLo

egen earnCutHi = pctile(earn4), p(99) by(female)
egen earnCutLo = pctile(earn4), p(5)  by(female)
gen  earnCodedFlag4  = (earn4>=earnCutHi | earn4<=earnCutLo) & ~mi(earn4) & earn4>0
replace earn4  = earnCutHi if earn4>=earnCutHi & ~mi(earn4)
replace earn4  = earnCutLo if earn4<=earnCutLo & ~mi(earn4) & earn4>0

ren h3lm16 hrsCurrJob3

gen perCurrjob3    = h3lm17
gen hrlyWage3      = h3lm18
gen dailyWage3     = h3lm19/(hrsCurrJob3/5)
gen weeklyWage3    = h3lm20/hrsCurrJob3
gen biweeklyWage3  = h3lm21/(2*hrsCurrJob3)
gen bimonthlyWage3 = h3lm22/(2*hrsCurrJob3)
gen monthlyWage3   = h3lm23/(4*hrsCurrJob3)
drop h3lm17 h3lm18 h3lm19 h3lm20 h3lm21 h3lm22 h3lm23

replace hrlyWage3 = weeklyWage3    if mi(hrlyWage3) & ~mi(weeklyWage3   )
replace hrlyWage3 = biweeklyWage3  if mi(hrlyWage3) & ~mi(biweeklyWage3 )
replace hrlyWage3 = monthlyWage3   if mi(hrlyWage3) & ~mi(monthlyWage3  )
replace hrlyWage3 = bimonthlyWage3 if mi(hrlyWage3) & ~mi(bimonthlyWage3)
replace hrlyWage3 = dailyWage3     if mi(hrlyWage3) & ~mi(dailyWage3    )
replace hrlyWage3 = . if hrlyWage3==0

gen annualHours3 = hrsCurrJob3*50
gen annualHours4 = hrsCurrJob4*50
gen hrlyWage2_3 = earn3/annualHours3
replace hrlyWage2_3 = . if hrlyWage2_3==0
gen hrlyWage2_4 = earn4/annualHours4
replace hrlyWage2_4 = . if hrlyWage2_4==0

gen empPT3 = inrange(hrsCurrJob3,0.01,34) if !mi(hrsCurrJob3)
gen empPT4 = inrange(hrsCurrJob4,0.01,34) if !mi(hrsCurrJob4)
gen empFT3 = inrange(hrsCurrJob3,34.01,.) if !mi(hrsCurrJob3)
gen empFT4 = inrange(hrsCurrJob4,34.01,.) if !mi(hrsCurrJob4)

* Convert earnings variables to 2008 constant dollars to be 2008, 106.293, 2001:90.647
* multiplier to turn 2001 wages into 2008 wages: 1.1726036
* multiplier to turn 2002 wages into 2008 wages: 1.1539789
replace hrlyWage2_3 = hrlyWage2_3*1.1726036 if iyear3==2001
replace hrlyWage3   = hrlyWage3  *1.1726036 if iyear3==2001
replace hrlyWage2_3 = hrlyWage2_3*1.1539789 if iyear3==2002
replace hrlyWage3   = hrlyWage3  *1.1539789 if iyear3==2002
replace earn3       = earn3      *1.1726036 if iyear3==2001
replace earn3       = earn3      *1.1539789 if iyear3==2002

genera lnWage3 = log(hrlyWage2_3)
lab var lnWage3 "Log annual earnings / annual hours worked"
genera lnWage4 = log(hrlyWage2_4)
lab var lnWage4 "Log annual earnings / annual hours worked"

genera lnEarn3 = log(earn3)
lab var lnEarn3 "Log earnings"
genera lnEarn4 = log(earn4)
lab var lnEarn4 "Log earnings"

* Labor Market Histories
generat work95  = (h3lm55==1)
replace work95  = 2 if h3lm58==1
generat work96  = (h3lm59==1)
replace work96  = 2 if h3lm62==1
generat work97  = (h3lm63==1)
replace work97  = 2 if h3lm66==1
generat work98  = (h3lm67==1)
replace work98  = 2 if h3lm70==1
generat work99  = (h3lm71==1)
replace work99  = 2 if h3lm74==1
generat work100 = (h3lm75==1)
replace work100 = 2 if h3lm78==1
generat work101 = (h3lm79==1)
replace work101 = 2 if h3lm82==1

gen yrsFull3 = (work95 ==2) + (work96 ==2) + (work97 ==2) + ( work98 ==2) + (work99 ==2) + (work100 ==2) + (work101 ==2)
gen yrsPart3 = (work95 ==1) + (work96 ==1) + (work97 ==1) + ( work98 ==1) + (work99 ==1) + (work100 ==1) + (work101 ==1)

* Drop earnings for people who worked only part-time or not at all in year prior to the interview
replace hrlyWage2_3 = . if work101==0 & iyear3==2002
replace hrlyWage2_3 = . if work100==0 & iyear3==2001



* Merge occupation characteristics
merge m:1 occ3     using crosswalk_soft13, keepusing(hard soft) keep(match master) nogen
ren hard hard3
ren soft soft3
merge m:1 occ4     using crosswalk_soft13, keepusing(hard soft) keep(match master) nogen
ren hard hard4
ren soft soft4
merge m:1 firstOcc using crosswalk_soft13, keepusing(hard soft) keep(match master) nogen
ren hard firstOccHard4
ren soft firstOccSoft4
ren firstOcc firstOcc4


* Drop unnecessary variables
drop work95 work96 work97 work98 work99 work100 work101 perCurrjob3 dailyWage3 weeklyWage3 biweeklyWage3 bimonthlyWage3 monthlyWage3 startDateCurr* h4lm20 mnthStartCurr* yearStartCurr* h4ed1 h3lm25 h3lm26a h3lm26b h3lm55 h3lm58 h3lm59 h3lm62 h3lm63 h3lm66 h3lm67 h3lm70 h3lm71 h3lm74 h3lm75 h3lm78 h3lm79 h3lm82 h3ed5 h3ed6 h3ed7 h3ed8

* Fix weights
replace gswgt3 = gswgt3_2
replace gswgt4 = gswgt4_2

* Reshape long
local varlist imonth iday iyear intvw age ageD height heightMeas weightLbs weightLbsMeas gradHS hgc highDeg yrGradHighDeg currEnrolled occ earn earnGuess lnEarn lnWage hrlyWage hrlyWage2_ hrsCurrJob grad4yr soft hard earnCodedFlag gswgt tenure annualHours firstOccHard firstOccSoft firstOcc everRegularlySmoked ageFirstRegularlySmoked numDaysSmokeRecently everDrinkAlc ageFirstDrinkAlc numDaysDrinkAlcPastYr numDaysDrunkPastYr alcEverInterfereWork alcEverRisky alcEverLegalProbs everUsedIllegalDrugs everAbusedRxDrugs everArrested everMarried hrsCommSvcPastYr oftenVoteLocElection liberality advDeg attCol inLF empPT empFT bmi overweight obese ovrwgtObese grad4yrCondlAttCol numPartners everCohabitated TimesWkExercise HrsVidGamesPastWk
foreach v of local varlist {
	capture confirm variable `v'4
	if !_rc {
		local l`v' : variable label `v'4
	}
}
 * foreach var of local varlist {
	* levelsof `var'4, local(`var'_levels)       /* create local list of all values of `var' */
	* foreach val of local `var'_levels {       /* loop over all values in local list `var'_levels */
		* local `var'vl`val' : label `var' `val'    /* create macro that contains label for each value */
	* }
* }

reshape long `varlist', i(id) j(wave)
sort id wave

gen regExercise = inrange(TimesWkExercise,3,.)   if !mi(TimesWkExercise)
gen videoGamer  = inrange(HrsVidGamesPastWk,5,.) if !mi(HrsVidGamesPastWk)

/* apply the variable & value labels as variable labels */
/* variables are in form answeryear incyear */
foreach var of local varlist {                 /* loop over list "inc answer" */
	lab var `var' "`l`var''"
}

* Convert height to cm and compute z-scores and percentiles by age
gen ageMosD = ageD*12
gen heightCm = height*2.54
generat ageCat = .
replace ageCat = 1   if inrange(ageMosD,24   ,24.5 ) & female==0
replace ageCat = 2   if inrange(ageMosD,24.5 ,25.5 ) & female==0
replace ageCat = 3   if inrange(ageMosD,25.5 ,26.5 ) & female==0
replace ageCat = 4   if inrange(ageMosD,26.5 ,27.5 ) & female==0
replace ageCat = 5   if inrange(ageMosD,27.5 ,28.5 ) & female==0
replace ageCat = 6   if inrange(ageMosD,28.5 ,29.5 ) & female==0
replace ageCat = 7   if inrange(ageMosD,29.5 ,30.5 ) & female==0
replace ageCat = 8   if inrange(ageMosD,30.5 ,31.5 ) & female==0
replace ageCat = 9   if inrange(ageMosD,31.5 ,32.5 ) & female==0
replace ageCat = 10  if inrange(ageMosD,32.5 ,33.5 ) & female==0
replace ageCat = 11  if inrange(ageMosD,33.5 ,34.5 ) & female==0
replace ageCat = 12  if inrange(ageMosD,34.5 ,35.5 ) & female==0
replace ageCat = 13  if inrange(ageMosD,35.5 ,36.5 ) & female==0
replace ageCat = 14  if inrange(ageMosD,36.5 ,37.5 ) & female==0
replace ageCat = 15  if inrange(ageMosD,37.5 ,38.5 ) & female==0
replace ageCat = 16  if inrange(ageMosD,38.5 ,39.5 ) & female==0
replace ageCat = 17  if inrange(ageMosD,39.5 ,40.5 ) & female==0
replace ageCat = 18  if inrange(ageMosD,40.5 ,41.5 ) & female==0
replace ageCat = 19  if inrange(ageMosD,41.5 ,42.5 ) & female==0
replace ageCat = 20  if inrange(ageMosD,42.5 ,43.5 ) & female==0
replace ageCat = 21  if inrange(ageMosD,43.5 ,44.5 ) & female==0
replace ageCat = 22  if inrange(ageMosD,44.5 ,45.5 ) & female==0
replace ageCat = 23  if inrange(ageMosD,45.5 ,46.5 ) & female==0
replace ageCat = 24  if inrange(ageMosD,46.5 ,47.5 ) & female==0
replace ageCat = 25  if inrange(ageMosD,47.5 ,48.5 ) & female==0
replace ageCat = 26  if inrange(ageMosD,48.5 ,49.5 ) & female==0
replace ageCat = 27  if inrange(ageMosD,49.5 ,50.5 ) & female==0
replace ageCat = 28  if inrange(ageMosD,50.5 ,51.5 ) & female==0
replace ageCat = 29  if inrange(ageMosD,51.5 ,52.5 ) & female==0
replace ageCat = 30  if inrange(ageMosD,52.5 ,53.5 ) & female==0
replace ageCat = 31  if inrange(ageMosD,53.5 ,54.5 ) & female==0
replace ageCat = 32  if inrange(ageMosD,54.5 ,55.5 ) & female==0
replace ageCat = 33  if inrange(ageMosD,55.5 ,56.5 ) & female==0
replace ageCat = 34  if inrange(ageMosD,56.5 ,57.5 ) & female==0
replace ageCat = 35  if inrange(ageMosD,57.5 ,58.5 ) & female==0
replace ageCat = 36  if inrange(ageMosD,58.5 ,59.5 ) & female==0
replace ageCat = 37  if inrange(ageMosD,59.5 ,60.5 ) & female==0
replace ageCat = 38  if inrange(ageMosD,60.5 ,61.5 ) & female==0
replace ageCat = 39  if inrange(ageMosD,61.5 ,62.5 ) & female==0
replace ageCat = 40  if inrange(ageMosD,62.5 ,63.5 ) & female==0
replace ageCat = 41  if inrange(ageMosD,63.5 ,64.5 ) & female==0
replace ageCat = 42  if inrange(ageMosD,64.5 ,65.5 ) & female==0
replace ageCat = 43  if inrange(ageMosD,65.5 ,66.5 ) & female==0
replace ageCat = 44  if inrange(ageMosD,66.5 ,67.5 ) & female==0
replace ageCat = 45  if inrange(ageMosD,67.5 ,68.5 ) & female==0
replace ageCat = 46  if inrange(ageMosD,68.5 ,69.5 ) & female==0
replace ageCat = 47  if inrange(ageMosD,69.5 ,70.5 ) & female==0
replace ageCat = 48  if inrange(ageMosD,70.5 ,71.5 ) & female==0
replace ageCat = 49  if inrange(ageMosD,71.5 ,72.5 ) & female==0
replace ageCat = 50  if inrange(ageMosD,72.5 ,73.5 ) & female==0
replace ageCat = 51  if inrange(ageMosD,73.5 ,74.5 ) & female==0
replace ageCat = 52  if inrange(ageMosD,74.5 ,75.5 ) & female==0
replace ageCat = 53  if inrange(ageMosD,75.5 ,76.5 ) & female==0
replace ageCat = 54  if inrange(ageMosD,76.5 ,77.5 ) & female==0
replace ageCat = 55  if inrange(ageMosD,77.5 ,78.5 ) & female==0
replace ageCat = 56  if inrange(ageMosD,78.5 ,79.5 ) & female==0
replace ageCat = 57  if inrange(ageMosD,79.5 ,80.5 ) & female==0
replace ageCat = 58  if inrange(ageMosD,80.5 ,81.5 ) & female==0
replace ageCat = 59  if inrange(ageMosD,81.5 ,82.5 ) & female==0
replace ageCat = 60  if inrange(ageMosD,82.5 ,83.5 ) & female==0
replace ageCat = 61  if inrange(ageMosD,83.5 ,84.5 ) & female==0
replace ageCat = 62  if inrange(ageMosD,84.5 ,85.5 ) & female==0
replace ageCat = 63  if inrange(ageMosD,85.5 ,86.5 ) & female==0
replace ageCat = 64  if inrange(ageMosD,86.5 ,87.5 ) & female==0
replace ageCat = 65  if inrange(ageMosD,87.5 ,88.5 ) & female==0
replace ageCat = 66  if inrange(ageMosD,88.5 ,89.5 ) & female==0
replace ageCat = 67  if inrange(ageMosD,89.5 ,90.5 ) & female==0
replace ageCat = 68  if inrange(ageMosD,90.5 ,91.5 ) & female==0
replace ageCat = 69  if inrange(ageMosD,91.5 ,92.5 ) & female==0
replace ageCat = 70  if inrange(ageMosD,92.5 ,93.5 ) & female==0
replace ageCat = 71  if inrange(ageMosD,93.5 ,94.5 ) & female==0
replace ageCat = 72  if inrange(ageMosD,94.5 ,95.5 ) & female==0
replace ageCat = 73  if inrange(ageMosD,95.5 ,96.5 ) & female==0
replace ageCat = 74  if inrange(ageMosD,96.5 ,97.5 ) & female==0
replace ageCat = 75  if inrange(ageMosD,97.5 ,98.5 ) & female==0
replace ageCat = 76  if inrange(ageMosD,98.5 ,99.5 ) & female==0
replace ageCat = 77  if inrange(ageMosD,99.5 ,100.5) & female==0
replace ageCat = 78  if inrange(ageMosD,100.5,101.5) & female==0
replace ageCat = 79  if inrange(ageMosD,101.5,102.5) & female==0
replace ageCat = 80  if inrange(ageMosD,102.5,103.5) & female==0
replace ageCat = 81  if inrange(ageMosD,103.5,104.5) & female==0
replace ageCat = 82  if inrange(ageMosD,104.5,105.5) & female==0
replace ageCat = 83  if inrange(ageMosD,105.5,106.5) & female==0
replace ageCat = 84  if inrange(ageMosD,106.5,107.5) & female==0
replace ageCat = 85  if inrange(ageMosD,107.5,108.5) & female==0
replace ageCat = 86  if inrange(ageMosD,108.5,109.5) & female==0
replace ageCat = 87  if inrange(ageMosD,109.5,110.5) & female==0
replace ageCat = 88  if inrange(ageMosD,110.5,111.5) & female==0
replace ageCat = 89  if inrange(ageMosD,111.5,112.5) & female==0
replace ageCat = 90  if inrange(ageMosD,112.5,113.5) & female==0
replace ageCat = 91  if inrange(ageMosD,113.5,114.5) & female==0
replace ageCat = 92  if inrange(ageMosD,114.5,115.5) & female==0
replace ageCat = 93  if inrange(ageMosD,115.5,116.5) & female==0
replace ageCat = 94  if inrange(ageMosD,116.5,117.5) & female==0
replace ageCat = 95  if inrange(ageMosD,117.5,118.5) & female==0
replace ageCat = 96  if inrange(ageMosD,118.5,119.5) & female==0
replace ageCat = 97  if inrange(ageMosD,119.5,120.5) & female==0
replace ageCat = 98  if inrange(ageMosD,120.5,121.5) & female==0
replace ageCat = 99  if inrange(ageMosD,121.5,122.5) & female==0
replace ageCat = 100 if inrange(ageMosD,122.5,123.5) & female==0
replace ageCat = 101 if inrange(ageMosD,123.5,124.5) & female==0
replace ageCat = 102 if inrange(ageMosD,124.5,125.5) & female==0
replace ageCat = 103 if inrange(ageMosD,125.5,126.5) & female==0
replace ageCat = 104 if inrange(ageMosD,126.5,127.5) & female==0
replace ageCat = 105 if inrange(ageMosD,127.5,128.5) & female==0
replace ageCat = 106 if inrange(ageMosD,128.5,129.5) & female==0
replace ageCat = 107 if inrange(ageMosD,129.5,130.5) & female==0
replace ageCat = 108 if inrange(ageMosD,130.5,131.5) & female==0
replace ageCat = 109 if inrange(ageMosD,131.5,132.5) & female==0
replace ageCat = 110 if inrange(ageMosD,132.5,133.5) & female==0
replace ageCat = 111 if inrange(ageMosD,133.5,134.5) & female==0
replace ageCat = 112 if inrange(ageMosD,134.5,135.5) & female==0
replace ageCat = 113 if inrange(ageMosD,135.5,136.5) & female==0
replace ageCat = 114 if inrange(ageMosD,136.5,137.5) & female==0
replace ageCat = 115 if inrange(ageMosD,137.5,138.5) & female==0
replace ageCat = 116 if inrange(ageMosD,138.5,139.5) & female==0
replace ageCat = 117 if inrange(ageMosD,139.5,140.5) & female==0
replace ageCat = 118 if inrange(ageMosD,140.5,141.5) & female==0
replace ageCat = 119 if inrange(ageMosD,141.5,142.5) & female==0
replace ageCat = 120 if inrange(ageMosD,142.5,143.5) & female==0
replace ageCat = 121 if inrange(ageMosD,143.5,144.5) & female==0
replace ageCat = 122 if inrange(ageMosD,144.5,145.5) & female==0
replace ageCat = 123 if inrange(ageMosD,145.5,146.5) & female==0
replace ageCat = 124 if inrange(ageMosD,146.5,147.5) & female==0
replace ageCat = 125 if inrange(ageMosD,147.5,148.5) & female==0
replace ageCat = 126 if inrange(ageMosD,148.5,149.5) & female==0
replace ageCat = 127 if inrange(ageMosD,149.5,150.5) & female==0
replace ageCat = 128 if inrange(ageMosD,150.5,151.5) & female==0
replace ageCat = 129 if inrange(ageMosD,151.5,152.5) & female==0
replace ageCat = 130 if inrange(ageMosD,152.5,153.5) & female==0
replace ageCat = 131 if inrange(ageMosD,153.5,154.5) & female==0
replace ageCat = 132 if inrange(ageMosD,154.5,155.5) & female==0
replace ageCat = 133 if inrange(ageMosD,155.5,156.5) & female==0
replace ageCat = 134 if inrange(ageMosD,156.5,157.5) & female==0
replace ageCat = 135 if inrange(ageMosD,157.5,158.5) & female==0
replace ageCat = 136 if inrange(ageMosD,158.5,159.5) & female==0
replace ageCat = 137 if inrange(ageMosD,159.5,160.5) & female==0
replace ageCat = 138 if inrange(ageMosD,160.5,161.5) & female==0
replace ageCat = 139 if inrange(ageMosD,161.5,162.5) & female==0
replace ageCat = 140 if inrange(ageMosD,162.5,163.5) & female==0
replace ageCat = 141 if inrange(ageMosD,163.5,164.5) & female==0
replace ageCat = 142 if inrange(ageMosD,164.5,165.5) & female==0
replace ageCat = 143 if inrange(ageMosD,165.5,166.5) & female==0
replace ageCat = 144 if inrange(ageMosD,166.5,167.5) & female==0
replace ageCat = 145 if inrange(ageMosD,167.5,168.5) & female==0
replace ageCat = 146 if inrange(ageMosD,168.5,169.5) & female==0
replace ageCat = 147 if inrange(ageMosD,169.5,170.5) & female==0
replace ageCat = 148 if inrange(ageMosD,170.5,171.5) & female==0
replace ageCat = 149 if inrange(ageMosD,171.5,172.5) & female==0
replace ageCat = 150 if inrange(ageMosD,172.5,173.5) & female==0
replace ageCat = 151 if inrange(ageMosD,173.5,174.5) & female==0
replace ageCat = 152 if inrange(ageMosD,174.5,175.5) & female==0
replace ageCat = 153 if inrange(ageMosD,175.5,176.5) & female==0
replace ageCat = 154 if inrange(ageMosD,176.5,177.5) & female==0
replace ageCat = 155 if inrange(ageMosD,177.5,178.5) & female==0
replace ageCat = 156 if inrange(ageMosD,178.5,179.5) & female==0
replace ageCat = 157 if inrange(ageMosD,179.5,180.5) & female==0
replace ageCat = 158 if inrange(ageMosD,180.5,181.5) & female==0
replace ageCat = 159 if inrange(ageMosD,181.5,182.5) & female==0
replace ageCat = 160 if inrange(ageMosD,182.5,183.5) & female==0
replace ageCat = 161 if inrange(ageMosD,183.5,184.5) & female==0
replace ageCat = 162 if inrange(ageMosD,184.5,185.5) & female==0
replace ageCat = 163 if inrange(ageMosD,185.5,186.5) & female==0
replace ageCat = 164 if inrange(ageMosD,186.5,187.5) & female==0
replace ageCat = 165 if inrange(ageMosD,187.5,188.5) & female==0
replace ageCat = 166 if inrange(ageMosD,188.5,189.5) & female==0
replace ageCat = 167 if inrange(ageMosD,189.5,190.5) & female==0
replace ageCat = 168 if inrange(ageMosD,190.5,191.5) & female==0
replace ageCat = 169 if inrange(ageMosD,191.5,192.5) & female==0
replace ageCat = 170 if inrange(ageMosD,192.5,193.5) & female==0
replace ageCat = 171 if inrange(ageMosD,193.5,194.5) & female==0
replace ageCat = 172 if inrange(ageMosD,194.5,195.5) & female==0
replace ageCat = 173 if inrange(ageMosD,195.5,196.5) & female==0
replace ageCat = 174 if inrange(ageMosD,196.5,197.5) & female==0
replace ageCat = 175 if inrange(ageMosD,197.5,198.5) & female==0
replace ageCat = 176 if inrange(ageMosD,198.5,199.5) & female==0
replace ageCat = 177 if inrange(ageMosD,199.5,200.5) & female==0
replace ageCat = 178 if inrange(ageMosD,200.5,201.5) & female==0
replace ageCat = 179 if inrange(ageMosD,201.5,202.5) & female==0
replace ageCat = 180 if inrange(ageMosD,202.5,203.5) & female==0
replace ageCat = 181 if inrange(ageMosD,203.5,204.5) & female==0
replace ageCat = 182 if inrange(ageMosD,204.5,205.5) & female==0
replace ageCat = 183 if inrange(ageMosD,205.5,206.5) & female==0
replace ageCat = 184 if inrange(ageMosD,206.5,207.5) & female==0
replace ageCat = 185 if inrange(ageMosD,207.5,208.5) & female==0
replace ageCat = 186 if inrange(ageMosD,208.5,209.5) & female==0
replace ageCat = 187 if inrange(ageMosD,209.5,210.5) & female==0
replace ageCat = 188 if inrange(ageMosD,210.5,211.5) & female==0
replace ageCat = 189 if inrange(ageMosD,211.5,212.5) & female==0
replace ageCat = 190 if inrange(ageMosD,212.5,213.5) & female==0
replace ageCat = 191 if inrange(ageMosD,213.5,214.5) & female==0
replace ageCat = 192 if inrange(ageMosD,214.5,215.5) & female==0
replace ageCat = 193 if inrange(ageMosD,215.5,216.5) & female==0
replace ageCat = 194 if inrange(ageMosD,216.5,217.5) & female==0
replace ageCat = 195 if inrange(ageMosD,217.5,218.5) & female==0
replace ageCat = 196 if inrange(ageMosD,218.5,219.5) & female==0
replace ageCat = 197 if inrange(ageMosD,219.5,220.5) & female==0
replace ageCat = 198 if inrange(ageMosD,220.5,221.5) & female==0
replace ageCat = 199 if inrange(ageMosD,221.5,222.5) & female==0
replace ageCat = 200 if inrange(ageMosD,222.5,223.5) & female==0
replace ageCat = 201 if inrange(ageMosD,223.5,224.5) & female==0
replace ageCat = 202 if inrange(ageMosD,224.5,225.5) & female==0
replace ageCat = 203 if inrange(ageMosD,225.5,226.5) & female==0
replace ageCat = 204 if inrange(ageMosD,226.5,227.5) & female==0
replace ageCat = 205 if inrange(ageMosD,227.5,228.5) & female==0
replace ageCat = 206 if inrange(ageMosD,228.5,229.5) & female==0
replace ageCat = 207 if inrange(ageMosD,229.5,230.5) & female==0
replace ageCat = 208 if inrange(ageMosD,230.5,231.5) & female==0
replace ageCat = 209 if inrange(ageMosD,231.5,232.5) & female==0
replace ageCat = 210 if inrange(ageMosD,232.5,233.5) & female==0
replace ageCat = 211 if inrange(ageMosD,233.5,234.5) & female==0
replace ageCat = 212 if inrange(ageMosD,234.5,235.5) & female==0
replace ageCat = 213 if inrange(ageMosD,235.5,236.5) & female==0
replace ageCat = 214 if inrange(ageMosD,236.5,237.5) & female==0
replace ageCat = 215 if inrange(ageMosD,237.5,238.5) & female==0
replace ageCat = 216 if inrange(ageMosD,238.5,239.5) & female==0
replace ageCat = 217 if inrange(ageMosD,239.5,240  ) & female==0
replace ageCat = 218 if inrange(ageMosD,240  ,10000) & female==0
replace ageCat = 219 if inrange(ageMosD,24   ,24.5 ) & female==1
replace ageCat = 220 if inrange(ageMosD,24.5 ,25.5 ) & female==1
replace ageCat = 221 if inrange(ageMosD,25.5 ,26.5 ) & female==1
replace ageCat = 222 if inrange(ageMosD,26.5 ,27.5 ) & female==1
replace ageCat = 223 if inrange(ageMosD,27.5 ,28.5 ) & female==1
replace ageCat = 224 if inrange(ageMosD,28.5 ,29.5 ) & female==1
replace ageCat = 225 if inrange(ageMosD,29.5 ,30.5 ) & female==1
replace ageCat = 226 if inrange(ageMosD,30.5 ,31.5 ) & female==1
replace ageCat = 227 if inrange(ageMosD,31.5 ,32.5 ) & female==1
replace ageCat = 228 if inrange(ageMosD,32.5 ,33.5 ) & female==1
replace ageCat = 229 if inrange(ageMosD,33.5 ,34.5 ) & female==1
replace ageCat = 230 if inrange(ageMosD,34.5 ,35.5 ) & female==1
replace ageCat = 231 if inrange(ageMosD,35.5 ,36.5 ) & female==1
replace ageCat = 232 if inrange(ageMosD,36.5 ,37.5 ) & female==1
replace ageCat = 233 if inrange(ageMosD,37.5 ,38.5 ) & female==1
replace ageCat = 234 if inrange(ageMosD,38.5 ,39.5 ) & female==1
replace ageCat = 235 if inrange(ageMosD,39.5 ,40.5 ) & female==1
replace ageCat = 236 if inrange(ageMosD,40.5 ,41.5 ) & female==1
replace ageCat = 237 if inrange(ageMosD,41.5 ,42.5 ) & female==1
replace ageCat = 238 if inrange(ageMosD,42.5 ,43.5 ) & female==1
replace ageCat = 239 if inrange(ageMosD,43.5 ,44.5 ) & female==1
replace ageCat = 240 if inrange(ageMosD,44.5 ,45.5 ) & female==1
replace ageCat = 241 if inrange(ageMosD,45.5 ,46.5 ) & female==1
replace ageCat = 242 if inrange(ageMosD,46.5 ,47.5 ) & female==1
replace ageCat = 243 if inrange(ageMosD,47.5 ,48.5 ) & female==1
replace ageCat = 244 if inrange(ageMosD,48.5 ,49.5 ) & female==1
replace ageCat = 245 if inrange(ageMosD,49.5 ,50.5 ) & female==1
replace ageCat = 246 if inrange(ageMosD,50.5 ,51.5 ) & female==1
replace ageCat = 247 if inrange(ageMosD,51.5 ,52.5 ) & female==1
replace ageCat = 248 if inrange(ageMosD,52.5 ,53.5 ) & female==1
replace ageCat = 249 if inrange(ageMosD,53.5 ,54.5 ) & female==1
replace ageCat = 250 if inrange(ageMosD,54.5 ,55.5 ) & female==1
replace ageCat = 251 if inrange(ageMosD,55.5 ,56.5 ) & female==1
replace ageCat = 252 if inrange(ageMosD,56.5 ,57.5 ) & female==1
replace ageCat = 253 if inrange(ageMosD,57.5 ,58.5 ) & female==1
replace ageCat = 254 if inrange(ageMosD,58.5 ,59.5 ) & female==1
replace ageCat = 255 if inrange(ageMosD,59.5 ,60.5 ) & female==1
replace ageCat = 256 if inrange(ageMosD,60.5 ,61.5 ) & female==1
replace ageCat = 257 if inrange(ageMosD,61.5 ,62.5 ) & female==1
replace ageCat = 258 if inrange(ageMosD,62.5 ,63.5 ) & female==1
replace ageCat = 259 if inrange(ageMosD,63.5 ,64.5 ) & female==1
replace ageCat = 260 if inrange(ageMosD,64.5 ,65.5 ) & female==1
replace ageCat = 261 if inrange(ageMosD,65.5 ,66.5 ) & female==1
replace ageCat = 262 if inrange(ageMosD,66.5 ,67.5 ) & female==1
replace ageCat = 263 if inrange(ageMosD,67.5 ,68.5 ) & female==1
replace ageCat = 264 if inrange(ageMosD,68.5 ,69.5 ) & female==1
replace ageCat = 265 if inrange(ageMosD,69.5 ,70.5 ) & female==1
replace ageCat = 266 if inrange(ageMosD,70.5 ,71.5 ) & female==1
replace ageCat = 267 if inrange(ageMosD,71.5 ,72.5 ) & female==1
replace ageCat = 268 if inrange(ageMosD,72.5 ,73.5 ) & female==1
replace ageCat = 269 if inrange(ageMosD,73.5 ,74.5 ) & female==1
replace ageCat = 270 if inrange(ageMosD,74.5 ,75.5 ) & female==1
replace ageCat = 271 if inrange(ageMosD,75.5 ,76.5 ) & female==1
replace ageCat = 272 if inrange(ageMosD,76.5 ,77.5 ) & female==1
replace ageCat = 273 if inrange(ageMosD,77.5 ,78.5 ) & female==1
replace ageCat = 274 if inrange(ageMosD,78.5 ,79.5 ) & female==1
replace ageCat = 275 if inrange(ageMosD,79.5 ,80.5 ) & female==1
replace ageCat = 276 if inrange(ageMosD,80.5 ,81.5 ) & female==1
replace ageCat = 277 if inrange(ageMosD,81.5 ,82.5 ) & female==1
replace ageCat = 278 if inrange(ageMosD,82.5 ,83.5 ) & female==1
replace ageCat = 279 if inrange(ageMosD,83.5 ,84.5 ) & female==1
replace ageCat = 280 if inrange(ageMosD,84.5 ,85.5 ) & female==1
replace ageCat = 281 if inrange(ageMosD,85.5 ,86.5 ) & female==1
replace ageCat = 282 if inrange(ageMosD,86.5 ,87.5 ) & female==1
replace ageCat = 283 if inrange(ageMosD,87.5 ,88.5 ) & female==1
replace ageCat = 284 if inrange(ageMosD,88.5 ,89.5 ) & female==1
replace ageCat = 285 if inrange(ageMosD,89.5 ,90.5 ) & female==1
replace ageCat = 286 if inrange(ageMosD,90.5 ,91.5 ) & female==1
replace ageCat = 287 if inrange(ageMosD,91.5 ,92.5 ) & female==1
replace ageCat = 288 if inrange(ageMosD,92.5 ,93.5 ) & female==1
replace ageCat = 289 if inrange(ageMosD,93.5 ,94.5 ) & female==1
replace ageCat = 290 if inrange(ageMosD,94.5 ,95.5 ) & female==1
replace ageCat = 291 if inrange(ageMosD,95.5 ,96.5 ) & female==1
replace ageCat = 292 if inrange(ageMosD,96.5 ,97.5 ) & female==1
replace ageCat = 293 if inrange(ageMosD,97.5 ,98.5 ) & female==1
replace ageCat = 294 if inrange(ageMosD,98.5 ,99.5 ) & female==1
replace ageCat = 295 if inrange(ageMosD,99.5 ,100.5) & female==1
replace ageCat = 296 if inrange(ageMosD,100.5,101.5) & female==1
replace ageCat = 297 if inrange(ageMosD,101.5,102.5) & female==1
replace ageCat = 298 if inrange(ageMosD,102.5,103.5) & female==1
replace ageCat = 299 if inrange(ageMosD,103.5,104.5) & female==1
replace ageCat = 300 if inrange(ageMosD,104.5,105.5) & female==1
replace ageCat = 301 if inrange(ageMosD,105.5,106.5) & female==1
replace ageCat = 302 if inrange(ageMosD,106.5,107.5) & female==1
replace ageCat = 303 if inrange(ageMosD,107.5,108.5) & female==1
replace ageCat = 304 if inrange(ageMosD,108.5,109.5) & female==1
replace ageCat = 305 if inrange(ageMosD,109.5,110.5) & female==1
replace ageCat = 306 if inrange(ageMosD,110.5,111.5) & female==1
replace ageCat = 307 if inrange(ageMosD,111.5,112.5) & female==1
replace ageCat = 308 if inrange(ageMosD,112.5,113.5) & female==1
replace ageCat = 309 if inrange(ageMosD,113.5,114.5) & female==1
replace ageCat = 310 if inrange(ageMosD,114.5,115.5) & female==1
replace ageCat = 311 if inrange(ageMosD,115.5,116.5) & female==1
replace ageCat = 312 if inrange(ageMosD,116.5,117.5) & female==1
replace ageCat = 313 if inrange(ageMosD,117.5,118.5) & female==1
replace ageCat = 314 if inrange(ageMosD,118.5,119.5) & female==1
replace ageCat = 315 if inrange(ageMosD,119.5,120.5) & female==1
replace ageCat = 316 if inrange(ageMosD,120.5,121.5) & female==1
replace ageCat = 317 if inrange(ageMosD,121.5,122.5) & female==1
replace ageCat = 318 if inrange(ageMosD,122.5,123.5) & female==1
replace ageCat = 319 if inrange(ageMosD,123.5,124.5) & female==1
replace ageCat = 320 if inrange(ageMosD,124.5,125.5) & female==1
replace ageCat = 321 if inrange(ageMosD,125.5,126.5) & female==1
replace ageCat = 322 if inrange(ageMosD,126.5,127.5) & female==1
replace ageCat = 323 if inrange(ageMosD,127.5,128.5) & female==1
replace ageCat = 324 if inrange(ageMosD,128.5,129.5) & female==1
replace ageCat = 325 if inrange(ageMosD,129.5,130.5) & female==1
replace ageCat = 326 if inrange(ageMosD,130.5,131.5) & female==1
replace ageCat = 327 if inrange(ageMosD,131.5,132.5) & female==1
replace ageCat = 328 if inrange(ageMosD,132.5,133.5) & female==1
replace ageCat = 329 if inrange(ageMosD,133.5,134.5) & female==1
replace ageCat = 330 if inrange(ageMosD,134.5,135.5) & female==1
replace ageCat = 331 if inrange(ageMosD,135.5,136.5) & female==1
replace ageCat = 332 if inrange(ageMosD,136.5,137.5) & female==1
replace ageCat = 333 if inrange(ageMosD,137.5,138.5) & female==1
replace ageCat = 334 if inrange(ageMosD,138.5,139.5) & female==1
replace ageCat = 335 if inrange(ageMosD,139.5,140.5) & female==1
replace ageCat = 336 if inrange(ageMosD,140.5,141.5) & female==1
replace ageCat = 337 if inrange(ageMosD,141.5,142.5) & female==1
replace ageCat = 338 if inrange(ageMosD,142.5,143.5) & female==1
replace ageCat = 339 if inrange(ageMosD,143.5,144.5) & female==1
replace ageCat = 340 if inrange(ageMosD,144.5,145.5) & female==1
replace ageCat = 341 if inrange(ageMosD,145.5,146.5) & female==1
replace ageCat = 342 if inrange(ageMosD,146.5,147.5) & female==1
replace ageCat = 343 if inrange(ageMosD,147.5,148.5) & female==1
replace ageCat = 344 if inrange(ageMosD,148.5,149.5) & female==1
replace ageCat = 345 if inrange(ageMosD,149.5,150.5) & female==1
replace ageCat = 346 if inrange(ageMosD,150.5,151.5) & female==1
replace ageCat = 347 if inrange(ageMosD,151.5,152.5) & female==1
replace ageCat = 348 if inrange(ageMosD,152.5,153.5) & female==1
replace ageCat = 349 if inrange(ageMosD,153.5,154.5) & female==1
replace ageCat = 350 if inrange(ageMosD,154.5,155.5) & female==1
replace ageCat = 351 if inrange(ageMosD,155.5,156.5) & female==1
replace ageCat = 352 if inrange(ageMosD,156.5,157.5) & female==1
replace ageCat = 353 if inrange(ageMosD,157.5,158.5) & female==1
replace ageCat = 354 if inrange(ageMosD,158.5,159.5) & female==1
replace ageCat = 355 if inrange(ageMosD,159.5,160.5) & female==1
replace ageCat = 356 if inrange(ageMosD,160.5,161.5) & female==1
replace ageCat = 357 if inrange(ageMosD,161.5,162.5) & female==1
replace ageCat = 358 if inrange(ageMosD,162.5,163.5) & female==1
replace ageCat = 359 if inrange(ageMosD,163.5,164.5) & female==1
replace ageCat = 360 if inrange(ageMosD,164.5,165.5) & female==1
replace ageCat = 361 if inrange(ageMosD,165.5,166.5) & female==1
replace ageCat = 362 if inrange(ageMosD,166.5,167.5) & female==1
replace ageCat = 363 if inrange(ageMosD,167.5,168.5) & female==1
replace ageCat = 364 if inrange(ageMosD,168.5,169.5) & female==1
replace ageCat = 365 if inrange(ageMosD,169.5,170.5) & female==1
replace ageCat = 366 if inrange(ageMosD,170.5,171.5) & female==1
replace ageCat = 367 if inrange(ageMosD,171.5,172.5) & female==1
replace ageCat = 368 if inrange(ageMosD,172.5,173.5) & female==1
replace ageCat = 369 if inrange(ageMosD,173.5,174.5) & female==1
replace ageCat = 370 if inrange(ageMosD,174.5,175.5) & female==1
replace ageCat = 371 if inrange(ageMosD,175.5,176.5) & female==1
replace ageCat = 372 if inrange(ageMosD,176.5,177.5) & female==1
replace ageCat = 373 if inrange(ageMosD,177.5,178.5) & female==1
replace ageCat = 374 if inrange(ageMosD,178.5,179.5) & female==1
replace ageCat = 375 if inrange(ageMosD,179.5,180.5) & female==1
replace ageCat = 376 if inrange(ageMosD,180.5,181.5) & female==1
replace ageCat = 377 if inrange(ageMosD,181.5,182.5) & female==1
replace ageCat = 378 if inrange(ageMosD,182.5,183.5) & female==1
replace ageCat = 379 if inrange(ageMosD,183.5,184.5) & female==1
replace ageCat = 380 if inrange(ageMosD,184.5,185.5) & female==1
replace ageCat = 381 if inrange(ageMosD,185.5,186.5) & female==1
replace ageCat = 382 if inrange(ageMosD,186.5,187.5) & female==1
replace ageCat = 383 if inrange(ageMosD,187.5,188.5) & female==1
replace ageCat = 384 if inrange(ageMosD,188.5,189.5) & female==1
replace ageCat = 385 if inrange(ageMosD,189.5,190.5) & female==1
replace ageCat = 386 if inrange(ageMosD,190.5,191.5) & female==1
replace ageCat = 387 if inrange(ageMosD,191.5,192.5) & female==1
replace ageCat = 388 if inrange(ageMosD,192.5,193.5) & female==1
replace ageCat = 389 if inrange(ageMosD,193.5,194.5) & female==1
replace ageCat = 390 if inrange(ageMosD,194.5,195.5) & female==1
replace ageCat = 391 if inrange(ageMosD,195.5,196.5) & female==1
replace ageCat = 392 if inrange(ageMosD,196.5,197.5) & female==1
replace ageCat = 393 if inrange(ageMosD,197.5,198.5) & female==1
replace ageCat = 394 if inrange(ageMosD,198.5,199.5) & female==1
replace ageCat = 395 if inrange(ageMosD,199.5,200.5) & female==1
replace ageCat = 396 if inrange(ageMosD,200.5,201.5) & female==1
replace ageCat = 397 if inrange(ageMosD,201.5,202.5) & female==1
replace ageCat = 398 if inrange(ageMosD,202.5,203.5) & female==1
replace ageCat = 399 if inrange(ageMosD,203.5,204.5) & female==1
replace ageCat = 400 if inrange(ageMosD,204.5,205.5) & female==1
replace ageCat = 401 if inrange(ageMosD,205.5,206.5) & female==1
replace ageCat = 402 if inrange(ageMosD,206.5,207.5) & female==1
replace ageCat = 403 if inrange(ageMosD,207.5,208.5) & female==1
replace ageCat = 404 if inrange(ageMosD,208.5,209.5) & female==1
replace ageCat = 405 if inrange(ageMosD,209.5,210.5) & female==1
replace ageCat = 406 if inrange(ageMosD,210.5,211.5) & female==1
replace ageCat = 407 if inrange(ageMosD,211.5,212.5) & female==1
replace ageCat = 408 if inrange(ageMosD,212.5,213.5) & female==1
replace ageCat = 409 if inrange(ageMosD,213.5,214.5) & female==1
replace ageCat = 410 if inrange(ageMosD,214.5,215.5) & female==1
replace ageCat = 411 if inrange(ageMosD,215.5,216.5) & female==1
replace ageCat = 412 if inrange(ageMosD,216.5,217.5) & female==1
replace ageCat = 413 if inrange(ageMosD,217.5,218.5) & female==1
replace ageCat = 414 if inrange(ageMosD,218.5,219.5) & female==1
replace ageCat = 415 if inrange(ageMosD,219.5,220.5) & female==1
replace ageCat = 416 if inrange(ageMosD,220.5,221.5) & female==1
replace ageCat = 417 if inrange(ageMosD,221.5,222.5) & female==1
replace ageCat = 418 if inrange(ageMosD,222.5,223.5) & female==1
replace ageCat = 419 if inrange(ageMosD,223.5,224.5) & female==1
replace ageCat = 420 if inrange(ageMosD,224.5,225.5) & female==1
replace ageCat = 421 if inrange(ageMosD,225.5,226.5) & female==1
replace ageCat = 422 if inrange(ageMosD,226.5,227.5) & female==1
replace ageCat = 423 if inrange(ageMosD,227.5,228.5) & female==1
replace ageCat = 424 if inrange(ageMosD,228.5,229.5) & female==1
replace ageCat = 425 if inrange(ageMosD,229.5,230.5) & female==1
replace ageCat = 426 if inrange(ageMosD,230.5,231.5) & female==1
replace ageCat = 427 if inrange(ageMosD,231.5,232.5) & female==1
replace ageCat = 428 if inrange(ageMosD,232.5,233.5) & female==1
replace ageCat = 429 if inrange(ageMosD,233.5,234.5) & female==1
replace ageCat = 430 if inrange(ageMosD,234.5,235.5) & female==1
replace ageCat = 431 if inrange(ageMosD,235.5,236.5) & female==1
replace ageCat = 432 if inrange(ageMosD,236.5,237.5) & female==1
replace ageCat = 433 if inrange(ageMosD,237.5,238.5) & female==1
replace ageCat = 434 if inrange(ageMosD,238.5,239.5) & female==1
replace ageCat = 435 if inrange(ageMosD,239.5,240  ) & female==1
replace ageCat = 436 if inrange(ageMosD,240  ,10000) & female==1

// CDC data comes from https://www.cdc.gov/growthcharts/data/zscore/statage.csv
// Steps to convert CSV file to DTA format:
// insheet using statage.csv, comma clear
// gen ageCat = _n
// save statureForAgeCDC, replace
merge m:1 ageCat using statureForAgeCDC, keep(match master) nogen keepusing(l m s p10 p25 p50 p75 p90)

generat heightZ   = (((heightCm/m)^l)-1)/(l*s)
generat heightPct = 100*normal(heightZ)
rename  p10 heightP10
rename  p25 heightP25
rename  p50 heightP50
rename  p75 heightP75
rename  p90 heightP90
generat inchesAboveMedian = (heightCm-heightP50)/2.54
generat heightAbovePeers  = height-peerheight if wave==1
generat heightZabovePeers = ((((2.54*(height-peerheight))/m)^l)-1)/(l*s) if wave==1

ren iyear year
generat potExper = age - ageEnterLF
replace potExper = 0 if potExper<0
generat onlySoft        = soft==1 & hard==0
replace onlySoft        = . if mi(soft) | mi(hard)
generat onlyHard        = soft==0 & hard==1
replace onlyHard        = . if mi(soft) | mi(hard)
generat bothSoftHard    = soft==1 & hard==1
replace bothSoftHard    = . if mi(soft) | mi(hard)
generat neitherSoftHard = soft==0 & hard==0
replace neitherSoftHard = . if mi(soft) | mi(hard)
lab var potExper "Potential experience (as measured by years since labor force entry)"
generat occType = .
replace occType = 1 if onlySoft
replace occType = 2 if onlyHard
replace occType = 3 if bothSoftHard
replace occType = 4 if neitherSoftHard
replace occType = . if mi(soft) | mi(hard)
lab def vloccType 1 "Soft only" 2 "Hard only" 3 "Both soft and hard" 4 "Neither soft nor hard"
lab val occType vloccType

generat stemOcc = inlist(occ,113021,119041,119121,151111,151121,151122,151131,151132,151133,151134,151141,151142,151143,151151,151152,151199,152011,152021,152031,152041,152091,152099,171021,171022,172011,172021,172031,172041,172051,172061,172071,172072,172081,172111,172112,172121,172131,172141,172151,172161,172171,172199,173011,173012,173013,173019,173021,173022,173023,173024,173025,173026,173027,173029,173031,191011,191012,191013,191021,191022,191023,191029,191031,191032,191041,191042,191099,192011,192012,192021,192031,192032,192041,192042,192043,192099,194011,194021,194031,194041,194051,194091,194092,194093,194099,251021,251022,251032,251041,251042,251043,251051,251052,251053,251054,414011,419031)

lab var height "Height (in inches, self-reported)"
lab var heightMeas "Height (in inches, measured)"
lab var weightLbs "Weight (in pounds, self-reported)"
lab var weightLbsMeas "Weight (in pounds, measured)"
lab var sports "Ever participated in sports"
lab var sportsA "Ever participated in sports (expanded definition)"
lab var numSports "Number of sports participated in"
lab var numSportsA "Number of sports participated in (expanded definition)"
lab var gradHS "Graduated HS (or GED)"
lab var female "Female indicator"
lab var year "Calendar year of interview"
lab var wave "Wave of interview"

compress

xtset id wave

d

save master_nowgt.dta, replace
log close
