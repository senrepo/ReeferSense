namespace reefersense_data.Models.StoredProcedures;

public class CompanyVesselGetResult
{
    public int CompanyIdent { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public DateTime CompanyCreatedDate { get; set; }
    public DateTime CompanyUpdatedDate { get; set; }

    public int VesselIdent { get; set; }
    public string VesselID { get; set; } = string.Empty;
    public string VesselName { get; set; } = string.Empty;
    public DateTime VesselCreatedDate { get; set; }
    public DateTime VesselUpdatedDate { get; set; }
}
