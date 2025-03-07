using System.Data;

namespace sql_server_data_access
{
    public interface IDatabaseHelper
    {
         IDbCommand CreateCommand(IDbConnection connection, string commandText, CommandType commandType, params IDataParameter[] parameters);
         object ExecuteScaler(IDbCommand command);
    }
}