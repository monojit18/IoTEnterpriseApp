using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.EventHubs;
using Microsoft.Azure.EventHubs.Processor;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace iotentehubapp
{
    public static class iotentreceiver
    {
        [FunctionName("iotentreceiver")]
        public static void Run([EventHubTrigger("srvlss-workshop-ehb",
                                      Connection = "EVENT_HUB_CONN", ConsumerGroup = "srvlss-workshop-enbcg")]
                                      EventData[] events,                                      
                                      ILogger log,
                                      PartitionContext partitionContext)
        {

            var partitionKeyName = Environment.GetEnvironmentVariable("PARTITION_KEY_NAME");
            foreach (EventData eventData in events)
            {

                var messageString = Encoding.UTF8.GetString(eventData.Body.ToArray());
                log.LogInformation($"Message:{messageString}");

                foreach (var prop in eventData.Properties)
                    log.LogInformation($"Key:{prop.Key} - Value:{prop.Value}");

                if (eventData.Properties.ContainsKey(partitionKeyName) == true)
                    log.LogInformation($"PartitionKey:{eventData.Properties[partitionKeyName]}");                


            }            
        }
    }
}
