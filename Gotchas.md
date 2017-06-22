# Chouette and Ruby on Rails gotchas
Here are some gotchas from working with Ruby on Rails.


# Define routes in 
```
./config/routes.rb
```

## Generate ActiveRecord model 
```Shell
./bin/rails generate model <ACTIVE_MODE_NAME> xmlns xmlnsurl
```

## Generate migration
```Shell
./bin/rails generate migration <MIGRATION_NAME>
```

## Generate controller
```Shell
./bin/rails generate controller <CONTROLLER_NAME> index
```

## Database stuff
If you wanna drop the database, reload the schema from schema.rb, and reseed the database
```Shell
bundle exec rake db:reset
```


### Database: migrate and rollback
It is possible to migrate changes and rollback changes again, this example rollback one step.
```Shell
bundle exec rake db:migrate
bundle exec rake db:rollback STEP=1
```

