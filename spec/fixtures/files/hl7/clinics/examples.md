# Example ADT clinic apointment messages - MSE

Test Clinic messages

A05 - new appoint
A38 - delete/cancel appoint

No | type | System | Patient | Clinic | Action | Clinic Date | Clinic Time | User | Action Date | Action Time
-- | -- | -- | -- | -- | -- | -- | -- | -- | -- | --
1  | A05 | Bas Med | D7006372 | Grewal (Trauma & Ortho Surg) RG D1 | Make New Appointment | 10/08/2021 | 09:00 | Jchohan | 06/08/2021 | 17:19
2  | A05 | Bas Med | D7006372 | Grewal (Trauma & Ortho Surg) RG D1 | Make New Appointment | 09/08/2021 | 17:30 | Jchohan | 09/08/2021 | 17:01
3  |     | Bas Med | D7006372 | Grewal (Trauma & Ortho Surg) RG D1 | Mark As Attended     |            |       | Jchohan | 09/08/2021 | 17:40 !! NOT RECV
4  | A05 | Bas Med | D7006372 | Grewal (Trauma & Ortho Surg) RG D1 | Make 2nd Appointment | 09/08/2021 | 18:30 | Jchohan | 09/08/2021 | 18:25
5  | A38 | Bas Med | D7006372 |                                    | Cancel Appointment   |            |       | Jchohan | 09/08/2021 | 19:09
6  | A05 | Bas Med | D7006372 | Grewal (Trauma & Ortho Surg) RG D1 | Make Appointment     | 09/08/2021 | 18:45 | Jchohan | 09/08/2021 | 19:10
7  | A38 | Bas Med | D7006372 | Grewal (Trauma & Ortho Surg) RG D1 | Change Date/time     | 11/08/2021 | 09:00 | Jchohan | 09/09/2021 | 20:54
8  | A05 | Send Med | T124545 | Fine (General Surgery) EF4M        | Make New Appointment | 09/08/2021 | 09:30 | Jchohan | 06/08/2021 | 13:54
9  | A05 | Send Med | T124545 | Fine (General Surgery) EF4M        | Mark As Attended     |            |       | Jchohan | 09/08/2021 | 11:17
10 | A05 | Send Med | T124545 | Fine (General Surgery) EF4M        | Make 2nd Appointment | 09/08/2021 | 11:00 | Jchohan | 09/08/2021 | 12:27
11 | A05 | Send Med | T124545 |                                    | Cancel Appointment   |            |       | Jchohan | 09/08/2021 | 13:53
12 | A38 | Send Med | T124545 | Fine (General Surgery) EF4M        | Make Appointment     | 09/08/2021 | 11:30 | Jchohan | 09/08/2021 | 13:57
13 | A05 | Send Med | T124545 | Fine (General Surgery) EF4M        | Change Date/time     | 10/08/2021 | 09:45 | Jchohan | 09/08/2021 | 14:40
14 | A05 | Lorenzo | 21378642 | TEST01                             | Make New Appointment      | 09/08/2021 | 09:00 | Jchohan | 06/08/2021 | 16:50
15 |   ? | Lorenzo | 21378642 | TEST01                             | Mark As Attended          |            |       | Jchohan | 09/08/2021 | 13:04  !! DID NOT RECV
16 | A05 | Lorenzo | 21378642 | TEST01                             | Make 2nd Appointment      | 09/08/2021 | 14:30 | Jchohan | 09/08/2021 | 14:15
17 | A38 | Lorenzo | 21378642 |                                    | Cancel Appointment        |            |       | Jchohan | 09/08/2021 | 14:59
18 | A05 | Lorenzo | 21378642 | TEST01                             | Make Appointment          | 09/08/2021 | 13:00 | Jchohan | 09/08/2021 | 15:10
19 | A38 | Lorenzo | 21378642 | TEST01                             | Change Date/time          | 10/08/2021 | 14:30 | Jchohan | 09/08/2021 | 16:08

# START BAS MED

## 1 make appnt 09:00

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210806171858||ADT^A05|RDD_19891315|P|2.4|||AL|NE|||
EVN|A05|20210806171858||200||20210810090000|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006022AP|||||||||||||||||||||||||||||||||
PV2||||||||20210810090000|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||NS|NOOUT||||||||01|^^^NS^Reason Not Set|

## 2 make appnt 17:30

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210809170113||ADT^A05|RDD_19891341|P|2.4|||AL|NE|||
EVN|A05|20210809170112||200||20210809173000|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006023AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809173000|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||NS|NOOUT||||||||02|^^^NS^Reason Not Set|

## 4 make apnt 18:30

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210809182436||ADT^A05|RDD_19891345|P|2.4|||AL|NE|||
EVN|A05|20210809182436||200||20210809183000|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006024AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809183000|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||NS|NOOUT||||||||02|^^^NS^Reason Not Set|

## 5 cancel 1830

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210809190848||ADT^A38|RDD_19891347|P|2.4|||AL|NE|||
EVN|A38|20210809190848||202||20210809190800|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006024AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809183000|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||4|NOOUT||||||||02|^^^SICK^By hospital - doctor unfit|

## 6 make Appointment 1845

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210809190937||ADT^A05|RDD_19891348|P|2.4|||AL|NE|||
EVN|A05|20210809190936||200||20210809184500|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006025AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809184500|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||NS|NOOUT||||||||02|^^^NS^Reason Not Set|

## Cancel 18:45

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210809205338||ADT^A38|RDD_19891350|P|2.4|||AL|NE|||
EVN|A38|20210809205338||202||20210809205300|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006025AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809184500|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||4|NOOUT||||||||02|^^^HCOVID^By hospital - COVID|

## 7 change 11/08 09:00

MSH|^~\&|MEDWAY|RAJ12|Renalware|MSE|20210809205414||ADT^A05|RDD_19891351|P|2.4|||AL|NE|||
EVN|A05|20210809205413||200||20210811090000|
PID||^NSTS03^^NHS^NHS|D7006372^^^RAJ12^HOSP||Tester-One^Btuh^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|BAS-BA-RG D1^Ad hoc, Ortho, Miss R Grewal, CONS RG D1^BAFRA^RDDH0|||||G8333795^Singh^SK^""^^Dr^^^^^^^GP|C3430343^Grewal^Rupi^""^^Ms^^^^^^^CONS|110|||||||||BAS-OP2107006026AP|||||||||||||||||||||||||||||||||
PV2||||||||20210811090000|||||||||||||||||01||||||||||||||||||||||
ZU1|||||||16||||||03A|1||||||||||||||
ZU3|||NS|NOOUT||||||||02|^^^NS^Reason Not Set|


# START SEND MED

## 8 make appt 9/8 9:30

MSH|^~\&|MEDWAY|RAJ01|Renalware|MSE|20210806135357||ADT^A05|RAJ_24459286|P|2.4|||AL|NE|||
EVN|A05|20210806135357||200||20210809093000|
PID||^NSTS03^^NHS^NHS|T124545^^^RAJ01^HOSP||Tester-One^Suht^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|SOH-EF 4M^General Surgery - EF 4M^OTBBBZ^RAJ01|||||""|C4103770^Fine^Esther^""^^Ms^^^^^^^CONS|100|||||||||SOH-OP2100000023AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809093000|||||||||||||||||1||||||||||||||||||||||
ZU1|||||||13||||||06|1||||||||||||||
ZU3|||NO|""||||||||1|^^^""^Not Set (default)|

## 9 ???

## 10 make appnt 9/8 11:00 SOH-OP2100000024AP

MSH|^~\&|MEDWAY|RAJ01|Renalware|MSE|20210809122650||ADT^A05|RAJ_24459292|P|2.4|||AL|NE|||
EVN|A05|20210809122650||200||20210809110000|
PID||^NSTS03^^NHS^NHS|T124545^^^RAJ01^HOSP||Tester-One^Suht^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|SOH-EF 4M^General Surgery - EF 4M^OTBBBZ^RAJ01|||||""|C4103770^Fine^Esther^""^^Ms^^^^^^^CONS|100|||||||||SOH-OP2100000024AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809110000|||||||||||||||||1||||||||||||||||||||||
ZU1|||||||13||||||06|1||||||||||||||
ZU3|||NO|""||||||||2|^^^""^Not Set (default)|

## 11 cancel 9/8 11:00 SOH-OP2100000024AP

MSH|^~\&|MEDWAY|RAJ01|Renalware|MSE|20210809135322||ADT^A38|RAJ_24459301|P|2.4|||AL|NE|||
EVN|A38|20210809135321||202||20210809135300|
PID||^NSTS03^^NHS^NHS|T124545^^^RAJ01^HOSP||Tester-One^Suht^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|SOH-EF 4M^General Surgery - EF 4M^OTBBBZ^RAJ01|||||""|C4103770^Fine^Esther^""^^Ms^^^^^^^CONS|100|||||||||SOH-OP2100000024AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809110000|||||||||||||||||1||||||||||||||||||||||
ZU1|||||||13||||||06|1||||||||||||||
ZU3|||4|""||||||||2|^^^HOSPCANC^Hospital - COVID|

## 12 Make appt  9/8 11:30 OP2100000025AP

MSH|^~\&|MEDWAY|RAJ01|Renalware|MSE|20210809135701||ADT^A05|RAJ_24459303|P|2.4|||AL|NE|||
EVN|A05|20210809135700||200||20210809113000|
PID||^NSTS03^^NHS^NHS|T124545^^^RAJ01^HOSP||Tester-One^Suht^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|SOH-EF 4M^General Surgery - EF 4M^OTBBBZ^RAJ01|||||""|C4103770^Fine^Esther^""^^Ms^^^^^^^CONS|100|||||||||SOH-OP2100000025AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809113000|||||||||||||||||1||||||||||||||||||||||
ZU1|||||||13||||||06|1||||||||||||||
ZU3|||NO|""||||||||2|^^^""^Not Set (default)|

## 13 cancel 9/8 11:30? OP2100000025AP - says app changed but its A38

MSH|^~\&|MEDWAY|RAJ01|Renalware|MSE|20210809144008||ADT^A38|RAJ_24459305|P|2.4|||AL|NE|||
EVN|A38|20210809144007||202||20210809143900|
PID||^NSTS03^^NHS^NHS|T124545^^^RAJ01^HOSP||Tester-One^Suht^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|SOH-EF 4M^General Surgery - EF 4M^OTBBBZ^RAJ01|||||""|C4103770^Fine^Esther^""^^Ms^^^^^^^CONS|100|||||||||SOH-OP2100000025AP|||||||||||||||||||||||||||||||||
PV2||||||||20210809113000|||||||||||||||||1||||||||||||||||||||||
ZU1|||||||13||||||06|1||||||||||||||
ZU3|||4|""||||||||2|^^^HOSPCANC^Hosp - Appt changed|

## 13 appnt changes 11:30 to 9:45 creates OP2100000026AP

MSH|^~\&|MEDWAY|RAJ01|Renalware|MSE|20210809144042||ADT^A05|RAJ_24459306|P|2.4|||AL|NE|||
EVN|A05|20210809144041||200||20210810094500|
PID||^NSTS03^^NHS^NHS|T124545^^^RAJ01^HOSP||Tester-One^Suht^^^Mr||20000101|M|||2 Middle Mead^Rochford^Essex^^SS4 1RL|||||||||||A||||||||N||NSTS03
PD1|||Rivermead Gate Med.Ctr.^^F81071|G8333795^Singh^SK^^^Dr^^^^^^^GP|||||||||||
PV1||O|SOH-EF 4M^General Surgery - EF 4M^OTBBBZ^RAJ01|||||""|C4103770^Fine^Esther^""^^Ms^^^^^^^CONS|100|||||||||SOH-OP2100000026AP|||||||||||||||||||||||||||||||||
PV2||||||||20210810094500|||||||||||||||||1||||||||||||||||||||||
ZU1|||||||13||||||06|1||||||||||||||
ZU3|||NO|""||||||||2|^^^""^Not Set (default)|

# START LORENZO

## 16

MSH|^~\&|CSCLRC|RAJ32|Renalware|MSE|20210809141542||ADT^A05|650058171196|P|2.4|||AL|NE|||
EVN|A05|20210809141542||OPT-C|||
PID|||21378642^^^RAJ32^HOSP||TESTER-ONE^Meht||20000101|M|||2 Middle Mead^ROCHFORD^^^SS4 1RL|||||||||||B||||||||N||""~""~""
PV1||O|BRM-TEST01^TEST01 - Testing - Raynard - BMFD^A208clinic^RQ8|||||G9710887^MOHABIR^NA^^^DR^^^^^^^NATGP|970775341039^Raynard^Francis^^^MR^^^^^^^SDSID|300|||||||||BRM-2108EN000019|||||||||||||||||||||||||||||||||
PV2||||||||20210809143000|||||||||||||||||||||||||||||||||||||||

## 17

MSH|^~\&|CSCLRC|RAJ32|Renalware|MSE|20210809145915||ADT^A38|650058171204|P|2.4|||AL|NE|||
EVN|A38|20210809145915||OPT-V|||
PID|||21378642^^^RAJ32^HOSP||TESTER-ONE^Meht||20000101|M|||2 Middle Mead^ROCHFORD^^^SS4 1RL|||||||||||B||||||||N||""~""~""
PV1||O|BRM-TEST01^TEST01 - Testing - Raynard - BMFD^A208clinic^RQ8|||||G9710887^MOHABIR^NA^^^DR^^^^^^^NATGP|970775341039^Raynard^Francis^^^MR^^^^^^^SDSID|300|||||||||BRM-2108EN000019|||||||||||||||||||||||||||||||||
PV2||||||||20210809143000|||||||||||||||||||||||||||||||||||||||

## 18

MSH|^~\&|CSCLRC|RAJ32|Renalware|MSE|20210809151002||ADT^A05|650058171210|P|2.4|||AL|NE|||
EVN|A05|20210809151002||OPT-C|||
PID|||21378642^^^RAJ32^HOSP||TESTER-ONE^Meht||20000101|M|||2 Middle Mead^ROCHFORD^^^SS4 1RL|||||||||||B||||||||N||""~""~""
PV1||O|BRM-TEST01^TEST01 - Testing - Raynard - BMFD^A208clinic^RQ8|||||G9710887^MOHABIR^NA^^^DR^^^^^^^NATGP|970775341039^Raynard^Francis^^^MR^^^^^^^SDSID|300|||||||||BRM-2108EN000021|||||||||||||||||||||||||||||||||
PV2||||||||20210809130000|||||||||||||||||||||||||||||||||||||||

## 19

MSH|^~\&|CSCLRC|RAJ32|Renalware|MSE|20210809160820||ADT^A38|650058171213|P|2.4|||AL|NE|||
EVN|A38|20210809160820||OPT-U|||
PID|||21378642^^^RAJ32^HOSP||TESTER-ONE^Meht||20000101|M|||2 Middle Mead^ROCHFORD^^^SS4 1RL|||||||||||B||||||||N||""~""~""
PV1||O|BRM-TEST01^TEST01 - Testing - Raynard - BMFD^A208clinic^RQ8|||||G9710887^MOHABIR^NA^^^DR^^^^^^^NATGP|970775341039^Raynard^Francis^^^MR^^^^^^^SDSID|300|||||||||BRM-2108EN000021|||||||||||||||||||||||||||||||||
PV2||||||||20210810143000|||||||||||||||||||||||||||||||||||||||

## 14

MSH|^~\&|CSCLRC|RAJ32|Renalware|MSE|20210806164753||ADT^A05|650058171143|P|2.4|||AL|NE|||
EVN|A05|20210806164753||OPT-C|||
PID|||21378642^^^RAJ32^HOSP||Tester-One^Meht||20000101|M|||2 Middle Mead^ROCHFORD^^^SS4 1RL|||||||||||||||||||N||""~""~""
PV1||O|BRM-TEST01^TEST01 - Testing - Raynard - BMFD^A208clinic^RQ8|||||G9710887^MOHABIR^NA^^^DR^^^^^^^NATGP|970775341039^Raynard^Francis^^^MR^^^^^^^SDSID|300|||||||||BRM-2108EN000013|||||||||||||||||||||||||||||||||
PV2||||||||20210809090000|||||||||||||||||||||||||||||||||||||||
