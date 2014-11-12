DROP TABLE IF EXISTS ethniccodes;
CREATE TABLE ethniccodes (ethnicity varchar(30) DEFAULT NULL, readcode varchar(6) DEFAULT NULL, KEY ethnicity (ethnicity) ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
LOCK TABLES ethniccodes WRITE;
INSERT INTO ethniccodes VALUES ('White','9S1..'),('Black Carribean','9S2..'),('Black African','9S3..'),('Black/other/non-mixed','9S4..'),('Indian','9S6..'),('Pakistani','9S7..'),('Bangladeshi','9S8..'),('Chinese','9S9..'),('Other',NULL),('Refused',NULL);
UNLOCK TABLES;