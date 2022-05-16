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

