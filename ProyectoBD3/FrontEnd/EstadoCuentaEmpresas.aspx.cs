using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LogicaDeNegocios;

namespace ProyectoBD3.FrontEnd
{
    public partial class EstadoCuentaEmpresas : System.Web.UI.Page
    {

        private Logica Logica = new Logica();
        private int codigoDeEmpresa = -1;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (Session["codigoDeEmpresa"] != null)
                {   
                    this.codigoDeEmpresa = (int)Session["codigoDeEmpresa"];

                    if (codigoDeEmpresa == 1)
                        lblNombreEmpresa.Text = "Empresa X";

                    if (codigoDeEmpresa == 2)
                        lblNombreEmpresa.Text = "Empresa Y";

                    LlenarGridView(codigoDeEmpresa);
                }

            }
        }

        private void LlenarGridView(int CodigoDeEmpresa)
        {
            var datos = Logica.recuperarEstadosDeCuenta(CodigoDeEmpresa);
            gvListaEstadosDeCuentas.DataSource = datos;
            gvListaEstadosDeCuentas.DataBind();
        }

        protected void lnkVolver_Click(object sender, EventArgs e)
        { 
            Response.Redirect("PatallaPrincipal.aspx");
        }

        protected void lnkDetalles_Click(object sender, EventArgs e)
        {
            Response.Redirect("DetallesEstadoDeCuentaEmpresa.aspx");
        }

        protected void gvListaEstadosDeCuentas_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Obtener la fila seleccionada
            GridViewRow selectedRow = gvListaEstadosDeCuentas.SelectedRow;

            // Suponiendo que la columna Fecha está en el índice 2
            int fechaColumnIndex = 2; 

            // Extraer el valor de la columna Fecha
            string fechaString = selectedRow.Cells[fechaColumnIndex].Text;

            // Enviar parámetros
            Session["fechaDeEstadoDeCuenta"] = fechaString;
            
        }

        protected void gvListaEstadosDeCuentas_RowDataBound(object sender, GridViewRowEventArgs e)
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