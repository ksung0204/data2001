CREATE TABLE members (
	member_id INTEGER GENERATED ALWAYS AS IDENTITY,
	member_name VARCHAR(100) NOT NULL,
	member_level INTEGER DEFAULT 1 CHECK (member_level BETWEEN 1 and 5),
	member_contribution INTEGER,
	PRIMARY KEY (member_id)
);

drop table members

CREATE TABLE committees(
	committee_id INTEGER GENERATED ALWAYS AS IDENTITY,
	com_name VARCHAR(20) NOT NULL,
	member_id INTEGER,
	PRIMARY KEY (committee_id),
	CONSTRAINT fk_member FOREIGN KEY(member_id) REFERENCES members(member_id)
);

select * from members
select * from committees
drop table committees

INSERT INTO members (member_name,member_level, member_contribution) VALUES ('Jack',1,1000);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Liam',1,900);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Cooper',2,1544);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Noah',3,5877);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Oliver',5,6588);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('William',4,1155);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Olivia',2,2277);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Mia',3,3355);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Amelia',5,7788);
INSERT INTO members (member_name,member_level,member_contribution) VALUES ('Lily',1,9554);



INSERT INTO committees (com_name,member_id) VALUES ('Events Committee',1);
INSERT INTO committees (com_name,member_id) VALUES ('Publicity Committee',10);
INSERT INTO committees (com_name,member_id) VALUES ('Finance Committee',3);
INSERT INTO committees (com_name,member_id) VALUES ('Recreation Committee',5);
INSERT INTO committees (com_name,member_id) VALUES ('Sports Commitee',NULL);


SELECT * 
	FROM members, committees;


SELECT * 
FROM members, committees 
WHERE members.member_id = committees.member_id;


SELECT *
FROM members Natural JOIN committees USING (member_id) LIMIT 3;


SELECT * FROM members INNER JOIN committees USING (member_id) WHERE com_name = 'Events Committee';

SELECT * FROM members, committees 
WHERE members.member_id = committees.member_id 
	AND 
	com_name = 'Events Committee';



SELECT *
FROM members Natural JOIN committees;

SELECT AVG(member_contribution)
FROM members;

=================
/*Advanced*/

/*1*/
SELECT 
 c.com_name, m.member_name
FROM
 committees c
INNER JOIN members m ON c.member_id = m.member_id
WHERE m.member_contribution IS NOT NULL;


/*2*/

SELECT 
	m.member_name, c.com_name
FROM
 members m
LEFT JOIN committees  c ON m.member_id = c.member_id;



SELECT 
	m.member_name, c.com_name
FROM
 members m
LEFT JOIN committees  c ON m.member_id = c.member_id
Where c.committee_id is not null;


SELECT 
    m.member_name,
    c.com_name
FROM 
    members m,
    committees c
WHERE 
    m.member_id = c.member_id
    AND c.committee_id IS NOT NULL;
	
	
	
	/*3*/


SELECT 
	 c.com_name, m.member_name
FROM
 members m
RIGHT JOIN committees  c ON m.member_id = c.member_id;





SELECT members.member_name, committees.com_name
FROM members
CROSS JOIN committees;

SELECT 
    m.member_name,
    c.com_name
FROM 
    members m,
    committees c

