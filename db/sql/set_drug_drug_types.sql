#19 Apr 2015
#IMPORTANT FOR DEMO PURPOSES; NOT COMPREHENSIVE!
TRUNCATE drug_drug_types;
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%benzylpenicillin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%flucloxacillin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%amoxicillin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%cephalexin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%cefuroxime%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%ceftriaxone%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%erythromycin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%clarithromycin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%azithromycin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%oxytetracycline:%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%doxycycline:%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%ciprofloxacin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%moxifloxacin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%gentamicin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%trimethoprim%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%nitrofurantoin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%clindamycin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%metronidazole%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%vancomycin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 1, NOW(), NOW() FROM drugs WHERE name LIKE '%chloramphenicol%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 2, NOW(), NOW() FROM drugs WHERE name LIKE '%[ESA]';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 3, NOW(), NOW() FROM drugs WHERE name LIKE '%[IS]';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 4, NOW(), NOW() FROM drugs WHERE name LIKE '%cefotaxime%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 4, NOW(), NOW() FROM drugs WHERE name LIKE '%amoxicillin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 4, NOW(), NOW() FROM drugs WHERE name LIKE '%ofloxacin%';
INSERT INTO drug_drug_types (drug_id, drug_type_id, created_at, updated_at) SELECT id, 4, NOW(), NOW() FROM drugs WHERE name LIKE '%ciprofloxacin%';