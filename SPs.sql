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

	/*
	DELETE FROM TiposUnidad
	DELETE FROM TiposElemento	
	DELETE FROM ElementosDeTipoTarifa
	DBCC CHECKIDENT (ElementosDeTipoTarifa, RESEED, 0);
	DELETE FROM TipoElementoFijo
	DBCC CHECKIDENT (TipoElementoFijo, RESEED, 0);
	DELETE FROM TipoRelacionesFamiliar
	DELETE FROM TiposTarifa

	DECLARE @datos XML 
	SELECT @datos = CONVERT(XML, Bulkcolumn) 
	FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\Config.xml', SINGLE_BLOB) AS x;

	EXEC CargarXmlConfig @datos
	*/
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
		
		WHILE (@lo <= @hi)
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
				/*
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
				*/
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
				--Calcular Detalles
				DECLARE @varFacturas TABLE (id INT IDENTITY(1,1) PRIMARY KEY, idFactura INT)
				DELETE FROM @varFacturas
				INSERT INTO @varFacturas (idFactura)
				SELECT
					Factura.id
				FROM Factura
				WHERE @fecha = Factura.FechaPago
				
				DECLARE @lou INT, @hig INT
				DECLARE @idFactura INT
				DECLARE @TBase INT, @MinExtra INT, @GigExtra FLOAT, @QFamiliares INT, @Costo911 INT,  @Costo110 INT, @Costo800 INT, @Costo900 INT

				SELECT @hig = MAX(F.id) FROM @varFacturas F
				SET @lou = 1

				WHILE (@lou <= @hig)
				BEGIN
					SELECT @idFactura = F.idFactura FROM @varFacturas F WHERE F.id = @lou

					PRINT @lou
					PRINT @idFactura

					SELECT
						@TBase = T.TarifaBase,
						@MinExtra = F.Minutos - T.MinutosBase,
						@GigExtra = F.QGigas - T.GigasBase,
						@QFamiliares = Fam.LlamadasFamiliares,
						@Costo911 = M.Llamadas911 * T.[911],
						@Costo110 = M.Llamadas110 * T.Costo110,
						@Costo800 = M.Minutos800 * T.Costo800,
						@Costo900 = M.Minutos900 * T.Costo900
					FROM
					(SELECT
						Contrato.id 'idContrato',
						SUM(DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin)) 'Minutos',
						SUM(UsoDatos.QGigas) 'QGigas'
					FROM LlamadaTelefonica
						inner join Contrato on Contrato.Numero =
						CASE
						WHEN LlamadaTelefonica.NumeroA LIKE '800%' THEN LlamadaTelefonica.NumeroA --si el receptor es numero 800, se le cobra a este
						ELSE LlamadaTelefonica.NumeroDe	--en otro caso, se le cobra al emisor de la llamada
						END
						inner join UsoDatos on UsoDatos.Numero = Contrato.Numero
					GROUP BY Contrato.id) AS F
						inner join
					(SELECT
						Contrato.id 'idContrato',
						SUM(CASE WHEN LlamadaTelefonica.NumeroA = '911' THEN 1 ELSE 0 END) 'Llamadas911',
						SUM(CASE WHEN LlamadaTelefonica.numeroA = '110' THEN 1 ELSE 0 END) 'Llamadas110',
						SUM(CASE WHEN LlamadaTelefonica.NumeroA LIKE '900%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END) 'Minutos900',
						SUM(CASE WHEN LlamadaTelefonica.NumeroDe LIKE '800%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END) 'Minutos800'
					FROM LlamadaTelefonica
						inner join Contrato on Contrato.Numero = 
							CASE
							WHEN Contrato.Numero LIKE '800%' THEN LlamadaTelefonica.NumeroA
							ELSE LlamadaTelefonica.NumeroDe END
						inner join Factura on Contrato.id = Factura.idContrato
					WHERE Factura.id = @idFactura
					GROUP BY Contrato.id
					)AS M on F.idContrato = M.idContrato
						inner join 
					(SELECT 
						Contrato.id 'idContrato',
						Contrato.Numero 'Numero',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 1 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'TarifaBase',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 2 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MinutosBase',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 5 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'GigasBase',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 8 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MultaAtraso',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 9 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo800',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 10 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo900',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 11 THEN ElementosDeTipoTarifa.valor ELSE 0 END) '911',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 12 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'IVA',
						MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 13 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo110'
					FROM Contrato
						inner join ElementosDeTipoTarifa on Contrato.idTarifa = ElementosDeTipoTarifa.idTipoTarifa
					GROUP BY Contrato.id, Contrato.Numero) AS T on M.idContrato = T.idContrato
						inner join
					(SELECT
						Contrato.id 'idContrato',
						COUNT(LlamadaTelefonica.NumeroDe) 'LlamadasFamiliares'
					FROM LlamadaTelefonica
						inner join Contrato on LlamadaTelefonica.NumeroDe = Contrato.Numero
						inner join RelacionFamiliar on Contrato.id = RelacionFamiliar.ClienteDe OR Contrato.id = RelacionFamiliar.ClienteA
					GROUP BY Contrato.id
					) AS Fam on F.idContrato = Fam.idContrato

					INSERT INTO Detalles (idFactura, Descripcion, Valor, idUnidad) VALUES
					(@idFactura, 'Tarifa Base', @TBase, 1),
					(@idFactura, 'Minutos Extra', @MinExtra, 4),
					(@idFactura, 'Gigas Extra', @GigExtra, 5),
					(@idFactura, 'Llamadas Familiares', @QFamiliares, NULL),
					(@idFactura, 'Cobro 911', @Costo911, 1),
					(@idFactura, 'Cobro 110', @Costo110, 1),
					(@idFactura, 'Cobro 800', @Costo800, 1),
					(@idFactura, 'Cobro 900', @Costo900, 1)

					SET @lou = @lou + 1
				END
				
				DECLARE @Atraso BIT
				SELECT 
					@Atraso = ~F2.Pagado
				FROM Factura F1
					inner join Factura F2 on 
						F1.idContrato = F2.idContrato 
						AND F2.FechaPago = DATEADD(MONTH, -1, F1.FechaPago)
				WHERE F2.Pagado = 1

				UPDATE Factura
					SET 
					TotalAntesIVA = (D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900,
					TotalConIVA = ((D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900) + ((D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + (D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900) + (D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900)*0.13,
					TotalConPendiente = ((D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900) + ((D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + (D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900) + (D.MinutosExtra * E.MinutosAdicional) + (D.GigasExtra * E.GigasAdicional) + D.Cobro911 + D.Cobro110 + D.Cobro800 + D.Cobro900)*0.13 + CASE WHEN @Atraso = 1 THEN E.MultaAtraso ELSE 0 END
					FROM
						(SELECT 
							Detalles.idFactura 'idFactura',
							MAX(CASE WHEN Detalles.descripcion = 'Minutos Extra' THEN Detalles.Valor ELSE 0 END) 'MinutosExtra',
							MAX(CASE WHEN Detalles.descripcion = 'Gigas Extra' THEN Detalles.Valor ELSE 0 END) 'GigasExtra',
							MAX(CASE WHEN Detalles.descripcion = 'Cobro 911' THEN Detalles.Valor ELSE 0 END) 'Cobro911',
							MAX(CASE WHEN Detalles.descripcion = 'Cobro 110' THEN Detalles.Valor ELSE 0 END) 'Cobro110',
							MAX(CASE WHEN Detalles.descripcion = 'Cobro 800' THEN Detalles.Valor ELSE 0 END) 'Cobro800',
							MAX(CASE WHEN Detalles.descripcion = 'Cobro 900' THEN Detalles.Valor ELSE 0 END) 'Cobro900'
						FROM Detalles
						GROUP BY Detalles.idFactura) AS D
						inner join Factura on D.idFactura = Factura.id
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
							GROUP BY Contrato.id, Contrato.Numero) AS E on Factura.idContrato = E.idContrato
					
					--Generar nueva factura
					INSERT INTO dbo.Factura (Fecha, FechaPago, idContrato, TotalAntesIVA, TotalConIVA, TotalConPendiente, Pagado)
					SELECT
						@fecha,
						DATEADD(MONTH, 1, @fecha),
						Factura.idContrato,
						0,
						0,
						0,
						0
					FROM Factura
					WHERE Factura.FechaPago = @fecha

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
	DELETE FROM EstadoDeCuenta
	DBCC CHECKIDENT (EstadoDeCuenta, RESEED, 0);
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
	FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\operacionesMasivas.xml', SINGLE_BLOB) AS x;
	
	DECLARE @out INT
	EXEC CargarXmlDatos @datos, @out OUT
		*/
	END;
GO

	DELETE FROM EstadoDeCuenta
	DBCC CHECKIDENT (EstadoDeCuenta, RESEED, 0);
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
	FROM OPENROWSET(BULK 'C:\Users\fash2\OneDrive\Documentos\GitHub\ProyectoBD3\operacionesMasivas.xml', SINGLE_BLOB) AS x;
	
	DECLARE @out INT
	EXEC CargarXmlDatos @datos, @out OUT
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

CREATE PROCEDURE mostrarDetalles (
	@inIdFactura INT,
	@outResultCode INT
) AS
BEGIN
	SET @outResultCode = 0

	BEGIN TRY
	BEGIN TRAN TDetalles

		SELECT
			T.TarifaBase 'TarifaBase',
			F.Minutos - T.MinutosBase 'MinutosExcedidos',
			F.QGigas - T.GigasBase 'Gigas Excedidos',
			M.Llamadas911 * T.[911] 'Cobro911',
			M.Llamadas110 * T.Costo110 'Cobro110',
			M.Minutos800 * T.Costo800 'Cobro800',
			M.Minutos900 * T.Costo900 'Cobro900'
		FROM
		(SELECT
			Factura.idContrato,
			SUM(CASE WHEN Detalles.idUnidad = 4 THEN Detalles.Valor ELSE 0 END) 'Minutos',
			SUM(CASE WHEN Detalles.idUnidad = 5 THEN Detalles.Valor ELSE 0 END) 'QGigas'
		FROM Detalles
			inner join Factura on Detalles.idFactura = Factura.id
		WHERE Factura.id = @inIdFactura
		GROUP BY Factura.idContrato) AS F
		inner join
		(SELECT
			Contrato.id 'idContrato',
			SUM(CASE WHEN LlamadaTelefonica.NumeroA = '911' THEN 1 ELSE 0 END) 'Llamadas911',
			SUM(CASE WHEN LlamadaTelefonica.numeroA = '110' THEN 1 ELSE 0 END) 'Llamadas110',
			SUM(CASE WHEN LlamadaTelefonica.NumeroA LIKE '900%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END) 'Minutos900',
			SUM(CASE WHEN LlamadaTelefonica.NumeroDe LIKE '800%' THEN DATEDIFF(MINUTE, LlamadaTelefonica.FechaHoraInicio, LlamadaTelefonica.FechaHoraFin) ELSE 0 END) 'Minutos800'
		FROM LlamadaTelefonica
			inner join Contrato on Contrato.Numero = 
				CASE
				WHEN Contrato.Numero LIKE '800%' THEN LlamadaTelefonica.NumeroA
				ELSE LlamadaTelefonica.NumeroDe END
			inner join Factura on Contrato.id = Factura.idContrato
		WHERE Factura.id = @inIdFactura
		GROUP BY Contrato.id
			)AS M on F.idContrato = M.idContrato
			inner join 
			(SELECT 
				Contrato.id 'idContrato',
				Contrato.Numero 'Numero',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 1 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'TarifaBase',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 2 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MinutosBase',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 5 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'GigasBase',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 8 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'MultaAtraso',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 9 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo800',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 10 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo900',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 11 THEN ElementosDeTipoTarifa.valor ELSE 0 END) '911',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 12 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'IVA',
				MAX(CASE WHEN ElementosDeTipoTarifa.IdTipoElemento = 13 THEN ElementosDeTipoTarifa.valor ELSE 0 END) 'Costo110'
			FROM Contrato
			inner join ElementosDeTipoTarifa on Contrato.idTarifa = ElementosDeTipoTarifa.idTipoTarifa
			GROUP BY Contrato.id, Contrato.Numero) AS T on M.idContrato = T.idContrato
		COMMIT TRAN TDetalles
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION CFactura
		
			SET @outResultCode = 50005

			INSERT INTO dbo.DBError (idTipoError,Fecha)
			VALUES (1,GETDATE())

		END CATCH
END