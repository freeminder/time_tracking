# Time Tracking

Time tracking web application.

## Requirements

* **Ruby >= 1.9.3**
* **Bundler**
* **MySQL server**

## Setup dev env

Clone `.env.example` to `.env` and update the environment variables with your local settings (use strings).

Then run:
```
bundle
rails db:setup
```
This will run database creation, migration and seeds.

## Background jobs

Run:
```
bundle exec rake jobs:work
```

## License

Please refer to [LICENSE.md](LICENSE.md).
