******************************
*** Intersectionality CDOE ***
******************************

** Do-File 4: Model fitting **

******
* CAN NOT RECALL FOR SURE IF THE STANDARD ERROR METHOD USED HERE IS WHAT WAS USED - NEED TO CONFIRM *
******

local path "insert/path/to/data"
putexcel set "`path'/results", sheet("residuals") modify

putexcel A1 = ("health")  B1 = ("health_lower") C1 = ("health_upper") 	///
D1 = ("dentition")  E1 = ("dentition_lower") F1 = ("dentition_upper") 	///
G1 = ("caries")  H1 = ("caries_lower") I1 = ("caries_upper") 			///
J1 = ("perio")  K1 = ("perio_lower") L1 = ("perio_upper")

****************************************************************

use "`path'/nhanes_cleaned.dta", clear

* Fit appropriate model
** Self reported oral health: melogit health i.sex i.race i.income i.birth if(included_health == 1) || group:, or
** Edentulism: 				  melogit health i.sex i.race i.income i.birth if(included_health == 1) || group:, or
** Untreated caries: 		  melogit health i.sex i.race i.income i.birth if(included_health == 1) || group:, or
** Periodontitis: 			  melogit health i.sex i.race i.income i.birth if(included_health == 1) || group:, or

* Probability (fixed + intersectional)
predict combined_prob
* Probability (fixed only)
predict fixed_prob, fixedonly

* Standard error (fixed only)
predict fixed_se, stdp
* Standard error (intersectional only)
predict random_se, reses relevel(group)
* Standard error (fixed + intersectional)
generate combined_var = sqrt(fixed_se^2 + random_se^2)
generate combined_se = combined_prob * (1 - combined_prob) * combined_var

* Probability (residuals)
generate resid_prob = combined_prob - fixed_prob
* Standard error (of the residuals)
generate resid_se = sqrt(combined_se^2 + fixed_se^2)
* Confidence intervals
generate random_prob_lo = resid_prob - invnormal(0.975) * resid_se
generate random_prob_hi = resid_prob + invnormal(0.975) * resid_se

* Copy results to Excel in accordance with appropriate model

** Self reported oral health
mean random_prob if(included_health == 1), over(group)
matrix residuals = r(table)[1, 1..48]
putexcel A2 = matrix(residuals')
mean random_prob_lo if(included_health == 1), over(group)
matrix residuals_lo = r(table)[1, 1..48]
putexcel B2 = matrix(residuals_lo')
mean random_prob_hi if(included_health == 1), over(group)
matrix residuals_hi = r(table)[1, 1..48]
putexcel C2 = matrix(residuals_hi')

** Edentulism
mean random_prob if(included_health == 1), over(group)
matrix residuals = r(table)[1, 1..48]
putexcel D2 = matrix(residuals')
mean random_prob_lo if(included_health == 1), over(group)
matrix residuals_lo = r(table)[1, 1..48]
putexcel E2 = matrix(residuals_lo')
mean random_prob_hi if(included_health == 1), over(group)
matrix residuals_hi = r(table)[1, 1..48]
putexcel F2 = matrix(residuals_hi')

** Untreated caries
mean random_prob if(included_health == 1), over(group)
matrix residuals = r(table)[1, 1..48]
putexcel G2 = matrix(residuals')
mean random_prob_lo if(included_health == 1), over(group)
matrix residuals_lo = r(table)[1, 1..48]
putexcel H2 = matrix(residuals_lo')
mean random_prob_hi if(included_health == 1), over(group)
matrix residuals_hi = r(table)[1, 1..48]
putexcel I2 = matrix(residuals_hi')

** Periodontitis
mean random_prob if(included_health == 1), over(group)
matrix residuals = r(table)[1, 1..48]
putexcel J2 = matrix(residuals')
mean random_prob_lo if(included_health == 1), over(group)
matrix residuals_lo = r(table)[1, 1..48]
putexcel K2 = matrix(residuals_lo')
mean random_prob_hi if(included_health == 1), over(group)
matrix residuals_hi = r(table)[1, 1..48]
putexcel L2 = matrix(residuals_hi')

****************************************************************