# Django API for CS 4261 First Assignment
This API is setup, configured, and deployed with Heroku
It uses Django. For more information on django, view the [documentation](https://docs.djangoproject.com/en/3.2/)

### Database design:
#### The database consists of 2 models: User and UserPosting:
<strong>User:</strong>
- pk: user's primary key
- username: user's username
- email: user's email
- first_name: user's first name
- last_name: user's last name
- password: user's encrypted password

<strong>UserPosting:</strong>
- pk: posting's primary key
- poster: the user who created the post
- message: the message of the post
- created_date: the date and time of when the post was created
- vote_count: the current vote count of the posting
- location_lat: the latitude of the user's location when the post was made
- location_long: the longitude of the user's location when the post was made

### Endpoints of the API:
<strong>POST /api/register</strong> - Parameters are ‘username’, ‘email’, ‘password’, ‘first_name’, and ‘last_name’. This API will create the user and return a 201 status with the user’s credentials.

<strong>POST /api/login</strong> - Parameters are ‘username’ and ‘password’. This API will authenticate the user and return a 200 status with the user’s credentials.

<strong>POST /api/posting/create</strong> - Parameters are ‘user_pk’, ‘message’, ‘lat’, and ‘long’. This API will create a user posting and return a 201 status with the values of the newly created posting.

<strong>GET /api/postings/all</strong> - Takes no parameters. Returns a status of 200 with a list of all the user postings sorted by the most recently created.

<strong>POST /api/posting/upvote </strong> - Parameters are ‘posting_pk’. Upvotes the specified posting and returns a 200 status with the details of the posting that was upvoted.

<strong>POST /api/posting/downvote </strong> - Parameters are ‘posting_pk’. Downvotees the specified posting and returns a 200 status with the details of the posting that was downvoted.

<strong>GET /api/posting</strong> - Parameters are ‘posting_pk’. Returns a 200 status with the details of the specified posting.
