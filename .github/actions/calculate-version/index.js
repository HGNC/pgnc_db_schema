'use strict';

const fs = require('node:fs');
const {
  parseVersion,
  compareSemver,
  resolveNextVersion
} = require('./lib/version-utils.js');

const USER_AGENT = 'calculate-version-action/0.1.0';
const MAX_TAG_PAGES = 5;
const TAGS_PER_PAGE = 100;

async function fetchTags({ owner, repo, token, apiBase }) {
  const headers = {
    Accept: 'application/vnd.github+json',
    Authorization: `Bearer ${token}`,
    'User-Agent': USER_AGENT,
    'X-GitHub-Api-Version': '2022-11-28'
  };

  const tagNames = [];

  for (let page = 1; page <= MAX_TAG_PAGES; page += 1) {
    const url = `${apiBase}/repos/${owner}/${repo}/tags?per_page=${TAGS_PER_PAGE}&page=${page}`;
    const response = await fetch(url, { headers });

    if (response.status === 404) {
      break;
    }

    if (!response.ok) {
      const body = await safeReadBody(response);
      throw new Error(`Failed to fetch tags (status ${response.status}): ${body}`);
    }

    const data = await response.json();
    if (!Array.isArray(data) || data.length === 0) {
      break;
    }

    for (const item of data) {
      if (item && typeof item.name === 'string') {
        tagNames.push(item.name);
      }
    }

    if (data.length < TAGS_PER_PAGE) {
      break;
    }
  }

  return tagNames;
}

async function safeReadBody(response) {
  try {
    return await response.text();
  } catch (error) {
    return error && error.message ? error.message : 'Unable to read response body';
  }
}

function findLatestSemverTag(tagNames) {
  const parsed = [];

  for (const name of tagNames) {
    try {
      parsed.push(parseVersion(name));
    } catch (error) {
      continue; // Ignore non-semver tags
    }
  }

  if (parsed.length === 0) {
    return null;
  }

  parsed.sort((left, right) => compareSemver(right, left));
  return parsed[0].normalized;
}

function setOutput(name, value) {
  const outputFile = process.env.GITHUB_OUTPUT;
  const stringValue = value === undefined || value === null ? '' : String(value);

  if (!outputFile) {
    console.log(`${name}=${stringValue}`);
    return;
  }

  fs.appendFileSync(outputFile, `${name}=${stringValue}\n`, { encoding: 'utf8' });
}

async function main() {
  const token = (process.env.GITHUB_TOKEN || '').trim();
  const tokenPresent = Boolean(token);
  console.log(`[calculate-version] GITHUB_TOKEN present=${tokenPresent}`);
  if (!token) {
    throw new Error('GITHUB_TOKEN is required for calculate-version action.');
  }

  const repoSlug = process.env.GITHUB_REPOSITORY || '';
  const [owner, repo] = repoSlug.split('/');
  if (!owner || !repo) {
    throw new Error(`Unable to determine repository owner/name from GITHUB_REPOSITORY: ${repoSlug}`);
  }
  console.log(`[calculate-version] repository=${owner}/${repo}`);

  const apiBase = ((process.env.GITHUB_API_URL || 'https://api.github.com').trim() || 'https://api.github.com')
    .replace(/\/$/, '');
  console.log(`[calculate-version] apiBase=${apiBase}`);

  const releaseType = process.env.RELEASE_TYPE || '';
  const explicitVersion = process.env.EXPLICIT_VERSION || '';

  const tags = await fetchTags({ owner, repo, token, apiBase });
  console.log(`[calculate-version] fetched ${Array.isArray(tags) ? tags.length : 0} tags`);
  const latestTag = findLatestSemverTag(tags);
  console.log(`[calculate-version] latest semantic tag=${latestTag}`);

  const result = resolveNextVersion({
    currentTag: latestTag,
    releaseType,
    explicitVersion
  });

  setOutput('next_version', result.nextVersion);
  setOutput('is_bootstrap', String(result.isBootstrap));
  setOutput('previous_version', result.previousVersion || '');
  setOutput('release_strategy', result.releaseStrategy);
  setOutput('resolved_release_type', result.releaseType);

  console.log(`[calculate-version] next_version=${result.nextVersion}`);
  if (result.previousVersion) {
    console.log(`[calculate-version] previous_version=${result.previousVersion}`);
  } else {
    console.log('[calculate-version] bootstrap run (no prior semantic tags found).');
  }
  console.log(`[calculate-version] release_strategy=${result.releaseStrategy}`);
  console.log(`[calculate-version] resolved_release_type=${result.releaseType}`);

  if (explicitVersion && explicitVersion.trim()) {
    console.log(`[calculate-version] explicit override applied: ${explicitVersion.trim()}`);
  }
}

main().catch((error) => {
  console.error(`[calculate-version] ${error.message}`);
  process.exit(1);
});
