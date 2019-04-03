#!/bin/sh

if [ ! -f ./shakespeare.json ]; then
  curl https://download.elastic.co/demos/kibana/gettingstarted/shakespeare_6.0.json \
  --output shakespeare.json
fi

if [ ! -f ./accounts.json ]; then
  curl https://download.elastic.co/demos/kibana/gettingstarted/accounts.zip \
  --output accounts.zip

  unzip accounts.zip
fi

if [ ! -f ./logs.jsonl ]; then
  curl https://download.elastic.co/demos/kibana/gettingstarted/logs.jsonl.gz \
  --output logs.jsonl.gz
  
  gunzip logs.jsonl.gz
fi

curl -X PUT "localhost:9200/shakespeare" -H 'Content-Type: application/json' -d'
{
 "mappings": {
  "doc": {
   "properties": {
    "speaker": {"type": "keyword"},
    "play_name": {"type": "keyword"},
    "line_id": {"type": "integer"},
    "speech_number": {"type": "integer"}
   }
  }
 }
}
'


curl -X PUT "localhost:9200/logstash-2015.05.18" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'

curl -X PUT "localhost:9200/logstash-2015.05.19" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'

curl -X PUT "localhost:9200/logstash-2015.05.20" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'

curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary @accounts.json
curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/shakespeare/doc/_bulk?pretty' --data-binary @shakespeare_6.0.json
curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/_bulk?pretty' --data-binary @logs.jsonl


curl -X GET "localhost:9200/_cat/indices?v"

