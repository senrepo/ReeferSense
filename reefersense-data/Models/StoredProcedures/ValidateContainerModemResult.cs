namespace reefersense_data.Models.StoredProcedures;

public class ValidateContainerModemResult
{
    public int ContainerIdent { get; set; }
    public string ContainerID { get; set; } = string.Empty;

    public int ModemIdent { get; set; }
    public string ModemIMEI { get; set; } = string.Empty;
    public string ModemModel { get; set; } = string.Empty;
    public string ModemManufacturer { get; set; } = string.Empty;

    public DateTime ContainerCreatedDate { get; set; }
    public DateTime ContainerUpdatedDate { get; set; }
    public DateTime ModemCreatedDate { get; set; }
    public DateTime ModemUpdatedDate { get; set; }
}
