clear all
set more off

cd "C:\Users\pstone\OneDrive - Imperial College London\Work\National Asthma and COPD Audit Programme\2020 Child & Young Persons Asthma Organisational Audit"

/* create log file */
capture log close
log using build_logs/ImportMergeCYPAdmissions, text replace

local data_dir "D:\National Asthma and COPD Audit Programme (NACAP)\2020 Child & Young Persons Organisational Audit"


//Initialise tempfiles
tempfile england_adms welsheng_adms wales_adms


//Import admissions data
import excel "`data_dir'/raw_data/manualextract_EnglandCYPAdmissions", firstrow clear

label define adm_range 4 "1-7"

foreach var of varlist emergency_adm respiratory_adm asthma_adm {
	
	replace `var' = "4" if `var' == "*"
	destring `var', replace
	label values `var' adm_range
}

gsort description

//remove duplicate hospital entries (don't appear in audit data)
drop if description == "NULL"
drop if site_code == "RNLAY"
drop if site_code == "RV3AN"
drop if site_code == "RRK02"
drop if site_code == "RR7EN"
drop if site_code == "RNLBX"

codebook description

save `england_adms'


import excel "`data_dir'/raw_data/manualextract_WelshEnglandCYPAdmissions", firstrow clear

replace description = upper(description)

save `welsheng_adms'


import excel "`data_dir'/raw_data/manualextract_WalesCYPAdmissions", firstrow clear

replace description = upper(description)

save `wales_adms'


//Merge with audit data
use "`data_dir'/builds/CYP_Org_2020_finalbuild", clear

replace description = upper(description)

merge 1:1 description using `england_adms'
drop if _merge == 2
drop _merge


merge 1:1 description using `wales_adms', update
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


save "`data_dir'/builds/CYP_Org_2020_finalbuild_adms", replace

export excel outputs/CYP_Asthma_Org_2020_adms.xlsx, firstrow(variables) replace


log close