In a similar vein to sending_mail_with_microsoft_graph.md so can also send mail
with the SendGrid API (not SMTP for the same reasons stated in the graph API doc).

The API key should be stored in Rails credentials. Eventually, this will be
specific to the hospital environment. E.g. stored in ich.yml.enc for Imperial.

It can also be overridden or set in environment variables. E.g.:
SENDGRID_API_KEY - Defaults to fetching `sendgrid_api_key` from Rails credentials.
SENDGRID_EMAIL_ADDRESS - Defaults to MAIL_OAUTH_EMAIL_ADDRESS then DEFAULT_FROM_EMAIL_ADDRESS.

This will allow gradual migration to hospital specific config within Renalware core.

You can test this locally by setting `MAIL_DELIVERY_METHOD=sendgrid_api` in demo/.env.

