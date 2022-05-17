----USEFUL FUNCTIONS
{
	SELECT AVG(mark) FROM student;

	SELECT Round(AVG(mark), 2) FROM student;

	SELECT FLOOR(AVG(mark)) FROM student;

	SELECT CEILING(AVG(mark)) FROM student;

	--Using LIKE operator how we use the IN operator
	select productid, productdescription
		from product_t
		where productdescription like'%Table%'
			OR 
			productdescription like'%Desk%';



		select productid, productdescription
		from product_t
		where productdescription like any (ARRAY['%Table%', '%Desk%']);



		select productid, productdescription
		from product_t
		where productdescription like any ('{"%Table%", "%Desk%"}');

	--SQL WILDCARDS

	--USING THE % WILDCARD
	SELECT * FROM student WHERE sname LIKE ‘w%’
	--Returns students whose first names start with w
	SELECT * FROM student WHERE sname LIKE ‘%w%’
	--returns students whose first name contains 'w'

	--USING THE _ WILDCARD
	SELECT * FROM student WHERE sname LIKE '_con'
	--will return student's first name that starts with any character, followed by "con"

	--USING THE [charlist] WILDCARD
	SELECT * FROM student WHERE sname LIKE '[akw]%'
	--selects students with name that starts with a,k or w

	--USING THE [^charlist] WILDCARD
	SELECT * FROM student WHERE sname LIKE '[^akw]%'
	--selects students where name does not start with a, k or w

	--USING THE - WILDCARD
	SELECT * FROM Patient WHERE PatLName LIKE '[a-e]%'
	--selects students whose first name starts with a,b,c,d or e
}

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
	--list all nursing staff members first name, last name and position
	SELECT stafname, stalname, nurposition from staff
	inner join nurse ON staff.staid = nurse.nurid

	SELECT stafname, stalname, nurposition 
	from staff cross join nurse 
	where staff.staid = nurse.nurid

	SELECT stafname, stalname, nurposition 
	from staff, nurse 
	where staff.staid = nurse.nurid

	--list all the ward numbers that have staff members from VIctoria state, eliminate duplicate values and sort ascending
	select distinct wardno
	FROM staff 
		inner join nurse ON staff.staid = nurse.nurid
		inner join nurseward ON nurse.nurid = nurseward.nurid
	where stastate = 'VIC'
	order by 1

	--LIST the ward numbers and the ward name that "CHRISTOPHER HANTON" has worked in
	SELECT w.wardno, wardname
	from staff s
		inner join nurse n on s.staId = n.nurid
		inner join nurseward nw on n.nurid = nw.nurid
		inner join ward w on w.wardno = nw.wardno
	where StafName = 'Christopher'
	and StaLname = 'Hanton';

	--List distinct ward names where nurses have worked in "night" shifts order by name ascending
	Select distinct wardname 
	from nuseward nw, ward w
	where nw.wardno = w.wardno
		and shift = 'Night';

	--List full name of all staff that live in the same state aas staff employee S632
	-- SELF JOINS MUST BE CUSTOM NAMED
	select s1.stafname, s1.stalname
	from staff s1, staff s2
	where s1.stastate = s2.stastate
	and s2.staid = 'S632';

	--List full name and salary of staff who get paid more than Christoper Hanton S632
	Select s1.stafname, s1.stalname, s1.stasalary
	from staff s1, staff s2
	where s2.staid = 'S632'
		and s1.stasalary > s2.stasalary;

	--For Christopher Hanton give his salary, and list the number and name of the wards he has worked in
	Select stacsalary, w.wardno, wardname
	from staff s, nurseward ns, ward w
	where s.staid = ns.nurid
		and ns.wardno = w.wardno
		and s.staid = 'S632';

	--List full name of the staff whose salary fall between the salary of Mikalya Vida and Natasha Laboureyas, not inclusive
	-- Inclusive would allow the use of the <= and >=
	Select s1.stafname, s1.stalname, s1.stacsalary
	from staff s1, staff s2, staff s3
	where s1.stacsalary > s2.stacsalary
		and s1.stacsalary < s3.stacsalary
		and s2.staid = 's837' and s3.staid = 's673';

	-- list all ward umbers and staff ID of those who have worked in them
	select ward.wardno, nurid
	from ward
		left outer join nurseward
			on ward.wardno = nurseward.wardno
	order by ward.wardno;

	select ward.wardno, nurid
	from nurseward
		right outer join ward
			on ward.wardno = nurseward.wardno
	order by ward.wardno;

	--Which staff members have not worked in any wards?
	-- make sure to use the same column in where as was used in the join statement
	select staid
	from staff
		left outer join nurseward
			on staff.staid = nurseward.nurid
	where nurid is null
	order by 1;

	--List all the availible wards in 2014 and the capacity of those that are still availible
	select w1.wardname, w2.wardcap
	from ward2014 w1
		left outer join ward w2
			on w1.wardno = w2.wardno;

	--whaich wards used to be active in 2014, and are not provided anymore?
	select w1.wardname
	from ward2014 w1
		left outer join ward w2
			on w1.wardno = w2.wardno
	where w2.wardno is null;

	--list all the wards that were availible in both the ward2014 and the current wards?
	--wanting to see both sides of table means full outer join
	select w1.wardname, w2.wardname
	from ward2014 w1
		full outer join ward w2
			on w1.wardno = w2.wardno;

	SELECT coalesce(w.wardname, '') || coalesce(w14.wardname, '') as name 
	FROM ward w
		Full Outer Join ward2014 w14 ON w.wardno = w14.wardno
	where w.wardno is null or w14.wardno is null;
	
}

----Sub Query: WEEK 9---
{
	--List all admission dates and symptoms for the patient “Jane Adams”.
		SELECT pm.patadmdate,  pm.patsymp
		FROM patmchart pm, patient p 
		WHERE pm.patid = p.patid
		and patfname = 'Jane' and patlname = 'Adams';

		-- b) Subquery
		SELECT pm.patadmdate,  pm.patsymp 
		FROM patmchart pm
		WHERE patid in (
			SELECT patid
			FROM Patient 
			WHERE patfname = 'Jane' and patlname = 'Adams');

	--Give all patients that originate from the same state as “Mitchell Newell”. Do not include Mitchell Newell in the results.
		SELECT p1.patfname, p1.patlname
		FROM patient p1 inner join patient mitch 
		ON p1.patstate = mitch.patstate and p1.patid != mitch.patid
		Where mitch.Patfname = 'Mitchell' and mitch.patlname = 'Newell';
		-- b) Subquery
		SELECT patfname, patlname 
		From Patient 
		Where PatState = (
			SELECT PatState 
			FROM Patient 
			WHERE Patfname = 'Mitchell' and patlname = 'Newell'
		) AND Patfname != 'Mitchell' and patlname != 'Newell';

	--Give drugs with prices that fall between the price of Nurofen and Morphine inclusively.
		Select d0.drugname, d0.drugprice
		from drug d0, 
			drug d1, 
			drug d2
		where d0.drugprice between d1.drugprice and d2.drugprice
			and d1.drugname = 'Nurofen' and d2.drugname = 'Morphine';
		-- b) subquery
		Select drugname, drugprice
		from drug
		where drugprice between
			(Select drugprice from drug where drugname = 'Nurofen')
			and 
			(Select drugprice from drug where drugname = 'Morphine');

	--Give the name and price of the most expensive drug.
		select d.drugname, d.drugprice
		from drug d
		where d.drugprice = (
			select max(drugprice)
			from drug
		);

	-- List drugs that cost less than the average drug price.
		Select drugname, drugprice 
		From drug 
		where drugprice < (
			SELECT avg(drugprice) 
			from drug
		);
	
	-- Give drug names and prices for drugs that are less 
	-- expensive than all drugs with the dosage “As prescribed 
	-- by doctor” (Hint: use < all predicate).
		Select drugname, drugprice 
		From Drug 
		where drugprice < all(
			SELECT drugprice 
			FROM drug 
			WHERE drugdosg = 'As prescribed by doctor'
		);

	--List all patient IDs and names who have been prescribed Panadol or Nurofen. Sort by patient ids.
		SELECT p.patid, p.patfname, p.patlname
		from patient p
		where p.patid in(
			select distinct patid
			from prescribeddrug
			where drugno in (
				select drugno
				from drug
				where drugname = 'Panadol' 
				or drugname = 'Nurofen'
			)
		)
		Order by patid;

	-- Give the patient(s) name which has been prescribed the largest single prescription amount of Panadol (D1486032).
		Select patfname, patlname
		from patient
		where patid = (
			select distinct patid
			from prescribeddrug
			where drugamt = (
				select max(drugamt)
				from prescribeddrug
				where drugno = 'D1486032'
			) and drugno = 'D1486032'
		);

	--Find the patient chart(s) (patID and patCID) which have the largest number of prescriptions.
		SELECT patid, patcid, count(*) 
		from prescribedDrug
		Group BY patid, patcid
		HAVING count(*) >= ALL(
			Select count(*) FROM prescribedDrug
			group By patid, patcid
		);
	
	--List patient charts (patient id, chart id, admission date, and diagnosis) that have been prescribed Vitamin C. Sort by the admission date. (Hint: you may need to join two tables first and then use a subquery)
		SELECT patid, patcid, patadmdate, patdiag 
		FROM patmchart 
		where (patid, patcid) in (
			SELECT patid, patcid 
			from prescribedDrug 
			where drugno in(
				select drugno
				from drug
				where drugname = 'Vitamin C'
			)
		) order by patadmdate;

	--Give the drug(s) name and description used for the most recent patient chart.
		select drugname, drugdesc
		from drug
		where drugno in(
			select drugno
			from prescribeddrug pd
				inner join patmchart pmt
					on pd.patid = pmt.patid and pd.patcid = pmt.patcid
			where patadmdate = (
				select max(patadmdate) from patmchart
			)
		);
}		

----Correlated Sub Query: WEEK 10---
{
	--List all drugs with method “Oral use with water”and any patient charts that 
	--includes these drugs (Give two different ways of constructing this query). 
	--Show the columns DrugNo, DrugName, DrugMethod and PatCID. Sort results by drugNo
	
		-- method 1:
		select d.drugno, d.drugname, d.drugmethod, pd.patcid
		from drug d left join prescribedDrug pd
		on d.drugno = pd.drugno
		where drugmethod = 'Oral use with water'
		order by drugno;

		-- method 2:
		select d.drugno, d.drugname, d.drugmethod, pd.patcid
		from prescribedDrug pd right join drug d
		on d.drugno = pd.drugno
		where drugmethod = 'Oral use with water'
		order by drugno;

	-- List all drugs with method ‘Oral use with water’ and all patient charts (those patient 
	--charts that include oral use with water drugs and those that do not). Show the columns 
	--patid, patcid, drugno, drugname, drugmethod. Sort by the patid, patcid, drugno
		select pmc.patid, pmc.patcid, dapd.drugno, dapd.drugname, dapd.drugmethod
		from patmchart pmc
		full outer join
			(
				select pd.patid, pd.patcid, d.drugno, d.drugname, d.drugmethod
				from drug d left outer join prescribedDrug pd
				on d.drugno = pd.drugno
				where drugmethod = 'Oral use with water'
			) dapd
			on pmc.patid = dapd.patid
			and pmc.patcid = dapd.patcid
			order by patid, patcid, drugno;

	--Which drugs are not used in any patient chart? (use uncorrelated/simple subquery operation)
		select drugno, drugname 
		from drug
		where drugno NOT IN (
			select drugno from prescribeddrug
		)

	--Which drugs are not used in any patient chart? (use correlated subquery operation)
		select d.drugno, d.drugname 
		from drug d
		where NOT EXISTS 
		(
			select drugno 
			from prescribeddrug pd
			where d.drugno = pd.drugno
		);
	
	--List each drugNo and the patient chartID that have been prescribed with the 
	--largest amount of this drug(use correlated subquery).
		select pd0.drugno, pd0.patcid, pd0.drugamt
		from prescribeddrug pd0
		where drugamt = 
		(
			select max(pd1.drugamt)
			from prescribeddrug pd1
			where pd1.drugno = pd0.drugno
		);

	--List DrugNo that are used in more than one patient chart (use correlated subquery operation). Sort your results based on DrugNo.
		select distinct drugno
		from prescribeddrug pd0
		where drugno in
		(
			select drugno
			from prescribeddrug pd1
			where pd1.patcid <> pd0.patcid 
			and pd1.patid <> pd0.patid
		) order by drugno;
}

----REVIEW: WEEK 11---
{
	--
}

-- Use the explation below if you are stuck on what parts of a query to use
-- SELECT   -> list the columns (and expressions) to be returned from the query​
-- FROM     -> indicate the table(s) or view(s) from which data will be obtained​
-- WHERE    -> (Comparison operators, AND, OR, is not null, in/not in, between) indicate the conditions under which a row will be included in the result​
-- GROUP BY -> (using aggregate functions AVG, MIN, MAX, SUM and COUNT) indicate categorization of results ​
-- HAVING   -> indicate the conditions under which a category (group) will be included​
-- ORDER BY -> Sorts the result according to specified criteria

----HARD QUESTIONS
{
	--
}

----SQL PRACTICE EXAM 1
{
	--
}

----SQL PRACTICE EXAM 2
{
	--
}

----SQL PRACTICE EXAM 3
{
	--
}

----CREATE TABLE
{
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
}

----INSERT DATA
{
	--
}