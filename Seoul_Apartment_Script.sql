SELECT * FROM seoul_apartment.apartment_sales;

USE seoul_apartment;

-- 기존에 IsNumeric 함수가 있으면 삭제
DROP FUNCTION IF EXISTS IsNumeric;

DELIMITER //

CREATE FUNCTION IsNumeric(s VARCHAR(255)) RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE validChar CHAR(1);
    DECLARE isNum TINYINT DEFAULT 1;
    DECLARE i INT DEFAULT 1;

    IF s IS NULL OR LENGTH(s) = 0 THEN
        RETURN 0;
    END IF;

    WHILE i <= LENGTH(s) DO
        SET validChar = SUBSTRING(s, i, 1);

        IF validChar NOT REGEXP '^[0-9]$' THEN
            SET isNum = 0;
        END IF;

        SET i = i + 1;
    END WHILE;

    RETURN isNum;
END //

DELIMITER ;


CREATE DATABASE IF NOT EXISTS Seoul_Apartment;
USE Seoul_Apartment;

-- 기존 테이블 삭제
DROP TABLE IF EXISTS apartment_sales;

CREATE TABLE apartment_sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    접수연도 INT NULL,
    자치구코드 INT NULL,
    자치구명 VARCHAR(255) NULL,
    법정동코드 INT NULL,
    법정동명 VARCHAR(255) NULL,
    지번구분 INT NULL,
    지번구분명 VARCHAR(255) NULL,
    본번 INT NULL,
    부번 INT NULL,
    건물명 VARCHAR(255) NULL,
    계약일 DATE NULL,
    물건금액_만원 INT NULL,
    건물면적_㎡ FLOAT NULL,
    토지면적_㎡ FLOAT NULL,
    층 INT NULL,
    권리구분 VARCHAR(255) NULL,
    취소일 DATE NULL,
    건축년도 INT NULL,
    건물용도 VARCHAR(255) NULL,
    신고구분 VARCHAR(255) NULL,
    시군구_공인중개사 VARCHAR(255) NULL
);

LOAD DATA INFILE 'C:/Program Files/MySQL/MySQL Server 8.0/Uploads/dataset.csv'
INTO TABLE apartment_sales
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(
    접수연도, 
    자치구코드, 
    자치구명, 
    법정동코드, 
    법정동명, 
    @지번구분, 
    지번구분명, 
    @본번, 
    @부번, 
    건물명, 
    계약일, 
    물건금액_만원, 
    건물면적_㎡, 
    @토지면적, 
    @층, 
    권리구분, 
    @취소일, 
    @건축년도, 
    건물용도, 
    신고구분, 
    시군구_공인중개사
)
SET 
    취소일 = NULLIF(@취소일, ''),
    지번구분 = CASE WHEN IsNumeric(@지번구분) = 1 THEN @지번구분 ELSE NULL END,
    본번 = CASE WHEN IsNumeric(@본번) = 1 THEN @본번 ELSE NULL END,
    부번 = CASE WHEN IsNumeric(@부번) = 1 THEN @부번 ELSE NULL END,
    층 = CASE WHEN IsNumeric(@층) = 1 THEN @층 ELSE NULL END,
    건축년도 = CASE WHEN IsNumeric(@건축년도) = 1 THEN @건축년도 ELSE NULL END,
    토지면적_㎡ = CASE WHEN TRIM(@토지면적)='' OR @토지면적 IS NULL THEN NULL ELSE CAST(@토지면적 AS FLOAT) END;
