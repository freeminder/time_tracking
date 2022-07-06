# Time Tracking
Time tracking web application.

## Requirements
* **Ruby >= 2.7.0**
* **Bundler**
* **MySQL server**
* **Redis server**

## Setup dev env
Clone `.env.example` to `.env` and update the environment variables with your local settings (use strings).
Then run:
```
bundle
rails db:setup
```
This will run database creation, migration and seeds.

## Background jobs
Run sidekiq:
```
bundle exec sidekiq
```

## Running the app
```
rails s
```

## Running the app with background jobs altogether:
```
foreman start
```

## Access the app
You can access the app with the default user at [http://localhost:3000/](http://localhost:3000/):
* email: admin@test.com
* password: P@ssword

## Tests
Run tests everytime before commiting with:
```
rspec -fd
```
Test every model method. Test every scenarios with feature tests. Double test any admin functionality to be sure that only admin can do that. Use this [article](https://robots.thoughtbot.com/how-we-test-rails-applications) and [this rsource](http://www.betterspecs.org/) as best practice.

##### FactoryBot
Create factory for all models in `spec/factories` folder.
Usefull [cheatsheet](https://devhints.io/factory_bot).

## Code analyzer
Run rubocop everytime before commiting with:
```
rubocop
```

## Docker containers
##### Requirements
* **Docker**
* **Docker Compose**

Run microservices everytime with:
```
docker-compose -f docker/docker-compose.yml up
```
And setup db for the first run with:
```
docker-compose -f docker/docker-compose.yml exec web rails db:setup
```
The application will be available at [http://localhost:3000/](http://localhost:3000/).

## License
Please refer to [LICENSE.md](LICENSE.md).
