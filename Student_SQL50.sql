show databases;
use venture;
drop table Student;
drop table Course;
drop table Teacher;
drop table Score;
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

SELECT 
    student.*, a.s_id, a.s_score AS s1, b.s_score AS s2
FROM
    (SELECT 
        *
    FROM
        Score
    WHERE
        c_id = '01') a
        LEFT JOIN
    (SELECT 
        *
    FROM
        Score
    WHERE
        c_id = '02') b ON a.s_id = b.s_id
        LEFT JOIN
    student ON student.s_id = a.s_id
WHERE
    a.s_score > b.s_score;


SELECT 
    st.*, sc.s_score AS '语文', sc2.s_score '数学'
FROM
    student st
        LEFT JOIN
    score sc ON sc.s_id = st.s_id AND sc.c_id = '01'
        LEFT JOIN
    score sc2 ON sc2.s_id = st.s_id AND sc2.c_id = '02'
WHERE
    sc.s_score > sc2.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数

SELECT 
    st.*, s1.s_score score1, s2.s_score score2
FROM
    student st
        LEFT JOIN
    score s1 ON s1.s_id = st.s_id AND s1.c_id = '01'
        LEFT JOIN
    score s2 ON s2.s_id = st.s_id AND s2.c_id = '02'
WHERE
    s1.s_score < s2.s_score;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

SELECT 
    a.s_id, st.s_name, a.avg_sc
FROM
    (SELECT 
        sc.s_id, AVG(sc.s_score) avg_sc
    FROM
        Score sc
    GROUP BY s_id
    HAVING avg_sc >= 60) a
        LEFT JOIN
    student st ON st.s_id = a.s_id;

SELECT 
    st.s_id, st.s_name, ROUND(AVG(sc.s_score), 2) '平均成绩'
FROM
    student st
        LEFT JOIN
    score sc ON sc.s_id = st.s_id
GROUP BY st.s_id
HAVING AVG(sc.s_score) >= 60;

-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
SELECT 
    st.s_id,
    st.s_name,
    (CASE
        WHEN ROUND(AVG(sc.s_score), 2) IS NULL THEN 0
        ELSE ROUND(AVG(sc.s_score), 2)
    END) '平均成绩'
FROM
    student st
        LEFT JOIN
    score sc ON sc.s_id = st.s_id
GROUP BY st.s_id
HAVING AVG(sc.s_score) < 60
    OR AVG(sc.s_score) IS NULL;


-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
SELECT 
    st.s_id,
    st.s_name,
    COUNT(sc.c_id) '选课总数',
    SUM(CASE
        WHEN sc.s_score IS NULL THEN 0
        ELSE sc.s_score
    END) '总成绩'
FROM
    student st
        LEFT JOIN
    score sc ON st.s_id = sc.s_id
GROUP BY st.s_id;

-- 6、查询"李"姓老师的数量 
SELECT 
    COUNT(t.t_name)
FROM
    teacher t
WHERE
    t.t_name LIKE '李%';
-- 7、查询学过"张三"老师授课的同学的信息 
SELECT 
    st.*
FROM
    teacher t
        LEFT JOIN
    course c ON t.t_id = c.t_id
        LEFT JOIN
    score sc ON c.c_id = sc.c_id
        LEFT JOIN
    student st ON sc.s_id = st.s_id
WHERE
    t.t_name = '张三';

-- 8、查询没学过"张三"老师授课的同学的信息
SELECT 
    b.*
FROM
    student b
WHERE
    b.s_name NOT IN (SELECT 
            st.s_name
        FROM
            teacher t
                LEFT JOIN
            course c ON t.t_id = c.t_id
                LEFT JOIN
            score sc ON c.c_id = sc.c_id
                LEFT JOIN
            student st ON sc.s_id = st.s_id
        WHERE
            t.t_name = '张三');

-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
SELECT 
    st.*
FROM
    student st
        INNER JOIN
    score s1 ON s1.s_id = st.s_id
        INNER JOIN
    score s2 ON s2.s_id = st.s_id
WHERE
    s1.c_id = '01' AND s2.c_id = '02';

SELECT 
    a.*
FROM
    student a,
    score b,
    score c
WHERE
    a.s_id = b.s_id AND a.s_id = c.s_id
        AND b.c_id = '01'
        AND c.c_id = '02';
    
-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
SELECT 
    st.*
FROM
    student st
        INNER JOIN
    score sc ON sc.s_id = st.s_id
        INNER JOIN
    course c ON c.c_id = sc.c_id AND c.c_id = '01'
WHERE
    st.s_id NOT IN (SELECT 
            st2.s_id
        FROM
            student st2
                INNER JOIN
            score sc2 ON sc2.s_id = st2.s_id
                INNER JOIN
            course c2 ON c2.c_id = sc2.c_id AND c2.c_id = '02');

-- 11、查询没有学全所有课程的同学的信息
-- 少了全都没选的
SELECT 
    st.*
FROM
    score sc
        LEFT JOIN
    student st ON sc.s_id = st.s_id
GROUP BY sc.s_id
HAVING SUM(CASE
    WHEN sc.s_id IS NULL THEN 0
    ELSE 1
END) < 3;

SELECT 
    *
FROM
    student
WHERE
    s_id NOT IN (SELECT 
            st.s_id
        FROM
            student st
                INNER JOIN
            score sc ON sc.s_id = st.s_id AND sc.c_id = '01'
        WHERE
            st.s_id IN (SELECT 
                    st1.s_id
                FROM
                    student st1
                        INNER JOIN
                    score sc2 ON sc2.s_id = st1.s_id AND sc2.c_id = '02')
                AND st.s_id IN (SELECT 
                    st2.s_id
                FROM
                    student st2
                        INNER JOIN
                    score sc2 ON sc2.s_id = st2.s_id AND sc2.c_id = '03'));


-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息
SELECT DISTINCT
    st.*
FROM
    score sc
        INNER JOIN
    student st ON st.s_id = sc.s_id
WHERE
    sc.c_id IN (SELECT 
            c_id
        FROM
            score
        WHERE
            s_id = '01');


-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
SELECT 
    st.*
FROM
    student st
        LEFT JOIN
    score sc ON st.s_id = sc.s_id
GROUP BY st.s_id
HAVING GROUP_CONCAT(sc.c_id
    ORDER BY sc.c_id) = (SELECT 
        GROUP_CONCAT(sc2.c_id
                ORDER BY sc2.c_id)
    FROM
        score sc2
    WHERE
        sc2.s_id = '01');

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
SELECT 
    st.s_name
FROM
    student st
WHERE
    st.s_id NOT IN (SELECT 
            sc.s_id
        FROM
            score sc
                INNER JOIN
            course c ON sc.c_id = c.c_id
                INNER JOIN
            teacher t ON c.t_id = t.t_id
        WHERE
            t.t_name = '张三');

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
SELECT 
    st.*,
    AVG(sc.s_score) avg_sc,
    SUM(CASE
        WHEN sc.s_score < 60 THEN 1
        ELSE 0
    END) failed
FROM
    score sc
        INNER JOIN
    student st ON st.s_id = sc.s_id
GROUP BY sc.s_id
HAVING failed >= 2;

-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
SELECT 
    st.*, sc.s_score
FROM
    score sc
        INNER JOIN
    student st ON sc.s_id = st.s_id
WHERE
    sc.s_score < 60 AND sc.c_id = '01'
ORDER BY sc.s_score DESC;

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
SELECT 
    sc1.s_id,
    sc1.s_score s1,
    sc2.s_score s2,
    sc3.s_score s3,
    AVG(sc4.s_score) avg_sc
FROM
    score sc1
        LEFT JOIN
    score sc2 ON sc1.s_id = sc2.s_id
        LEFT JOIN
    score sc3 ON sc1.s_id = sc3.s_id
        LEFT JOIN
    score sc4 ON sc1.s_id = sc4.s_id
WHERE
    sc1.c_id = '01' AND sc2.c_id = '02'
        AND sc3.c_id = '03'
GROUP BY sc1.s_id
ORDER BY avg_sc DESC;

SELECT 
    st.*,
    s1.score1,
    s2.score2,
    s3.score3,
    AVG(s4.score4) avg_score
FROM
    student st
        LEFT JOIN
    (SELECT 
        sc1.s_id, sc1.s_score score1
    FROM
        score sc1
    WHERE
        sc1.c_id = '01') s1 ON s1.s_id = st.s_id
        LEFT JOIN
    (SELECT 
        sc2.s_id, sc2.s_score score2
    FROM
        score sc2
    WHERE
        sc2.c_id = '02') s2 ON s2.s_id = st.s_id
        LEFT JOIN
    (SELECT 
        sc3.s_id, sc3.s_score score3
    FROM
        score sc3
    WHERE
        sc3.c_id = '03') s3 ON s3.s_id = st.s_id
        LEFT JOIN
    (SELECT 
        sc4.s_id, sc4.s_score score4
    FROM
        score sc4) s4 ON s4.s_id = st.s_id
GROUP BY st.s_id
ORDER BY avg_score DESC;

-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
SELECT 
    sc.c_id,
    c.c_name,
    MAX(sc.s_score) '最高分',
    MIN(sc.s_score) '最低分',
    AVG(sc.s_score) '平均分',
    AVG(CASE
        WHEN sc.s_score >= 60 THEN 1
        ELSE 0
    END) '及格率'
FROM
    score sc
        INNER JOIN
    course c ON sc.c_id = c.c_id
GROUP BY sc.c_id;

-- 19、按各科成绩进行排序，并显示排名(实现不完全)

SELECT 
    *
FROM
    score;


-- 20、查询学生的总成绩并进行排名
SELECT 
    st.*,
    SUM(CASE
        WHEN sc.s_score IS NULL THEN 0
        ELSE sc.s_score
    END) total
FROM
    student st
        LEFT JOIN
    score sc ON st.s_id = sc.s_id
GROUP BY st.s_id
ORDER BY total DESC;

SELECT 
    st.*, SUM(COALESCE(sc.s_score, 0)) total
FROM
    student st
        LEFT JOIN
    score sc ON st.s_id = sc.s_id
GROUP BY st.s_id
ORDER BY total DESC;

-- 21、查询不同老师所教不同课程平均分从高到低显示 
SELECT 
    t.*, c.c_id, AVG(sc.s_score) mean
FROM
    teacher t
        LEFT JOIN
    course c ON t.t_id = c.t_id
        LEFT JOIN
    score sc ON sc.c_id = c.c_id
GROUP BY t.t_id
ORDER BY mean DESC;


