using Azure.Messaging.ServiceBus;
using iot_data_processor.Processor;
using iot_data_processor.Validators;
using Microsoft.Extensions.Configuration;
using System.Text.Json;

namespace iot_data_processor
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _config;
        private readonly string _serviceBusConnectionString;
        private readonly string _queueName;

        private ServiceBusClient _client;
        private ServiceBusProcessor _processor;

        private List<IValidator> _validators = new List<IValidator>
            {
                new ContainerValidator(),
                new ModemValidator()
            };
        private readonly SensorDataProcessor _sensorDataProcessor;

        public Worker(ILogger<Worker> logger, IConfiguration config)
        {
            _logger = logger;
            _serviceBusConnectionString = config["AppSettings:ServiceBus:ConnectionString"];
            _queueName = config["AppSettings:ServiceBus:QueueName"];

            _client = new ServiceBusClient(_serviceBusConnectionString);
            _processor = _client.CreateProcessor(_queueName, new ServiceBusProcessorOptions {
                AutoCompleteMessages = false
            });

            _sensorDataProcessor = new SensorDataProcessor();
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _processor.ProcessMessageAsync += ProcessMessageHandler;
            _processor.ProcessErrorAsync += ErrorHandler;

            await _processor.StartProcessingAsync(stoppingToken);

            while (stoppingToken.IsCancellationRequested)
            {
                await _processor.StopProcessingAsync(stoppingToken);
            }
        }

        private async Task ProcessMessageHandler(ProcessMessageEventArgs args)
        {
            string body = args.Message.Body.ToString();
            _logger.LogInformation($"Received telegram: {body}");

            try
            {
                var data = JsonSerializer.Deserialize<SensorData>(body, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                if (!ValidateData(data))
                {
                    _logger.LogWarning("Invalid telegram, moving to dead-letter queue...");
                    await args.DeadLetterMessageAsync(args.Message, "Invalid telegram");
                    return;
                }

                ProcessData(data);
                await args.CompleteMessageAsync(args.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error processing telegram: {ex.Message}");
                await args.DeadLetterMessageAsync(args.Message, "Processing error");
            }

        }

        private async Task ErrorHandler(ProcessErrorEventArgs args)
        {
            _logger.LogError($"Error in Service Bus processing: {args.Exception.Message}");
            await Task.CompletedTask;
        }

        private async Task StopAsync(CancellationToken cancellationToken)
        {
            await _processor.StopProcessingAsync(cancellationToken);
            await _client.DisposeAsync();
            await base.StopAsync(cancellationToken);
        }

        private bool ValidateData(SensorData data)
        {


            foreach (var validator in _validators)
            {
                if (!validator.Validate(data))
                {
                    return false;
                }
            }

            return true;
        }

        private bool ProcessData(SensorData data)
        {
            bool result = _sensorDataProcessor.Process(data);

            _logger.Log(result ? LogLevel.Information : LogLevel.Error, result ? "Data processed successfully." : "Error processing data.");

            return result;
        }
    }
}
