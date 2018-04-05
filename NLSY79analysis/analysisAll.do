version 13.0
clear all
set more off
capture log close

global datapath "../NLSY79data/"
log using "analysisAll.log", replace

* qui creturn list
* if "`c(os)'"=="Windows" {
    local arCeeAr rcr
    local arCeeArOpts0 ", lambda(0 .05)"
    local arCeeArOpts1 ", lambda(0 .1)"
    local arCeeArOpts2 ", lambda(0 .15)"
* }
* else {
    * local arCeeAr "qui sum"
    * local arCeeArOpts0 
    * local arCeeArOpts1 
    * local arCeeArOpts2 
* }

set mem 5g
set matsize 11000
set maxvar  32000

log close
do analysis.do
do analysisFemale.do
do analysisStrongAthlete.do
do analysisStrongAthleteFemale.do

