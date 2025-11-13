namespace reefersense_data.Models.StoredProcedures;

public class ModemGetResult
{
    public int ModemIdent { get; set; }
    public string ModemIMEI { get; set; } = string.Empty;
    public string Model { get; set; } = string.Empty;
    public string Manufacturer { get; set; } = string.Empty;
    public DateTime CreatedDate { get; set; }
    public DateTime UpdatedDate { get; set; }
}
