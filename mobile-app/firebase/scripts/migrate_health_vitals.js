#!/usr/bin/env node

/**
 * Migration script to move HealthVitals documents from the root collection
 * into per-user subcollections at /users/{userId}/HealthVitals/{vitalId}.
 *
 * Usage:
 *   node firebase/scripts/migrate_health_vitals.js --project=<projectId>
 *
 * Authentication:
 *   - Set GOOGLE_APPLICATION_CREDENTIALS to a service-account JSON, or
 *   - Run with `firebase login` and `gcloud auth application-default login`, or
 *   - Run inside an environment with Workload Identity / Cloud credentials.
 *
 * Safety:
 *   - The script copies each document to the destination first.
 *   - Once the copy succeeds, the source document is deleted.
 *   - Documents missing a userRef field are skipped and logged.
 */

const { initializeApp, applicationDefault, cert, getApps } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const fs = require('node:fs');
const path = require('node:path');

function parseArgs() {
  const args = process.argv.slice(2);
  const options = {};
  for (const arg of args) {
    if (arg.startsWith('--project=')) {
      options.projectId = arg.split('=')[1];
    } else if (arg.startsWith('--credentials=')) {
      options.credentials = arg.split('=')[1];
    } else if (arg === '--dry-run') {
      options.dryRun = true;
    }
  }
  return options;
}

function loadCredentials(credentialsPath) {
  if (!credentialsPath) {
    return null;
  }
  const resolved = path.resolve(credentialsPath);
  const content = fs.readFileSync(resolved, 'utf8');
  return JSON.parse(content);
}

async function ensureApp({ projectId, credentials }) {
  if (getApps().length === 0) {
    if (credentials) {
      initializeApp({
        credential: cert(credentials),
        projectId,
      });
    } else {
      initializeApp({
        credential: applicationDefault(),
        projectId,
      });
    }
  }
  return getFirestore();
}

function getUserIdFromRef(userRef) {
  if (!userRef) {
    return null;
  }
  if (typeof userRef.id === 'string') {
    return userRef.id;
  }
  const segments = userRef.path?.split('/') ?? [];
  const usersIndex = segments.findIndex((segment) => segment === 'users');
  if (usersIndex >= 0 && usersIndex + 1 < segments.length) {
    return segments[usersIndex + 1];
  }
  return segments.length >= 2 ? segments[1] : null;
}

async function migrate({ projectId, credentials, dryRun }) {
  const db = await ensureApp({ projectId, credentials });
  const sourceCollection = db.collection('HealthVitals');
  const snapshot = await sourceCollection.get();

  console.log(`Fetched ${snapshot.size} root-level HealthVitals documents.`);
  if (snapshot.empty) {
    console.log('Nothing to migrate.');
    return;
  }

  let migrated = 0;
  let skipped = 0;

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const userRef = data.userRef;
    const userId = getUserIdFromRef(userRef);

    if (!userId) {
      console.warn(`Skipping ${doc.id}: missing or invalid userRef.`);
      skipped += 1;
      continue;
    }

    const destRef = db.collection('users').doc(userId).collection('HealthVitals').doc(doc.id);

    if (dryRun) {
      console.log(`[dry-run] Would migrate doc ${doc.id} -> users/${userId}/HealthVitals/${doc.id}`);
      migrated += 1;
      continue;
    }

    try {
      await destRef.set(data, { merge: true });
      await doc.ref.delete();
      migrated += 1;
      console.log(`Migrated ${doc.id} -> users/${userId}/HealthVitals/${doc.id}`);
    } catch (err) {
      console.error(`Failed to migrate doc ${doc.id}:`, err);
      skipped += 1;
    }
  }

  console.log(`Migration complete. Migrated ${migrated}, skipped ${skipped}.`);
}

(async () => {
  try {
    const options = parseArgs();
    if (!options.projectId) {
      throw new Error('Missing required --project=<projectId> argument.');
    }

    const credentials = loadCredentials(options.credentials);

    await migrate({
      projectId: options.projectId,
      credentials,
      dryRun: options.dryRun ?? false,
    });
  } catch (err) {
    console.error('Migration failed:', err);
    process.exitCode = 1;
  }
})();
