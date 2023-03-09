******************************
*** Intersectionality CDOE ***
******************************

** Do-File 1: Data cleaning **

local path "insert/path/to/data"
use "`path'/nhanes_cdoe.dta", clear

****************************************************************

* Age
generate age = 1 if(ridageyr >= 20 & ridageyr < 30)
replace age = 2 if(ridageyr >= 30 & ridageyr < 40)
replace age = 3 if(ridageyr >= 40 & ridageyr < 50)
replace age = 4 if(ridageyr >= 50 & ridageyr < 60)
replace age = 5 if(ridageyr >= 60 & ridageyr < 70)
replace age = 6 if(ridageyr >= 70)
replace age = . if(ridageyr == .)

label define age_lab 1 "20-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" 6 "70+"
label values age age_lab

* Sex
generate sex = riagendr

label define sex_lab 1 "M" 2 "F"
label values sex sex_lab

* Race / ethnicity
generate race = 1 if(ridreth1 == 3)
replace race = 2 if(ridreth1 == 4)
replace race = 3 if(ridreth1 == 1 | ridreth1 == 2)
replace race = 4 if(ridreth1 == 5)

label define race_lab 1 "NHW" 2 "NHB" 3 "HISP" 4 "OTH"
label values race race_lab

* Education
generate education = 1 if(dmdeduc2 == 1 | dmdeduc2 == 2)
replace education = 2 if(dmdeduc2 == 3 | dmdeduc2 == 4)
replace education = 3 if(dmdeduc2 == 5)

label define edu_lab 1 "Below high" 2 "High school" 3 "College"
label values education edu_lab

* Poverty to income
generate income = 1 if(indfmpir < 1)
replace income = 2 if(indfmpir >= 1 & indfmpir < 2.5)
replace income = 3 if(indfmpir >= 2.5)
replace income = . if(indfmpir == .)

label define inc_lab 1 "LOW" 2 "MED" 3 "HI"
label values income inc_lab

* Country of birth
generate birth = 1 if(dmdborn2 == 1 | dmdborn4 == 1)
replace birth = 2 if(dmdborn2 == 2 | dmdborn2 == 4 | dmdborn2 == 5 | dmdborn4 == 2)

label define birth_lab 1 "US" 2 "NON-US"
label values birth birth_lab

* Dental outcomes

** Self rated oral health (2009-2018)
generate self = ohq845
replace self = . if(ohq845 == 7)
replace self = . if(ohq845 == 9)

label define self_lab 1 "Excellent" 2 "V good" 3 "Good" 4 "Fair" 5 "Poor"
label values self self_lab

** Number of teeth (2009-2018)

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	foreach var of varlist ohx`I'tc {
			generate ohx`I'pres = 1 if(`var' == 1 | `var' == 2 | `var' == 5)
			recode ohx`I'pres(. = 0)
	}
}

egen teeth = rowtotal(ohx02pres-ohx31pres)

** Untreated caries (2011-2018)

*** 2015-16 and 2017-18

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	generate ohx`I'car = 0 if(year == 2015 | year == 2017)
	replace ohx`I'car = 1 if((strpos(ohx`I'ctc, "K") | strpos(ohx`I'ctc, "Z")) & (year == 2015 | year == 2017))
}

*** 2011-12 and 2013-14

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	replace ohx`I'car = 0 if(year == 2011 | year == 2013)
	replace ohx`I'car = 1 if((strpos(ohx`I'csc, "0") | strpos(ohx`I'csc, "1") | strpos(ohx`I'csc, "2") | strpos(ohx`I'csc, "3") | strpos(ohx`I'csc, "4")) & (year == 2011 | year == 2013))
}

egen decay = rowtotal(ohx02car-ohx31car)
replace decay = . if(year == 2009)

** Periodontitis (2009-2014)

*** Mild perio CAL

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	generate ohx`I'cal_mil = 0
	foreach var of varlist ohx`I'lad ohx`I'las ohx`I'lap ohx`I'laa {
			recode `var'(99 = .)
			replace ohx`I'cal_mil = 1 if(`var' >= 3 & `var' != .)
	}
}

egen calmil = rowtotal(ohx02cal_mil-ohx31cal_mil)

*** Mild perio PPD

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	generate ohx`I'ppd_mil = 0
	foreach var of varlist ohx`I'pcd ohx`I'pcs ohx`I'pcp ohx`I'pca {
			recode `var'(99 = .)	
			replace ohx`I'ppd_mil = 1 if(`var' >= 4 & `var' != .)
	}
}

egen ppdmil = rowtotal(ohx02ppd_mil-ohx31ppd_mil)

*** Moderate perio CAL

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	generate ohx`I'cal_mod = 0
	foreach var of varlist ohx`I'lad ohx`I'las ohx`I'lap ohx`I'laa {
			recode `var'(99 = .)
			replace ohx`I'cal_mod = 1 if(`var' >= 4 & `var' != .)
	}
}

egen calmod = rowtotal(ohx02cal_mod-ohx31cal_mod)

*** Severe perio CAL

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	generate ohx`I'cal_sev = 0
	foreach var of varlist ohx`I'lad ohx`I'las ohx`I'lap ohx`I'laa {
			recode `var'(99 = .)
			replace ohx`I'cal_sev = 1 if(`var' >= 6 & `var' != .)
	}
}

egen calsev = rowtotal(ohx02cal_sev-ohx31cal_sev)

*** Perio PPD

forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	generate ohx`I'ppd = 0
	foreach var of varlist ohx`I'pcd ohx`I'pcs ohx`I'pcp ohx`I'pca {
			recode `var'(99 = .)	
			replace ohx`I'ppd = 1 if(`var' >= 5 & `var' != .)
	}
}

egen ppdsites = rowtotal(ohx02ppd-ohx31ppd)

generate cdc_perio = 1
replace cdc_perio = 2 if((calmil >= 2 & ppdmil >= 2) | (calmil >= 2 & ppdsites >= 1))
replace cdc_perio = 3 if(calmod >= 2 | ppdsites >= 2)
replace cdc_perio = 4 if(calsev >= 2 & ppdsites >= 1)

replace cdc_perio = . if(year == 2015 | year == 2017)

label define perio_lab 1 "None" 2 "Mild" 3 "Moderate" 4 "Severe"
label values cdc_perio perio_lab

* Final diagnoses

** Self rated oral health (Good / Very good / Excellent vs Fair / Poor), NHANES 2009-2018

generate health = 0 if(self == 1 | self == 2 | self == 3)
replace health = 1 if(self == 4 | self == 5)

label define health_lab 0 "Good" 1 "Poor"
label values health health_lab

** Edentulism (Non-edentulous vs Edentulous), NHANES 2009-2018

generate dentition = 0 if(teeth > 0 & teeth != .)
replace dentition = 1 if(teeth == 0)

label define dent_lab 0 "Non-edentulous" 1 "Edentulous"
label values dentition dent_lab

** Untreated caries (Absent vs Present), NHANES 2011-2018

generate caries = 0 if(decay == 0)
replace caries = 1 if(decay > 0 & decay != .)

label define caries_lab 0 "None" 1 "Decay"
label values caries caries_lab

** Periodontitis (Absent vs Present), NHANES 2009-2014

generate perio = 0 if(cdc_perio == 1 | cdc_perio == 2)
replace perio = 1 if(cdc_perio == 3 | cdc_perio == 4)

label define per_lab 0 "None" 1 "Perio"
label values perio per_lab

** Creating group variable

egen group = group(sex race income birth), label

* Inclusion criteria

** Dental examination status
generate dental_ex = 1 if(ohdexsts == 1)

** Perio examination status
generate perio_ex = 1 if(ohdpdsts == 1)

** Self-reported health
generate included_health = 1

** Dentition
generate included_dentition = 1
replace included_dentition = 0 if(dental_ex != 1)

** Untreated caries
generate included_caries = 1
replace included_caries = 0 if(dental_ex != 1 | teeth == 0 | year == 2009)

** Periodontal disease
generate included_perio = 1
replace included_perio = 0 if(perio_ex != 1 | teeth == 0 | year == 2015 | year == 2017)

foreach var of varlist age sex race income birth year group {
	replace included_health = 0 if missing(`var')
	replace included_dentition = 0 if missing(`var')
	replace included_caries = 0 if missing(`var')
	replace included_perio = 0 if missing(`var')
}

label define incl_lab 0 "Excluded" 1 "Included"
foreach var of varlist included_* {
	label values `var' incl_lab
}

* Dropping unecessary variables

keep seqn year age-birth teeth health-perio group *_ex included_* ridageyr

save "`path'/nhanes_cleaned.dta", replace

****************************************************************