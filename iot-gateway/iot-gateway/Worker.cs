using System.Net.Sockets;
using System.Net;
using System.Text;

namespace iot_gateway
{
    public class Worker : BackgroundService
    {
        private const int Port = 9000;
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _config;

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

        private async Task HandleClientAsync(TcpClient client)
        {
            NetworkStream stream = client.GetStream();
            byte[] buffer = new byte[1024];
            int bytesRead;

            try
            {
                while ((bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length)) != 0)
                {
                    string receivedMessage = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                    _logger.LogInformation("Received: " + receivedMessage);

                    // Respond back to the client
                    string response = "Message received: " + receivedMessage;
                    byte[] responseData = Encoding.UTF8.GetBytes(response);
                    await stream.WriteAsync(responseData, 0, responseData.Length);
                    _logger.LogInformation("Response sent.");
                }
            }
            catch (Exception ex)
            {
                _logger.LogInformation($"Error handling client: {ex.Message}");
            }
            finally
            {
                client.Close();
                _logger.LogInformation("Client disconnected.");
            }
        }

    }
}
