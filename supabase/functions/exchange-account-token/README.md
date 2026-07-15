# exchange-account-token

Exchanges a valid **Enclave Account** access token for a **Messaging data** Supabase session.

## Auth model

- `verify_jwt = false` in `supabase/config.toml` because callers send an Account-project JWT, which the Messaging data gateway cannot validate.
- Handler verifies the bearer token against Account JWKS (`eyqaeigblulbtnorqyts`) and rejects Messaging data tokens with a clear error.
- Only issues a Messaging data session after Account identity is confirmed.

## Required secrets

- `SUPABASE_URL` / `SUPABASE_SERVICE_ROLE_KEY` (Messaging / legacy data project)
- `ACCOUNT_SUPABASE_URL` / `ACCOUNT_SUPABASE_ANON_KEY` (Account project, for fallback `getUser`)

## Notes

- Must remain callable only with a valid Account JWT; never accept anonymous requests.
