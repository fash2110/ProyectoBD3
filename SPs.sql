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
	SET NOCOUNT ON

	--Clientes
    INSERT INTO [dbo].[Clientes] (Nombre, Identificacion)
    SELECT 
        c.value('@Nombre', 'VARCHAR(64)'),
		c.value('@Identificacion', 'INT')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion/ClienteNuevo') AS t(c);

	--Contratos
	INSERT INTO [dbo].[Contrato] (Numero, idCliente, DocIdCliente, idTarifa, Fecha)
	SELECT
		c.value('@Numero', 'VARCHAR(64)'),
		Clientes.id,
		c.value('@DocIdCliente', 'INT'),
		c.value('@TipoTarifa', 'INT'),
		CAST(d.value('@fecha', 'NVARCHAR(32)') AS DATE)
	FROM @XMLData.nodes('/Operaciones/FechaOperacion') as r(d)
		CROSS APPLY d.nodes('NuevoContrato') AS t(c)
		left join Clientes on c.value('@DocIdCliente', 'INT') = Clientes.Identificacion
	
	--Llamadas
	INSERT INTO [dbo].[LlamadaTelefonica] (NumeroA, NumeroDe, Inicio, Final)
	SELECT
		c.value('@NumeroA', 'VARCHAR(64)'),
		c.value('@NumeroDe', 'VARCHAR(64)'),
		CAST(c.value('@Inicio', 'NVARCHAR(32)') AS DATETIME),
		CAST(c.value('@Final', 'NVARCHAR(32)') AS DATETIME)
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/LlamadaTelefonica') as t(c)

	--UsoDatos
	INSERT INTO [dbo].[UsoDatos] (Numero, QGigas)
	SELECT
		c.value('@Numero', 'VARCHAR(64)'),
		c.value('@QGigas','FLOAT')
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/UsoDatos') AS t(c)

	--TODO: generar facturas para poder pagarlas
	INSERT INTO Factura (Fecha, FechaPago, idContrato, TotalAntesIVA, TotalConIVA, TotalConPendiente, Pagado)
SELECT
	CAST(c.value('@fecha', 'VARCHAR(32)') AS DATE),
	DATEADD(MONTH, 1,  CAST(c.value('@fecha', 'VARCHAR(32)') AS DATE)),
	Contrato.id,
	0,
	0,
	0,
	0
	FROM @XMLData.nodes('/Operaciones/FechaOperacion') as t(c), Contrato
	WHERE
		DAY(CAST(c.value('@fecha', 'VARCHAR(32)') AS DATE)) =
		CASE 
		WHEN DAY(Contrato.Fecha) <= DAY(EOMONTH(CAST(c.value('@fecha', 'VARCHAR(32)') AS DATE))) THEN DAY(Contrato.Fecha)
		ELSE DAY(EOMONTH(CAST(c.value('@fecha', 'VARCHAR(32)') AS DATE)))
		END
		AND MONTH(Contrato.Fecha) <= MONTH(CAST(c.value('@fecha', 'VARCHAR(32)') AS DATE))

	--RelacionesFamiliar
	INSERT INTO [dbo].[RelacionFamiliar] (ClienteDe, ClienteA, idTipoRelacionesFamiliar)
	SELECT
		Cde.id,
		Ca.id,
		c.value('@TipoRelacion','INT')
	FROM @XMLData.nodes('/Operaciones/FechaOperacion/RelacionFamiliar') AS t(c)
		left join Clientes Cde on c.value('@DocIdDe', 'INT') = Cde.Identificacion
		left join CLientes Ca on c.value('@DocIdA', 'INT') = Ca.Identificacion

	SET NOCOUNT OFF
END;
GO;
-- ####################################################################
DELETE FROM Detalles
DELETE FROM Factura
DELETE FROM Contrato
DELETE FROM RelacionFamiliar
DELETE FROM Clientes
DELETE FROM LlamadaTelefonica
DELETE FROM UsoDatos

DBCC CHECKIDENT (Clientes, RESEED, 0);
DBCC CHECKIDENT (Contrato, RESEED, 0);
DBCC CHECKIDENT (LlamadaTelefonica, RESEED, 0);
DBCC CHECKIDENT (UsoDatos, RESEED, 0);
DBCC CHECKIDENT (RelacionFamiliar, RESEED, 0);
DBCC CHECKIDENT (Factura, RESEED, 0);


DECLARE @datos XML
SELECT @datos = CONVERT(XML, BulkColumn)
--cambiar ruta al archivo local
FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\operacionesMasivas.xml', SINGLE_BLOB) AS x;

EXEC CargarXmlDatos @datos
-- ####################################################################
GO;

SELECT * FROM Contrato