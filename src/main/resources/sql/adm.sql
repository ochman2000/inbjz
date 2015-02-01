create user student password 'abc';

create schema adm;

crate table adm.students (
	id INT NOT NULL,
	first_name VARCHAR (100),
	last_name VARCHAR(100),
	date_created DATETIME default sysdate
)
ALTER TABLE adm.students ADD CONSTRAINT adm.students_id_pk PRIMARY KEY (id);
CREATE UNIQUE INDEX adm.IDX_STUDENTS_SECTION_NUMBER ON adm.students (section, number);

create table adm.tasks (
 id INT NOT NULL
 , section INT NOT NULL
 , number INT NOT NULL
 , question VARCHAR (2000)
 , answer VARCHAR (2000)
 , type VARCHAR (10)
 , author VARCHAR (100)
 , date_created DATETIME default sysdate
)
ALTER TABLE adm.tasks ADD CONSTRAINT adm.tasks_id_pk PRIMARY KEY (id);

create table adm.logs(
	id    INT NOT NULL
    , student_id INT
	, session_ID VARCHAR(100)
	, client_id VARCHAR(20)
	, task_id INT
	, answer VARCHAR(2000)
	, correct VARCHAR(5)
	, log_date DATETIME default sysdate
)
ALTER TABLE adm.logs ADD CONSTRAINT adm.logs_log_id_pk PRIMARY KEY (id);
ALTER TABLE adm.logs ADD CONSTRAINT adm.logs_student_fk FOREIGN KEY (student_id) REFERENCES adm.students(id);
ALTER TABLE adm.logs ADD CONSTRAINT adm.logs_task_fk FOREIGN KEY (task_id) REFERENCES adm.tasks (id);

--GRANT ALTER ANY SCHEMA TO STUDENT;
REVOKE Insert on adm.students from STUDENT;
REVOKE update on adm.students from STUDENT;
REVOKE delete on adm.students from STUDENT;

REVOKE Insert on adm.tasks from STUDENT;
REVOKE update on adm.tasks from STUDENT;
REVOKE delete on adm.tasks from STUDENT;

REVOKE Insert on adm.logs from STUDENT;
REVOKE update on adm.logs from STUDENT;
REVOKE delete on adm.logs from STUDENT;

