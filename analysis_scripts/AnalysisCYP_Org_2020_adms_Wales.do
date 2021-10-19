clear all
set more off

cd "C:\Users\pstone\OneDrive - Imperial College London\Work\National Asthma and COPD Audit Programme\2020 Child & Young Persons Asthma Organisational Audit"

local country = "Wales"

/* create log file */
capture log close
log using analysis_logs/AnalysisCYP_Org_2020_adms_`country'_MANUAL, smcl replace

local data_dir "D:\National Asthma and COPD Audit Programme (NACAP)\2020 Child & Young Persons Organisational Audit"


use "`data_dir'/builds/CYP_Org_2020_finalbuild_adms_MANUAL", clear


keep if country == 3
tab country, missing

do analysis_scripts/AnalysisCYP_Org_2020_adms


log close

translate analysis_logs/AnalysisCYP_Org_2020_adms_`country'_MANUAL.smcl ///
		  outputs/CYP_Asthma_Organisational_2020_admissions_`country'_MANUAL.pdf