******************************
*** Intersectionality CDOE ***
******************************

** Do-File 2: Group counts **

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

****************************************************************

* Counting number of participants and reasons for inclusion/exclusion
* Allows for STROBE flowcharts to be constructed

** Self-reported oral health

generate included1 = 1
tab included1
replace included1 = 0 if missing(age)
tab included1
replace included1 = 0 if missing(health)
tab included1
replace included1 = 0 if missing(group)
tab included1

** Dentition

generate included2 = 1
tab included2
replace included2 = 0 if missing(age)
tab included2
replace included2 = 0 if dental_ex != 1
replace included2 = 0 if missing(dentition)
tab included2
replace included2 = 0 if missing(group)
tab included2

** Untreated caries

generate included3 = 1
replace included3 = 0 if (year == 2009)
tab included3
replace included3 = 0 if missing(age)
tab included3
replace included3 = 0 if dental_ex != 1
replace included3 = 0 if missing(caries)
replace included3 = 0 if(teeth == 0)
tab included3
replace included3 = 0 if missing(group)
tab included3

** Periodontitis

generate included4 = 1
replace included4 = 0 if (year == 2015 | year == 2017)
tab included4
replace included4 = 0 if missing(age)
replace included4 = 0 if ridageyr < 30
tab included4
replace included4 = 0 if perio_ex != 1
replace included4 = 0 if missing(perio)
replace included4 = 0 if(teeth == 0)
tab included4
replace included4 = 0 if missing(group)
tab included4

****************************************************************
