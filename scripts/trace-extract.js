#!/usr/bin/env node
/**
 * Skidora / Habitat Open Trace Extractor
 * 
 * Extracts failing HTTP requests from:
 * 1. Habitat Browser Recorder JSON exports
 * 2. W3C Standard .HAR files (Chrome/Firefox DevTools)
 * 3. Skidora trace JSON logs or STDIN
 * 
 * Outputs:
 * - Failing endpoint & status code
 * - Executable cURL reproduction command
 * - Suggested router/handler file targets for Pass A
 */

const fs = require('fs');

function toCurl(entry) {
  const method = (entry.method || entry.request?.method || 'GET').toUpperCase();
  const url = entry.url || entry.request?.url || '';
  let cmd = `curl -v -X ${method} "${url}"`;

  const headers = entry.headers || entry.request?.headers || [];
  if (Array.isArray(headers)) {
    for (const h of headers) {
      const name = h.name || h.key;
      const val = h.value;
      if (name && val && !['host', 'content-length', 'connection'].includes(name.toLowerCase())) {
        cmd += ` \\\n  -H "${name}: ${String(val).replace(/"/g, '\\"')}"`;
      }
    }
  } else if (typeof headers === 'object') {
    for (const [name, val] of Object.entries(headers)) {
      if (!['host', 'content-length', 'connection'].includes(name.toLowerCase())) {
        cmd += ` \\\n  -H "${name}: ${String(val).replace(/"/g, '\\"')}"`;
      }
    }
  }

  const body = entry.body || entry.request?.postData?.text || null;
  if (body && method !== 'GET' && method !== 'HEAD') {
    const safeBody = typeof body === 'string' ? body : JSON.stringify(body);
    cmd += ` \\\n  --data '${safeBody.replace(/'/g, "'\\''")}'`;
  }

  return cmd;
}

function parseData(raw) {
  try {
    return JSON.parse(raw);
  } catch (err) {
    console.error('Error: Input is not valid JSON. Provide a .har file or Habitat JSON report.');
    process.exit(1);
  }
}

function extractFailures(data) {
  const failures = [];

  // HAR format: data.log.entries
  if (data.log && Array.isArray(data.log.entries)) {
    for (const entry of data.log.entries) {
      const status = entry.response?.status || 0;
      if (status >= 400 || status === 0) {
        failures.push({
          method: entry.request?.method || 'GET',
          url: entry.request?.url || '',
          status,
          statusText: entry.response?.statusText || (status === 0 ? 'Network/CORS Failed' : ''),
          time: entry.time ? `${Math.round(entry.time)}ms` : '—',
          curl: toCurl(entry),
          errorResponse: entry.response?.content?.text || '—'
        });
      }
    }
  }
  // Habitat / Skidora Trace format: Array of trace objects
  else if (Array.isArray(data)) {
    for (const item of data) {
      if (item.status >= 400 || item.error || item.status === 0) {
        failures.push({
          method: item.method || 'GET',
          url: item.url || '',
          status: item.status || 0,
          statusText: item.error || item.statusText || 'Error',
          time: item.durationMs ? `${item.durationMs}ms` : '—',
          curl: item.curl || toCurl(item),
          errorResponse: item.responseBody || '—'
        });
      }
    }
  }

  return failures;
}

function suggestRouterFile(urlStr) {
  try {
    const url = new URL(urlStr);
    const parts = url.pathname.split('/').filter(Boolean);
    if (parts.length === 0) return 'router entry';
    const last = parts[parts.length - 1];
    return `app/api/${parts.join('/')}/route.ts or routes/${last}.ts or router.ex`;
  } catch {
    return 'router handler';
  }
}

function main() {
  const fileArg = process.argv[2];

  if (fileArg && fileArg !== '-') {
    if (!fs.existsSync(fileArg)) {
      console.error(`Error: File not found: ${fileArg}`);
      process.exit(1);
    }
    const content = fs.readFileSync(fileArg, 'utf8');
    runExtraction(content);
  } else {
    // Read from STDIN
    let input = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', chunk => { input += chunk; });
    process.stdin.on('end', () => { runExtraction(input); });
  }
}

function runExtraction(content) {
  const data = parseData(content);
  const failures = extractFailures(data);

  if (failures.length === 0) {
    console.log('✅ No failed network requests (HTTP >= 400) detected.');
    return;
  }

  console.log(`🚨 Found ${failures.length} failing network request(s):\n`);
  failures.forEach((f, idx) => {
    console.log(`[Failure #${idx + 1}] ${f.method} ${f.url}`);
    console.log(`- Status: ${f.status} ${f.statusText} (${f.time})`);
    console.log(`- Pass A Target: Look for route handler in ${suggestRouterFile(f.url)}`);
    console.log(`- Pass B Reproduction cURL:\n${f.curl}\n`);
  });
}

if (require.main === module) {
  main();
}
