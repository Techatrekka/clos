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
    // TODO: Change the table_name to your table
    const reqURL = new URL(req.url);
    if (reqURL.searchParams.size > 1) {
      throw new Error("Too few/many params");
    }
    const audio_type = reqURL.searchParams.values().next().value;
    // TODO: Change the table_name to your table
    if (audio_type.toLowerCase() != "true" && audio_type.toLowerCase() != "false") {
      throw new Error("must be either true or false");
    }
    const is_audiobook = audio_type === 'true';
    const { data, error } = await supabase.from('Tape').select('*').eq('is_audiobook', is_audiobook);
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
