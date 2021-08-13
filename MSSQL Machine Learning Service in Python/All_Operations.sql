/*

There are 3 steps to process SQL server data in python
    1. Import data using SELECT statement
    2. Process data using python functions and libraries
    3. Export the data as a valid SQL server result set.

For the first option, Query results are converted into a python dataframe and then stored in a variable called "InputDataSet". Later on, this variable can be used in the python scripts. 
Then we will have to use pandas dataframe functions namely loc/iloc to process the data.
Finally, Exporting data uses "OutputDataSet" variable. It converts the data frame into SQL server result set on exit.



-----------------------------------------------------------------------------
Convert a series to a data frame
converstion workflow
A number of scaler value -> A python list -> pandas series -> Pandas Data Frame -> SQL server result set

diff between series and frame:
    series contains a single column of values.
    data frame contains one or more column
*/

-------------------------------------------------------------------------------
-- A simple task

--Step 1, Generate Query
SELECT
    ColorID,
    ColorName
FROM 
    WideWorldImporters.Warehouse.Colors
WHERE
    ColorID>20

--Step 2, Execute in Python
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet)
',
@INPUT_DATA_1 = N'
SELECT
    ColorID,
    ColorName
FROM 
    WideWorldImporters.Warehouse.Colors
WHERE
    ColorID>20
'



-------------------------------------------------------------------------------
-- A simple task, another way
--Step 1, Generate Query
SELECT
    ColorID,
    ColorName
FROM 
    WideWorldImporters.Warehouse.Colors

--Step 2, Execute in Python
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
OutputDataSet = InputDataSet.iloc[20:]
print(OutputDataSet.shape)
',
@INPUT_DATA_1 = N'
SELECT
    ColorID,
    ColorName
FROM 
    WideWorldImporters.Warehouse.Colors
ORDER BY
    ColorID
'
WITH RESULT SETS (([cOLORid] INT, [COLORNAME] NVARCHAR(25)))




-------------------------------------------------------------------------------
-- A simple task, FULL TASK
--Step 1, Generate Query
SELECT
    ColorID,
    ColorName
FROM 
    WideWorldImporters.Warehouse.Colors

--Step 2, Execute in Python
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.iloc[20:])
print("Shape of the obtained DataFrame: " + str(InputDataSet.iloc[20:].shape))
OutputData = InputDataSet.iloc[20:]
OutputDataSet = OutputData.head(10)
',
@INPUT_DATA_1 = N'
SELECT
    ColorID,
    ColorName
FROM 
    WideWorldImporters.Warehouse.Colors
ORDER BY
    ColorID
'
WITH RESULT SETS (([cOLORid] INT, [COLORNAME] NVARCHAR(25)))


-------------------------------------------------------------------------------
-- Findout the packages of anaconda
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
import pkg_resources
packages = [str(x) for x in pkg_resources.working_set]
packages.sort(key = str.lower)
packages = pandas.DataFrame(packages)
OutputDataSet = packages
'
WITH RESULT SETS(([Package_name] NVARCHAR(40)))




-------------------------------------------------------------------------------
-- Produce graphs with Matplotlib
-- Generate the query
SELECT 
    StateProvinceID,
    COUNT(CityID) AS Cities
FROM
    WideWorldImporters.Application.Cities
GROUP BY
    StateProvinceID

-- Script in python
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
import matplotlib.pyplot as plt
x = InputDataSet.StateProvinceID
y = InputDataSet.Cities
plt.bar(x,y)
plt.xlabel("State/Province ID")
plt.ylabel("Number of Cities")
plt.title("Cities per State/Province")
plt.savefig("..\MyFigure.png")
',
@INPUT_DATA_1 = N'
SELECT 
    StateProvinceID,
    COUNT(CityID) AS Cities
FROM
    WideWorldImporters.Application.Cities
GROUP BY
    StateProvinceID
'

-- To locate the saved file
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(os.getcwd())
'




-------------------------------------------------------------------------------
-- Get Dexcriptive Statistics on DataFrame
-- Generate the query first | Getting order ID and Price
SELECT
    o.OrderID, SUM(ol.Quantity * ol.UnitPrice) as Total_Price
FROM 
    WideWorldImporters.Sales.Orders AS o
INNER JOIN
    WideWorldImporters.Sales.OrderLines as ol
ON
    o.OrderID = ol.OrderID
GROUP BY
    o.OrderID
ORDER BY
    o.OrderID

-- Putting In Python Script
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.describe())
',
@INPUT_DATA_1 = N'
SELECT
    o.OrderID, CONVERT(float, SUM(ol.Quantity * ol.UnitPrice)) as Total_Price
FROM 
    WideWorldImporters.Sales.Orders AS o
INNER JOIN
    WideWorldImporters.Sales.OrderLines as ol
ON
    o.OrderID = ol.OrderID
GROUP BY
    o.OrderID
ORDER BY
    o.OrderID
'



-------------------------------------------------------------------------------
-- Challenge 2
-- Query
SELECT
    DISTINCT CityName,
    CityID 
FROM
    WideWorldImporters.Application.Cities

-- Python Script
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.sample(10))
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    CityID 
FROM
    WideWorldImporters.Application.Cities
'
--WITH RESULT SETS (([CityName] NVARCHAR(30), [CITY_ID] INT))



-------------------------------------------------------------------------------
/*
Standard Format
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'

',
@INPUT_DATA_1 = N'

'
WITH RESULT SET(([]))
*/





/*
Here we will be using another parameter at the end. that is input_data_*. That will be storing the query result as a pandas dataframe into the variable.
*/
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet)
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'



-------------------------------------------------------------------------------
-- We can use iloc in the python Script as well
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.iloc[5:15:2])
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'




-------------------------------------------------------------------------------
-- We can use head in the python Script as well
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.head(100))
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'




-------------------------------------------------------------------------------
-- We look into the columns of the dataset now
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.columns)
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'




-------------------------------------------------------------------------------
-- We look into the shape of dataframe
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.shape)
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'



-------------------------------------------------------------------------------
--Conver series into frame
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
A = "Banana"
B = "Apple"
C = "Cherry"
OutputDataSet = pandas.DataFrame(pandas.Series([A, B, C]))
'


-------------------------------------------------------------------------------
--Add Multiple series to a data frame | Combine in a Dictionary
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
A = "Banana"
B = "Apple"
C = "Cherry"
X = "Red"
Y = "Yellow"
Z = "Blue"
Fruits = pandas.Series([A, B, C])
Colors = pandas.Series([X ,Y, Z])
df = pandas.DataFrame({"Fruits": Fruits, "Colors": Colors})
OutputDataSet = df
'



-------------------------------------------------------------------------------
-- Include index in a data frame.

-- Query
SELECT
    LatestRecordedPopulation
FROM
    WideWorldImporters.Application.Cities

-- PYTHON SCRIPT
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
stats = InputDataSet.describe()
OutputDataSet = stats.reset_index()
',
@INPUT_DATA_1 = N'
SELECT
    LatestRecordedPopulation
FROM
    WideWorldImporters.Application.Cities
'



-------------------------------------------------------------------------------
-- Include index in a data frame.
-- QUERY
SELECT
    TOP 10 CityID,
    CityName
FROM
    WideWorldImporters.Application.Cities

-- Python Script
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet)
CityIDSeries = InputDataSet.iloc[:,0]
CityNameSeries = InputDataSet.iloc[:,1]
"""print("-------------------------------------------------------------------------------")
print(CityIDSeries)
print("-------------------------------------------------------------------------------")
print(CityNameSeries)"""

df = pandas.DataFrame({"CityId": CityIDSeries, "CityName": CityNameSeries})
outputDataSet = df

',
@INPUT_DATA_1 = N'
SELECT
    TOP 10 CityID,
    CityName
FROM
    WideWorldImporters.Application.Cities
'


-------------------------------------------------------------------------------
-- Challenge 3
-- generate query
SELECT 
    Temperature
FROM
    WideWorldImporters.Warehouse.ColdRoomTemperatures

-- Python
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
cVal = InputDataSet.iloc[:,0]
fVal = (cVal*1.8) + 32
#print(cVal)
#print(fVal)
df = pandas.DataFrame({"TempC": cVal, "TempF": fVal})
OutputDataSet = df
',
@INPUT_DATA_1 = N'
SELECT 
    CONVERT(float, Temperature)
FROM
    WideWorldImporters.Warehouse.ColdRoomTemperatures
'
WITH RESULT SETS(([TempC] float, [TempF] float))






-------------------------------------------------------------------------------
-- Craeting a Store procedure

CREATE PROCEDURE RANDOMNUMBER
AS
EXECUTE sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
import random as r
mylst = [r.randint(1,101) for x in range(1,11)]
OutputDataSet = pandas.DataFrame(pandas.Series(mylst))
'
WITH RESULT SETS(([Random_Numbers] INT))




-------------------------------------------------------------------------------
-- Craeting a Store procedure in python with parameter passing

CREATE PROCEDURE RandomNumberMod
    @count INT
AS
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
import random as r
mylst = [r.randint(1,100) for x in range(1,n+1)]
OutputDataSet = pandas.DataFrame(pandas.Series(mylst))
',
@PARAMS = N'@n int',
@n = @count
WITH RESULT SETS(([RandomNumbers] INT))




-------------------------------------------------------------------------------
-- Challenge 4
--Query
SELECT
    CityID,
    CityName
FROM
    WideWorldImporters.Application.Cities

--Creating Procedure

CREATE PROCEDURE ReturnCity
    @count INT
AS
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
OutputDataSet = InputDataSet.sample(m)
',
@INPUT_DATA_1 = N'
SELECT
    CityID,
    CityName
FROM
    WideWorldImporters.Application.Cities
',
@PARAMS = N'@m int',
@m = @count
WITH RESULT SETS(([City_ID] INT, [CITY_NAME] NVARCHAR(50)))


EXEC ReturnCity @count = 50



-------------------------------------------------------------------------------
-- We save the query result to output dataset
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
OutputDataSet = InputDataSet.iloc[5:15:2]
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'




-------------------------------------------------------------------------------
-- Previous report didn't have any name on columns. To define columns, we use "WITH RESULT SETS"
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print(InputDataSet.iloc[5:15:2])
',
@INPUT_DATA_1 = N'
SELECT
    DISTINCT CityName,
    StateProvinceID
FROM 
    WideWorldImporters.Application.Cities
ORDER BY
    CityName
'
WITH RESULT SETS (([City Name] NVARCHAR(100), [State_Province_ID] INT))