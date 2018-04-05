version 11.1
clear all
set more off
capture log close

log using "import_all.log", replace

set mem 5g
set maxvar 32000

**********************************************************
* Import and save the data
**********************************************************
* Demographics
do import_demog.do
sort id year
compress
save demog_raw.dta, replace
! zip -u demog_raw.dta.zip demog_raw.dta

* School
do import_school.do
sort id year
compress
save school_raw.dta, replace
! zip -u school_raw.dta.zip school_raw.dta

* Work
do import_work.do
sort id year
compress
save work_raw.dta, replace
! zip -u work_raw.dta.zip work_raw.dta


***********************************
* Merge the data and save the data
***********************************
use demog_raw, clear
merge 1:1 id year using school_raw
assert _merge==3
drop _merge
merge 1:1 id year using work_raw
assert _merge==3
drop _merge

***********************************
* Merge the IQ test score data
***********************************
preserve
    tempfile afqtdata
    use AFQT_MATCHING/afqt_adjusted_final79, clear
    ren ID id
    keep id afqt_std
    zscore afqt_std
    ren z_afqt_std afqt
    keep id afqt
    save `afqtdata'
restore
merge     m:1 id using `afqtdata', keepusing(id afqt)
assert    _merge!=2
drop      _merge

foreach test in AR CS MK NO PC WK {
    preserve
        tempfile asvab`test'data
        use AFQT_MATCHING_`test'/afqt_adjusted_final79, clear
        ren ID id
        keep id asvab`test'_std
        zscore asvab`test'_std
        ren z_asvab`test'_std asvab`test'
        keep id asvab`test'
        save `asvab`test'data'
    restore
    merge     m:1 id using `asvab`test'data', keepusing(id asvab`test')
    assert    _merge!=2
    drop      _merge
}

compress
save raw.dta, replace
! zip -u raw.dta.zip raw.dta

log close
