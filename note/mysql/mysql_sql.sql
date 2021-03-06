mysql数据类型
（1字节8位）
数据类型        字节       范围（有符号）               范围（无符号）          用途 
TINYINT        1字节        (-128,127)                     (0,255)            小整数值 
SMALLINT       2字节    	(-32 768,32 767)               (0,65 535)         大整数值 
MEDIUMINT      3字节    	(-8 388 608,8 388 607)         (0,16 777 215)     大整数值 
INT			   4字节   		(-2 147 483 648,2 147 483 647) (0,4 294 967 295)  大整数值 
BIGINT         8字节   		(-9 233 372 036 854 775 808,9 223 372 036 854 775 807) (0,18 446 744 073 709 551 615) 极大整数值 

FLOAT          4字节   		(-3.402 823 466 E+38,1.175 494 351 E-38),0,(1.175 494 351 E-38,3.402 823 466 351 E+38) 0,(1.175 494 351 E-38,3.402 823 466 E+38) 单精度浮点数值 
DOUBLE         8字节 		(1.797 693 134 862 315 7 E+308,2.225 073 858 507 201 4 E-308),0,(2.225 073 858 507 201 4 E-308,1.797 693 134 862 315 7 E+308) 0,(2.225 073 858 507 201 4 E-308,1.797 693 134 862 315 7 E+308) 双精度浮点数值

FLOAT(p)	   4 bytes if 0 <= p <= 24, 8 bytes if 25 <= p <= 53

DECIMAL[(M),(N)]  默认M为10，最大为65，N最大值为30 NUMERIC类型与之相同，整数与分数分开存储，4字节存储9位（10进制转换成二进制的占用）
DECIMAL(5,2)      -999.99 to 999.99

CHAR[(M)]         255字符          		定长字符串 
VARCHAR(M)        65535字节          	变长字符串   M代表字符数
TINYBLOB          255字节        		二进制字符串 
TINYTEXT     	  255字节        		文本字符串 
BLOB[(M)]         65535字节      		二进制字符串
TEXT[(M)]         65535字节      		长文字符串 
MEDIUMBLOB   	  16 777 215字节 		二进制字符串
MEDIUMTEXT   	  16 777 215字节 		文本字符串
LOGNGBLOB    	  4 294 967 295字节 	二进制字符串
LONGTEXT     	  4 294 967 295字节 	文本字符串

VARBINARY(M) 	  65535字节				变长二进制字符串
BINARY(M)    	  255字节				定长二进制字符串

DATE       4  1000-01-01/9999-12-31 					YYYY-MM-DD     日期值 
TIME       3  '-838:59:59'/'838:59:59'  				HH:MM:SS    时间值或持续时间 
YEAR       1  1901/2155                 				YYYY         年份值 
DATETIME   8  1000-01-01 00:00:00/9999-12-31 23:59:59 	YYYY-MM-DD HH:MM:SS 混合日期和时间值 
TIMESTAMP  4  1970-01-01 00:00:00/2037 年某时 			YYYYMMDD HHMMSS 混合日期和时间值,时间戳


BIT[(M)]   M=(1,64)            二进制格式 M为多少位
JSON                           json格式 5.7.8以后支持

SERIAL           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE 的别称


https://dev.mysql.com/doc/refman/8.0/en/innodb-limits.html

LONGBLOB and LONGTEXT columns must be less than 4GB, 
and the total row size, including BLOB and TEXT columns, must be less than 4GB.

If a row is less than half a page long, all of it is stored locally within the page. （默认页16k）
If it exceeds half a page, variable-length columns are chosen for external off-page storage until the row fits within half a page.

不包括BLOB等的单个记录最大长度是65535字节。    

InnoDB has a limit of 1017 columns per table, 64 secondary indexes, 16 columns for multicolumn indexes.


插入格式 b'101'  
insert into tb_name(column_name) values(b'101');
           
查看格式 
	hex(column_name)   转成十六进制
	select conv(hex(column_name),16,2) from tb_name   以二进制格式查询
    select bin(column_name) from tb_name;

select 0x21;
select unhex('21');

select CONV('10000', 2, 16);   #任意进制之间转换 如二进制转16进制
select b'10'<<2;   #左移
select b'10'>>2;   #右移
select ~b'100';    #取反

SELECT col->"$.json_filed_name" FROM t_name;    #查询json的制订字段
UPDATE t_name SET col = json_set(col,'$.json_filed_name','xxyy1') ...     #增加/修改json中字段
json_remove(col,'$.json_filed_name')                                      #删除json中字段
JSON_EXTRACT(col,'$.json_filed_name')                                     #提取字段

ENUM('value1','value2',...)     A string object that can have only one value
SET('value1','value2',...)      A string object that can have zero or more values

--一行记录所有字符相加不大于65536,最大可存varchar(65532)

create table test20201124(
id int auto_increment,          --自增
opt_date  datetime,
primary key(id)
);

delete a from xx a, yy b  where...
DELETE FROM a USING xx  a , yy b WHERE ...; 

delete a,b from xx a, yy b  where ...
DELETE FROM a,b USING xx  a , yy b WHERE ...; 

select * from mysql.proc        ---查看存储过程的信息
DROP PROCEDURE procedure_name   ---删除存储过程

---存储过程
---delimiter  设置结束符号

DELIMITER //  
CREATE PROCEDURE demo_in_parameter(IN p_in int)  
BEGIN   
SELECT p_in;   
SET p_in=2;   
SELECT p_in;   
END;   
//  
DELIMITER ;

DELIMITER //   
CREATE PROCEDURE proc1(OUT s int)  
BEGIN 
SELECT COUNT(*) INTO s FROM wdg_test;  
END 
//  
DELIMITER ;    


DELIMITER //   
CREATE PROCEDURE demo_inout_parameter(INOUT p_inout int)   
BEGIN 
SELECT p_inout;  
SET p_inout=2;  
SELECT p_inout;   
END;  
//   
DELIMITER ; 
 
执行存储过程
---执行结果:
SET @p_inout=1;  
CALL demo_inout_parameter(@p_inout) 


DELIMITER //  
CREATE PROCEDURE proc3()  
begin 
declare x1 varchar(5) default 'outer';     ----声明变量
begin 
declare x1 varchar(5) default 'inner';  
select x1;  
end;  
select x1;  
end;  
//  
DELIMITER ;

create procedure my_insert(in bg int,in en int)
begin
declare i int;
set i=1;
lp1: loop
insert into test.demo values(i);
set i=i+1;
if i>x then
leave lp1;
end if;
end loop;
end;
DELIMITER ;

DELIMITER // 
create procedure my_insert(in begin_num int,in end_num int)
begin
declare i int;
set i=begin_num;
while i<end_num
do
insert into test.demo values(i);
set i=i+1;
end while;
end;
DELIMITER ;

DELIMITER //
create procedure input_t(in table_n varchar(20))
begin
select table_n;
end;


执行计划
explain select * from test1 where id=1


prepare prod from "insert into example values(?,?)";	---创建预定义语句,可以使用 create table、delete、insert、replace、select、set、update、show
set @a='xxx'
set @b='yyy'
execute prod using @a,@b;								---使用预定义
deallocate prepare prod;								---释放预定义语句

					    
SET @c1 = "XYZ";
set @c2 ="abc";
SET @strsql = concat("select ",@c1," from t where column2=",@c2);           --实现拼接sql，之后再执行
PREPARE stmt FROM @strsql;
EXECUTE stmt;					    
					    
					    				    
create function func_name(arg1 int,arg2 varchar(10)...)
returns varchar(10)
begin
...
end

调用
select func_name(...) from ...




INSERT INTO table_name(column_1,column_2) VALUES(v1,v2);
INSERT INTO table_name(column_1,column_2) VALUES(v01,v02),(v11,v12);    ----only for mysql

---mysql特有
---与insert类似
---根据主键或者唯一索引判断。不存在,则插入；存在,则更新。
replace into table(id, update_time) values(1, now());   


选择表的特定几行
--MySQL
select * from table_name limit 2,5;  --从第3行开始选5行
select * from table_name limit 5 offset 2;  --从第3行开始选5行
select * from table_name limit 3;    --选择前3行


约束
ALTER TABLE table_name ADD CONSTRAINT constraint_name UNIQUE (column1,column2);
撤销约束
ALTER TABLE table_name DROP CONSTRAINT constraint_name;


更改表的字段
ALTER TABLE table_name MODIFY column_name data_type;



UDF (use defined function)
mysql.func

create function func_name return string "mysql_function.so";		---由创建的动态连接库添加mysql的function

####动态连接库创建
####mysql.h在$mysql_home/include/mysql下
####test_add.cpp

#include <mysql.h>
extern "C" long long testadd(UDF_INIT *initid,UDF_ARGS *args,char *is_null,char *error)
{
	int a=*((long long*)args->args[0]);
	int b=*((long long*)args->args[1]);
	return a+b;
}
extern "C" my_bool testadd_init(UDF_INIT *initid,UDF_ARGS *args,char *message)
{
	return 0;
}

###需要预先安装libmysqlclient-dev
##编译
g++ -shared -fPIC -l /usr/include/mysql -o test_add.so test_add.cpp   	###动态连接库的位置要确定
cp test_add.so /usr/lib/mysql/plugin   									####在mysql中使用【SHOW VARIABLES LIKE 'plugin_dir'; 】查看要复制到的位置

nm test_add.so		##可查看动态连接库中的函数

mysql中使用
create function testadd returns integer soname "test_add.so";
select testadd(1,2);


github.com/mysqludf



----空间占用查询
----所有数据的大小：
select concat(round(sum(data_length/1024/1024),2),'MB') as data from information_schema.tables;
----指定数据库的大小：
select concat(round(sum(data_length/1024/1024),2),'MB') as data from information_schema.tables where table_schema='schema_name';
----指定数据库各表的大小：
select TABLE_SCHEMA,TABLE_NAME,concat(round(sum(data_length/1024/1024/1024),2),'G') as data from information_schema.tables where TABLE_SCHEMA='schema_name' group by TABLE_NAME;



注释(comment)
查看

create table table_name(
name varchar comment '名字',
pid int comment '编号'
)


修改
alter table `table_name` modify column `name` varchar(20) comment `you comment`;




delimiter //
create trigger db_info_to_stats
BEFORE delete on db_info
for each row
begin
delete from stats where ip=old.master_private_ip;
end;
//


drop trigger db_info_update_stats;
delimiter //
create trigger db_info_update_stats
after update on db_info
for each row
begin
declare private_ip varchar(40);
declare my_cursor cursor for select manage_private_ip from cloud_info where cloud_id=new.cloud_id;
open my_cursor;
fetch my_cursor into private_ip;
close my_cursor;

replace into stats(
db_type
,project
,channel
,manage_host
,ip
,port
,max_connections
,comment)   
values(
new.db_type           
,new.project           
,new.sub_project       
,private_ip 
,new.master_private_ip 
,new.master_port                
,new.max_connections    
,new.hardware_info   
);
end;
//
delimiter ;


drop trigger db_info_insert_stats;
delimiter //
create trigger db_info_insert_stats
after insert on db_info
for each row
begin
declare private_ip varchar(40);
declare my_cursor cursor for select manage_private_ip from cloud_info where cloud_id=new.cloud_id;
open my_cursor;
fetch my_cursor into private_ip;
close my_cursor;

replace into stats(
db_type
,project
,channel
,manage_host
,ip
,port
,max_connections
,comment)   
values(
new.db_type           
,new.project           
,new.sub_project       
,private_ip 
,new.master_private_ip 
,new.master_port                
,new.max_connections    
,new.hardware_info   
);
end;
//
delimiter ;



自增虚拟列
select (@i:=@i+1) as v_id,tb_name.* from tb_name,(select @i:=0) vt


event
--用于定期执行sql语句
create event event_name ...


set global event_scheduler=on; 

CREATE EVENT myevent
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
UPDATE mytable SET mycol = mycol + 1;


delimiter ;;
CREATE EVENT `myevent_test` 
ON SCHEDULE EVERY 1 minute 
ON COMPLETION PRESERVE ENABLE 
DO 
BEGIN
insert into test20201124(opt_date) values(now());
END
;;
delimiter ;

select db,name,status from mysql.event;
--修改状态
-- update mysql.event set status='DISABLED' where name='myevent_test';   
-- update mysql.event set status='ENABLED' where name='myevent_test';   flush tables mysql.events;  --不能立即生效 需要重启？
alter event myevent_test disable;
alter event myevent_test enable;



delimiter ;;                                                 -- 
CREATE EVENT `myevent_test`                                  -- 
ON SCHEDULE EVERY 1 DAY                                      --
starts '2011-03-21 03:30:00'                                 -- 开始时间 
ON COMPLETION PRESERVE ENABLE                                -- 
DO                                                           -- 
...                                                          -- 
;;                                                           -- 
delimiter ;                                                  -- 


CREATE FUNCTION f1(s CHAR(20))
RETURNS CHAR(50) DETERMINISTIC
RETURN CONCAT('Hello, ',s,'!');




delimiter //
create procedure random_insert_max()
begin
declare i int;
set i=0;
while i<8000000 do
insert into index_test1(a,b,c,d,e) values(round(rand()*10000),round(rand()*10000),round(rand()*1000),round(rand()*10000),round(rand()*10000));
set i=i+1;
end while;
end

//
delimiter ;

--插入多行
CREATE TABLE t (
a INT UNSIGNED NOT NULL AUTO_INCREMENT,
b CHAR(10),
PRIMARY KEY(a)
) ENGINE=INNODB CHARSET=LATIN1 ROW_FORMAT=COMPACT;


DELIMITER //
CREATE PROCEDURE load_t (count INT UNSIGNED)
BEGIN
SET @c=0;
WHILE @c < count DO
INSERT INTO t SELECT NULL,REPEAT(CHAR(97+RAND()*26),10);
SET @c=@c+1;
END WHILE;
END;
//
DELIMITER ;


// 一行拆分成多行
create table c(c1 int,c2 varchar(20));
insert into c values(1,'a,b');
insert into c values(2,'c,d,e');
insert into c values(3,'f,g');


SELECT
    a.c1,
    substring_index(
        substring_index(
            a.c2,
            ',',
            b.help_topic_id + 1
        ),
        ',' ,- 1
    ) AS c3
FROM
    c a
JOIN mysql.help_topic b ON b.help_topic_id < (
    length(a.c2) - length(
        REPLACE (a.c2, ',', '')
    ) + 1
);


--结果集 都是条件谓词的结果 即a.id=b.id  ...
select * from a a1 join b b1 on a.id=b.id  ...
select * from a a1 , b b1 where a.id=b.id  ...            --sql优化器自动优化成join

--结果集 如果不满足条件谓词，b显示空值
select * from a a1 left join b b1 on a.id=b.id  ...

--结果集 如果不满足条件谓词，a显示空值
select * from a a1 right join b b1 on a.id=b.id  ...


--sql优化器会自动选择驱动表（小表驱动大表，因为join的操作是表1逐个值跟表2全部值匹配，聚合成结果集，小表驱动大表可以减少随机读）

inner join: 默认
outer join: left join / right join / full join
笛卡尔积:  不加任何连接条件

--mysql 不支持 full join  需要使用union曲线替代
select ... from a left join b on ...
union
select ... from a right join b on ...;


--重复的结果集只会显示一个
select ... from ...
union
select ... from ...;


--重复的结果集都显示，不进行结果集过滤
select ... from ...
union all
select ... from ...;


--子查询
select .. from a where c in ( select a1.c from a1 ... )
select .. from a where c1,c2 in ( select a1.c1,a1.c2 from a1 ... )         #mysql不支持 


分区表
SELECT * FROM p1 PARTITION (p0[,p1])；     							#从指定分区查询
EXPLAIN PARTITIONS SELECT * FROM p1 WHERE column_name=10；			#查看从分区表的执行信息
ALTER TABLE tr DROP PARTITION p2;	                              	#删除分区，针对RANGE/LIST分区
ALTER TABLE tr ADD PARTITION (PARTITION p_name …);   				#增加分区，针对RANGE/LIST分区
ALTER TABLE members REORGANIZE PARTITION p0,p1,p2,p3 INTO (
    	PARTITION m0 …,
   	PARTITION m1 …);       						#调整RANGE/LIST分区
ALTER TABLE tr COALESCE PARTITION 4;   			#减小HASH/KEY分区
ALTER TABLE tr ADD PARTITION PARTITIONS 6;      #增多HASH/KEY分区



CREATE TABLE tb_name ...
PARTITION BY RANGE  ...


CREATE TABLE employees (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE NOT NULL DEFAULT '1970-01-01',
    separated DATE NOT NULL DEFAULT '9999-12-31',
    job_code INT NOT NULL,
    store_id INT NOT NULL
)
PARTITION BY RANGE (store_id) (
    PARTITION p0 VALUES LESS THAN (6),
    PARTITION p1 VALUES LESS THAN (11),
    PARTITION p2 VALUES LESS THAN (16),
    PARTITION p3 VALUES LESS THAN (21)
);


PARTITION BY RANGE COLUMNS(a,d,c) (
    PARTITION p0 VALUES LESS THAN (5,10,'ggg'),
    PARTITION p1 VALUES LESS THAN (10,20,'mmm'),
    PARTITION p2 VALUES LESS THAN (15,30,'sss'),
    PARTITION p3 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE)
);


PARTITION BY LIST(store_id) (
    PARTITION pNorth VALUES IN (3,5,6,9,17),
    PARTITION pEast VALUES IN (1,2,10,11,19,20),
    PARTITION pWest VALUES IN (4,12,13,14,18),
    PARTITION pCentral VALUES IN (7,8,15,16)
);


PARTITION BY HASH(store_id)
PARTITIONS 4;


PARTITION BY HASH( YEAR(hired) )
PARTITIONS 4;


-- 类似hash 但使用主键 或者NOT NULL唯一键  使用hash函数 PASSWORD()
PARTITION BY KEY()
PARTITIONS 2;


-- 复合分区 分区数 3 * 2 = 6 
PARTITION BY RANGE( YEAR(purchased) )
SUBPARTITION BY HASH( TO_DAYS(purchased) )
SUBPARTITIONS 2 (
    PARTITION p0 VALUES LESS THAN (1990),
    PARTITION p1 VALUES LESS THAN (2000),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);




MRG_MYISAM
--MYISAM的分区表 比较老的版本使用 5.5以上MyISAM以及支持分区表
CREATE TABLE `article_0` ( `id` BIGINT( 20 ) NOT NULL , `subject` VARCHAR( 200 ) NOT NULL , PRIMARY KEY ( `id` ) ) ENGINE = MYISAM ;
CREATE TABLE `article_1` ( `id` BIGINT( 20 ) NOT NULL , `subject` VARCHAR( 200 ) NOT NULL , PRIMARY KEY ( `id` ) ) ENGINE = MYISAM ;

CREATE TABLE `article_merge` ( `id` BIGINT( 20 ) NOT NULL , `subject` VARCHAR( 200 ) NOT NULL , PRIMARY KEY ( `id` ) ) ENGINE=MRG_MyISAM DEFAULT CHARSET=utf8 UNION=(article_0,article_1);

--插入数据只能往后端的表操作
--更新 删除可以在前端表操作

UserId 主键
CreateDate 非唯一键
Uuid 没有索引

select SQL_NO_CACHE count(*) from t_u_userinfo;              0.38 0.34 0.33
select SQL_NO_CACHE count(1) from t_u_userinfo;              0.33 0.35 0.34
select SQL_NO_CACHE count(UserId) from t_u_userinfo;         0.37 0.36 0.38
select SQL_NO_CACHE count(CreateDate) from t_u_userinfo;     0.48 0.49 0.48
select SQL_NO_CACHE count(Uuid) from t_u_userinfo;           9.76 




--多表操作

UPDATE T1
[INNER JOIN | LEFT JOIN] T2 ON T1.C1 = T2. C1
SET T1.C2 = T2.C2, 
    T2.C3 = expr
WHERE ...;


UPDATE T1, T2
SET T1.C2 = T2.C2, 
    T2.C3 = expr
WHERE ...;


delete a
from T1 a
join T2 b on a.PackageId = b.PackageId
where ...;



