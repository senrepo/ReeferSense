using System.Net.Sockets;
using System.Net;
using System.Text;
using Azure.Messaging.ServiceBus;

namespace iot_gateway
{
    public class Worker : BackgroundService
    {
        private const int Port = 9000;
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _config;
        private ServiceBusClient _client;
        private ServiceBusSender _sender;

        public Worker(ILogger<Worker> logger, IConfiguration config)
        {
            _logger = logger;
            _config = config;

        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            TcpListener server = new TcpListener(IPAddress.Any, Port);
            server.Start();
            _logger.LogInformation($"Server started on port {Port}");

            while (!stoppingToken.IsCancellationRequested)
            {
                TcpClient client = await server.AcceptTcpClientAsync();
                _logger.LogInformation("Client connected");

                // Handle the client asynchronously
                _ = HandleClientAsync(client);
            }

            await Task.CompletedTask;
        }

        private void CreateServiceBusConnection()
        {
            var servicebusConnString = _config["AppSettings:ServiceBus:ConnectionString"];
            var queueName = _config["AppSettings:ServiceBus:QueueName"];

            _client = new ServiceBusClient(servicebusConnString);
            _sender = _client.CreateSender(queueName);
        }

        private async Task HandleClientAsync(TcpClient client)
        {
            NetworkStream stream = client.GetStream();
            byte[] buffer = new byte[1024];
            int bytesRead;

            try
            {
                while ((bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length)) != 0)
                {
                    string hexTelegram = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                    _logger.LogInformation("Received telegram");

                    // Respond back to the client
                    string response = "ACK";
                    byte[] responseData = Encoding.UTF8.GetBytes(response);
                    await stream.WriteAsync(responseData, 0, responseData.Length);
                    _logger.LogInformation("ACK Response sent");

                    // Convert the hex string to string
                    string telegram = ConvertFromHex(hexTelegram);
                    //_logger.LogInformation("Received data: " + message);

                    // Send the message to the service bus queue
                    await SendMessageAsync(telegram);
                }
            }
            catch (Exception ex)
            {
                _logger.LogInformation($"Error handling client: {ex.Message}");
            }
            finally
            {
                client.Close();
                _logger.LogInformation("Client disconnected");
            }
        }

        private string ConvertFromHex(string hexData)
        {
            byte[] bytes = new byte[hexData.Length / 2];

            for (int i = 0; i < bytes.Length; i++)
            {
                bytes[i] = Convert.ToByte(hexData.Substring(i * 2, 2), 16);
            }

            return Encoding.UTF8.GetString(bytes);
        }

        private async Task SendMessageAsync(string message)
        {
            if(_client == null)
            {
                CreateServiceBusConnection();
            }

            try
            {
                ServiceBusMessage busMessage = new ServiceBusMessage(message);
                await _sender.SendMessageAsync(busMessage);
                _logger.LogInformation("Telegram sent to service bus queue");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending telegram to service bus queue: {ex.Message}");
            }
        }

        public override void Dispose()
        {
            base.Dispose();
            _sender.DisposeAsync();
            _client.DisposeAsync();
        }
    }
}
