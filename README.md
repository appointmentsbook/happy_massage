# Happy Massage

This is a Rails App intended to be an appointments book.

## Setup

```shell
bundle
bundle exec rake db:migrate
bundle exec rake db:seed
```

## Usage

### .env file

For now, to run it locally, you will need a CAS server to login to the app.

At the application root, create a .env file with the following content:

```
DB_HOST=<db_host>
DB_ADAPTER=<db_adapter>
DB_ENCODING=<db_encoding>
DB_NAME=<db_name>
DB_POOL=<db_pool>
DB_USERNAME=<db_username>
DB_PASSWORD=<db_password>

CAS_USERS_BASE_URL=<cas_server_url>
```

### Configuration

The app config is located at
```
config/schedule_settings.yml
```

### Running

```shell
bundle exec rails s
```

## License

happy_massage is Copyright © 2015-2016 Eron Junior, Flavio Muniz and Paula Roschel.

It is free software, and may be redistributed under the terms specified in the
[LICENSE](/LICENSE) file.
