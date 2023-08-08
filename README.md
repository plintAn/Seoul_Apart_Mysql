# Seoul_Apartment MySQL 분석

이 포스트에서는 MySQL Workbench를 활용하여 서울의 아파트 매매 데이터를 분석하고 전처리하는 방법을 탐색하겠습니다. 전처리 단계를 마치고 나면, 이 데이터셋은 매매의 분포를 이해하거나 판매된 아파트의 평균 면적과 같은 통찰력 있는 지표를 파악하기 위해 잘 활용될 수 있습니다.

## Python이 아닌 MySQL을 활용해 분석하는 이유


Python(API호출)과 CSV 파일 활용
|           | 장점              | 단점                |
|-----------|------------------|--------------------|
|           | 간편한 데이터 로드   | 파일 크기 제한        |
|           | 별도의 데이터베이스 설정 X | 대용량 데이터 처리 부적합 |
|           | API호출 비용 수반 | 수동적인 데이터 업데이트 |

MySQL Workbench를 활용한 SQL 활용
|           | 장점               | 단점                      |
|-----------|-------------------|--------------------------|
|           | 대용량 데이터 효율적 처리  | 초기 설정 시간 소요          |
|           | 편리한 데이터 업데이트 및 관리 | SQL 지식 요구              |
|           | 다양한 쿼리와 집계 가능    |                            |
|           | Google Data Studio와 연동 |                            |


서울특별시_부동산 실거래가 정보 자료 출처:https://www.data.go.kr/tcs/dss/selectFileDataDetailView.do?publicDataPk=15052419

## 데이터 CRUD

CREATE, ROAD, USE, DELETE

### 1. 데이터 선택


```SQL
SELECT * FROM seoul_apartment.apartment_sales;
```
* 이 코드는 seoul_apartment 데이터베이스의 apartment_sales 테이블에서 모든 데이터를 선택합니다.

### 2. 데이터베이스 사용 설정

```SQL
USE seoul_apartment;
```
* 이 코드는 seoul_apartment 데이터베이스를 사용하도록 설정

### 3. IsNumeric 함수 설정

```SQL
DROP FUNCTION IF EXISTS IsNumeric;
```
* 이미 IsNumeric 함수가 존재한다면 해당 함수를 삭제
```SQL
DELIMITER //

CREATE FUNCTION IsNumeric(s VARCHAR(255)) RETURNS TINYINT DETERMINISTIC
BEGIN
    ...
END //

DELIMITER ;
```

* 문자열이 숫자로만 구성되어 있는지 검사하는 사용자 정의 함수 IsNumeric를 정의하는데, 이 함수는 주어진 문자열이 숫자인 경우 1을 반환하고, 그렇지 않으면 0을 반환한다.

### 4. 데이터베이스 및 테이블 생성

```SQL
CREATE DATABASE IF NOT EXISTS Seoul_Apartment;
USE Seoul_Apartment;
DROP TABLE IF EXISTS apartment_sales;
CREATE TABLE apartment_sales ( ... );
```

* Seoul_Apartment라는 이름의 데이터베이스를 생성합니다. 이미 해당 이름의 데이터베이스가 있으면 생성하지 않습니다.
* 사용할 데이터베이스를 Seoul_Apartment로 설정합니다.
* 'apartment_sales'라는 테이블이 이미 있다면 삭제하고, 해당 이름으로 새 테이블을 정의합니다.

### 5. 데이터 로드

```SQL
LOAD DATA INFILE 'YOURDATASET_PATH.csv'
```

* 주어진 경로의 CSV 파일에서 데이터를 불러와 apartment_sales 테이블에 저장
* 특정 필드는 변수(@변수명)를 사용하여 임시로 저장되며, 데이터 로딩 후에 조건에 따라 처리된다
* SET 구문을 사용하여 IsNumeric 함수를 활용해 숫자가 아닌 값들을 NULL로 변환하거나, 다른 특정 조건에 따라 값을 변환하거나 설정한다.
* 이 코드는 서울의 아파트 매매 데이터를 MySQL 데이터베이스에 저장하고 전처리하기 위한 것이다.
* 데이터 로딩 시 특정 조건에 따라 데이터의 정합성을 유지하기 위한 전처리 작업이 포함되어 있습니다.

다음은 로딩된 결과물

![Mysql_Execute_Apartment](https://github.com/plintAn/Seoul_Apart_Mysql/assets/124107186/c1390f1a-0b1b-4dab-bc4f-426355c3c1c1)


![image](https://github.com/plintAn/Seoul_Apart_Mysql/assets/124107186/b1c8cdae-e1d6-4bfd-8391-2d891e6a3f7a)


1048575 row(s) affected Records: 1048575  Deleted: 0  Skipped: 0  Warnings: 0

100만개가 넘는 행을 불러올 수 있었습니다. 확실히 파이썬을 이용한 csv 활용보다 편리하네요

### 6.데이터 편집



편집연습

* 조건 : 2019년도 ~ 2023년도
* 건물용도 : 아파트
* 물건금액_만원 : 가장 비싼
* 정렬 : 높은순
* 리스트 : 100개

```sql
SELECT *
FROM seoul_apartment.apartment_sales
WHERE 건물용도 = '아파트' AND 접수연도 BETWEEN 2019 AND 2023
ORDER BY 물건금액_만원 DESC
LIMIT 100;

```

![image](https://github.com/plintAn/Seoul_Apart_Mysql/assets/124107186/0a785590-59da-4391-b62c-a6c0e1a78b62)

4월 28 강남 청담동에서 PH129라는 건물명을 가진 아파트가 무려 145억으로 가장 비싸게 거래가 된 것을 확인할 수 있었습니다.






