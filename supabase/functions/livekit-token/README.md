# livekit-token

Mints LiveKit room tokens for Enclave Messaging voice channels.

## Status

**Required in production** — clients call this endpoint via `supabase.functions.invoke`. Implementation is in `index.ts`.

## Auth model

- `verify_jwt = true` in `supabase/config.toml` (gateway rejects missing/invalid Messaging data JWTs).
- Handler also calls `supabase.auth.getUser(token)` before minting a room token.
- Caller uses `supabase.functions.invoke` with the active Messaging data session.

## Request / response

```http
POST /functions/v1/livekit-token
Content-Type: application/json

{
  "roomName": "channel-<id>",
  "participantName": "display name",
  "participantIdentity": "<auth user id>"
}
```

```json
{
  "token": "<livekit access token>",
  "url": "<LIVEKIT_URL from secrets>"
}
```

## Required secrets

| Secret | Purpose |
|--------|---------|
| `LIVEKIT_API_KEY` | LiveKit API key |
| `LIVEKIT_API_SECRET` | LiveKit API secret |
| `LIVEKIT_URL` | **Required** — LiveKit websocket URL (no hardcoded default) |

Also standard Supabase function env: `SUPABASE_URL`, `SUPABASE_ANON_KEY`.

## Deploy

```bash
npx supabase link --project-ref kltykhkcvdwhfjgvevbt
npx supabase secrets set LIVEKIT_API_KEY=... LIVEKIT_API_SECRET=... LIVEKIT_URL=wss://...
npx supabase functions deploy livekit-token
```
