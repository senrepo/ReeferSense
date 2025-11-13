namespace reefersense_data.Models.StoredProcedures;

public class CompanyModemGetResult
{
    public int CompanyIdent { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public DateTime CompanyCreatedDate { get; set; }
    public DateTime CompanyUpdatedDate { get; set; }

    public int ModemIdent { get; set; }
    public string ModemIMEI { get; set; } = string.Empty;
    public string Model { get; set; } = string.Empty;
    public string Manufacturer { get; set; } = string.Empty;
    public DateTime ModemCreatedDate { get; set; }
    public DateTime ModemUpdatedDate { get; set; }
}
