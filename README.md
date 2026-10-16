# KING CLIENT | ملك التصميم

A staged Next.js + TypeScript + Supabase project for a design portfolio, bookings, project previews, payment review, and client/admin workflows.

## Implemented
- Arabic RTL responsive interface with existing black/white/gold styling; brand updated to **KING CLIENT** throughout interface, configuration, migration comments, and documentation.
- Supabase browser/server clients configured to use `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`.
- `.env.local` prefilled with the Project URL and Publishable key supplied for this handoff. It is excluded from Git.
- Diagnostic endpoint at `/api/health/supabase` checks read access to `public.services` and checks the current Auth session. It does not expose the key.
- Initial SQL migration and Row Level Security policies retained; profile update policy adjusted to avoid recursive RLS lookup.

## Setup and connection test
1. Install Node.js 20.9+ and npm.
2. Run `npm install` in this folder.
3. In Supabase SQL Editor, run `supabase/migrations/0001_initial_schema.sql`.
4. Start with `npm run dev`.
5. Open `http://localhost:3000/api/health/supabase`. HTTP 200 with `database: "reachable"` means the `services` table query succeeded. A failure response includes a diagnostic error; do not treat environment configuration alone as proof of connectivity.

## Checks
Run `npm test`, `npm run lint`, and `npm run build`.

## Still requires setup or implementation
- Live login/signup UI and Google OAuth are not implemented. Configure Auth redirect URLs and providers in Supabase before enabling them.
- No profile-creation trigger currently inserts a `profiles` row after signup; add and test that flow before implementing real login.
- Booking submission, file uploads, portfolio CRUD, admin workflows, payment review, messaging, private storage buckets, and deployment are not wired to live data.
- Apply the migration to the target Supabase project before the diagnostic endpoint can confirm database access. Review RLS policies and storage policies before production.
- Create the first admin only after verifying the owner's Auth UUID, using a trusted SQL/admin workflow. Never allow a public form to set `role`.

## Environment variables
`NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` are public client configuration values. Never put a Supabase `service_role` key in a `NEXT_PUBLIC_` variable or commit privileged secrets.
