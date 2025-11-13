using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using reefersense_data.Context;
using reefersense_data.Models.StoredProcedures;

namespace reefersense_data.Repositories;

public class ReeferSenseRepository : IReeferSenseRepository
{
    private readonly ReeferSenseDbContext _context;

    public ReeferSenseRepository(ReeferSenseDbContext context)
    {
        _context = context;
    }

    // ========== READ (sp_get_*) ==========

    public async Task<(List<CompanyGetResult> companies, int? resultCode)> GetCompaniesAsync(int? companyIdent)
    {
        // Input parameter
        var companyIdentParam = new SqlParameter("@company_ident", companyIdent ?? (object)DBNull.Value);

        // Output parameter
        var resultParam = new SqlParameter
        {
            ParameterName = "@result",
            SqlDbType = System.Data.SqlDbType.Int,
            Direction = System.Data.ParameterDirection.Output
        };

        // EXEC statement
        var companies = await _context.Set<CompanyGetResult>()
            .FromSqlRaw("EXEC dbo.sp_get_company @company_ident = @company_ident, @result = @result OUTPUT",
                        companyIdentParam, resultParam)
            .AsNoTracking()
            .ToListAsync();

        //return the results
        int? resultCode = (int?)(resultParam.Value ?? null);
        return (companies, resultCode);
    }

    public async Task<(List<CompanyModemGetResult> companyModems, int? resultCode)> GetCompanyModemAsync(int companyIdent, string? modemImei)
    {
        // Input parameters
        var companyIdentParam = new SqlParameter("@company_ident", companyIdent);
        var modemImeiParam = new SqlParameter("@modem_imei", modemImei ?? (object)DBNull.Value);

        // Output parameter
        var resultParam = new SqlParameter
        {
            ParameterName = "@result",
            SqlDbType = System.Data.SqlDbType.Int,
            Direction = System.Data.ParameterDirection.Output
        };

        // EXEC must match your ALTER PROCEDURE signature exactly
        var companyModems = await _context.Set<CompanyModemGetResult>()
            .FromSqlRaw(
                "EXEC dbo.sp_get_company_modem " +
                "@company_ident = @company_ident, " +
                "@modem_imei = @modem_imei, " +
                "@result = @result OUTPUT",
                companyIdentParam, modemImeiParam, resultParam)
            .AsNoTracking()
            .ToListAsync();

        int? resultCode = resultParam.Value == DBNull.Value ? null : (int?)resultParam.Value;

        return (companyModems, resultCode);
    }

    public async Task<(List<CompanyVesselGetResult> companyVessels, int? resultCode)> GetCompanyVesselAsync( int companyIdent, string? vesselId)
    {
        // Input parameters
        var companyIdentParam = new SqlParameter("@company_ident", System.Data.SqlDbType.Int)
        {
            Value = companyIdent
        };

        var vesselIdParam = new SqlParameter("@vessel_id", System.Data.SqlDbType.VarChar, 50) // adjust size to match DB
        {
            Value = (object?)vesselId ?? DBNull.Value
        };

        // Output parameter
        var resultParam = new SqlParameter
        {
            ParameterName = "@result",
            SqlDbType = System.Data.SqlDbType.Int,
            Direction = System.Data.ParameterDirection.Output
        };

        // Execute stored procedure and map result set
        var companyVessels = await _context.Set<CompanyVesselGetResult>()
            .FromSqlRaw(
                "EXEC dbo.sp_get_company_vessel " +
                "@company_ident = @company_ident, " +
                "@vessel_id = @vessel_id, " +
                "@result = @result OUTPUT",
                companyIdentParam, vesselIdParam, resultParam)
            .AsNoTracking()
            .ToListAsync();

        int? resultCode = resultParam.Value == DBNull.Value ? null : (int?)resultParam.Value;

        return (companyVessels, resultCode);
    }

    public async Task<(List<TemperatureDataLatestResult>, int totalCount)> GetTemperatureDataLatestAsync(int? pageNumber, int? pageSize)
    {
        // Input parameters
        var pageNumberParam = new SqlParameter("@pageNumber", pageNumber ?? (object)DBNull.Value);
        var pageSizeParam = new SqlParameter("@pageSize", pageSize ?? (object)DBNull.Value);

        // Output parameter
        var totalCountParam = new SqlParameter
        {
            ParameterName = "@totalCount",
            SqlDbType = System.Data.SqlDbType.Int,
            Direction = System.Data.ParameterDirection.Output
        };

        // Execute stored procedure and map result set
        var latestData = await _context.Set<TemperatureDataLatestResult>()
                         .FromSqlRaw(
                            "EXEC dbo.sp_get_temperature_data_latest " +
                             "@pageNumber = @pageNumber, " +
                             "@pageSize = @pageSize, " +
                             "@totalCount = @totalCount OUTPUT",
                             pageNumberParam, pageSizeParam, totalCountParam
                         ).AsNoTracking().ToListAsync();

        var totalCount = (int)totalCountParam.Value;

        return (latestData, totalCount);
    }


    //public Task<List<ContainerGetResult>> GetContainersAsync(string? containerId)
    //{
    //    return _context.Containers
    //        .FromSqlRaw("EXEC dbo.sp_get_container @container_id = {0}", containerId)
    //        .ToListAsync();
    //}

    //public Task<List<ModemGetResult>> GetModemsAsync(string? modemImei)
    //{
    //    return _context.Modems
    //        .FromSqlRaw("EXEC dbo.sp_get_modem @modem_imei = {0}", modemImei)
    //        .ToListAsync();
    //}

    //public Task<List<ModemFirmwareGetResult>> GetModemFirmwareAsync(int modemIdent, int firmwareIdent)
    //{
    //    return _context.ModemFirmwares
    //        .FromSqlRaw("EXEC dbo.sp_get_modem_firmware @modem_ident = {0}, @firmware_ident = {1}", modemIdent, firmwareIdent)
    //        .ToListAsync();
    //}

    //public Task<List<UserGetResult>> GetUsersAsync(string? userId)
    //{
    //    return _context.Users
    //        .FromSqlRaw("EXEC dbo.sp_get_user @user_id = {0}", userId)
    //        .ToListAsync();
    //}

    //public Task<List<VesselGetResult>> GetVesselsAsync(string? vesselId)
    //{
    //    return _context.Vessels
    //        .FromSqlRaw("EXEC dbo.sp_get_vessel @vessel_id = {0}", vesselId)
    //        .ToListAsync();
    //}

    //public Task<List<ValidateContainerModemResult>> ValidateContainerModemAsync(string containerId, string modemImei)
    //{
    //    return _context.ValidateContainerModems
    //        .FromSqlRaw(
    //            "EXEC dbo.sp_get_validate_container_modem @container_id = {0}, @modem_imei = {1}",
    //            containerId,
    //            modemImei)
    //        .ToListAsync();
    //}

    //// ========== WRITE / MAINTENANCE (sp_cleanup_*, sp_onboard_*, sp_upsert_*) ==========

    //public Task<int> CleanupCompanyContainerModemAsync(string companyName, string containerId, string imei)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_cleanup_company_container_modem @input_company_name = {0}, @input_container_id = {1}, @input_imei_no = {2}",
    //        companyName,
    //        containerId,
    //        imei);
    //}

    //public Task<int> OnboardCompanyContainerModemAsync(string companyName, string containerId, string imei)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_onboard_company_container_modem @input_company_name = {0}, @input_container_id = {1}, @input_imei_no = {2}",
    //        companyName,
    //        containerId,
    //        imei);
    //}

    //public Task<int> UpsertCompanyAsync(string companyName, int? companyIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_company @company_name = {0}, @company_ident = {1}",
    //        companyName,
    //        companyIdent);
    //}

    //public Task<int> UpsertCompanyModemAsync(int companyIdent, int modemIdent, int? companyModemIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_company_modem @company_ident = {0}, @modem_ident = {1}, @company_modem_ident = {2}",
    //        companyIdent,
    //        modemIdent,
    //        companyModemIdent);
    //}

    //public Task<int> UpsertCompanyVesselAsync(int companyIdent, int vesselIdent, int? companyVesselIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_company_vessel @company_ident = {0}, @vessel_ident = {1}, @company_vessel_ident = {2}",
    //        companyIdent,
    //        vesselIdent,
    //        companyVesselIdent);
    //}

    //public Task<int> UpsertContainerAsync(string containerId, int? containerIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_container @container_id = {0}, @container_ident = {1}",
    //        containerId,
    //        containerIdent);
    //}

    //public Task<int> UpsertModemAsync(string modemImei, string model, string manufacturer, int? modemIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_modem @modem_imei = {0}, @model = {1}, @manufacturer = {2}, @modem_ident = {3}",
    //        modemImei,
    //        model,
    //        manufacturer,
    //        modemIdent);
    //}

    //public Task<int> UpsertModemFirmwareAsync(int modemIdent, int firmwareIdent, int? modemFirmwareIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_modem_firmware @modem_ident = {0}, @firmware_ident = {1}, @modem_firmware_ident = {2}",
    //        modemIdent,
    //        firmwareIdent,
    //        modemFirmwareIdent);
    //}

    //public Task<int> UpsertTemperatureDataAsync(
    //    string containerId,
    //    string? modemImei,
    //    string? vesselId,
    //    short temperatureF,
    //    DateTime loggedAt,
    //    bool power,
    //    short batteryPercent,
    //    short co2Percent,
    //    short o2Percent,
    //    bool deforsting,
    //    short humidityPercent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_temperature_data " +
    //        "@container_id = {0}, @modem_imei = {1}, @vessel_id = {2}, " +
    //        "@temperatureF = {3}, @logged_dt = {4}, @power = {5}, " +
    //        "@battery_percent = {6}, @co2_percent = {7}, @o2_percent = {8}, " +
    //        "@deforsting = {9}, @humidityPercent = {10}",
    //        containerId,
    //        modemImei,
    //        vesselId,
    //        temperatureF,
    //        loggedAt,
    //        power,
    //        batteryPercent,
    //        co2Percent,
    //        o2Percent,
    //        deforsting,
    //        humidityPercent);
    //}

    //public Task<int> UpsertUserAsync(string userId, string firstName, string lastName, bool isActive, int? userIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_user @user_id = {0}, @first_name = {1}, @last_name = {2}, @active = {3}, @user_ident = {4}",
    //        userId,
    //        firstName,
    //        lastName,
    //        isActive,
    //        userIdent);
    //}

    //public Task<int> UpsertVesselAsync(string vesselId, string vesselName, int? vesselIdent)
    //{
    //    return _context.Database.ExecuteSqlRawAsync(
    //        "EXEC dbo.sp_upsert_vessel @vessel_id = {0}, @vessel_name = {1}, @vessel_ident = {2}",
    //        vesselId,
    //        vesselName,
    //        vesselIdent);
    //}
}
