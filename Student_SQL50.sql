show databases;
use venture;
CREATE TABLE `Student`(
`s_id` VARCHAR(20),
`s_name` VARCHAR(20) NOT NULL DEFAULT '',
`s_birth` VARCHAR(20) NOT NULL DEFAULT '',
`s_sex` VARCHAR(10) NOT NULL DEFAULT '',
PRIMARY KEY(`s_id`)
);

CREATE TABLE `Course`(
`c_id` VARCHAR(20),
`c_name` VARCHAR(20) NOT NULL DEFAULT '',
`t_id` VARCHAR(20) NOT NULL,
PRIMARY KEY(`c_id`)
);

CREATE TABLE `Teacher`(
`t_id` VARCHAR(20),
`t_name` VARCHAR(20) NOT NULL DEFAULT '',
PRIMARY KEY(`t_id`)
);

CREATE TABLE `Score`(
`s_id` VARCHAR(20),
`c_id` VARCHAR(20),
`s_score` INT(3),
PRIMARY KEY(`s_id`,`c_id`)
);

insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into Student values('08' , '王菊' , '1990-01-20' , '女');

insert into Course values('01' , '语文' , '02');
insert into Course values('02' , '数学' , '01');
insert into Course values('03' , '英语' , '03');


insert into Teacher values('01' , '张三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');


insert into Score values('01' , '01' , 80);
insert into Score values('01' , '02' , 90);
insert into Score values('01' , '03' , 99);
insert into Score values('02' , '01' , 70);
insert into Score values('02' , '02' , 60);
insert into Score values('02' , '03' , 80);
insert into Score values('03' , '01' , 80);
insert into Score values('03' , '02' , 80);
insert into Score values('03' , '03' , 80);
insert into Score values('04' , '01' , 50);
insert into Score values('04' , '02' , 30);
insert into Score values('04' , '03' , 20);
insert into Score values('05' , '01' , 76);
insert into Score values('05' , '02' , 87);
insert into Score values('06' , '01' , 31);
insert into Score values('06' , '03' , 34);
insert into Score values('07' , '02' , 89);
insert into Score values('07' , '03' , 98);

# 查看表内容
select * from Score;
select * from Student;
select * from Teacher;

-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数 

select student.*,a.s_id,a.s_score as s1,b.s_score as s2 from(
select * from Score where c_id='01') a
left join(
select * from Score where c_id='02') b
on a.s_id=b.s_id
left join student
on student.s_id=a.s_id
where a.s_score>b.s_score;


select st.*,sc.s_score as '语文' ,sc2.s_score '数学' 
from student st
left join score sc on sc.s_id=st.s_id and sc.c_id='01' 
left join score sc2 on sc2.s_id=st.s_id and sc2.c_id='02'  
where sc.s_score>sc2.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数

select st.*,s1.s_score score1,s2.s_score score2 from student st
left join score s1 on s1.s_id=st.s_id and s1.c_id='01'
left join score s2 on s2.s_id=st.s_id and s2.c_id='02'
where s1.s_score<s2.s_score;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

select a.s_id,st.s_name,a.avg_sc from(
select sc.s_id,avg(sc.s_score) avg_sc from Score sc
group by s_id
having avg_sc>=60) a
left join student st
on st.s_id=a.s_id;

select st.s_id,st.s_name,ROUND(AVG(sc.s_score),2) "平均成绩" from student st
left join score sc on sc.s_id=st.s_id
group by st.s_id having AVG(sc.s_score)>=60;

-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
        -- (包括有成绩的和无成绩的)
        
select st.s_id,st.s_name,(case when ROUND(AVG(sc.s_score),2) is null then 0 else ROUND(AVG(sc.s_score),2) end ) "平均成绩" from student st
left join score sc on sc.s_id=st.s_id
group by st.s_id having AVG(sc.s_score)<60 or AVG(sc.s_score) is NULL;


-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select st.s_id,st.s_name,count(sc.c_id) "选课总数",sum(case when sc.s_score is null then 0 else sc.s_score end) "总成绩" 
from student st 
left join score sc on st.s_id = sc.s_id 
group by st.s_id;

-- 6、查询"李"姓老师的数量 
select count(t.t_name) from teacher t
where t.t_name like '李%';
-- 7、查询学过"张三"老师授课的同学的信息 
select st.* from teacher t 
left join course c on t.t_id=c.t_id
left join score sc on c.c_id=sc.c_id
left join student st on sc.s_id=st.s_id
where t.t_name = '张三';

-- 8、查询没学过"张三"老师授课的同学的信息
select b.* from student b
where b.s_name not in (
select st.s_name from teacher t 
left join course c on t.t_id=c.t_id
left join score sc on c.c_id=sc.c_id
left join student st on sc.s_id=st.s_id
where t.t_name = '张三');

-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select st.* from student st
inner join score s1 on s1.s_id=st.s_id
inner join score s2 on s2.s_id=st.s_id
where s1.c_id='01' and s2.c_id='02';

select a.* 
from
    student a,
    score b,
    score c
where
    a.s_id = b.s_id
    and a.s_id = c.s_id
    and b.c_id = '01'
    and c.c_id = '02';
    
-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select st.* from student st 
inner join score sc on sc.s_id = st.s_id
inner join course c on c.c_id=sc.c_id and c.c_id="01"
where st.s_id not in (
select st2.s_id from student st2 
inner join score sc2 on sc2.s_id = st2.s_id
inner join course c2 on c2.c_id=sc2.c_id and c2.c_id="02"
);