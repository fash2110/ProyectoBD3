<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatallaPrincipal.aspx.cs" Inherits="ProyectoBD3.FrontEnd.PatallaPrincipal" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página del Administrador</title>
    <style>
        body {
            font-family: 'Lucida Console';
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: auto;
        }
        header {
            background: #50b3a2;
            color: #ffffff;
            padding: 30px 0;
            border-bottom: #a2505d 3px solid;
            text-align: center;
        }
        header h1 {
            text-transform: uppercase;
            margin: 0;
        }
        .content {
            background: #ffffff;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .options {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }
        .option {
            background: #e7e7e7;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
            width: 45%;
        }
        .option input[type="text"] {
            width: 80%;
            padding: 10px;
            margin: 10px 0;
        }
        .option input[type="submit"], .option a {
            background: #50b3a2;
            color: white;
            padding: 10px;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            margin: 10px 0;
            display: inline-block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header>
            <div class="container">
                <h1>Bienvenido, Administrador</h1>
            </div>
        </header>
        <div class="container">
            <div class="content">
                <h2>Opciones</h2>
                <div class="options">
                    <div class="option">
                        <h3>Consultar Facturas</h3>
                        <p>Ingrese un número telefónico:</p>
                        <asp:TextBox ID="txtTelefono" runat="server" Placeholder="Número telefónico" CssClass="textbox"></asp:TextBox>
                        <asp:Button ID="btnConsultar" runat="server" Text="Consultar" OnClick="btnConsultar_Click" />
                    </div>
                    <div class="option">
                        <h3>Estados de Cuenta</h3>
                        <p>Seleccione la empresa:</p>
                        <asp:LinkButton ID="lnkEmpresaX" runat="server" OnClick="lnkEmpresaX_Click">Empresa X</asp:LinkButton>
                        <asp:LinkButton ID="lnkEmpresaY" runat="server" OnClick="lnkEmpresaY_Click">Empresa Y</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
