version 13.1
clear all
set more off
capture log close

/* Change working directory */
* cd "C:\Users\mrr2\Research Files\Sports&Occupation\NELS88"

log using NELS88reg05_capt.log, replace

/* Increase memory size to allow for dataset */

set maxvar 10000

/* Open Stata dataset */
use ../NELS88data/NELS88regdata4.dta
gen by72 = BIRTHYR==1972
gen race_other = race_native==1 | race_api==1
gen tot_irt = math_irt + read_irt


preserve
    ren captain athlete
    drop race_native race_api
    gen loginc = log(inc99)
    drop if female
    *===================================================
    * Summary statistics for descriptive stats tables
    *===================================================

    foreach var of varlist athlete by* race_* hh_* ed_* inc_* frqabsent handicap enr? cont_* urban? college_grad post_second loginc workft fit_active binge_drink voter {
        gen `var'_100 = 100*`var'
    }

    qui clonevar tempirt = tot_irt
    qui clonevar temploginc   = loginc
    qui replace  temploginc   = . if mi(loginc)

    qui ds *_100
    local discretevars `r(varlist)'

    local contvars tempirt temploginc

    lab var race_white_100         "White"
    lab var race_black_100         "Black"
    lab var race_hisp_100          "Hispanic"
    lab var race_other_100         "Other"
    lab var ed_mother_100          "Mother: college degree or higher"
    lab var ed_father_100          "Father: college degree or higher"
    lab var hh_mother_100          "Coresidence with Mother"
    lab var hh_father_100          "Coresidence with Father"
    lab var inc_high_100           "Family income > 50k"
    lab var inc_low_100            "Family income < 20k"
    lab var by72_100               "Born in 1972"
    lab var by73_100               "Born in 1973"
    lab var by74_100               "Born in 1974"
    lab var by75_100               "Born in 1975"
    lab var frqabsent_100           "Frequently absent"
    lab var handicap_100           "Has handicap"
    lab var enr1_100               "School size decile 1"
    lab var enr2_100               "School size decile 2"
    lab var enr3_100               "School size decile 3"
    lab var enr4_100               "School size decile 4"
    lab var enr5_100               "School size decile 5"
    lab var enr6_100               "School size decile 6"
    lab var enr7_100               "School size decile 7"
    lab var enr8_100               "School size decile 8"
    lab var enr9_100               "School size decile 9"
    lab var cont_public_100        "Public school"
    lab var cont_catholic_100      "Catholic school"
    lab var cont_religious_100     "Non-Catholic religious school"
    lab var cont_private_100       "Non-religious private school"
    lab var urban1_100              "Urbanicity quintile 1"
    lab var urban2_100              "Urbanicity quintile 2"
    lab var urban3_100              "Urbanicity quintile 3"
    lab var urban4_100              "Urbanicity quintile 4"
    lab var urban5_100              "Urbanicity quintile 5"
    lab var post_second_100        "Attended college"
    lab var college_grad_100       "Graduated 4-year college"
    lab var workft_100             "Employed full-time"
    lab var binge_drink_100        "Alcohol abuse"
    lab var voter_100              "Voter"
    lab var fit_active_100         "Regular exercise"
    capture lab var tempirt        "Colmbined IRT score"
    capture lab var temploginc     "Log income"

    *-----------------------------------------
    * Create summary stats tables
    *-----------------------------------------
    qui ds athlete_100 tempirt race_white_100 race_black_100 race_hisp_100 race_other_100 ed_mother_100 ed_father_100 inc_low_100 inc_high_100 hh_mother_100 hh_father_100 by72_100 by73_100 by74_100 by75_100 frqabsent_100 handicap_100 enr1_100 enr2_100 enr3_100 enr4_100 enr5_100 enr6_100 enr7_100 enr8_100 enr9_100 cont_public_100 cont_catholic_100 cont_religious_100 cont_private_100 urban1_100 urban2_100 urban3_100 urban4_100 urban5_100 post_second_100 college_grad_100 temploginc workft_100 fit_active_100 binge_drink_100 voter_100
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
            qui sum `var' , d
            local temp: di %3.2f `r(mean)'
            qui replace holderOverall = "`temp'" if _n==`i'
            qui ttest `var' , by(athlete)
            qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
            foreach a in 0 1 {
                qui sum `var'  if athlete==`a', d
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
            qui sum `var' , d
            local temp1: di %3.2f `r(mean)'
            local temp2: di %3.2f `r(sd)'
            qui replace holderOverall = "`temp1'"   if _n==`i'
            qui replace holderOverall = "(`temp2')" if _n==`=`i'+1'
            qui ttest `var' , by(athlete)
            qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
            foreach a in 0 1 {
                qui sum `var' if athlete==`a', d
                local temp1: di %3.2f `r(mean)'
                local temp2: di %3.2f `r(sd)'
                qui replace holderAthlete`a' = "`temp1'"   if _n==`i'
                qui replace holderAthlete`a' = "(`temp2')" if _n==`=`i'+1'
            }
            local i = `=`i'+2'
        }
        * Sample Sizes
        qui replace holderName = "N" if _n==`i'
        qui count 
        local tempN: di %9.0fc `r(N)'
        qui replace holderOverall = "`tempN'" if _n==`i'
        foreach a in 0 1 {
            qui count if athlete==`a'
            local tempN: di %9.0fc `r(N)'
            qui replace holderAthlete`a' = "`tempN'" if _n==`i'
        }
    }

    * Add asterisk if athletes are significantly different from non-athletes
    replace holderAthlete1 = "$"+holderAthlete1+"^{\ast}$" if holderOverallPflag==1

    qui listtex holderName holderAthlete0 holderAthlete1 holderOverall in 1/`=`i'' using sumStatsTableCapt.tex, replace delimiter(" & ") end ("   \tabularnewline")

    drop *_100
restore

preserve
    ren sport athlete
    drop race_native race_api
    gen loginc = log(inc99)
    drop if !female
    *===================================================
    * Summary statistics for descriptive stats tables
    *===================================================

    foreach var of varlist athlete by* race_* hh_* ed_* inc_* frqabsent handicap enr? cont_* urban? college_grad post_second loginc workft fit_active binge_drink voter {
        gen `var'_100 = 100*`var'
    }

    qui clonevar tempirt = tot_irt
    qui clonevar temploginc   = loginc
    qui replace  temploginc   = . if mi(loginc)

    qui ds *_100
    local discretevars `r(varlist)'

    local contvars tempirt temploginc

    lab var race_white_100         "White"
    lab var race_black_100         "Black"
    lab var race_hisp_100          "Hispanic"
    lab var race_other_100         "Other"
    lab var ed_mother_100          "Mother: college degree or higher"
    lab var ed_father_100          "Father: college degree or higher"
    lab var hh_mother_100          "Coresidence with Mother"
    lab var hh_father_100          "Coresidence with Father"
    lab var inc_high_100           "Family income > 50k"
    lab var inc_low_100            "Family income < 20k"
    lab var by72_100               "Born in 1972"
    lab var by73_100               "Born in 1973"
    lab var by74_100               "Born in 1974"
    lab var by75_100               "Born in 1975"
    lab var frqabsent_100           "Frequently absent"
    lab var handicap_100           "Has handicap"
    lab var enr1_100               "School size decile 1"
    lab var enr2_100               "School size decile 2"
    lab var enr3_100               "School size decile 3"
    lab var enr4_100               "School size decile 4"
    lab var enr5_100               "School size decile 5"
    lab var enr6_100               "School size decile 6"
    lab var enr7_100               "School size decile 7"
    lab var enr8_100               "School size decile 8"
    lab var enr9_100               "School size decile 9"
    lab var cont_public_100        "Public school"
    lab var cont_catholic_100      "Catholic school"
    lab var cont_religious_100     "Non-Catholic religious school"
    lab var cont_private_100       "Non-religious private school"
    lab var urban1_100              "Urbanicity quintile 1"
    lab var urban2_100              "Urbanicity quintile 2"
    lab var urban3_100              "Urbanicity quintile 3"
    lab var urban4_100              "Urbanicity quintile 4"
    lab var urban5_100              "Urbanicity quintile 5"
    lab var post_second_100        "Attended college"
    lab var college_grad_100       "Graduated 4-year college"
    lab var workft_100             "Employed full-time"
    lab var binge_drink_100        "Alcohol abuse"
    lab var voter_100              "Voter"
    lab var fit_active_100         "Regular exercise"
    capture lab var tempirt        "Colmbined IRT score"
    capture lab var temploginc     "Log income"

    *-----------------------------------------
    * Create summary stats tables
    *-----------------------------------------
    qui ds athlete_100 tempirt race_white_100 race_black_100 race_hisp_100 race_other_100 ed_mother_100 ed_father_100 inc_low_100 inc_high_100 hh_mother_100 hh_father_100 by72_100 by73_100 by74_100 by75_100 frqabsent_100 handicap_100 enr1_100 enr2_100 enr3_100 enr4_100 enr5_100 enr6_100 enr7_100 enr8_100 enr9_100 cont_public_100 cont_catholic_100 cont_religious_100 cont_private_100 urban1_100 urban2_100 urban3_100 urban4_100 urban5_100 post_second_100 college_grad_100 temploginc workft_100 fit_active_100 binge_drink_100 voter_100
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
            qui sum `var' , d
            local temp: di %3.2f `r(mean)'
            qui replace holderOverall = "`temp'" if _n==`i'
            qui ttest `var' , by(athlete)
            qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
            foreach a in 0 1 {
                qui sum `var' if athlete==`a', d
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
            qui sum `var' , d
            local temp1: di %3.2f `r(mean)'
            local temp2: di %3.2f `r(sd)'
            qui replace holderOverall = "`temp1'"   if _n==`i'
            qui replace holderOverall = "(`temp2')" if _n==`=`i'+1'
            qui ttest `var' , by(athlete)
            qui replace holderOverallPflag = (`r(p)'<.05) if _n==`i'
            foreach a in 0 1 {
                qui sum `var' if athlete==`a', d
                local temp1: di %3.2f `r(mean)'
                local temp2: di %3.2f `r(sd)'
                qui replace holderAthlete`a' = "`temp1'"   if _n==`i'
                qui replace holderAthlete`a' = "(`temp2')" if _n==`=`i'+1'
            }
            local i = `=`i'+2'
        }
        * Sample Sizes
        qui replace holderName = "N" if _n==`i'
        qui count 
        local tempN: di %9.0fc `r(N)'
        qui replace holderOverall = "`tempN'" if _n==`i'
        foreach a in 0 1 {
            qui count if athlete==`a'
            local tempN: di %9.0fc `r(N)'
            qui replace holderAthlete`a' = "`tempN'" if _n==`i'
        }
    }

    * Add asterisk if athletes are significantly different from non-athletes
    replace holderAthlete1 = "$"+holderAthlete1+"^{\ast}$" if holderOverallPflag==1

    qui listtex holderName holderAthlete0 holderAthlete1 holderOverall in 1/`=`i'' using sumStatsTableCaptFemale.tex, replace delimiter(" & ") end ("   \tabularnewline")

    drop *_100
restore




xtset F1SCH_ID

/*  Higher Ed Analysis  */

reg college_grad captain if female, rob clust(F1SCH_ID)

reg college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg college_grad captain if male, rob clust(F1SCH_ID)

reg college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)
rcr college_grad captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID)


/*  Attend post-secondary education */

reg post_second captain if female, rob clust(F1SCH_ID)

reg post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg post_second captain if male, rob clust(F1SCH_ID)

reg post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)
rcr post_second captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID)


/*  Fitness Activity Analysis  */

reg fit_active captain if female, rob clust(F1SCH_ID)

reg fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg fit_active captain if male, rob clust(F1SCH_ID)

reg fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)

preserve
rcr fit_active captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) details

rcrplot, xrange(-.4 .4) yrange(-5 5)

graph export NELSmaleFitRCRplot.eps, replace
restore


/*  Binge Drinking Analysis  */

reg binge_drink captain if female, rob clust(F1SCH_ID)

reg binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg binge_drink captain if male, rob clust(F1SCH_ID)

reg binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)
rcr binge_drink captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID)

/*   Income and work Analysis   */

reg workft captain if female, rob clust(F1SCH_ID)

reg workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg workft captain if male, rob clust(F1SCH_ID)

reg workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)
rcr workft captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID)

gen loginc = log(inc99)

reg loginc captain if female, rob clust(F1SCH_ID)

reg loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg loginc captain if male, rob clust(F1SCH_ID)

reg loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)
rcr loginc captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID)

/*  Voter Analysis  */

reg voter captain if female, rob clust(F1SCH_ID)

reg voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, rob clust(F1SCH_ID)

rcr voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(-1 0)
rcr voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID) lambda(0 .5)
rcr voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if female, clust(F1SCH_ID)

reg voter captain if male, rob clust(F1SCH_ID)

reg voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, rob clust(F1SCH_ID)

rcr voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(-1 0)
rcr voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID) lambda(0 .5)
rcr voter captain by73-by75 race_native race_black race_hisp race_api hh_* ed_*  inc_low inc_high math_irt read_irt frqabsent handicap enr2-enr9 cont_catholic cont_religious cont_private urban2 urban3 urban4   if male, clust(F1SCH_ID)

log close
