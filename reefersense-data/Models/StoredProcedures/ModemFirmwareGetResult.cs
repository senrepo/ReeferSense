namespace reefersense_data.Models.StoredProcedures;

public class ModemFirmwareGetResult
{
    public int ModemIdent { get; set; }
    public string ModemIMEI { get; set; } = string.Empty;
    public string Model { get; set; } = string.Empty;
    public string Manufacturer { get; set; } = string.Empty;
    public DateTime ModemCreatedDate { get; set; }
    public DateTime ModemUpdatedDate { get; set; }

    public int FirmwareIdent { get; set; }
    public string FirmwareVersion { get; set; } = string.Empty;
    public DateTime FirmwareCreatedDate { get; set; }
    public DateTime FirmwareUpdatedDate { get; set; }

    public DateTime RelationshipCreatedDate { get; set; }
    public DateTime RelationshipUpdatedDate { get; set; }
}
