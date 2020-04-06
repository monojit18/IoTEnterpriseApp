using IoTHubTrigger = Microsoft.Azure.WebJobs.EventHubTriggerAttribute;

using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.EventHubs;
using AZEH = Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
using System.Threading.Tasks;
using System.Text;
using System.Net.Http;
using Microsoft.Extensions.Logging;

namespace iotentsender
{
    public static class iotentsender
    {
        //  private static HttpClient client = new HttpClient();
        private static EventHubProducerClient eventProducer = null;

        [FunctionName("iotentsender")]
        public static async Task Run([IoTHubTrigger("messages/events", Connection = "IOT_HUB_CONN")]EventData message, ILogger log)
        {
            log.LogInformation($"C# IoT Hub trigger function processed a message: {Encoding.UTF8.GetString(message.Body.Array)}");

            if (message.Properties.Keys.Contains("enterpriseid") == false)
                return;

            var connectionString = Environment.GetEnvironmentVariable("EVENT_HUB_CONN");
            var eventHubNameString = Environment.GetEnvironmentVariable("EVENT_HUB_NAME");

            if (eventProducer == null)
            {
                eventProducer = new EventHubProducerClient(connectionString);

            }

            foreach (var prop in message.Properties)
                log.LogInformation($"{prop.Key} - {prop.Value}");

            var partitionKeyString = message.Properties["enterpriseid"] as string;

            var batchOptions = new CreateBatchOptions()
            {

                PartitionKey = partitionKeyString

            };

            var eventDataBatch = await eventProducer.CreateBatchAsync(batchOptions);
            var partitionKeyName = Environment.GetEnvironmentVariable("PARTITION_KEY_NAME");

            var ed = new AZEH.EventData(message.Body);
            ed.Properties.Add(partitionKeyName, partitionKeyString);

            foreach (var prop in message.Properties)
                ed.Properties.Add(prop.Key, prop.Value);

            eventDataBatch.TryAdd(ed);

            await eventProducer.SendAsync(eventDataBatch);
        }
    }
}