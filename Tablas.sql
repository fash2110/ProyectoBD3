USE [master]
GO
/****** Object:  Database [ProyectoBD3]    Script Date: 5/15/2024 8:32:46 PM ******/
CREATE DATABASE [ProyectoBD3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ProyectoBD3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.PABLOMESENBD\MSSQL\DATA\ProyectoBD3.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ProyectoBD3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.PABLOMESENBD\MSSQL\DATA\ProyectoBD3_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ProyectoBD3] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ProyectoBD3].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ProyectoBD3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ProyectoBD3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ProyectoBD3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ProyectoBD3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ProyectoBD3] SET ARITHABORT OFF 
GO
ALTER DATABASE [ProyectoBD3] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ProyectoBD3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ProyectoBD3] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ProyectoBD3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ProyectoBD3] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ProyectoBD3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ProyectoBD3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ProyectoBD3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ProyectoBD3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ProyectoBD3] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ProyectoBD3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ProyectoBD3] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ProyectoBD3] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ProyectoBD3] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ProyectoBD3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ProyectoBD3] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ProyectoBD3] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ProyectoBD3] SET RECOVERY FULL 
GO
ALTER DATABASE [ProyectoBD3] SET  MULTI_USER 
GO
ALTER DATABASE [ProyectoBD3] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ProyectoBD3] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ProyectoBD3] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ProyectoBD3] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ProyectoBD3] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ProyectoBD3] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ProyectoBD3', N'ON'
GO
ALTER DATABASE [ProyectoBD3] SET QUERY_STORE = ON
GO
ALTER DATABASE [ProyectoBD3] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ProyectoBD3]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[Identificación] [int] NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CobroFijo]    Script Date: 5/15/2024 8:32:46 PM ******/
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
/****** Object:  Table [dbo].[Contrato]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contrato](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](64) NOT NULL,
	[DocIdCliente] [int] NOT NULL,
	[idCliente] [int] NOT NULL,
	[idTarifa] [int] NOT NULL,
 CONSTRAINT [PK_Contrato] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Detalles]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Detalles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idFactura] [int] NOT NULL,
 CONSTRAINT [PK_Detalles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ElementosDeTipoTarifa]    Script Date: 5/15/2024 8:32:46 PM ******/
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
/****** Object:  Table [dbo].[Factura]    Script Date: 5/15/2024 8:32:46 PM ******/
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
 CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LlamadaTelefonica]    Script Date: 5/15/2024 8:32:46 PM ******/
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
	[idDetalles] [int] NOT NULL,
 CONSTRAINT [PK_LlamadaTelefonica] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Local]    Script Date: 5/15/2024 8:32:46 PM ******/
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
/****** Object:  Table [dbo].[NoLocal]    Script Date: 5/15/2024 8:32:46 PM ******/
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
/****** Object:  Table [dbo].[RelacionFamiliar]    Script Date: 5/15/2024 8:32:46 PM ******/
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
/****** Object:  Table [dbo].[TipoRelacionesFamiliar]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoRelacionesFamiliar](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoParentezco] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposElemento]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposElemento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TiposElemento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposTarifa]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposTarifa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoTarifa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsoDatos]    Script Date: 5/15/2024 8:32:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsoDatos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](64) NOT NULL,
	[QGigas] [float] NOT NULL,
	[idDetalles] [int] NOT NULL,
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
ALTER TABLE [dbo].[LlamadaTelefonica]  WITH CHECK ADD  CONSTRAINT [FK_LlamadaTelefonica_Detalles] FOREIGN KEY([idDetalles])
REFERENCES [dbo].[Detalles] ([id])
GO
ALTER TABLE [dbo].[LlamadaTelefonica] CHECK CONSTRAINT [FK_LlamadaTelefonica_Detalles]
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
ALTER TABLE [dbo].[UsoDatos]  WITH CHECK ADD  CONSTRAINT [FK_UsoDatos_Detalles] FOREIGN KEY([idDetalles])
REFERENCES [dbo].[Detalles] ([id])
GO
ALTER TABLE [dbo].[UsoDatos] CHECK CONSTRAINT [FK_UsoDatos_Detalles]
GO
USE [master]
GO
ALTER DATABASE [ProyectoBD3] SET  READ_WRITE 
GO
