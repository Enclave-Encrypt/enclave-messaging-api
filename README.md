# Enclave Messaging API

Supabase edge functions and migrations for **Enclave Messaging**. Lives in **Enclave-Encrypt** alongside other product APIs.

E2EE/MLS cryptography is client-side in [`@enclave/messaging-sdk`](https://github.com/Enclave-Messaging/enclave-messaging-sdk) (AGPL). Eden Social may use the same SDK for encryption against its own database.

## Layout

```
enclave-messaging-api/
  supabase/
    functions/           # Edge handlers (auth exchange, LiveKit, Stripe, notifications)
    migrations/          # Messaging / legacy Social schema (excludes sign_* and verify_*)
```

Sign and Verify APIs are separate: `enclave-sign-api`, `enclave-verify-api`.

## Deploy

Legacy Social data project remains `kltykhkcvdwhfjgvevbt` until a new Messaging Supabase project is provisioned:

```bash
npm run deploy
# or
npx supabase db push
```

## License

AGPL-3.0-or-later
