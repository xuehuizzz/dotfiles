## 常用函数
```mysql
select INET_ATON('192.168.3.100')    -- 将IPv4地址转换为 无符号32位整数
select INET_NTOA(3232236388)      -- 将一个无符号32位整数, 转换回对应的IPv4地址

select name, age from users where name regexp 'a|b|c|d|e';    -- 查询name包含a或b或c或d或e的用户
```
