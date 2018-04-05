capture log close

global datapath "../NLSY79data/"
log using "analysisStrongAthlete.log", replace

* qui creturn list
* if "`c(os)'"=="Windows" {
    local arCeeAr rcr
    local arCeeArOpts0  ", lambda(0 .05)"
    local arCeeArOpts1  ", lambda(0 .1)"
    local arCeeArOpts2  ", lambda(0 .15)"
    local arCeeArOpts3  ", lambda(0 .2)"
    local arCeeArOpts4  ", lambda(0 .25)"
    local arCeeArOpts5  ", lambda(0 .3)"
    local arCeeArOpts6  ", lambda(0 .35)"
    local arCeeArOpts7  ", lambda(0 .4)"
    local arCeeArOpts8  ", lambda(0 .45)"
    local arCeeArOpts9  ", lambda(0 .5)"
    local arCeeArOpts10 ", lambda(0  1)"
    local arCeeArOpts11 ", lambda(-1 0)"
* }
* else {
    * local arCeeAr "qui sum"
    * local arCeeArOpts0 
    * local arCeeArOpts1 
    * local arCeeArOpts2 
    * local arCeeArOpts3 
    * local arCeeArOpts4 
    * local arCeeArOpts5 
    * local arCeeArOpts6 
    * local arCeeArOpts7 
    * local arCeeArOpts8 
    * local arCeeArOpts9 
    * local arCeeArOpts10
    * local arCeeArOpts11
* }


**************************************************
* Load data and run some preliminary analyses
**************************************************
! unzip -o -: ../NLSY79data/master.dta.zip
! rm -f master.dta
use ../NLSY79data/master.dta, clear
! zip -u ../NLSY79data/master.dta.zip ../NLSY79data/master.dta

gen teenheightA = height if year==1981  
bys id (year): egen teenheight = mean(teenheightA )
drop teenheightA
gen adultheightA = height if year==1985
bys id (year): egen adultheight = mean(adultheightA )
drop adultheightA
gen teenweightA = weight if year==1981  
bys id (year): egen teenweight = mean(teenweightA )
drop teenweightA
gen q4birth = birthq==4

* keep if birthyr>1961

mdesc strongAthlete hgc gradHS grad4yr lnfamInc78 m_famInc1978 exper commOrg hobbyClub studentCouncil yrbookPaper performArts nhs otherClub no_clubs hgc*th m_hgc*th *asvab?? rotter_score if age==25

**************************************************
* Generate data for rcr
**************************************************
gen m_rott = mi(rotter_score)
recode rotter_score (. .d .i .r = 0)

gen hgc2   = hgc^2/100

gen exper2 = exper^2/100
gen exper3 = exper^3/1000

gen afqt2  = afqt^2/10
gen rott2  = rotter_score^2/10

gen attCol = inrange(hgc,13,25) if !missInt
capture drop black
gen black  = race==2
* capture drop other
gen other  = race==3 | race==4

* Athlete interactions
foreach var of varlist black other nhs hgc*th afqt rotter_score m_afqt m_rott liveWithMom14 femaleHeadHH14 born1958-born1964 hgc gradHS grad4yr exper {
    gen athX`var' = strongAthlete*`var'
}

local depvars gradHS attCol grad4yr lnwage empPT empFT overweight obese ovrwgtObese
local basevars   black other hgc*th m_hgc*th lnfamInc78 m_famInc1978 afqt afqt2 m_afqt rotter_score rott2 m_rott liveWithMom14 femaleHeadHH14 born1958-born1964
local basevars25 `basevars'
local basevars30 black other hgc*th m_hgc*th lnfamInc78 m_famInc1978 afqt afqt2 m_afqt rotter_score rott2 m_rott liveWithMom14 femaleHeadHH14 born1958-born1963
local basevars35 black other hgc*th m_hgc*th lnfamInc78 m_famInc1978 afqt afqt2 m_afqt rotter_score rott2 m_rott liveWithMom14 femaleHeadHH14 born1958
local labmktvs25 `basevars25'
local labmktvs30 `basevars30'
local labmktvs35 `basevars35'

preserve
    drop if female
    *===================================================
    * Summary statistics for descriptive stats tables
    *===================================================
    foreach var of varlist athlete strongAthlete white black other m_hgcMoth m_hgcFath m_famInc1978 liveWithMom14 born1957 born1958 born1959 born1960 born1961 born1962 born1963 born1964 gradHS grad4yr attCol empFT obese {
        gen `var'_100 = 100*`var'
    }

    qui clonevar tempafqt       = afqt
    qui clonevar temprotter     = rotter
    qui clonevar tempexper      = exper
    qui clonevar temphgc        = hgc
    qui clonevar temphgcMoth    = hgcMoth
    qui clonevar temphgcFath    = hgcFath
    qui clonevar templnwage     = lnwage
    qui clonevar templnfamInc78 = lnfamInc78
    qui replace  tempafqt       = . if m_afqt
    qui replace  temprotter     = . if m_rott
    qui replace  tempexper      = . if mi(exper)
    qui replace  temphgc        = . if mi(hgc)
    qui replace  temphgcMoth    = . if m_hgcMoth
    qui replace  temphgcFath    = . if m_hgcFath
    qui replace  templnwage     = . if mi(lnwage)
    qui replace  templnfamInc78 = . if m_famInc1978

    qui ds *_100
    local discretevars `r(varlist)'

    local contvars tempafqt temprotter temppotExper temphgc temphgcMoth temphgcFath templnwage templnfamInc78 tempexper

    lab var white_100         "White"
    lab var black_100         "Black"
    lab var other_100         "Other"
    lab var m_hgcMoth_100     "missing Mother's education"
    lab var m_hgcFath_100     "missing Father's education"
    lab var m_famInc1978_100  "missing family income"
    lab var liveWithMom14_100 "missing maternal coresidence"
    lab var born1957_100      "Born in 1957"
    lab var born1958_100      "Born in 1958"
    lab var born1959_100      "Born in 1959"
    lab var born1960_100      "Born in 1960"
    lab var born1961_100      "Born in 1961"
    lab var born1962_100      "Born in 1962"
    lab var born1963_100      "Born in 1963"
    lab var born1964_100      "Born in 1964"
    lab var gradHS_100        "Graduated high school"
    lab var attCol_100        "Attended college"
    lab var grad4yr_100       "Graduated 4-year college"
    lab var empFT_100         "Employed full-time"
    lab var obese_100         "Obese"

    capture lab var tempafqt       "AFQT score"
    capture lab var temprotter     "Rotter score"
    capture lab var tempexper      "Experience"
    capture lab var temphgc        "Years of education"
    capture lab var temphgcMoth    "Mother's years of education"
    capture lab var temphgcFath    "Father's years of education"
    capture lab var templnwage     "Log wage"
    capture lab var templnfamInc78 "Family income"

    *-----------------------------------------
    * Create summary stats tables
    *-----------------------------------------
    qui ds athlete_100 strongAthlete_100 tempafqt temprotter white_100 black_100 other_100 temphgcMoth m_hgcMoth_100 temphgcFath m_hgcFath_100 templnfamInc78 m_famInc1978_100 liveWithMom14_100 born1957_100 born1958_100 born1959_100 born1960_100 born1961_100 born1962_100 born1963_100 born1964_100 tempexper temphgc gradHS_100 attCol_100 grad4yr_100 templnwage empFT_100 obese_100
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
            qui sum `var' if age==25, d
            local temp: di %3.2f `r(mean)'
            qui replace holderOverall = "`temp'" if _n==`i'
            qui ttest `var' if age==25, by(strongAthlete)
            qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
            foreach a in 0 1 {
                qui sum `var' if age==25 & strongAthlete==`a', d
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
            qui sum `var' if age==25, d
            local temp1: di %3.2f `r(mean)'
            local temp2: di %3.2f `r(sd)'
            qui replace holderOverall = "`temp1'"   if _n==`i'
            qui replace holderOverall = "(`temp2')" if _n==`=`i'+1'
            qui ttest `var' if age==25, by(strongAthlete)
            qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
            foreach a in 0 1 {
                qui sum `var' if age==25 & strongAthlete==`a', d
                local temp1: di %3.2f `r(mean)'
                local temp2: di %3.2f `r(sd)'
                qui replace holderAthlete`a' = "`temp1'"   if _n==`i'
                qui replace holderAthlete`a' = "(`temp2')" if _n==`=`i'+1'
            }
            local i = `=`i'+2'
        }
        * Sample Sizes
        qui replace holderName = "N" if _n==`i'
        qui count if age==25
        local tempN: di %9.0fc `r(N)'
        qui replace holderOverall = "`tempN'" if _n==`i'
        foreach a in 0 1 {
            qui count if age==25 & strongAthlete==`a'
            local tempN: di %9.0fc `r(N)'
            qui replace holderAthlete`a' = "`tempN'" if _n==`i'
        }
    }

    * Add asterisk if athletes are significantly different from non-athletes
    replace holderAthlete1 = "$"+holderAthlete1+"^{\ast}$" if holderOverallPflag==1

    qui listtex holderName holderAthlete0 holderAthlete1 holderOverall in 1/`=`i'' using sumStatsTableStrongAthlete.tex, replace delimiter(" & ") end ("   \tabularnewline")

    drop *_100
restore

sum voter if year==2012 & !female & strongAthlete==1
sum voter if year==2012 & !female & strongAthlete==0
sum voter if year==2012 & !female

preserve
    drop if female
    foreach depvar in `depvars' {
        di "      "
        di "      "
        di "      "
        di "      "
        di "      "
        di "      "

        if "`depvar'"=="lnwage" | "`depvar'"=="empPT" | "`depvar'"=="empFT"  {
            foreach a in 25 30 35 {
                di "********************"
                di "         "
                di " Age `a' "
                di "         "
                di "********************"
                regress   `depvar' strongAthlete               if age==`a'
                est sto simple
                regress   `depvar' strongAthlete `labmktvs`a'' if age==`a'
                est sto ols
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts0'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts1'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts2'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts3'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts4'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts5'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts6'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts7'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts8'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts9'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts10'
                `arCeeAr' `depvar' strongAthlete `labmktvs`a'' if age==`a' `arCeeArOpts11'
                est table simple ols, b(%9.3f) stats(N) keep(strongAthlete) title("Table: effects of strongAthlete on `depvar' at age `a'")
            }
        }
        else if "`depvar'"=="overweight" | "`depvar'"=="obese" | "`depvar'"=="ovrwgtObese"  {
            foreach a in 25 30 35 {
                di "********************"
                di "         "
                di " Age `a' "
                di "         "
                di "********************"
                regress   `depvar' strongAthlete               if age==`a'
                est sto simple
                regress   `depvar' strongAthlete `basevars`a''    if age==`a'
                est sto ols
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts0'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts1'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts2'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts3'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts4'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts5'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts6'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts7'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts8'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts9'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts10'
                `arCeeAr' `depvar' strongAthlete `basevars`a''    if age==`a' `arCeeArOpts11'
                est table simple ols, b(%9.3f) stats(N) keep(strongAthlete) title("Table: effects of strongAthlete on `depvar' at age `a'")
            }
        }
        else {
            regress   `depvar' strongAthlete                if age==25
            est sto simple
            regress   `depvar' strongAthlete `basevars'     if age==25
            est sto ols
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts0'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts1'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts2'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts3'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts4'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts5'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts6'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts7'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts8'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts9'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts10'
            `arCeeAr' `depvar' strongAthlete `basevars'     if age==25 `arCeeArOpts11'
            est table simple ols, b(%9.3f) stats(N) keep(strongAthlete) title("Table: effects of strongAthlete on `depvar'")
        }
        di "      "
        di "      "
        di "      "
        di "      "
        di "      "
        di "      "
    }
    
    
    
    
    
    
            regress   voter strongAthlete                if year==2012
            est sto simple
            regress   voter strongAthlete `basevars'     if year==2012
            est sto ols
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts0'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts1'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts2'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts3'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts4'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts5'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts6'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts7'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts8'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts9'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts10'
            `arCeeAr' voter strongAthlete `basevars'     if year==2012 `arCeeArOpts11'
            est table simple ols, b(%9.3f) stats(N) keep(strongAthlete) title("Table: effects of strongAthlete on voter")
restore



log close
