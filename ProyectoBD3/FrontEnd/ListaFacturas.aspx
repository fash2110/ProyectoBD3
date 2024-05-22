<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ListaFacturas.aspx.cs" Inherits="ProyectoBD3.FrontEnd.ListaFacturas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Lista de facturas</title>

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

    </style>


</head>
<body>
    <form id="form1" runat="server">
       
        <header>
            <div class="container">
                <h1>Lista de Facturas</h1>
            </div>
        </header>

        <div class="container">
            <h2>Número Telefonico: </h2>
            <asp:Label ID="lblNumeroTelefonico" runat="server" Text=""></asp:Label>

            <div class="content">

                <asp:GridView ID="gvListaFacturas" runat="server" CssClass="gridview">
                    <HeaderStyle BackColor="#50b3a2" ForeColor="White" />
                    <AlternatingRowStyle BackColor="#f2f2f2" />
                    <RowStyle BackColor="white" />
                    <PagerStyle BackColor="#50b3a2" ForeColor="White" />
                    <SelectedRowStyle BackColor="#50b3a2" Font-Bold="True" ForeColor="White" />
                </asp:GridView>

            </div>
        </div>

    </form>
</body>
</html>
