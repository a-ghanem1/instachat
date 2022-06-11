# Chat app task

## Technologies
- Rails 5
- MySQL
- Redis
- Elasticsearch
- Resque `for message queueing`: also I've created a worker on docker-compose file to execute jobs.

## How to run
You can run this app with `docker-compose up -d`

## Routes

1- **Application**
```
GET /applications/:application_token

POST /applications
{ "name": "app name" }

PUT /applications/:token
{ "name": "new app name" }

DELETE /applications/:token
```
2- **Chats**
```
GET /applications/:application_token/chats

POST /applications/:application_token/chats

DELETE /applications/:application_token/chats/:number
```

3- **Messages**
```
GET /applications/:application_token/chats/:chat_number/messages

POST /applications/:application_token/chats/:chat_number/messages
{ "body": "new message body" }

GET /applications/:application_token/chats/:chat_number/messages/search/:term
```

## Improvements
Things to be improved in the future.

- add test cases (unit, feature).
- refactor the code to follow all best practices.
- add a load balancer to app servers in case we expect to have a lot of traffic.