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

-- 11、查询没有学全所有课程的同学的信息
-- 少了全都没选的
select st.* from score sc
left join student st
on sc.s_id=st.s_id
group by sc.s_id
having sum(case when sc.s_id is null then 0 else 1 end)<3;

select * from student where s_id not in (
select st.s_id from student st 
inner join score sc on sc.s_id = st.s_id and sc.c_id="01"
where st.s_id  in (
select st1.s_id from student st1 
inner join score sc2 on sc2.s_id = st1.s_id and sc2.c_id="02"
) and st.s_id in (
select st2.s_id from student st2 
inner join score sc2 on sc2.s_id = st2.s_id and sc2.c_id="03"
));


-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select distinct st.* from score sc
inner join student st
on st.s_id=sc.s_id
where sc.c_id in(
select c_id from score
where s_id='01');


-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select st.* from student st
left join score sc on st.s_id=sc.s_id
group by st.s_id
having group_concat(sc.c_id order by sc.c_id) = (
select  group_concat(sc2.c_id order by sc2.c_id) from score sc2
where sc2.s_id ='01');

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
select st.s_name from student st where st.s_id not in ( 
select sc.s_id from score sc
inner join course c on sc.c_id=c.c_id
inner join teacher t on c.t_id=t.t_id
where t.t_name='张三');

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select st.*,
	   avg(sc.s_score) avg_sc,
	   sum(case when sc.s_score<60 then 1 else 0 end) failed from score sc
inner join student st on st.s_id=sc.s_id
group by sc.s_id
having failed>=2;

-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
select st.*,sc.s_score from score sc
inner join student st on sc.s_id=st.s_id
where sc.s_score<60 and sc.c_id='01'
order by sc.s_score desc;

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select sc1.s_id,sc1.s_score s1,sc2.s_score s2,sc3.s_score s3,avg(sc4.s_score) avg_sc from score sc1 
left join score sc2 on sc1.s_id=sc2.s_id
left join score sc3 on sc1.s_id=sc3.s_id
left join score sc4 on sc1.s_id=sc4.s_id
where sc1.c_id='01' and sc2.c_id='02' and sc3.c_id='03'
group by sc1.s_id
order by avg_sc desc;

select st.*,s1.score1,s2.score2,s3.score3,avg(s4.score4) avg_score from student st 
left join( select sc1.s_id,sc1.s_score score1 from score sc1
where sc1.c_id='01') s1 on s1.s_id=st.s_id 
left join( select sc2.s_id,sc2.s_score score2 from score sc2
where sc2.c_id='02') s2 on s2.s_id=st.s_id 
left join( select sc3.s_id,sc3.s_score score3 from score sc3
where sc3.c_id='03') s3 on s3.s_id=st.s_id 
left join( select sc4.s_id,sc4.s_score score4 from score sc4) 
s4 on s4.s_id=st.s_id 
group by st.s_id
order by avg_score desc;

-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
select sc.c_id,c.c_name,max(sc.s_score) '最高分',
	   min(sc.s_score) '最低分',
       avg(sc.s_score) '平均分',
       avg(case when sc.s_score>=60 then 1 else 0 end) '及格率'from score sc
inner join course c
on sc.c_id = c.c_id
group by sc.c_id;

-- 19、按各科成绩进行排序，并显示排名(实现不完全)

select * from score;


-- 20、查询学生的总成绩并进行排名
select st.*,sum(case when sc.s_score is null then 0 else sc.s_score end) total from student st
left join score sc on st.s_id = sc.s_id
group by st.s_id
order by total desc;

select st.*,sum(coalesce(sc.s_score,0)) total from student st
left join score sc on st.s_id = sc.s_id
group by st.s_id
order by total desc;

-- 21、查询不同老师所教不同课程平均分从高到低显示 
select t.t_id,c.c_id,avg(sc.s_score) from teacher t
left join course c on c.t_id = t.t_id
left join score sc on sc.c_id = c.c_id
group by t.t_id;

SELECT 
    t.t_id, t.t_name, c.c_name, AVG(sc.s_score)
FROM
    teacher t
        LEFT JOIN
    course c ON c.t_id = t.t_id
        LEFT JOIN
    score sc ON sc.c_id = c.c_id
GROUP BY t.t_id
ORDER BY AVG(sc.s_score) DESC;


select t.t_id,c.c_id,sc.s_score from teacher t
left join course c on c.t_id = t.t_id
left join score sc on sc.c_id = c.c_id
group by t.t_id and c.c_id;


select * from course;
