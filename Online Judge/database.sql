drop table Contestant;
drop table Username;
drop table NumberOfSolve;
drop table StudentOJ;


create table StudentOJ(
  roll Number(7) NOT NULL,
  name varchar2(10) NOT NULL
);

create table Username(
roll1 number(7) NOT NULL,
Username_UVA varchar2(10) NOT NULL,
Username_CODEFORCES varchar2(10) NOT NULL,
Username_LightOJ varchar2(10) NOT NULL,
Username_SPOJ varchar2(10) NOT NULL
);


create table NumberOfSolve(
roll2 number(7),
UVAsolve number(7),
CODEFORCESsolve number(7),
LightOJsolve number(7),
SPOJsolve number(7)
);


create table Contestant(
contest_id number(7),
name varchar2(10),
totalsolve number(7),
position varchar2(20)
);


-- using alter statement
alter table StudentOJ add contest_id number(7);
alter table StudentOJ add primary key(roll);
alter table Contestant add primary key(contest_id);
alter table Username add foreign key (roll1) references StudentOJ (roll) ON DELETE CASCADE;
alter table NumberOfSolve add foreign key (roll2) references StudentOJ (roll) ON DELETE CASCADE;


-- describing table
describe studentOJ;
describe Username;
describe NumberOfSolve;
describe Contestant;


--Using Trigger

CREATE TRIGGER TR_POS 
BEFORE UPDATE OR INSERT ON Contestant 
FOR EACH ROW 

BEGIN
IF :NEW.totalsolve>999 THEN
    :NEW.position:='GrandMaster';

ELSIF :NEW.totalsolve>499 THEN
    :NEW.position:='Master';

ELSIF :NEW.totalsolve>199 AND :NEW.totalsolve<499  THEN
    :NEW.position:='Special';

ELSIF :NEW.totalsolve>49 AND :NEW.totalsolve<199  THEN
    :NEW.position:='Pupil';

ELSIF :NEW.totalsolve<49  THEN
    :NEW.position:='NEW';

END IF;
END TR_POS;
/


-- inserting value
insert into studentOJ values(1207003,'Tanim',10002);
insert into studentOJ values(1207015,'Tomal',10004);
insert into studentOJ values(1207021,'Musa',10006);
insert into studentOJ values(1207028,'Tanmoy',10005);
insert into studentOJ values(1207029,'Kakon',10003);

insert into Username values(1207003,'U_Tanim03','C_Tanim03','L_Tanim03','S_Tanim03');
insert into Username values(1207015,'U_Tomal15','C_Tomal15','L_Tomal15','S_Tomal15');
insert into Username values(1207021,'U_Musa21','C_Musa21','L_Musa21','S_Musa21');
insert into Username values(1207028,'U_Tanmoy28','C_Tanmoy28','L_Tanmoy28','S_Tanmoy28');
insert into Username values(1207029,'U_Kakon29','C_Kakon29','L_Kakon29','S_Kakon29');


insert into NumberOfSolve values(1207003,100,200,300,400);
insert into NumberOfSolve values(1207015,100,200,300,400);
insert into NumberOfSolve values(1207021,400,200,300,400);
insert into NumberOfSolve values(1207028,100,200,300,400);
insert into NumberOfSolve values(1207029,10,200,300,400);


insert into Contestant values(10001,'Aziz',300,null);
insert into Contestant values(10002,'Tanim',1000,null);
insert into Contestant values(10005,'Tanmoy',1000,null);
insert into Contestant values(10008,'Papon',200,null);
insert into Contestant values(10009,'Abir',100,null);



-- Data Table using select statement
select * from StudentOJ;
select * from Username;
select * from NumberOfSolve;
select * from Contestant;
select roll2 from NumberOfSolve where  SPOJsolve>100;
select roll2, LightOJsolve FROM NumberOfSolve WHERE CODEFORCESsolve between 100 AND 300;
select roll2, CODEFORCESsolve FROM NumberOfSolve WHERE LightOJsolve IN(100,300);


-- Update and Delete statement 
update NumberOfSolve set LightOJsolve = 250 where roll2 = 1207003;
delete from StudentOJ where roll=1207015;


-- Ording by column value
select contest_id,name,totalsolve,position from Contestant Order by contest_id;


-- Using Aggregate function 
select max(UVAsolve) from NumberOfSolve;
select min(LightOJsolve) from NumberOfSolve;
select sum(CODEFORCESsolve) from NumberOfSolve;
select avg(SPOJsolve) from NumberOfSolve;


-- Using Subquery
SELECT u.Username_CODEFORCES, u.Username_LightOJ, u.Username_UVA, u.Username_SPOJ
	FROM Username u
		WHERE u.roll1 IN (SELECT n.roll2
					  FROM NumberOfSolve n
					 WHERE u.roll1 = n.roll2);


SELECT Username_CODEFORCES,Username_UVA from Username WHERE roll1=1207028 UNION
SELECT u.Username_CODEFORCES, u.Username_UVA
	FROM Username u
		WHERE u.roll1 IN (SELECT n.roll2
					  FROM NumberOfSolve n
					 WHERE u.roll1 = n.roll2);


SELECT Username_SPOJ,Username_LightOJ from Username where roll1=1207021 INTERSECT 
SELECT u.Username_SPOJ, u.Username_LightOJ
	FROM Username u
		WHERE u.roll1 IN (SELECT n.roll2
					  FROM NumberOfSolve n
					 WHERE u.roll1 = n.roll2);


SELECT u.Username_SPOJ, u.Username_LightOJ
	FROM Username u
		WHERE u.roll1 IN (SELECT n.roll2
					  FROM NumberOfSolve n
					 WHERE u.roll1 = n.roll2) Minus
SELECT Username_SPOJ,Username_LightOJ from Username where roll1=1207021 ;


SELECT Username_CODEFORCES,Username_UVA from Username WHERE roll1=1207028 
UNION
( 
	SELECT u.Username_CODEFORCES, u.Username_UVA
	FROM Username u
		WHERE u.roll1 IN (SELECT n.roll2
					  FROM NumberOfSolve n
					 WHERE u.roll1 = n.roll2)  INTERSECT
	SELECT Username_CODEFORCES,Username_UVA from Username where roll1=1207021 
);



-- Join Operation
SELECT s.roll,c.name from StudentOJ s inner join Contestant c on s.contest_id=c.contest_id;
SELECT s.roll,c.name from studentOJ s left  outer join Contestant c on s.contest_id=c.contest_id;
SELECT s.roll,c.name from studentOJ s right outer join Contestant c on s.contest_id=c.contest_id;
SELECT s.roll,c.name from studentOJ s full outer join Contestant c on s.contest_id=c.contest_id;


-- PL-SQL condition
set serveroutput on
   declare
      better varchar2(20);
      C_total number(7);
      L_total number(7);
   begin
      select sum(CODEFORCESsolve) into C_total from NumberOfSolve;
      select sum(LightOJsolve) into L_total from NumberOfSolve;
      IF C_total > L_total then
      		better:='CodeForces';
      ELSE
      		better:='LightOJ';
      END IF;

      DBMS_OUTPUT.PUT_LINE('Better Oj between CodeForces and LightOJ is : ' || better );
  end;
/


-- PL-SQL loop
  declare
     CURSOR S is select roll,name,contest_id from StudentOJ;
     myroll StudentOJ.roll%type;
     myname StudentOJ.name%type;
     myid studentOJ.contest_id%type;
     
  begin
     OPEN S;
     LOOP
       FETCH S into myroll,myname,myid;
       exit WHEN S%notfound;
       DBMS_OUTPUT.PUT_LINE(myroll || ' ' || myname || ' ' || myid);
     END LOOP;
     CLOSE S;
  end;
  /



-- PL-SQL Procedure Using
set serveroutput on;
   CREATE OR REPLACE PROCEDURE MINUVA is
      myroll NumberOfSolve.roll2%type;
      uva NumberOfSolve.UVAsolve%type;
   BEGIN
   	  select min(UVAsolve) into uva from NumberOfSolve;
   	  --uva:=200;
      select roll2 into  myroll from NumberOfSolve where  uva=UVAsolve;
      
      DBMS_OUTPUT.PUT_LINE('Minimum UVA Solver Roll : ' || myroll); 
  END;
/
SHOW ERRORS;

BEGIN
   MINUVA;
END;
/



-- PL-SQL Function Using

   CREATE OR REPLACE Function MAXUVA return number is
      myroll NumberOfSolve.roll2%type;
      uva NumberOfSolve.UVAsolve%type;
   BEGIN
   	  select max(UVAsolve) into uva from NumberOfSolve;
   	  --uva:=200;
      select roll2 into  myroll from NumberOfSolve where  uva=UVAsolve;
      return myroll;
       
  end;
/

SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.PUT_LINE('Maximum UVA Solver Roll : ' || MAXUVA);
END;
/


-- Using Rollback
  
select * from StudentOJ;
delete from StudentOJ;
rollback;
select * from StudentOJ;
insert into StudentOJ values (1207001,'Tanim',10001);
savepoint  cont6;
insert into StudentOJ values (1207024,'Abir',10009);
savepoint  cont7;
rollback to cont6;
select * from StudentOJ;

commit;