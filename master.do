version 13.1
clear all
set more off
capture log close


cd NLSY79data
*------------------------------
* NLSY79 data processing
*------------------------------
do import_all
do create_master


cd ../NLSY79analysis
*------------------------------
* NLSY79 data analysis
*------------------------------
do analysis
do analysisFemale
do analysisStrongAthlete       // robustness check for young men whose "main activity" was sports
do analysisStrongAthleteFemale // robustness check for young women whose "main activity" was sports


cd ../NELS88data
*------------------------------
* NELS88 data processing
*------------------------------
do NELS88_readin
do NELS88_regdata4


cd ../NELS88analysis
*------------------------------
* NELS88 data analysis
*------------------------------
do NELS88reg05_a
do NELS88reg05_capt      // robustness check for captains
do NELS88reg05_varsity   // robustness check for varsity athletes
do NELS88reg05_hetblack  // robustness check for heterogeneity among African-American young men

/*
cd ../AddHealthData
*------------------------------
* Add Health data processing
*------------------------------
do cr_all_nowgt


cd ../AddHealthAnalysis
*------------------------------
* Add Health data analysis
*------------------------------
do analysis
do analysisFemale
do analysisMult       // robustness check for young men who reported participating in multiple sports
do analysisMultFemale // robustness check for young women who reported participating in multiple sports
*/