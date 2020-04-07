using System;
using System.Text;
using System.IO;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Devices.Client;

namespace iotenthttp
{
    public static class iotenthttp
    {

        private static DeviceClient kDeviceClient = null;        
        private static Dictionary<string, DeviceClient> kDeviceConnectionDictionary = null;

        private static async Task SendDeviceToCloudMessagesAsync(string messageString,
                                                                    string enterpriseIdString,
                                                                 DeviceClient deviceClient)
        {

            var message = new Message(Encoding.ASCII.GetBytes(messageString));            
            message.Properties.Add("enterpriseid", enterpriseIdString);           
            deviceClient?.SendEventAsync(message);

        }

        [FunctionName("iotenthttp")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequest req,
            ILogger log)
        {

            log.LogInformation("C# HTTP trigger function processed a request.");

            var deviceIdString = Environment.GetEnvironmentVariable("DEVICE_ID_1");
            if (req.Headers.ContainsKey("device-id"))
                deviceIdString = req.Headers["device-id"];
            
            string enterpriseIdString = string.Empty;
            if (req.Headers.ContainsKey("enterpriseid"))
                enterpriseIdString = req.Headers["enterpriseid"]; 

            string messageString = await new StreamReader(req.Body).ReadToEndAsync();
            log.LogInformation(messageString);

            if (kDeviceClient == null)
            {

                var deviceConnString = Environment.GetEnvironmentVariable("CONN_DEVICE_1");
                kDeviceClient = DeviceClient.CreateFromConnectionString(deviceConnString,
                                                                        TransportType.Mqtt);
            }

            if (kDeviceConnectionDictionary == null)
            {

                var deviceId1String = Environment.GetEnvironmentVariable("DEVICE_ID_1");
                kDeviceConnectionDictionary = new Dictionary<string, DeviceClient>()
                {

                    [deviceId1String] = kDeviceClient                    
                };

            }

            var deviceClient = kDeviceConnectionDictionary[deviceIdString];
            await SendDeviceToCloudMessagesAsync(messageString, enterpriseIdString,
                                                    deviceClient);

            log.LogInformation($"Done:{DateTime.Now.ToLongTimeString()}");
            return new OkObjectResult("OK");
        }
    }
}
