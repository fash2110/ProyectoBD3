USE [ProyectoBD3]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[Identificacion] [int] NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CobroFijo]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CobroFijo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idElementosDeTipoTarifa] [int] NOT NULL,
	[idDetalles] [int] NOT NULL,
 CONSTRAINT [PK_CobroFijo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contrato]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contrato](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](64) NOT NULL,
	[DocIdCliente] [int] NOT NULL,
	[idCliente] [int] NULL,
	[idTarifa] [int] NOT NULL,
	[Fecha] [date] NULL,
 CONSTRAINT [PK_Contrato] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DBError]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBError](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoError] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_DBError] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Detalles]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Detalles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idFactura] [int] NOT NULL,
	[Nombre] [varchar](10) NULL,
	[valor] [int] NULL,
 CONSTRAINT [PK_Detalles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallesECOperador]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesECOperador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DuraciónLlamada] [int] NOT NULL,
	[idTipoLlamadaOperador] [int] NOT NULL,
	[idEstadoDeCuentaOperador] [int] NOT NULL,
 CONSTRAINT [PK_DetallesECOperador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ElementosDeTipoTarifa]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ElementosDeTipoTarifa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoTarifa] [int] NOT NULL,
	[IdTipoElemento] [int] NOT NULL,
	[valor] [int] NOT NULL,
	[IdTipoUnidad] [int] NOT NULL,
 CONSTRAINT [PK_ElementosDeTipoTarifa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoDeCuentaOperador]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoDeCuentaOperador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TotalMinutosEntrantes] [int] NOT NULL,
	[TotalMinutosSalientes] [int] NOT NULL,
 CONSTRAINT [PK_EstadoDeCuentaOperador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Factura]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Factura](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[FechaPago] [date] NOT NULL,
	[idContrato] [int] NOT NULL,
	[TotalAntesIVA] [int] NOT NULL,
	[TotalConIVA] [int] NOT NULL,
	[TotalConPendiente] [int] NULL,
	[Pagado] [bit] NULL,
 CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LlamadaTelefonica]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LlamadaTelefonica](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NumeroDe] [varchar](64) NOT NULL,
	[NumeroA] [varchar](64) NOT NULL,
	[Inicio] [datetime] NOT NULL,
	[Final] [datetime] NOT NULL,
 CONSTRAINT [PK_LlamadaTelefonica] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Local]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Local](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NúmeroDeTelefono] [varchar](64) NOT NULL,
	[idLlamadaTelefonica] [int] NOT NULL,
	[idContrato] [int] NOT NULL,
 CONSTRAINT [PK_Local] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoLocal]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoLocal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NumeroDeTelefono] [varchar](64) NOT NULL,
	[idLlamadaTelefonica] [int] NOT NULL,
 CONSTRAINT [PK_NoLocal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Operador]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[Prefijo] [varchar](64) NOT NULL,
	[IdEstadoDeCuentaOperador] [int] NOT NULL,
 CONSTRAINT [PK_Operador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RelacionFamiliar]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelacionFamiliar](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ClienteDe] [int] NOT NULL,
	[ClienteA] [int] NOT NULL,
	[idTipoRelacionesFamiliar] [int] NOT NULL,
 CONSTRAINT [PK_Parientes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoError]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoError](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoError] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoLlamadaOperador]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoLlamadaOperador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NombreDeTipo] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoLlamadaOperador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoRelacionesFamiliar]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoRelacionesFamiliar](
	[id] [int] NOT NULL,
	[Tipo] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoParentezco] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposElemento]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposElemento](
	[id] [int] NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TiposElemento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposTarifa]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposTarifa](
	[id] [int] NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoTarifa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposUnidad]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposUnidad](
	[id] [int] NOT NULL,
	[tipo] [varchar](64) NULL,
 CONSTRAINT [PK_TiposUnidad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsoDatos]    Script Date: 5/21/2024 4:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsoDatos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](64) NOT NULL,
	[QGigas] [float] NOT NULL,
 CONSTRAINT [PK_UsoDatos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CobroFijo]  WITH CHECK ADD  CONSTRAINT [FK_CobroFijo_Detalles] FOREIGN KEY([idDetalles])
REFERENCES [dbo].[Detalles] ([id])
GO
ALTER TABLE [dbo].[CobroFijo] CHECK CONSTRAINT [FK_CobroFijo_Detalles]
GO
ALTER TABLE [dbo].[CobroFijo]  WITH CHECK ADD  CONSTRAINT [FK_CobroFijo_ElementosDeTipoTarifa] FOREIGN KEY([idElementosDeTipoTarifa])
REFERENCES [dbo].[ElementosDeTipoTarifa] ([id])
GO
ALTER TABLE [dbo].[CobroFijo] CHECK CONSTRAINT [FK_CobroFijo_ElementosDeTipoTarifa]
GO
ALTER TABLE [dbo].[Contrato]  WITH CHECK ADD  CONSTRAINT [FK_Contrato_Clientes] FOREIGN KEY([idCliente])
REFERENCES [dbo].[Clientes] ([id])
GO
ALTER TABLE [dbo].[Contrato] CHECK CONSTRAINT [FK_Contrato_Clientes]
GO
ALTER TABLE [dbo].[Contrato]  WITH CHECK ADD  CONSTRAINT [FK_Contrato_TiposTarifa] FOREIGN KEY([idTarifa])
REFERENCES [dbo].[TiposTarifa] ([id])
GO
ALTER TABLE [dbo].[Contrato] CHECK CONSTRAINT [FK_Contrato_TiposTarifa]
GO
ALTER TABLE [dbo].[Detalles]  WITH CHECK ADD  CONSTRAINT [FK_Detalles_Factura] FOREIGN KEY([idFactura])
REFERENCES [dbo].[Factura] ([id])
GO
ALTER TABLE [dbo].[Detalles] CHECK CONSTRAINT [FK_Detalles_Factura]
GO
ALTER TABLE [dbo].[ElementosDeTipoTarifa]  WITH CHECK ADD  CONSTRAINT [FK_ElementosDeTipoTarifa_TiposElemento] FOREIGN KEY([IdTipoElemento])
REFERENCES [dbo].[TiposElemento] ([id])
GO
ALTER TABLE [dbo].[ElementosDeTipoTarifa] CHECK CONSTRAINT [FK_ElementosDeTipoTarifa_TiposElemento]
GO
ALTER TABLE [dbo].[ElementosDeTipoTarifa]  WITH CHECK ADD  CONSTRAINT [FK_ElementosDeTipoTarifa_TiposTarifa] FOREIGN KEY([idTipoTarifa])
REFERENCES [dbo].[TiposTarifa] ([id])
GO
ALTER TABLE [dbo].[ElementosDeTipoTarifa] CHECK CONSTRAINT [FK_ElementosDeTipoTarifa_TiposTarifa]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_Contrato] FOREIGN KEY([idContrato])
REFERENCES [dbo].[Contrato] ([id])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_Contrato]
GO
ALTER TABLE [dbo].[Local]  WITH CHECK ADD  CONSTRAINT [FK_Local_Contrato] FOREIGN KEY([idContrato])
REFERENCES [dbo].[Contrato] ([id])
GO
ALTER TABLE [dbo].[Local] CHECK CONSTRAINT [FK_Local_Contrato]
GO
ALTER TABLE [dbo].[Local]  WITH CHECK ADD  CONSTRAINT [FK_Local_LlamadaTelefonica] FOREIGN KEY([idLlamadaTelefonica])
REFERENCES [dbo].[LlamadaTelefonica] ([id])
GO
ALTER TABLE [dbo].[Local] CHECK CONSTRAINT [FK_Local_LlamadaTelefonica]
GO
ALTER TABLE [dbo].[NoLocal]  WITH CHECK ADD  CONSTRAINT [FK_NoLocal_LlamadaTelefonica] FOREIGN KEY([idLlamadaTelefonica])
REFERENCES [dbo].[LlamadaTelefonica] ([id])
GO
ALTER TABLE [dbo].[NoLocal] CHECK CONSTRAINT [FK_NoLocal_LlamadaTelefonica]
GO
ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_Clientes] FOREIGN KEY([ClienteDe])
REFERENCES [dbo].[Clientes] ([id])
GO
ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_Clientes]
GO
ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_Clientes1] FOREIGN KEY([ClienteA])
REFERENCES [dbo].[Clientes] ([id])
GO
ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_Clientes1]
GO
ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_TipoRelacionesFamiliar] FOREIGN KEY([idTipoRelacionesFamiliar])
REFERENCES [dbo].[TipoRelacionesFamiliar] ([id])
GO
ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_TipoRelacionesFamiliar]
GO
