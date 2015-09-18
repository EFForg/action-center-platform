Action Center
=============

### Configuration

#### Secrets
Much of the configuration for your app will happen in a file called
`config/application.yml`. Use this file to store sensitive login credentials,
API keys, and other information that should not be made public, including:

* Rails secret key base - generate this with `rake secret`
* Devise secret key - generate this with `rake secret`
* Amazon S3 secret key and key id
* [SmartyStreets API](https://smartystreets.com/account/create) key and id
* [Sunlight API](https://sunlightfoundation.com/api/accounts/register/) key

For convenience, a template config is provided in
`config/application.yml.example`

#### Database

The default database is postgresql, but the mysql2 adapter can be chosen if
desired. You can edit the database settings in `config/application.yml`

If you're using heroku, you can skip this part. Heroku should take care of
the database configuration when you deploy.

#### SMTP

You will need to configure an smtp server in order to start creating user
accounts.  Configure the `address`, `port`, and `domain` in
`config/application.rb`. Configure the username and password in
`config/secrets.yml`.

### Local Setup

    bundle install
    rake db:schema:load
    rails s

Once the server is running, navigate to `localhost:3000/register` and create
yourself a user account. You will need to provide (and confirm) a valid email
in order to log in. When that's done, promote yourself to be an admin using the
following command:

    rake users:add_admin[youremail@example.org]

Now you should be able to go to `localhost:3000/admin/action_pages` to create
your first action page.

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

### Front-end Asset Management

We use [rails-assets.org](https://rails-assets.org) for front-end asset management.  Please refer to the `Gemfile` to modify these assets.

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

## Acknowledgements

This project was created by Lilia Kai, Thomas Davis, and Sina Khanifar. Large portions of the codebase are directly attributable to them, while under the employ or contractorship of the Electronic Frontier Foundation in 2014. Thank you Lilia, Thomas, and Sina! The Action Center is maintained currently by William Budington and Sina Khanifar.

## Licensing

See the `LICENSE` file for licensing information. This is applicable to the entire project, sans any 3rd party libraries that may be included.
