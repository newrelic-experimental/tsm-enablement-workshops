# Activity 3

In the previous activity you configured the collector to gather, process and transmit metrics. This activity focuses on logs.

## Task 1: Configure the colector to gather and transmit logs from file

In order to gather data from file we need a receiver that will watch the file for changes and report them. The [File Log Receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/filelogreceiver) does just this and has plenty of configurable options for shipping log file data. 

In this task you will onfigure the collector to ship data using this receiver from a single file `custom.log` to New Relic.

1. Review the documentation for the [File Log Receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/filelogreceiver)
2. In the receivers section of `collector_config.yaml` add a new configuration block to configure the receveiver to watch the `custom.log` file:

```
receivers:
  # ... (existing config) ...
  filelog/custom_file:
    include:
      - /workspace/custom.log
```

> `filelog:` should be indented at the same level as `hostmetrics:` in the `recievers:` block

3. Add the reference to the filelog receiver in the `receviers:` list of the logs pipeline in the `services:` block:
```
service:
  pipelines:
    # ... (other config) ...
    logs:
      receivers: [filelog/custom_file]
      processors: []
      exporters: [otlp/newrelic]
```

4. Restart the collector and check the `collector.log` log for any errors
```
./collector.sh restart
```

5. Generate some test data:
```
./collector.sh generate_log_entry
```
> This will add some data to the `custom.log` file

6. Confirm the log data is received in New Relic:
```
from Log select * where demo='otel-collector-demo'
```

> You could also use the logs UI to look for received data.


## Task 2: Add debugger
To understand what is happening in the following tasks its useful to be able to see whats happening in the collector pipeline. Adding a [debug exporter](https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/debugexporter/README.md) can help with this:


1. Add the [debug exporter](https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/debugexporter/README.md) to the `exporters:` block:
```
exporters:
  # ... existing config...
  debug:
    verbosity: detailed
```

2. Add the debug exporter to the list of exporters for the log pipeline

```
service:
  pipelines:
    # ... other config...
    logs:
      receivers: [filelog/custom_file]
      processors: []
      exporters: [otlp/newrelic,debug]
```

3. Restart the collector and generate some logs
```
./collector.sh restart
./collector.sh generate_log_entry
```

4. View the collector.log file

Observe that each log line is reported spereately and for each there is a `Body` and a single attribute `log.file.name`. eg.:
```
Body: Str({"uuid":"d864f2bf-ee34-4016-ae1b-79e4a072267c","log":"INFO: This data is just some generated data","demo":"otel-collector-demo","clientId":"112233"})
Attributes:
     -> log.file.name: Str(custom.log)
```     


## Task 3: Remove unnecessary attributes from the log messages

Each log line in our exmple log data is a valid JSON string. New Relic receives this and converts each attribute into a seperately addressable columns in the data.
Sometimes you may want to filter out, or 'drop' attributes that don't offer any value. For instance in the example log data the `clientId` field is always the same. Lets drop this from the ingest data before we send it.

There are many ways to solve this, in this case we will use two processors: first we need to convert the log line string to a set of attributes and then we need to drop the attributes we do not need. 

1. Add a new [transform processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/transformprocessor/README.md) to the `processors:` block called `logs_to_attributes`

```
processors:
  # ... other config ... 
  transform/logs_to_attributes:
    log_statements:
    - context: log
      statements:
          - merge_maps(attributes, ParseJSON(body), "upsert")
          - set(body, "")
```
> This processor transforms log lines. The log line body is converted to attributes using [`ParseJSON()`](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/ottl/ottlfuncs/README.md#parsejson). We then discard the body.

2. Add the transform processor reference to the list of `processors:` for the logs pipeline:

```
service:
  pipelines:
    # ... other config ...
    logs:
      receivers: [filelog/custom_file]
      processors: [transform/logs_to_attributes]
      exporters: [otlp/newrelic,debug]
```

3. Restart the collector and generate some logs
```
./collector.sh restart
./collector.sh generate_log_entry
```

4. Confirm the log data has been converted to attributes by viewing the collector.log file:
You should now observe that the shape of the log data has changed. The individual attributes of the json object are now OTel attributes and the Body is empty. e.g:

```
Body: Str()
Attributes:
     -> log.file.name: Str(custom.log)
     -> uuid: Str(e410d575-8648-4b3f-b10c-8e5785be06a5)
     -> log: Str(INFO: This data is just some generated data)
     -> demo: Str(otel-collector-demo)
     -> clientId: Str(112233)
```

5. Add an [attributes processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/attributesprocessor) to the `processors:` block:

```
processors:
  # ... other config ...
  attributes/remove_unnecessary:
    actions:
      - key: clientId
        action: delete
```

> The attributes processor lets us manipulate the attributes. Here we are simply deleting all the `clientId` attributes

6. Add the attribute processor reference to the list of `processors:` for the logs pipeline:

```
service:
  pipelines:
    # ... other config ...
    logs:
      receivers: [filelog/custom_file]
      processors: [transform/logs_to_attributes,attributes/remove_unnecessary]
      exporters: [otlp/newrelic,debug]
```
> Be sure to add the attribute removal processor *after* the logs transformation processor

7.  Restart the collector and generate some logs
```
./collector.sh restart
./collector.sh generate_log_entry
```

8. Observe the clientId attribute has been dropped both in the `collector.log` debug log and in New Relic ingested data:
```
from Log select uuid, message, clientId where demo='otel-collector-demo'
```

## Task 4: Batching log delivery

This is only a toy example, but in larger scale systems there may be a lot of data that needs delivering. You can control how the data is batched and sent to New Relic to improve the efficiency of the data delivery. It is generally recommended to implement some batching.

1. View the existing log line batch information

When you generate the logs there is a short two second delay artifically introduced between lines 4 and 5. When you view your existing logs in New Relic, observe that the field `newrelic.logs.batchIndex` indicates the index of the record in the batch of logs received. You should see that the first four log lines are indexed 1-4 but the fifth log line has an index of 1. This tells us that the fifth line was received in a different batch to the first four.

```
from Log select uuid, newrelic.logs.batchIndex, message where demo='otel-collector-demo' 
```

2. Add a [batch processor](https://github.com/open-telemetry/opentelemetry-collector/blob/main/processor/batchprocessor/README.md) to the `processors:` block with a five second timeout:

```
processors:
  # ... existing config ...
  batch:
    timeout: 5s
```
> The batch can be configured by both size and time, in this case we simply set to 5 seconds, which is enough time (usually) for all 5 log lines to be batched and sent together. The default is 200ms.

3. Add the batch processor reference to the list of `processors:` for the logs pipeline:
```
service:
  pipelines:
    # ... other config ...
    logs:
      receivers: [filelog/custom_file]
      processors: [transform/logs_to_attributes,attributes/remove_unnecessary,batch]
      exporters: [otlp/newrelic,debug]
```

4.  Restart the collector and generate some logs
```
./collector.sh restart
./collector.sh generate_log_entry
```

5. Observe the logs are received in the same batch in New Relic
```
from Log select uuid, newrelic.logs.batchIndex, message where demo='otel-collector-demo' 
```

> You should see that the fifth log line is now indexed 5 in the batch *most of the time.* (It may sometimes stil lcome in the next batch depending on the timing of running the commands)

> This was just a demonstration of the batch processor. The File Log receiver has controls over polling interval too that may be useful.


## Challenge 1: Maniplating data before ingest
You may notice that some of the log lines include a `price` attribute. This value is currently a string. In order to easily perform math functions on it when its received it would be good to convert it to a number. 

Use what you have learnt already about the [attributes processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/attributesprocessor) to convert the `price` field on those records to a `double` type.

> Hint: You can use this query to determine if the value type has been successfully changed. Once its been changed the `price*10` column should have a value that is 10 times larger than the `price` value:
> ```from Log select uuid, price, price * 10 where demo='otel-collector-demo' and price is not null```

<details>
<summary>More hints for challenge 1!</summary>

> Hint: You can use the existing attribute processor or add a new one. Why might a new one be better? 

> Hint: Don't forget to add your processor to the logs pipeline processor list!

</details>

<details>
<summary>Challenge 1 Solution</summary>

One way to achieve this result is to add an attributes processor using the `convert` action. Add a new attributes processor to the `processors:` block:

```
processors:
  # ... other config ...
  attributes/convert_price:
    actions:
      - key: price
        action: convert
        converted_type: double
```

And remember to add the reference to the processor top the log pipeline processors list:

```
service:
  pipelines:
    # ... other config ...
    logs:
      receivers: [filelog/custom_file]
      processors: [transform/logs_to_attributes,attributes/remove_unnecessary,attributes/convert_price,batch]
      exporters: [otlp/newrelic,debug]
```
</details>


## Challenge 2: Pre-ingest currency conversion (tricky!)
Unfortunately the price currency data being reported is in credits, we need to convert it to dollars! Fortunately the exchange rate is simple, we need to multiply by 1.2.

Create a new attribute `price_dollars` that contains the adjusted price based on the 1.2 exchange rate.

> Hint: You can use this query to view the prices:
> ```from Log select uuid, price, price_dollars where demo='otel-collector-demo'```


<details>
<summary>More hints for challenge 2!</summary>

> Hint: You can *set* attributes with the [transform processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/transformprocessor/README.md), we've already used one of those. 

> Hint: The current price attribute is available in the value `attributes["price"]`

> Hint: Don't forget to add the reference to your processor in the logs pipeline processors list

> Hint: Got `<nil>` type errors blowing up the collector? Not every record has a price attribute. You'll need to take that *condition* into account.

</details>

<details>
<summary>Challenge 2 Solution</summary>

We can solve this by adding a transform processor to set the value of a new attribute `price_dollars` by multiplying the value of the attribute `price` by the exhcnage rate 1.2. Because not every record has a price attribute we need to add a condition to our processor so that it only runs on records with a price.


```
processors:
  # ... other config ...
  transform/price_to_dollars:
    log_statements:
      - context: log
        statements:
            - set(attributes["price_dollars"], attributes["price"] * 1.2)
        conditions:
          - attributes["price"] != nil
```

We need to add this to our logs processors list. The list is getting quite long so we have formateed the yaml slightly differently for clarity:

```
service:
  pipelines:
    # ... other config ...
    logs:
      receivers: [filelog/custom_file]
      processors: 
        - transform/logs_to_attributes
        - attributes/remove_unnecessary
        - attributes/convert_price
        - transform/price_to_dollars
        - batch
      exporters: [otlp/newrelic,debug]
```
</details>
