******************************
*** Intersectionality CDOE ***
******************************

** Do-File 5: Predicted probabilities **

* Computing stratum-level probabilties for each outcome
* Convereted to prevalence when needed by multiplying probabilties by 100

local path "insert/path/to/data"
putexcel set "`path'/results", sheet("probabilties") modify

putexcel A1 = ("stratum") 									///  
B1 = ("sroh") C1 = ("sroh_lo") D1 = ("sroh_hi")				///
E1 = ("edent") F1 = ("edent_lo") G1 = ("edent_hi")			///
H1 = ("caries") I1 = ("caries_lo") J1 = ("caries_hi")		///
K1 = ("perio") L1 = ("perio_lo") M1 = ("perio_hi")	

****************************************************************

* Self reported oral health

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

melogit health if(included_health == 1) || group:, or
predict prob, mu
predict fixed_se, stdp
predict random_log_odds, ebmean reffects reses(random_se)
generate total_se = fixed_se + random_se
generate total_log_odds = ln(prob / (1 - prob))
generate prob_hi = exp(total_log_odds + 1.96 * total_se) / (1 + exp(total_log_odds + 1.96 * total_se))
generate prob_lo = exp(total_log_odds - 1.96 * total_se) / (1 + exp(total_log_odds - 1.96 * total_se))

mean prob if(included_health == 1), over(group)
matrix sroh_probs = r(table)[1, 1..48]
putexcel B2 = matrix(sroh_probs')
mean prob_lo if(included_health == 1), over(group)
matrix sroh_probs_lo = r(table)[1, 1..48]
putexcel C2 = matrix(sroh_probs_lo')
mean prob_hi if(included_health == 1), over(group)
matrix sroh_probs_hi = r(table)[1, 1..48]
putexcel D2 = matrix(sroh_probs_hi')

****************************************************************

* Edentulism

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

melogit dentition if(included_dentition == 1) || group:, or
predict prob, mu
predict fixed_se, stdp
predict random_log_odds, ebmean reffects reses(random_se)
generate total_se = fixed_se + random_se
generate total_log_odds = ln(prob / (1 - prob))
generate prob_hi = exp(total_log_odds + 1.96 * total_se) / (1 + exp(total_log_odds + 1.96 * total_se))
generate prob_lo = exp(total_log_odds - 1.96 * total_se) / (1 + exp(total_log_odds - 1.96 * total_se))

mean prob if(included_dentition == 1), over(group)
matrix dent_probs = r(table)[1, 1..48]
putexcel E2 = matrix(dent_probs')
mean prob_lo if(included_dentition == 1), over(group)
matrix dent_probs_lo = r(table)[1, 1..48]
putexcel F2 = matrix(dent_probs_lo')
mean prob_hi if(included_dentition == 1), over(group)
matrix dent_probs_hi = r(table)[1, 1..48]
putexcel G2 = matrix(dent_probs_hi')

****************************************************************

* Untreated caries

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

melogit caries if(included_caries == 1) || group:, or
predict prob, mu
predict fixed_se, stdp
predict random_log_odds, ebmean reffects reses(random_se)
generate total_se = fixed_se + random_se
generate total_log_odds = ln(prob / (1 - prob))
generate prob_hi = exp(total_log_odds + 1.96 * total_se) / (1 + exp(total_log_odds + 1.96 * total_se))
generate prob_lo = exp(total_log_odds - 1.96 * total_se) / (1 + exp(total_log_odds - 1.96 * total_se))

mean prob if(included_caries == 1), over(group)
matrix caries_probs = r(table)[1, 1..48]
putexcel H2 = matrix(caries_probs')
mean prob_lo if(included_caries == 1), over(group)
matrix caries_probs_lo = r(table)[1, 1..48]
putexcel I2 = matrix(caries_probs_lo')
mean prob_hi if(included_caries == 1), over(group)
matrix caries_probs_hi = r(table)[1, 1..48]
putexcel J2 = matrix(caries_probs_hi')

****************************************************************

* Periodontitis

local path "insert/path/to/data"
use "`path'/nhanes_cleaned.dta", clear

melogit perio if(included_perio == 1) || group:, or
predict prob, mu
predict fixed_se, stdp
predict random_log_odds, ebmean reffects reses(random_se)
generate total_se = fixed_se + random_se
generate total_log_odds = ln(prob / (1 - prob))
generate prob_hi = exp(total_log_odds + 1.96 * total_se) / (1 + exp(total_log_odds + 1.96 * total_se))
generate prob_lo = exp(total_log_odds - 1.96 * total_se) / (1 + exp(total_log_odds - 1.96 * total_se))

mean prob if(included_perio == 1), over(group)
matrix perio_probs = r(table)[1, 1..48]
putexcel K2 = matrix(perio_probs')
mean prob_lo if(included_perio == 1), over(group)
matrix perio_probs_lo = r(table)[1, 1..48]
putexcel L2 = matrix(perio_probs_lo')
mean prob_hi if(included_perio == 1), over(group)
matrix perio_probs_hi = r(table)[1, 1..48]
putexcel M2 = matrix(perio_probs_hi')

****************************************************************