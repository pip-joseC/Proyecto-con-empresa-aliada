/******************************** CREACIÓN DE LAS TABLAS ********************************/

-- Creando la tabla de categorías (category)
CREATE TABLE category (
    [IdCategory] TINYINT, --IdCategory son enteros del 1 al 5, un TINYINT es suficiente
    [Category] VARCHAR(100) --Aquí se guarda el significado de cada Id en forma de cadenas de texto
)

-- Creando la tabla del calendario (calendar)
CREATE TABLE calendar (
    [Week] VARCHAR(10), --Identificadores cortos de cada semana 
    [Year] INT, --Año correspondiente, en forma de entero 
    [Month] TINYINT, --Mes correspondiente, identificado por su número de mes del 1 al 12
    [WeekNumber] TINYINT, --Número de la semana de ese año, va del 1 a 52
    [Date] DATE --Fecha completa del primer día de la semana correspondiente
)

-- Creando la tabla de segmentos (segments)
CREATE TABLE segments (
    [Category] TINYINT, --Entero identificador de la categoría
    [Attr1] VARCHAR(30), --Primer atributo, guardado como texto
    [Attr2] VARCHAR(30), --Segundo atributo, guardado como texto
    [Attr3] VARCHAR(30), --Tercer atributo, guardado como texto
    [Format] VARCHAR(30), --Nombre del formato/presentación, guardado como texto
    [Segment] VARCHAR(30) --Nombre del segmento correspondiente, guardado como texto
)

-- Creando la tabla de productos (products)
CREATE TABLE products (
    [Manufacturer] VARCHAR(100), --Nombre del manufacturero, guardado como texto
    [Brand] VARCHAR(100), --Nombre de la marca, guardado como texto
    [Item] VARCHAR(100), --Identificador alfanumérico del producto
    [ItemDescription] VARCHAR(255), --Descripción del producto, guardado como un texto largo
    [Category] TINYINT, --Entero identificador de la categoría
    [Format] VARCHAR(30), --Nombre del formato/presentación, guardado como texto
    [Attr1] VARCHAR(30), --Primer atributo, guardado como texto
    [Attr2] VARCHAR(30), --Segundo atributo, guardado como texto
    [Attr3] VARCHAR(30), --Tercer atributo, guardado como texto
)

-- Creando la tabla de ventas (sales)
CREATE TABLE sales (
    [Week] VARCHAR(10), --Identificadores cortos de cada semana de la venta
    [ItemCode] VARCHAR(100), --Identificador alfanumérico del producto vendido
    [TotalUnitSales] DECIMAL(8,3), --Cantidad decimal que mide las ventas unitarias de esa semana
    [TotalValueSales] DECIMAL(8,3), --Cantidad decimal que mide las ventas monetarias de esa semana
    [TotalUnitAvgWeeklySales] DECIMAL(8,3), --Cantidad que mide el rendimiento histórico promedio del producto
    [Region] VARCHAR(100) --Region en la que se hizo la venta, guardada como texto
)

/******************************** IMPORTANDO LOS DATOS ********************************/

-- Importar el archivo CSV
BULK INSERT category
--Ruta del archivo: esta debe de cambairse si se requiere reproducibilidad
FROM 'C:\Users\sorak\Proyecto Reckitt\DIM_CATEGORY.csv'
WITH (
    FORMAT='CSV', -- Especificamos que el formato es CSV
    FIRSTROW = 2  -- Saltar el encabezado, empezará en la segunda fila
);

SELECT * 
FROM category

-- Importar el archivo CSV, pero ahora para las ventas
BULK INSERT sales
--Ruta del archivo: esta debe de cambairse si se requiere reproducibilidad
FROM 'C:\Users\sorak\Proyecto Reckitt\FACT_SALES.csv'
WITH (
    FORMAT='CSV', -- Especificamos que el formato es CSV
    FIRSTROW = 2  -- Saltar el encabezado, empezará en la segunda fila
);

SELECT * 
FROM sales

-- LAS DEMÁS TABLAS FUERON IMPORTADAS CON LA HERRAMIENTA DE SSMS PARA IMPORTAR ARCHIVOS DE EXCEL

--Correción para evitar errores en el Asistente de importación de datos (requerirá convertir formato después)
ALTER TABLE calendar
ALTER COLUMN [Date] VARCHAR(10);
--Después, se tiene que importar la tabla de calendar otra vez y ya debería de funcionar

--Visualizando los datos ya insertados en la tabla calendar
SELECT * 
FROM calendar

--FALTA: Convertir el campo de "Date" de VARCHAR a DATE
--Agregando una nueva columna con tipo de dato DATE
ALTER TABLE calendar ADD ValidDate DATE;
--Actualizando los registros de este campo con los registros tipo VARCHAR convertidos a DATE
UPDATE calendar
SET ValidDate = CONVERT(DATE,[Date],103); --El formato 103 es el formato de fecha DD/MM/YYYY
--Eliminando el campo con las fechas en VARCHAR
ALTER TABLE calendar DROP COLUMN [Date];
--Renombrando la nueva columna como la anterior: 'Date'
EXEC sp_rename 'calendar.ValidDate', 'Date', 'COLUMN';

SELECT * 
FROM calendar

--Visualizando los datos ya insertados en la tabla segments
SELECT * 
FROM segments

--Visualizando los datos ya insertados en la tabla products
SELECT * 
FROM products


/******************************** LIMPIEZA DE DATOS ********************************/

--¿Hay valores nulos en las columnas de las tablas? (En category ya sabemos que no hay nulos)

--Checando valores nulos en segments
SELECT 
    SUM(CASE WHEN [Category] IS NULL THEN 1 ELSE 0 END) AS CategoryNulls,
    SUM(CASE WHEN [Attr1] IS NULL THEN 1 ELSE 0 END) AS Attr1Nulls,
    SUM(CASE WHEN [Attr2] IS NULL THEN 1 ELSE 0 END) AS Attr2Nulls,
    SUM(CASE WHEN [Attr3] IS NULL THEN 1 ELSE 0 END) AS Attr3Nulls,
    SUM(CASE WHEN [Format] IS NULL THEN 1 ELSE 0 END) AS FormatNulls,
    SUM(CASE WHEN [Segment] IS NULL THEN 1 ELSE 0 END) AS SegmentNulls
FROM segments;

--Checando valores nulos en calendar
SELECT 
    SUM(CASE WHEN [Week] IS NULL THEN 1 ELSE 0 END) AS WeekNulls,
    SUM(CASE WHEN [Year] IS NULL THEN 1 ELSE 0 END) AS YearNulls,
    SUM(CASE WHEN [Month] IS NULL THEN 1 ELSE 0 END) AS MonthNulls,
    SUM(CASE WHEN [WeekNumber] IS NULL THEN 1 ELSE 0 END) AS WeekNumberNulls,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS DateNulls
FROM calendar;

--Checando valores nulos en products
SELECT 
    SUM(CASE WHEN [Manufacturer] IS NULL THEN 1 ELSE 0 END) AS ManufacturerNulls,
    SUM(CASE WHEN [Brand] IS NULL THEN 1 ELSE 0 END) AS BrandNulls,
    SUM(CASE WHEN [Item] IS NULL THEN 1 ELSE 0 END) AS ItemNulls,
    SUM(CASE WHEN [ItemDescription] IS NULL THEN 1 ELSE 0 END) AS ItemDescriptionNulls,
    SUM(CASE WHEN [Category] IS NULL THEN 1 ELSE 0 END) AS CategoryNulls,
    SUM(CASE WHEN [Format] IS NULL THEN 1 ELSE 0 END) AS FormatNulls,
    SUM(CASE WHEN [Attr1] IS NULL THEN 1 ELSE 0 END) AS Attr1Nulls,
    SUM(CASE WHEN [Attr2] IS NULL THEN 1 ELSE 0 END) AS Attr2Nulls,
    SUM(CASE WHEN [Attr3] IS NULL THEN 1 ELSE 0 END) AS Attr3Nulls
FROM products;

--Checando valores nulos en sales
SELECT 
    SUM(CASE WHEN [Week] IS NULL THEN 1 ELSE 0 END) AS WeekNulls,
    SUM(CASE WHEN [ItemCode] IS NULL THEN 1 ELSE 0 END) AS ItemCodeNulls,
    SUM(CASE WHEN [TotalUnitSales] IS NULL THEN 1 ELSE 0 END) AS ItemNulls,
    SUM(CASE WHEN [TotalValueSales] IS NULL THEN 1 ELSE 0 END) AS TotalUnitSalesNulls,
    SUM(CASE WHEN [TotalUnitAvgWeeklySales] IS NULL THEN 1 ELSE 0 END) AS TotalUnitAvgWeeklySalesNulls,
    SUM(CASE WHEN [Region] IS NULL THEN 1 ELSE 0 END) AS RegionNulls
FROM sales;


--Tratando los valores nulos
UPDATE segments --Solo hay un valor nulo en segments en la columna Attr3
SET [Attr3] = ISNULL([Attr3], 'NO DEFINIDO');

UPDATE products --Solo hay 12 valores nulos en la tabla products: 6 en Attr1 y 6 en Attr3
SET [Attr1] = ISNULL([Attr1], 'NO DEFINIDO'),
    [Attr3] = ISNULL([Attr3], 'NO DEFINIDO');


--¿Hay duplicados en las tablas?
--Se agruparán los datos tomando en cuenta todas las columnas, y se mostrarán las que aparezcan más de 1 vez
SELECT *, COUNT(*) AS VecesDuplicado
FROM calendar
GROUP BY [Week], [Year], [Month], [WeekNumber], [Date] 
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS VecesDuplicado
FROM segments
GROUP BY [Category], [Attr1], [Attr2], [Attr3], [Format], [Segment]
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS VecesDuplicado
FROM products
GROUP BY [Manufacturer], [Brand], [Item], [ItemDescription], [Category], [Format], [Attr1], [Attr2], [Attr3]
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS VecesDuplicado
FROM sales
GROUP BY [Week], [ItemCode], [TotalUnitSales], [TotalValueSales], [TotalUnitAvgWeeklySales], [Region]
HAVING COUNT(*) > 1;

--Solo se encontró un registro duplicado en la tabla segments
WITH cte_dups AS ( --Creamos un CTE, ya que necesitamos filtrar la columna generada con ROW_NUMBER()
SELECT *, ROW_NUMBER() OVER( --Particionamos sobre todas las columnas de la tabla segments
          PARTITION BY [Category], [Attr1], [Attr2], [Attr3], [Format], [Segment] 
          ORDER BY [Segment]) AS IdDuplicado
FROM segments
)
DELETE FROM cte_dups
WHERE IdDuplicado > 1; --Eliminamos los que tengan un IdDuplicado > 1, los cuales corresponden a duplicados


/************** Definición de llaves (PRIMARY KEY y FOREIGN KEY) ****************/
--Antes de asignar las "Primary Keys", hay qe asegurarnos que no tengan valores nulos y duplicados.
--(en todas las tabals menos category, porque ya se visualizó que no hay valores duplicados)

--Verificando duplicados en solo en los campos que deben de ser primary keys para las tablas:
--calendar (campo Week)
SELECT [Week], COUNT(*) AS Frecuency
FROM calendar
GROUP BY [Week]
HAVING COUNT(*) > 1;
--segments (campos Category, Attr1, Attr2, Attr3, Format)
SELECT [Category], [Attr1], [Attr2], [Attr3], [Format], COUNT(*) AS Frecuency
FROM segments
GROUP BY [Category], [Attr1], [Attr2], [Attr3], [Format]
HAVING COUNT(*) > 1;
--products (campo Item)
SELECT [Item], COUNT(*) AS Frecuency
FROM products
GROUP BY [Item]
HAVING COUNT(*) > 1;

--¿Hay algún producto en la tabla "sales" que tenga como ItemCode = 'N/A'?
SELECT [ItemCode]
FROM sales
WHERE [ItemCode] = 'N/A'

--Como no hay ningún producto con ItemCode 'N/A', lo mejor será eliminarlos, ya que no serán de utilizada para Joins
DELETE FROM products
WHERE [Item] = 'N/A';


--Una vez ya revisado esto, podemos asignar las Primary y Foerign Keys a cada tabla:

--category solo tiene la Primary Key de IdCategory
ALTER TABLE category
ALTER COLUMN [IdCategory] TINYINT NOT NULL; --Primero hay que redefinir que no acepte valores nulos
ALTER TABLE category
ADD CONSTRAINT PK_IdCategory PRIMARY KEY CLUSTERED ([IdCategory]); --Asignando la Primary Key

--calendar solo tiene la Primary Key de Week
ALTER TABLE calendar
ALTER COLUMN [Week] VARCHAR(10) NOT NULL; --Primero hay que redefinir que no acepte valores nulos
ALTER TABLE calendar
ADD CONSTRAINT PK_Week PRIMARY KEY CLUSTERED ([Week]); --Asignando la Primary Key 

--segments tiene una Composite Primary Key conformada por: [Category],[Attr1],[Attr2],[Attr3],[Format]
ALTER TABLE segments
ALTER COLUMN [Category] TINYINT NOT NULL; 
ALTER TABLE segments
ALTER COLUMN [Attr1] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ALTER COLUMN [Attr2] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ALTER COLUMN [Attr3] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ALTER COLUMN [Format] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ADD CONSTRAINT PK_segment PRIMARY KEY ([Category],[Attr1],[Attr2],[Attr3],[Format]); --Asignando la Primary Key 

--products tiene la PK de Item, y dos FK: CAtegory y la compuesta de la tabla segments
ALTER TABLE products
ALTER COLUMN [Item] VARCHAR(100) NOT NULL; --Primero hay que redefinir que no acepte valores nulos
ALTER TABLE products
ADD CONSTRAINT PK_Item PRIMARY KEY CLUSTERED ([Item]); --Asignando la Primary Key 
ALTER TABLE products
ADD CONSTRAINT FK_Category FOREIGN KEY ([Category]) --Asignando la Foreign Key 
REFERENCES category([IdCategory]); --Hace referencia a la PK de calendar
ALTER TABLE products --Asignando la Composite Foreign Key
ADD CONSTRAINT FK_segments FOREIGN KEY ([Category],[Attr1],[Attr2],[Attr3],[Format])  
REFERENCES segments ([Category],[Attr1],[Attr2],[Attr3],[Format]); --Hace referencia a la PK de segments

--sales tiene 2 Foreign Keys: Week e ItemCode
ALTER TABLE sales
ADD CONSTRAINT FK_Week FOREIGN KEY ([Week]) --Asignando la Foreign Key 
REFERENCES calendar([Week]); --Hace referencia a la PK de calendar
ALTER TABLE sales
ADD CONSTRAINT FK_Item FOREIGN KEY ([ItemCode]) --Asignando la Foreign Key 
REFERENCES products([Item]); --Hace referencia a la PK de products


/******************************** JOINS DE TABLAS ********************************/
--Con la base de datos ya completa y preparada, podemos realizar algunos JOINS y generar views con estos
CREATE VIEW [Productos Detallados] AS
SELECT p.[Item], p.[Manufacturer], p.[Brand], p.[ItemDescription], 
       c.[Category], s.[Format], s.[Segment], s.[Attr1], s.[Attr2], s.[Attr3] --Campos a visualzar
FROM products AS p
    INNER JOIN category AS c ON c.[IdCategory] = p.[Category] --Haciendo un Inner Join utilizando la identificador de categoría (PK IdCategory)
    INNER JOIN segments AS s ON p.[Category] = s.[Category] AND p.[Attr1] = s.[Attr1] AND
                                p.[Attr2] = s.[Attr2] AND p.[Attr3] = s.[Attr3] AND
                                p.[Format] = s.[Format]; --Haciendo un Inner Join utilizando la composite PK para obtener los segmentos de los productos
--Visualizando el view creado
SELECT *
FROM [Productos Detallados];

CREATE VIEW [Ventas con Fechas] AS
SELECT ca.[Date], sa.[ItemCode], sa.[TotalUnitSales], 
       sa.[TotalValueSales], sa.[TotalUnitAvgWeeklySales], sa.[Region] --Campos a visualzar
FROM sales AS sa
    INNER JOIN calendar AS ca ON ca.[Week] = sa.[Week]; --Haciendo un Inner Join utilizando la identificador de la semana (PK Week)
--Visualizando el view creado
SELECT *
FROM [Ventas con Fechas];

--Para el siguiente Join, usaremos los dos views creados anteriormente y los juntaremos en uno solo
CREATE VIEW [Datos Completos] AS
SELECT vf.[Date], vf.[ItemCode], pd.[ItemDescription], vf.[TotalUnitSales], 
       vf.[TotalValueSales], vf.[TotalUnitAvgWeeklySales], vf.[Region],
       pd.[Manufacturer], pd.[Brand], pd.[Category], pd.[Format], 
       pd.[Segment], pd.[Attr1], pd.[Attr2], pd.[Attr3] --Campos a visualzar
FROM [Productos Detallados] AS pd
    INNER JOIN [Ventas con Fechas] AS vf ON pd.[Item] = vf.[ItemCode]; --Haciendo un Inner Join utilizando la código de producto (PK Item)
--Visualizando el view creado
SELECT *
FROM [Datos Completos];

/******************************** INSIGHTS RELEVANTES ********************************/
/*
A continuación, se presentarán múltiples consultas a la base de datos recién creada, con el objetivo
de obtener insights clave de las ventas. Para ello, se calcularán estadísticas de venta, definidas como:

Estadísticas de venta: El número de ventas (frecuencia de registros), el promedio de las las ventas 
unitarias (TotalUnitSales) y del rendimiento histórico de las ventas (TotalUnitAvgWeeklySales), 
así como el promedio y la suma total de las ventas monetarias totales (TotalValueSales)
*/

--Calculando las estadísticas de venta por segmento (Segment)
SELECT [Segment], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Segment]
ORDER BY AVG(TotalValueSales) DESC;

--Calculando las estadísticas de venta por formato (Format)
SELECT [Format], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Format]
ORDER BY AVG(TotalValueSales) DESC;

--Calculando las estadísticas de venta por región (Region)
SELECT [Region], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Region]
ORDER BY AVG(TotalUnitSales) DESC;

--Calculando las estadísticas de venta por marca (Brand). Dado que hay muchas marcas, solo se mostrará el Top 5 mejores.
SELECT TOP(5) [Brand], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Brand]
ORDER BY AVG(TotalValueSales) DESC; 

--Supongamos que queremos saber en qué lugar se encuentra Lysol en el ranking de las marcas según sus ventas promedio
WITH cte AS ( --Si no se realiza un CTE, el ranking no funciona correctamente
SELECT [Brand], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales,
       RANK() OVER(ORDER BY AVG(TotalValueSales) DESC) AS RankAvgSales,
       RANK() OVER(ORDER BY SUM(TotalValueSales) DESC) AS RankSumSales
FROM [Datos Completos]
GROUP BY [Brand]
)
SELECT *
FROM cte
WHERE [Brand] = 'LYSOL';


--AGRUPACIONES MÚLTIPLES
--Calculando las estadísticas de venta por Región y Segmento
SELECT TOP (10)
       [Region],
       [Segment], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Region], [Segment]
ORDER BY AVG(TotalValueSales) DESC;

--Calculando las estadísticas de venta por Segemento y Formato
SELECT TOP (10)
       [Segment],
       [Format], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Segment], [Format]
ORDER BY AVG(TotalValueSales) DESC;

--CONSULTAS MÁS ELABORADAS

/*
Mostrando el mejor producto de cada marca, mostrando sus estadisticas de ventas. Para solo desplegar información importante,
solamente se seleccionarán los productos de las marcas Vanish y Lysol (las marcas de interés) y las otras marcas del TOP 5 mejores ventas
(BLANCATEL,CLORALEX,CLOROX,CLARASOL)
*/
WITH cte_items AS ( --CTE con las estadísticas de ventas de cada producto
    SELECT [Brand],
           [ItemDescription],
           [Segment], 
           AVG(TotalUnitSales) AS AvgUnitSales,
           AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
           AVG(TotalValueSales) AS AvgValueSales,
           SUM(TotalValueSales) AS SumValueSales
    FROM [Datos Completos]
    GROUP BY [Brand],[ItemDescription],[Segment]
),
cte_ranked AS ( --Realizando otro CTE para poder aplicar un RANK particionado por marca, ya que después se utilziará esta nueva columna
    SELECT *,
           RANK() OVER(PARTITION BY [Brand] ORDER BY AvgValueSales DESC) AS RankBrand
    FROM cte_items
)
SELECT *
FROM cte_ranked --Se seleccioanrá solo el mejor producto por marca (RankBrand = 1) solo de las marcas correspondientes
WHERE RankBrand = 1 AND [Brand] IN ('VANISH','LYSOL','BLANCATEL','CLORALEX','CLOROX','CLARASOL')
ORDER BY AvgValueSales DESC;

/*
Vamos a utilizar las fechas para crear una categoría con fechas según el trimestre al que correspondan
La división trimestral estándar corporativa está definida como:
- Q1: Ene-Mar
- Q2: Abr-Jun
- Q3: Jul-Sep
- Q4: Oct-Dic
*/

--Necesitamos saber primero cuál es el rango de fechas disponibles
SELECT MIN([Date]) AS FechaMin, MAX([Date]) AS FechaMax
FROM [Datos Completos]; --Las fechas aparecerán en formato YYYY-MM-DD

/*
Podemos ver que tenemos ventas del 9 de Enero del 2022 al 17 de Julio del 2023, por lo que podemos
dividir las ventas del del Q1 de 2022 al Q3 de 2023. A continuación, se agruparán las ventas por 
trimestres y se mostrarán sus estadísticas de ventas
*/
WITH cte_trimesters AS (
SELECT *, 
       CASE
            WHEN [Date] BETWEEN '2022-01-01' AND '2022-03-31' THEN 'Q1-2022'
            WHEN [Date] BETWEEN '2022-04-01' AND '2022-06-30' THEN 'Q2-2022'
            WHEN [Date] BETWEEN '2022-07-01' AND '2022-09-30' THEN 'Q3-2022'
            WHEN [Date] BETWEEN '2022-10-01' AND '2022-12-31' THEN 'Q4-2022'
            WHEN [Date] BETWEEN '2023-01-01' AND '2023-03-31' THEN 'Q1-2023'
            WHEN [Date] BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Q2-2023'
            ELSE 'Q3-2023' END AS Trimester
FROM [Datos Completos]
)
SELECT [Trimester],
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM cte_trimesters
WHERE [Brand] IN ('VANISH','LYSOL')
GROUP BY Trimester
ORDER BY AVG(TotalValueSales) DESC;