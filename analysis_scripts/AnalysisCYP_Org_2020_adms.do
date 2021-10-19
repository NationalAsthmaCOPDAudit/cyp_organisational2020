//Section 1: Admissions – numbers and beds

//Part A: Externally sourced admissions data - NOT AVAILABLE

//A. Number of paediatric medical emergencies in the 2018/19 financial year per medical bed at each hospital
summarize admsperbed, detail

//B. Number of paediatric respiratory coded emergency admissions in the 2018/19 financial year
summarize respadmsperbed, detail

//C. Number of paediatric asthma coded emergency admissions in the 2018/19 financial year
summarize asthmaadmsper1000adms, detail


//Staff per 100 admissions
display "Staff per 100 admissions..."
display "phr = per 100 respiratory admissions"
display "pha = per 100 asthma admissions"

local filledstaffvars "fy1fy2filledwte st1st2filledwte st3andabovefilledwte paediatricconsultantfilledwte paediatricrespi_sultantfilledwte associatespecialistfilledwte staffgradefilledwte asthmanursespecialistfilledwte nurseconsultant_stnursefilledwte specialistrespi_erapistfilledwte paediatricpsychologistfilledwte paediatricpharmacistfilledwte othernotlistedfilledwte"

foreach filledstaffvar of local filledstaffvars {
	
	display "`filledstaffvar'"
	
	local staffper100adm = subinstr("`filledstaffvar'", "wte", "ph", 1)
	
	//per 100 admissions vars
	sum `staffper100adm'r, detail
	sum `staffper100adm'a, detail
	
	display "============================================================="
	display ""
}