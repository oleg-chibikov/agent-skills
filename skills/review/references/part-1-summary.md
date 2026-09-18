# Part 1: what this change is about

It MUST read for someone who has not heard of this product or this code. Three
`###` headings, one or two sentences under each:

- **Before**, what was wrong or missing, as a person would notice it.
- **Now**, what happens instead.
- **Where**, the place in the product it shows up.

File names, type names and function names MUST stay out. Cannot tell what
problem the change solves? Say that first and ask. Guessing here poisons the
rest.

```markdown
## What this change is about

### Before

The Save button on the profile page wiped the name field before the server had
agreed to store the new name. A failed save lost the typed name, with nothing on
screen explaining why.

### Now

The text stays until the server confirms, and comes back if the save failed.

### Where

Settings, the Profile tab, the Save button.
```
