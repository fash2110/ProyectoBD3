<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EstadoCuentaEmpresas.aspx.cs" Inherits="ProyectoBD3.FrontEnd.EstadoCuentaEmpresas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Estados de Cuenta</title>
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
        padding-top: 30px;
        min-height: 70px;
        border-bottom: #a2505d 3px solid;
    }
    header h1 {
        text-align: center;
        text-transform: uppercase;
        margin: 0;
    }
    .content {
        background: #ffffff;
        padding: 20px;
        margin-top: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .gridview {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .gridview th, .gridview td {
        padding: 8px;
        border: 1px solid #ddd;
        text-align: left;
    }
    .gridview th {
        background-color: #50b3a2;
        color: white;
    }
    .gridview tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    .gridview .select-button {
        display: inline-block;
        padding: 5px 10px;
        border: 1px solid #50b3a2;
        border-radius: 5px;
        background-color: #f2f2f2;
        color: #50b3a2;
        text-align: center;
        text-decoration: none;
    }

    .gridview .select-button:hover {
        background-color: #50b3a2;
        color: white;
        cursor: pointer;
    }
    .option {
        background: #e7e7e7;
        padding: 20px;
        border-radius: 5px;
        text-align: center;
        width: 20%;
        margin-top: 10px;
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
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header>
            <div class="container">
                <h1>Lista de Estados de Cuenta</h1>
            </div>
        </header>

        <div class="container">
            <h2>Estados de cuenta de:</h2>
            <asp:Label ID="lblNombreEmpresa" runat="server" Text="Empresa Desconocida"></asp:Label>

            <div class="content">
                <div id="div1" style="max-height:600px; overflow-y:scroll;">
                    <asp:GridView ID="gvListaEstadosDeCuentas" runat="server" CssClass="gridview" AutoGenerateSelectButton="true" 
                                  OnRowDataBound="gvListaEstadosDeCuentas_RowDataBound" OnSelectedIndexChanged="gvListaEstadosDeCuentas_SelectedIndexChanged">
                        <HeaderStyle BackColor="#50b3a2" ForeColor="White" />
                        <AlternatingRowStyle BackColor="#f2f2f2" />
                        <RowStyle BackColor="white" />
                        <PagerStyle BackColor="#50b3a2" ForeColor="White" />
                        <SelectedRowStyle BackColor="#50b3a2" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </div>

                <div class="option">
                    <asp:LinkButton ID="lnkVolver" runat="server" OnClick="lnkVolver_Click">Volver</asp:LinkButton>
                    <asp:LinkButton ID="lnkDetalles" runat="server" OnClick="lnkDetalles_Click">Detalles</asp:LinkButton>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
