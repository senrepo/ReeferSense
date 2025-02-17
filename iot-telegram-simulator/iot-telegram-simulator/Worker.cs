using System.Text;
using System.IO;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Options;
using System.Threading;
using System.Net.Sockets;

namespace iot_telegram_simulator
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _config;
        private readonly string _serverAddress;
        private readonly int _port;

        public Worker(ILogger<Worker> logger, IConfiguration config)
        {
            _logger = logger;
            _config = config;

            _serverAddress = _config["AppSettings:ServerAddress"];
            _port = int.Parse(_config["AppSettings:Port"]);
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            string fileName = string.Empty;
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using (TcpClient client = new TcpClient(_serverAddress, _port))
                    using (NetworkStream stream = client.GetStream())
                    {
                        _logger.LogInformation("Connected to server.");

                        while (!stoppingToken.IsCancellationRequested)
                        {
                            string directoryPath = $"{AppDomain.CurrentDomain.BaseDirectory}/data";

                            foreach (string file in Directory.GetFiles(directoryPath, "*.json"))
                            {
                                var hexString = GetJsonFileHex(file);
                                fileName = Path.GetFileName(file);

                                // Send message to server
                                byte[] data = Encoding.UTF8.GetBytes(hexString);
                                stream.Write(data, 0, data.Length);
                                _logger.LogInformation($"Telegram sent for {fileName}");

                                // Receive response from server
                                byte[] buffer = new byte[1024];
                                int bytesRead = stream.Read(buffer, 0, buffer.Length);
                                string response = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                                _logger.LogInformation($"Server acknowledged for {fileName}");
                            }

                            if (stoppingToken.IsCancellationRequested)
                            {
                                _logger.LogWarning("Cancellation Requested, exiting operation.");
                                break;
                            }

                            await Task.Delay(TimeSpan.FromSeconds(10));
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error occurred: {ex.Message}. Attempting to reconnect...");

                    // Wait before trying to reconnect to avoid excessive retry attempts
                    await Task.Delay(TimeSpan.FromSeconds(10));
                }
            }

            await Task.CompletedTask;
        }


        private string GetJsonFileHex(string filePath)
        {
            string hexString = string.Empty;

            if (File.Exists(filePath))
            {
                try
                {
                    string jsonContent = File.ReadAllText(filePath);
                    var json = JsonNode.Parse(jsonContent);
                    json["logged"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ");
                    hexString = ConvertToHex(jsonContent);

                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error processing file {Path.GetFileName(filePath)} {Environment.NewLine} {ex.Message} {Environment.NewLine} {ex.StackTrace}");
                }
            }

            return hexString;
        }


        private string ConvertToHex(string input)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input);
            StringBuilder hexBuilder = new StringBuilder(bytes.Length * 2);

            foreach (byte b in bytes)
            {
                hexBuilder.AppendFormat("{0:X2}", b);
            }

            return hexBuilder.ToString();
        }
    }
}
