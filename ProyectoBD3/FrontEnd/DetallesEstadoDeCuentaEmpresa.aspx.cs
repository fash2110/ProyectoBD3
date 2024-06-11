using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LogicaDeNegocios;

namespace ProyectoBD3.FrontEnd
{
    public partial class DetallesEstadoDeCuentaEmpresa : System.Web.UI.Page
    {   

        private Logica Logica = new Logica();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["codigoDeEmpresa"] != null && Session["fechaDeEstadoDeCuenta"] != null)
                {
                    int codigoDeEmpresa = (int)Session["codigoDeEmpresa"];
                    string fechaDeEstadoDeCuenta = (string)Session["fechaDeEstadoDeCuenta"];

                    LlenarGridView(codigoDeEmpresa, fechaDeEstadoDeCuenta);
                    Session.Remove("codigoDeEmpresa");
                    Session.Remove("fechaDeEstadoDeCuenta");

                    if (codigoDeEmpresa == 1)
                        tituloDIV.Text = "Empresa respectiva X";

                    if (codigoDeEmpresa == 2)
                        tituloDIV.Text = "Empresa respectiva Y";

                }
            }
        }
        private void LlenarGridView(int CodigoDeEmpresa, string FechaDeEstadoDeCuenta)
        {
            var datos = Logica.recuperarLlamadasDeEstadoDeCuenta(CodigoDeEmpresa, FechaDeEstadoDeCuenta);
            gvLlamadasDeEstadoDeCuenta.DataSource = datos;
            gvLlamadasDeEstadoDeCuenta.DataBind();
        }

        protected void lnkVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("PatallaPrincipal.aspx");
        }

        protected void gvLlamadasDeEstadoDeCuenta_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton selectButton = e.Row.Cells[0].Controls[0] as LinkButton;
                if (selectButton != null)
                {
                    selectButton.CssClass = "select-button";
                }
            }
        }
    }
}