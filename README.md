[![Code Climate](https://codeclimate.com/github/TheNotary/action-center-platform/badges/gpa.svg)](https://codeclimate.com/github/TheNotary/action-center-platform)
[![Test Coverage](https://codeclimate.com/github/TheNotary/action-center-platform/badges/coverage.svg)](https://codeclimate.com/github/TheNotary/action-center-platform/coverage)
[![Build Status](https://travis-ci.org/TheNotary/action-center-platform.svg?branch=master)](https://travis-ci.org/TheNotary/action-center-platform)


Action Center
=============

### Configuration

#### Secrets
For convenience almost all of the configuration settings have been moved into the `config/application.yml` file.  The file isn't tracked into the repo so to get started, make a copy of `config/application.yml.example` and begin filling in and generating the appropriate values.

#### Notable Dependencies
* Amazon S3 secret key and key id
  * Allows admins to upload images for the ActionPages
* [SmartyStreets API](https://smartystreets.com/account/create) key and id
  * Allows Congress members to be looked up for users
* [Sunlight API](https://sunlightfoundation.com/api/accounts/register/) key
  * Allows Congress members to be looked up for users
* [Phantom of the Capitol](https://github.com/efforg/phantom-of-the-capitol) whitelisting on server side?
  * Allows users to submit e-messages to congress
* call

### Local Setup

Install system package dependencies (the below example works on Ubuntu/precise).  You need postresql 9.3 at least.

```
$  sudo apt-get install postgresql postgresql-contrib-9.3 libpq-dev libqt4-dev libqtwebkit-dev
```

For convenience, you may configure a postgresql superuser, and then run the below commands to bring the app online.


```
$  sudo -u postgres bash -c "psql -c \"CREATE ROLE actioncenter PASSWORD 'CHANGEMEinproduction6f799ae4eb3d59e' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN; \""

$  bundle install
   rake db:create
   rake db:schema:load
   rails server
```

Once the server is running, navigate to `localhost:3000/register` and create yourself a user account. You will need to provide (and confirm) a valid email in order to log in. When that's done, promote yourself to be an admin using the following command:

    rake users:add_admin[youremail@example.org]

Now you should be able to go to `localhost:3000/admin/action_pages` to create your first action page.

## Heroku Setup

First create a new app and configure it with a Postgres add on. Then

    git remote add heroku git@heroku.com:your-action-center-app.git
    git push heroku master
    heroku run rake db:migrate

As with above, you can now register a user account and confirm your email.

    heroku run rake users:add_admin[youremail@example.org]

## Production Setup

Follow these instructions
`https://www.digitalocean.com/community/articles/how-to-install-rails-and-nginx-with-passenger-on-ubuntu`

### Generating the EFF icon font

The EFF icon font is generated using [fontello.com](fontello.com) and via the [fontello-rails-converter](https://github.com/railslove/fontello_rails_converter).

To add a new icon to the fontset, read the **Update your existing fontello font** section of the [fontello_rails_converter readme](https://github.com/railslove/fontello_rails_converter#updating-your-existing-fontello-font).

## Embedding Actions

Embedding actions is simple.  Just include the following HTML on the page you want the action to be embedded:

    <script type="text/javascript" src="https://act.eff.org/action/embed"></script>
    <a id="action-center-widget" href="https://act.eff.org/action/shut-the-nsa-s-backdoor-to-the-internet">Take part in the action!</a>

The link href should point to the action page you wish to embed.

If you want to get fancy, you can modify the embed code to include some of the following parameters, all of which are optional:

    <script type="text/javascript">
        var ac_embed = {};
        ac_embed.css = "https://example.com/hello.css"; // specify a css file url
        ac_embed.width = 500; // specify a width manually
        ac_embed.no_css = true; // remove all default styles
        ac_embed.css_content = "#some_elem"; // specify an element which itself contains some styles
    </script>
    <script id="some_div" type="text/x-css-content">
        body{
            background-color: blue;
        }
    </script>
    <script type="text/javascript" src="https://act.eff.org/action/embed"></script>
    <a id="action-center-widget" href="https://act.eff.org/action/shut-the-nsa-s-backdoor-to-the-internet">Take part in the action!</a>

## Testing

To run the full test suite, simply run `rake` with no arguments.  The Rspec tests will run first, followed by the more spotty cucumber tests.  You may need to do some tweaking and install firefox to get those tests to pass.  

Rspec tests are used for unit testing the app, and some integration testing.   Cucumber tests are used for testing API keys, javascript tests and possibly for taking on new features described to us by Activism.  

## Acknowledgements

This project was created by Lilia Kai, Thomas Davis, and Sina Khanifar. Large portions of the codebase are directly attributable to them, while under the employ or contractorship of the Electronic Frontier Foundation in 2014. Thank you Lilia, Thomas, and Sina! The Action Center is maintained currently by William Budington and Sina Khanifar.

## Licensing

See the `LICENSE` file for licensing information. This is applicable to the entire project, sans any 3rd party libraries that may be included.
