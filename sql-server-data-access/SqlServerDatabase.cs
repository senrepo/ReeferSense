using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace sql_server_data_access
{
    public class SqlServerDatabase : Database
    {
        private readonly string connectionString = string.Empty;

        public SqlServerDatabase(IConfiguration configuration)
        {
            connectionString = configuration.GetSection("DatabaseConfiguration")["ConnectionString"];
        }

        public override IDbConnection CreateDBConnection()
        {
           return new SqlConnection(connectionString);
        }
    }
}