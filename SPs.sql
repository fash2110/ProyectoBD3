USE [ProyectoBD3]
GO;
CREATE PROCEDURE [dbo].[CargarXmlConfig] (@XMLData XML)
AS
BEGIN
	--TiposTarifa
    INSERT INTO [dbo].[TiposTarifa] (id, Nombre)
    SELECT 
        c.value('@Id', 'INT'),
        c.value('@Nombre', 'VARCHAR(64)')
    FROM @XMLData.nodes('/Data/TiposTarifa/TipoTarifa') AS t(c);

	--TiposElemento
	INSERT INTO [dbo].[TiposElemento] (id, Nombre)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Nombre', 'VARCHAR(64)')
	FROM @XMLData.nodes('/Data/TiposElemento/TipoElemento') as t(c)

	--TiposUnidad
	INSERT INTO [dbo].[TiposUnidad] (id, tipo)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Tipo', 'VARCHAR(64)')
	FROM @XMLData.nodes('/Data/TiposUnidades/TipoUnidad') as t(c)

	--ElementosDeTipoTarifa
	INSERT INTO [dbo].[ElementosDeTipoTarifa] (idTipoTarifa, IdTipoElemento, valor, IdTipoUnidad)
	SELECT
		c.value('@idTipoTarifa', 'INT'),
		c.value('@IdTipoElemento','INT'),
		c.value('@Valor', 'INT'),
		c.value('@IdTipoUnidad', 'INT')
	FROM @XMLData.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS t(c)

	--TipoRelacionesFamiliar
	INSERT INTO [dbo].[TipoRelacionesFamiliar] (id, Tipo)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Nombre', 'VARCHAR(64)')
	FROM @XMLData.nodes('/Data/TipoRelacionesFamiliar/TipoRelacionFamiliar') AS t(c)
END;
GO;

-- ####################################################################
DECLARE @datos XML
SELECT @datos = CONVERT(XML, BulkColumn)
--cambiar ruta al archivo local
FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\config.xml', SINGLE_BLOB) AS x;

EXEC CargarXmlConfig @datos
GO;
-- ####################################################################

ALTER PROCEDURE [dbo].[CargarXmlDatos] (@XMLData XML)
AS
BEGIN
	--Clientes
    INSERT INTO [dbo].[Clientes] (Nombre, Identificacion)
    SELECT 
        c.value('@Nombre', 'VARCHAR(64)'),
		c.value('@Identificacion', 'INT')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion/ClienteNuevo') AS t(c);

	--Contratos
	INSERT INTO [dbo].[Contrato] (Numero, idCliente, DocIdCliente, idTarifa)
	SELECT
		c.value('@Numero', 'VARCHAR(64)'),
		Clientes.id,
		c.value('@DocIdCliente', 'INT'),
		c.value('@TipoTarifa', 'INT')
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/NuevoContrato') as t(c)
		left join Clientes on c.value('@DocIdCliente', 'INT') = Clientes.Identificacion

	--Llamadas
	INSERT INTO [dbo].[LlamadaTelefonica] (NumeroA, NumeroDe, Inicio, Final, idDetalles)
	SELECT
		c.value('@NumeroA', 'VARCHAR(64)'),
		c.value('@NumeroDe', 'VARCHAR(64)'),
		CAST(c.value('@Inicio', 'NVARCHAR(32)') AS DATETIME),
		CAST(c.value('@Final', 'NVARCHAR(32)') AS DATETIME),
		NULL
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/LlamadaTelefonica') as t(c)

	--UsoDatos
	INSERT INTO [dbo].[UsoDatos] (Numero, QGigas, idDetalles)
	SELECT
		c.value('@Numero', 'VARCHAR(64)'),
		c.value('@QGigas','FLOAT'),
		NULL
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/UsoDatos') AS t(c)

	--TODO: generar facturas para poder pagarlas

	--TipoRelacionesFamiliar
	INSERT INTO [dbo].[RelacionFamiliar] (ClienteDe, ClienteA, idTipoRelacionesFamiliar)
	SELECT
		Cde.id,
		Ca.id,
		c.value('@TipoRelacion','INT')
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/RelacionFamiliar') AS t(c)
		left join Clientes Cde on c.value('@DocIdDe', 'INT') = Cde.Identificacion
		left join CLientes Ca on c.value('@DocIdA', 'INT') = Ca.Identificacion
END;
GO;
-- ####################################################################
DELETE FROM Clientes
DELETE FROM Contrato
DELETE FROM LlamadaTelefonica
DELETE FROM UsoDatos
DELETE FROM RelacionFamiliar

DBCC CHECKIDENT (Clientes, RESEED, 0);
DBCC CHECKIDENT (Contrato, RESEED, 0);
DBCC CHECKIDENT (LlamadaTelefonica, RESEED, 0);
DBCC CHECKIDENT (UsoDatos, RESEED, 0);
DBCC CHECKIDENT (RelacionFamiliar, RESEED, 0);


DECLARE @datos XML
SELECT @datos = CONVERT(XML, BulkColumn)
--cambiar ruta al archivo local
FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\operacionesMasivas.xml', SINGLE_BLOB) AS x;

EXEC CargarXmlDatos @datos
-- ####################################################################
GO;