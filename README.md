# README

This app contains single endpoint `/convert` to convert a given amount from one currency to another one using external API.
Required params:
- `from_currency`, string
- `to_currency`, string
- `amount`, positive number

Exchange rates from external api are temporary cached based on a timestamp of next update in external service.

In case of error, error is returned in the response. Errors are:
- missing `from_currency` param
- missing `to_currency` param
- missing `amount` param
- invalid `amount` param (negative or string)
- exchange rate not found (when non-existing currency is set in params)

Sample request could look like
```
GET /convert?from_currency=EUR&to_currency=USD&amount=100

200 OK
{
  "converted_amount": "4.217352"
}
```

Currently app responds with 200 OK in case of errors as well, so it could be changed to respond with 400/404 for the error described above.

### Setup
```
bundle install
rails s
```

### Specs
```
rspec
```
