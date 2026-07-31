# Book Club Assemble — exact setup & deploy steps

Three files in this zip:
- `index.html` — the app
- `schema.sql` — sets up your database
- `README.md` — this file

Total time: about 10 minutes. No coding required, just copy/paste.

---

## PART 1 — Create your free database (Supabase)

1. Go to **supabase.com** and sign up (free, no credit card).
2. Click **New project**.
   - Name: anything, e.g. "book-club"
   - Database password: pick one and save it somewhere (you won't need it for this app, but Supabase requires it)
   - Region: pick whichever is closest to you
   - Click **Create new project**. Wait ~1-2 minutes while it spins up.
3. Once it's ready, in the left sidebar click **SQL Editor**.
4. Click **New query**.
5. Open `schema.sql` from this zip, select all, copy it.
6. Paste it into the SQL Editor box in Supabase.
7. Click **Run** (bottom right, or Ctrl/Cmd+Enter).
   - You should see "Success. No rows returned." If you see a red error instead, stop and re-check you pasted the whole file.

## PART 2 — Get your two keys

1. Still in Supabase, click the **gear icon (Project Settings)** in the left sidebar.
2. Click **API** in the settings menu.
3. You'll see two things you need:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public** key — a long string starting with `eyJ...`
4. Keep this tab open, you'll copy these in the next step.

## PART 3 — Connect the app

1. Open `index.html` from this zip in any text editor (Notepad, TextEdit, VS Code, whatever you have).
2. Find these two lines near the top (search for `SUPABASE_URL` if your editor supports search):

   ```js
   var SUPABASE_URL = 'YOUR_SUPABASE_PROJECT_URL';
   var SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```

3. Replace the placeholder text between the quotes with your real values from Part 2:

   ```js
   var SUPABASE_URL = 'https://abcdefgh.supabase.co';
   var SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```

   Keep the quote marks. Don't touch anything else in the file.
4. Save `index.html`.

## PART 4 — Deploy it (pick ONE of these, all free)

### Option A — Netlify Drop (easiest, no account needed)
1. Go to **app.netlify.com/drop**
2. Drag your edited `index.html` file onto the page.
3. It gives you a live URL in a few seconds, like `https://random-name-123.netlify.app`.
4. That's your link — send it to your friend.

### Option B — Vercel
1. Go to **vercel.com**, sign up free.
2. Click **Add New → Project**.
3. Choose **upload** (no GitHub needed) or connect a GitHub repo containing `index.html`.
4. Deploy. You get a live URL like `https://your-project.vercel.app`.

### Option C — GitHub Pages
1. Create a free GitHub account if you don't have one.
2. Create a new repository, upload `index.html` into it.
3. Go to repo **Settings → Pages**.
4. Under "Branch," pick `main` and save.
5. Wait a minute, then your link is `https://yourusername.github.io/repo-name`.

## PART 5 — First time opening it

1. Open your live URL on your phone.
2. You'll be asked to name both readers and set a shared password. Do this once — whoever opens it first sets it up for both of you.
3. Send the same URL to your friend. They'll open it, enter the password you both agreed on, then pick which of the two names is theirs.
4. From then on, both of you can update your book progress and post thoughts/quotes, and it all syncs live between your devices.

---

## Notes

- The password is checked inside the database itself, not in the browser — the hash is never sent to either phone.
- No login/rate-limiting on password guesses — fine for keeping a link private between two friends, not meant to stop a determined attacker.
- Nothing is remembered on either device (no localStorage), so the same link works identically on both your phones, and you'll re-enter the password each time you reopen it.
- Free tier limits (Supabase): the project can pause after a week of no visits (opening the site again wakes it up), and there's a monthly cap on database size/bandwidth a two-person book log won't come close to hitting.
- If something doesn't load: open your browser's dev console (F12) on the deployed page — errors there almost always mean the URL/key in Part 3 was pasted wrong, or `schema.sql` didn't fully run in Part 1.
