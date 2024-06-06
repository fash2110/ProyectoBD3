using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoBD3.FrontEnd
{
    public partial class DetallesEstadoDeCuentaEmpresa : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Crear una tabla de datos simulada
                DataTable dt = new DataTable();
                dt.Columns.Add("Campo1");
                dt.Columns.Add("Campo2");
                dt.Columns.Add("Campo3");

                // Añadir 30 filas a la tabla
                for (int i = 1; i <= 100; i++)
                {
                    dt.Rows.Add("Dato " + i, "Dato " + i, "Dato " + i);
                }

                // Enlazar el GridView
                gvDetails.DataSource = dt;
                gvDetails.DataBind();
            }
        }

        protected void lnkVolver_Click(object sender, EventArgs e)
        {
            // Volver a la página principal

            Response.Redirect("PatallaPrincipal.aspx");
        }
    }
}