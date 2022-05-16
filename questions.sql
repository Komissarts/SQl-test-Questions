----BASIC SQL: WEEK 7---
{
	--List every subject in alphabetical order
	select * from Subject ORDER BY subname asc; 

	--List students ordered by mark in descending order
	select * from Student order by mark desc, sname asc; 

	--List all unique marks methods
	select distinct(mark) From student

	--List all subjects with marks less than 10 and have a quota of 5
	select subname from Subject where mark < 10 and quota = 5;

	--list all drugs except those with a dosage of "every 4 hours" or "every 6 hrs"
	select drugname from drug where drugDosg != 'Every 4 hrs' and drugDosg != 'Every 6 hrs';

	--get all information for patients that live in sydney, Mortdale and Ultimo
	select * from patient where patcity in('Sydney', 'Mortdale', 'Ultimo');

	-- List Drugs (only name and price) that cost between 10 and 20 dollars, inclusive
	select drugname, drugprice from drug where drugPrice >= 10 and drugPrice <= 20;

	-- List Drugs with a name ending with letters 'ine'
	select drugname from drug where drugname like '%ine';

	-- List all patients, giving first, last name and whether the number is not null
	select patfname, patlname, patphone from patient where patPhone is not null;

	--Get total number of rows in the drug table
	select count(*) from drug

	-- How Many different drug methods are recorded in the drug table? call the column no_of_methods
	select count(distinct(drugmethod)) as no_of_methods from drug

	--Get the price of the cheapest drug with the method of "Oral use with Water"
	Select min(drugprice) from DRUG where Drugmethod = 'Oral use with water';

	--Get the total price for panadol and Aspirin
	select sum(drugPrice) from drug where drugname in ('Panadol', 'Aspirin');

	--Give the average price of drugs for each DrugMethod. include the drugMethod and average price (called avgPrice) in output
	select drugmethod, round(avg(drugprice), 2) as avgPrice from drug group by drugmethod;

	--Give the average price of drugs for each drug method. Do not include drug methods with only one drug. Include the drug method and average (called average price) in output
	select drugmethod, avg(drugprice) as avgPrice from drug group by drugmethod having count(*) > 1;
}

----Join Tables: WEEK 8---
{
	--
}



----Sub Query: WEEK 9---
{
	--
}


----Correlated Sub Query: WEEK 10---
{
	--
}


----REVIEW: WEEK 11---
{
	--
}



--HARD QUESTIONS
{
	--
}





CREATE TABLE student
(
	sno character(10) NOT NULL,
	sname character(10),
	telno character(10),
	CONSTRAINT student_pkey PRIMARY KEY (sno)
);
CREATE TABLE subject
(
	subno character(5) NOT NULL,
	subname character(25),
	quota integer,
	prerequisiteno character(5),
	CONSTRAINT subject_pkey PRIMARY KEY (subno),
	CONSTRAINT subject_prerequisiteno_fkey FOREIGN KEY (prerequisiteno) REFERENCES subject (subno)
);
CREATE TABLE enroll
(
	sno character(10) NOT NULL,
	subno character(5) NOT NULL,
	mark integer,
	CONSTRAINT enroll_mark_check CHECK (((mark >= 0) AND (mark <= 100))),
	CONSTRAINT enroll_pkey PRIMARY KEY (sno, subno),
	CONSTRAINT enroll_sno_fkey FOREIGN KEY (sno) REFERENCES student (sno),
	CONSTRAINT enroll_subno_fkey FOREIGN KEY (subno) REFERENCES subject (subno)
);

