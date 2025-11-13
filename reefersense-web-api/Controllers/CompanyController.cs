using Microsoft.AspNetCore.Mvc;
using reefersense_data.Models.StoredProcedures;
using reefersense_data.Repositories;

namespace reefersense_web_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CompanyController : ControllerBase
    {
        private readonly IReeferSenseRepository _reeferSenseRepository;

        private readonly ILogger<CompanyController> _logger;

        public CompanyController(ILogger<CompanyController> logger, IReeferSenseRepository reeferSenseRepository)
        {
            _logger = logger;
            _reeferSenseRepository = reeferSenseRepository;
        }

        // GET /api/company/{companyIdent}
        [HttpGet]
        [Route("{companyIdent?}")]
        public async Task<ActionResult<List<CompanyGetResult>>> GetCompaniesAsync(int? companyIdent)
        {
            var (companies, resultCode) = await _reeferSenseRepository.GetCompaniesAsync(companyIdent);

            return Ok(new
            {
                ResultCode = resultCode,
                Data = companies
            });
        }

        // GET /api/company/{companyIdent}/modem/{modemImei}
        [HttpGet("{companyIdent}/modem/{modemImei?}")]
        public async Task<ActionResult<List<CompanyModemGetResult>>> GetCompanyModemAsync(int companyIdent, string? modemImei)
        {
            var (CompanyModems, resultCode) = await _reeferSenseRepository
                .GetCompanyModemAsync(companyIdent, modemImei);

            return Ok(new
            {
                ResultCode = resultCode,
                Data = CompanyModems
            });
        }

        // GET /api/company/{companyIdent}/Vessel/{vesselId}
        [HttpGet("{companyIdent}/vessel/{vesselId?}")]
        public async Task<ActionResult<List<CompanyVesselGetResult>>> GetCompanyVesselAsync(int companyIdent, string? vesselId)
        {
            var (CompanyModems, resultCode) = await _reeferSenseRepository
                .GetCompanyVesselAsync(companyIdent, vesselId);

            return Ok(new
            {
                ResultCode = resultCode,
                Data = CompanyModems
            });
        }
    }
}
