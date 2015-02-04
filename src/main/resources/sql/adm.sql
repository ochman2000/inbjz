drop table students if exists;
drop table tasks if exists;
drop table answers if exists;
drop table logs if exists;
drop table LOGIN_EVENTS if exists;
drop table logged_answers if exists;
drop SEQUENCE LOGS_SEQ_ID if exists;
drop SEQUENCE LOGGED_ANSWERS_SEQ_ID if exists;

CREATE CACHED TABLE PUBLIC.STUDENTS(
	ID INT NOT NULL,
	FIRST_NAME VARCHAR(100),
	LAST_NAME VARCHAR(100),
	DATE_CREATED DATETIME DEFAULT CURRENT_TIMESTAMP(),
	LAST_SUCCESS_LOGIN DATETIME,
	LAST_ERROR_LOGIN DATETIME,
	STATUS VARCHAR(10),
	SALT VARCHAR(256),
	PASSWORD VARCHAR(256),
	ERROR_COUNTER INT 
);

ALTER TABLE students ADD CONSTRAINT students_id_pk PRIMARY KEY (id);

CREATE CACHED TABLE PUBLIC.TASKS(
 ID INT NOT NULL,
 SECTION INT NOT NULL,
 NUMBER INT NOT NULL,
 QUESTION VARCHAR(2000),
 ANSWER_ID INT,
 TYPE VARCHAR(10),
 AUTHOR VARCHAR(100),
 DATE_CREATED DATETIME DEFAULT CURRENT_TIMESTAMP(),
 DATE_MODIFIED DATETIME,
 QUESTION_VER VARCHAR(10),
 DATABASE_VENDOR VARCHAR(20),
 DATABASE_VER VARCHAR(20) 
 );
ALTER TABLE tasks ADD CONSTRAINT tasks_id_pk PRIMARY KEY (id);
CREATE INDEX IDX_TASKS_ANSWER_ID ON tasks (answer_id);
CREATE UNIQUE INDEX IDX_TASKS_SECTION_NUMBER ON tasks (section, number);

CREATE CACHED TABLE PUBLIC.LOGS(
 ID INT NOT NULL,
 STUDENT_ID INT,
 SESSION_ID VARCHAR(100),
 CLIENT_ID VARCHAR(20),
 TASK_ID INT,
 ANSWER_ID INT,
 CORRECT VARCHAR(5),
 LOG_DATE DATETIME DEFAULT CURRENT_TIMESTAMP() 
 );
ALTER TABLE logs ADD CONSTRAINT logs_log_id_pk PRIMARY KEY (id);
ALTER TABLE logs ADD CONSTRAINT logs_student_fk FOREIGN KEY (student_id) REFERENCES students(id);
ALTER TABLE logs ADD CONSTRAINT logs_task_fk FOREIGN KEY (task_id) REFERENCES tasks (id);
CREATE INDEX IDX_LOGS_STUDENT_ID ON logs (student_id);
CREATE INDEX IDX_LOGS_SESSION_ID ON logs (session_id);
CREATE INDEX IDX_LOGS_TASK_ID ON logs (task_id);
CREATE INDEX IDX_LOGS_LOG_DATE ON logs (log_date);
CREATE INDEX IDX_LOGS_ANS_ID ON logs (answer_id);

create table public.login_events(
	id INT NOT NULL
	, student_id INT
	, session_id INT
	, login_date DATETIME
	, login_input VARCHAR(100)
	, success CHAR(1)
	, ip VARCHAR(40)
	, USER_AGENT VARCHAR(500)
);
ALTER TABLE login_events ADD CONSTRAINT login_events_id_pk PRIMARY KEY (id);
CREATE INDEX IDX_login_events_student_id ON login_events (student_id);
CREATE INDEX IDX_login_events_session_id ON login_events (session_id);
CREATE INDEX IDX_login_events_login_date ON login_events (login_date);

create table public.answers (
	id INT NOT NULL
	, answer VARCHAR(2000)
	, DATE_CREATED DATETIME DEFAULT CURRENT_TIMESTAMP()
	, DATE_MODIFIED DATETIME
);
ALTER TABLE answers ADD CONSTRAINT answers_id_pk PRIMARY KEY (id);
ALTER TABLE tasks ADD CONSTRAINT tasks_answer_fk FOREIGN KEY (answer_id) REFERENCES answers(id);
CREATE SEQUENCE LOGS_SEQ_ID;
CREATE SEQUENCE LOGGED_ANSWERS_SEQ_ID;


create table public.logged_answers (
	id INT NOT NULL
	, answer VARCHAR(2000)
);
ALTER TABLE logged_answers ADD CONSTRAINT logged_answers_pk PRIMARY KEY (id);
ALTER TABLE logs ADD CONSTRAINT logs_answer_fk FOREIGN KEY (answer_id) REFERENCES logged_answers (id);

grant select on students to STUDENT;
grant select on tasks to STUDENT;
grant select on logs to STUDENT;
grant select on login_events to STUDENT;

INSERT INTO PUBLIC.STUDENTS(ID, FIRST_NAME, LAST_NAME, DATE_CREATED, LAST_SUCCESS_LOGIN, LAST_ERROR_LOGIN, STATUS, SALT, PASSWORD, ERROR_COUNTER) VALUES (183566, STRINGDECODE('\u0141ukasz'), STRINGDECODE('Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:04:44.356', TIMESTAMP '2015-01-03 00:07:53.086', TIMESTAMP '2014-11-03 00:08:05.127', 'ACTIVE', '6dd5c1e4-ab2f-11e4-89d3-123b93f75cba', '7B7C2F32BED0AD20BCD9985751B4C3C1A44F5080888A87B9A011850CC4731E3C', 0);

INSERT INTO PUBLIC.TASKS(ID, SECTION, NUMBER, QUESTION, ANSWER_ID, TYPE, AUTHOR, DATE_CREATED, DATE_MODIFIED, QUESTION_VER, DATABASE_VENDOR, DATABASE_VER) VALUES (101, 1, 1, STRINGDECODE('Wykonaj swoje pierwsze zapytanie i zatwierd\u017a kombinacj\u0105 klawiszy Ctrl+Enter. SELECT * FROM DUAL;'), null, 'QUERY', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (102, 1, 2, STRINGDECODE('Poka\u017c wszystkie tabele w schemacie ''PUBLIC'', u\u017cywaj\u0105c poni\u017cszej sk\u0142adni SQL:\nSELECT TABLE_SCHEMA, TABLE_NAME\nFROM INFORMATION_SCHEMA.TABLES\nWHERE TABLE_SCHEMA=''PUBLIC''; '), null, 'QUERY', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (103, 1, 3, STRINGDECODE('Utw\u00f3rz schemat <swojenazwisko>_<nr albumu> za pomoc\u0105 polecenia\nCREATE SCHEMA kowalski_123456;'), NULL, 'CREATE', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (104, 1, 4, STRINGDECODE('Usu\u0144 schemat <swojenazwisko>_<nr albumu> za pomoc\u0105 polecenia:\nDROP SCHEMA kowalski_123456;\na nast\u0119pnie stw\u00f3rz go ponownie:\nCREATE SCHEMA kowalski_123456;'), NULL, 'MODIFY', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (105, 1, 5, STRINGDECODE('Stw\u00f3rz tabel\u0119 OSOBY zawieraj\u0105c\u0105 definicj\u0119 klucza g\u0142\u00f3wnego nr_osoby typu int, imi\u0119 \u2013 znakowy o 40 znakach, nazwisko \u2013 analogicznie, adres znakowy o 500 znakach, wiek int.'), NULL, 'CREATE', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (106, 1, 6, STRINGDECODE('Sprawd\u017a, ile rekord\u00f3w znajduje si\u0119 w tabeli OSOBY.'), NULL, 'TEST', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (107, 1, 7, STRINGDECODE('Wstaw do tabeli jeden rekord imi\u0119 Baba, nazwisko: Jaga, adres: Domek z Piernika 100, wiek 154.'), NULL, 'INSERT', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (108, 1, 8, STRINGDECODE('Wy\u015bwietl wszystkie rekordy z tabeli OSOBY.'), NULL, 'TEST', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (109, 1, 9, STRINGDECODE('Sprawd\u017a ponownie, ile rekord\u00f3w jest w tabeli OSOBY.'), NULL, 'TEST', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (110, 1, 10, STRINGDECODE('Utw\u00f3rz drug\u0105 tabel\u0119 DZIECI o nast\u0119puj\u0105cej strukturze:\nnr_dziecka int przyrostowy od 100 co 1,\nnr_osoby int,\nimie znakowy do 40 znak\u00f3w.'), NULL, 'CREATE', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (111, 1, 11, STRINGDECODE('Wstaw do tabeli 2 rekordy dla osoby Baba Jaga i dzieci Ja\u015b oraz Ma\u0142gosia.'), NULL, 'INSERT', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (112, 1, 12, STRINGDECODE('Dodaj do tabeli OSOBY kolumn\u0119 data_wpisu zawieraj\u0105c\u0105 automatycznie dat\u0119 wpisu rekordu.'), NULL, 'INSERT', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)');
INSERT INTO PUBLIC.TASKS(ID, SECTION, NUMBER, QUESTION, ANSWER_ID, TYPE, AUTHOR, DATE_CREATED, DATE_MODIFIED, QUESTION_VER, DATABASE_VENDOR, DATABASE_VER) VALUES (113, 1, 13, STRINGDECODE('Wstaw do tabeli OSOBY kolejny rekord: imi\u0119: Matka, nazwisko: Chrzestna, adres Wr\u00f3\u017ckolandia, wiek 105.'), NULL, 'INSERT', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (114, 1, 14, STRINGDECODE('Dopisz do tabeli DZIECI Kopciuszka tak, \u017ceby jego id_dziecka = 10.'), NULL, 'ALTER', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (115, 1, 15, STRINGDECODE('Za\u0142\u00f3\u017c ograniczenie, kt\u00f3re od tej pory nie pozwoli na wprowadzanie os\u00f3b starszych ni\u017c 100 lat.'), NULL, 'ALTER', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (116, 1, 16, STRINGDECODE('Sprawd\u017a na przyk\u0142adach, czy ograniczenie dzia\u0142a.'), NULL, 'TEST', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)'), (201, 2, 1, STRINGDECODE('W schemacie <nr albumu>_biblioteka stworzy\u0107 tabel\u0119 \u201eCzytelnicy\u201d z nast\u0119puj\u0105cymi kolumnami:\n\n pole id o 5 znakach powinno sk\u0142ada\u0107 si\u0119 z dw\u00f3ch liter + 3 cyfr, klucz g\u0142\u00f3wny,\n pole nazwisko \u2013 typ znakowy o zmiennej d\u0142ugo\u015bci do 15 znak\u00f3w,\n pole imie \u2013 j.w.,\n pole pesel powinno sk\u0142ada\u0107 si\u0119 z 11 cyfr \u2013 niepuste,\n pole nazwisko, imie, pesel, data_ur \u2013niepuste,\n pole plec 1 znak \u2013 powinno zawiera\u0107 tylko liter\u0119 K lub M,\n pole telefon \u2013 do 15 znak\u00f3w,\n'), NULL, 'CREATE', STRINGDECODE('\u0141ukasz Ochma\u0144ski'), TIMESTAMP '2015-02-03 00:16:59.926', TIMESTAMP '2015-02-03 00:17:07.924', '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (301, 'select nazwisko, placa from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (301, 3, 1, 'Podaj nazwiska pracowników i ich płace.', 301, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values ( 302, 'select nazwisko, placa/25 from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (302, 3, 2, 'Podaj nazwiska i wartość dniówek pracowników.', 301, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (303, 'select nazwisko, placa/25 as dniówka from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (303, 3, 3, 'Dodaj alias ''dniówka'' do poprzedniego zapytania.', 303, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (304, 'select nazwisko, placa*12 from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (304, 3, 4, 'Podaj nazwiska i roczną płacę pracowników.', 304, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (305, 'select nazwisko, placa*12 as roczny_dochód from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (305, 3, 5, 'Dodaj alias ''roczny_dochód'' do poprzedniego zapytania.', 305, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (306, 'select min(placa) from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (306, 3, 6, 'Ile wynosi minimalna płaca w tabeli test_pracownicy.pracownicy?', 306, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (307, 'select nazwisko, stanowisko, placa
from test_pracownicy.pracownicy
where placa<(select avg(placa) from test_pracownicy.pracownicy);', sysdate, sysdate);
insert into tasks values (307, 3, 7, 'Podaj nazwisko, stanowisko i płacę pracownika, który zarabia najmniej.', 307, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (308, 'select nazwisko, stanowisko, placa
from test_pracownicy.pracownicy
where placa<(select avg(placa) from pracownicy);', sysdate, sysdate);
insert into tasks values (308, 3, 8, 'Podaj nazwiska, stanowiska i płace pracowników, którzy zarabiają poniżej średniej w firmie.', 308, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (309, 'select id_dzialu, COUNT(*) as liczba_pracowników
from test_pracownicy.pracownicy
group by id_dzialu
order by liczba_pracowników;', sysdate, sysdate);
insert into tasks values (309, 3, 9, 'Podaj ilu pracowników pracuje w każdym dziale.', 309, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (310, 'select p.nazwisko||'' pracuje w dziale: ''||d.nazwa as wyniki from test_pracownicy.pracownicy p inner join test_pracownicy.dzialy d on p.id_dzialu=d.id_dzialu;', sysdate, sysdate);
insert into tasks values (310, 3, 10, 'Wypisz w postaci jednego łańcucha nazwisko pracownika i w jakim pracuje dziale.', 310, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (311, 'select id_dzialu, stanowisko, COUNT(*) as liczba_etatów
from test_pracownicy.pracownicy
group by id_dzialu, stanowisko;', sysdate, sysdate);
insert into tasks values (311, 3, 11, 'Ilu pracowników zatrudnia każdy dział, na każdym etacie?', 311, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (312, 'select p.nazwisko, d.nazwa, p.placa, s.placa_min, s.placa_max from test_pracownicy.pracownicy p join test_pracownicy.dzialy d on p.id_dzialu=d.id_dzialu join test_pracownicy.stanowiska s on p.stanowisko=s.stanowisko where s.placa_min>1500 and s.placa_max<3500;', sysdate, sysdate);
insert into tasks values (312, 3, 12, 'Podaj nazwiska, nazwę działu, płacę, oraz minimalną i maksymalną płacę, jaką może zarobić pracownik
   na swoim stanowisku, jednakże tylko dla tych stanowisk, dla których płaca minimalna jest większa niż
   1500PLN, a płaca maksymalna mniejsza niż 3500PLN.', 312, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');
   
insert into answers values (313, 'select p.nazwisko, p.placa
from test_pracownicy.pracownicy p
where p.placa>(select max(p.placa) from test_pracownicy.pracownicy p where p.id_dzialu=30);', sysdate, sysdate);
insert into tasks values (313, 3, 13, 'Podaj nazwiska i płace pracowników, ktorzy zarabiają więcej niż którykolwiek pracownik z działu 30.', 313, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (314, 'select p.nazwisko, p.placa,
 (select avg(placa) from test_pracownicy.pracownicy) as średnia,
  (abs((select avg(placa) from test_pracownicy.pracownicy)-p.placa)) as różnica
from test_pracownicy.pracownicy p;', sysdate, sysdate);
insert into tasks values (314, 3, 14, 'Podaj nazwisko pracownika, jego płacę, oraz ile wynosi różnica między jego płacą a średnią płacą w firmie.', 314, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (315, 'select d.nazwa, avg(p.placa) as średnia from test_pracownicy.pracownicy p join test_pracownicy.dzialy d on p.id_dzialu=d.id_dzialu group by d.nazwa;', sysdate, sysdate);
insert into tasks values (315, 3, 15, 'Wypisz nazwę działu i średnią płacę dla jego pracowników.', 315, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (316, 'select p.id_dzialu, p.nazwisko, p.placa
from test_pracownicy.pracownicy p
where p.placa>(
	select avg(t.placa) as średnia
	 from test_pracownicy.pracownicy t  
	  where p.id_dzialu=t.id_dzialu
	   group by t.id_dzialu
	   );', sysdate, sysdate);
insert into tasks values (316, 3, 16, 'Wypisz identyfikator działu, nazwisko i płacę pracowników, którzy zarabiają więcej niż wynosi średnia
   płaca w ich dziale.', 316, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (317, 'select p.nazwisko
from test_pracownicy.pracownicy p
where p.nr_akt in (select t.kierownik from test_pracownicy.pracownicy t);', sysdate, sysdate);
insert into tasks values (317, 3, 17, 'Podaj nazwiska szefów.', 317, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (318, 'select d.id_dzialu from test_pracownicy.dzialy d where not exists (select p.id_dzialu from test_pracownicy.pracownicy p where p.id_dzialu=d.id_dzialu);', sysdate, sysdate);
insert into tasks values (318, 3, 18, 'Podaj identyfikator i nazwę działu, który nie zatrudnia pracowników.', 318, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');