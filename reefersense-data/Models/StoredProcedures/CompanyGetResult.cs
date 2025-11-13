namespace reefersense_data.Models.StoredProcedures;

public class CompanyGetResult
{
    public int CompanyIdent { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public DateTime CreatedDate { get; set; }
    public DateTime UpdatedDate { get; set; }
}
