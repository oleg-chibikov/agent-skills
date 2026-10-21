# State and failure

Read the change again twice: as two copies of it running at once, and as a run
that dies halfway.

- **Old copy written back**: does a step read the state, wait on something
  slow, then write its old copy over a newer one?
- **Half a file**: can a reader see a file mid-write? `writeFile` empties it
  first, a temp file and `rename` don't.
- **Someone else's lock**: does the code release a lock it didn't take, or take
  over a stale one another process just took?
- **Dies halfway**: does a step delete or move before the step that can fail?
  Does a rerun then trust the half, or a "done" flag that means "tried"?
- **Retry twice**: does a retry after an unclear answer post the comment, the
  row or the charge again?

A message that sends the person to the wrong fix SHOULD be flagged here too: one
text for two causes, stderr dropped, a stack trace for a mistyped flag.

The finding MUST give the order of steps that breaks it, one step per line.
