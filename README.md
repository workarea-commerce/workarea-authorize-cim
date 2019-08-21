# WorkArea Authorize.Net CIM Integration

Integrates the `ActiveMerchant::Billing::AuthorizeNetCimGateway` with
the WebLinc platform. Designed to be dropped in to the project as the
primary payment gateway. Uses a bogus gateway until secrets are
configured.

## Installation

The latest version of this gem supports **Workarea 3.x**.

Add this to Gemfile in your `source` block for
**https://gems.workarea.com**:

```ruby
gem 'workarea-authorize_cim'
```

## Usage

The gem will automatically load the `BogusAuthorizeNetCimGateway` when
installed, but you can load the real-life gateway by configuring the
secrets for your environment as shown:

```yaml
authorize:
  login: YOUR LOGIN
  password: YOUR PASSWORD
  test: true # ONLY FOR STAGING!! Uses the auth.net sandbox
```

## WebLinc Platform Documentation

See https://developer.workarea.com for WebLinc platform documentation.

## Copyright & Licensing

Copyright WebLinc 2016-2018. All rights reserved.

For licensing, contact sales@workarea.com.
