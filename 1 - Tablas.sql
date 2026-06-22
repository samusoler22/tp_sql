/* ============================================================================
   01_tablas.sql
   TPO - Sistema de Gestion de Comedores Publicos
   Script de creacion de Base de Datos y Tablas (SQL Server)
   ----------------------------------------------------------------------------
   DECISIONES DE DISEÑO (3FN):
   - "Tiene" (Comedor 1:1 Stock): se modela con FK unica en Stock -> Comedor.
     No se fusiona Stock dentro de Comedor para no mezclar dos entidades
     conceptualmente distintas (datos del comedor vs. inventario).
   - "Almacena" (Stock 1:N Producto): FK ID_Stock en Producto (lado N).
   - "Envia" (Delivery 1:N Producto): FK ID_Delivery en Producto (lado N).
   - Ambas FK de Producto (ID_Stock, ID_Delivery) son NULL: un producto
     puede existir (recien ingresado a un Almacen via "Ingresa") antes de
     ser asignado a un Stock o despachado en un Delivery.
   - "Atiende" (Comedor 1:N Afiliado): FK ID_Comedor en Afiliado, NOT NULL.
   - "Suministra" (Comedor 1:N Delivery) y "Provee" (Almacen 1:N Delivery):
     ambas FK (ID_Comedor, ID_Almacen) viven en Delivery, NOT NULL.
   - "Ayuda", "Ingresa", "Dona": tablas intermedias N:N con PK compuesta.
     Ingresa y Dona incluyen el atributo Fecha del DER como parte de la PK,
     ya que un mismo Almacen/Producto o Producto/Donante puede repetirse
     en distintas fechas (reingresos / donaciones recurrentes).
   ============================================================================ */

-- ============================================================================
-- Seccion 0: Creacion idempotente de la base de datos
-- ============================================================================
USE master;
GO

CREATE DATABASE TPO_Comedores;
GO

USE TPO_Comedores;
GO

-- ============================================================================
-- Seccion 1: Tablas independientes (entidades fuertes, sin Foreign Keys)
-- ============================================================================

CREATE TABLE Comedor (
    ID_Comedor      INT IDENTITY(1,1)   NOT NULL,
    Nombre          VARCHAR(100)        NOT NULL,
    Direccion       VARCHAR(150)        NOT NULL,
    Zona            VARCHAR(50)         NOT NULL,
    Prioridad       VARCHAR(10)         NOT NULL,
    CONSTRAINT PK_Comedor PRIMARY KEY (ID_Comedor),
    CONSTRAINT CK_Comedor_Prioridad CHECK (Prioridad IN ('Alta','Media','Baja'))
);
GO

CREATE TABLE Almacen (
    ID_Almacen      INT IDENTITY(1,1)   NOT NULL,
    Nombre          VARCHAR(100)        NOT NULL,
    Direccion       VARCHAR(150)        NOT NULL,
    CONSTRAINT PK_Almacen PRIMARY KEY (ID_Almacen)
);
GO

CREATE TABLE Voluntario (
    DNI                 INT             NOT NULL,
    Nombre              VARCHAR(50)     NOT NULL,
    Apellido            VARCHAR(50)     NOT NULL,
    Direccion           VARCHAR(150)    NOT NULL,
    Telefono            VARCHAR(20)     NULL,
    Email               VARCHAR(100)    NULL,
    Fecha_Nacimiento    DATE            NOT NULL,
    CONSTRAINT PK_Voluntario PRIMARY KEY (DNI),
    CONSTRAINT CK_Voluntario_DNI CHECK (DNI > 0 AND DNI <= 99999999)
);
GO

CREATE TABLE Donante (
    DNI                 INT             NOT NULL,
    Nombre              VARCHAR(50)     NOT NULL,
    Apellido            VARCHAR(50)     NOT NULL,
    Direccion           VARCHAR(150)    NOT NULL,
    Telefono            VARCHAR(20)     NULL,
    Email               VARCHAR(100)    NULL,
    Fecha_Nacimiento    DATE            NOT NULL,
    CONSTRAINT PK_Donante PRIMARY KEY (DNI),
    CONSTRAINT CK_Donante_DNI CHECK (DNI > 0 AND DNI <= 99999999)
);
GO

-- ============================================================================
-- Seccion 2: Tablas con Foreign Key simple (relaciones 1:N)
-- ============================================================================

-- Afiliado:
CREATE TABLE Afiliado (
    DNI                 INT             NOT NULL,
    Nombre              VARCHAR(50)     NOT NULL,
    Apellido            VARCHAR(50)     NOT NULL,
    Direccion           VARCHAR(150)    NOT NULL,
    Telefono            VARCHAR(20)     NULL,
    Email               VARCHAR(100)    NULL,
    Fecha_Nacimiento    DATE            NOT NULL,
    ID_Comedor          INT             NOT NULL,
    CONSTRAINT PK_Afiliado PRIMARY KEY (DNI),
    CONSTRAINT CK_Afiliado_DNI CHECK (DNI > 0 AND DNI <= 99999999),
    CONSTRAINT FK_Afiliado_Comedor FOREIGN KEY (ID_Comedor)
        REFERENCES Comedor (ID_Comedor)
);
GO

-- Delivery
CREATE TABLE Delivery (
    ID_Delivery     INT IDENTITY(1,1)   NOT NULL,
    Fecha           DATE                NOT NULL,
    ID_Comedor      INT                 NOT NULL,
    ID_Almacen      INT                 NOT NULL,
    CONSTRAINT PK_Delivery PRIMARY KEY (ID_Delivery),
    CONSTRAINT FK_Delivery_Comedor FOREIGN KEY (ID_Comedor)
        REFERENCES Comedor (ID_Comedor),
    CONSTRAINT FK_Delivery_Almacen FOREIGN KEY (ID_Almacen)
        REFERENCES Almacen (ID_Almacen)
);
GO

-- ============================================================================
-- Seccion 3: Relacion 1:1
-- ============================================================================

CREATE TABLE Stock (
    ID_Stock    INT IDENTITY(1,1)   NOT NULL,
    ID_Comedor  INT                 NOT NULL,
    CONSTRAINT PK_Stock PRIMARY KEY (ID_Stock),
    CONSTRAINT FK_Stock_Comedor FOREIGN KEY (ID_Comedor)
        REFERENCES Comedor (ID_Comedor),
    CONSTRAINT UQ_Stock_Comedor UNIQUE (ID_Comedor)
);
GO

-- ============================================================================
-- Seccion 4: Tabla con multiples Foreign Keys
-- ============================================================================

-- Producto 
CREATE TABLE Producto (
    ID_Producto          INT IDENTITY(1,1)  NOT NULL,
    Nombre                VARCHAR(100)       NOT NULL,
    Unidad_de_Medida      VARCHAR(20)        NOT NULL,
    Valor_de_Medida       DECIMAL(10,2)      NOT NULL,
    Fecha_Vencimiento     DATE               NULL,
    ID_Stock              INT                NULL,
    ID_Delivery           INT                NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (ID_Producto),
    CONSTRAINT FK_Producto_Stock FOREIGN KEY (ID_Stock)
        REFERENCES Stock (ID_Stock),
    CONSTRAINT FK_Producto_Delivery FOREIGN KEY (ID_Delivery)
        REFERENCES Delivery (ID_Delivery)
);
GO

-- ============================================================================
-- Seccion 5: Tablas intermedias
-- ============================================================================

-- Ayuda
CREATE TABLE Ayuda (
    DNI_Voluntario  INT NOT NULL,
    ID_Comedor      INT NOT NULL,
    CONSTRAINT PK_Ayuda PRIMARY KEY (DNI_Voluntario, ID_Comedor),
    CONSTRAINT FK_Ayuda_Voluntario FOREIGN KEY (DNI_Voluntario)
        REFERENCES Voluntario (DNI),
    CONSTRAINT FK_Ayuda_Comedor FOREIGN KEY (ID_Comedor)
        REFERENCES Comedor (ID_Comedor)
);
GO

-- Ingresa
CREATE TABLE Ingresa (
    ID_Almacen  INT     NOT NULL,
    ID_Producto INT     NOT NULL,
    Fecha       DATE    NOT NULL,
    CONSTRAINT PK_Ingresa PRIMARY KEY (ID_Almacen, ID_Producto, Fecha),
    CONSTRAINT FK_Ingresa_Almacen FOREIGN KEY (ID_Almacen)
        REFERENCES Almacen (ID_Almacen),
    CONSTRAINT FK_Ingresa_Producto FOREIGN KEY (ID_Producto)
        REFERENCES Producto (ID_Producto)
);
GO

-- Dona
CREATE TABLE Dona (
    ID_Producto INT     NOT NULL,
    DNI_Donante INT     NOT NULL,
    Fecha       DATE    NOT NULL,
    CONSTRAINT PK_Dona PRIMARY KEY (ID_Producto, DNI_Donante, Fecha),
    CONSTRAINT FK_Dona_Producto FOREIGN KEY (ID_Producto)
        REFERENCES Producto (ID_Producto),
    CONSTRAINT FK_Dona_Donante FOREIGN KEY (DNI_Donante)
        REFERENCES Donante (DNI)


);



USE TPO_Comedores;
GO

CREATE OR ALTER FUNCTION dbo.FN_Calcular_Edad (@Fecha_Nacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Edad INT;

    SET @Edad = DATEDIFF(YEAR, @Fecha_Nacimiento, GETDATE())
        - CASE 
            WHEN (MONTH(@Fecha_Nacimiento) > MONTH(GETDATE()))
              OR (MONTH(@Fecha_Nacimiento) = MONTH(GETDATE()) AND DAY(@Fecha_Nacimiento) > DAY(GETDATE()))
            THEN 1 
            ELSE 0 
          END;

    RETURN @Edad;
END
