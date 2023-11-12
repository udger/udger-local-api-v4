# Udger-local-api-v4

User Agent parser v4 microservice with REST API intended to be run in Docker.

## Description

Udger-local-api-v4 is an application containing scalable pool of udger-parsers. Udger-local-api-v4 communicates via REST API, it can be easily embedded into Docker container and used as a microservice. Project provides basic Dockerfile based on **Alpine Linux** using highly efficient **Meecrowave** java EE microprofile.

## Parts of project

Project consists of following parts:

* [REST API description](https://github.com/udger/udger-local-api-v4/blob/master/openapi.yaml) in [openapi](https://swagger.io) format.
* Java8 project in Maven
* [Dockerfile](https://github.com/udger/udger-local-api-v4/blob/master/Dockerfile) based on [AlpineLinux+java8](https://hub.docker.com/r/adoptopenjdk/openjdk8) with [Meecrowave](http://openwebbeans.apache.org/meecrowave/index.html) microprofile.
* Simple [build&run](https://github.com/udger/udger-local-api-v4/blob/master/buildAndRun.sh) script. Build project, build Docker image and run Docker container.
* [Testing scripts](https://github.com/udger/udger-local-api-v4/tree/master/utils) in Python.
* [Hosted docker image](https://hub.docker.com/r/udgercom/udger-local-api-v4/) on [hub.docker.com](https://hub.docker.com/)

## Quick start

* Run [`buildAndRun.sh`](https://github.com/udger/udger-local-api-v4/blob/master/buildAndRun.sh) script

## Application parameters

Udger-local-api-v4 can be parameterized using following java properties:

* `-Dudger.poolsize=N` where `N` is number of parsers in the pool. Default value is `5`
* `-Dudger.cachesize=N` where `N` is number of items in parser LRU cache. Default is `10000`
* `-Dudger.clientkey=KEY` where `KEY` is client key used for access dbfile from `http://data.udger.com/`. Default value is empty.
* `-Dudger.db=dbFile` where `dbFile` is path to database file. Default value is `/udgerdb/udgerdb_v4.dat`.
* `-Dudger.autoupdate.time=4:42` schedule daily auto update time to 4:42 (HH:mm format).

## Use full udgerdb_v4.dat

* replace `udgerdb_test_v4.dat` by full db `udgerdb_v4.dat` in [`Dockerfile`](https://github.com/udger/udger-local-api-v4/blob/master/Dockerfile)

## Examples

* `parse/ua`
```
    wget http://localhost:8080/udger-local-api-v4/parse/ua/Mozilla%2F5.0+%28Windows+NT+10.0%3B+WOW64%3B+rv%3A40.0%29+Gecko%2F20100101+Firefox%2F40.0
```
* `parse/us-v4`
```
curl -X POST -H "Content-Type: application/xml" -d '<parseUaV4Request>
  <uaString></uaString>
  <secChUa>" Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"</secChUa>
  <secChUaFullVersionList></secChUaFullVersionList>
  <secChUaMobile>?0</secChUaMobile>
  <secChUaFullVersion>"97.0.4692.71"</secChUaFullVersion>
  <secChUaPlatform></secChUaPlatform>
  <secChUaPlatformVersion></secChUaPlatformVersion>
  <secChUaModel></secChUaModel>
</parseUaV4Request>' http://localhost:8080/udger-local-api-v4/parse/ua-v4
```
* `parse/ip`
```
    wget http://localhost:8080/udger-local-api-v4/parse/ip/12.118.188.126
```
* `statistic`
```
    wget http://localhost:8080/udger-local-api-v4/statistic
```
* `set/updatedata`
```
    curl -F 'file=@udgerdb_v4.dat' http://127.0.0.1:8080/udger-local-api-v4/set/datafile
```
