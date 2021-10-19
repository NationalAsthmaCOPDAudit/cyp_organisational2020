clear all
set more off

cd "C:\Users\pstone\OneDrive - Imperial College London\Work\National Asthma and COPD Audit Programme\2020 Child & Young Persons Asthma Organisational Audit"

/* create log file */
capture log close
log using analysis_logs/AnalysisCYP_Org_2020_benchmarking, text replace

local data_dir "D:\National Asthma and COPD Audit Programme (NACAP)\2020 Child & Young Persons Organisational Audit"


use "`data_dir'/builds/CYP_Org_2020_finalbuild", clear


keep orgcode description trustcode trust country region hospital doesyourhospita_ntscanbeadmitted q3_5designatedn_orasthmaservices q3_8smokingcess_ostparentscarers q3_9smokingcess_icasthmapatients q3_1doyouhaveac_tientsspirometry q3_1doyouhaveac_xpiratoryflowpef q3_1doyouhaveac_dnitricoxidefeno q3_1doyouhaveac_ntsskinpricktest q3_1doyouhaveac_thmapatientsnone


rename doesyourhospita_ntscanbeadmitted hdu
tab hdu, missing


//just paediatrics
tab q3_5designatedn_orasthmaservices, missing
gen asthmalead = (q3_5designatedn_orasthmaservices == 1 | ///
				  q3_5designatedn_orasthmaservices == 3)
label values asthmalead yn
tab q3_5designatedn_orasthmaservices asthmalead
tab asthmalead, missing
order asthmalead, after(q3_5designatedn_orasthmaservices)
drop q3_5designatedn_orasthmaservices


tab q3_8smokingcess_ostparentscarers, missing
gen smokcesssignpost = (q3_8smokingcess_ostparentscarers == 1)
label values smokcesssignpost yn
tab q3_8smokingcess_ostparentscarers smokcesssignpost
tab smokcesssignpost, missing
order smokcesssignpost, after(q3_8smokingcess_ostparentscarers)
drop q3_8smokingcess_ostparentscarers


tab q3_9smokingcess_icasthmapatients, missing
gen smokingcessation = (q3_9smokingcess_icasthmapatients == 1)
label values smokingcessation yn
tab q3_9smokingcess_icasthmapatients smokingcessation
tab smokingcessation, missing
order smokingcessation, after(q3_9smokingcess_icasthmapatients)
drop q3_9smokingcess_icasthmapatients


//spirometry AND FeNO
tab1 q3_1doyouhaveac_tientsspirometry q3_1doyouhaveac_xpiratoryflowpef q3_1doyouhaveac_dnitricoxidefeno q3_1doyouhaveac_ntsskinpricktest q3_1doyouhaveac_thmapatientsnone, missing

gen spir_feno = (q3_1doyouhaveac_tientsspirometry == 1 & q3_1doyouhaveac_dnitricoxidefeno == 1)
label values spir_feno yn
tab spir_feno, missing

drop q3_1doyouhaveac_tientsspirometry q3_1doyouhaveac_xpiratoryflowpef q3_1doyouhaveac_dnitricoxidefeno q3_1doyouhaveac_ntsskinpricktest q3_1doyouhaveac_thmapatientsnone


export excel outputs/CYP_Asthma_Org_2020_Benchmarking.xlsx, firstrow(variables) replace


log close