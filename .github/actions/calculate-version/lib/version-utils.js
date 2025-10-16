'use strict';

const SEMVER_PATTERN = /^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/;

function parseVersion(input) {
  if (typeof input !== 'string') {
    throw new Error('Version must be a string.');
  }

  const value = input.trim();
  const match = SEMVER_PATTERN.exec(value);

  if (!match) {
    throw new Error(`Invalid semantic version: ${input}`);
  }

  const major = Number.parseInt(match[1], 10);
  const minor = Number.parseInt(match[2], 10);
  const patch = Number.parseInt(match[3], 10);

  return {
    major,
    minor,
    patch,
    raw: value,
    normalized: formatVersion(major, minor, patch)
  };
}

function formatVersion(major, minor, patch) {
  return `v${major}.${minor}.${patch}`;
}

function normalizeVersion(input) {
  return parseVersion(input).normalized;
}

function normalizeReleaseType(value) {
  if (value === undefined || value === null) {
    return 'patch';
  }

  if (typeof value !== 'string') {
    throw new Error('release_type must be a string.');
  }

  const candidate = value.trim().toLowerCase();

  if (!candidate) {
    return 'patch';
  }

  if (!['major', 'minor', 'patch'].includes(candidate)) {
    throw new Error(`Unsupported release_type: ${value}`);
  }

  return candidate;
}

function compareSemver(a, b) {
  if (a.major !== b.major) {
    return a.major - b.major;
  }

  if (a.minor !== b.minor) {
    return a.minor - b.minor;
  }

  return a.patch - b.patch;
}

function incrementVersion(current, releaseType) {
  switch (releaseType) {
    case 'major':
      return formatVersion(current.major + 1, 0, 0);
    case 'minor':
      return formatVersion(current.major, current.minor + 1, 0);
    case 'patch':
      return formatVersion(current.major, current.minor, current.patch + 1);
    default:
      throw new Error(`Unsupported release_type: ${releaseType}`);
  }
}

function resolveNextVersion(options) {
  const currentTag = options.currentTag ? options.currentTag.trim() : '';
  const explicitVersion = options.explicitVersion ? options.explicitVersion.trim() : '';
  const releaseType = normalizeReleaseType(options.releaseType);

  if (!currentTag) {
    if (explicitVersion) {
      const explicit = parseVersion(explicitVersion);
      return {
        nextVersion: explicit.normalized,
        previousVersion: null,
        isBootstrap: true,
        releaseStrategy: 'explicit',
        releaseType
      };
    }

    return {
      nextVersion: 'v1.0.0',
      previousVersion: null,
      isBootstrap: true,
      releaseStrategy: 'bootstrap',
      releaseType
    };
  }

  const current = parseVersion(currentTag);

  if (explicitVersion) {
    const explicit = parseVersion(explicitVersion);
    if (compareSemver(explicit, current) <= 0) {
      throw new Error(`explicit_version ${explicit.normalized} must be greater than ${current.normalized}`);
    }

    return {
      nextVersion: explicit.normalized,
      previousVersion: current.normalized,
      isBootstrap: false,
      releaseStrategy: 'explicit',
      releaseType
    };
  }

  const nextVersion = incrementVersion(current, releaseType);

  return {
    nextVersion,
    previousVersion: current.normalized,
    isBootstrap: false,
    releaseStrategy: 'auto',
    releaseType
  };
}

module.exports = {
  SEMVER_PATTERN,
  parseVersion,
  normalizeVersion,
  normalizeReleaseType,
  compareSemver,
  incrementVersion,
  resolveNextVersion
};
