# What to look for

In this order of importance:

1. **Breaks for the user**: wrong result, crash, data loss, lost input, stuck
   spinner, a forgotten case (empty list, no network, slow reply, two clicks in
   a row).
2. **Security**: anything from the OWASP Top 10. Unescaped user input, secrets
   in code or logs, a missing permission check, an open redirect, a query built
   by string concatenation.
3. **Money and speed**: work repeated in a loop, a request per item, a file read
   on every render, an unbounded list held in memory.
4. **Will bite later**: a silent `catch`, a `TODO` that hides a known bug, two
   sources of truth for the same value, a test that cannot fail.
5. **Wrong shape for the job**, does the design fit the task at all.
6. **Already written somewhere**, does the repo or a dependency do this today.
7. **Style**. It MUST NOT be flagged unless the repo asks for it in writing.

You MUST read [deeper-checks.md](deeper-checks.md) at this step for 5 and 6.
They run on every review.

A file that is fine MUST be named as fine. Silence reads as "not reviewed". It
goes in the one "Clean:" line under the findings table.

Each finding SHOULD be worked out from the diff and the files around it, no
further. A finding you can't pin down stays in, marked for what it is. The deep
dive is where the digging happens, on the ones the user picks.
