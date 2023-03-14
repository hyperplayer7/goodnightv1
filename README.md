## Development

### Prerequisites

The setups steps expect following tools installed on the system.

- Ruby 3.1.2
- Rails ~> 7.0.4
- PostgreSQL

### 1. Check out the repository

```bash
git clone git@github.com:hyperplayer7/goodnightv1.git
```

### 2. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle
rake db:create
rake db:migrate
```

### 3. Start the Rails server

You can start the rails server using the command given below.

```ruby
bin/rails s
```

And now you can visit the site with the URL http://localhost:3000. Available endpoints are:

```
POST    http://localhost:3000/api/v1/sleeps
POST    http://localhost:3000/api/v1/sleeps/:id/follow
DELETE  http://localhost:3000/api/v1/sleeps/:id/unfollow
GET     http://localhost:3000/api/v1/sleeps/:id/sleep_records
```

For testing the API, you would need API client like Postman/Insomnia or something similar.

POST    http://localhost:3000/api/v1/sleeps [EXAMPLE]

<img width="1011" src="https://user-images.githubusercontent.com/557377/224915381-6e76b67b-f8bb-4a0e-b6d2-0e6461afa4eb.png">

POST    http://localhost:3000/api/v1/sleeps/:id/follow  [EXAMPLE]

<img width="1011" src="https://user-images.githubusercontent.com/557377/224915384-400cf47a-f536-43b8-a530-0efa7e6fc1d5.png">

DELETE  http://localhost:3000/api/v1/sleeps/:id/unfollow [EXAMPLE]

<img width="1011" src="https://user-images.githubusercontent.com/557377/224915389-3c9018f0-83b6-4b91-b90f-5ff268cf8685.png">

GET     http://localhost:3000/api/v1/sleeps/:id/sleep_records [EXAMPLE]

<img width="1011" src="https://user-images.githubusercontent.com/557377/224915391-42877caf-a14f-45a6-bff6-14b42f577e2d.png">
