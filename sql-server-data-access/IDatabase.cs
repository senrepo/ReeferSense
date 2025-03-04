using System.Data;

namespace sql_server_data_access
{
    public interface IDatabase
    {
       IDataReader ExecuteReader (string commandText, int timeout, params IDataParameter[] parameters); 
       IDataReader ExecuteReaderStoredProcedure(string storedProcedureName, int timeout, params IDataParameter[] parameters);
       int ExecuteNonQuery(CommandType commandType, string commandText,  int timeout, params IDataParameter[] parameters);
       object ExecuteScaler(CommandType commandType, string commandText,  int timeout, params IDataParameter[] parameters);
    }
}