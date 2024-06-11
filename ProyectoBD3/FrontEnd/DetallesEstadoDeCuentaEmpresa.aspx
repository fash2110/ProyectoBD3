<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DetallesEstadoDeCuentaEmpresa.aspx.cs" Inherits="ProyectoBD3.FrontEnd.DetallesEstadoDeCuentaEmpresa" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Detalles de Estado De Cuenta</title>
    <style>
        body {
            font-family: 'Lucida Console';
            background-color: #f0f0f0;
        }
        .container {
            width: 80%;
            margin: auto;
            padding: 20px;
        }
        .title {
            background-color: #50b3a2;
            color: white;
            padding: 10px;
            margin-top: 20px;
        }
        .gridview {
            width: 100%;
            height: 300px;
            border: 5px solid #ccc;
            box-sizing: border-box;
            margin-top: 10px;
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
        <div class="container">
            <div id="myDiv" class="title" runat="server">
                <asp:Literal ID="tituloDIV" runat="server"></asp:Literal>
            </div>

                <div id="popup" style="max-height:600px;overflow-y:scroll;margin-top:10px;">
                    
                    <asp:GridView ID="gvLlamadasDeEstadoDeCuenta" runat="server" CssClass="gridview"> 
                                  
                        <HeaderStyle BackColor="#50b3a2" ForeColor="White" />
                        <AlternatingRowStyle BackColor="#f2f2f2" />
                        <RowStyle BackColor="white" />
                        <PagerStyle BackColor="#50b3a2" ForeColor="White" />
                        <SelectedRowStyle BackColor="#50b3a2" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>

                </div>

                <div class="option">
                    <asp:LinkButton ID="lnkVolver" runat="server" Onclick="lnkVolver_Click">Volver</asp:LinkButton>
                </div>
        </div>
    </form>
</body>
</html>

