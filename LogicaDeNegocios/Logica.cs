using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Datos;

namespace LogicaDeNegocios
{
    public class Logica
    {
        ProyectoBD3Entities database = new ProyectoBD3Entities();

        public List<ListarEstadosDeCuentas_Result> recuperarEstadosDeCuenta(int CodigoDeEmpresa)
        {
            // Creación de parámetros SQL
            var CodigoDeEmpresaParam = new SqlParameter("@inCodigoEmpresa", CodigoDeEmpresa);
            var resultCodeParam = new SqlParameter
            {
                ParameterName = "@outResultCode",
                SqlDbType = SqlDbType.Int,
                Direction = ParameterDirection.Output
            };

            // Ejecutar el procedimiento almacenado y obtener la lista de resultados
            var EstadosDeCuenta = database.Database.SqlQuery<ListarEstadosDeCuentas_Result>(
                "EXEC ListarEstadosDeCuentas @inCodigoEmpresa, @outResultCode OUTPUT",
                CodigoDeEmpresaParam, resultCodeParam).ToList();

            // Opcional: manejar el valor de @outResultCode si es necesario
            // int resultCode = (int)resultCodeParam.Value;

            return EstadosDeCuenta;
        }

        public List<ListarLlamadasEstadoDeCuenta_Result> recuperarLlamadasDeEstadoDeCuenta(int CodigoDeEmpresa, string FechaDeEstadoDeCuenta)
        {
            var CodigoDeEmpresaParam = new SqlParameter("@inCodigoEmpresa", CodigoDeEmpresa);
            var FechaDeEstadoDeCuentaParam = new SqlParameter("@inFechaDeEstadoDeCuenta", FechaDeEstadoDeCuenta);
            var resultCodeParam = new SqlParameter
            {
                ParameterName = "@outResultCode",
                SqlDbType = SqlDbType.Int,
                Direction = ParameterDirection.Output
            };

            var llamadasEstadoDeCuenta = database.Database.SqlQuery<ListarLlamadasEstadoDeCuenta_Result>(
                "EXEC ListarLlamadasEstadoDeCuenta @inFechaDeEstadoDeCuenta, @inCodigoEmpresa, @outResultCode OUTPUT",
                FechaDeEstadoDeCuentaParam, CodigoDeEmpresaParam, resultCodeParam).ToList();

            return llamadasEstadoDeCuenta;
        }

        

    }
}
