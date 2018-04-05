version 13.1
clear all
set more off
capture log close

log using "analysisMult.log", replace

set maxvar  32000
set matsize 11000

**************************************************
* Load data and run some preliminary analyses
**************************************************
use ../AddHealthData/master_nowgt.dta, clear


**** Create teen height, adult height, teen weight, and quarter of birth
qui gen teenheightA = height if wave==1
bys id (wave): egen teenheight = mean(teenheightA )
drop teenheightA
qui gen adultheightA = height if wave==4
bys id (wave): egen adultheight = mean(adultheightA )
drop adultheightA
qui gen teenheightA = heightZ if wave==1
bys id (wave): egen teenheightZ = mean(teenheightA )
drop teenheightA
qui gen teenheightA = heightAbovePeers if wave==1
bys id (wave): egen teenheightAbovePeers = mean(teenheightA )
drop teenheightA
qui gen teenheightA = heightZabovePeers if wave==1
bys id (wave): egen teenheightZabovePeers = mean(teenheightA )
drop teenheightA
qui gen adultheightA = heightZ if wave==4
bys id (wave): egen adultheightZ = mean(adultheightA )
drop adultheightA
qui gen teenheightA = inrange(heightPct,75,100) if wave==1
bys id (wave): egen teenheightAboveP75 = mean(teenheightA )
drop teenheightA
qui gen adultheightA = inrange(heightPct,75,100) if wave==4
bys id (wave): egen adultheightAboveP75 = mean(adultheightA )
drop adultheightA
qui gen teenheightA = inchesAboveMedian if wave==1
bys id (wave): egen teenheightInAbvMed = mean(teenheightA )
drop teenheightA
qui gen adultheightA = inchesAboveMedian if wave==4
bys id (wave): egen adultheightInAbvMed = mean(adultheightA )
drop adultheightA
qui gen teenweightA = weightLbs if wave==1
bys id (wave): egen teenweight = mean(teenweightA )
drop teenweightA
qui gen teenobeseA = obese if wave==1
bys id (wave): egen teenobese = mean(teenobeseA )
drop teenobeseA
qui gen q4birth = inlist(birthMo,10,11,12)
qui gen n_roster000 = n_roster/1000
xtile enr = n_roster, nquantiles(10)

**** Create wave 4 missing indicator (separate from missing wages)
gen missWave4 = earn==.n & wave==4

**** Create race dummies
gen white    = race==1
gen black    = race==2
gen hispanic = race==3
gen other    = race==4

**** Parental ed dummies
gen momColGrad = inlist(hgcMoth,4,5)
gen momEdMiss  = hgcMoth==6
gen dadColGrad = inlist(hgcFath,4,5)
gen dadEdMiss  = hgcFath==6
qui tab hgcMoth, gen(momeddum)
qui tab hgcFath, gen(dadeddum)

**** Childhood co-residence dummies
gen liveMoth14 = liveWithMoth==1
gen liveFath14 = liveWithFath==1

**** School enrollment quartiles
qui tab enr, gen(enrdum)

**** School metro dummies
qui tab metro, gen(metrodum)

**** School race dummies
qui tab qpwht, gen(qpwhtdum)

**** School type dummies
qui tab schtype, gen(typedum)

**** PVT scores
gen ahpvt_std2 = ahpvt_std^2

**** Experience
gen potExper2 = potExper^2

**** Tenure
gen tenure2 = tenure^2

**** Years of schooling
gen yrsSchool2 = yrsSchool^2

**** birth year dummies
qui tab birthYr, gen(byrdum)

local FEoutcomes     FEsoft FEhard FEstemOcc FEhrsCommSvcPastYr FEoftenVoteLocElection FElnEarn FElnWage FEhrsCurrJob FEattCol FEgrad4yrCondlAttCol FEgrad4yr FEgradHS FEadvDeg FEinLF FEempPT FEempFT FEcurrMilitary FEeverRegularlySmoked FEeverDrinkAlc FEnumDaysDrunkPastYr FEheavyDrunk FEeverUsedIllegalDrugs FEeverAbusedRxDrugs FEeverArrested FEeverRiskyPregnant FEageFirstSex FEeverMarried FEeverCohabitated FEvideoGamer FEoverweight FEobese FEovrwgtObese FEregExercise
local outcomes         soft   hard   stemOcc   hrsCommSvcPastYr   oftenVoteLocElection   lnEarn   lnWage   hrsCurrJob   attCol   grad4yrCondlAttCol   grad4yr   gradHS   advDeg   inLF   empPT   empFT   currMilitary   everRegularlySmoked   everDrinkAlc   numDaysDrunkPastYr   heavyDrunk   everUsedIllegalDrugs   everAbusedRxDrugs   everArrested   everRiskyPregnant   ageFirstSex   everMarried   everCohabitated   videoGamer   overweight   obese   ovrwgtObese   regExercise
local FEvars25labmkt FEblack FEhispanic FEother FEmomeddum2 FEmomeddum3 FEmomeddum4 FEmomeddum5 FEmomeddum6 FEdadeddum2 FEdadeddum3 FEdadeddum4 FEdadeddum5 FEdadeddum6 FEliveMoth14 FEm_liveWithMoth14 FEliveFath14 FEm_liveWithFath14 FEbyrdum6 FEbyrdum7 FEbyrdum8 FEbyrdum9                                                                                                                                                        FEahpvt_std FEahpvt_std2 FEpotExper FEpotExper2 FEtenure FEtenure2 FEyrsSchool FEyrsSchool2 FEgradHS FEgrad4yr
local vars25labmkt     black   hispanic   other   momeddum2   momeddum3   momeddum4   momeddum5   momeddum6   dadeddum2   dadeddum3   dadeddum4   dadeddum5   dadeddum6   liveMoth14   m_liveWithMoth14   liveFath14   m_liveWithFath14   byrdum6   byrdum7   byrdum8   byrdum9   enrdum2   enrdum3   enrdum4   enrdum5   enrdum6   enrdum7   enrdum8   enrdum9   enrdum10   metrodum2   metrodum3   qpwhtdum2   qpwhtdum3   qpwhtdum4   ahpvt_std   ahpvt_std2   potExper   potExper2   tenure   tenure2   yrsSchool   yrsSchool2   gradHS   grad4yr
local FEvars25       FEblack FEhispanic FEother FEmomeddum2 FEmomeddum3 FEmomeddum4 FEmomeddum5 FEmomeddum6 FEdadeddum2 FEdadeddum3 FEdadeddum4 FEdadeddum5 FEdadeddum6 FEliveMoth14 FEm_liveWithMoth14 FEliveFath14 FEm_liveWithFath14 FEbyrdum6 FEbyrdum7 FEbyrdum8 FEbyrdum9                                                                                                                                                        FEahpvt_std FEahpvt_std2
local vars25           black   hispanic   other   momeddum2   momeddum3   momeddum4   momeddum5   momeddum6   dadeddum2   dadeddum3   dadeddum4   dadeddum5   dadeddum6   liveMoth14   m_liveWithMoth14   liveFath14   m_liveWithFath14   byrdum6   byrdum7   byrdum8   byrdum9   enrdum2   enrdum3   enrdum4   enrdum5   enrdum6   enrdum7   enrdum8   enrdum9   enrdum10   metrodum2   metrodum3   qpwhtdum2   qpwhtdum3   qpwhtdum4   ahpvt_std   ahpvt_std2
* local FEvars25labmkt FEblack FEhispanic FEother FEmomColGrad FEmomEdMiss FEdadColGrad FEdadEdMiss FEliveMoth14 FEm_liveWithMoth14 FEliveFath14 FEm_liveWithFath14                                                                                                                                                        FEahpvt_std FEahpvt_std2 FEadultheightZ FEpotExper FEpotExper2 FEtenure FEtenure2 FEyrsSchool FEyrsSchool2 FEgradHS FEgrad4yr
* local vars25labmkt     black   hispanic   other   momColGrad   momEdMiss   dadColGrad   dadEdMiss   liveMoth14   m_liveWithMoth14   liveFath14   m_liveWithFath14   enrdum2   enrdum3   enrdum4   enrdum5   enrdum6   enrdum7   enrdum8   enrdum9   enrdum10   metrodum2   metrodum3   qpwhtdum2   qpwhtdum3   qpwhtdum4   ahpvt_std   ahpvt_std2   adultheightZ   potExper   potExper2   tenure   tenure2   yrsSchool   yrsSchool2   gradHS   grad4yr
* local FEvars25       FEblack FEhispanic FEother FEmomColGrad FEmomEdMiss FEdadColGrad FEdadEdMiss FEliveMoth14 FEm_liveWithMoth14 FEliveFath14 FEm_liveWithFath14                                                                                                                                                        FEahpvt_std FEahpvt_std2 FEadultheightZ
* local vars25           black   hispanic   other   momColGrad   momEdMiss   dadColGrad   dadEdMiss   liveMoth14   m_liveWithMoth14   liveFath14   m_liveWithFath14   enrdum2   enrdum3   enrdum4   enrdum5   enrdum6   enrdum7   enrdum8   enrdum9   enrdum10   metrodum2   metrodum3   qpwhtdum2   qpwhtdum3   qpwhtdum4   ahpvt_std   ahpvt_std2   adultheightZ


**** Create missing parental education dummies
* gen m_hgcMoth = mi(hgcMoth)
* gen m_hgcFath = mi(hgcFath)

**** Sample Selection criteria
local row = 2
putexcel A1 = ("Table A1: Sample Selection") ///
A`row' = ("Selection criterion") B`row' = ("Resultant Persons") C`row' = ("Resultant person-wave observations") ///
using SampleSelection, sheet("TA1") modify
local row = `row'+1
* drop those who attrited
drop if mi(age)
xtsum id
putexcel A`row' = ("Full Add Health sample") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
local row = `row'+1
* drop those missing in-school questionnaire
drop if frenchClub==.n
xtsum id
putexcel A`row' = ("Drop if missing in-school questionnaire in Wave I") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
local row = `row'+1
* drop females
drop if female
xtsum id
putexcel A`row' = ("Drop females") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
local row = `row'+1
* * drop those with mising sample weights
* * drop if mi(gswgt)
* * xtsum id
* putexcel A`row' = ("Drop if missing sample weights") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
* local row = `row'+1
* drop those with mising PVT score
drop if mi(ahpvt_std)
xtsum id
putexcel A`row' = ("Drop if missing AH-PVT score") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
local row = `row'+1
* drop older students in wave 1
drop if ~inrange(birthYr,1978,1982)
xtsum id
putexcel A`row' = ("Drop if over age 17 in Wave I") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
local row = `row'+1
* * drop if missing height or weight
* drop if mi(teenheightZ) | mi(teenweight)
* xtsum id
* putexcel A`row' = ("Drop if missing height or weight in Wave I") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
* local row = `row'+1
* * drop if missing peer sports
* drop if mi(peerFracSports) | mi(n_roster000)
* xtsum id
* putexcel A`row' = ("Drop if missing peer sports participation data") B`row' = (r(n)) C`row' = (r(N)) using SampleSelection, sheet("TA1") modify
* local row = `row'+1

tab female if wave==4 & ~missWave4


**** Wave IV Sample Selection
local row = 2
putexcel A1 = ("Table A2: Wave IV Sample Selection") ///
A`row' = ("Selection criterion") B`row' = ("Resultant Persons") ///
using SampleSelection, sheet("TA2") modify
local row = `row'+1
xtsum id if wave==1
putexcel A`row' = ("Wave I estimation sample") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
local row = `row'+1
xtsum id if wave==4 & ~missWave4
putexcel A`row' = ("Drop if missing Wave IV interview") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
local row = `row'+1
xtsum id if wave==4 & ~missWave4 & ~mi(earn)
putexcel A`row' = ("Drop if missing earnings") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
local row = `row'+1
xtsum id if wave==4 & ~missWave4 & ~mi(earn) & earn>0
putexcel A`row' = ("Drop if zero earnings") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
local row = `row'+1
* xtsum id if ~mi(lnEarn)
* putexcel A`row' = ("Drop if zero earnings") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
* local row = `row'+1
xtsum id if wave==4 & ~missWave4 & ~mi(earn) & earn>0 & ~mi(occ) & ~mi(lnEarn)
putexcel A`row' = ("Drop if missing occupation") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
local row = `row'+1
xtsum id if wave==4 & ~missWave4 & ~mi(earn) & earn>0 & ~mi(occ) & ~mi(lnEarn) & ~mi(soft) & ~mi(hard)
putexcel A`row' = ("Drop if missing occupational skills index") B`row' = (r(n)) using SampleSelection, sheet("TA2") modify
local row = `row'+1
local wave4flagAll "wave==4 & ~missWave4"
xtsum id if `wave4flagAll'
local wave4flag    "wave==4 & ~missWave4 & ~mi(occ) & ~mi(lnEarn) & ~mi(soft) & ~mi(hard)"
xtsum id if `wave4flag'
* drop if missing key labor market variables
* drop if wave==4 & (mi(occ) | mi(lnEarn) | mi(soft) | mi(hard))
* xtsum id

reg teenobese multSports if `wave4flagAll'
reg obese teenobese multSports if `wave4flagAll'

*===================================================
* Summary statistics for descriptive stats tables
*===================================================
foreach var of varlist multSports white black hispanic other momeddum? dadeddum? liveMoth14 m_liveWithMoth14 liveFath14 m_liveWithFath14 byrdum? byrdum?? enrdum? enrdum?? metrodum? qpwhtdum? gradHS grad4yr attCol empFT regExercise heavyDrunk4 obese {
	gen `var'_100 = 100*`var'
}

qui clonevar tempahpvt_std = ahpvt_std
qui clonevar temppotExper  = potExper
qui clonevar temptenure    = tenure
qui clonevar tempyrsSchool = yrsSchool
qui clonevar templnWage    = lnWage
qui replace  tempahpvt_std = . if mi(ahpvt_std)
qui replace  temppotExper  = . if mi(potExper)
qui replace  temptenure    = . if mi(tenure)
qui replace  tempyrsSchool = . if mi(yrsSchool)
qui replace  templnWage    = . if mi(lnWage)


qui ds *_100
local discretevars `r(varlist)'

local contvars tempahpvt_std temppotExper temptenure tempyrsSchool templnWage

capture lab var multSports_100       "Multi-sport athlete"
capture lab var white_100            "White"
capture lab var black_100            "Black"
capture lab var hispanic_100         "Hispanic"
capture lab var other_100            "Other ethnicity"
capture lab var momeddum1_100        "Mom: HS dropout"
capture lab var momeddum2_100        "Mom: HS grad"
capture lab var momeddum3_100        "Mom: Some college"
capture lab var momeddum4_100        "Mom: 4-year college grad"
capture lab var momeddum5_100        "Mom: Advanced degree"
capture lab var momeddum6_100        "Mom: missing education"
capture lab var dadeddum1_100        "Dad: HS dropout"
capture lab var dadeddum2_100        "Dad: HS grad"
capture lab var dadeddum3_100        "Dad: Some college"
capture lab var dadeddum4_100        "Dad: 4-year college grad"
capture lab var dadeddum5_100        "Dad: Advanced degree"
capture lab var dadeddum6_100        "Dad: missing education"
capture lab var liveMoth14_100       "Lived with mother at age 14"
capture lab var m_liveWithMoth14_100 "Missing mother's co-residence status"
capture lab var liveFath14_100       "Lived with father at age 14"
capture lab var m_liveWithFath14_100 "Missing father's co-residence status"
capture lab var byrdum1_100          "Born in 1974"
capture lab var byrdum2_100          "Born in 1975"
capture lab var byrdum3_100          "Born in 1976"
capture lab var byrdum4_100          "Born in 1977"
capture lab var byrdum5_100          "Born in 1978"
capture lab var byrdum6_100          "Born in 1979"
capture lab var byrdum7_100          "Born in 1980"
capture lab var byrdum8_100          "Born in 1981"
capture lab var byrdum9_100          "Born in 1982"
capture lab var byrdum10_100         "Born in 1983"
capture lab var enrdum1_100          "School size: 26-311"
capture lab var enrdum2_100          "School size: 312-498"
capture lab var enrdum3_100          "School size: 499-644"
capture lab var enrdum4_100          "School size: 649-825"
capture lab var enrdum5_100          "School size: 842-967"
capture lab var enrdum6_100          "School size: 968-1,178"
capture lab var enrdum7_100          "School size: 1,221-1,631"
capture lab var enrdum8_100          "School size: 1,635-2,104"
capture lab var enrdum9_100          "School size: 2,114-2,320"
capture lab var enrdum10_100         "School size: 2,363-3,546"
capture lab var metrodum1_100        "Urban"
capture lab var metrodum2_100        "Suburban"
capture lab var metrodum3_100        "Rural"
capture lab var qpwhtdum1_100        "School: 0\% White"
capture lab var qpwhtdum2_100        "School: 1\%-66\% White"
capture lab var qpwhtdum3_100        "School: 67\%-93\% White"
capture lab var qpwhtdum4_100        "School: 94\%-100\% White"
capture lab var gradHS_100           "Graduated high school"
capture lab var attCol_100           "Attended college"
capture lab var grad4yr_100          "Graduated 4-year college"
capture lab var empFT_100            "Employed full-time"
capture lab var regExercise_100      "Regular exercise"
capture lab var heavyDrunk4_100      "Alcohol abuse"
capture lab var obese_100            "Obese"

capture lab var templnWage           "Log wage"
capture lab var tempahpvt_std        "AHPVT score"
capture lab var temppotExper         "Potential experience"
capture lab var temptenure           "Firm tenure"
capture lab var tempyrsSchool        "Years of schooling"

*-----------------------------------------
* Create summary stats tables
*-----------------------------------------
qui ds multSports_100 tempahpvt_std white_100 black_100 hispanic_100 other_100 momeddum1_100 momeddum2_100 momeddum3_100 momeddum4_100 momeddum5_100 momeddum6_100 dadeddum1_100 dadeddum2_100 dadeddum3_100 dadeddum4_100 dadeddum5_100 dadeddum6_100 liveMoth14_100 m_liveWithMoth14_100 liveFath14_100 m_liveWithFath14_100 byrdum1_100 byrdum2_100 byrdum3_100 byrdum4_100 byrdum5_100 byrdum6_100 byrdum7_100 byrdum8_100 byrdum9_100 byrdum10_100 enrdum1_100 enrdum2_100 enrdum3_100 enrdum4_100 enrdum5_100 enrdum6_100 enrdum7_100 enrdum8_100 enrdum9_100 enrdum10_100 metrodum1_100 metrodum2_100 metrodum3_100 qpwhtdum1_100 qpwhtdum2_100 qpwhtdum3_100 qpwhtdum4_100 temppotExper temptenure tempyrsSchool gradHS_100 attCol_100 grad4yr_100 templnWage empFT_100 regExercise_100 obese_100 heavyDrunk4_100
local allvars `r(varlist)'

qui gen holderOverall      = ""
qui gen holderOverallPflag = 0
qui gen holderAthlete0     = ""
qui gen holderAthlete1     = ""
qui gen holderName         = ""
qui gen fmtInd             = 0
local i = 1
foreach var in `allvars' {
	local test = 0
	foreach var2 in `discretevars' {
		if "`var'"=="`var2'" {
			local test = 1
			continue, break
		}
	}
	if "`test'"=="1" {
		di "`var'"
		local varlab: variable label `var'
		qui replace holderName = "`varlab'" if _n==`i'
		qui replace fmtInd     = 1          if _n==`i'
		qui sum `var' if `wave4flagAll', d
		local temp: di %3.2f `r(mean)'
		qui replace holderOverall = "`temp'" if _n==`i'
		qui ttest `var' if `wave4flagAll', by(multSports)
		qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
		foreach a in 0 1 {
			qui sum `var' if `wave4flagAll' & multSports==`a', d
			local temp: di %3.2f `r(mean)'
			qui replace holderAthlete`a' = "`temp'" if _n==`i'
		}
		local i = `=`i'+1'
	}
	else {
		di "`var'"
		local varlab: variable label `var'
		qui replace holderName = "`varlab'" if _n==`i'
		qui replace fmtInd     = 1          if _n==`i'
		qui sum `var' if `wave4flagAll', d
		local temp1: di %3.2f `r(mean)'
		local temp2: di %3.2f `r(sd)'
		qui replace holderOverall = "`temp1'"   if _n==`i'
		qui replace holderOverall = "(`temp2')" if _n==`=`i'+1'
		qui ttest `var' if `wave4flagAll', by(multSports)
		qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
		foreach a in 0 1 {
			qui sum `var' if `wave4flagAll' & multSports==`a', d
			local temp1: di %3.2f `r(mean)'
			local temp2: di %3.2f `r(sd)'
			qui replace holderAthlete`a' = "`temp1'"   if _n==`i'
			qui replace holderAthlete`a' = "(`temp2')" if _n==`=`i'+1'
		}
		local i = `=`i'+2'
	}
	* Sample Sizes
	qui replace holderName = "N" if _n==`i'
	qui count if `wave4flagAll'
	local tempN: di %9.0fc `r(N)'
	qui replace holderOverall = "`tempN'" if _n==`i'
	foreach a in 0 1 {
		qui count if `wave4flagAll' & multSports==`a'
		local tempN: di %9.0fc `r(N)'
		qui replace holderAthlete`a' = "`tempN'" if _n==`i'
	}
}

* Add asterisk if athletes are significantly different from non-athletes
replace holderAthlete1 = "$"+holderAthlete1+"^{\ast}$" if holderOverallPflag==1

qui listtex holderName holderAthlete0 holderAthlete1 holderOverall in 1/`=`i'' using sumStatsTableMult.tex, replace delimiter(" & ") end ("   \tabularnewline")

drop *_100

/*
**** Summary statistics (Individuals, wave 1)
putexcel A1 = ("Table 1: Individual summary stats") ///
A2 = ("Variable") B2 = ("N") C2 = ("Mean") D2 = ("Std. Dev.") ///
using SummaryTables, sheet("T1") modify
sleep 1000

loc row = 3
foreach var in white black hispanic other ageD hgcMoth m_hgcMoth hgcFath m_hgcFath ahpvt_std height heightZ heightPct inchesAboveMedian weightLbs sports {
loc varlab: var label `var'
qui sum `var' if wave==1
putexcel A`row' = ("`var'") ///
B`row' = (r(N)) C`row' = (r(mean)) D`row' = (r(sd)) ///
using SummaryTables, sheet("T1") modify
loc row = `row'+1
sleep 1000
}
qui sum numSports if wave==1 & sports
putexcel A`row' = ("Number of sports (if partic.)") ///
B`row' = (r(N)) C`row' = (r(mean)) D`row' = (r(sd)) ///
using SummaryTables, sheet("T1") modify
sleep 1000


**** Summary statistics (Schools belonging to estimation sample, wave 1)
putexcel A1 = ("Table 2: School summary stats") ///
A2 = ("Variable") B2 = ("N") C2 = ("Mean") D2 = ("Std. Dev.") E2 = ("Min") F2 = ("Max") ///
using SummaryTables, sheet("T2") modify
preserve
collapse n_roster schtype metro region qpwht avgClassSize sportsVariety if wave==1, by(scid)
recode schtype (3 = 2)
qui tab qpwht, gen(qp)
qui tab schtype, gen(type)
qui tab metro, gen(met)
qui tab region, gen(reg)
d n_roster avgClassSize qp* type* met* reg*

loc row = 3
foreach var in n_roster avgClassSize sportsVariety qp1 qp2 qp3 qp4 type1 type2 met1 met2 met3 reg1 reg2 reg3 reg4 {
qui sum `var'
putexcel A`row' = ("`var'") ///
B`row' = (r(N)) C`row' = (r(mean)) D`row' = (r(sd)) E`row' = (r(min)) F`row' = (r(max)) ///
using SummaryTables, sheet("T2") modify
loc row = `row'+1
}

corr n_roster avgClassSize
sleep 1000
restore


**** Summary statistics by athletic participation status (Individuals, wave 1)
putexcel A1 = ("Table 3: Sample means by sports status") ///
A2 = ("Variable") B2 = ("N") C2 = ("Sports") D2 = ("No Sports") E2 = ("P-value of difference") ///
using SummaryTables, sheet("T3") modify

loc row = 3
foreach var in white black hispanic other ageD hgcMoth m_hgcMoth hgcFath m_hgcFath ahpvt_std height heightZ heightPct inchesAboveMedian weightLbs n_roster000 avgClassSize {
loc varlab: var label `var'
* qui sum `var' if wave==1 &  sports
* putexcel A`row' = ("`var'") ///
* B`row' = (r(mean)) ///
* using SummaryTables, sheet("T3") modify
* qui sum `var' if wave==1 & ~sports
* putexcel C`row' = (r(mean)) ///
* using SummaryTables, sheet("T3") modify
qui reg `var' sports if wave==1, cluster(scid)
loc mN = `e(N)'
matrix bet  = e(b)'
matrix bvar = vecdiag(e(V))'
matmap bvar bse, map(sqrt(@))
loc m1 = bet[2,1]
loc m2 = bet[1,1]+bet[2,1]
loc td = bet[1,1]/bse[1,1]
loc pv = ttail( `e(df_r)',abs( `td'))*2
putexcel A`row' = ("`var'") B`row' = (`mN') C`row' = (`m2') D`row' = (`m1')  E`row' = (`pv') ///
using SummaryTables, sheet("T3") modify
loc row = `row'+1
sleep 1000
}


**** Summary statistics by athletic participation status (Individuals, wave 4)
putexcel A1 = ("Table 4: Sample Wave IV outcomes by sports status") ///
A2 = ("Variable") B2 = ("N") C2 = ("Sports") D2 = ("No Sports") E2 = ("P-value of difference") ///
using SummaryTables, sheet("T4") modify

loc row = 3
foreach var in grad4yr advDeg lnEarn lnWage hrsCurrJob onlySoft onlyHard bothSoftHard neitherSoftHard stemOcc everCohabitated everMarried hrsCommSvcPastYr oftenVoteLocElection liberality everRegularlySmoked everDrinkAlc everUsedIllegalDrugs everAbusedRxDrugs everArrested  {
loc varlab: var label `var'
* qui sum `var' if wave==1 &  sports
* putexcel A`row' = ("`var'") ///
* B`row' = (r(mean)) ///
* using SummaryTables, sheet("T4") modify
* qui sum `var' if wave==1 & ~sports
* putexcel C`row' = (r(mean)) ///
* using SummaryTables, sheet("T4") modify
qui reg `var' sports if `wave4flagAll', cluster(scid)
loc mN = `e(N)'
matrix bet  = e(b)'
matrix bvar = vecdiag(e(V))'
matmap bvar bse, map(sqrt(@))
loc m1 = bet[2,1]
loc m2 = bet[1,1]+bet[2,1]
loc td = bet[1,1]/bse[1,1]
loc pv = ttail( `e(df_r)',abs( `td'))*2
putexcel A`row' = ("`var'") B`row' = (`mN') C`row' = (`m2') D`row' = (`m1')  E`row' = (`pv') ///
using SummaryTables, sheet("T4") modify
loc row = `row'+1
sleep 1100
}


**** Summary statistics by occupation (Individuals, wave 4)
putexcel A1 = ("Table 4: Sample Wave IV outcomes by sports status") ///
A2 = ("Variable") B2 = ("N") C2 = ("Soft") D2 = ("Hard") E2 = ("Both") F2 = ("Neither")  ///
using SummaryTables, sheet("T5") modify

loc row = 3
foreach var in  sports numSportsIncl0 teenheight teenheightZ teenheightInAbvMed teenheightAboveP75 ahpvt_std lnEarn lnWage hrsCurrJob {
loc varlab: var label `var'
* qui sum `var' if wave==1 &  sports
* putexcel A`row' = ("`var'") ///
* B`row' = (r(mean)) ///
* using SummaryTables, sheet("T4") modify
* qui sum `var' if wave==1 & ~sports
* putexcel C`row' = (r(mean)) ///
* using SummaryTables, sheet("T4") modify
qui reg `var' onlySoft onlyHard bothSoftHard neitherSoftHard if `wave4flagAll', cluster(scid) nocons
loc mN = `e(N)'
matrix bet  = e(b)'
matrix bvar = vecdiag(e(V))'
matmap bvar bse, map(sqrt(@))
loc m1 = bet[1,1]
loc m2 = bet[2,1]
loc m3 = bet[3,1]
loc m4 = bet[4,1]
* loc td = bet[1,1]/bse[1,1]
* loc pv = ttail( `e(df_r)',abs( `td'))*2
putexcel A`row' = ("`var'") B`row' = (`mN') C`row' = (`m1') D`row' = (`m2') E`row' = (`m3') F`row' = (`m4') ///
using SummaryTables, sheet("T5") modify
loc row = `row'+1
sleep 1100
}
*/


**** Summary statistics (Individuals)
tab ageD if wave==1
tab race if wave==1
sum earn if ~mi(lnEarn), d
sum earn if ~mi(lnEarn), d
sum earnCodedFlag if `wave4flag', d
sum lnEarn if `wave4flag', d
sum lnEarn soft hard if `wave4flag'
tab ageD  if `wave4flag'
tab race if `wave4flag'
codebook teenheight if wave==1
codebook teenweight if wave==1

* does school quality affect sports participation?
* reg sports         pctMomCol           if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel replace se addstat(F,e(F)) bdec(3)
* reg sports                   schoolPVT if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel append se addstat(F,e(F)) bdec(3)
* reg sports         pctMomCol schoolPVT if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel append se addstat(F,e(F)) bdec(3)
* reg numSportsIncl0 pctMomCol           if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel append se addstat(F,e(F)) bdec(3)
* reg numSportsIncl0           schoolPVT if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel append se addstat(F,e(F)) bdec(3)
* reg numSportsIncl0 pctMomCol schoolPVT if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel append se addstat(F,e(F)) bdec(3)
* reg numSportsIncl0 pctMomCol schoolPVT if wave==1, cluster(scid)
* qui outreg2 using schoolQuality.xml, excel append se addstat(F,e(F)) bdec(3)

/*
* sports participation (wave I)
qui reg sports q4birth if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel replace se addstat(F,e(F)) bdec(3)
qui reg sports n_roster000 if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports sportsVariety if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheight if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheightZ if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheightAboveP75 if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheightInAbvMed if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheightInAbvMed teenheightAboveP75 if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenweight if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheight heightAbovePeers if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports teenheight teenweight if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerPVT if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports n_roster000 teenheight teenweight q4birth peerPVT if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports peerPVT     teenheight                            if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheightZ                           if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheightAboveP75                    if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheightInAbvMed                    if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheightInAbvMed teenheightAboveP75 if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports heightAbovePeers teenheight teenheightAboveP75     if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports heightAbovePeers teenheight                        if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheight teenheightAboveP75         if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             sportsVariety teenheight              if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheight peerNumSportsIncl0         if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheight peerNumSportsIncl0 i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std if wave==1, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg sports peerFracSports             teenheight teenweight q4birth peerPVT if `wave4flag', cluster(scid)
* qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui predict sportshat if e(sample), xb
qui reg numSports peerNumSports n_roster000 if wave==1 & sports, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg numSports peerNumSports n_roster000 c.teenheight##c.teenheight teenweight q4birth peerPVT if wave==1 & sports, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)
qui reg numSports peerNumSports n_roster000 c.teenheight##c.teenheight teenweight q4birth peerPVT sportsVariety if wave==1 & sports, cluster(scid)
qui outreg2 using firstStage.xml, excel append se addstat(F,e(F)) bdec(3)


local ss0  black hispanic other
local ss1  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ageD
local ss2  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std i.hgc
local ss3  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std
local ss4  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype i.hgc c.adultheightZ
local ss5  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype i.hgc c.adultheightZ c.ahpvt_std##c.ahpvt_std
local ss6  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std i.hgc c.tenure c.potExper##c.potExper
local ss7  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std i.hgc c.tenure c.potExper##c.potExper c.adultheightZ
local ss8  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std i.hgc c.tenure c.potExper##c.potExper sports
local ss9  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std i.hgc c.tenure c.potExper##c.potExper sports c.adultheightZ
local ss10 black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std i.hgc c.tenure c.potExper##c.potExper c.adultheightZ

local s0   black hispanic other
local s1   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ageD
local s2   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std
local s3   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std
local s4   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.adultheightZ
local s5   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.adultheightZ c.ahpvt_std##c.ahpvt_std
local s6   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std
local s7   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std c.adultheightZ
local s8   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std sports
local s9   black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std sports c.adultheightZ
local s10  black hispanic other i.hgcMoth i.hgcFath i.liveWithMoth14 i.liveWithFath14 i.enr i.metro i.qpwht i.schtype c.ahpvt_std##c.ahpvt_std c.adultheightZ

mdesc race hgc*th live*14 ageD ahpvt_std adultheightZ sports hgc tenure potExper peerFracSports teenheightZ enr metro qpwht schtype if `wave4flag'
*/



* **** Within transformation
* foreach var in multSports `vars25labmkt' `outcomes' {
	* capture confirm variable schN_`var'
	* if !_rc {
		* drop schN_`var' sch_`var' FE`var'
	* }
	* qui egen schN_`var' = count(`var') if `wave4flagAll', by(scid)
	* qui egen sch_`var' = mean(`var') if `wave4flagAll', by(scid)
	* qui gen FE`var' = `var'-sch_`var'
* }

* reg FElnWage FEmultSports `FEvars25labmkt' if `wave4flagAll' & schN_lnWage>5, vce(cluster scid)
* areg  lnWage   multSports   `vars25labmkt' if `wave4flagAll', absorb(scid) vce(cluster scid)

* reg FEattCol `FEvars25labmkt' if `wave4flagAll', vce(cluster scid)
* areg  attCol   `vars25labmkt' if `wave4flagAll', absorb(scid) vce(cluster scid)

local conderLM = ""
foreach var in `vars25labmkt' {
	local temp = "!mi(`var')"
	if "`conderLM'"=="" {
		local conderLM `temp'
	}
	else {
		local conderLM = "`conderLM' & `temp'"
	}
}
di "`conderLM'"

local conder = ""
foreach var in `vars25' {
	local temp = "!mi(`var')"
	if "`conder'"=="" {
		local conder `temp'
	}
	else {
		local conder = "`conder' & `temp'"
	}
}
di "`conder'"

* foreach dv in FEsoft FEhard FEstemOcc FEhrsCommSvcPastYr FEoftenVoteLocElection FElnEarn FElnWage FEhrsCurrJob FEattCol FEgrad4yrCondlAttCol FEgrad4yr FEadvDeg FEinLF FEcurrMilitary FEeverRegularlySmoked FEeverDrinkAlc FEeverUsedIllegalDrugs FEeverAbusedRxDrugs FEeverArrested FEeverRiskyPregnant FEageFirstSex FEeverMarried FEeverCohabitated FEoverweight FEobese FEovrwgtObese {
foreach dv in lnWage inLF empPT empFT gradHS attCol grad4yr everRegularlySmoked heavyDrunk numDaysDrunkPastYr everUsedIllegalDrugs everAbusedRxDrugs everArrested everRiskyPregnant ageFirstSex everMarried everCohabitated videoGamer regExercise overweight obese ovrwgtObese {
* local dvNoFE = substr("`dv'",3,.)
* di "`dvNoFE'"

**** Within transformation for each dv
* foreach var in multSports `vars25labmkt' `outcomes' {
	* capture confirm variable schN_`var'
	* if !_rc {
		* drop schN_`var' sch_`var' FE`var'
	* }
	* qui egen schN_`var' = count(`var') if `wave4flagAll' & !mi(`dvNoFE'), by(scid)
	* qui egen sch_`var' = mean(`var') if `wave4flagAll' & !mi(`dvNoFE'), by(scid)
	* qui gen FE`var' = `var'-sch_`var'
* }

qui duplicates report scid if `wave4flagAll' & !mi(`dvNoFE')
local dofcorrection = r(N)/(r(N)-r(unique_value))

if !inlist("`dv'","lnWage","inLF","empPT","empFT") {
		di "Dependent variable is: `dv'"
		regress `dv' multSports          if `conder' & `wave4flagAll', vce(cluster scid)
		est sto simple
		regress `dv' multSports `vars25' if            `wave4flagAll', vce(cluster scid)
		est sto ols
		* areg    `dv' multSports `vars25' if            `wave4flagAll', absorb(scid) vce(cluster scid)
		* est sto arg
		rcr `dv' multSports `vars25' if `conder' & `wave4flagAll', cluster(scid) lambda(-1 0)
		forvalues x=-.5(.05).5 {
			if `x'<0  local bounds = "`x' 0"
			if `x'>=0 local bounds = "0 `x'"
			rcr `dv' multSports `vars25' if `conder' & `wave4flagAll', cluster(scid) lambda(`bounds')
		}
		rcr `dv' multSports `vars25' if `conder' & `wave4flagAll', cluster(scid) lambda(0 1)
		est sto rcr
	}
	else {
		di "Dependent variable is: `dv'"
		regress `dv' multSports                        if `conderLM' & `wave4flagAll', vce(cluster scid)
		est sto simple
		regress `dv' multSports `vars25labmkt' grad4yr if              `wave4flagAll', vce(cluster scid)
		est sto ols
		* areg    `dv' multSports `vars25labmkt' grad4yr if              `wave4flagAll', absorb(scid) vce(cluster scid)
		* est sto arg
		rcr `dv' multSports `vars25labmkt' if `conderLM' & `wave4flagAll', cluster(scid) lambda(-1 0)
		forvalues x=-.5(.05).5 {
			if `x'<0  local bounds = "`x' 0"
			if `x'>=0 local bounds = "0 `x'"
			rcr `dv' multSports `vars25labmkt' if `conderLM' & `wave4flagAll', cluster(scid) lambda(`bounds')
		}
		rcr `dv' multSports `vars25labmkt' if `conderLM' & `wave4flagAll', cluster(scid) lambda(0 1)
	}
	est table simple ols, b(%9.3f) se(%9.3f) stats(N) keep(multSports) title("Table: effects of multSports on `dv'")
}

log close
