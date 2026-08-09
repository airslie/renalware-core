# API credentials

Renalware integrations should authenticate with a scoped bearer token rather than a username and
token in URL query parameters. Only a SHA-256 digest of the bearer token is stored in Renalware.

## Issue a credential

The associated Devise user provides the audit identity recorded by API actions. It must be approved
and active, but should have a random, unknown interactive password.

Run the task in a secure shell, not in CI or deployment output:

```bash
API_USERNAME=api \
API_CREDENTIAL_NAME=mirth-outgoing-documents \
API_SCOPES=outgoing_documents:read,outgoing_documents:write \
bin/rails renalware:api_credentials:issue
```

Set `API_EXPIRES_AT`, using a value understood by `Time.zone.parse`, to issue an expiring credential.
The bearer token is displayed once and cannot be recovered from the database. If it is lost, disable
the credential and issue another with a new name, such as a date or version suffix. Credential names
must be unique for each user, including disabled credentials.

Supported scopes are:

| Scope | Access |
| --- | --- |
| `outgoing_documents:read` | List and retrieve queued outgoing documents |
| `outgoing_documents:write` | Report the outcome of an outgoing document |
| `mirth_statistics:write` | Submit Mirth channel statistics reports |
| `patients:read` | Read patient API resources |
| `medications:read` | Read patient prescriptions |
| `hd_sessions:write` | Create or update HD sessions |

Give each integration only the scopes it needs. Prefer separate credentials for different sites,
applications, and purposes so they can be rotated or revoked independently.

## Configure the client

Send the token on every request over verified HTTPS:

```http
Authorization: Bearer <token>
```

For Mirth, keep the token outside the exported channel, such as in its Configuration Map, and use an
HTTP Sender header such as `Authorization: Bearer ${renalwareApiToken}`. Remove `username` and
`token` from the URL. Avoid verbose header logging because it may record the bearer token.

## Migrating legacy clients

Query-string authentication remains enabled by default for a staged rollout. It logs a deprecation
warning without logging the token.

1. Deploy Renalware and run the database migration.
2. Issue a scoped credential for each integration.
3. Change every request made by that integration to send the bearer header. Pagination URLs do not
   carry credentials, so clients must send the header when following them.
4. Verify the integration and check for legacy-authentication deprecation warnings.
5. After all clients at the site have migrated, set
   `LEGACY_API_QUERY_AUTHENTICATION_ENABLED=false` and redeploy.
6. Clear or rotate the user's old plaintext `authentication_token`.

Setting `LEGACY_API_QUERY_AUTHENTICATION_ENABLED=false` before every client has migrated will make
remaining query-authenticated requests return `401 Unauthorized`.

## Revoke or inspect credentials

Credentials can be identified by name and the non-secret `token_prefix`. To revoke one immediately:

```ruby
user = Renalware::User.find_by!(username: "api")
credential = user.api_credentials.find_by!(name: "mirth-outgoing-documents")
credential.update!(enabled: false)
```

`last_used_at` is updated periodically and can help confirm whether a credential is still in use.
Disabling or expiring the associated Devise user also prevents API access.

## Mirth channel statistics

Issue a dedicated credential:

```bash
API_USERNAME=api \
API_CREDENTIAL_NAME=mirth-statistics-2026-08 \
API_SCOPES=mirth_statistics:write \
bin/rails renalware:api_credentials:issue
```

Post JSON to `POST /api/v1/monitoring/mirth/channel_stats`. This endpoint accepts bearer
authentication only; legacy query credentials are deliberately rejected.

```json
{
  "schema_version": 1,
  "report_id": "12d76844-4b15-4226-af8b-d4a66d9aca01",
  "reported_at": "2026-08-09T10:15:00Z",
  "source": "mirth_connect",
  "site_id": "hospital-a",
  "instance_id": "renalware-production",
  "server_id": "e64f0bc9-9b8a-4618-ab2f-da497b53a7fe",
  "channels": [
    {
      "id": "a7f684ca-a58a-4e7e-b4a9-8f13a7977cf9",
      "name": "Pathology results",
      "state": "STARTED",
      "received": 12043,
      "sent": 12040,
      "error": 2,
      "filtered": 1,
      "queued": 3
    }
  ]
}
```

A new report returns `201 Created`. Repeating a `report_id` is an idempotent retry and returns
`200 OK` without creating duplicate statistics. Invalid reports return `422 Unprocessable Content`.

For a push-based deployment, retain `MONITORING_MIRTH_ENABLED=true` so the dashboard is visible and
set `MONITORING_MIRTH_POLLING_ENABLED=false` to stop the old GoodJob API poller. Existing deployments
that do not set the new polling variable retain their current polling behaviour.
