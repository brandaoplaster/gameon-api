# Game On API :video_game:

An e-commerce for online game sales

## About the Game On project
Features present in this e-commerce:

 - Administrative area
 - Shopping cart
 - List of desired products
 - Shopping list
 - Product categorization
 - Search by filters
 - List of products
 - Payment integration


## Configuration database and Installing dependencies

- Apply database configuration in the **database.yml** file

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
  user: username
  password: password
```

### next steps

- 
```
bundle install
```
- 
```
rails db:create
```
- 
```
rails db:migrate
```
- 
```
bundle exec rspec
```
- 
```
rails s
```

### Docker
> Option to use in development using docker.
****
> Needs fixing problem with active storage


## Stack
 - Ruby 2.7.1
 - Rails 6.0.3.3
 - Postgres
 - Docker
 - Docker compose

## Authors

- [brandaoplaster](https://github.com/brandaoplaster)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
