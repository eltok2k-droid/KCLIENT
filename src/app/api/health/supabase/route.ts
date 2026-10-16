import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export async function GET() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

  if (!url || !key) {
    return NextResponse.json(
      { ok: false, configured: false, database: "not_checked", auth: "not_checked", error: "Supabase environment variables are missing." },
      { status: 503 }
    );
  }

  try {
    const supabase = await createSupabaseServerClient();
    const [{ data: services, error: databaseError }, { data: userData, error: authError }] = await Promise.all([
      supabase.from("services").select("key").limit(1),
      supabase.auth.getUser()
    ]);

    if (databaseError) {
      return NextResponse.json({
        ok: false, configured: true, database: "error",
        auth: authError?.message.toLowerCase().includes("session") ? "no_session" : authError ? "error" : "reachable",
        error: databaseError.message
      }, { status: 502 });
    }

    const noSession = Boolean(authError?.message.toLowerCase().includes("session"));
    return NextResponse.json({
      ok: true,
      configured: true,
      database: "reachable",
      servicesTable: "readable",
      auth: noSession ? "reachable_no_session" : authError ? "error" : "reachable",
      authenticated: Boolean(userData.user),
      serviceRowsReturned: services?.length ?? 0
    });
  } catch (error) {
    return NextResponse.json({
      ok: false, configured: true, database: "error", auth: "not_checked",
      error: error instanceof Error ? error.message : "Unknown connection error"
    }, { status: 502 });
  }
}
