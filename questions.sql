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

-- Use the explation below if you are stuck on what parts of a query to use
-- SELECT   -> list the columns (and expressions) to be returned from the query​
-- FROM     -> indicate the table(s) or view(s) from which data will be obtained​
-- WHERE    -> (Comparison operators, AND, OR, is not null, in/not in, between) indicate the conditions under which a row will be included in the result​
-- GROUP BY -> (using aggregate functions AVG, MIN, MAX, SUM and COUNT) indicate categorization of results ​
-- HAVING   -> indicate the conditions under which a category (group) will be included​
-- ORDER BY -> Sorts the result according to specified criteria

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
		from staff left outer join nurseward
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
		
	--Give all patients that originate from the same state as “Mitchell Newell”. 
	--Do not include Mitchell Newell in the results.
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
	--Q1: Give employee Id, name, and date hired of the managers who have the highest experience (years employed) order by employee name.
		select employeeid, employeename, employeedatehired
		from employee_t
		where employeedatehired in (
			select min(employeedatehired)
			from employee_t
		) order by employeename

	--Q1: Give employee Id, name, and date hired of the managers who have the highest experience (years employed) order by employee name.
		select subno, subname, quota
		from subject
		where quota in (
			select min(quota)
			from subject
		) order by subname

	--Q4 (L7 or 6):  Give all manager names and date hired for managers whose work experience is higher than the work experience of their employees. List results in managers' name order.
		select employeename, employeedatehired
		from employee_t M
		where employeeID = any (
			select employeesupervisor 
			from employee_t 
			)
		and employeedatehired <= (
			select min (employeedatehired)
			from employee_T E
			where E.employeesupervisor = M.employeeid
			)
		order by employeename;
	--Q4 (L7 or 6):  Give all subject names and quotas for prerequisites whose quota is higher than the quota of their subjects. List results in subject' name order.
		select subname, quota
		from subject sp
		where subno = any (
			select prerequisiteno
			from subject 
			)
		and quota <= (
			select min (quota)
			from subject s
			where s.prerequisiteno = sp.subno
			)
		order by subname;

	--Q2 (L7): List Material ID and Product Id in which the Material has the highest quantity required for this material. List results in order of Material ID.
		select materialid, productid
		from uses_t u0
		where quantityrequired = (
			select max(quantityrequired)
			from uses_t u1
			where u1.materialid = u0.materialid
		) order by materialid

	--Q2 (L7): List sno and subjectno in which the student has the highest mark required for this subject. List results in order of subjectno.
		select subno, sno
		from enroll e0
		where mark = (
			select max(mark)
			from enroll e1
			where e1.subjectno = e0.subjectno --can swap subno with stuno
		) order by subjectno

	-- Q3 (L7): For products that have used materials, show the product ID, product description, material ID, and quantity required of materials whose quantity required is higher than the average quantity required for that material.  Sort the results by product ID and then by material ID.
		select u0.productid, p.productdescription, u0.materialid, u0.quantityrequired
		from product_t p inner join uses_t u0
		on u0.productid = p.productid
		where quantityrequired > (
			select avg(quantityrequired)
			from uses_t
			where materialid = u0.materialid
		) order by productid, materialid

	-- Q3 (L7): For products that have used materials, show the product ID, product description, material ID, 
	-- and quantity required of materials whose quantity required is higher than the average quantity required 
	-- for that material.  Sort the results by product ID and then by material ID.
		select e.subno, s.subname, e.sno, e.mark
		from subject s inner join enroll e
		on e.subno = s.subno
		where mark > (
			select avg(mark)
			from enroll
			where sno = e.sno
		) order by subno, sno
}

----REVIEW WEEK 12-----
{
	--List all student numbers who have any marks higher than 90 in student number order.(Only display each student's number once)
		Select distinct(e.sno)
		from enroll e
		where e.mark>90
		order by 1

	--For each student, show their student number and their average mark as amark. ONly show marks between student number '9800010' and '9800023'
	-- order by average mark
		select sno, avg(mark) as amark
		from enroll
		where sno >= '9800010' and sno <= '9800023'
		group by sno
		order by 2

	-- Give the lowest mark for each student. Only list students whose lowest mark is <50.
	--Show their student number and their lowest mark as 'mmark'list the results in student number order
		select distinct sno, mark as mmark
		from enroll
		where mark < 50
		order by 1 --INCOMPLETE!!!!!

	-----------------------------------------------------------------HARDER QUESTIONS--------------------------------------------------------------------------

	-- List student number, name and telephone number where their average mark is less than 60 
	-- and have enrolled in more than 2 subjects list the result in descending student number order
		select distinct s.sno, sname, telno
		from student s inner join enroll e
		on s.sno = e.sno
		group by s.sno, e.sno
		having s.sno in (
			select sno
			from enroll
			group by sno
			having avg(mark) < 60 and count(sno) > 2
		) Order by 1 desc

	-- List all subject number and subject name for subjects that have the same quota as subject '31434'
	-- do not include subject 31434 in the results. list results based on subject number in ascending order
		select subno, subname
		from subject
		where quota in (
			select quota
			from subject
			where subno = '31434'
		) and subno != '31434'
		order by 1
		
	-- Display the subject number, subject name, student number of students who have recived a mark higher than average in this subject
	-- sort results on student number and subject number
		select e.sno, s.sname, subno, mark
		from student s inner join enroll e
		on s.sno = e.sno
		where mark > (
			select avg(mark)
			from enroll e2
			where e2.subno = e.subno
		) order by 1, subno
		
	---------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------EXAM 2-----------------------------------------------------------------------------

	-- List all subject's with quotas of less than 350. Show bith the subjects name and quota
	-- Sort the results in quota ascending and name descending order
		SELECT subname, quota FROM Subject 
		WHERE quota < 350
		ORDER BY quota asc, subname desc
		
	-- For each student, show their student number and their average mark as amark. ONly show marks between student number '9800010' and '9800023'
	-- List the results in student number order
		SELECT sno, avg(mark) as amark FROM Enroll
		WHERE sno BETWEEN '9800010' AND '9800023'
		GROUP BY sno
		ORDER BY sno
		
	-- Give the lowest mark for each student, by showing their student number and their lowest mark as 'mmark'. Only lsit students who have enrolled for more
	--than 3 subjects.
	-- List the results in student number order
		SELECT sno, min(mark) as mmark FROM Enroll
		GROUP BY sno
		HAVING count(subno) > 3
		ORDER BY sno
		
	-- List all the subjects and marks for the student '9800024'. Show the subjects number, subjets name and mark 
	-- Sort the results by mark and then by subject number
		SELECT e.subno, subname, mark FROM Enroll e
		INNER JOIN Subject s ON e.subno = s.subno
		WHERE sno = '9800024'
		ORDER BY mark, subno
		
	-- List student number and name of students who have an average mark is higher than 75
	-- List the results in student number order
		SELECT s.sno, sname FROM Student s
		INNER JOIN Enroll e ON s.sno = e.sno
		GROUP BY s.sno
		HAVING avg(mark) > 75
		ORDER BY 1
		
	-- List all subjects, showing subject number and subject name, that have a quota lower than the quota for subject '31434'.
	-- List results in descending subject number order
		SELECT subno, subname FROM Subject
		WHERE quota < (SELECT quota FROM Subject 
			       WHERE subno = '31434')
		ORDER BY 1 desc
	
	-- For subjects that have more enrolled students than their prerequisite subject, show their subject number, subject name and quota
	-- In the order if quota followed by subject number 
		SELECT s1.subno, s1.subname, s1.quota FROM Subject s1
		INNER JOIN (SELECT prerequisiteno, sno FROM Subject s2 
			    INNER JOIN Enroll e ON prerequisiteno = e.subno
			    GROUP BY prerequisiteno) pre
		ON s1.prerequisiteno = pre.prerequisiteno
		-- INCOMPLETE!!!! QAQ ;-;
}

----Mock SQL
{
	-- 1. List all the companies that have a quota of more than 7 students in alphabetical order.
		select subno, quota
		from subject
		where quota > 7
		order by subno asc

	-- 2. What is the average quota for companies
		select round(avg(quota), 2) as average_quota
		from subject

	-- 3. List all the students doing internships that are still in progress (i.e. don’t yet have a mark) for companies with ‘tu’ in their name.
		select s.sno, s.sname, c.subname
		from student s inner join enroll i 
		on s.sno=i.sno inner join subject c 
		on i.subno = c.subno
		where i.mark is null
		and subname LIKE ‘%tu%’
	
	-- 4. List all companies that have a quota divisible by 4 (without remainder).
		select quota 
		from subject
		where mod(quota, 4) = 0

	-- 5. List the students that have done more than 3 internships.
		select sno, count(sno) as count
		from enroll
		group by sno
		having count(sno) > 3;

	-- 6. List all the students that have received a mark of 0 for their internships.
		--CROSS JOINS
		SELECT distinct i.sno, s.sname, c.subname
		FROM subject c, enroll i, student s
		WHERE c.subno = i.subno 
		AND i.sno = s.sno
		AND mark = 0;

		--INNER JOINS
		SELECT distinct i.sno, s.sname, c.subname
		FROM subject c INNER JOIN enroll i 
		on c.subno = i.subno INNER JOIN student s 
		on i.sno = s.sno
		WHERE mark = 0;

	-- 7. Find the student that has the highest mark for any internship.
		select distinct(i.sno), s.sname, i.mark, c.subname
		FROM subject c, enroll i, student s
		where s.sno = i.sno
		and c.subno = i.subno
		and i.mark = (
			select max(mark)
			from enroll
		);

	-- 8. Which students have never done an internship?
		--Using Outer Join
		select s.sno, s.sname
		from student s left outer join enroll i
		on s.sno = i.sno
		where i.sno is null;

		--Using Corrolated Subquery
		select s.sno, s.sname
		from student s
		where s.sno NOT IN (
			select sno
			from enroll s1
			where s1.sno = s.sno
		);

	-- 9. List the average internship mark (rounded to 2 decimal places) for all students. 
	-- Make sure to exclude internships that are not yet completed. Order from highest average to lowest average.
		select i.sno, round(avg(i.mark), 2) as avg_mark
		from enroll i
		where i.mark is not null
		group by i.sno
		order by 2 desc;

	-- 10. List the average internship mark (rounded to 2 decimal places) for all companies that have had students 
	-- successfully complete internships. Order from highest average to lowest average.
		select subno, round(avg(i.mark), 2) as avg_mark
		from enroll i
		where mark is not null
		group by i.subno
		order by 2 desc;

	-- 11. Which internships have prerequisites and which companies are they at?
		select c1.subname, c2.subname as prereq_company
		from subject c1 inner join subject c2
		on c1.prerequisiteno = c2.subno
		where c1.prerequisiteno is not null;

	-- 12. How many companies do not have prerequisites?
		select count(*) as without_prereqs
		from subject 
		where prerequisiteno is null;

	-- 13. Determine which companies are the prerequisites for other companies and the number of companies they are a prerequisite for.
		select c1.subno, c1.subname, count(c2.prerequisiteno) as num_prereq_for
		from subject c1, subject c2
		where c1.subno = c2.prerequisiteno
		group by c1.subno, c1.subname
		order by num_prereq_for desc;

	-- List all students that have achieved a mark greater than the average mark for that specific subject.
		SELECT sno
		FROM enroll e1
		WHERE mark > (
			SELECT avg(mark)
			FROM enroll e2
			WHERE e2.subno = e1.subno);
}

----SQL PRACTICE EXAM 1
{
	-- L1-0 List pizzas with the substring 'i' anywhere within the pizza name.
		select pizza from menu where pizza like '%i%';

	-- L2-3 Give the average price of pizzas from each country of origin. Change the column name related to average price to "average".
		select country, avg(price) as average
		from menu 
		where country is not null
		group by country

	-- L3-6 Give the average price of pizzas from each country of origin, do not list countries with only one pizza.
		select country, avg(price)
		from menu
		where country is not null 
		group by country
		having count(country) > 1;
	
	-- L4-9 List all ingredients and their types for the 'margarita' pizza. Do not use a subquery.
		select distinct recipe.ingredient, type
		from recipe left join items
		on recipe.ingredient = items.ingredient
		where recipe.pizza = 'margarita'

	-- L5-12 Give pizzas and prices for pizzas that are more expensive than all Italian pizzas. 
		select pizza, price
		from menu
		where price > (
			select max(m1.price)
			from menu m1
			where m1.country = 'italy')

	-- L6-18 Give all pizzas that originate from the same country as the 'siciliano' pizza.  Do not include 'siciliano' pizza in your result table. Sort your results based on pizza.
		Select pizza
		from menu
		where country in (
			select country
			from menu
			where pizza = 'siciliano'
		) and pizza != 'siciliano'
		order by pizza
	
	-- L7-21 List each ingredient and the pizza that contains the largest amount of this ingredient.
		select ingredient, pizza, amount
		from recipe r0
		where amount = (
			select max(amount)
			from recipe r1
			where r1.ingredient = r0.ingredient
		)
}

----SQL PRACTICE EXAM 2
{
	-- L1-1 List all pizzas, giving pizza name, price and country of origin where the country of origin has NOT been recorded (i.e. is missing).
		select pizza, price, country
		from menu
		where country is null
	
	-- L2-4 Give the most expensive pizza price from each country of origin. Sort your results by country in ascending order.
		select country, max(price)
		from menu
		where country is not null
		group by country
		order by country;
	
	-- L3-7 Give the average price of pizzas from each country of origin, only list countries with 'i' in the country's name. Sort your results based on country in ascending order.
		select country, avg(price) as avg
		from menu
		where country is not null
		and country like '%i%'
		group by country
		order by country
	
	--List all 'fish' ingredients used in pizzas, also list the pizza names. Do not use a subquery.
		select r.ingredient, pizza
		from recipe r left join items i
		on r.ingredient = i.ingredient
		where type = 'fish'

	-- List all ingredients for the Mexican pizza (i.e. country = 'mexico'). You must use a subquery.
		select distinct ingredient
		from recipe r
		where pizza in (
			select pizza
			from menu
			where country = 'mexico'
		)

	--List all pizzas that cost more than 'stagiony' pizza, also give their prices. Sort the results based on prices in descending order.
		select pizza, price
		from menu
		where price > (
			select price
			from menu
			where pizza = 'stagiony'
		) order by price desc

	--List ingredients used in more than one pizza. Sort your results in ascending order.
		select ingredient
		from recipe
		group by ingredient
		having count(ingredient) > 1
		order by ingredient asc
}

----SQL PRACTICE EXAM 3
{
	-- List all price categories recorded in the MENU table, eliminating duplicates.
		select distinct price
		from menu

	-- Give the cheapest pizzas from each country of origin. Sort your results by country in ascending order.
		from menu
		where country is not null
		group by country
		order by country;

	-- Give cheapest price of pizzas from each country of origin, only list countries with cheapest price of less than $7.00
		select country, price as min
		from menu
		where price < 7
		and country is not null

	-- List all 'meat' ingredients used in pizzas, also list the pizza names. Do not use a subquery.
		select r.ingredient, pizza
		from recipe r left join items i
		on r.ingredient = i.ingredient
		where type = 'meat'

	-- List pizzas with at least one 'meat' ingredient.You must use a subquery.
		select distinct pizza
		from recipe
		where ingredient in (
			select ingredient
			from items
			where type = 'meat')

	--List all pizzas that cost less than 'siciliano' pizza, also give their prices.
		select pizza, price
		from menu
		where price < (
			select price
			from menu
			where pizza = 'siciliano')

	-- List the ingredients, and for each ingredient, also list the pizza that contains the largest amount of this ingredient.
		select ingredient, pizza, amount
		from recipe r0
		where amount = (
			select max(amount)
			from recipe r1
			where r1.ingredient = r0.ingredient
		)
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
