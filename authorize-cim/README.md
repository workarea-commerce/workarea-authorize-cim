# WebLinc Authorize.Net CIM Integration

Integrates the `ActiveMerchant::Billing::AuthorizeNetCimGateway` with
the WebLinc platform. Designed to be dropped in to the project as the
primary payment gateway. Uses a bogus gateway until secrets are
configured.

## Installation

This gem supports **Weblinc 2.x**.

Add this to Gemfile in your `source` block for
**https://gems.weblinc.com**:

```ruby
gem 'weblinc-authorize-cim'
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

See [http://guides.weblinc.com](http://guides.weblinc.com) for WebLinc platform documentation.

## Copyright & Licensing

Copyright WebLinc 2016. All rights reserved.

For licensing, contact sales@weblinc.com.
