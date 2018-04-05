* create outcomes for the main job in each year: (if someone is working multiple jobs, break ties with lower numbered job
egen numIntWeekJobs = rowtotal(intWeekWorking*)
* replace intWeekWorking

gen wage  = .
gen hours = .
gen occ   = .
gen ind   = .
gen class = .
forvalues x=59(-1)1 {
	qui replace wage  = wage`x'  if intWeekWorking`x'==1
	qui replace hours = hours`x' if intWeekWorking`x'==1
	qui replace occ   = occ`x'   if intWeekWorking`x'==1
	qui replace ind   = ind`x'   if intWeekWorking`x'==1
	qui replace class = class`x' if intWeekWorking`x'==1
}
generat selfemp = class==3

qui replace wage  = wksWorkLastYr if wksWorkLastYr>=.
qui replace hours = wksWorkLastYr if wksWorkLastYr>=.
qui replace occ   = wksWorkLastYr if wksWorkLastYr>=.
qui replace ind   = wksWorkLastYr if wksWorkLastYr>=.
qui replace class = wksWorkLastYr if wksWorkLastYr>=.


* top- and bottom-code wages at $2 and $50
local top_limit 7500
local bot_limit 200
sum wage, d
qui replace wage = `top_limit' if wage>=`top_limit' & ~mi(wage)
qui replace wage = `bot_limit' if wage<=`bot_limit' & ~mi(wage)
sum wage, d

* Deflate wages, create log wage
qui generat wagereal = wage/(100*cpi)
qui generat lnwage   = ln(wagereal)
qui replace lnwage = occ if lnwage>=. & occ>=.

* Work experience
gen empFT    = inrange(wksWorkLastYr,40.01,.) & inrange(hours,34.01,.)
gen empPT    = (inrange(wksWorkLastYr,0,40) & inrange(hours,0,.)) | (inrange(hours,0,34) & inrange(wksWorkLastYr,0,.))
bys id (wave): generat exper = sum(L.empFT)+.5*sum(L.empPT)

replace empFT = . if !mi(reason_noninterview)
replace empPT = . if !mi(reason_noninterview)

* Vote behavior
generat voter = inlist(vote,3,4)
replace voter = vote if mi(vote)

lab var lnwage   "Log hourly wage, in 1982-84 $"
lab var exper    "Work experience (cum. # years 40+ weeks worked)"
lab var hours    "Usual hours per week at main job"
lab var occ      "Occupation of main job"
lab var ind      "Industry of main job"
lab var class    "Class of main job"
lab var selfemp  "Dummy for whether main job is self-employed"

** Variables to keep:
global keeperwork lnwage exper hours empPT empFT occ ind class hours* occ* wage* intWeekWorking* selfemp numIntWeekJobs wksWorkLastYr voter
