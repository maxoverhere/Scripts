# DLT MESSAGE MANAGEMENT

## TESTING

### RUN LOCALLY
Spin up the dependencies by running
```
docker compose up -d
```
Spin down the dependencies by running
```
docker-compose down
```

Run the app
```
./gradlew bootRun --args='--spring.profiles.active=local'
```

Poll the app health
```
curl http://localhost:8080/actuator/health
```

Query API with using the http file [here](docs/dead-letter-api.http)

View local docker compose Kafka UI at http://localhost:8081/

Wipe the db with this command
```
docker rm -f -v awx-dlt-message-management-db-1	
```

Send Kafka message to local Kafka using [this manual test](dlt-message-management/src/test/kotlin/com/airwallex/pa/dltmessagemanagement/kafka/DltConsumerPublishToLocalManual.kt)

### FORWARD FROM STAGING
Get the pod name
```
kc get po | grep dlt
```

Then forward the pod (replace pod name)
```
kubectl port-forward dlt-message-management-6f5f57f8cf-nmggc 8090:8090
```
