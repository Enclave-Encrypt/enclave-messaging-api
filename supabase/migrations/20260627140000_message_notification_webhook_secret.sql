-- Load message notification webhook secret from internal_job_secrets instead of hardcoding it in SQL.

create or replace function public.queue_send_message_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_secret text;
  v_url text := 'https://kltykhkcvdwhfjgvevbt.supabase.co/functions/v1/send-message-notification';
begin
  select secret_value
  into v_secret
  from public.internal_job_secrets
  where job_key = 'message_notification'
  limit 1;

  if v_secret is null or btrim(v_secret) = '' then
    raise warning 'Message notification webhook skipped: internal_job_secrets.message_notification is not configured';
    return NEW;
  end if;

  perform net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-webhooks-secret', v_secret
    ),
    body := jsonb_build_object('record', to_jsonb(NEW))
  );
exception
  when undefined_function then
    raise warning 'Message notification webhook skipped: pg_net extension is unavailable';
  when others then
    raise warning 'Message notification webhook failed: %', sqlerrm;
end;
$$;

drop trigger if exists "send-message-notification" on public.messages;
drop trigger if exists send_message_notification on public.messages;

create trigger send_message_notification
after insert on public.messages
for each row
execute function public.queue_send_message_notification();
