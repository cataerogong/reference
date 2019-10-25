# Oracle自动添加数据文件

版权声明：本文为CSDN博主「帅大狗」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。

原文链接：https://blog.csdn.net/u011478909/article/details/50554351

--------

一旦数据块大小为8k的数据文件达到32g将无法再拓展，我们就需要手动添加数据文件，很麻烦。所以，下面介绍自动为表空间添加数据文件的存储过程，并将其加入到job中定时执行。

* 存储过程：

```
create or replace procedure auto_add_datafile is
ALL_file_name Varchar(500);
file_name Varchar(500);
tablespace_all varchar(500);
Vs_Sql Varchar2(500);
cursor c_tablespace is 
SELECT total.tablespace_name, Round(total.MB, 2) AS Total_MB,Round(total.MB-free.MB, 2) AS Used_MB, Round((1-free.MB/total.MB)*100, 2) AS Used_Pct
FROM (SELECT tablespace_name, Sum(bytes)/1024/1024 AS MB FROM dba_free_space GROUP BY tablespace_name) free, 
     (SELECT tablespace_name, Sum(bytes)/1024/1024 AS MB FROM dba_data_files GROUP BY tablespace_name) total
WHERE free.tablespace_name = total.tablespace_name
      and free.tablespace_name <> 'SYSTEM' AND free.tablespace_name <> 'SYSAUX' AND free.tablespace_name <> 'USERS' AND free.tablespace_name NOT LIKE 'UNDOTBS%';
Begin
  for tablespace_all in c_tablespace loop
        If tablespace_all.USED_PCT >= 90 Then
            ALL_file_name := '你自己的数据文件路径' || tablespace_all.tablespace_name;
            ALL_file_name := ALL_file_name || '_' || to_char(sysdate,'yyyymmddhh24') || '.dbf';
            Vs_Sql := 'alter tablespace ' || tablespace_all.tablespace_name || ' add datafile ''' || ALL_file_name || ''' size 10g autoextend on next 1g';
            --dbms_output.put_line(Vs_Sql);
            Execute Immediate Vs_Sql;
       End If;
  end loop;
exception
  when others then
    dbms_output.put_line(sqlerrm);
End auto_add_datafile;
```

* 创建job:

```
SQL> variable jobid number;
SQL> exec dbms_job.submit(:jobid, 'auto_add_datafile;', sysdate, 'TRUNC(sysdate)+1+1/24');
--每天凌晨1点执行。
SQL> exec dbms_job.run(:jobid);
```

* 关于interval参数的详解：

    1. 每分钟执行

        Interval => TRUNC(sysdate,'mi')+1/(24*60) 或 Interval => sysdate+1/1440

    2. 每天定时执行

        例如：每天的凌晨1点执行

        Interval => TRUNC(sysdate)+1+1/24

    3. 每周定时执行

        例如：每周一凌晨1点执行

        Interval => TRUNC(NEXT_DAY(sysdate,'星期一'))+1/24

    4. 每月定时执行

        例如：每月1日凌晨1点执行

        Interval => TRUNC(LAST_DAY(SYSDATE))+1+1/24

    5. 每季度定时执行

        例如每季度的第一天凌晨1点执行

        Interval => TRUNC(ADD_MONTHS(SYSDATE,3),'Q')+1/24

    6. 每半年定时执行

        例如：每年7月1日和1月1日凌晨1点

        Interval => ADD_MONTHS(TRUNC(sysdate,'yyyy'),6)+1/24

    7. 每年定时执行

        例如：每年1月1日凌晨1点执行

        Interval => ADD_MONTHS(TRUNC(sysdate,'yyyy'),12)+1/24
