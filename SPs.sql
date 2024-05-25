USE [ProyectoBD3]
GO
/****** Object:  StoredProcedure [dbo].[CargarXmlConfig]    Script Date: 5/25/2024 4:13:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargarXmlConfig] (@XMLData XML)
AS
BEGIN
	
	--TiposElemento
	INSERT INTO [dbo].[TiposElemento] (id,Nombre,IdTipoUnidad,EsFijo)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Nombre', 'VARCHAR(64)'),
		c.value('@IdTipoUnidad','INT'),
		c.value('@EsFijo','BIT')
	FROM @XMLData.nodes('/Data/TiposElemento/TipoElemento') as t(c)

	-- Insertar en la tabla TipoElementoFijo WHERE EsFijo = 1
	INSERT INTO [dbo].[TipoElementoFijo] (idTipoElemento, Valor)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Valor', 'INT')
	FROM @XMLData.nodes('/TiposElemento/TipoElemento') as t(c)
	WHERE c.value('@EsFijo', 'BIT') = 1;

	--TiposUnidad
	INSERT INTO [dbo].[TiposUnidad] (id, tipo)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Tipo', 'VARCHAR(64)')
	FROM @XMLData.nodes('/Data/TiposUnidades/TipoUnidad') as t(c)

	--TipoRelacionesFamiliar -- 
	INSERT INTO [dbo].[TipoRelacionesFamiliar] (id, Tipo)
	SELECT
		c.value('@Id', 'INT'),
		c.value('@Nombre', 'VARCHAR(64)')
	FROM @XMLData.nodes('/Data/TipoRelacionesFamiliar/TipoRelacionFamiliar') AS t(c)
	
	--TiposTarifa -- 
    INSERT INTO [dbo].[TiposTarifa] (id, Nombre)
    SELECT 
        c.value('@Id', 'INT'),
        c.value('@Nombre', 'VARCHAR(64)')
    FROM @XMLData.nodes('/Data/TiposTarifa/TipoTarifa') AS t(c);

	--ElementosDeTipoTarifa -- 
	INSERT INTO [dbo].[ElementosDeTipoTarifa] (idTipoTarifa, IdTipoElemento, valor)
	SELECT
		c.value('@idTipoTarifa', 'INT'),
		c.value('@IdTipoElemento','INT'),
		c.value('@Valor', 'INT')
	FROM @XMLData.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS t(c)

	--DELETE FROM TiposElemento
	--DBCC CHECKIDENT (TiposElemento, RESEED, 0);
	
	--DELETE FROM TipoElementoFijo
	--DBCC CHECKIDENT (TiposElemento, RESEED, 0);

	--DELETE FROM TiposUnidad
	--DBCC CHECKIDENT (TiposUnidad, RESEED, 0);

	--DELETE FROM TipoRelacionesFamiliar
	--DBCC CHECKIDENT (TipoRelacionesFamiliar, RESEED, 0);

	--DELETE FROM TiposTarifa
	--DBCC CHECKIDENT (TiposTarifa, RESEED, 0);

	--DELETE FROM ElementosDeTipoTarifa
	--DBCC CHECKIDENT (ElementosDeTipoTarifa, RESEED, 0);

	--DECLARE @datos XML 
	--SELECT @datos = CONVERT(XML, Bulkcolumn) 
	--FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\Config.xml', SINGLE_BLOB) AS x;

	--EXEC CargarXmlConfig @datos
END;
GO
/****** Object:  StoredProcedure [dbo].[CargarXmlDatos]    Script Date: 5/25/2024 4:13:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargarXmlDatos] (@XMLData XML)
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

	--DELETE FROM Contrato
	--DBCC CHECKIDENT (Contrato, RESEED, 0);
	
	--DELETE FROM Clientes
	--DBCC CHECKIDENT (Clientes, RESEED, 0);

	--DELETE FROM Detalles
	--DBCC CHECKIDENT (Detalles, RESEED, 0);

	--DELETE FROM Factura
	--DBCC CHECKIDENT (Factura, RESEED, 0);

	--DELETE FROM RelacionFamiliar
	--DBCC CHECKIDENT (RelacionFamiliar, RESEED, 0);

	--DELETE FROM LlamadaTelefonica
	--DBCC CHECKIDENT (LlamadaTelefonica, RESEED, 0);

	--DELETE FROM UsoDatos
	--DBCC CHECKIDENT (UsoDatos, RESEED, 0);
	
	--DELETE FROM RelacionFamiliar
	--DBCC CHECKIDENT (RelacionFamiliar, RESEED, 0);

	--DECLARE @datos XML 
	--SELECT @datos = CONVERT(XML, Bulkcolumn) 
	--FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\OperacionesMasivasFechasSql.xml', SINGLE_BLOB) AS x;

	--EXEC CargarXmlDatos @datos
END;
GO
/****** Object:  StoredProcedure [dbo].[PagarFactura]    Script Date: 5/25/2024 4:13:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PagarFactura]
(

	@inIdFactura INT
	,@outResultCode INT	

)
AS
BEGIN
	
	BEGIN TRY

		BEGIN TRANSACTION PagandoFactura

			UPDATE f
			SET f.Pagado = 1
			FROM Factura AS f
			WHERE f.id = @inIdFactura AND f.Pagado = 0
				
			SET @outResultCode = 0

		COMMIT TRANSACTION PagandoFactura
		
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION PagandoFactura
		
		SET @outResultCode = 50005

		INSERT INTO dbo.DBError (idTipoError,Fecha)
		VALUES (1,GETDATE())

	END CATCH

END
GO
