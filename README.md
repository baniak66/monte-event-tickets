# README

###### The application allows users to see event details like name, date, time and available tickets types and quantity. Signed in users can make a reservation and see the state of reservation. Signed in users can also make a payment for reserved tickets. Reservation is automatically canceled if the user didn't make payment in 15 minutes from the initialization of reservation.

## MAIN ENDPOINTS

* show event
  path:   `/events/show/:id`
  method: `GET
  accepted pa`rams:
  ```
    {
      id: int # (event id)
    }
  ```
  returns: json resopnse with event data

* create reservation
  authentication required (auth headers)
  path:   `/reservations/create`
  method: `POST`
  accepted params:
  ```
    {
      event_id:     int, # (event id)
      even:         int, # amount of even type tickets ordered
      all_together: int, # amount of all_together type tickets ordered
      avoid_one:    int  # amount of avoid_one type tickets ordered
    }
  ```
  returns: 200 status in case of success action or 422 status with json contain error messages

* show reservation
  authentication required (auth headers)
  path:   `/reservations/show/:id`
  method: `GET`
  accepted params:
  ```
    {
      id: int # (event id)
    }
  ```
  returns: json resopnse with reservation data

* create payment
  authentication required (auth headers)
  path:   `/payments/create`
  method: `POST`
  accepted params:
  ```
    {
      id:     int, # (id of reservation)
      amount: int  # (reserved tickets price amount)
    }
  ```
  returns: 200 status in case of success action or 422 status with json contain error messages

## Authenticaton

Application authentication wiht `devise_token_auth` gem

* signup
  path:   `/auth`
  method: `POST`
  accepted(required) params:
  ```
    {
      "email":                 "user@email.com",
      "password"               "password",
      "password_confirmation": "password"
    }
  ```
  returns: users data and authentication headers

* signin
  path:   `/auth/sign_in`
  method: `POST`
  accepted(required) params:
  ```
    {
      "email": "test@email.com",
      "password": "password"
    }
  ```
  returns: users data and authentication headers

  Above enpoints returns authentication headers that need to be added to request that need authentication.
  Returned headers:
  ```
    "access-token": "wwwww",
    "token-type":   "Bearer",
    "client":       "xxxxx",
    "expiry":       "yyyyy",
    "uid":          "zzzzz"
  ```

* signout
  path:   `/auth`
  method: `DELETE`
  requierd auth headers


