Workarea Authorize Cim 2.1.2 (2020-06-01)
--------------------------------------------------------------------------------

*   Added fields to include IP in transactions IP address is stored on tender while the order is being placed. It is then passed along as an argument when submitting the transaction to Authorize.net


    daniel



Workarea Authorize Cim 2.1.1 (2019-08-22)
--------------------------------------------------------------------------------

*   Open Source!



Workarea Authorize Cim 2.1.0 (2018-09-04)
--------------------------------------------------------------------------------

*   Pass order id on auth / purchase calls

    Add order number as the invoice number on auth and purchase.
    Remove tests that were pushed up stream in Workarea 3.3

    AUTHORIZE-18
    Eric Pigeon



Workarea Authorize Cim 2.0.2 (2018-08-31)
--------------------------------------------------------------------------------

*   prepping v2.0.1 release

    Eric Pigeon

*   AUTHORIZE-17: Add proxy to gateway configuration

    Andy Sides



Workarea Authorize.Net CIM 2.0.1 (2018-03-21)
--------------------------------------------------------------------------------

*   Validate refund has settled transactions

    remove refund in vcr tests because authorize cim can't refund until the
    transaction has been settled

    AUTHORIZE-12
    Eric Pigeon

*   Handle duplicate transaction errors in test suite

    AUTHORIZE-11
    Eric Pigeon

*   Fix core tests

    AUTHORIZE-11
    Eric Pigeon

*   Fix rakefile for running core tests

    Fix rakefile to run the full test suite and clean up the plugin

    AUTHORIZE-10
    Eric Pigeon


Workarea Authorize.Net CIM 2.0.0 (2018-02-01)
--------------------------------------------------------------------------------

*   Handle duplicate transaction errors in test suite

    AUTHORIZE-11
    Eric Pigeon

*   Fix core tests

    AUTHORIZE-11
    Eric Pigeon

*   Fix rakefile for running core tests

    Fix rakefile to run the full test suite and clean up the plugin

    AUTHORIZE-10
    Eric Pigeon

*   Upgrade plugin for v3 compatibility

    - Rename to workarea-authorize_cim
    - Regenerate and reconfigure dummy app to run tests
    - Convert tests to use Minitest, use Mocha to mock out Authorize.Net responses

    AUTHORIZE-8
    Tom Scott
