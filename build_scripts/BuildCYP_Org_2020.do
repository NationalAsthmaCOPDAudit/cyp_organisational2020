clear all
set more off

cd "C:\Users\pstone\OneDrive - Imperial College London\Work\National Asthma and COPD Audit Programme\2020 Child & Young Persons Asthma Organisational Audit"

/* create log file */
capture log close
log using build_logs/BuildCYP_Org_2020, text replace

local data_dir "D:\National Asthma and COPD Audit Programme (NACAP)\2020 Child & Young Persons Organisational Audit"


use "`data_dir'/stata_data/CYP_Org_2020", clear


//drop list vars
drop q3_3accesstoano_icasthmapatients q3_1doyouhaveac_icasthmapatients q4_1picuoutreachservicedays q4_2seniordecis_wardroundpaudays q4_3seniordecis_diatricwardsdays q4_4respiratory_mainpatientsdays q5_4adoesyourea_wingtoberecorded q7_1processfort_tservicesensures

//Add label to list var options
label define ticked 0 "Unticked" 1 "Ticked"
label values q3_3accesstoano_mapatientsonsite q3_3accesstoano_tientsonthephone q3_3accesstoano_loutreachservice q3_1doyouhaveac_tientsspirometry q3_1doyouhaveac_xpiratoryflowpef q3_1doyouhaveac_dnitricoxidefeno q3_1doyouhaveac_ntsskinpricktest q3_1doyouhaveac_thmapatientsnone q4_1picuoutreac_vicedaysweekdays q4_1picuoutreac_vicedaysweekends q4_1picuoutreac_cedaysoutofhours q4_1picuoutreac_ooutreachservice q4_2seniordecis_dpaudaysweekdays q4_2seniordecis_dpaudaysweekends q4_2seniordecis_audaysoutofhours q4_2seniordecis_roundpaudaysnone q4_3seniordecis_ardsdaysweekdays q4_3seniordecis_ardsdaysweekends q4_3seniordecis_dsdaysoutofhours q4_3seniordecis_ricwardsdaysnone q4_4respiratory_entsdaysweekdays q4_4respiratory_entsdaysweekends q4_4respiratory_tsdaysoutofhours q4_4respiratory_rynurseavailable q5_4a_ew_targeto2 q5_4a_ew_actualo2 q5_4adoesyourea_ygenadministered q5_4adoesyourea_ednoneoftheabove q7_1processfort_oftheircondition q7_1processfort_entthesamerecord q7_1processfort_eirparentscarers q7_1processfort_rersareaddressed q7_1processfort_dadultclinicians q7_1processfort_intheadultsystem q7_1processfort_totheadultsystem q7_1processfort_tinuedevaluation q7_1processfort_tionarrangements ticked


//generate necessary vars

//2.1 WTE categories
//order unfilled vars after filled
order fy1fy2unfilledwte st1st2unfilledwte st3andaboveunfilledwte paediatricconsultantunfilledwte paediatricrespi_ltantunfilledwte associatespecialistunfilledwte staffgradeunfilledwte asthmanursespecialistunfilledwte nurseconsultant_nurseunfilledwte specialistrespi_rapisunfilledwte paediatricpsych_ogistunfilledwte paediatricpharmacistunfilledwte othernotlistedunfilledwte, after(othernotlistedfilledwte)

//generate WTE categories
local staffingvars "fy1fy2filledwte st1st2filledwte st3andabovefilledwte paediatricconsultantfilledwte paediatricrespi_sultantfilledwte associatespecialistfilledwte staffgradefilledwte asthmanursespecialistfilledwte nurseconsultant_stnursefilledwte specialistrespi_erapistfilledwte paediatricpsychologistfilledwte paediatricpharmacistfilledwte othernotlistedfilledwte fy1fy2unfilledwte st1st2unfilledwte st3andaboveunfilledwte paediatricconsultantunfilledwte paediatricrespi_ltantunfilledwte associatespecialistunfilledwte staffgradeunfilledwte asthmanursespecialistunfilledwte nurseconsultant_nurseunfilledwte specialistrespi_rapisunfilledwte paediatricpsych_ogistunfilledwte paediatricpharmacistunfilledwte othernotlistedunfilledwte"

label define staffinglab 0 "No WTE" 1 "0.1-1.0 WTE" 2 "1.1-3.0 WTE" 3 ">3.0 WTE"

foreach staffingvar of local staffingvars {

	format %10.1f `staffingvar'
	
	local staffingcat = subinstr("`staffingvar'", "wte", "cat", 1)
	
	gen byte `staffingcat' = 0 if `staffingvar' == 0
	replace `staffingcat' = 1 if `staffingvar' > 0 & `staffingvar' <= 1
	replace `staffingcat' = 2 if `staffingvar' > 1 & `staffingvar' <= 3
	replace `staffingcat' = 3 if `staffingvar' > 3 & `staffingvar' != .
	
	label values `staffingcat' staffinglab
	order `staffingcat', before(`staffingvar')
}


compress
save "`data_dir'/builds/CYP_Org_2020_finalbuild", replace

export excel outputs/CYP_Asthma_Org_2020.xlsx, firstrow(variables) replace


log close