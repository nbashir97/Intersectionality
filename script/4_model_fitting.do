******************************
*** Intersectionality CDOE ***
******************************

** Do-File 4: Model fitting **

* Steps:
* 1. Computing weights
* 2. Fitting models (unweighted and weighted)
* 3. Computing median odds ratio
* 4. Computing AUC
* 5. Computing VPC (ICC)
* 6. Computing PCV

****************************************************************

** Self reported oral health (2009-2018)

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

generate wgt_sroh_dent = wtmec2yr / 5
generate wgt2 = 1

sort group
gen sq_wgt = wgt_sroh_dent * wgt_sroh_dent
by group: egen sum_wgt = sum(wgt_sroh_dent)
by group: egen sum_sqw = sum(sq_wgt)
gen wgt1 = wgt_sroh_dent * sum_wgt / sum_sqw
svyset group, weight(wgt2) || _n, weight(wgt1)

* Model 1A
** Unweighted: melogit health if(included_health == 1) || group:, or
** Weighted: svy, subpop(if included_health == 1): melogit health || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_health == 1)
roctab health probability if(included_health == 1)
quietly: drop probability
estat icc

* Model 1B
** Unweighted: melogit health i.age i.year if(included_health == 1) || group:, or
** Weighted: svy, subpop(if included_health == 1): melogit health i.age i.year || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_health == 1), fixedonly
roctab health probability if(included_health == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (10.04 - 9.40) / 9.40
** Weighted PCV: di (10.05 - 8.93) / 8.93

* Model 2A
** Unweighted: melogit health i.sex i.race i.income i.birth if(included_health == 1) || group:, or
** Weighted: svy, subpop(if included_health == 1): melogit health i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_health == 1), fixedonly
roctab health probability if(included_health == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (1.19 - 9.40) / 9.40
** Weighted PCV: di (1.30 - 8.93) / 8.93

* Model 2B
** Unweighted: melogit health i.age i.year i.sex i.race i.income i.birth if(included_health == 1) || group:, or
** Weighted: svy, subpop(if included_health == 1): melogit health i.age i.year i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_health == 1), fixedonly
roctab health probability if(included_health == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (1.06 - 9.40) / 9.40
** Weighted PCV: di (1.13 - 8.93) / 8.93

****************************************************************

** Dentition (2009-2018)

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

generate wgt_sroh_dent = wtmec2yr / 5
generate wgt2 = 1

sort group
gen sq_wgt = wgt_sroh_dent * wgt_sroh_dent
by group: egen sum_wgt = sum(wgt_sroh_dent)
by group: egen sum_sqw = sum(sq_wgt)
gen wgt1 = wgt_sroh_dent * sum_wgt / sum_sqw
svyset group, weight(wgt2) || _n, weight(wgt1)

* Make 40-49 the reference group for age as ORs become very large otherwise

generate age_recode = age
replace age_recode = 1 if(age == 3)
replace age_recode = 2 if(age == 1)
replace age_recode = 3 if(age == 2)

label define recode_lab 1 "40-49" 2 "20-29" 3 "30-39" 4 "50-59" 5 "60-69" 6 "70+"
label values age_recode recode_lab

* Model 1A
** Unweighted: melogit health if(included_dentition == 1) || group:, or
** Weighted: svy, subpop(if included_dentition == 1): melogit dentition || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_dentition == 1)
roctab dentition probability if(included_dentition == 1)
quietly: drop probability
estat icc

* Model 1B
** Unweighted: melogit dentition i.age_recode i.year if(included_dentition == 1) || group:, or
** Weighted: svy, subpop(if included_dentition == 1): melogit dentition i.age i.year || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_dentition == 1)
roctab dentition probability if(included_dentition == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (14.63 - 12.36) / 12.36
** Weighted PCV: di (15.78 - 13.75) / 13.75

* Model 2A
** Unweighted: melogit dentition i.sex i.race i.income i.birth if(included_dentition == 1) || group:, or
** Weighted: svy, subpop(if included_dentition == 1): melogit dentition i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_dentition == 1)
roctab dentition probability if(included_dentition == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (1.97 - 12.36) / 12.36
** Weighted PCV: di (1.21 - 13.75) / 13.75

* Model 2B
** Unweighted: melogit dentition i.age_recode i.year i.sex i.race i.income i.birth if(included_dentition == 1) || group:, or
** Weighted: svy, subpop(if included_dentition == 1): melogit dentition i.age i.year i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_dentition == 1)
roctab dentition probability if(included_dentition == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (3.48 - 12.36) / 12.36
** Weighted PCV: di (2.83 - 13.75) / 13.75

****************************************************************

** Untreated caries (2011-2018)

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

generate wgt_caries = wtmec2yr / 4
generate wgt2 = 1

sort group
gen sq_wgt = wgt_caries * wgt_caries
by group: egen sum_wgt = sum(wgt_caries)
by group: egen sum_sqw = sum(sq_wgt)
gen wgt1 = wgt_caries * sum_wgt / sum_sqw
svyset group, weight(wgt2) || _n, weight(wgt1)

* Model 1A
** Unweighted: melogit caries if(included_caries == 1) || group:, or
** Weighted: svy, subpop(if included_caries == 1): melogit caries || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_caries == 1)
roctab caries probability if(included_caries == 1)
quietly: drop probability
estat icc

* Model 1B
** Unweighted: melogit caries i.age i.year if(included_caries == 1) || group:, or
** Weighted: svy, subpop(if included_caries == 1): melogit caries i.age i.year || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_caries == 1), fixedonly
roctab caries probability if(included_caries == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (9.70 - 9.51) / 9.51
** Weighted PCV: di (9.15 - 9.20) / 9.20

* Model 2A
** Unweighted: melogit caries i.sex i.race i.income i.birth if(included_caries == 1) || group:, or
** Weighted: svy, subpop(if included_caries == 1): melogit caries i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_caries == 1), fixedonly
roctab caries probability if(included_caries == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (0.66 - 9.51) / 9.51
** Weighted PCV: di (0.70 - 9.20) / 9.20

* Model 2B
** Unweighted: melogit caries i.age i.year i.sex i.race i.income i.birth if(included_caries == 1) || group:, or
** Weighted: svy, subpop(if included_caries == 1): melogit caries i.age i.year i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_caries == 1), fixedonly
roctab caries probability if(included_caries == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (0.62 - 9.51) / 9.51
** Weighted PCV: di (0.70 - 9.20) / 9.20

****************************************************************

** Periodontitis (2009-2014)

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

generate wgt_perio = wtmec2yr / 3
generate wgt2 = 1

sort group
gen sq_wgt = wgt_perio * wgt_perio
by group: egen sum_wgt = sum(wgt_perio)
by group: egen sum_sqw = sum(sq_wgt)
gen wgt1 = wgt_perio * sum_wgt / sum_sqw
svyset group, weight(wgt2) || _n, weight(wgt1)

* Model 1A
** Unweighted: melogit perio if(included_perio == 1) || group:, or
** Weighted: svy, subpop(if included_perio == 1): melogit perio || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_perio == 1)
roctab perio probability if(included_perio == 1)
quietly: drop probability
estat icc

* Model 1B
** Unweighted: melogit perio i.age i.year if(included_perio == 1) || group:, or
** Weighted: svy, subpop(if included_perio == 1): melogit perio i.age i.year || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_perio == 1), fixedonly
roctab perio probability if(included_perio == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (14.49 - 12.71) / 12.71
** Weighted PCV:  di (14.24 - 10.89) / 10.89

* Model 2A
** Unweighted: melogit perio i.sex i.race i.income i.birth if(included_perio == 1) || group:, or
** Weighted: svy, subpop(if included_perio == 1): melogit perio i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_caries == 1), fixedonly
roctab caries probability if(included_caries == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (0.37 - 12.71) / 12.71
** Weighted PCV: -100%

* Model 2B
** Unweighted: melogit perio i.age i.year i.sex i.race i.income i.birth if(included_perio == 1) || group:, or
** Weighted: svy, subpop(if included_perio == 1): melogit perio i.age i.year i.sex i.race i.income i.birth || group:, or
nlcom exp(sqrt(2*_b[/var(_cons[group])])*invnormal(0.75)), cformat(%9.2f)
quietly: predict probability if(included_caries == 1), fixedonly
roctab caries probability if(included_caries == 1)
quietly: drop probability
estat icc

** Unweighted PCV: di (0.29 - 12.71) / 12.71
** Weighted PCV: -100%

****************************************************************