using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace reefersense_data.Models.StoredProcedures
{
    public class TemperatureDataLatestResult
    {
        public string? CompanyName { get; set; }

        public string? VesselId { get; set; }
        public string? VesselName { get; set; }

        public string ContainerId { get; set; } = string.Empty;

        public string? ModemImei { get; set; }
        public string? Model { get; set; }
        public string? Manufacturer { get; set; }
        public string? FirmwareVersion { get; set; }

        public short TemperatureF { get; set; }          // temperatureF
        public short? Co2Percent { get; set; }           // co2_percent
        public bool? Deforsting { get; set; }            // deforsting
        public short? HumidityPercent { get; set; }      // humidityPercent
        public short? O2Percent { get; set; }            // o2_percent
        public bool? Power { get; set; }                 // power

        public DateTime LoggedAt { get; set; }           // logged_dt
        public DateTime? ReceivedAt { get; set; }        // received_dt
    }

}
