--Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/9sR16Q
CREATE TABLE "Employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "Dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_Dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "Salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_Salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("title_id");

ALTER TABLE "Dept_emp" ADD CONSTRAINT "fk_Dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Dept_emp" ADD CONSTRAINT "fk_Dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");


SELECT * FROM public."Titles";
SELECT * FROM public."Employees";

1. /*List the employee number, last name, first name, sex, and salary of each employee.*/
SELECT public."Employees".emp_no, public."Employees".last_name, public."Employees".first_name, public."Employees".sex, public."Salaries".salary
FROM public."Employees"
LEFT JOIN  public."Salaries"
ON (public."Employees".emp_no =  public."Salaries".emp_no);


2. /*List the first name, last name, and hire date for the employees who were hired in 1986.*/
SELECT public."Employees".emp_no, public."Employees".last_name, public."Employees".hire_date
FROM public."Employees"
WHERE public."Employees".hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY public."Employees".hire_date;

3. /*List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.*/
SELECT public."Dept_manager".emp_no, public."Dept_manager".dept_no, public."Employees".last_name, public."Employees".first_name
FROM public."Dept_manager"
LEFT JOIN public."Employees"
ON (public."Employees".emp_no =  public."Dept_manager".emp_no);

SELECT public."Departments".dept_no, public."Departments".dept_name, public."Dept_manager".emp_no, public."Employees".last_name, public."Employees".first_name
FROM public."Departments"
JOIN public."Dept_manager"
ON public."Departments".dept_no = public."Dept_manager".dept_no
JOIN public."Employees"
ON public."Dept_manager".emp_no = public."Employees".emp_no;


4. -- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.--
SELECT public."Dept_emp".emp_no, public."Employees".last_name, public."Employees".first_name, public."Departments".dept_name
FROM public."Dept_emp"
JOIN public."Employees"
ON public."Dept_emp".emp_no = public."Employees".emp_no
JOIN public."Departments"
ON public."Dept_emp".dept_no = public."Departments".dept_no;

5. --List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.--
SELECT public."Employees".first_name, public."Employees".last_name, public."Employees".sex
FROM public."Employees"
WHERE public."Employees".first_name = 'Hercules'
AND public."Employees".last_name Like 'B%'

6. --List each employee in the Sales department, including their employee number, last name, and first name.--
SELECT public."Departments".dept_name, public."Employees".last_name, public."Employees".first_name
FROM public."Dept_emp"
JOIN public."Employees"
ON public."Dept_emp".emp_no = public."Employees".emp_no
JOIN public."Departments"
ON public."Dept_emp".dept_no = public."Departments".dept_no
WHERE public."Departments".dept_name = 'Sales';

7. --List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.--
SELECT public."Dept_emp".emp_no, public."Employees".last_name, public."Employees".first_name, public."Departments".dept_name
FROM public."Dept_emp"
JOIN public."Employees"
ON public."Dept_emp".emp_no = public."Employees".emp_no
JOIN public."Departments"
ON public."Dept_emp".dept_no = public."Departments".dept_no
WHERE public."Departments".dept_name = 'Sales' 
OR public."Departments".dept_name = 'Development';

8. --List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).--
SELECT public."Employees".last_name,
COUNT(public."Employees".last_name) AS "frequency"
FROM public."Employees"
GROUP BY public."Employees".last_name
ORDER BY
COUNT(public."Employees".last_name) DESC;

