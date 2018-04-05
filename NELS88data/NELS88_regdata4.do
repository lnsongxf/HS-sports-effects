/*   This file will construct the analysis data for the NELS88 sample first stage     */
version 13.1
capture log close
log using NELS88_regdata4.log, replace

use NELS88_short4.dta, clear


/*  Demographic characteristics   */

gen by73 = BIRTHYR == 73
gen by74 = BIRTHYR == 74
gen by75 = BIRTHYR == 75



gen male = SEX == 1
gen female = SEX == 2


gen race_api = RACE == 1
gen race_hisp= RACE == 2
gen race_black = RACE == 3
gen race_white = RACE == 4
gen race_native = RACE == 5


/*  Household Characteristics    */

gen hh_father = BYS8A==1
replace hh_father = . if BYS8A > 2
label var hh_father "Lives with Father (8th grade)"
gen hh_mother = BYS8C==1
replace hh_mother = . if BYS8C > 2
label var hh_mother "Lives with Mother (8th grade)"

gen ed_mother = BYS34B > 4 & BYS34B < 8
replace ed_mother = . if BYS34B >=97
gen ed_father = BYS34A > 4 & BYS34A < 8
replace ed_father = . if BYS34A >=97
label var ed_mother "Mother College Grad"
label var ed_father "Father College Grad"

gen old_sibs = BYP4 > 0
replace old_sibs = . if BYP4 > 90
label var old_sibs "Has Older Sibling(s)"

gen inc_low = BYP80 <=8
gen inc_high = BYP80 >= 12
label var inc_low "Family Income <20K (1988)"
label var inc_high "Family Income >50K (1988)"

/*  gen low_ses = BYSES<-1
replace low_ses = . if low_ses > 99
label var low_ses "Lower Family SES Status (<-1 of composite)"  */

/*  destring BYFAMSIZ, gen(family_size)
replace family_size = . if family_size ==98  */

/*  8th Grade Student Characteristics   */
gen math_irt = BY2XMIRR 
replace math_irt=. if math_irt >99
label var math_irt "Math IRT (8th grade)"

gen read_irt = BY2XRIRR
replace read_irt = . if read_irt > 99
label var read_irt "Reading IRT (8th grade)"

gen frqabsent = BYT1_4 == 1
label var frqabsent "Student Frequently Absent (8th grade)"

gen handicap = BYT1_10 == 1
label var handicap "Student has handicap that affects school work (8th grade)"


/*  Generate high school sports variables   */
/*  Note, if participated on JV or varsity in 1990 or in 1992 counted as participant  */

/*  Note that missing responses are treated as "not participating"   */
/*  However, if student failed to respond to ALL sports questions, then set to "missing" */
/*  Also set to missing if individual was not in the survey */

gen baseball = F1S41AA == 4 | F1S41AA == 5 | F1S41AA == 6 
gen bsktball = F1S41AB == 4 | F1S41AB == 5 | F1S41AB == 6 
gen football = F1S41AC  == 4 | F1S41AC == 5 | F1S41AC == 6
gen soccer = F1S41AD  == 4 | F1S41AD == 5 | F1S41AD == 6 
gen swim = F1S41AE  == 4 | F1S41AE== 5 | F1S41AE == 6 
gen sport_team = F1S41AF  == 4 | F1S41AF== 5 | F1S41AF == 6 
gen sport_indv = F1S41AG  == 4 | F1S41AG == 5 | F1S41AG == 6

gen sport90 = baseball | bsktball | football | soccer | swim | sport_team | sport_indv

gen baseballVarsity   = F1S41AA == 5 | F1S41AA == 6 
gen bsktballVarsity   = F1S41AB == 5 | F1S41AB == 6 
gen footballVarsity   = F1S41AC == 5 | F1S41AC == 6
gen soccerVarsity     = F1S41AD == 5 | F1S41AD == 6 
gen swimVarsity       = F1S41AE == 5 | F1S41AE == 6 
gen sport_teamVarsity = F1S41AF == 5 | F1S41AF == 6 
gen sport_indvVarsity = F1S41AG == 5 | F1S41AG == 6

gen varsity90 = baseballVarsity | bsktballVarsity | footballVarsity | soccerVarsity | swimVarsity | sport_teamVarsity | sport_indvVarsity

gen baseballCaptain   = F1S41AA == 6 
gen bsktballCaptain   = F1S41AB == 6 
gen footballCaptain   = F1S41AC == 6
gen soccerCaptain     = F1S41AD == 6 
gen swimCaptain       = F1S41AE == 6 
gen sport_teamCaptain = F1S41AF == 6 
gen sport_indvCaptain = F1S41AG == 6

gen captain90 = baseballCaptain | bsktballCaptain | footballCaptain | soccerCaptain | swimCaptain | sport_teamCaptain | sport_indvCaptain


replace sport90   = . if F1S41AA == 98 & F1S41AB == 98 & F1S41AC == 98  & F1S41AD == 98 & F1S41AE == 98 & F1S41AF == 98 & F1S41AG == 98
replace sport90   = . if F1S41AA == 99 /*   Not in survey wave in 90, probably redundant  */
replace varsity90 = . if F1S41AA == 98 & F1S41AB == 98 & F1S41AC == 98  & F1S41AD == 98 & F1S41AE == 98 & F1S41AF == 98 & F1S41AG == 98
replace varsity90 = . if F1S41AA == 99 /*   Not in survey wave in 90, probably redundant  */
replace captain90 = . if F1S41AA == 98 & F1S41AB == 98 & F1S41AC == 98  & F1S41AD == 98 & F1S41AE == 98 & F1S41AF == 98 & F1S41AG == 98
replace captain90 = . if F1S41AA == 99 /*   Not in survey wave in 90, probably redundant  */

gen team_92 = F2S30AA == 3 | F2S30AA == 4 | F2S30AA == 5
gen indv_92 = F2S30AB == 3 | F2S30AB == 4 | F2S30AB == 5

gen sport92 = team_92 | indv_92
replace sport92 = . if F2S30AA == 8 & F2S30AB == 8
replace sport92 = . if F2S30AA == 9  /*   Not in survey wave in 92, probably redundant  */

gen varsity_team_92 = F2S30AA == 4 | F2S30AA == 5
gen varsity_indv_92 = F2S30AB == 4 | F2S30AB == 5

gen varsity92 = varsity_team_92 | varsity_indv_92
replace varsity92 = . if F2S30AA == 8 & F2S30AB == 8
replace varsity92 = . if F2S30AA == 9  /*   Not in survey wave in 92, probably redundant  */

gen captain_team_92 = F2S30AA == 4 | F2S30AA == 5
gen captain_indv_92 = F2S30AB == 4 | F2S30AB == 5

gen captain92 = captain_team_92 | captain_indv_92
replace captain92 = . if F2S30AA == 8 & F2S30AB == 8
replace captain92 = . if F2S30AA == 9  /*   Not in survey wave in 92, probably redundant  */

gen sport = sport90 | sport92
replace sport = . if sport90 == . & sport92 == .

gen varsity = varsity90 | varsity92
replace varsity = . if varsity90 == . & varsity92 == .

gen captain = captain90 | captain92
replace captain = . if captain90 == . & captain92 == .

gen cheer90 = F1S41AH == 4 | F2S30AC==5 | F2S30AC == 6
label var cheer90 "Cheerleading (10th grade)"

gen band90 = F1S41BA == 3 | F1S41BA == 4
label var band90 "Participated in band or orchestra (10th grade)"

gen yrbk_news90 = F1S41BE == 3 | F1S41BE == 4
label var yrbk_news90 "Yearbook or newspaper staff (10th grade)"

/*  School Characteristics  */

gen enroll90 = F1SCENRL
replace enroll90 = . if enroll90 == 98
tab enroll90, gen(enr)

gen cont_public = G10CTRL1 == 1
gen cont_catholic = G10CTRL1 == 2
gen cont_religious = G10CTRL1 == 3
gen cont_private = G10CTRL1 == 4 | G10CTRL1==5

tab G10URBAN, gen(urban)

gen coed=F1C10 == 1
replace coed = . if F1C10 == 8 | F1C10 == .

gen tpratio = BYRATIO
replace tpratio = . if BYRATIO == 99


gen nosports = F1C71S == 2
replace nosports = . if F1C71S==8
label var nosports "School does not offer interscholastic sports for 10th graders (1990)"

gen white_low = F1C27F == 1
gen white_med = F1C27F == 2 | F1C27F ==3
gen white_high = F1C27F == 4 | F1C27F ==5
replace white_low = . if F1C27F > 5
replace white_med = . if F1C27F > 5
replace white_high = . if F1C27F > 5

label var white_low "Student body < 25% white (non-hisp)"
label var white_med "Student body between 25 & 75% white (non-hisp)"
label var white_high "Student body more than 75% white (non-hisp)"


gen ap_prcnt = F1C30I 
replace ap_prcnt = . if F1C30I >= 998
label var ap_prcnt "Percent of students who receive AP courses"
replace ap_prcnt = . if F1C30I == 998 | F1C30I == 999

gen avail_band = F1C71B == 1 | F1C71P == 1
gen avail_choir = F1C71C == 1
gen avail_news = F1C71N == 1
gen avail_yrbk = F1C71O == 1

/*  Identifying college major for those who have a BA degree       */

gen major = F4EMJ1D if F4EDGR1 == 3
replace major = F4EMJ2D if F4EDGR2 == 3
replace major = F4EMJ3D if F4EDGR3 == 3
replace major = F4EMJ4D if F4EDGR4 == 3
replace major = F4EMJ5D if F4EDGR5 == 3
replace major = F4EMJ6D if F4EDGR6 == 3

gen stem=0
replace stem = 1 if major < = 40
replace stem = 1 if major == 110 | major == 111 | major ==112
replace stem = 1 if major >=140 & major <= 150
replace stem = 1 if major >= 260 & major <=271
replace stem = 1 if major >= 301 & major <=303
replace stem = 1 if major >= 400 & major <=403
replace stem = 1 if major == 420  /*  Psychology  */
replace stem = 1 if major == 450  /*  Archeology  */
label var stem "Major in STEM field"

gen business = 0
replace business = 1 if major >=60 & major <=80
label var business "Major in Business field"

gen education = 0
replace education = 1 if major >=130 & major <= 135
label var education "Major in Education field"


/*  Adult Outcome Variables  */

gen workft = F4AACTF == 1
replace workft = . if F4AACTF == -2
label var workft "Currently work full time (2000)"

gen occupation = F4BXOCCD
replace occupation = . if F4BXOCCD < 0

gen married = F4GMRS == 2
label var married "Currently married"

gen nevermar = F4GMRS == 1
label var nevermar "Never married"

gen single_parent = F4SGPAR == 1
replace single_parent = . if F4SGPAR == -9
label var single_parent "Respondent is single parent"

gen post_second = F4ATTPSE == 1
replace post_second = . if F4ATTPSE == -9
label var post_second "Attended post-secondary "

gen post_4yr = F4ATT4YR == 1
replace post_4yr = . if F4ATT4YR == -9

gen college_grad = F4TYPEDG == 4 | F4TYPEDG >= 6
replace college_grad = . if F4TYPEDG == -9

gen fit_active = F4IFITNS >2 & F4IFITNS <=7   /*  Fitness activities 3 or more days/week */
replace fit_active = . if F4IFITNS <0

gen binge_drink = F4IBINGE>0    /*  5 or more drinks in a row in last 30 days?  */
replace binge_drink = . if F4IBINGE == -7 | F4IBINGE == -1 | F4IBINGE == -2

gen arrest = ARRESTED == 1
replace arrest = . if ARRESTED < 0

gen inc99 = F4HI99  /*  Wage & salary income in 1999 */
replace inc99 = . if F4HI99 < 0 
replace inc99 = 0 if F4HI99 == -3

/*  Voting behavior as adult  */
gen voter = NATELEC==1 | VOTEPRES==1 | F3VOTED==1 | F4IVPRE==1

/*  Create the "peer" variables to be used in the IV estimation  */

/*  Get number of "peers", male peers, and female peers    */

egen peers = count(STU_ID), by(F1SCH_ID)
egen mpeers = total(male), by(F1SCH_ID)
egen fpeers = total(female), by(F1SCH_ID)

replace peers = peers - 1
replace mpeers = mpeers - male
replace fpeers = fpeers - female

/*  Now get fraction of male peers, female peers, total peers who play sports  */
/*  Assume that missing response to sport participation means no participation */
/*  The fraction of peers is based on 1990 peers.  Can't identify peers in 1992 public use data   */

gen msport = male*sport
gen fsport = female*sport

gen msport90 = male*sport90
gen fsport90 = female*sport90

egen tot_sport = total(sport), by(F1SCH_ID)
egen tot_fsport = total(fsport), by(F1SCH_ID)
egen tot_msport = total(msport), by(F1SCH_ID)

egen tot_sport90 = total(sport90), by(F1SCH_ID)
egen tot_fsport90 = total(fsport90), by(F1SCH_ID)
egen tot_msport90 = total(msport90), by(F1SCH_ID)

gen frac_sport = (tot_sport-sport)/peers
gen frac_msport = (tot_msport-msport)/mpeers
gen frac_fsport = (tot_fsport-fsport)/fpeers

gen frac_sport90 = (tot_sport90-sport90)/peers
gen frac_msport90 = (tot_msport90-msport90)/mpeers
gen frac_fsport90 = (tot_fsport90-fsport90)/fpeers

/*   Other peer activities   */

egen tot_cheer90 = total(cheer90), by(F1SCH_ID)
gen frac_cheer90 = (tot_cheer90 - cheer90)/peers

egen tot_band90 = total(band90), by(F1SCH_ID)
gen frac_band90 = (tot_band90-band90)/peers

egen tot_yrbk90 = total(yrbk_news90), by(F1SCH_ID)
gen frac_yrbk90 = (tot_yrbk90-yrbk_news90)/peers



/*   Select Sample Present in 1988 & 1990 who responded to 4th follow-up    */
/*   Known High School in 1990     */

sum STU_ID 

keep if F1SCH_ID ~= 99999

sum STU_ID

keep if F4UNI2A == 1

sum STU_ID

keep if F4UNI2C == 1 | F4UNI2C == 2

sum STU_ID

keep if F4UNI2D == 1 | F4UNI2D == 2

sum STU_ID

keep if F4IBINGE ~= -7  /*  Drop partial interviews  */

sum STU_ID

keep if SEX ~= 9
keep if RACE ~= 8
drop if BIRTHYR == 98

sum STU_ID

drop if math_irt == . | read_irt == .

sum STU_ID

drop if hh_mother == . | hh_father == . | ed_father==. | ed_mother == .

sum STU_ID

save NELS88regdataXT4.dta, replace

drop if enr2 == .



sum STU_ID

keep if sport ~=. 


save NELS88regdata4.dta, replace

log close
