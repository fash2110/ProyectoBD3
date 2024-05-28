USE [ProyectoBD3]
GO
/****** Object:  StoredProcedure [dbo].[CargarXmlConfig]    Script Date: 5/28/2024 3:21:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargarXmlConfig] (@XMLData XML)
AS
BEGIN
    -- Insertar en TiposUnidad primero
    INSERT INTO [dbo].[TiposUnidad] (id, tipo)
    SELECT
        c.value('@Id', 'INT'),
        c.value('@Tipo', 'VARCHAR(64)')
    FROM @XMLData.nodes('/Data/TiposUnidades/TipoUnidad') as t(c);

    -- Insertar en TiposElemento después de TiposUnidad
    INSERT INTO [dbo].[TiposElemento] (id, Nombre, IdTipoUnidad, EsFijo)
    SELECT
        c.value('@Id', 'INT'),
        c.value('@Nombre', 'VARCHAR(64)'),
        c.value('@IdTipoUnidad','INT'),
        c.value('@EsFijo','BIT')
    FROM @XMLData.nodes('/Data/TiposElemento/TipoElemento') as t(c);

    -- Insertar en TipoElementoFijo después de TiposElemento
    INSERT INTO [dbo].[TipoElementoFijo] (idTipoElemento, Valor)
    SELECT
        c.value('@Id', 'INT'),
        c.value('@Valor', 'INT')
    FROM @XMLData.nodes('/Data/TiposElemento/TipoElemento') as t(c)
    WHERE c.value('@EsFijo', 'BIT') = 1;

    -- Insertar en TiposTarifa después de TiposElemento
    INSERT INTO [dbo].[TiposTarifa] (id, Nombre)
    SELECT 
        c.value('@Id', 'INT'),
        c.value('@Nombre', 'VARCHAR(64)')
    FROM @XMLData.nodes('/Data/TiposTarifa/TipoTarifa') AS t(c);

    -- Insertar en TipoRelacionesFamiliar después de TiposElemento
    INSERT INTO [dbo].[TipoRelacionesFamiliar] (id, Tipo)
    SELECT
        c.value('@Id', 'INT'),
        c.value('@Nombre', 'VARCHAR(64)')
    FROM @XMLData.nodes('/Data/TipoRelacionesFamiliar/TipoRelacionFamiliar') AS t(c);

    -- Insertar en ElementosDeTipoTarifa al final
    INSERT INTO [dbo].[ElementosDeTipoTarifa] (idTipoTarifa, IdTipoElemento, valor)
    SELECT
        c.value('@idTipoTarifa', 'INT'),
        c.value('@IdTipoElemento','INT'),
        c.value('@Valor', 'INT')
    FROM @XMLData.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS t(c);

	--DELETE FROM ElementosDeTipoTarifa
	--DBCC CHECKIDENT (ElementosDeTipoTarifa, RESEED, 0);
	--DELETE FROM TiposElemento	
	--DBCC CHECKIDENT (TiposElemento, RESEED, 0);
	--DELETE FROM TipoElementoFijo
	--DBCC CHECKIDENT (TipoElementoFijo, RESEED, 0);
	--DELETE FROM TiposUnidad
	--DBCC CHECKIDENT (TiposUnidad, RESEED, 0);
	--DELETE FROM TipoRelacionesFamiliar
	--DBCC CHECKIDENT (TipoRelacionesFamiliar, RESEED, 0);
	--DELETE FROM TiposTarifa
	--DBCC CHECKIDENT (TiposTarifa, RESEED, 0);

	--DECLARE @datos XML 
	--SELECT @datos = CONVERT(XML, Bulkcolumn) 
	--FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\Config.xml', SINGLE_BLOB) AS x;

	--EXEC CargarXmlConfig @datos
END;
GO
/****** Object:  StoredProcedure [dbo].[CargarXmlDatos]    Script Date: 5/28/2024 3:21:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargarXmlDatos] (@XMLData XML)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @fecha DATE 

	IF CURSOR_STATUS('global', 'crsr') >= -1
    BEGIN
        CLOSE crsr;
        DEALLOCATE crsr;
    END

	--Cursor itera por la tabla de fechas, para insertar los datos individualmente por fecha
	DECLARE crsr CURSOR FOR
	SELECT c.value('@fecha', 'VARCHAR(16)') FROM @XMLData.nodes('/Operaciones/FechaOperacion') as t(c);
	OPEN crsr;
	PRINT 'crsr open'
	FETCH NEXT FROM crsr INTO @fecha
	
	DECLARE @varDatos TABLE (
        Fecha DATE,
        Nombre VARCHAR(64) NULL,
        Identificacion INT NULL,
        Numero VARCHAR(64) NULL,
        DocIdCliente INT NULL,
        TipoTarifa INT NULL,
        NumeroDe VARCHAR(64) NULL,
        NumeroA VARCHAR(64) NULL,
        Inicio DATETIME NULL,
        Final DATETIME NULL,
        QGigas FLOAT NULL,
        DocIdDe INT NULL,
        DocIdA INT NULL,
        TipoRelacion INT NULL
    );

    -- Insert ClienteNuevo data
    INSERT INTO @varDatos (Fecha, Nombre, Identificacion)
    SELECT 
        c.value('@fecha', 'DATE'),
        d.value('@Nombre', 'VARCHAR(64)'),
        d.value('@Identificacion', 'INT')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion') AS T(c) 
    CROSS APPLY c.nodes('ClienteNuevo') AS U(d);

    -- Insert NuevoContrato data
    INSERT INTO @varDatos (Fecha, Numero, DocIdCliente, TipoTarifa)
    SELECT 
        c.value('@fecha', 'DATE'),
        d.value('@Numero', 'VARCHAR(64)'),
        d.value('@DocIdCliente', 'INT'),
        d.value('@TipoTarifa', 'INT')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion') AS T(c) 
    CROSS APPLY c.nodes('NuevoContrato') AS U(d);

    -- Insert RelacionFamiliar data
    INSERT INTO @varDatos (Fecha, DocIdDe, DocIdA, TipoRelacion)
    SELECT 
        c.value('@fecha', 'DATE'),
        d.value('@DocIdDe', 'INT'),
        d.value('@DocIdA', 'INT'),
        d.value('@TipoRelacion', 'INT')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion') AS T(c) 
    CROSS APPLY c.nodes('RelacionFamiliar') AS U(d);

    -- Insert LlamadaTelefonica data
    INSERT INTO @varDatos (Fecha, NumeroDe, NumeroA, Inicio, Final)
    SELECT 
        c.value('@fecha', 'DATE'),
        d.value('@NumeroDe', 'VARCHAR(64)'),
        d.value('@NumeroA', 'VARCHAR(64)'),
        d.value('@Inicio', 'DATETIME'),
        d.value('@Final', 'DATETIME')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion') AS T(c) 
    CROSS APPLY c.nodes('LlamadaTelefonica') AS U(d);

    -- Insert UsoDatos data
    INSERT INTO @varDatos (Fecha, Numero, QGigas)
    SELECT 
        c.value('@fecha', 'DATE'),
        d.value('@Numero', 'VARCHAR(64)'),
        d.value('@QGigas', 'FLOAT')
    FROM @XMLData.nodes('/Operaciones/FechaOperacion') AS T(c) 
    CROSS APPLY c.nodes('UsoDatos') AS U(d);


	BEGIN TRAN
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @fecha
		 
		--Clientes
		INSERT INTO dbo.Clientes (Nombre, Identificacion)
		SELECT DISTINCT
			d.Nombre, 
			d.Identificacion
		FROM @varDatos d
		left join Clientes on d.Identificacion = Clientes.Identificacion
		WHERE d.Fecha = @fecha
			AND d.Nombre IS NOT NULL
			AND d.Identificacion IS NOT NULL
			AND Clientes.Identificacion IS NULL --inserta unicamente si no existe

		--Contratos
		INSERT INTO dbo.Contrato (Numero, DocIdCliente, idCliente, idTarifa, Fecha)
		SELECT
			d.Numero,
			d.DocIdCliente,
			Clientes.id,
			d.TipoTarifa,
			@fecha
		FROM @varDatos d
		left join Clientes on d.DocIdCliente = Clientes.Identificacion
		WHERE d.Fecha = @fecha 
			AND d.Numero IS NOT NULL
			AND d.DocIdCliente IS NOT NULL
			AND d.TipoTarifa IS NOT NULL
		
		--RelacionesFamiliar
		INSERT INTO dbo.RelacionFamiliar (ClienteDe, ClienteA, idTipoRelacionesFamiliar)
		SELECT
			CDe.id,
			CA.id,
			d.TipoRelacion
		FROM @varDatos d
		left join Clientes CDe on d.DocIdDe = CDe.Identificacion
		left join Clientes CA on d.DocIdA = CA.Identificacion
		WHERE d.Fecha = @fecha 
			AND d.DocIdDe IS NOT NULL
			AND d.DocIdA IS NOT NULL
			AND d.TipoRelacion IS NOT NULL

		--Llamadas
		INSERT INTO dbo.LlamadaTelefonica (NumeroDe, NumeroA, Inicio, Final)
		SELECT
			d.NumeroDe,
			d.NumeroA,
			d.Inicio,
			d.Final
		FROM @varDatos d
		WHERE d.Fecha = @fecha 
			AND d.NumeroDe IS NOT NULL
			AND d.NumeroA IS NOT NULL
			AND d.Inicio IS NOT NULL
			AND d.Final IS NOT NULL

		--UsoDatos
		INSERT INTO dbo.UsoDatos (Numero, QGigas)
		SELECT
			d.Numero,
			d.QGigas
		FROM @varDatos d
		WHERE d.Fecha = @fecha 
			AND d.Numero IS NOT NULL
			AND d.QGigas IS NOT NULL

		--AbrirFacturas
		INSERT INTO dbo.Factura (Fecha, FechaPago, idContrato, TotalAntesIVA, TotalConIVA, TotalConPendiente, Pagado)
		SELECT
			@fecha,
			DATEADD(MONTH, 1, @fecha),
			Contrato.id,
			0,
			0,
			0,
			0
		FROM dbo.Contrato 
		WHERE Contrato.Fecha = @fecha

		FETCH NEXT FROM crsr INTO @fecha
	END
	
	COMMIT TRAN

	PRINT 'END'
	CLOSE crsr
	DEALLOCATE crsr;
	PRINT 'crsr close'
	SET NOCOUNT OFF

	/*
	DELETE FROM Factura
	DBCC CHECKIDENT (Factura, RESEED, 0);
	DELETE FROM Contrato
	DBCC CHECKIDENT (Contrato, RESEED, 0);
	DELETE FROM Clientes
	DBCC CHECKIDENT (Clientes, RESEED, 0);
	DELETE FROM Detalles
	DBCC CHECKIDENT (Detalles, RESEED, 0);
	DELETE FROM RelacionFamiliar
	DBCC CHECKIDENT (RelacionFamiliar, RESEED, 0);
	DELETE FROM LlamadaTelefonica
	DBCC CHECKIDENT (LlamadaTelefonica, RESEED, 0);
	DELETE FROM UsoDatos
	DBCC CHECKIDENT (UsoDatos, RESEED, 0);
	DELETE FROM RelacionFamiliar
	DBCC CHECKIDENT (RelacionFamiliar, RESEED, 0);
	DECLARE @datos XML 
	SELECT @datos = CONVERT(XML, Bulkcolumn) 
	FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\OperacionesMasivasFechasSql.xml', SINGLE_BLOB) AS x;
	
	EXEC CargarXmlDatos @datos
	*/
END;
GO
/****** Object:  StoredProcedure [dbo].[PagarFactura]    Script Date: 5/28/2024 3:21:38 PM ******/
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
