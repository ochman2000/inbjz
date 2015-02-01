create table students (
	id INT NOT NULL,
	first_name VARCHAR (100),
	last_name VARCHAR(100),
	date_created DATETIME default sysdate
);
ALTER TABLE students ADD CONSTRAINT students_id_pk PRIMARY KEY (id);


create table tasks (
 id INT NOT NULL
 , section INT NOT NULL
 , number INT NOT NULL
 , question VARCHAR (2000)
 , answer VARCHAR (2000)
 , type VARCHAR (10)
 , author VARCHAR (100)
 , date_created DATETIME default sysdate
);
ALTER TABLE tasks ADD CONSTRAINT tasks_id_pk PRIMARY KEY (id);
CREATE UNIQUE INDEX IDX_TASKS_SECTION_NUMBER ON tasks (section, number);

create table logs(
	id    INT NOT NULL
    , student_id INT
	, session_ID VARCHAR(100)
	, client_id VARCHAR(20)
	, task_id INT
	, answer VARCHAR(2000)
	, correct VARCHAR(5)
	, log_date DATETIME default sysdate
);
ALTER TABLE logs ADD CONSTRAINT logs_log_id_pk PRIMARY KEY (id);
ALTER TABLE logs ADD CONSTRAINT logs_student_fk FOREIGN KEY (student_id) REFERENCES students(id);
ALTER TABLE logs ADD CONSTRAINT logs_task_fk FOREIGN KEY (task_id) REFERENCES tasks (id);

create user student password 'abc';
--GRANT ALTER ANY SCHEMA TO STUDENT;
grant select on students to STUDENT;
REVOKE Insert on students from STUDENT;
REVOKE update on students from STUDENT;
REVOKE delete on students from STUDENT;

grant select on tasks to STUDENT;
REVOKE Insert on tasks from STUDENT;
REVOKE update on tasks from STUDENT;
REVOKE delete on tasks from STUDENT;

grant select on logs to STUDENT;
REVOKE Insert on logs from STUDENT;
REVOKE update on logs from STUDENT;
REVOKE delete on logs from STUDENT;

grant all on countries to student;
grant all on jobs to student;
grant all on employees to student;
grant all on regions to student;
grant all on departments to student;

--select * from information_schema.rights;
--select * from information_schema.COLUMN_PRIVILEGES;
--select * from INFORMATION_SCHEMA.TABLE_PRIVILEGES;
--select * from INFORMATION_SCHEMA.USERS;
