namespace reefersense_data.Models.StoredProcedures;

public class ContainerGetResult
{
    public int ContainerIdent { get; set; }
    public string ContainerID { get; set; } = string.Empty;
    public DateTime CreatedDate { get; set; }
    public DateTime UpdatedDate { get; set; }
}
