USE TPO_Comedores;
GO

CREATE OR ALTER VIEW vw_Inventario_Comedores AS
SELECT 
    c.ID_Comedor,
    c.Nombre AS Nombre_Comedor,
    c.Zona,
    c.Prioridad,
    p.ID_Producto,
    p.Nombre AS Nombre_Producto,
    p.Valor_de_Medida,
    p.Unidad_de_Medida,
    p.Fecha_Vencimiento
FROM Comedor c
INNER JOIN Stock s ON c.ID_Comedor = s.ID_Comedor
INNER JOIN Producto p ON s.ID_Stock = p.ID_Stock;
GO

CREATE OR ALTER VIEW vw_Historial_Donaciones AS
SELECT 
    d.Fecha AS Fecha_Donacion,
    don.DNI AS DNI_Donante,
    don.Nombre + ' ' + don.Apellido AS Nombre_Donante,
    don.Email AS Contacto_Donante,
    p.Nombre AS Producto_Donado,
    p.Valor_de_Medida,
    p.Unidad_de_Medida
FROM Dona d
INNER JOIN Donante don ON d.DNI_Donante = don.DNI
INNER JOIN Producto p ON d.ID_Producto = p.ID_Producto;
GO

CREATE OR ALTER VIEW vw_Control_Deliveries AS
SELECT 
    d.ID_Delivery,
    d.Fecha AS Fecha_Envio,
    al.ID_Almacen,
    al.Nombre AS Nombre_Almacen,
    c.ID_Comedor,
    c.Nombre AS Nombre_Comedor,
    c.Zona AS Zona_Comedor,
    c.Prioridad AS Prioridad_Comedor
FROM Delivery d
INNER JOIN Almacen al ON d.ID_Almacen = al.ID_Almacen
INNER JOIN Comedor c ON d.ID_Comedor = c.ID_Comedor;
GO

CREATE OR ALTER VIEW vw_Padron_Voluntarios AS
SELECT 
    v.DNI AS DNI_Voluntario,
    v.Nombre + ' ' + v.Apellido AS Nombre_Voluntario,
    dbo.FN_Calcular_Edad(v.Fecha_Nacimiento) AS Edad_Voluntario,
    v.Telefono,
    v.Email,
    c.ID_Comedor,
    c.Nombre AS Nombre_Comedor,
    c.Zona AS Zona_Comedor
FROM Voluntario v
INNER JOIN Ayuda ay ON v.DNI = ay.DNI_Voluntario
INNER JOIN Comedor c ON ay.ID_Comedor = c.ID_Comedor;
GO

CREATE OR ALTER VIEW vw_Productos_Por_Vencer AS
SELECT
    p.ID_Producto,
    p.Nombre AS Nombre_Producto,
    p.Unidad_de_Medida,
    p.Valor_de_Medida,
    p.Fecha_Vencimiento,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), p.Fecha_Vencimiento) AS Dias_Hasta_Vencimiento,
    p.ID_Stock,
    p.ID_Delivery
FROM Producto p
WHERE p.Fecha_Vencimiento IS NOT NULL
  AND p.Fecha_Vencimiento >= CAST(GETDATE() AS DATE)
  AND p.Fecha_Vencimiento <= DATEADD(MONTH, 2, CAST(GETDATE() AS DATE));
GO

CREATE OR ALTER VIEW vw_Cobertura_Por_Comedor AS
SELECT
    c.ID_Comedor,
    c.Nombre                                        AS Nombre_Comedor,
    c.Zona,
    c.Prioridad,
    COUNT(DISTINCT a.DNI)                           AS Cantidad_Afiliados,
    COUNT(DISTINCT ay.DNI_Voluntario)               AS Cantidad_Voluntarios,
    CASE
        WHEN COUNT(DISTINCT ay.DNI_Voluntario) = 0 THEN NULL
        ELSE CAST(COUNT(DISTINCT a.DNI) AS DECIMAL(10,2))
             / COUNT(DISTINCT ay.DNI_Voluntario)
    END                                             AS Ratio_Afiliados_Por_Voluntario,
    COUNT(DISTINCT d.ID_Delivery)                   AS Deliveries_Total,
    COUNT(DISTINCT CASE
        WHEN d.Fecha >= DATEADD(MONTH, -3, CAST(GETDATE() AS DATE))
        THEN d.ID_Delivery END)                     AS Deliveries_Ultimos_3_Meses,
    COUNT(DISTINCT p.ID_Producto)                   AS Productos_En_Stock
FROM Comedor c
LEFT JOIN Afiliado a    ON c.ID_Comedor = a.ID_Comedor
LEFT JOIN Ayuda ay      ON c.ID_Comedor = ay.ID_Comedor
LEFT JOIN Delivery d    ON c.ID_Comedor = d.ID_Comedor
LEFT JOIN Stock s       ON c.ID_Comedor = s.ID_Comedor
LEFT JOIN Producto p    ON s.ID_Stock   = p.ID_Stock
GROUP BY c.ID_Comedor, c.Nombre, c.Zona, c.Prioridad;
GO

CREATE OR ALTER VIEW vw_Impacto_Donaciones AS
SELECT
    YEAR(d.Fecha)                                   AS Anio,
    MONTH(d.Fecha)                                  AS Mes,
    DATEPART(QUARTER, d.Fecha)                      AS Trimestre,
    CASE
        WHEN YEAR(d.Fecha)  = YEAR(GETDATE())
         AND DATEPART(QUARTER, d.Fecha) = DATEPART(QUARTER, GETDATE())
        THEN 'Trimestre Actual'
        WHEN YEAR(d.Fecha)  = YEAR(DATEADD(QUARTER, -1, GETDATE()))
         AND DATEPART(QUARTER, d.Fecha) = DATEPART(QUARTER, DATEADD(QUARTER, -1, GETDATE()))
        THEN 'Trimestre Anterior'
        ELSE 'Historico'
    END                                             AS Periodo_Trimestral,
    p.ID_Producto,
    p.Nombre                                        AS Nombre_Producto,
    p.Unidad_de_Medida,
    COUNT(*)                                        AS Cantidad_Donaciones,
    COUNT(DISTINCT d.DNI_Donante)                   AS Donantes_Unicos,
    SUM(p.Valor_de_Medida)                          AS Volumen_Total_Donado
FROM Dona d
INNER JOIN Donante don  ON d.DNI_Donante = don.DNI
INNER JOIN Producto p   ON d.ID_Producto = p.ID_Producto
GROUP BY
    YEAR(d.Fecha), MONTH(d.Fecha), DATEPART(QUARTER, d.Fecha),
    p.ID_Producto, p.Nombre, p.Unidad_de_Medida;
GO

-- TRIGGERS
/* ============================================================================
   05_triggers.sql
   TPO - Sistema de Gestion de Comedores Publicos
   2 Triggers (CREATE OR ALTER TRIGGER)
   ----------------------------------------------------------------------------
   Trigger 1: TR_Producto_ValidarVencimiento
       - Evento: AFTER INSERT, UPDATE en Producto
       - Logica: impide registrar/actualizar un producto con una
         Fecha_Vencimiento anterior a la fecha actual (no se puede
         ingresar algo que ya esta vencido).

   Trigger 2: TR_Comedor_Auditoria
       - Evento: AFTER UPDATE en Comedor
       - Logica: cuando cambia la Prioridad de un comedor, registra el
         cambio (valor anterior, valor nuevo, fecha, usuario) en la
         tabla de auditoria Auditoria_Comedor.
         Esta tabla se crea aca porque es de soporte exclusivo del trigger.
   ============================================================================ */

USE TPO_Comedores;
GO

-- ============================================================================
-- Seccion 1: Tabla de soporte para el trigger de auditoria
-- ============================================================================
IF OBJECT_ID('dbo.Auditoria_Comedor', 'U') IS NULL
BEGIN
    CREATE TABLE Auditoria_Comedor (
        ID_Auditoria        INT IDENTITY(1,1) NOT NULL,
        ID_Comedor          INT               NOT NULL,
        Prioridad_Anterior  VARCHAR(10)       NOT NULL,
        Prioridad_Nueva     VARCHAR(10)       NOT NULL,
        Fecha_Cambio        DATETIME          NOT NULL DEFAULT GETDATE(),
        Usuario_BD          VARCHAR(100)      NOT NULL DEFAULT SUSER_SNAME(),
        CONSTRAINT PK_Auditoria_Comedor PRIMARY KEY (ID_Auditoria),
        CONSTRAINT FK_Auditoria_Comedor_Comedor FOREIGN KEY (ID_Comedor)
            REFERENCES Comedor (ID_Comedor)
    );
END
GO

-- ============================================================================
-- Seccion 2: Trigger 1 - Validacion de Fecha_Vencimiento en Producto
-- ============================================================================
CREATE OR ALTER TRIGGER TR_Producto_ValidarVencimiento
ON Producto
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Fecha_Vencimiento IS NOT NULL
          AND Fecha_Vencimiento < CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR('No se puede registrar/actualizar un Producto con Fecha_Vencimiento anterior a hoy.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- ============================================================================
-- Seccion 3: Trigger 2 - Auditoria de cambios de Prioridad en Comedor
-- ============================================================================
CREATE OR ALTER TRIGGER TR_Comedor_Auditoria
ON Comedor
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Prioridad)
    BEGIN
        INSERT INTO Auditoria_Comedor (ID_Comedor, Prioridad_Anterior, Prioridad_Nueva)
        SELECT
            i.ID_Comedor,
            d.Prioridad AS Prioridad_Anterior,
            i.Prioridad AS Prioridad_Nueva
        FROM inserted i
        INNER JOIN deleted d ON d.ID_Comedor = i.ID_Comedor
        WHERE i.Prioridad <> d.Prioridad;
    END
END
GO

-- ============================================================================
-- Seccion 4: Pruebas rapidas (comentadas, descomentar para probar)
-- ============================================================================
-- Prueba Trigger 1: deberia fallar por fecha de vencimiento pasada
-- INSERT INTO Producto (Nombre, Unidad_de_Medida, Valor_de_Medida, Fecha_Vencimiento)
-- VALUES ('Test Vencido', 'kg', 1.00, '2020-01-01');

-- Prueba Trigger 2: deberia generar una fila en Auditoria_Comedor
-- UPDATE Comedor SET Prioridad = 'Baja' WHERE ID_Comedor = 1;
-- SELECT * FROM Auditoria_Comedor;