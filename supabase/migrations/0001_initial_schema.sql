-- KING CLIENT initial schema. Run in Supabase SQL Editor or with Supabase CLI.
create extension if not exists pgcrypto;

create type public.app_role as enum ('customer', 'admin');
create type public.service_key as enum ('graphic', 'video', 'android', 'web');
create type public.project_status as enum (
  'pending_review','awaiting_quote','awaiting_deposit','payment_review',
  'deposit_confirmed','in_progress','preview_available','awaiting_customer_changes',
  'changes_in_progress','awaiting_final_payment','completed','cancelled'
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  display_name text,
  avatar_path text,
  role public.app_role not null default 'customer',
  profile_completed boolean not null default false,
  username_changed_at timestamptz,
  avatar_changed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint username_format check (username ~ '^[A-Za-z0-9_]{3,30}$')
);
create unique index profiles_username_lower_unique on public.profiles (lower(username));

create table public.services (
  id uuid primary key default gen_random_uuid(),
  key public.service_key not null unique,
  title_ar text not null,
  title_en text not null,
  enabled boolean not null default true,
  min_budget_egp numeric(12,2) not null default 0 check (min_budget_egp >= 0),
  max_budget_egp numeric(12,2) not null default 0 check (max_budget_egp >= min_budget_egp),
  min_duration text,
  max_duration text,
  created_at timestamptz not null default now()
);

create table public.portfolio_items (
  id uuid primary key default gen_random_uuid(),
  service_key public.service_key not null,
  serial_number bigint generated always as identity,
  title text not null,
  description text,
  media_kind text not null check (media_kind in ('image','video','interactive','document')),
  preview_storage_path text,
  published boolean not null default false,
  display_order integer not null default 0,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  unique(service_key, serial_number)
);
create index portfolio_published_idx on public.portfolio_items(service_key, published, display_order);

create table public.portfolio_likes (
  id uuid primary key default gen_random_uuid(),
  portfolio_item_id uuid not null references public.portfolio_items(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(portfolio_item_id, user_id)
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  project_number bigint generated always as identity unique,
  customer_id uuid not null references public.profiles(id),
  service_key public.service_key not null,
  request_kind text not null check (request_kind in ('new','similar')),
  reference_item_id uuid references public.portfolio_items(id) on delete set null,
  description text not null,
  options jsonb not null default '{}'::jsonb,
  estimated_budget_egp numeric(12,2) check (estimated_budget_egp is null or estimated_budget_egp >= 0),
  estimated_duration text,
  quoted_price_egp numeric(12,2) check (quoted_price_egp is null or quoted_price_egp >= 0),
  deposit_percent numeric(5,2) not null default 50 check (deposit_percent >= 0 and deposit_percent <= 100),
  paid_amount_egp numeric(12,2) not null default 0 check (paid_amount_egp >= 0),
  status public.project_status not null default 'pending_review',
  expected_delivery_at timestamptz,
  admin_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint description_limit check (char_length(description) between 1 and 1000)
);
create index projects_customer_created_idx on public.projects(customer_id, created_at desc);
create index projects_status_idx on public.projects(status, created_at desc);

create table public.project_attachments (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  uploaded_by uuid not null references public.profiles(id),
  storage_path text not null,
  original_name text not null,
  mime_type text not null,
  size_bytes bigint not null check (size_bytes > 0),
  purpose text not null default 'customer_brief' check (purpose in ('customer_brief','preview','source','delivery','payment_receipt','comment')),
  created_at timestamptz not null default now()
);

create table public.project_status_history (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  changed_by uuid references public.profiles(id),
  old_status public.project_status,
  new_status public.project_status not null,
  reason text,
  created_at timestamptz not null default now()
);

create table public.project_versions (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  version_number integer not null check (version_number > 0),
  label text not null,
  preview_storage_path text not null,
  preview_kind text not null check (preview_kind in ('image','video','website','document')),
  published boolean not null default false,
  published_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  unique(project_id, version_number)
);
create unique index one_published_version_per_project on public.project_versions(project_id) where published = true;

create table public.project_comments (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  version_id uuid references public.project_versions(id) on delete set null,
  author_id uuid not null references public.profiles(id),
  body text not null check (char_length(body) between 1 and 3000),
  annotation jsonb,
  created_at timestamptz not null default now()
);

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  customer_id uuid not null references public.profiles(id),
  subject text not null default 'محادثة جديدة',
  archived_at timestamptz,
  created_at timestamptz not null default now()
);
create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id),
  body text not null check (char_length(body) between 1 and 5000),
  read_at timestamptz,
  created_at timestamptz not null default now()
);
create index messages_conversation_created_idx on public.messages(conversation_id, created_at);

create table public.payment_submissions (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  customer_id uuid not null references public.profiles(id),
  sender_phone text not null,
  transaction_reference text,
  amount_egp numeric(12,2) not null check (amount_egp > 0),
  transferred_at timestamptz,
  receipt_storage_path text,
  notes text,
  status text not null default 'pending_review' check (status in ('pending_review','approved','rejected','needs_info')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  review_note text,
  created_at timestamptz not null default now()
);
create index payment_review_idx on public.payment_submissions(status, created_at);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  project_id uuid references public.projects(id) on delete cascade,
  kind text not null,
  title text not null,
  body text not null,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.site_settings (
  key text primary key,
  value jsonb not null,
  updated_by uuid references public.profiles(id),
  updated_at timestamptz not null default now()
);

create table public.admin_audit_log (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid references public.profiles(id),
  action text not null,
  target_type text not null,
  target_id uuid,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- Role helper is security-definer to avoid recursive RLS lookups.
create or replace function public.is_admin()
returns boolean language sql stable security definer
set search_path = public
as $$
  select exists(select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

alter table public.profiles enable row level security;
alter table public.services enable row level security;
alter table public.portfolio_items enable row level security;
alter table public.portfolio_likes enable row level security;
alter table public.projects enable row level security;
alter table public.project_attachments enable row level security;
alter table public.project_status_history enable row level security;
alter table public.project_versions enable row level security;
alter table public.project_comments enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.payment_submissions enable row level security;
alter table public.notifications enable row level security;
alter table public.site_settings enable row level security;
alter table public.admin_audit_log enable row level security;

create policy "profiles visible to owner and admins" on public.profiles
for select to authenticated using (id = auth.uid() or public.is_admin());
-- SECURITY DEFINER helper avoids querying profiles through its own RLS policy.
create or replace function public.current_user_role()
returns public.app_role language sql stable security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid();
$$;
revoke all on function public.current_user_role() from public;
grant execute on function public.current_user_role() to authenticated;

create policy "owner updates safe profile fields" on public.profiles
for update to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() and role = public.current_user_role() or public.is_admin());
create policy "services readable" on public.services for select using (enabled or public.is_admin());
create policy "admins manage services" on public.services for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "published portfolio readable" on public.portfolio_items for select using (published or public.is_admin());
create policy "admins manage portfolio" on public.portfolio_items for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "likes readable to owner/admin" on public.portfolio_likes for select to authenticated using (user_id = auth.uid() or public.is_admin());
create policy "user creates own like" on public.portfolio_likes for insert to authenticated with check (user_id = auth.uid());
create policy "user removes own like" on public.portfolio_likes for delete to authenticated using (user_id = auth.uid() or public.is_admin());
create policy "customer reads own projects" on public.projects for select to authenticated using (customer_id = auth.uid() or public.is_admin());
create policy "customer creates own project" on public.projects for insert to authenticated with check (customer_id = auth.uid() and status = 'pending_review' and paid_amount_egp = 0 and quoted_price_egp is null);
create policy "admins update projects" on public.projects for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins delete projects" on public.projects for delete to authenticated using (public.is_admin());
create policy "attachment access by project owner/admin" on public.project_attachments for select to authenticated using (public.is_admin() or exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid()));
create policy "customer attaches to own project" on public.project_attachments for insert to authenticated with check (uploaded_by = auth.uid() and exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid()));
create policy "status history owner/admin read" on public.project_status_history for select to authenticated using (public.is_admin() or exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid()));
create policy "admins manage status history" on public.project_status_history for insert to authenticated with check (public.is_admin());
create policy "versions visible to project owner/admin" on public.project_versions for select to authenticated using (public.is_admin() or (published and exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid())));
create policy "admins manage versions" on public.project_versions for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "comments visible to project owner/admin" on public.project_comments for select to authenticated using (public.is_admin() or exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid()));
create policy "customer comments on own project" on public.project_comments for insert to authenticated with check (author_id = auth.uid() and exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid()));
create policy "admins manage comments" on public.project_comments for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "conversation visible to participants/admin" on public.conversations for select to authenticated using (customer_id = auth.uid() or public.is_admin());
create policy "customer creates conversation" on public.conversations for insert to authenticated with check (customer_id = auth.uid());
create policy "admins manage conversations" on public.conversations for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "messages visible to conversation participant/admin" on public.messages for select to authenticated using (public.is_admin() or exists(select 1 from public.conversations c where c.id = conversation_id and c.customer_id = auth.uid()));
create policy "sender writes own message" on public.messages for insert to authenticated with check (sender_id = auth.uid() and exists(select 1 from public.conversations c where c.id = conversation_id and (c.customer_id = auth.uid() or public.is_admin())));
create policy "admins update messages" on public.messages for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "payment visible to owner/admin" on public.payment_submissions for select to authenticated using (customer_id = auth.uid() or public.is_admin());
create policy "customer submits own payment for own project" on public.payment_submissions for insert to authenticated with check (customer_id = auth.uid() and status = 'pending_review' and reviewed_by is null and exists(select 1 from public.projects p where p.id = project_id and p.customer_id = auth.uid()));
create policy "admins review payments" on public.payment_submissions for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "notifications visible to recipient/admin" on public.notifications for select to authenticated using (recipient_id = auth.uid() or public.is_admin());
create policy "recipient marks notification read" on public.notifications for update to authenticated using (recipient_id = auth.uid()) with check (recipient_id = auth.uid());
create policy "settings readable" on public.site_settings for select using (true);
create policy "admins manage settings" on public.site_settings for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins read audit log" on public.admin_audit_log for select to authenticated using (public.is_admin());
create policy "admins create audit log" on public.admin_audit_log for insert to authenticated with check (public.is_admin());

insert into public.services(key,title_ar,title_en,min_budget_egp,max_budget_egp,min_duration,max_duration) values
('graphic','تصميم جرافيك','Graphic Design',200,500,'30 دقيقة','ساعة ونصف'),
('video','مونتاج فيديو','Video Editing',250,1100,'ساعة','3 ساعات'),
('android','تطبيقات أندرويد','Android Apps',4000,23000,'يومان','أسبوعان'),
('web','مواقع ويب','Websites',6000,30000,'4 أيام','شهر')
on conflict(key) do nothing;

-- IMPORTANT: no user is made admin by default. Create an account, then assign admin role
-- manually from the SQL editor after verifying its auth.users UUID.
