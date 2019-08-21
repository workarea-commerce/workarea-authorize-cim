Weblinc Authorize.Net CIM 1.0.3 (2018-03-28)
--------------------------------------------------------------------------------

*   Rescue exceptions to avoid user-facing 500 errors.

    Backport fix in commit 35f04d8e046 which adds AuthorizeCim::Error and
    raises AuthorizeCim::Error and ActiveMerchant::ActiveMerchantError
    instead of RuntimeError.

    AUTHORIZE-16
    Devan Hurst



