//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Datos
{
    using System;
    using System.Collections.Generic;
    
    public partial class DetalleLlamada
    {
        public int id { get; set; }
        public int idDetalles { get; set; }
        public int idLlamada { get; set; }
        public double QMinutos { get; set; }
    
        public virtual Detalle Detalle { get; set; }
        public virtual LlamadaTelefonica LlamadaTelefonica { get; set; }
    }
}
