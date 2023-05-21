# README

## Requirements
The `GITHUB_SECRET` variable needs to be set in order for the application to
work. This value is a GitHub REST API token, it can be generated following
[these](https://docs.github.com/en/rest/guides/getting-started-with-the-rest-api?apiVersion=2022-11-28#authenticating)
instructions. The application supports loading environment vars from an `.env`
file, which is the preferred method for this.

## REST endpoints

### `GET /gh_users`

Returns all users already in the platform database

### `GET /gh_users/:name`

Returns information on a given user, matching its github handle, based on the
latest information available at the platform. If the user does not exist in the
platform, a dummy entry is created.

### `PUT /gh_users/:name/fetch_repos`

Asynchronously updates information on a given user, matching its github handle.
