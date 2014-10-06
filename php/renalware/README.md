#Renalware


Copyright © 2013 Nuagistes Pte (Singapore) Ltd

##IMPORTANT NOTE

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

##USAGE
Currently, Renalware is designed only for use at King's College Hospital under specific conditions and appropriate expertise. It should not be used in any other clinical environment at this time.


##Renalware Installation

###Step 1: Uploading the version as BETA
Move the downloaded .zip file to the server and rename as 'rwbeta1.X.Y.Z' for BETA use where 1.X.Y.Z=the version number (e.g. 1.6.0.1)

###Step 2: Enabling the BETA

There is now a master config_status.php file:

1. Open the file
2. Comment out the DEVEL and LIVE lines
3. Comment in the BETA line i.e. $configstatus='BETA';

###Step 3: Launching a version as LIVE

1. Open the config_status.php file and active the LIVE setting (by commenting/uncommenting)
3. Rename the directory from 'rwbeta1.X.Y.Z' to 'renal'.


