using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoBD3.FrontEnd
{
    public partial class EstadoCuentaEmpresas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LlenarGridView();
            }
        }

        private void LlenarGridView()
        {
            // Crear una lista de objetos anónimos con datos ficticios
            var datos = new List<dynamic>
            {
                new { Campo1 = "Dato 1", Campo2 = "Dato 2", Campo3 = "Dato 3" },
                new { Campo1 = "Dato 4", Campo2 = "Dato 5", Campo3 = "Dato 6" },
                new { Campo1 = "Dato 7", Campo2 = "Dato 8", Campo3 = "Dato 9" },
                new { Campo1 = "Dato 10", Campo2 = "Dato 11", Campo3 = "Dato 12" },
                new { Campo1 = "Dato 13", Campo2 = "Dato 14", Campo3 = "Dato 15" },
                new { Campo1 = "Dato 16", Campo2 = "Dato 17", Campo3 = "Dato 18" },
                new { Campo1 = "Dato 19", Campo2 = "Dato 20", Campo3 = "Dato 21" },
                new { Campo1 = "Dato 22", Campo2 = "Dato 23", Campo3 = "Dato 24" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 28", Campo2 = "Dato 29", Campo3 = "Dato 30" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" },
                new { Campo1 = "Dato 25", Campo2 = "Dato 26", Campo3 = "Dato 27" }
            };

            // Asignar la lista de datos al GridView y enlazar los datos
            gvListaEstadosDeCuentas.DataSource = datos;
            gvListaEstadosDeCuentas.DataBind();
        }

        protected void lnkVolver_Click(object sender, EventArgs e)
        {
            // Volver a la página principal

            Response.Redirect("PatallaPrincipal.aspx");
        }

        protected void lnkDetalles_Click(object sender, EventArgs e)
        {
            // Ir a los detalles del estado de cuenta
        }
    }
}