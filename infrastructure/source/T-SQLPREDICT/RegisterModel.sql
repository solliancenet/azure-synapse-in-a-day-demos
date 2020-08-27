-- 資格情報の保存
CREATE DATABASE SCOPED CREDENTIAL [ADLS_CREDENTIAL]
WITH
 IDENTITY = 'ストレージアカウント名'
, SECRET = 'キー';

-- 外部データソースの作成
CREATE EXTERNAL DATA SOURCE [DS_ADLS_CREDENTIAL]
WITH
( LOCATION = 'abfss://datalake@ストレージアカウント名.dfs.core.windows.net'
, CREDENTIAL = ADLS_CREDENTIAL
, TYPE = HADOOP
)

-- 外部データフォーマット定義
CREATE EXTERNAL FILE FORMAT [csv]
WITH (
FORMAT_TYPE = DELIMITEDTEXT,
FORMAT_OPTIONS (
FIELD_TERMINATOR = ',',
STRING_DELIMITER = '',
DATE_FORMAT = '',
USE_TYPE_DEFAULT = False
)
);
GO

-- 外部データ用スキーマ作成
CREATE SCHEMA [ext];
GO

-- モデル読み込み用外部テーブル作成
CREATE EXTERNAL TABLE [ext].[Models]
(
[Model] [varbinary](max) NULL
)
WITH (
 LOCATION='/Models/hex/rul_model.onnx.hex' ,
 DATA_SOURCE = DS_ADLS_CREDENTIAL ,
 FILE_FORMAT = csv ,
 REJECT_TYPE = VALUE ,
 REJECT_VALUE = 0
)
GO

-- モデル保存テーブル作成
CREATE TABLE [dbo].[Models]
(
[Id] [int] IDENTITY(1,1) NOT NULL,
[Model] [varbinary](max) NULL,
[Description] [varchar](200) NULL
)
WITH (
 DISTRIBUTION = REPLICATE,
 heap
)
GO

-- 外部テーブルからロード
INSERT INTO [dbo].[Models]
SELECT Model, 'RUL Model'
FROM [ext].[Models]
GO

-- テーブル確認
SELECT 
    *
FROM 
    [dbo].[Models]

/*
再実行用
DROP TABLE Models
DROP EXTERNAL TABLE [ext].[Models]
DROP SCHEMA ext
DROP EXTERNAL DATA SOURCE DS_ADLS_CREDENTIAL
DROP DATABASE SCOPED CREDENTIAL ADLS_CREDENTIAL
DROP EXTERNAL FILE FORMAT csv
*/
