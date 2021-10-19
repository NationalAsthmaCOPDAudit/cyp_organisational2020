clear all
set more off

cd "C:\Users\pstone\OneDrive - Imperial College London\Work\National Asthma and COPD Audit Programme\2020 Child & Young Persons Asthma Organisational Audit"

/* create log file */
capture log close
log using build_logs/ImportMergeCYPAdmissions_MANUAL, text replace

local data_dir "D:\National Asthma and COPD Audit Programme (NACAP)\2020 Child & Young Persons Organisational Audit"


//Initialise tempfiles
tempfile admissions


//Import admissions data
import excel "`data_dir'/raw_data/CYP_Asthma_Org_2020_adms_manual.xlsx", firstrow clear

label define adm_range 4 "1-7"

foreach var of varlist emergency_adm respiratory_adm asthma_adm {
	
	replace `var' = "4" if `var' == "*"
	replace `var' = "4" if `var' == "1-7"
	destring `var', replace
	label values `var' adm_range
}

drop trustcode description

save `admissions'


//Merge with audit data
use "`data_dir'/builds/CYP_Org_2020_finalbuild", clear

merge 1:1 orgcode using `admissions'
drop if _merge == 2
drop _merge

order site_code emergency_adm respiratory_adm asthma_adm, after(hospital)


gen double admsperbed = round(emergency_adm/howmanypaediatr_icasthmapatients, 0.1)
gen double respadmsperbed = round(respiratory_adm/howmanypaediatr_icasthmapatients, 0.1)
gen double asthmaadmsper1000adms = round(asthma_adm/(emergency_adm/1000), 0.1)

order admsperbed respadmsperbed asthmaadmsper1000adms, after(asthma_adm)


// Staff per 100 admissions
local filledstaffvars "fy1fy2filledwte st1st2filledwte st3andabovefilledwte paediatricconsultantfilledwte paediatricrespi_sultantfilledwte associatespecialistfilledwte staffgradefilledwte asthmanursespecialistfilledwte nurseconsultant_stnursefilledwte specialistrespi_erapistfilledwte paediatricpsychologistfilledwte paediatricpharmacistfilledwte othernotlistedfilledwte"

foreach filledstaffvar of local filledstaffvars {

	local staffper100adm = subinstr("`filledstaffvar'", "wte", "ph", 1)
		
	gen double `staffper100adm'r = round(`filledstaffvar'/(respiratory_adm/100), 0.1)
	gen double `staffper100adm'a = round(`filledstaffvar'/(asthma_adm/100), 0.1)

	order `staffper100adm'r `staffper100adm'a, after(`filledstaffvar')
}


save "`data_dir'/builds/CYP_Org_2020_finalbuild_adms_MANUAL", replace

export excel outputs/CYP_Asthma_Org_2020_adms_MANUAL.xlsx, firstrow(variables) replace


log close