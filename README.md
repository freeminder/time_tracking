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
rake db:setup
```
This will run database creation, migration and seeds.

## Background jobs
Run:
```
rake jobs:work
```

### Tests
Run tests everytime before commiting with:

```
rspec -fd
```

Test every model method. Test every scenarios with feature tests. Double test any admin functionality to be sure that only admin can do that. Use this [article](https://robots.thoughtbot.com/how-we-test-rails-applications) and [this rsource](http://www.betterspecs.org/) as best practice.

__FactoryBot__

Create factory for all models in `spec/factories` folder.
Usefull [cheatsheet](https://devhints.io/factory_bot).

## License

Please refer to [LICENSE.md](LICENSE.md).
