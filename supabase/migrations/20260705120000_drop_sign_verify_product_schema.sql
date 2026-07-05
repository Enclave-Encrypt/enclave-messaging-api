-- Retire Sign and Verify product schema from Enclave Social data.
-- Sign → project dqjwchquqeznftdnncec (enclave-sign)
-- Verify → project ccrjbpdluwxmkxwuymck (enclave-verify)
--
-- Does NOT drop public.begin_billing_mutation / billing_mutation_allowed (Social billing).

-- Verify marketing sync (depended on verify_accounts)
drop trigger if exists verify_users_resend_sync on public.verify_accounts;
drop trigger if exists verify_users_profile_resend_sync on public.users;
drop function if exists public.queue_verify_users_resend_sync();
drop function if exists public.queue_verify_users_resend_sync_from_profile();
drop view if exists public.resend_verify_users_audience;

-- Realtime
do $$
begin
  if exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'verify_sessions'
  ) then
    alter publication supabase_realtime drop table public.verify_sessions;
  end if;
end;
$$;

-- Sign RPCs (keep Social billing helpers)
drop trigger if exists guard_sign_accounts_billing_columns on public.sign_accounts;
drop function if exists public.clear_sign_subscription(text);
drop function if exists public.apply_sign_subscription(uuid, text, text, text, text, text, timestamptz, text);
drop function if exists public.guard_sign_accounts_billing_columns();
drop function if exists public.sign_ensure_account();

-- Verify RPCs
drop function if exists public.erase_my_verify_account();
drop function if exists public.get_my_verify_erase_status();
drop function if exists public.verify_switch_dashboard_mode(text);
drop function if exists public.verify_complete_onboarding(text, text, text, text);

-- Sign storage policies (empty buckets via Storage API/dashboard if needed)
drop policy if exists "Sign owners delete encrypted envelope documents" on storage.objects;
drop policy if exists "Sign owners read encrypted envelope documents" on storage.objects;
drop policy if exists "Sign owners upload encrypted envelope documents" on storage.objects;

-- Product tables
drop table if exists public.sign_billing_events cascade;
drop table if exists public.sign_contacts cascade;
drop table if exists public.sign_envelope_completed_artifacts cascade;
drop table if exists public.sign_envelope_fields cascade;
drop table if exists public.sign_envelope_document_keys cascade;
drop table if exists public.sign_envelope_documents cascade;
drop table if exists public.sign_envelope_recipients cascade;
drop table if exists public.sign_envelopes cascade;
drop table if exists public.sign_accounts cascade;

drop table if exists public.verify_sessions cascade;
drop table if exists public.verify_billing_events cascade;
drop table if exists public.verify_presentations cascade;
drop table if exists public.verify_requests cascade;
drop table if exists public.verify_certificates cascade;
drop table if exists public.verify_api_keys cascade;
drop table if exists public.verify_businesses cascade;
drop table if exists public.verify_accounts cascade;
