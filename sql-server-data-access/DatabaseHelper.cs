using System;
using System.Data;

namespace sql_server_data_access
{
    public class DatabaseHelper : IDatabaseHelper
    {
        public IDbCommand CreateCommand(IDbConnection connection, string commandText, CommandType commandType, params IDataParameter[] parameters)
        {
            if(connection == null) throw new ArgumentNullException("database connection");
            if(string.IsNullOrEmpty(commandText)) throw new ArgumentNullException("commandText");

            IDbCommand command = connection.CreateCommand();
            command.CommandText = commandText;
            command.CommandType = commandType;

            if(parameters != null && parameters.Length > 0)
            {
                for(int index = 0; index < parameters.Length; ++index)
                {
                    parameters[index].SourceColumn = parameters[index].ParameterName.TrimStart('@');
                }
            }

            AttachParameters(command, parameters);

            return command;
        }

        public object ExecuteScaler(IDbCommand command)
        {
            var isConnectionOpened = false;
            if(command.Connection.State != ConnectionState.Open)
            {
                command.Connection.Open();
                isConnectionOpened = true;
            }

            var result = command.ExecuteScalar();

            if(isConnectionOpened) command.Connection.Close();

            return result;
        }

        private void AttachParameters(IDbCommand command, IDataParameter[] parameters)
        {
            foreach(var parameter in parameters)
            {
                if( (parameter.Direction == ParameterDirection.Input || parameter.Direction == ParameterDirection.InputOutput )
                && parameter.Value == null)
                {
                    parameter.Value = DBNull.Value;
                }
                command.Parameters.Add(parameter);
            }
        }
    }
}