# [H][SQL][B][深化总结][A][核心要点][A][MySQL]

## 官方文档

* [MySQL](https://www.mysql.com)
* [Manual](https://dev.mysql.com/doc/refman/8.0/en/)

## 相关概念

* DBMS
* SQL
* RDS
* NoSQL
    * Single Process Request
* MySQL
* ACID
    * Atomicity
    * Consistency
    * Isolation
    * Durability
* 3NF
    * 1NF
    * 2NF
    * 3NF
* Engine
    * InnoDB
    * MyISAM
    * Memory
    * Archive
    * CSV

## 核心组成

* DDL(Data Definition Language)
    * DROP
    * CREATE
    * ALTER
    * TRUNCATE
* DML(Data Manipulation Language)
    * INSERT
    * UPDATE
    * DELETE
* DQL(Data Query Language)
    * SELECT
* DCL(Data Control Language)
    * GRANT
    * REVOKE
    * COMMIT
    * ROLLBACK

## 基本操作

##### DB
```SQL
-- @LOGIN
[root@host]# mysql -u root -p
Enter password:******

-- @CREATE
CREATE DATABASE `www.hello.com`;

-- @USE
USE `www.hello.com`;

-- @SHOW
SHOW DATABASES;

-- @DROP
DROP DATABASE `www.hello.com`;
```

##### DDL
```SQL
-- @CREATE
CREATE TABLE `company` (
    `company_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
    `company_name` varchar(100) NOT NULL COMMENT 'Company Name',
    `company_code` varchar(50) NOT NULL COMMENT 'COmpany Code',
    `effective_time` datetime NOT NULL COMMENT 'Effective Time',
    `expired_time` datetime NOT NULL COMMENT 'Expired Time',
    `hidden` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether Hide',
    `disabled` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether Disable',
    `deleted` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether Delete',
    `deleted_at` timestamp NULL DEFAULT NULL COMMENT 'Deleted Time',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Created Time',
    `created_by` int(11) unsigned NOT NULL COMMENT 'Created User ID',
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Updated Time',
    `updated_by` int(11) unsigned NOT NULL COMMENT 'Updated User ID',
    PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- @RENAME
RENAME TABLE `company` TO `company_new`;
ALTER TABLE `company_new` RENAME TO `company`;

-- @COPY
CREATE TABLE `company_bak` LIKE `company`;
INSERT INTO `company_bak` SELECT * FROM `company`;
-- CREATE TABLE `company_bak` AS (SELECT * FROM `company`);

-- @PRIMARY KEY
ALTER TABLE `company` DROP PRIMARY KEY;
ALTER TABLE `company` ADD PRIMARY KEY (`company_id`);

-- @FOREIGN KEY
ALTER TABLE `company` ADD CONSTRAINT fk_id FOREIGN KEY(fk_id) REFERENCES fk(fk_id);
ALTER TABLE `company` DROP FOREIGN KEY fk_id;

-- @INDEX
CREATE INDEX `idx_comany_name` ON `company` (`company_name`) USING BTREE;
ALTER TABLE `company` ADD INDEX `idx_comany_name` (`company_name`) USING BTREE;
ALTER TABLE `company` DROP INDEX `idx_comany_name`;

-- @COLUMN
ALTER TABLE `company` ADD COLUMN `fk_id` varchar(255)  NOT NULL  DEFAULT '0' COMMENT 'FK';
ALTER TABLE `company` CHANGE `fk_id` `fk_id` int(10) unsigned  NOT NULL DEFAULT '0' COMMENT 'FK';
ALTER TABLE `company` MODIFY `fk_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'FK';
ALTER TABLE `company` DROP COLUMN `fk_id`;

-- @DESC
DESC `company`;

-- @TRUNCATE @DROP
TRUNCATE TABLE `company`;
DROP TABLE IF EXISTS `company`;

```

##### DML
```SQL
-- @INSERT
INSERT INTO `company`(
    `company_name`,
    `company_code`,
    `effective_time`,
    `expired_time`,
    `hidden`,
    `disabled`,
    `deleted`,
    `deleted_at`,
    `created_at`,
    `created_by`,
    `updated_at`,
    `updated_by`
) VALUES (
    'A',
    '10001',
    '2020-10-01 00:00:00',
    '2021-10-01 00:00:00',
    '0',
    '0',
    '0',
    NULL,
    '2020-04-23 13:53:05',
    '1',
    '2020-04-23 13:58:20',
    '1'
);

-- @UPDATE
UPDATE
    `company` c1
    JOIN `company_bak` c2 ON c1.company_id = c2.company_id
SET
    c1.company_name = c2.company_name
WHERE
    c1.company_id = 1;

-- @DELETE
DELETE
    c1.*
FROM
    `company` c1
    JOIN `company_bak` c2 ON c1.company_id = c2.company_id
WHERE
    c1.company_id = 1;
```

##### DQL
```SQL
-- AS/COUNT/WHERE/LENGTH/LIKE/GROUP BY/HAVING/ORDER BY/LIMIT
SELECT
    c.company_id,
    c.company_name AS company,
    GROUP_CONCAT(c.company_name),
    COUNT(c.company_name) AS total
FROM
    company c
WHERE
    LENGTH(c.company_name) > 0 -- =、!=、>=、<=、>、<、REGEXP
    AND c.company_id IN(SELECT cb.company_id FROM company_bak cb)
    -- AND EXISTS(SELECT 1 FROM company_bak cb WHERE cb.company_id = c.company_id)
    AND c.company_name LIKE 'B%' -- LIKE、NOT LIKE
    AND c.company_code IS NOT NULL -- IS NULL、IS NOT NULL
GROUP BY
    c.company_id,
    c.company_name
HAVING
    total > 0
ORDER BY
    company_id ASC,
    company DESC
LIMIT 100;

-- DISTINCT
SELECT
    DISTINCT c.company_name
FROM
    company c;

-- LEFT/RIGHT/INNER JOIN
SELECT
    c.company_id,
    c.company_name,
    cb.company_id,
    cb.company_name
FROM
    company c
    LEFT JOIN company_bak cb ON c.company_id = cb.company_id
WHERE
    c.company_id > 0;

-- COMPLEX
SELECT
    @a := 1 AS a,
    @b := IFNULL((SELECT MAX(c1.company_id) FROM company c1), 0) AS b,
    @c := IF(@a > 1, 50, 0) AS c,
    @d := IFNULL((CASE WHEN c.company_id = 1 THEN 100 WHEN c.company_id = 2 THEN 200 ELSE 0 END), 0) AS d,
    ROUND((@a + @b + @c + @d), 4) AS sum
FROM
    company c
WHERE
    c.company_id > 0;
```

##### DCL
```SQL
-- @PRIVILEGES
CREATE USER 'bruce'@'%' identified by '123456';
GRANT SELECT ON *.* TO 'bruce'@'%';
ALTER USER 'bruce'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
FLUSH PRIVILEGES;

```

##### FUNCTION
```SQL
-- @VERSION
SELECT VERSION(), @@version;

-- @TIME
SHOW VARIABLES LIKE "%time_zone%";
SELECT
    @@global.time_zone,
    @@session.time_zone,
    NOW(),
    CURDATE(),
    CONVERT_TZ(UTC_TIMESTAMP, 'UTC', 'America/Los_Angeles'),
    UTC_TIMESTAMP,
    DATE_FORMAT(CONVERT_TZ(UTC_TIMESTAMP, 'UTC', 'Asia/Shanghai'), '%Y-%m-%d %H:%i:%s'),
    YEAR(CURDATE()),
    MONTH(CURDATE()),
    WEEKOFYEAR(CURDATE()),
    WEEK(CURDATE()),
    DAY(CURDATE());

```

##### DEBUG
```SQL
-- @INFO
SELECT * FROM information_schema.innodb_trx;
SELECT * FROM information_schema.innodb_locks;
SELECT * FROM information_schema.innodb_lock_waits;

-- @PROCESS
SHOW PROCESSLIST;
KILL 9087506;

-- @PERFORMANCE
EXPLAIN
SELECT
    c.*
FROM company c;

-- @MANY CONNECTION ERRORS
SET GLOBAL max_connect_errors=10000;
FLUSH HOSTS;

-- @SQL MODE
SELECT @@sql_mode
SET @@sql_mode = '...'
```

##### ADVANCED
* 视图
* 存储过程
* 触发器
* 事务
* 数据库架构
* 数据库优化
