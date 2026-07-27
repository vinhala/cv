---
name: tailor-cv
description: Tailor Vincent's CV to a specific job posting. Use when the user pastes a job description and asks to adapt, target, or optimize the CV for the role. Makes focused edits to relevant LaTeX sections under `cv_vincent/cv-sections/` without creating a cover letter or inventing experience.
---

# Tailor CV

Adapt Vincent's CV to a specific job posting by emphasizing the most relevant existing experience, skills, and projects. Do not create or edit a cover letter.

## Inputs

Use the pasted job description to extract:

- `ORGANISATION` — company name, when stated
- `JOB_POSTING` — exact role title, when stated
- Key technical requirements, technologies, domain, and product context
- Soft-skill and process expectations
- Seniority signal

If the posting is incomplete, continue with the information available unless a missing detail would materially change the CV edits.

## Workflow

Track this checklist:

```text
- [ ] 1. Parse the job description
- [ ] 2. Read the current CV sections
- [ ] 3. Map job requirements to supported CV evidence
- [ ] 4. Plan minimal, targeted edits
- [ ] 5. Apply the edits
- [ ] 6. Review the diff for accuracy and scope
- [ ] 7. Report changes and tell the user to run `make pdf`
```

### Step 1 — Parse the posting

Identify:

- The top 5–8 technical requirements, including languages, frameworks, infrastructure, and tooling
- The domain and product context, such as health-tech, fintech, or developer tools
- Soft-skill and process expectations, such as clarifying requirements early or owning CI/CD
- The expected seniority level
- Repeated terms and priorities that should be easy to find in the CV

Rank the requirements by importance. Treat explicit must-haves and repeated requirements as higher priority than incidental mentions.

### Step 2 — Read the CV

Read these files before proposing or applying edits:

- `cv_vincent/cv-sections/experience.tex`
- `cv_vincent/cv-sections/skills.tex`
- `cv_vincent/cv-sections/projects.tex`

Read other files under `cv_vincent/cv-sections/` only when they are directly relevant to the posting.

### Step 3 — Map requirements to evidence

For each high-priority requirement, find concrete support in the current CV. Prefer direct evidence from experience bullets over a standalone skill mention.

Classify each requirement internally as:

- **Direct match** — explicitly supported by the CV
- **Adjacent match** — supported by closely related experience and can be framed honestly
- **Unsupported** — not evidenced in the CV and must not be added

Do not infer technologies, responsibilities, employers, dates, or outcomes that the CV does not support.

### Step 4 — Plan targeted edits

Make the smallest changes that improve relevance and scanability. Prioritize:

1. Moving the strongest matching experience bullets earlier
2. Rephrasing existing bullets so relevant supported technologies, responsibilities, or outcomes are visible sooner
3. Reordering skills so the posting's supported stack appears first
4. Moving the most relevant projects earlier

Avoid keyword stuffing, vague claims, and broad rewrites. Preserve Vincent's voice and the existing LaTeX structure.

### Step 5 — Apply the edits

Only edit files under `cv_vincent/cv-sections/`.

Allowed edits:

- **`experience.tex`** — reorder bullets within a `\cventry`; rephrase a bullet to foreground technology, ownership, or outcomes already supported by the original content
- **`skills.tex`** — reorder existing items within a `\cvskill` category so the most relevant supported skills appear first
- **`projects.tex`** — reorder existing `\cventry` blocks so the most relevant project appears first
- **Other section files** — make similarly minimal edits only when their existing content directly supports the posting

Forbidden edits without explicit user approval:

- Changing job titles, employers, dates, or locations
- Adding employers, projects, responsibilities, technologies, skills, metrics, or credentials not already supported by the CV
- Adding new `\cventry` or `\cvskill` entries
- Removing existing entries
- Touching files outside `cv_vincent/cv-sections/`, including `resume_cv.tex`, fonts, output files, or the Makefile
- Creating or editing any cover letter

If a more invasive change would materially improve the CV, describe the proposed change to the user instead of applying it silently.

### Step 6 — Review the diff

Inspect the final diff and confirm that:

- Every changed claim is supported by the original CV
- No dates, employers, titles, locations, or metrics changed unintentionally
- LaTeX commands, braces, escaping, and list structure remain valid
- Changes are limited to relevant files under `cv_vincent/cv-sections/`
- The result emphasizes the posting's priorities without pretending to satisfy unsupported requirements

Do not rebuild the CV PDF automatically. Let the user review the source edits first.

### Step 7 — Report

Respond with:

1. A concise summary of how the CV was targeted to the role
2. A list of edited CV sections with a one-line rationale for each
3. Any important posting requirement that remains unsupported or only adjacent
4. The reminder: "Run `make pdf` to regenerate `output/resume_cv.pdf`."

## Example

For a posting seeking a senior full-stack engineer with TypeScript, Node.js, React, AWS, PostgreSQL, and CI/CD experience:

- Surface the strongest existing TypeScript, Node.js, AWS, PostgreSQL, and CI/CD evidence near the top of the relevant experience entries.
- Reorder existing skills so supported requirements are easier to scan.
- Move the most relevant existing project ahead of less relevant projects.
- Do not add React or any other requirement unless the current CV supports it.
- Report unsupported or adjacent requirements honestly instead of trying to conceal the gap.
