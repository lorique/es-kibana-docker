# Elasticsearch documentation

Elasticsearch can be a wonderful tool if used correctly, and with consideration to the fact that its a java application. 

Under here you can find some good reading material sources to get you started down the fantastic world of lucene and elasticsearch.

- [Learning](https://www.elastic.co/learn)
- [Basic concepts](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-concepts.html)

## Queries

Queries can be slow. Best practice is to search only the indexes you need, and the fields you want to know if the query is in. 

- [Full text query](https://www.elastic.co/guide/en/elasticsearch/reference/current/full-text-queries.html)

### Query_string vs match
Query_string supports operators and many other goodies. It works just fine if you wan't to search accross all fields in the index, but because of all the goodies it can be slow.

```
{
    "query": {
        "query_string" : {
            "default_field" : "field1",
            "query" : "abc"
        }
    }
}
```

### Multiple fields alternative.
To query multiple fields, use the [multi_match](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html) query type. Example below.

```
{
  "query": {
    "multi_match" : {
      "query":    "abc", 
      "fields": [ "field1", "field2"],
      "type": "cross_fields",
      "operator": "or"
    }
  }
}
```


## Configuration
Configurations should always be explicit, so if any changes happens to default configuration on version change, it does not affect the installation. 

For cluster configuration, please refer to documentation below.

### Memory and swapping
According to elasticsearch's own documentation `Elasticsearch performs poorly when the system is swapping the memory.`. Put it in other terms, make sure the system has enough memory by a wide margin. They suggest only letting ES us about half the system memory. On low memory systems, i would suggest lowering this to 1/3rd, to allow the operating system enough memory to function without swapping.

#### Allocation vs actual use.
Generally speaking, when you set the -Xms and -Xmx environment variables for heap memory, its important to note that this only allocates the memory to the system. The actualy memory usage by the jvm can be checked using the `curl --request GET --url 'http://localhost:9200/_cluster/stats?human=&pretty='` request. Under nodes.jvm.mem.heap_used (of the result) you can check how much memory is actually being used. If this gets to within 80% of the nodes.jvm.mem.heap_max, consider adding more memory to the server to avoid issues with swapping.

### Production considerations
Turns out elasticsearch 6 does come with a semi-sane configuration for single-node setups. However there are som considerations regarding memory, and location of log files and data store.

Best practice for logs are to put on them on a different partition from where you store data. This is because a full partition can have some detrimental effects, and cause odd error messages from ES. Logs happen for a variety of reasons, and they take up space unless you use log-rotation. Best advice, move them away from the main data partition.

The data store partition should be made with a thought to how much data you think will be stored and how often you clean your data. Cleaning, or pruning your data, can be done manually or using the Curator plugin for elasticsearch. Pruning can only be done to time-series data, data which has had an @timestamp added to its body. 

- [Important settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html)
- [Curator 5](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/index.html)

### Files
There are two key files to look for when we talk configuration. The elasticsearch configuration file, [elasticsearch.yml](./elasticsearch.yml) and javaopts. Javaopts are usually set as environment configuration, and can usually be found in the startup script. More information on javaopts can be found in the documentation, but looking up parameters used in the startup script is a good baseline to go by.

## Sharding considerations

### Unassigned shards
Unassigned shards are always present in a single-node elasticsearch, because there is always a primary shard in an index, and a replica for each primary shard. Elasticsearch tries to allocate these to nodes, but replicas cant live on the same node as primary shards, so they become unassigned. Controlling the number of replica can be done by updating the number of replica's an index can have. Updating this number can be done using this curl:

```
curl --request PUT \
  --url http://localhost:9200/%5BINDEX%5D/_settings \
  --header 'content-type: application/json' \
  --data '{"number_of_replicas": 0}'
```

- [Datadog help](https://www.datadoghq.com/blog/elasticsearch-unassigned-shards/)
- [Shard primer](https://docs.bonsai.io/article/122-shard-primer)
- [Reduction of shard usage](https://docs.bonsai.io/article/124-reducing-shard-usage)

## Cluster and redundancy
Elasticsearch *wants* to be clustered. Its designed to be for reduncancy and scalabiltiy purposes, and as such has some very nice built in configurations which allow for automatic discovery, data protection, and promotion of new primary shards in the event of node loss.

It is highly recommended to run with at least 2 nodes, master and replica, on different servers in case of a node. This also addresses high availability concerns, in environments where the elasticsearch serve as the primary way of interacting with the data.

- [ES Cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cluster.html)
- [Dzone tutorial 2018](https://dzone.com/articles/elasticsearch-tutorial-creating-an-elasticsearch-c)
	- Configuration is the important part here.

## Local setup with docker

* Install docker
* Login or create account.
* run `docker-compse up -d` to start the elasticsearch and kibana containers.
* run `docker-compse stop` to stop the elasticsearch and kibana containers.

Configuration files for [elasticsearch](elasticsearch.yml) and [kibana](kibana.yml) can be found in this directory. After changes to configuration files, run `docker-compse restart` to have them take effect.

### Sample data
With your containers started, you can run the [install](shakespeare/install.sh) file, to download and install the sample data libraries into your elasticsearch.

### Useful links

- [Setup guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
- [Sample data](https://www.elastic.co/guide/en/kibana/current/tutorial-load-dataset.html)