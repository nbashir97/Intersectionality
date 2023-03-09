******************************
*** Intersectionality CDOE ***
******************************

** Do-File 3: Summary statistics **

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

****************************************************************

generate weight_sroh_dent = wtmec2yr / 5
generate weight_caries = wtmec2yr / 4
generate weight_perio = wtmec2yr / 3

* Computing summary statistics
* Unweighted counts and weighted proportions

** Self reported oral health

svyset [w = weight_sroh_dent], psu(sdmvpsu) strata(sdmvstra)
tab health if(included_health == 1)
svy, subpop(if included_health == 1): proportion health, percent

foreach var of varlist sex race income birth age year {
	tab `var' health if(included_health == 1)
	svy, subpop(if included_health == 1): proportion health, over(`var') percent
}

** Dentition

svyset [w = weight_sroh_dent], psu(sdmvpsu) strata(sdmvstra)
tab dentition if(included_dentition == 1)
svy, subpop(if included_dentition == 1): proportion dentition, percent

foreach var of varlist sex race income birth age year {
	tab `var' dentition if(included_dentition == 1)
	svy, subpop(if included_dentition == 1): proportion dentition, over(`var') percent
}

** Caries

svyset [w = weight_caries], psu(sdmvpsu) strata(sdmvstra)
tab caries if(included_caries == 1)
svy, subpop(if included_caries == 1): proportion caries, percent

foreach var of varlist sex race income birth age year {
	tab `var' caries if(included_caries == 1)
	svy, subpop(if included_caries == 1): proportion caries, over(`var') percent
}

** Perio

svyset [w = weight_perio], psu(sdmvpsu) strata(sdmvstra)
tab perio if(included_perio == 1)
svy, subpop(if included_perio == 1): proportion perio, percent

foreach var of varlist sex race income birth age year {
	tab `var' perio if(included_perio == 1)
	svy, subpop(if included_perio == 1): proportion perio, over(`var') percent
}

****************************************************************