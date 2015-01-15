drop table regions if exists;
CREATE TABLE regions
    ( region_id      INT
       CONSTRAINT  region_id_nn NOT NULL
    , region_name    VARCHAR(25)
    );

ALTER TABLE regions ADD CONSTRAINT reg_id_pk PRIMARY KEY (region_id);

drop table countries if exists;
CREATE TABLE countries
    ( country_id      CHAR(2)
       CONSTRAINT  country_id_nn NOT NULL
    , country_name    VARCHAR(40)
    , region_id       INT
    , CONSTRAINT     country_c_id_pk
        	     PRIMARY KEY (country_id)
    ) ;

ALTER TABLE countries ADD CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES regions(region_id);

drop table locations if exists;
CREATE TABLE locations
    ( location_id    INT NOT NULL
    , street_address VARCHAR(40)
    , postal_code    VARCHAR(12)
    , city       VARCHAR(30)
	CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR(25)
    , country_id     CHAR(2)
    ) ;


ALTER TABLE locations ADD CONSTRAINT loc_id_pk PRIMARY KEY (location_id);
ALTER TABLE locations ADD CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES countries(country_id) ;

drop table departments if exists;
CREATE TABLE departments
    ( department_id    INT NOT NULL
    , department_name  VARCHAR(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       INT
    , location_id      INT
    ) ;


ALTER TABLE departments ADD CONSTRAINT dept_id_pk PRIMARY KEY (department_id);
ALTER TABLE departments ADD CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) REFERENCES locations (location_id);

drop table jobs if exists;
CREATE TABLE jobs
    ( job_id         VARCHAR(10) NOT NULL
    , job_title      VARCHAR(35)
	CONSTRAINT     job_title_nn  NOT NULL
    , min_salary     DECIMAL(10,2)
    , max_salary     DECIMAL(10,2)
    ) ;


ALTER TABLE jobs ADD CONSTRAINT job_id_pk PRIMARY KEY(job_id) ;

drop table employees if exists;
CREATE TABLE employees
    ( employee_id    INT NOT NULL
    , first_name     VARCHAR(20)
    , last_name      VARCHAR(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR(20)
    , hire_date      DATETIME
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR(10)
	CONSTRAINT     emp_job_nn  NOT NULL
    , salary         DECIMAL(10,2)
    , commission_pct DECIMAL(2,2)
    , manager_id     INT
    , department_id  INT
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0)
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;


ALTER TABLE employees ADD CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id);
ALTER TABLE employees ADD CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments(department_id);
ALTER TABLE employees ADD CONSTRAINT emp_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id);
ALTER TABLE employees ADD CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ;


ALTER TABLE departments ADD CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id);

drop table job_history if exists;
CREATE TABLE job_history
    ( employee_id   INT
	 CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATETIME
	CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATETIME
	CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR(10)
	CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id INT
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;


ALTER TABLE job_history ADD CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date);
ALTER TABLE job_history ADD CONSTRAINT jhist_job_fk FOREIGN KEY (job_id) REFERENCES jobs(job_id);
ALTER TABLE job_history ADD CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES employees(employee_id);
ALTER TABLE job_history ADD CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id) REFERENCES departments(department_id);