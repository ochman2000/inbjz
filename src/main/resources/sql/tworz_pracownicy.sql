drop schema TEST_PRACOWNICY if exists;
create schema TEST_PRACOWNICY;

CREATE TABLE test_pracownicy.dzialy (
id_dzialu	int, 
nazwa	VARCHAR(15), 
siedziba VARCHAR(15),
CONSTRAINT dzialy_primary_key PRIMARY KEY (id_dzialu)
);

CREATE TABLE test_pracownicy.taryfikator (
kateria	int, 
od int, 
do int
 );

CREATE TABLE test_pracownicy.stanowiska (
stanowisko	VARCHAR(18),
placa_min DECIMAL(10,2), 
placa_max	DECIMAL(10,2), 
CONSTRAINT stan_primary_key PRIMARY KEY (stanowisko)
);

CREATE TABLE test_pracownicy.pracownicy (
nr_akt int, 
nazwisko	VARCHAR(20), 
stanowisko VARCHAR(18),
kierownik int CONSTRAINT prac_self_key REFERENCES pracownicy (nr_akt), 
data_zatr	DATETIME, 
data_zwol	DATETIME, 
placa DECIMAL(10,2), 
dod_funkcyjny DECIMAL(10,2), 
prowizja DECIMAL(10,2), 
id_dzialu	INT,
CONSTRAINT prac_primary_key PRIMARY KEY (nr_akt), 
CONSTRAINT prac_foreign_key FOREIGN KEY (id_dzialu) REFERENCES dzialy (id_dzialu)
);

CREATE TABLE test_pracownicy.prac_archiw (
nr_akt INT, 
nazwisko VARCHAR(20), 
stanowisko VARCHAR(18),
kierownik INT, 
data_zatr DATETIME, 
data_zwol DATETIME, 
placa DECIMAL(10,2), 
dod_funkcyjny DECIMAL(10,2) DEFAULT 0, 
prowizja DECIMAL(10,2) DEFAULT 0, 
id_dzialu	INT
 );
