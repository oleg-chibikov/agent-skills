# Part 3: the findings table

One row per finding. The table MUST sit above the findings, so the verdict fits
on one screen, even when there is a single finding.

- **#** matches the finding below.
- **Severity** is the word used in the heading.
- **Where** is the file and line in backticks, file name only, no path.
- **What** is the symptom in under about 10 words, lowercase, no full stop.

Under the table, one line names the changed files with nothing to flag. Row
counts and file counts MUST stay out: the table shows them.

Nothing to flag anywhere? The table goes, and one line replaces it: what the
change does well, and that it is good to go.

```markdown
## Findings

| #   | Severity   | Where             | What                                                  |
| --- | ---------- | ----------------- | ----------------------------------------------------- |
| 1   | Blocker    | `SaveName.tsx:42` | the typed name is lost when the save is slow          |
| 2   | Should fix | `profile.ts:88`   | the save error is swallowed, so the page stays silent |
| 3   | Nit        | `SaveName.tsx:20` | nothing reads the `isLoading` flag                    |

Clean: `result.ts`, `collect-results.ts`, the test config.
```
