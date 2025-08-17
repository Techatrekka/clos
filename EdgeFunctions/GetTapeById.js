// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'jsr:@supabase/supabase-js@2';
Deno.serve(async (req)=>{
  try {
    const supabase = createClient(Deno.env.get('SUPABASE_URL') ?? '', Deno.env.get('SUPABASE_ANON_KEY') ?? '', {
      global: {
        headers: {
          Authorization: req.headers.get('Authorization')
        }
      }
    });
    const reqURL = new URL(req.url);
    if (reqURL.searchParams.size > 1) {
      throw new Error("Too few/many params");
    }
    const tape_id = reqURL.searchParams.values().next().value;
    // TODO: Change the table_name to your table
    const { data, error } = await supabase.from('Tape').select('*').eq('tape_id', Number(tape_id));
    if (error) {
      throw error;
    }
    return new Response(JSON.stringify({
      data
    }), {
      headers: {
        'Content-Type': 'application/json'
      },
      status: 200
    });
  } catch (err) {
    return new Response(JSON.stringify({
      message: err?.message ?? err
    }), {
      headers: {
        'Content-Type': 'application/json'
      },
      status: 500
    });
  }
});
