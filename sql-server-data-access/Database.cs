using System.Data;

namespace sql_server_data_access
{
    public abstract class Database : IDatabase
    {
        private const int DEFAULT_TIMEOUT = 30;

        public abstract IDbConnection CreateDBConnection();

        public Database()
        {

        }

        public int ExecuteNonQuery(CommandType commandType, string commandText, int timeout = DEFAULT_TIMEOUT, params IDataParameter[] parameters)
        {
            var result = 0;

            using (var connection = CreateDBConnection())
            {
                var databaseHelper = CreateDatabaseHelper();
                var command = databaseHelper.CreateCommand(connection, commandText, commandType, parameters);
                command.CommandTimeout = timeout;
                command.Connection.Open();

                result = command.ExecuteNonQuery();
            }

            return result;
        }

        public IDataReader ExecuteReader(string commandText, int timeout = DEFAULT_TIMEOUT, params IDataParameter[] parameters)
        {
            var databaseHelper = CreateDatabaseHelper();
            var command = databaseHelper.CreateCommand(CreateDBConnection(), commandText, CommandType.Text, parameters);
            command.CommandTimeout = timeout;

            command.Connection.Open();

            return command.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public IDataReader ExecuteReaderStoredProcedure(string storedProcedureName, int timeout, params IDataParameter[] parameters)
        {
            var databaseHelper = CreateDatabaseHelper();
            var command = databaseHelper.CreateCommand(CreateDBConnection(), storedProcedureName, CommandType.StoredProcedure, parameters);
            command.CommandTimeout = timeout;

            command.Connection.Open();

            return command.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public object ExecuteScaler(CommandType commandType, string commandText, int timeout, params IDataParameter[] parameters)
        {
            using (var connection = CreateDBConnection())
            {
                var databaseHelper = CreateDatabaseHelper();
                var command = databaseHelper.CreateCommand(connection, commandText, commandType, parameters);
                command.CommandTimeout = timeout;

                return databaseHelper.ExecuteScaler(command);
            }
        }

        protected virtual IDatabaseHelper CreateDatabaseHelper()
        {
            return new DatabaseHelper();
        }
    }
}