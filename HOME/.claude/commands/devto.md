# Publish an article to dev.to

How Brooke publishes markdown articles to dev.to, taken from the SRDD series' pipeline. Loaded only when Brooke runs `/devto`.

## Usage
- `/devto` — load this how-to before drafting or publishing a dev.to article.

## Hard rule: nothing is posted until Brooke says so

Never call the dev.to API, run the sync script, or push to a branch whose CI syncs, until Brooke has been through the edit cycles and explicitly says to publish. Drafting, editing and committing the markdown are fine. When Brooke does say publish, the first sync goes up as a **dev.to draft** (`devto_published: false`). Brooke reviews it on dev.to, and only then flips it to `true`.

## Reference implementation

`~/CloudStation/Dev/_MediumArticles/2025-12-20 Spec-Roundtrip Driven Development/`, GitHub https://github.com/docs-bbos/srdd. Read these rather than reinventing:

- `documentation/about.md`: how the pipeline works (the segment Brooke wrote about it).
- `scripts/sync-to-devto/`: `sync-to-devto.js` (Node 18+, `gray-matter`, `js-yaml`) and its README.
- `.github/workflows/deploy-and-sync.yml`: GitHub Pages build, then the dev.to sync, then a commit of the sync state.

## How it works

1. **Source of truth:** markdown files in the repo's `documentation/` directory. dev.to is a copy.
2. **Front matter** per article:
   ```yaml
   ---
   title: My Article
   devto_published: false        # false = dev.to draft; true = published
   devto_tags: [ai, devops, productivity, opensource]   # max 4
   devto_series: "Series name"   # optional
   ---
   ```
3. **Cross-links between articles** use `{{devto:slug}}`. The GitHub Pages build turns these into `./slug.md`; the sync turns them into the real dev.to URLs in a second pass, because dev.to adds random suffixes to URLs.
4. **Canonical URL:** each dev.to article points at the GitHub Pages copy (`SITE_URL/<slug>/`), so search engines credit the canonical site. Without a Pages site, set `SITE_URL` to wherever the canonical copy lives, or leave canonical out by editing `buildCanonicalUrl()`.
5. **Incremental:** content is hashed into `documentation/.sync-state.json` (hash, syncedAt, dev.to URL); only changed files sync. `--force` syncs all; `--refresh-urls` refetches URLs.
6. **Images and video** must be absolute URLs (dev.to can't resolve repo-relative paths). Host them in the repo and reference the raw/Pages URL. dev.to embeds YouTube with `{% embed https://youtu.be/... %}`.
7. **Styles:** `<style>` blocks are stripped for dev.to; keep layout plain markdown.

## Setting up a new repo

1. Copy `scripts/sync-to-devto/` (without `node_modules`) and the workflow from the reference repo.
2. Secrets: `DEVTO_API_KEY` (GitHub secret; locally in a `.env` that is gitignored, as the SRDD repo does via `../../.env`). Never print, log or commit the key. Variable: `SITE_URL`.
3. Set `PUBLISH_BY_DEFAULT: 'false'` in the workflow so a push never publishes on its own; articles publish only via `devto_published: true`.
4. Run locally with `cd scripts/sync-to-devto && npm install && export $(grep -v '^#' .env | xargs) && node sync-to-devto.js`, only after Brooke says publish.

## Edit cycle

1. Draft the article as `documentation/<slug>.md` on a branch, `devto_published: false`.
2. Leave clearly marked placeholders for media Brooke will add, e.g. `<!-- SCREENSHOT: goc --all listing the ephemeral section -->` and `<!-- VIDEO: 60s walkthrough of ... -->`.
3. Open an MR/PR. Brooke comments; revise in new commits (no amend). Repeat until Brooke approves.
4. On Brooke's "publish": sync as a dev.to draft, give Brooke the dev.to URL, wait for their final OK, then set `devto_published: true` and sync again.
5. Record the dev.to URL from `.sync-state.json` in the project's diary.
