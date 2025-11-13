using Microsoft.AspNetCore.Mvc;
using reefersense_data.Models.StoredProcedures;
using reefersense_data.Repositories;

namespace reefersense_web_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TemperatureDataController : Controller
    {
        private readonly IReeferSenseRepository _reeferSenseRepository;
        private readonly ILogger<TemperatureDataController> _logger;

        public TemperatureDataController(ILogger<TemperatureDataController> logger, IReeferSenseRepository reeferSenseRepository)
        {
            _logger = logger;
            _reeferSenseRepository = reeferSenseRepository;
        }

        [HttpGet]
        [Route("latest/{pageNumber?}/{pageSize?}")]
        public async Task<ActionResult<List<TemperatureDataLatestResult>>> GetLatestDataAsync(int? pageNumber, int? pageSize)
        {
            var (data, totalCount) = await _reeferSenseRepository.GetTemperatureDataLatestAsync(pageNumber, pageSize);

            return Ok(new
            {
                TotalCount = totalCount,
                Data = data
            });
        }
    }
}
