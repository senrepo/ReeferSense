namespace reefersense_data.Models.StoredProcedures;

public class VesselGetResult
{
    public int VesselIdent { get; set; }
    public string VesselID { get; set; } = string.Empty;
    public string VesselName { get; set; } = string.Empty;
    public DateTime CreatedDate { get; set; }
    public DateTime UpdatedDate { get; set; }
}
