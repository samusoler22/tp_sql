
USE TPO_Comedores;
GO

INSERT INTO Comedor (Nombre, Direccion, Zona, Prioridad) VALUES
    ('Comedor San Martin',      'Av. San Martin 1200',       'Centro',       'Alta'),
    ('Comedor La Boca',         'Brandsen 805',              'Sur',          'Alta'),
    ('Comedor Belgrano',        'Monroe 2450',               'Norte',        'Media'),
    ('Comedor Flores',          'Av. Rivadavia 7200',        'Oeste',        'Media'),
    ('Comedor Villa Devoto',    'Av. Lope de Vega 3200',     'Oeste',        'Baja'),
    ('Comedor Palermo',         'Honduras 5200',             'Centro',       'Media'),
    ('Comedor Barracas',        'Suarez 1600',               'Sur',          'Alta'),
    ('Comedor Caballito',       'Av. Directorio 1200',       'Centro',       'Media'),
    ('Comedor Nunez',           'Av. del Libertador 7800',   'Norte',        'Baja'),
    ('Comedor Mataderos',       'Av. Lisandro de la Torre 4800', 'Oeste',  'Alta');
GO

INSERT INTO Almacen (Nombre, Direccion) VALUES
    ('Almacen Central',         'Av. Corrientes 3500'),
    ('Deposito Norte',          'Parana 4500'),
    ('Deposito Sur',            'Av. Juan B. Justo 8000'),
    ('Deposito Oeste',          'Rivadavia 11000'),
    ('Centro Logistico CABA',   'Cochabamba 7800'),
    ('Deposito Belgrano',       'Cabildo 2100'),
    ('Deposito La Boca',        'Suarez 2400'),
    ('Deposito Flores',         'Av. San Pedrito 3500'),
    ('Deposito Palermo',        'Cordoba 5200'),
    ('Deposito Barracas',       'Av. Montes de Oca 1800');
GO

INSERT INTO Voluntario (DNI, Nombre, Apellido, Direccion, Telefono, Email, Fecha_Nacimiento) VALUES
    (30123456, 'Lucia',    'Gomez',      'Av. Cabildo 1200',       '1155667788', 'lucia.gomez@gmail.com',      '1995-03-15'),
    (31234567, 'Martin',   'Perez',      'Thames 450',             '1144556677', 'martin.perez@gmail.com',     '1988-07-22'),
    (32345678, 'Carla',    'Rodriguez',  'Av. Santa Fe 2800',      '1133445566', 'carla.rodriguez@gmail.com',  '1992-11-08'),
    (33456789, 'Diego',    'Fernandez',  'Corrientes 5100',        '1122334455', 'diego.fernandez@gmail.com',  '1990-01-30'),
    (34567890, 'Sofia',    'Lopez',      'Av. Rivadavia 6400',     '1111223344', 'sofia.lopez@gmail.com',      '1998-05-12'),
    (35678901, 'Andres',   'Martinez',   'Honduras 4100',          '1199887766', 'andres.martinez@gmail.com',  '1985-09-25'),
    (36789012, 'Valentina','Sanchez',    'Av. Directorio 900',     '1188776655', 'valentina.sanchez@gmail.com','1993-12-03'),
    (37890123, 'Facundo',  'Romero',     'Brandsen 1200',          '1177665544', 'facundo.romero@gmail.com',   '1991-06-18'),
    (38901234, 'Camila',   'Torres',     'Monroe 3100',            '1166554433', 'camila.torres@gmail.com',    '1996-08-07'),
    (39012345, 'Nicolas',  'Diaz',       'Av. del Libertador 6200','1155443322', 'nicolas.diaz@gmail.com',     '1987-04-28');
GO

INSERT INTO Donante (DNI, Nombre, Apellido, Direccion, Telefono, Email, Fecha_Nacimiento) VALUES
    (20123456, 'Roberto',  'Alvarez',    'Av. Callao 800',         '1144332211', 'roberto.alvarez@gmail.com',  '1975-02-14'),
    (21234567, 'Elena',    'Molina',     'Scalabrini Ortiz 1200',  '1133221100', 'elena.molina@gmail.com',     '1980-10-05'),
    (22345678, 'Jorge',    'Castro',     'Av. Pueyrredon 900',     '1122110099', 'jorge.castro@gmail.com',     '1978-07-19'),
    (23456789, 'Patricia', 'Ruiz',       'Av. Las Heras 2200',     '1111009988', 'patricia.ruiz@gmail.com',    '1982-03-27'),
    (24567890, 'Hector',   'Vega',       'Av. San Juan 3500',      '1199008877', 'hector.vega@gmail.com',      '1970-11-11'),
    (25678901, 'Monica',   'Herrera',    'Av. Cramer 1800',        '1188997766', 'monica.herrera@gmail.com',   '1988-06-02'),
    (26789012, 'Oscar',    'Mendoza',    'Av. Boedo 1400',         '1177886655', 'oscar.mendoza@gmail.com',    '1973-09-16'),
    (27890123, 'Silvia',   'Navarro',    'Av. Entre Rios 1100',    '1166775544', 'silvia.navarro@gmail.com',   '1985-01-23'),
    (28901234, 'Ricardo',  'Silva',      'Av. Medrano 900',        '1155664433', 'ricardo.silva@gmail.com',    '1979-12-30'),
    (29012345, 'Gabriela', 'Morales',    'Av. Independencia 2800', '1144553322', 'gabriela.morales@gmail.com', '1981-08-09');
GO

INSERT INTO Afiliado (DNI, Nombre, Apellido, Direccion, Telefono, Email, Fecha_Nacimiento, ID_Comedor) VALUES
    (40123456, 'Juan',     'Acosta',     'Av. San Martin 500',       '1155112233', 'juan.acosta@gmail.com',      '1960-04-10', 1),
    (41234567, 'Maria',    'Benitez',    'Brandsen 300',             '1144223344', 'maria.benitez@gmail.com',    '1955-08-21', 2),
    (42345678, 'Pedro',    'Cabrera',    'Monroe 1800',              '1135334455', 'pedro.cabrera@gmail.com',    '1965-12-05', 3),
    (43456789, 'Ana',      'Dominguez',  'Av. Rivadavia 7100',       '1126445566', 'ana.dominguez@gmail.com',    '1958-02-18', 4),
    (44567890, 'Luis',     'Espinoza',   'Av. Lope de Vega 3100',    '1117556677', 'luis.espinoza@gmail.com',    '1970-06-30', 5),
    (45678901, 'Rosa',     'Fuentes',    'Honduras 5000',            '1108667788', 'rosa.fuentes@gmail.com',     '1962-09-14', 6),
    (46789012, 'Carlos',   'Gimenez',    'Suarez 1400',              '1199778899', 'carlos.gimenez@gmail.com',   '1950-11-25', 7),
    (47890123, 'Laura',    'Ibarra',     'Av. Directorio 1100',      '1180889900', 'laura.ibarra@gmail.com',     '1968-03-08', 8),
    (48901234, 'Miguel',   'Juarez',     'Av. del Libertador 7700',  '1171990011', 'miguel.juarez@gmail.com',    '1953-07-17', 9),
    (49012345, 'Claudia',  'Klein',      'Av. Lisandro de la Torre 4700', '1162001122', 'claudia.klein@gmail.com', '1963-10-29', 10);
GO

INSERT INTO Delivery (Fecha, ID_Comedor, ID_Almacen) VALUES
    ('2025-01-10', 1,  1),
    ('2025-01-15', 2,  7),
    ('2025-02-01', 3,  6),
    ('2025-02-10', 4,  8),
    ('2025-02-20', 5,  4),
    ('2025-03-05', 6,  9),
    ('2025-03-12', 7, 10),
    ('2025-03-18', 8,  5),
    ('2025-03-25', 9,  2),
    ('2025-04-02', 10, 3);
GO

INSERT INTO Stock (ID_Comedor) VALUES
    (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
GO

INSERT INTO Producto (Nombre, Unidad_de_Medida, Valor_de_Medida, Fecha_Vencimiento, ID_Stock, ID_Delivery) VALUES
    ('Arroz',            'Kg',   25.00,  '2026-06-30', NULL, NULL),
    ('Fideos',           'Kg',   10.00,  '2026-08-15', NULL, NULL),
    ('Aceite de girasol','Litro', 5.00, '2026-12-01', NULL, NULL),
    ('Lentejas',         'Kg',   15.00,  '2026-05-20', 1,    NULL),
    ('Harina',           'Kg',   20.00,  '2026-04-10', 2,    NULL),
    ('Azucar',           'Kg',   12.00,  '2026-09-05', 3,    NULL),
    ('Leche en polvo',   'Kg',   8.00,   '2026-07-22', NULL, 1),
    ('Atun en lata',     'Unidad', 24.00,'2027-01-15', NULL, 2),
    ('Polenta',          'Kg',   18.00,  '2026-10-30', 4,    3),
    ('Garbanzos',        'Kg',   14.00,  '2026-11-18', 5,    4);
GO


INSERT INTO Ayuda (DNI_Voluntario, ID_Comedor) VALUES
    (30123456, 1),
    (31234567, 2),
    (32345678, 3),
    (33456789, 4),
    (34567890, 5),
    (35678901, 6),
    (36789012, 7),
    (37890123, 8),
    (38901234, 9),
    (39012345, 10);
GO

INSERT INTO Ingresa (ID_Almacen, ID_Producto, Fecha) VALUES
    (1, 1, '2025-01-05'),
    (1, 2, '2025-01-06'),
    (2, 3, '2025-01-08'),
    (3, 4, '2025-01-10'),
    (4, 5, '2025-01-12'),
    (5, 6, '2025-01-14'),
    (6, 7, '2025-01-16'),
    (7, 8, '2025-01-18'),
    (8, 9, '2025-01-20'),
    (9, 10, '2025-01-22');
GO

INSERT INTO Dona (ID_Producto, DNI_Donante, Fecha) VALUES
    (1, 20123456, '2025-01-07'),
    (2, 21234567, '2025-01-09'),
    (3, 22345678, '2025-01-11'),
    (4, 23456789, '2025-01-13'),
    (5, 24567890, '2025-01-15'),
    (6, 25678901, '2025-01-17'),
    (7, 26789012, '2025-01-19'),
    (8, 27890123, '2025-01-21'),
    (9, 28901234, '2025-01-23'),
    (10, 29012345, '2025-01-25');
GO
