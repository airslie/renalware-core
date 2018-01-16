About the test files in this folder

### simple.zip

A basic zip file containing one.txt and two.txt, used for testing the ZipArchive class.

### simple_rar.zip

A RAR version of simple.zip

### practices/HSCOrgRefData_Full_example.xml

A trimmed down version of the ODS xml data from NHS TRUD.
Contains three organisations, two of which are practices.
The normal size of the actual file is 365MB.

### practices/fullfile.zip

Contains HSCOrgRefData_Full_example.xml, and is used in specs to simulate the file
that is uploaded in order to update practices. Its a zip file but the actual downloaded
file is a in RAR format. The format is transparent to via the ZipArchive class however.
The normal size of the actual file is around 11MB.

### primary_care_physicians/egpcur.zip

A compressed egbcur.csv containing a small set of GP records for testing PrimaryCarePhysician
imports. The file comes from the TRUD nhs_ods_weekly dataset.
https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/1/subpack/58/releases

