---
name: tailor-application
description: Tailor Vincent's cover letter and CV to a specific job posting. Use when the user pastes a job description and asks to write a cover letter, prepare an application, apply for a job, or tailor the CV to a role. Produces a Markdown cover letter in `cover_letters/` and targeted edits to relevant LaTeX sections under `cv_vincent/cv-sections/`.
---

# Tailor Application

Helps Vincent prepare a job application by:

1. Picking the matching cover letter template under `cover_letters/`.
2. Filling it in for the specific posting, in the voice of the existing exemplar (`cover_letters/little_journey_senior_fullstack_engineer.md`).
3. Making targeted edits to the relevant CV `.tex` sections so the resume emphasizes what the posting asks for.

The agent does NOT rebuild the PDF automatically — it tells the user to run `make pdf` after reviewing the CV changes.

## Inputs

The user provides the job description as pasted text. Extract from it:

- `ORGANISATION` — company name
- `RECIPIENT` — hiring contact if named, otherwise `<Organisation> Team`
- `JOB_POSTING` — exact role title from the posting
- `ROLE_FAMILY` — one of `fullstack`, `ai`, `frontend` (used to pick the template)
- Key requirements, technologies, domain, and product context

If any of `ORGANISATION` / `JOB_POSTING` / `ROLE_FAMILY` cannot be confidently extracted, ask the user before proceeding.

## Workflow

Copy this checklist and track progress:

```
- [ ] 1. Parse job description and extract metadata
- [ ] 2. Pick template based on ROLE_FAMILY
- [ ] 3. Read template + exemplar + current CV sections
- [ ] 4. Draft cover letter (template structure, exemplar voice)
- [ ] 5. Write cover letter file
- [ ] 6. Identify CV section edits and apply them
- [ ] 7. Report changes and tell user to run `make pdf`
```

### Step 1 — Parse the posting

Read the pasted job description carefully. List internally:

- Top 5–8 technical requirements (languages, frameworks, infra).
- Domain / product context (e.g. health-tech, fintech, devtools).
- Soft / process expectations (e.g. "clarify requirements early", "CI/CD ownership").
- Seniority signal (junior / mid / senior / lead).

### Step 2 — Pick the template

| ROLE_FAMILY | Template file |
|-------------|---------------|
| `fullstack` (incl. backend-heavy, "software engineer", "product engineer") | `cover_letters/fullstack_engineer.md` |
| `ai` (ML, AI/LLM, data science, AI engineer) | `cover_letters/ai_engineer.md` |
| `frontend` (UI, web frontend, mobile/iOS-leaning roles also start here) | `cover_letters/frontend_engineer.md` |

If the posting is clearly hybrid (e.g. "AI Fullstack Engineer"), prefer the template whose body paragraphs most plausibly match the company's core need. When in doubt, ask the user.

### Step 3 — Read sources

Before drafting, read in parallel:

- The selected template under `cover_letters/`.
- The exemplar `cover_letters/little_journey_senior_fullstack_engineer.md` (voice reference).
- `cv_vincent/cv-sections/experience.tex`, `skills.tex`, and `projects.tex` (so claims in the letter are grounded in what the CV actually states).

### Step 4 — Draft the cover letter

Use the template's structure (subject line, opening, generalist paragraph, JOB_FIT closer, sign-off). Then enrich it the way the exemplar does:

- Add a paragraph that explicitly names the company and ties Vincent's interest to their domain/product.
- Replace the generic "JOB_FIT" sentence with one or two paragraphs of concrete evidence — pull real role bullets from `experience.tex` (GovRadar, Nextaim, Fireflow/Meiller MiDrive) and reuse their exact tech stack wording.
- Map at least 3 explicit requirements from the posting to concrete experience.
- Close in Vincent's voice ("Looking forward to getting to know you all better and the ways we can build … together!").

**Hard rules — preserve Vincent's voice:**

- Sign off as `Vincent Halasz`.
- Keep the opening line pattern: `**Application for <JOB_POSTING> at <ORGANISATION>**`.
- Keep the phrasing "I would like to apply for your advertised position as …".
- Keep the philosophy beat from the template ("the technologies changed, the underlying process of software engineering did not" / "modern software development is about combining all of these …"). You may compress it, but do not remove the idea.
- Honest framing: if the stack only partially overlaps, say so (see exemplar: "While I do not claim equal depth in every part of your stack …").
- Do not invent employers, dates, or technologies that are not present in `experience.tex`, `projects.tex`, or `skills.tex`.

### Step 5 — Write the cover letter file

Path: `cover_letters/<company_slug>_<role_slug>.md`

Slug rules: lowercase, ASCII, words separated by underscores, drop articles, drop punctuation. Examples:

- "Little Journey" + "Senior Fullstack Engineer" → `little_journey_senior_fullstack_engineer.md`
- "Acme AI, Inc." + "AI Engineer" → `acme_ai_ai_engineer.md`

If a file with that name already exists, ask the user whether to overwrite or pick a new suffix.

### Step 6 — Tailor the CV sections

Make minimal, surgical edits in `cv_vincent/cv-sections/`. The goal is emphasis, not rewriting history.

Allowed edits:

- **`experience.tex`** — reorder bullets within a `\cventry` so the most relevant ones come first; rephrase a bullet to surface a technology that's already implicit (e.g. mention TypeScript explicitly when applying for a TS-heavy role). Do not add tech that wasn't part of the actual work.
- **`skills.tex`** — reorder items inside a `\cvskill` category so the posting's stack appears earliest. Do not add skills Vincent doesn't have.
- **`projects.tex`** — reorder `\cventry` blocks so the most relevant project appears first.

Forbidden edits (without explicit user approval):

- Changing job titles, employers, dates, or locations.
- Adding new `\cventry` or `\cvskill` entries.
- Removing existing entries.
- Touching files outside `cv_vincent/cv-sections/` (e.g. `resume_cv.tex`, fonts, the Makefile).

If the posting would benefit from a more invasive change (e.g. a brand new bullet describing real but uncaptured work), surface a proposal to the user instead of editing silently.

### Step 7 — Report

After writing files, respond with:

1. Path to the new cover letter.
2. Bullet list of CV sections edited, with one-line rationale per edit.
3. Reminder: "Run `make pdf` to regenerate `output/resume_cv.pdf`."

## Cover Letter Skeleton (assembled)

This is the shape the final letter should end up in — template structure inflated with exemplar-style content:

```markdown
# Application for <JOB_POSTING> at <ORGANISATION>

Dear <RECIPIENT>,

I would like to apply for your advertised position as <JOB_POSTING>, as I believe it would be a great fit for my current skill-set and the kind of <role-flavored phrase> work I enjoy most.

<Philosophy paragraph adapted from the chosen template — kept compact.>

<Company-specific paragraph: name the organisation, tie Vincent's interest to their domain/product, and mirror 1–2 explicit expectations from the posting.>

<Evidence paragraph 1: current role at GovRadar, grounded in experience.tex bullets, mapping to the posting's stack.>

<Evidence paragraph 2: prior role (Nextaim or Fireflow/Meiller MiDrive), chosen for relevance to the posting.>

<JOB_FIT paragraph: synthesise why Vincent is a strong fit, including an honest stack-overlap caveat if appropriate.>

I am looking forward to getting to know you all better and the ways we can build <something aligned with the company's mission> together.

Best regards,

Vincent Halasz
```

## Example Mapping

For reference: when the posting is *"Senior Fullstack Engineer at Little Journey (paediatric clinical trials, TypeScript, Node, React, AWS)"*, the agent:

- Picks `fullstack_engineer.md` as the template.
- Pulls the GovRadar bullets (TypeScript, Vue, FastAPI, Docker, GitHub Actions) and the Nextaim bullets (Go → Node/TS migration, Fastify, PostgreSQL, AWS) as the evidence paragraphs.
- Mentions the Meiller MiDrive iOS work for breadth.
- Caveats stack overlap ("I do not claim equal depth in every part of your stack").
- Writes `cover_letters/little_journey_senior_fullstack_engineer.md`.
- Likely reorders `experience.tex` so TS / Node / AWS bullets lead, and reorders `skills.tex` Languages so TypeScript is first.

See `cover_letters/little_journey_senior_fullstack_engineer.md` as the canonical worked example.
