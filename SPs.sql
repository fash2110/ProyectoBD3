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
ALTER PROCEDURE [dbo].[CargarXmlDatos] (
	@XMLData XML, 
	@OutResultCode INT OUTPUT
) AS
BEGIN
	SET NOCOUNT ON

	DECLARE 
		@fecha DATE,
		@lo INT,
		@hi INT
	SET @OutResultCode = 0
	SET @lo = 1

	BEGIN TRY
		
		DECLARE @varFechas TABLE(
			id INT IDENTITY(1,1) PRIMARY KEY, 
			Fecha DATE)
		INSERT INTO @varFechas (Fecha)
		SELECT c.value('@fecha', 'VARCHAR(16)')
		FROM @XMLData.nodes('/Operaciones/FechaOperacion') as t(c);

		SELECT @hi = MAX(f.id)
		FROM @varFechas f

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
			TipoRelacion INT NULL,
			PagoFactura BIT NULL
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
	
		--Insert FacturasPagadas
		INSERT INTO @varDatos (Fecha, Numero, PagoFactura)
		SELECT 
			c.value('@fecha', 'DATE'),
			d.value('@Numero', 'VARCHAR(64)'),
			1
		FROM @XMLData.nodes('/Operaciones/FechaOperacion') AS T(c) 
		CROSS APPLY c.nodes('PagoFactura ') AS U(d);
	
		WHILE (@lo < @hi)
		BEGIN		
			BEGIN TRAN Tdatos
				SELECT @fecha = f.Fecha
				FROM @varFechas f
				WHERE f.id = @lo
				
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
				INSERT INTO dbo.LlamadaTelefonica (NumeroDe, NumeroA, FechaHoraInicio, FechaHoraFin, EsGratis)
				SELECT
					d.NumeroDe,
					d.NumeroA,
					d.Inicio,
					d.Final,
					0
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

				--Insertar detalles de facturas por llamadas
				INSERT INTO dbo.Detalles (idFactura, Descripcion, Valor, idUnidad)
				SELECT
					Factura.id 'idFactura',
					'Llamada',
					DATEDIFF(MINUTE, d.Inicio, d.Final),
					4
				FROM Contrato
					inner join Factura on Contrato.id = Factura.idContrato
					inner join @varDatos d on Contrato.Numero = 
					CASE
					WHEN d.NumeroA LIKE '800%' THEN d.NumeroA --si el receptor es numero 800, se le cobra a este
					ELSE d.NumeroDe	--en otro caso, se le cobra al emisor de la llamada
					END
				WHERE CAST(d.Final AS DATE) = @fecha

				--Insertar detalles de factura por usoDatos
				INSERT INTO dbo.Detalles (idFactura, Descripcion, Valor, idUnidad)
				SELECT
					Factura.id,
					'usoDatos',
					d.QGigas,
					5
				FROM Contrato
					inner join Factura on Contrato.id = Factura.idContrato
					inner join @varDatos d on d.Numero = Contrato.Numero
				WHERE d.Fecha = @fecha AND d.QGigas IS NOT NULL

				--Pagar facturas
				UPDATE Factura
				SET Factura.Pagado = 1
				FROM (SELECT Factura.id 
						FROM Factura 
						inner join Contrato on Factura.idContrato = Contrato.id
						inner join @varDatos d on d.Numero = Contrato.Numero
						WHERE d.PagoFactura = 1) AS F
				WHERE F.id = Factura.id
			COMMIT TRAN Tdatos
		
			IF DAY(@fecha) = 5 --cierre de estado de cuenta
			BEGIN
				--Empresa X
				INSERT INTO EstadoDeCuenta (Fecha, MinutosEntrantes, MinutosSaliente, Empresa)
				SELECT
					@fecha,
					SUM(CASE WHEN LlamadaTelefonica.NumeroDe LIKE '7%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
					SUM(CASE WHEN LlamadaTelefonica.NumeroA LIKE '7%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
					'X'
				FROM LlamadaTelefonica
				WHERE MONTH(@fecha) = MONTH(LlamadaTelefonica.FechaHoraInicio)

				--Empresa Y
				INSERT INTO EstadoDeCuenta (Fecha, MinutosEntrantes, MinutosSaliente, Empresa)
				SELECT
					@fecha,
					SUM(CASE WHEN LlamadaTelefonica.NumeroDe LIKE '6%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
					SUM(CASE WHEN LlamadaTelefonica.NumeroA LIKE '6%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
					'Y'
				FROM LlamadaTelefonica
				WHERE MONTH(@fecha) = MONTH(LlamadaTelefonica.FechaHoraInicio)
			END

			IF EXISTS(SELECT 1 FROM Factura WHERE @fecha = Factura.FechaPago)
			BEGIN
			BEGIN TRAN TFactura
				--Cerrar Facturas
				UPDATE Factura 
				SET 
				Factura.TotalAntesIVA = FC.TotalAntesIVA,
				Factura.TotalConIVA = FC.TotalConIVA,
				Factura.TotalConPendiente = FC.TotalCMulta
				FROM (SELECT 
					--TotalAntesIVA
					E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END AS 'TotalAntesIVA'
					,
					--TotalConIVA
					(E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END) +
					(E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END) * 0.13
					AS 'TotalConIVA'
					,
					--MultaAtraso
					CASE WHEN EXISTS(SELECT 1 FROM Factura WHERE Factura.FechaPago = DATEADD(MONTH, -1, S.Fecha) AND Factura.Pagado = 0) 
						THEN ((E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END) +
					(E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END) * 0.13) + E.MultaAtraso
					ELSE (E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END) +
					(E.TarifaBase +
					CASE
					WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
					WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
					WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
					ELSE 0
					END 
					+
					CASE
					WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
					ELSE 0
					END) * 0.13
					END AS 'TotalCMulta'
				FROM (SELECT
							Factura.idContrato,
							Factura.id,
							Factura.Fecha,
							SUM(CASE WHEN Detalles.idUnidad = 4 THEN Detalles.Valor ELSE 0 END) 'Minutos',
							SUM(CASE WHEN Detalles.idUnidad = 5 THEN Detalles.Valor ELSE 0 END) 'QGigas'
						FROM Factura
							inner join Detalles on Detalles.idFactura = Factura.id
						WHERE @fecha BETWEEN Factura.Fecha AND Factura.FechaPago
						GROUP BY Factura.id, Factura.idContrato, Factura.Fecha) as S
						inner join 
						(SELECT 
							Contrato.id 'idContrato',
							Contrato.Numero 'Numero',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 1 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'TarifaBase',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 2 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MinutosBase',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 3 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MinutosAdicional',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 5 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'GigasBase',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 6 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'GigasAdicional',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 8 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MultaAtraso',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 9 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo800',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 10 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo900',
							MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 12 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'IVA'
						FROM Contrato
						inner join ElementosDeTipoTarifa on Contrato.idTarifa = ElementosDeTipoTarifa.idTipoTarifa
						GROUP BY Contrato.id, Contrato.Numero) AS E ON S.idContrato = E.idContrato) AS FC
					WHERE @fecha = Factura.FechaPago
			
				--Generar nueva factura
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
			COMMIT TRAN TFactura
			END
		
			SET @lo = @lo + 1
		END
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK
		
			SET @outResultCode = 50005

			INSERT INTO dbo.DBError (idTipoError,Fecha)
			VALUES (1,GETDATE())
		END CATCH

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
		FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\OperacionesMasivas.xml', SINGLE_BLOB) AS x;
	
		EXEC CargarXmlDatos @datos
		*/
	END;
GO
	DELETE FROM Detalles
	DBCC CHECKIDENT (Detalles, RESEED, 0);
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
	FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\OperacionesMasivas.xml', SINGLE_BLOB) AS x;
	
	DECLARE @out INT
	EXEC CargarXmlDatos @datos, @out OUT

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

ALTER PROCEDURE cerrarEstadoDeCuenta(	
	@outResultCode INT OUT
) AS
BEGIN
	SET @outResultCode = 0
	BEGIN TRY
		BEGIN TRAN CEstCu
			INSERT INTO EstadoDeCuenta (Fecha, MinutosEntrantes, MinutosSaliente, Empresa)
			SELECT
				GETDATE(),
				SUM(CASE WHEN LlamadaTelefonica.NumeroDe LIKE '7%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
				SUM(CASE WHEN LlamadaTelefonica.NumeroA LIKE '7%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
				'X'
			FROM LlamadaTelefonica
			WHERE MONTH(GETDATE()) = MONTH(LlamadaTelefonica.FechaHoraInicio)

			INSERT INTO EstadoDeCuenta (Fecha, MinutosEntrantes, MinutosSaliente, Empresa)
			SELECT
				GETDATE(),
				SUM(CASE WHEN LlamadaTelefonica.NumeroDe LIKE '6%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
				SUM(CASE WHEN LlamadaTelefonica.NumeroA LIKE '6%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END),
				'Y'
			FROM LlamadaTelefonica
			WHERE MONTH(GETDATE()) = MONTH(LlamadaTelefonica.FechaHoraInicio)
		COMMIT TRAN CEstCu
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION CEstCu
		
		SET @outResultCode = 50005

		INSERT INTO dbo.DBError (idTipoError,Fecha)
		VALUES (1,GETDATE())
	END CATCH
END
GO;

CREATE PROCEDURE cerrarFactura (
	@outResultCode INT OUT
) AS
BEGIN
	SET @outResultCode = 0
	BEGIN TRY
		BEGIN TRAN CFactura
		UPDATE Factura 
					SET 
					Factura.TotalAntesIVA = FC.TotalAntesIVA,
					Factura.TotalConIVA = FC.TotalConIVA,
					Factura.TotalConPendiente = FC.TotalCMulta
					FROM (SELECT 
						--TotalAntesIVA
						E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END AS 'TotalAntesIVA'
						,
						--TotalConIVA
						(E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END) +
						(E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END) * 0.13
						AS 'TotalConIVA'
						,
						--MultaAtraso
						CASE WHEN EXISTS(SELECT 1 FROM Factura WHERE Factura.FechaPago = DATEADD(MONTH, -1, S.Fecha) AND Factura.Pagado = 0) 
							THEN ((E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END) +
						(E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END) * 0.13) + E.MultaAtraso
						ELSE (E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END) +
						(E.TarifaBase +
						CASE
						WHEN S.Minutos > E.MinutosBase THEN (S.Minutos - E.MinutosBase) * COALESCE(NULLIF(E.MinutosAdicional, 0), 1)
						WHEN E.Numero LIKE '800%' THEN S.Minutos * E.Costo800
						WHEN E.Numero LIKE '900%' THEN S.Minutos * E.Costo900
						ELSE 0
						END 
						+
						CASE
						WHEN S.QGigas > E.GigasBase THEN (S.QGigas - E.GigasBase) * COALESCE(NULLIF(E.GigasAdicional, 0), 1)
						ELSE 0
						END) * 0.13
						END AS 'TotalCMulta'
					FROM (SELECT
								Factura.idContrato,
								Factura.id,
								Factura.Fecha,
								SUM(CASE WHEN Detalles.idUnidad = 4 THEN Detalles.Valor ELSE 0 END) 'Minutos',
								SUM(CASE WHEN Detalles.idUnidad = 5 THEN Detalles.Valor ELSE 0 END) 'QGigas'
							FROM Factura
								inner join Detalles on Detalles.idFactura = Factura.id
							WHERE GETDATE() BETWEEN Factura.Fecha AND Factura.FechaPago
							GROUP BY Factura.id, Factura.idContrato, Factura.Fecha) as S
							inner join 
							(SELECT 
								Contrato.id 'idContrato',
								Contrato.Numero 'Numero',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 1 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'TarifaBase',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 2 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MinutosBase',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 3 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MinutosAdicional',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 5 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'GigasBase',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 6 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'GigasAdicional',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 8 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MultaAtraso',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 9 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo800',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 10 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo900',
								MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 12 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'IVA'
							FROM Contrato
							inner join ElementosDeTipoTarifa on Contrato.idTarifa = ElementosDeTipoTarifa.idTipoTarifa
							GROUP BY Contrato.id, Contrato.Numero) AS E ON S.idContrato = E.idContrato) AS FC
						WHERE GETDATE() = Factura.FechaPago
		COMMIT TRAN CFactura
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION CFactura
		
		SET @outResultCode = 50005

		INSERT INTO dbo.DBError (idTipoError,Fecha)
		VALUES (1,GETDATE())
	END CATCH
END
GO;