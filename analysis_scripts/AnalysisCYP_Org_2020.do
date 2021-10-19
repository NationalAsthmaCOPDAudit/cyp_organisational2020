//Section 1: Admissions – numbers and beds

//Part A: Externally sourced admissions data - NOT AVAILABLE

//A. Number of paediatric medical emergencies in the 2018/19 financial year per medical bed at each hospital

//B. Number of paediatric respiratory coded emergency admissions in the 2018/19 financial year

//C. Number of paediatric asthma coded emergency admissions in the 2018/19 financial year

//Section B: Admissions and beds

//1.1 How many paediatric medical beds are there in your hospital which can be used for paediatric asthma patients?
summarize howmanypaediatr_icasthmapatients, detail

//1.2 Does your hospital have a paediatric High Dependency Unit(s) (HDU) to which paediatric asthma patients can be admitted? 
tab doesyourhospita_ntscanbeadmitted

//1.2a How many beds does your paediatric HDU have? 
summarize q1_2ahowmanybed_aediatrichduhave,detail

//1.3 Does your hospital have a Paediatric Intensive Care Unit (PICU) to which paediatric asthma patients can be admitted?
tab q1_3doesyourhos_ntscanbeadmitted

//1.3a How many beds does your PICU have?
summarize q1_3ahowmanybedsdoesyourpicuhave,detail


//Section 2: Staffing levels

//2.1 How many of each of the following staff posts (filled and unfilled) are there in your acute paediatric service? 
tab1 fy1fy2filledcat st1st2filledcat st3andabovefilledcat paediatricconsultantfilledcat paediatricrespi_sultantfilledcat associatespecialistfilledcat staffgradefilledcat asthmanursespecialistfilledcat nurseconsultant_stnursefilledcat specialistrespi_erapistfilledcat paediatricpsychologistfilledcat paediatricpharmacistfilledcat othernotlistedfilledcat

summarize fy1fy2filledwte st1st2filledwte st3andabovefilledwte paediatricconsultantfilledwte paediatricrespi_sultantfilledwte associatespecialistfilledwte staffgradefilledwte asthmanursespecialistfilledwte nurseconsultant_stnursefilledwte specialistrespi_erapistfilledwte paediatricpsychologistfilledwte paediatricpharmacistfilledwte othernotlistedfilledwte, detail

//2.1 Number of unfilled posts in respiratory team
tab1 fy1fy2unfilledcat st1st2unfilledcat st3andaboveunfilledcat paediatricconsultantunfilledcat paediatricrespi_ltantunfilledcat associatespecialistunfilledcat staffgradeunfilledcat asthmanursespecialistunfilledcat nurseconsultant_nurseunfilledcat specialistrespi_rapisunfilledcat paediatricpsych_ogistunfilledcat paediatricpharmacistunfilledcat othernotlistedunfilledcat


//Section 3: Access to specialist staff and services

//3.1 How often are paediatric patients on the paediatric admissions ward routinely reviewed by a senior decision maker (ST3 or above)?
tab1 q3_1aroutinelyr_raboveonweekdays q3_1broutinelyr_raboveonweekends

//3.2 Which admitted paediatric asthma patients have access to a paediatric respiratory nurse?
tab q3_2whichadmitt_respiratorynurse

//3.3 What is your hospital’s access to an on-call paediatric respiratory consultant for paediatric asthma patients?
tab1 q3_3accesstoano_mapatientsonsite q3_3accesstoano_tientsonthephone q3_3accesstoano_loutreachservice

//3.4 Is your service part of a regional paediatric asthma network?
tab q3_4isyourservi_ricasthmanetwork

//3.5 Does your hospital have a designated named clinical lead for asthma services?
tab q3_5designatedn_orasthmaservices

//3.5a Is this role currently filled?
tab q3_5aisthisrolecurrentlyfilled

//3.5b Is the asthma lead responsible for formal training in the management of acute paediatric asthma?
tab q3_5bistheasthm_paediatricasthma

//3.6 Does your hospital have a specific service for paediatric asthma?
tab q3_6doesyourhos_paediatricasthma

//3.6a If not, do you have set criteria for referral to an offsite specialist paediatric asthma service?
tab q3_6aifnotdoyou_ricasthmaservice

//3.7 When children with poor asthma control or severe illness have been identified in clinic, does the asthma lead review the child prior to referral to a specialist paediatric asthma service?
tab q3_7doesasthmal_lorsevereillness

//3.8 Is there a smoking cessation service to which you can refer or signpost parents/carers of your paediatric asthma patients?
tab q3_8smokingcess_ostparentscarers

//3.8a Please let us know more about the provision of this service 
tab q3_8apleaseletu_ionofthisservice

//3.9 Is there a smoking cessation service to which you can refer paediatric asthma patients?
tab q3_9smokingcess_icasthmapatients

//3.9a Please let us know more about the provision of this service
tab q3_9apleaseletu_ionofthisservice

//3.10 Do you have a dedicated service for childhood obesity, to which your paediatric asthma patients can be referred?
tab q3_10doyouhavea_ntscanbereferred

//3.11 Can the paediatric team refer paediatric asthma patients to a home-based community service post discharge?
tab q3_11canthepaed_icepostdischarge

//3.12 In your hospital, do you have access to the following diagnostic tools for paediatric asthma patients?
tab1 q3_1doyouhaveac_tientsspirometry q3_1doyouhaveac_xpiratoryflowpef q3_1doyouhaveac_dnitricoxidefeno q3_1doyouhaveac_ntsskinpricktest q3_1doyouhaveac_thmapatientsnone


//Section 4: 7 day working

//4.1 On which days does your hospital provide a PICU outreach service for critically ill cases requiring PICU management?
tab1 q4_1picuoutreac_vicedaysweekdays q4_1picuoutreac_vicedaysweekends q4_1picuoutreac_cedaysoutofhours q4_1picuoutreac_ooutreachservice

//4.2 On which days does a senior decision maker from paediatric team (ST3 or above) undertake a ward round of new paediatric asthma patients on the Paediatric Admission Unit (PAU)?
tab1 q4_2seniordecis_dpaudaysweekdays q4_2seniordecis_dpaudaysweekends q4_2seniordecis_audaysoutofhours q4_2seniordecis_roundpaudaysnone 

//4.3 On which days does a senior decision maker from paediatric team (ST3 or above) undertake a ward round of new paediatric asthma patients on the paediatric ward(s)?
tab1 q4_3seniordecis_ardsdaysweekdays q4_3seniordecis_ardsdaysweekends q4_3seniordecis_dsdaysoutofhours q4_3seniordecis_ricwardsdaysnone 

//4.4 On which days is a respiratory nurse(s) available to review paediatric asthma inpatients? 
tab1 q4_4respiratory_entsdaysweekdays q4_4respiratory_entsdaysweekends q4_4respiratory_tsdaysoutofhours q4_4respiratory_rynurseavailable


//Section 5: Management of care 

//5.1 Does the paediatric service in your hospital have an Electronic Patient Record (EPR) system?
tab q5_1doesthepaed_trecordeprsystem

//5.2 Does your hospital have a paediatric oxygen policy?
tab q5_2doesyourhos_tricoxygenpolicy

//5.3 Do the ward-based paediatric medication charts/records have a designated place in which to record the prescription of oxygen?
tab q5_3dothewardba_criptionofoxygen

//5.4 Does your hospital use a system of paediatric early warning detection eg. PEWS?
tab q5_4doesyourhos_etectione_g_pews

//5.4a Does your early warning detection system allow the following to be recorded?
tab1 q5_4a_ew_targeto2 q5_4a_ew_actualo2 q5_4adoesyourea_ygenadministered q5_4adoesyourea_ednoneoftheabove

//5.4b Does your early warning detection system incorporate a section in which nurses can record a qualitative measure of how worried they are about the child/young adult?
tab q5_4bearlywarni_echildyoungadult


//Section 6: Patient and carer engagement

//6.1 Does your trust have a strategic group for paediatric asthma services?
tab q6_1doesyourtru_icasthmaservices

//6.1a If yes, does this group patient or parent/carer representation?
tab q6_1aifyesdoest_errepresentation

//6.2 How often is a formal survey seeking patient and parent/carer views on paediatric services undertaken?
tab q6_2howoftenisa_rvicesundertaken


//Section 7: Transitional care

//7.1 Do your processes for transitioning young people from paediatric to adult service include ensuring that:
tab1 q7_1processfort_oftheircondition q7_1processfort_entthesamerecord q7_1processfort_eirparentscarers q7_1processfort_rersareaddressed q7_1processfort_dadultclinicians q7_1processfort_intheadultsystem q7_1processfort_totheadultsystem q7_1processfort_tinuedevaluation q7_1processfort_tionarrangements


//Section 8: Reimbursement for costs of care

//8.1 How is reimbursement of costs of care for paediatric patients with asthma achieved?
tab q8_1howisreimbu_thasthmaachieved

//8.2 Has your commissioner/health board agreed a Commissioning for Quality and Innovation (CQUIN) payment of Local Incentive Payment (LIP) in relation to paediatric asthma care?
tab q8_2hasyourcomm_iatricasthmacare