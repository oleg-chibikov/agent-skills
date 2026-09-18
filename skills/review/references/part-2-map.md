# Part 2: the map and the reading order

How the changed files hang together, and in which order to open them. GitHub
shows them alphabetically, so this part saves the reader that. Three pieces MUST
be there:

1. **One bullet per file**, the name in bold, then one plain sentence on what it
   is for. Files that belong together share one bullet and are named as a group.
   No prose here.
2. **A plain text tree** in a fenced block marked `text`. Mermaid MUST NOT be
   used: chat windows render it as an empty box. Start from the file that pulls
   the others in, branch with `├──` and `└──`, and add a short note after a file
   name when what travels along that edge is the point. Mark the files the PR
   adds and the ones nothing calls yet. Hold the changed files plus the existing
   ones they touch, nothing more, under about twelve lines. Below three files,
   skip the tree.
3. **The reading order**, numbered, one line each, saying why the file comes at
   that point. Start where the data starts or where the simplest piece is, end
   where it ties together. Tests and config last.

One file and a test? Write one line saying the map is not needed.

````markdown
## How the files hang together

- **`import-csv.ts`** reads the uploaded file and pulls the rows out of it. It
  leans on the two new helpers below.
- **`parse-row.ts`, `to-record.ts`** parse one row and turn it into a record.
- **`result.ts`** carries the outcome. This PR taught it to hold warnings.
- **Tests and build config** only pull the new files into the run.

```text
import-csv.ts (new)  the main file of the PR
├── parse-row.ts (new)        parses one row
├── to-record.ts (new)        turns it into a record
└── result.ts                 warnings were added here
    └── collect-results.ts (unchanged)   carries them to the output

importButton (next PR) ···> import-csv.ts   nothing calls it yet
```

Reading order:

1. `result.ts`, to see what a warning is. It turns up everywhere after that.
2. `to-record.ts` and `parse-row.ts`, small and self contained, read them with
   their tests.
3. `import-csv.ts`, the main file of the PR, the rest exists for it.
4. `collect-results.ts`, unchanged, but this is where you see whether the
   warnings reach the output.
5. The test and lint config, last, they only wire the new files in.
````
