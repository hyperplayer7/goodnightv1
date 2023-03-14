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