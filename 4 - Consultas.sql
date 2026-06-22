USE TPO_Comedores;
GO


-- CONSULTA 1: Lista de todos los afiliados con el nombre del comedor al que asisten (INNER JOIN básico)
SELECT 
    a.DNI, 
    a.Nombre AS Nombre_Afiliado, 
    a.Apellido AS Apellido_Afiliado, 
    c.Nombre AS Nombre_Comedor
FROM Afiliado a
INNER JOIN Comedor c ON a.ID_Comedor = c.ID_Comedor;


-- CONSULTA 2: Cantidad de afiliados registrados en cada comedor (Función de agregado COUNT + GROUP BY)
SELECT 
    c.Nombre AS Comedor, 
    COUNT(a.DNI) AS Cantidad_Afiliados
FROM Comedor c
LEFT JOIN Afiliado a ON c.ID_Comedor = a.ID_Comedor
GROUP BY c.Nombre;


-- CONSULTA 3: Voluntarios que ayudan en comedores de prioridad "Alta" (Múltiples JOINs)
SELECT DISTINCT 
    v.DNI, 
    v.Nombre, 
    v.Apellido, 
    c.Nombre AS Comedor_Asignado,
    c.Prioridad
FROM Voluntario v
INNER JOIN Ayuda ay ON v.DNI = ay.DNI_Voluntario
INNER JOIN Comedor c ON ay.ID_Comedor = c.ID_Comedor
WHERE c.Prioridad = 'Alta';


-- CONSULTA 4: Cantidad de productos donados agrupados por su unidad de medida (Filtro por agregación)
SELECT 
    p.Unidad_de_Medida, 
    COUNT(p.ID_Producto) AS Total_Productos
FROM Producto p
INNER JOIN Dona d ON p.ID_Producto = d.ID_Producto
GROUP BY p.Unidad_de_Medida;


-- CONSULTA 5: Top 3 de donantes que más veces han realizado donaciones (Cláusula TOP + ORDER BY)
SELECT TOP 3 
    do.DNI, 
    do.Nombre, 
    do.Apellido, 
    COUNT(d.ID_Producto) AS Cantidad_Donaciones
FROM Donante do
INNER JOIN Dona d ON do.DNI = d.DNI_Donante
GROUP BY do.DNI, do.Nombre, do.Apellido
ORDER BY Cantidad_Donaciones DESC;


-- CONSULTA 6: Productos que ingresaron a los almacenes durante el año actual (Uso de funciones de fecha)
SELECT 
    a.Nombre AS Almacen, 
    p.Nombre AS Producto, 
    i.Fecha AS Fecha_Ingreso
FROM Almacen a
INNER JOIN Ingresa i ON a.ID_Almacen = i.ID_Almacen
INNER JOIN Producto p ON i.ID_Producto = p.ID_Producto
WHERE YEAR(i.Fecha) = YEAR(GETDATE());


-- CONSULTA 7: Comedores que no tienen asignado ningún delivery (Uso de LEFT JOIN para encontrar nulos)
SELECT 
    c.ID_Comedor, 
    c.Nombre AS Comedor_Sin_Suministro, 
    c.Zona
FROM Comedor c
LEFT JOIN Delivery d ON c.ID_Comedor = d.ID_Comedor  -- Relación Suministra
WHERE d.ID_Delivery IS NULL;


-- CONSULTA 8: Promedio del valor de medida de los productos almacenados (Función de agregado AVG)
SELECT 
    p.Unidad_de_Medida, 
    AVG(p.Valor_de_Medida) AS Promedio_Medida
FROM Producto p
GROUP BY p.Unidad_de_Medida;


-- CONSULTA 9: 

SELECT 
    CASE 
        WHEN dbo.FN_Calcular_Edad(Fecha_Nacimiento) < 25 THEN 'Joven (menos de 25)'
        WHEN dbo.FN_Calcular_Edad(Fecha_Nacimiento) BETWEEN 25 AND 40 THEN 'Adulto (25 a 40)'
        ELSE 'Mayor (más de 40)'
    END AS Rango_Edad,
    COUNT(*) AS Cantidad_Voluntarios,
    AVG(dbo.FN_Calcular_Edad(Fecha_Nacimiento)) AS Edad_Promedio
FROM Voluntario
GROUP BY 
    CASE 
        WHEN dbo.FN_Calcular_Edad(Fecha_Nacimiento) < 25 THEN 'Joven (menos de 25)'
        WHEN dbo.FN_Calcular_Edad(Fecha_Nacimiento) BETWEEN 25 AND 40 THEN 'Adulto (25 a 40)'
        ELSE 'Mayor (más de 40)'
    END
ORDER BY Edad_Promedio DESC;



-- CONSULTA 10: SUBCONSULTA COMPLEJA - Comedores ubicados en zonas que tienen más de 2 comedores registrados
SELECT 
    ID_Comedor, 
    Nombre, 
    Zona, 
    Prioridad
FROM Comedor
WHERE Zona IN (
    SELECT Zona 
    FROM Comedor 
    GROUP BY Zona 
    HAVING COUNT(ID_Comedor) > 2
);
GO
