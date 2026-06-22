
USE TPO_Comedores;
GO

CREATE OR ALTER PROCEDURE usp_Comedor_Insertar
    @Nombre     VARCHAR(100),
    @Direccion  VARCHAR(150),
    @Zona       VARCHAR(50),
    @Prioridad  VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Comedor (Nombre, Direccion, Zona, Prioridad)
    VALUES (@Nombre, @Direccion, @Zona, @Prioridad);

    SELECT SCOPE_IDENTITY() AS ID_Comedor_Generado;
END
GO

CREATE OR ALTER PROCEDURE usp_Comedor_Actualizar
    @ID_Comedor INT,
    @Nombre     VARCHAR(100),
    @Direccion  VARCHAR(150),
    @Zona       VARCHAR(50),
    @Prioridad  VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Comedor WHERE ID_Comedor = @ID_Comedor)
    BEGIN
        RAISERROR('No existe un Comedor con ID_Comedor = %d.', 16, 1, @ID_Comedor);
        RETURN;
    END

    UPDATE Comedor
    SET Nombre = @Nombre,
        Direccion = @Direccion,
        Zona = @Zona,
        Prioridad = @Prioridad
    WHERE ID_Comedor = @ID_Comedor;
END
GO

CREATE OR ALTER PROCEDURE usp_Afiliado_Eliminar
    @DNI INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Afiliado WHERE DNI = @DNI)
    BEGIN
        RAISERROR('No existe un Afiliado con DNI = %d.', 16, 1, @DNI);
        RETURN;
    END

    DELETE FROM Afiliado WHERE DNI = @DNI;
END
GO

CREATE OR ALTER PROCEDURE usp_Afiliado_Consultar
    @ID_Comedor INT = NULL  -- si es NULL, devuelve todos los afiliados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        a.DNI,
        a.Nombre,
        a.Apellido,
        a.Direccion,
        a.Telefono,
        a.Email,
        a.Fecha_Nacimiento,
        a.ID_Comedor,
        c.Nombre AS Nombre_Comedor
    FROM Afiliado a
    INNER JOIN Comedor c ON c.ID_Comedor = a.ID_Comedor
    WHERE @ID_Comedor IS NULL OR a.ID_Comedor = @ID_Comedor
    ORDER BY a.Apellido, a.Nombre;
END
GO

CREATE OR ALTER PROCEDURE usp_Voluntario_Insertar
    @DNI                INT,
    @Nombre             VARCHAR(50),
    @Apellido           VARCHAR(50),
    @Direccion          VARCHAR(150),
    @Telefono           VARCHAR(20) = NULL,
    @Email              VARCHAR(100) = NULL,
    @Fecha_Nacimiento   DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Voluntario WHERE DNI = @DNI)
    BEGIN
        RAISERROR('Ya existe un Voluntario con DNI = %d.', 16, 1, @DNI);
        RETURN;
    END

    INSERT INTO Voluntario (DNI, Nombre, Apellido, Direccion, Telefono, Email, Fecha_Nacimiento)
    VALUES (@DNI, @Nombre, @Apellido, @Direccion, @Telefono, @Email, @Fecha_Nacimiento);
END
GO

CREATE OR ALTER PROCEDURE usp_Voluntario_Eliminar
    @DNI INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Voluntario WHERE DNI = @DNI)
    BEGIN
        RAISERROR('No existe un Voluntario con DNI = %d.', 16, 1, @DNI);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Ayuda WHERE DNI_Voluntario = @DNI)
    BEGIN
        RAISERROR('No se puede eliminar: el Voluntario tiene comedores asignados en Ayuda.', 16, 1);
        RETURN;
    END

    DELETE FROM Voluntario WHERE DNI = @DNI;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_Actualizar
    @ID_Producto        INT,
    @Nombre             VARCHAR(100),
    @Unidad_de_Medida   VARCHAR(20),
    @Valor_de_Medida    DECIMAL(10,2),
    @Fecha_Vencimiento  DATE = NULL,
    @ID_Stock           INT = NULL,
    @ID_Delivery        INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE ID_Producto = @ID_Producto)
    BEGIN
        RAISERROR('No existe un Producto con ID_Producto = %d.', 16, 1, @ID_Producto);
        RETURN;
    END

    UPDATE Producto
    SET Nombre = @Nombre,
        Unidad_de_Medida = @Unidad_de_Medida,
        Valor_de_Medida = @Valor_de_Medida,
        Fecha_Vencimiento = @Fecha_Vencimiento,
        ID_Stock = @ID_Stock,
        ID_Delivery = @ID_Delivery
    WHERE ID_Producto = @ID_Producto;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_ConsultarProximosAVencer
    @Dias_Limite INT = 30  -- ventana de dias hacia adelante
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.ID_Producto,
        p.Nombre,
        p.Unidad_de_Medida,
        p.Valor_de_Medida,
        p.Fecha_Vencimiento,
        p.ID_Stock,
        p.ID_Delivery
    FROM Producto p
    WHERE p.Fecha_Vencimiento IS NOT NULL
      AND p.Fecha_Vencimiento <= DATEADD(DAY, @Dias_Limite, CAST(GETDATE() AS DATE))
    ORDER BY p.Fecha_Vencimiento ASC;
END
GO

CREATE OR ALTER PROCEDURE usp_Delivery_Insertar
    @Fecha      DATE,
    @ID_Comedor INT,
    @ID_Almacen INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Comedor WHERE ID_Comedor = @ID_Comedor)
    BEGIN
        RAISERROR('No existe un Comedor con ID_Comedor = %d.', 16, 1, @ID_Comedor);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Almacen WHERE ID_Almacen = @ID_Almacen)
    BEGIN
        RAISERROR('No existe un Almacen con ID_Almacen = %d.', 16, 1, @ID_Almacen);
        RETURN;
    END

    INSERT INTO Delivery (Fecha, ID_Comedor, ID_Almacen)
    VALUES (@Fecha, @ID_Comedor, @ID_Almacen);

    SELECT SCOPE_IDENTITY() AS ID_Delivery_Generado;
END
GO

CREATE OR ALTER PROCEDURE usp_Delivery_ConsultarPorComedor
    @ID_Comedor INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.ID_Delivery,
        d.Fecha,
        d.ID_Comedor,
        c.Nombre AS Nombre_Comedor,
        d.ID_Almacen,
        al.Nombre AS Nombre_Almacen
    FROM Delivery d
    INNER JOIN Comedor c ON c.ID_Comedor = d.ID_Comedor
    INNER JOIN Almacen al ON al.ID_Almacen = d.ID_Almacen
    WHERE d.ID_Comedor = @ID_Comedor
    ORDER BY d.Fecha DESC;
END
GO

CREATE OR ALTER PROCEDURE usp_Insertar_Donacion
    @DNI_Donante        INT,
    @Fecha              DATE,
    @Nombre             VARCHAR(100),
    @Unidad_de_Medida   VARCHAR(20),
    @Valor_de_Medida    DECIMAL(10,2),
    @Fecha_Vencimiento  DATE = NULL,
    @ID_Stock           INT = NULL,
    @ID_Delivery        INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Donante WHERE DNI = @DNI_Donante)
    BEGIN
        RAISERROR('No existe un Donante con DNI = %d.', 16, 1, @DNI_Donante);
        RETURN;
    END

    INSERT INTO Producto (Nombre, Unidad_de_Medida, Valor_de_Medida, Fecha_Vencimiento, ID_Stock, ID_Delivery)
    VALUES (@Nombre, @Unidad_de_Medida, @Valor_de_Medida, @Fecha_Vencimiento, @ID_Stock, @ID_Delivery);

    DECLARE @ID_Producto INT = SCOPE_IDENTITY();

    INSERT INTO Dona (ID_Producto, DNI_Donante, Fecha)
    VALUES (@ID_Producto, @DNI_Donante, @Fecha);

    SELECT @ID_Producto AS ID_Producto_Generado;
END
GO