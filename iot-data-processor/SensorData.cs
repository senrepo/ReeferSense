using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace iot_data_processor
{
    internal class SensorData
    {
        public string? ContainerId { get; set; }
        public string? ModemImei { get; set; }
        public string? TemperatureF { get; set; }  // Changed to string
        public DateTime? LoggedDt { get; set; }
        public string? Power { get; set; }  // Changed to string
        public string? BatteryPercent { get; set; }  // Changed to string
        public string? Co2Percent { get; set; }  // Changed to string
        public string? O2Percent { get; set; }  // Changed to string
        public string? Defrosting { get; set; }  // Changed to string
        public string? HumidityPercent { get; set; }  // Changed to string

        // Helper methods to safely convert string values to numbers
        public decimal? GetTemperatureF() => decimal.TryParse(TemperatureF, out var temp) ? temp : null;
        public bool GetPower() => Power == "1"; // Assuming "1" means true, "0" means false
        public short? GetBatteryPercent() => short.TryParse(BatteryPercent, out var battery) ? battery : null;
        public short? GetCo2Percent() => short.TryParse(Co2Percent, out var battery) ? battery : null;
        public short? GetO2Percent() => short.TryParse(O2Percent, out var battery) ? battery : null;
        public bool GetDefrosting() => Defrosting == "1"; // Assuming "1" means true, "0" means false
        public short? GetHumidityPercent() => short.TryParse(HumidityPercent, out var battery) ? battery : null;
    }
}
