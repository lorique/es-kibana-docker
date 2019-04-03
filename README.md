# Elasticsearch documentation

Elasticsearch can be a wonderful tool if used correctly, and with consideration to the fact that its a java application. 

Under here you can find some good reading material sources to get you started down the fantastic world of lucene and elasticsearch.


- [Learning](https://www.elastic.co/learn)
- [Basic concepts](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-concepts.html)

## Queries


## Configuration

### Memory and swapping


### Production considerations
Turns out elasticsearch 6 does come with a semi-sane configuration for single-node setups. However there are som considerations regarding memory, and location of log files and data store.

Best practice for logs are to put on them on a different partition from where you store data. This is because a full partition can have some detrimental effects, and cause odd error messages from ES. Logs happen for a variety of reasons, and they take up space unless you use log-rotation. Best advice, move them away from the main data partition.

The data store partition should be made with a thought to how much data you think will be stored and how often you clean your data. Cleaning, or pruning your data, can be done manually or using the Curator plugin for elasticsearch. Pruning can only be done to time-series data, data which has had an @timestamp added to its body. 

- [Important settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html)
- [Curator 5](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/index.html)

### Files
There are two key files to look for when we talk configuration. The elasticsearch configuration file, [elasticsearch.yml](./elasticsearch.yml) and javaopts. Javaopts are usually set as environment configuration, and can usually be found in the startup script. More information on javaopts can be found in the documentation, but looking up parameters used in the startup script is a good baseline to go by.

## Sharding considerations

## Multinode and redundancy

## Local setup with docker

### Useful links

- [Setup guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
- [Sample data](https://www.elastic.co/guide/en/kibana/current/tutorial-load-dataset.html)