clear all
set more off

cd "C:\Users\pstone\OneDrive - Imperial College London\Work\National Asthma and COPD Audit Programme\2020 Child & Young Persons Asthma Organisational Audit"

/* create log file */
capture log close
log using build_logs/ImportCYP_Org_2020, text replace

local data_dir "D:\National Asthma and COPD Audit Programme (NACAP)\2020 Child & Young Persons Organisational Audit"


//Import organisational data
import delimited "`data_dir'/raw_data/NACAP-CYPAA---Org-Audit-2019---All-Data-20200401-111327-454.csv", varnames(nonames) rowrange(1:1) clear


//clean up and replace the var names
foreach var of varlist _all {
	
	//clean variable names
	replace `var' = trim(itrim(ustrto(ustrnormalize(`var', "nfd"), "ascii", 2)))
	
	replace `var' = subinstr(`var', " ", "", .)
	replace `var' = subinstr(`var', "?", "", .)
	replace `var' = subinstr(`var', "#", "", .)
	replace `var' = subinstr(`var', ":", "", .)
	replace `var' = subinstr(`var', "%", "", .)
	replace `var' = subinstr(`var', "/", "", .)
	replace `var' = subinstr(`var', "=", "", .)
	replace `var' = subinstr(`var', "-", "", .)
	replace `var' = subinstr(`var', "(", "", .)
	replace `var' = subinstr(`var', ")", "", .)
	replace `var' = subinstr(`var', ",", "", .)
	replace `var' = subinstr(`var', ";", "", .)
	replace `var' = subinstr(`var', "'", "", .)
	replace `var' = subinstr(`var', ".", "_", .)
	
	//prefix a "q" to variables that start with a number
	if real(substr(`var', 1, 1)) != . {
	
		replace `var' = "q"+`var'
	}
	
	//shrink variable names (keep beginning and end)
	if strlen(`var') > 32 {
		
		replace `var' = substr(`var', 1, 15) + "_" + substr(`var', -16, .)
	}
	
	//fix variable names that are identical when shortened
	if "`var'" == "v87" {
		
		replace `var' = "q5_4a_EW_targetO2"
	}
	else if "`var'" == "v88" {
	
		replace `var' = "q5_4a_EW_actualO2"
	}
	
	local name = lower(`var')
	rename `var' `name'
}

describe, varlist
local varnames = r(varlist)

import delimited "`data_dir'/raw_data/NACAP-CYPAA---Org-Audit-2019---All-Data-20200401-111327-454.csv", asdouble clear
rename (_all) (`varnames')


foreach var of varlist _all {
	
	capture confirm string variable `var'
	if !_rc {
	
		//clean strings with non-ASCII characters
		replace `var' = trim(itrim(ustrto(ustrnormalize(`var', "nfd"), "ascii", 2)))
	}
}

//remove waste-of-time incomplete entries
tab complete, missing
drop if complete != "yes"
drop complete


tempfile org
compress
save `org'


//Import hospital names/countries
import delimited "`data_dir'/raw_data/NACAP-CYPAA-HospitalCodes-2020-04.csv", varnames(1) clear

foreach var of varlist _all {
	
	capture confirm string variable `var'
	if !_rc {
	
		//clean strings with non-ASCII characters
		replace `var' = trim(itrim(ustrto(ustrnormalize(`var', "nfd"), "ascii", 2)))
	}
}

rename crowncode orgcode

list if country != "England" & country != "Scotland" & country != "Wales"
drop if country != "England" & country != "Scotland" & country != "Wales"

encode country, gen(country2)
encode regionsha, gen(region)

drop country regionsha
rename country2 country

compress


//merge imported organisational data
merge 1:1 orgcode using `org'
drop if _merge == 1
drop _merge

gsort orgcode


//no idea what this date is - is it useful? who knows?
drop edeadline


//Yes/No variables
local ynvars "doesyourhospita_ntscanbeadmitted q1_3doesyourhos_ntscanbeadmitted q3_6aifnotdoyou_ricasthmaservice q5_1doesthepaed_trecordeprsystem q5_3dothewardba_criptionofoxygen q5_4doesyourhos_etectione_g_pews q8_2hasyourcomm_iatricasthmacare"
label define yn 0 "No" 1 "Yes"
foreach ynvar of local ynvars {
	
	replace `ynvar' = "0" if lower(`ynvar') == "no"
	replace `ynvar' = "1" if lower(`ynvar') == "yes"
	destring `ynvar', replace
	label values `ynvar' yn
}


//Yes/No/Not known variables
local ynnk_vars "q3_4isyourservi_ricasthmanetwork q3_5aisthisrolecurrentlyfilled q3_6doesyourhos_paediatricasthma q3_8smokingcess_ostparentscarers q3_9smokingcess_icasthmapatients q3_10doyouhavea_ntscanbereferred q3_11canthepaed_icepostdischarge q5_4bearlywarni_echildyoungadult q6_1doesyourtru_icasthmaservices q6_1aifyesdoest_errepresentation"
label define ynnk 0 "No" 1 "Yes" 2 "Not known"
foreach ynnkvar of local ynnk_vars {
	
	replace `ynnkvar' = "0" if `ynnkvar' == "No"
	replace `ynnkvar' = "1" if `ynnkvar' == "Yes"
	replace `ynnkvar' = "2" if `ynnkvar' == "Not known"
	destring `ynnkvar', replace
	label values `ynnkvar' ynnk
}


//3.1 How often are paediatric patients on the paediatric admissions ward routinely reviewed by a senior decision maker (ST3 or above)?
label define freq 1 "Twice daily" 2 "Daily" 3 "Other"
foreach var in q3_1aroutinelyr_raboveonweekdays q3_1broutinelyr_raboveonweekends {
	
	replace `var' = "1" if `var' == "Twice daily"
	replace `var' = "2" if `var' == "Daily"
	replace `var' = "3" if `var' == "Other"

	destring `var', replace
	label values `var' freq
}


//3.2 Which admitted paediatric asthma patients have access to a paediatric respiratory nurse?
local var1 "q3_2whichadmitt_respiratorynurse"
replace `var1' = "0" if `var1' == "None"
replace `var1' = "1" if `var1' == "All paediatric asthma patients"
replace `var1' = "2" if `var1' == "Those under the care of a paediatric respiratory consultant"
replace `var1' = "3" if `var1' == "Other"
destring `var1', replace

label define nurse 0 "None" ///
				   1 "All paediatric asthma patients" ///
				   2 "Those under the care of a paediatric respiratory consultant" ///
				   3 "Other"
label values `var1' nurse


//3.5 Does your hospital have a designated, named clinical lead for asthma services?
local var2 "q3_5designatedn_orasthmaservices"
replace `var2' = "0" if `var2' == "No lead"
replace `var2' = "1" if `var2' == "Paediatric lead only"
replace `var2' = "2" if `var2' == "Adult lead only"
replace `var2' = "3" if `var2' == "Single lead for both adults and paediatrics"
destring `var2', replace

label define lead 0 "No lead" ///
				  1 "Paediatric lead only" ///
				  2 "Adult lead only" ///
				  3 "Single lead for both adults and paediatrics"
label values `var2' lead


//3.5b Is the asthma lead responsible for formal training in the management of acute paediatric asthma?
local var3 "q3_5bistheasthm_paediatricasthma"
replace `var3' = "0" if `var3' == "No"
replace `var3' = "1" if `var3' == "Yes - paediatric only"
replace `var3' = "2" if `var3' == "Yes - paediatric and adult"
destring `var3', replace

label define training 0 "No" ///
					  1 "Yes - paediatric only" ///
					  2 "Yes - paediatric and adult"
label values `var3' training


//3.7 When children with poor asthma control or severe illness have been identified in clinic, does the asthma lead review the child prior to referral to a specialist paediatric asthma service?
local var4 "q3_7doesasthmal_lorsevereillness"
replace `var4' = "0" if `var4' == "No"
replace `var4' = "1" if `var4' == "Yes"
replace `var4' = "2" if `var4' == "Not applicable - we have specialist advice on site"
replace `var4' = "3" if `var4' == "Not known"
destring `var4', replace

label define review 0 "No" ///
					1 "Yes" ///
					2 "Not applicable - we have specialist advice on site" ///
					3 "Not known"
label values `var4' review


//3.8a/3.9a Please let us know more about the provision of this service:
label define service 1 "Hospital based team" ///
					 2 "Community based team" ///
					 3 "Both hospital and community-based teams" ///
					 4 "Single team that works across the community/secondary care interface"
foreach var in q3_8apleaseletu_ionofthisservice q3_9apleaseletu_ionofthisservice {
	
	replace `var' = "1" if `var' == "Hospital based team"
	replace `var' = "2" if `var' == "Community based team"
	replace `var' = "3" if `var' == "Both hospital and community-based teams"
	replace `var' = "4" if `var' == "Single team that works across the community/secondary care interface"

	destring `var', replace
	label values `var' service
}


//5.2 Does your hospital have a paediatric oxygen policy?
local var5 "q5_2doesyourhos_tricoxygenpolicy"
replace `var5' = "0" if `var5' == "Neither a paediatric nor adult policy"
replace `var5' = "1" if `var5' == "Yes - paediatric specific"
replace `var5' = "2" if `var5' == "Yes - combined adult and paediatric policy"
replace `var5' = "3" if `var5' == "Not known"
destring `var5', replace

label define policy 0 "Neither a paediatric nor adult policy" ///
					1 "Yes - paediatric specific" ///
					2 "Yes - combined adult and paediatric policy" ///
					3 "Not known"
label values `var5' policy


//6.2 How often is a formal survey seeking patient and parent/carer views on paediatric services undertaken?
local var6 "q6_2howoftenisa_rvicesundertaken"
replace `var6' = "0" if `var6' == "Never"
replace `var6' = "1" if `var6' == "Less than once a year"
replace `var6' = "2" if `var6' == "1-2 times a year"
replace `var6' = "3" if `var6' == "3-4 times a year"
replace `var6' = "4" if `var6' == "More than 4 times a year"
replace `var6' = "5" if `var6' == "Continuous (every patient)"
destring `var6', replace

label define survey 0 "Never" ///
					1 "Less than once a year" ///
					2 "1-2 times a year" ///
					3 "3-4 times a year" ///
					4 "More than 4 times a year" ///
					5 "Continuous (every patient)"
label values `var6' survey


//8.1 How is reimbursement of costs of care for paediatric patients with asthma achieved?
local var7 "q8_1howisreimbu_thasthmaachieved"
replace `var7' = "1" if `var7' == "Payment via block contract"
replace `var7' = "2" if `var7' == "Payment by results"
replace `var7' = "3" if `var7' == "Locally negotiated tariff"
replace `var7' = "4" if `var7' == "Other"
destring `var7', replace

label define costs 1 "Payment via block contract" ///
				   2 "Payment by results" ///
				   3 "Locally negotiated tariff" ///
				   4 "Other"
label values `var7' costs


//correct denominators in multiple choice answers
replace q4_4respiratory_entsdaysweekdays = . if q4_4respiratory_mainpatientsdays == ""
replace q4_4respiratory_entsdaysweekends = . if q4_4respiratory_mainpatientsdays == ""
replace q4_4respiratory_tsdaysoutofhours = . if q4_4respiratory_mainpatientsdays == ""
replace q4_4respiratory_rynurseavailable = . if q4_4respiratory_mainpatientsdays == ""

replace q5_4a_ew_targeto2 = . if q5_4doesyourhos_etectione_g_pews == 0
replace q5_4a_ew_actualo2 = . if q5_4doesyourhos_etectione_g_pews == 0
replace q5_4adoesyourea_ygenadministered = . if q5_4doesyourhos_etectione_g_pews == 0
replace q5_4adoesyourea_ednoneoftheabove = . if q5_4doesyourhos_etectione_g_pews == 0


//these variables arent't required
drop q6_2howoftenisa_uouseverypatient q6_2howoftenisa_ethan4timesayear q6_2howoftenisa_aken34timesayear q6_2howoftenisa_aken12timesayear q6_2howoftenisa_essthanonceayear q6_2howoftenisa_sundertakennever


compress
save "`data_dir'/stata_data/CYP_Org_2020", replace


log close