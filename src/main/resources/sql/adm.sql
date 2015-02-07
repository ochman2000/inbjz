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


insert into answers values (101, 'select * from dual;', sysdate, sysdate);
insert into tasks values (101, 1, 1, 'Wykonaj swoje pierwsze zapytanie i zatwierdź kombinacją klawiszy Ctrl+Enter.', 101, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (102, 'SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=''PUBLIC'';', sysdate, sysdate);
insert into tasks values (102, 1, 2, 'Pokaż wszystkie tabele w schemacie ''PUBLIC'', używając poniższej składni SQL:', 102, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (103, null, sysdate, sysdate);
insert into tasks values (103, 1, 3, 'Utwórz schemat <swojenazwisko>_<nr albumu> za pomocą polecenia:
CREATE SCHEMA kowalski_123456;', 103, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (104, null, sysdate, sysdate);
insert into tasks values (104, 1, 4, 'Usuń schemat <swojenazwisko>_<nr albumu> za pomocą polecenia:
DROP SCHEMA kowalski_123456;
a następnie stwórz go ponownie:
CREATE SCHEMA kowalski_123456;', 104, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (105, null, sysdate, sysdate);
insert into tasks values (105, 1, 5, '<h4>Stwórz tabelę OSOBY zawierającą:
                <ul>
                    <li>definicję klucza głównego nr_osoby typu int,</li>
                    <li>imię – znakowy o 40 znakach,</li>
                    <li>nazwisko – analogicznie, adres znakowy o 500 znakach,</li>
                    <li>wiek int.</li>
                </ul>
            </h4>', 105, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (106, null, sysdate, sysdate);
insert into tasks values (106, 1, 6, 'Sprawdź, ile rekordów znajduje się w tabeli OSOBY.', 106, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (107, null, sysdate, sysdate);
insert into tasks values (107, 1, 7, '<h4>Wstaw do tabeli jeden rekord:
                <ul>
                    <li>imię: Baba,</li>
                    <li>nazwisko: Jaga,</li>
                    <li>adres: Domek z Piernika 100,</li>
                    <li>wiek 154.</li>
                </ul>
            </h4>', 107, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (108, null, sysdate, sysdate);
insert into tasks values (108, 1, 8, 'Wyświetl wszystkie rekordy z tabeli OSOBY.', 108, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (109, null, sysdate, sysdate);
insert into tasks values (109, 1, 9, 'Sprawdź ponownie, ile rekordów jest w tabeli OSOBY.', 109, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (110, null, sysdate, sysdate);
insert into tasks values (110, 1, 10, ' <h4>Utwórz drugą tabelę DZIECI o następującej strukturze:
                <ul>
                    <li>nr_dziecka; int przyrostowy od 100 co 1,</li>
                    <li>nr_osoby; int,</li>
                    <li>imie; znakowy do 40 znaków.</li>
                </ul>
            </h4>', 110, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (111, null, sysdate, sysdate);
insert into tasks values (111, 1, 11, '<h4>Wstaw do tabeli OSOBY jeden rekord:
                <ul>
                    <li>Baba Jaga</li>
                </ul>
            </h4>', 111, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (112, null, sysdate, sysdate);
insert into tasks values (112, 1, 12, '<h4>Wstaw do tabeli DZIECI dwa rekordy:
                <ul>
                    <li>Jaś</li>
                    <li>Małgosia</li>
                </ul>
            </h4>', 112, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (113, null, sysdate, sysdate);
insert into tasks values (113, 1, 13, 'Dodaj do tabeli OSOBY kolumnę data_wpisu zawierającą automatycznie datę wpisu rekordu.', 113, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (114, null, sysdate, sysdate);
insert into tasks values (114, 1, 14, '<h4>Wstaw do tabeli OSOBY kolejny rekord:
                <ul>
                    <li>imię: Matka,</li>
                    <li>nazwisko: Chrzestna,</li>
                    <li>adres Wróżkolandia,</li>
                    <li>wiek 105.</li>
                </ul>
            </h4>', 114, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (115, null, sysdate, sysdate);
insert into tasks values (115, 1, 15, 'Dopisz do tabeli DZIECI Kopciuszka tak, żeby jego id_dziecka = 10.', 115, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (116, null, sysdate, sysdate);
insert into tasks values (116, 1, 16, 'Załóż ograniczenie, które od tej pory nie pozwoli na wprowadzanie osób starszych niż 100 lat.', 116, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (117, null, sysdate, sysdate);
insert into tasks values (117, 1, 17, 'Sprawdź na przykładach, czy ograniczenie działa.', 117, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (118, 'HELP', sysdate, sysdate);
insert into tasks values (118, 1, 18, 'Wyświetl dokumentację bazy danych za pomocą polecenia: HELP', 118, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (201, null, sysdate, sysdate);
insert into tasks values (201, 2, 1, 'Utworzyć schemat o nazwie biblioteka_<nr albumu>.', 201, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (202, null, sysdate, sysdate);
insert into tasks values (202, 2, 2, '', 202, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (203, null, sysdate, sysdate);
insert into tasks values (203, 2, 3, '', 203, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (204, null, sysdate, sysdate);
insert into tasks values (204, 2, 4, '', 204, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (205, null, sysdate, sysdate);
insert into tasks values (205, 2, 5, '', 205, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (206, null, sysdate, sysdate);
insert into tasks values (206, 2, 6, '', 206, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (207, null, sysdate, sysdate);
insert into tasks values (207, 2, 7, '', 207, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (208, null, sysdate, sysdate);
insert into tasks values (208, 2, 8, '', 208, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (209, null, sysdate, sysdate);
insert into tasks values (209, 2, 9, '', 209, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (210, null, sysdate, sysdate);
insert into tasks values (210, 2, 10, '', 210, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (211, null, sysdate, sysdate);
insert into tasks values (211, 2, 11, '', 211, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (212, null, sysdate, sysdate);
insert into tasks values (212, 2, 12, '', 212, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (213, null, sysdate, sysdate);
insert into tasks values (213, 2, 13, '', 213, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (214, null, sysdate, sysdate);
insert into tasks values (214, 2, 14, '', 214, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (215, null, sysdate, sysdate);
insert into tasks values (215, 2, 15, '', 215, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (216, null, sysdate, sysdate);
insert into tasks values (216, 2, 16, '', 216, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (217, null, sysdate, sysdate);
insert into tasks values (217, 2, 17, '', 217, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (218, null, sysdate, sysdate);
insert into tasks values (218, 2, 18, '', 218, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (219, null, sysdate, sysdate);
insert into tasks values (219, 3, 19, '', 219, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (220, null, sysdate, sysdate);
insert into tasks values (220, 3, 20, '', 220, 'CREATE', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (301, 'select nazwisko, placa from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (301, 3, 1, 'Podaj nazwiska pracowników i ich płace.', 301, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (302, 'select nazwisko, placa/25 from test_pracownicy.pracownicy;', sysdate, sysdate);
insert into tasks values (302, 3, 2, 'Podaj nazwiska i wartość dniówek pracowników.', 302, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

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

insert into answers values (401, null, sysdate, sysdate);
insert into tasks values (401, 4, 1, '', 401, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (402, null, sysdate, sysdate);
insert into tasks values (402, 4, 2, '', 402, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (403, null, sysdate, sysdate);
insert into tasks values (403, 4, 3, '', 403, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (404, null, sysdate, sysdate);
insert into tasks values (404, 4, 4, '', 404, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (405, null, sysdate, sysdate);
insert into tasks values (405, 4, 5, '', 405, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (406, null, sysdate, sysdate);
insert into tasks values (406, 4, 6, '', 406, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (407, null, sysdate, sysdate);
insert into tasks values (407, 4, 7, '', 407, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (408, null, sysdate, sysdate);
insert into tasks values (408, 4, 8, '', 408, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (409, null, sysdate, sysdate);
insert into tasks values (409, 4, 9, '', 409, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (410, null, sysdate, sysdate);
insert into tasks values (410, 4, 10, '', 410, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (411, null, sysdate, sysdate);
insert into tasks values (411, 4, 11, '', 411, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (412, null, sysdate, sysdate);
insert into tasks values (412, 4, 12, '', 412, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (413, null, sysdate, sysdate);
insert into tasks values (413, 4, 13, '', 413, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (414, null, sysdate, sysdate);
insert into tasks values (414, 4, 14, '', 414, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (415, null, sysdate, sysdate);
insert into tasks values (415, 4, 15, '', 415, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (416, null, sysdate, sysdate);
insert into tasks values (416, 4, 16, '', 416, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (417, null, sysdate, sysdate);
insert into tasks values (417, 4, 17, '', 417, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (418, null, sysdate, sysdate);
insert into tasks values (418, 4, 18, '', 418, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (419, null, sysdate, sysdate);
insert into tasks values (419, 4, 19, '', 419, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (420, null, sysdate, sysdate);
insert into tasks values (420, 4, 20, '', 420, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');


insert into answers values (501, null, sysdate, sysdate);
insert into tasks values (501, 5, 1, '', 501, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (502, null, sysdate, sysdate);
insert into tasks values (502, 5, 2, '', 502, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (503, null, sysdate, sysdate);
insert into tasks values (503, 5, 3, '', 503, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (504, null, sysdate, sysdate);
insert into tasks values (504, 5, 4, '', 504, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (505, null, sysdate, sysdate);
insert into tasks values (505, 5, 5, '', 505, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (506, null, sysdate, sysdate);
insert into tasks values (506, 5, 6, '', 506, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (507, null, sysdate, sysdate);
insert into tasks values (507, 5, 7, '', 507, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (508, null, sysdate, sysdate);
insert into tasks values (508, 5, 8, '', 508, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (509, null, sysdate, sysdate);
insert into tasks values (509, 5, 9, '', 509, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (510, null, sysdate, sysdate);
insert into tasks values (510, 5, 10, '', 510, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (511, null, sysdate, sysdate);
insert into tasks values (511, 5, 11, '', 511, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (512, null, sysdate, sysdate);
insert into tasks values (512, 5, 12, '', 512, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (513, null, sysdate, sysdate);
insert into tasks values (513, 5, 13, '', 513, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (514, null, sysdate, sysdate);
insert into tasks values (514, 5, 14, '', 514, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (515, null, sysdate, sysdate);
insert into tasks values (515, 5, 15, '', 515, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (516, null, sysdate, sysdate);
insert into tasks values (516, 5, 16, '', 516, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (517, null, sysdate, sysdate);
insert into tasks values (517, 5, 17, '', 517, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (518, null, sysdate, sysdate);
insert into tasks values (518, 5, 18, '', 518, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (519, null, sysdate, sysdate);
insert into tasks values (519, 5, 19, '', 519, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (520, null, sysdate, sysdate);
insert into tasks values (520, 5, 20, '', 520, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');


insert into answers values (601, null, sysdate, sysdate);
insert into tasks values (601, 6, 1, '', 601, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (602, null, sysdate, sysdate);
insert into tasks values (602, 6, 2, '', 602, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (603, null, sysdate, sysdate);
insert into tasks values (603, 6, 3, '', 603, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (604, null, sysdate, sysdate);
insert into tasks values (604, 6, 4, '', 604, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (605, null, sysdate, sysdate);
insert into tasks values (605, 6, 5, '', 605, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (606, null, sysdate, sysdate);
insert into tasks values (606, 6, 6, '', 606, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (607, null, sysdate, sysdate);
insert into tasks values (607, 6, 7, '', 607, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (608, null, sysdate, sysdate);
insert into tasks values (608, 6, 8, '', 608, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (609, null, sysdate, sysdate);
insert into tasks values (609, 6, 9, '', 609, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (610, null, sysdate, sysdate);
insert into tasks values (610, 6, 10, '', 610, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (611, null, sysdate, sysdate);
insert into tasks values (611, 6, 11, '', 611, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (612, null, sysdate, sysdate);
insert into tasks values (612, 6, 12, '', 612, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (613, null, sysdate, sysdate);
insert into tasks values (613, 6, 13, '', 613, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (614, null, sysdate, sysdate);
insert into tasks values (614, 6, 14, '', 614, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (615, null, sysdate, sysdate);
insert into tasks values (615, 6, 15, '', 615, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (616, null, sysdate, sysdate);
insert into tasks values (616, 6, 16, '', 616, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (617, null, sysdate, sysdate);
insert into tasks values (617, 6, 17, '', 617, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (618, null, sysdate, sysdate);
insert into tasks values (618, 6, 18, '', 618, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (619, null, sysdate, sysdate);
insert into tasks values (619, 6, 19, '', 619, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

insert into answers values (620, null, sysdate, sysdate);
insert into tasks values (620, 6, 20, '', 620, 'QUERY', 'Łukasz Ochmański', sysdate, sysdate, '1.0.0', 'H2', '1.4.182 (2014-10-17)');

update tasks set question=null where question='';