using Microsoft.Data.SqlClient;
using sql_server_data_access;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace iot_data_processor.Processor
{
    internal class SensorDataProcessor
    {
        private readonly IConfiguration _config;
        private readonly ILogger _logger;
        private SqlServerDatabase _sqlDatabaseConnection;

        public SensorDataProcessor(ILogger logger, IConfiguration config) 
        {
            _config = config;
            _logger = logger;
        }

        public bool Process(SensorData data)
        {
            if(_sqlDatabaseConnection == null)
            {
                CreateSqlServerDBConnection();
            }

            var response = _sqlDatabaseConnection.ExecuteScaler(CommandType.StoredProcedure,"sp_upsert_temperature_data", 30, new SqlParameter[]
            {
                new SqlParameter("@container_id", data.ContainerId),
                new SqlParameter("@modem_imei", data.ModemImei),
                new SqlParameter("@vessel_id", DBNull.Value), // vesselId is not available in the iot data context
                new SqlParameter("@temperatureF", data.GetTemperatureF()),
                new SqlParameter("@logged_dt", data.LoggedDt),
                new SqlParameter("@power", data.GetPower()),
                new SqlParameter("@battery_percent", data.GetBatteryPercent()),
                new SqlParameter("@co2_percent", data.GetCo2Percent()),
                new SqlParameter("@o2_percent", data.GetO2Percent()),
                new SqlParameter("@deforsting", data.GetDefrosting()),
                new SqlParameter("@humidityPercent", data.GetHumidityPercent())
            });

            _logger.LogInformation($"sp_upsert_temperature_data return code for container_id {data.ContainerId} is {response}");
            return response != null && Convert.ToInt16(response) == 1;
        }

        private void CreateSqlServerDBConnection()
        {
            _sqlDatabaseConnection = new SqlServerDatabase(_config["AppSettings:SqlServer:ConnectionString"]);
        }
    }
}
