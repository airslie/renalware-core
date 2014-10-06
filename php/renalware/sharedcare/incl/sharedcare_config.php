<?php
//--Tue Sep 30 16:02:07 EDT 2014--
$modulebase="sharedcare";
$brandlabel="Renalware";
$modulelabel="Shared Care Module";
$pagetitles = array(
  'index' => 'Main Menu',
  'list_forms' => 'Shared Care forms (all)',
  'list_current' => 'Shared Care data (current)',
  'add_form' => 'Add Shared Care form',
);

$pagedescrs = array(
  'index' => 'Main Menu (this page)',
  'list_forms' => 'List of all Shared Care questionnaires. Patients may appear more than once.',
  'list_current' => 'List of the actual responses for each patient; most recent form only.',
  'add_form' => 'Locate a patient and enter form data.',
  'show_addform' => 'Shared Care Questionnaire',
);

$questions = array(
    'q1' => 'Functions of the kidney & principles of haemodialysis',
    'q2' => 'Doing my observations',
    'q3' => 'Preparing my dialysis machine',
    'q4' => 'Preparing my pack',
    'q5' => 'Programming my dialysis machine',
    'q6' => 'Preparing my fistula/graft for dialysis',
    'q7' => 'Preparing my tunnelled line for dialysis',
    'q8' => 'Commencing my dialysis',
    'q9' => 'Discontinuing dialysis with my fistula/graft',
    'q10' => 'Discontinuing dialysis with my tunnelled line',
    'q11' => 'After my dialysis',
    'q12' => 'Administering my medications: a) LMWH b) Erythropoietin c) Heparin',
    'q13' => 'Problem solving',
    'q14' => 'Progress review sheet (photocopy as required)'
);

/*
REFERENCE
CREATE TABLE `sharedcaredata
sharedcare_id
sharedcarestamp
sharedcareuid
sharedcareuser
sharedcarezid
sharedcareadddate
sharedcaredate
currentflag
q1interest
q1participating
q1completed
q1completed_by
q1completed_date
q2interest
q2participating
q2completed
q2completed_by
q2completed_date
q3interest
q3participating
q3completed
q3completed_by
q3completed_date
q4interest
q4participating
q4completed
q4completed_by
q4completed_date
q5interest
q5participating
q5completed
q5completed_by
q5completed_date
q6interest
q6participating
q6completed
q6completed_by
q6completed_date
q7interest
q7participating
q7completed
q7completed_by
q7completed_date
q8interest
q8participating
q8completed
q8completed_by
q8completed_date
q9interest
q9participating
q9completed
q9completed_by
q9completed_date
q10interest
q10participating
q10completed
q10completed_by
q10completed_date
q11interest
q11participating
q11completed
q11completed_by
q11completed_date
q12interest
q12participating
q12completed
q12completed_by
q12completed_date
q13interest
q13participating
q13completed
q13completed_by
q13completed_date
q14interest
q14participating
q14completed
q14completed_by
q14completed_date
*/