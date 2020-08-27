-- 特徴量生成用テーブル
CREATE TABLE [dbo].[SensorFeatures]
(
	DeviceId NVARCHAR(10)NULL ,
	Period REAL NULL,
	Sensor11 REAL NULL,
	Sensor14 REAL NULL,
	Sensor15 REAL NULL,
	Sensor9 REAL NULL
	,[features] REAL NULL
)
GO 

-- 一時テーブルロード
INSERT INTO [dbo].[SensorFeatures]
SELECT   
	DeviceId,
	MAX(Period),
	avg(Sensor11),
	avg(Sensor14),
	avg(Sensor15),
	avg(Sensor9),
	avg(Sensor11)
FROM 
	Sensor
GROUP BY 
	DeviceId
GO

-- Modelを変数にセット
DECLARE @model varbinary(max) = (SELECT top 1 Model FROM [dbo].[Models]);

-- スコアリングの開始
SELECT 
	d.*, 
	p.prediction as RUL
INTO
	[dbo].[PREDICT_SensorRUL]
FROM 
	PREDICT(
		MODEL = @model,
		DATA =  [dbo].[SensorFeatures] AS d
		)
WITH (
	prediction real
	) AS p;

