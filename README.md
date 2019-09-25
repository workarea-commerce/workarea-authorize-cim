WorkArea Authorize.Net CIM Integration
================================================================================

Integrates the `ActiveMerchant::Billing::AuthorizeNetCimGateway` with
the Workarea platform. Designed to be dropped in to the project as the
primary payment gateway. Uses a bogus gateway until secrets are
configured.

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-authorize_cim'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Usage
--------------------------------------------------------------------------------

The gem will automatically load the `BogusAuthorizeNetCimGateway` when
installed, but you can load the real-life gateway by configuring the
secrets for your environment as shown:

```yaml
authorize:
  login: YOUR LOGIN
  password: YOUR PASSWORD
  test: true # ONLY FOR STAGING!! Uses the auth.net sandbox
```

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Authorize.net CIM is released under the [Business Software License](LICENSE)
