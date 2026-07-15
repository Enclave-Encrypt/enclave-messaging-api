# Enclave Messaging API

Supabase edge functions and migrations for **Enclave Messaging**. Lives in **Enclave-Encrypt** alongside other product APIs.

E2EE/MLS cryptography is client-side in [`@enclave/messaging-sdk`](https://github.com/Enclave-Messaging/enclave-messaging-sdk) (AGPL).

## Layout

```
enclave-messaging-api/
  supabase/
    functions/           # Edge handlers (auth exchange, LiveKit, notifications)
    migrations/          # Messaging schema (excludes sign_* and verify_*)
```

Sign and Verify APIs are separate: `enclave-sign-api`, `enclave-verify-api`.

## Deploy

Legacy data project remains `kltykhkcvdwhfjgvevbt` until a dedicated Messaging Supabase project is provisioned:

```bash
npm run deploy
# or
npx supabase db push
```

## License

AGPL-3.0-or-later
