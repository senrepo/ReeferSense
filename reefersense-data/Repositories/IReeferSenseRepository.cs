using System.Collections.Generic;
using System.Threading.Tasks;
using reefersense_data.Models.StoredProcedures;

namespace reefersense_data.Repositories;

public interface IReeferSenseRepository
{
    // Read operations (sp_get_*)
    Task<(List<CompanyGetResult> companies, int? resultCode)> GetCompaniesAsync(int? companyIdent);
    Task<(List<CompanyModemGetResult> companyModems, int? resultCode)> GetCompanyModemAsync(int companyIdent, string? modem_imei);
    Task<(List<CompanyVesselGetResult> companyVessels, int? resultCode)> GetCompanyVesselAsync(int companyIdent, string? vesselId);
    Task<(List<TemperatureDataLatestResult>, int totalCount)> GetTemperatureDataLatestAsync(int? pageNumber, int? pageSize);

    //    Task<List<ContainerGetResult>> GetContainersAsync(string? containerId);
    //    Task<List<ModemGetResult>> GetModemsAsync(string? modemImei);
    //    Task<List<ModemFirmwareGetResult>> GetModemFirmwareAsync(int modemIdent, int firmwareIdent);
    //    Task<List<UserGetResult>> GetUsersAsync(string? userId);
    //    Task<List<VesselGetResult>> GetVesselsAsync(string? vesselId);
    //    Task<List<ValidateContainerModemResult>> ValidateContainerModemAsync(string containerId, string modemImei);

    //    // Write / maintenance operations (upsert / onboard / cleanup / temperature)
    //    Task<int> CleanupCompanyContainerModemAsync(string companyName, string containerId, string imei);
    //    Task<int> OnboardCompanyContainerModemAsync(string companyName, string containerId, string imei);

    //    Task<int> UpsertCompanyAsync(string companyName, int? companyIdent);
    //    Task<int> UpsertCompanyModemAsync(int companyIdent, int modemIdent, int? companyModemIdent);
    //    Task<int> UpsertCompanyVesselAsync(int companyIdent, int vesselIdent, int? companyVesselIdent);
    //    Task<int> UpsertContainerAsync(string containerId, int? containerIdent);
    //    Task<int> UpsertModemAsync(string modemImei, string model, string manufacturer, int? modemIdent);
    //    Task<int> UpsertModemFirmwareAsync(int modemIdent, int firmwareIdent, int? modemFirmwareIdent);
    //    Task<int> UpsertTemperatureDataAsync(
    //        string containerId,
    //        string? modemImei,
    //        string? vesselId,
    //        short temperatureF,
    //        System.DateTime loggedAt,
    //        bool power,
    //        short batteryPercent,
    //        short co2Percent,
    //        short o2Percent,
    //        bool deforsting,
    //        short humidityPercent);
    //    Task<int> UpsertUserAsync(string userId, string firstName, string lastName, bool isActive, int? userIdent);
    //    Task<int> UpsertVesselAsync(string vesselId, string vesselName, int? vesselIdent);
}
