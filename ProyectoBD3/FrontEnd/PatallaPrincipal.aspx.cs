using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoBD3.FrontEnd
{
    public partial class PatallaPrincipal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnConsultar_Click(object sender, EventArgs e)
        {
            // Se debe de verificar que el contenido sea un número que exista (Base de datos)
            // y que sea un valor totalmente númerico (Capa lógica)
        }

        protected void lnkEmpresaX_Click(object sender, EventArgs e)
        {
            Session["codigoDeEmpresa"] = 1;
            Response.Redirect("EstadoCuentaEmpresas.aspx");
        }

        protected void lnkEmpresaY_Click(object sender, EventArgs e)
        {
            Session["codigoDeEmpresa"] = 2;
            Response.Redirect("EstadoCuentaEmpresas.aspx");
        }
    }
}