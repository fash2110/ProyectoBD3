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
    
    public partial class Factura
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Factura()
        {
            this.Detalles = new HashSet<Detalle>();
        }
    
        public int id { get; set; }
        public int idContrato { get; set; }
        public System.DateTime Fecha { get; set; }
        public System.DateTime FechaPago { get; set; }
        public int TotalAntesIVA { get; set; }
        public int TotalConIVA { get; set; }
        public Nullable<int> TotalConPendiente { get; set; }
        public Nullable<bool> Pagado { get; set; }
    
        public virtual Contrato Contrato { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Detalle> Detalles { get; set; }
    }
}
