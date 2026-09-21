/**
 * Skidora / Habitat Open Trace Interceptor
 * 
 * Lightweight client-side network & error sniffer inspired by Habitat Browser Recorder.
 * Intercepts fetch/XHR, maintains an in-memory ring buffer, and auto-generates
 * reproduction cURL commands for any API call returning HTTP status >= 400.
 * 
 * Usage:
 * - Browser: Paste into DevTools console or include in index.html / layout.tsx
 * - Node.js: require('./scripts/trace-interceptor.js')
 */

(function (global) {
  'use strict';

  if (global.__skidora_trace_installed) return;
  global.__skidora_trace_installed = true;

  const MAX_RING_BUFFER = 30;
  const traces = [];

  function toCurl(req) {
    let cmd = `curl -v -X ${req.method.toUpperCase()} "${req.url}"`;
    const headers = req.headers || {};
    
    for (const [key, val] of Object.entries(headers)) {
      const lower = key.toLowerCase();
      // Skip hop-by-hop or browser-managed headers
      if (['host', 'content-length', 'connection', 'sec-ch-ua', 'sec-fetch-dest', 'sec-fetch-mode', 'sec-fetch-site'].includes(lower)) {
        continue;
      }
      const safeVal = String(val).replace(/"/g, '\\"');
      cmd += ` \\\n  -H "${key}: ${safeVal}"`;
    }

    if (req.body && req.method.toUpperCase() !== 'GET' && req.method.toUpperCase() !== 'HEAD') {
      let bodyStr = typeof req.body === 'string' ? req.body : JSON.stringify(req.body);
      const safeBody = bodyStr.replace(/'/g, "'\\''");
      cmd += ` \\\n  --data '${safeBody}'`;
    }

    return cmd;
  }

  function recordTrace(trace) {
    traces.push(trace);
    if (traces.length > MAX_RING_BUFFER) {
      traces.shift();
    }

    if (trace.status >= 400 || trace.error) {
      const statusLabel = trace.error ? `NETWORK ERROR (${trace.error})` : `HTTP ${trace.status}`;
      console.warn(
        `%c[Skidora / Habitat Trace] 🚨 ${statusLabel}: ${trace.method} ${trace.url}`,
        'background: #7928ca; color: #fff; padding: 2px 6px; font-weight: bold; border-radius: 3px;'
      );
      console.info(
        `%c📋 Reproduction cURL:\n${trace.curl}`,
        'color: #0070f3; font-family: monospace; font-size: 11px;'
      );
    }
  }

  // Intercept window.fetch / globalThis.fetch
  if (typeof global.fetch === 'function') {
    const originalFetch = global.fetch;
    global.fetch = async function (input, init = {}) {
      const startTime = Date.now();
      const method = (init.method || (input instanceof Request ? input.method : 'GET')).toUpperCase();
      const url = typeof input === 'string' ? input : (input instanceof Request ? input.url : String(input));
      
      let headers = {};
      if (init.headers) {
        if (init.headers instanceof Headers) {
          init.headers.forEach((v, k) => { headers[k] = v; });
        } else if (Array.isArray(init.headers)) {
          init.headers.forEach(([k, v]) => { headers[k] = v; });
        } else {
          headers = { ...init.headers };
        }
      }

      let body = init.body || (input instanceof Request ? input.body : null);
      const reqRecord = {
        id: `req_${Date.now()}_${Math.random().toString(36).substr(2, 5)}`,
        timestamp: new Date().toISOString(),
        method,
        url,
        headers,
        body
      };
      reqRecord.curl = toCurl(reqRecord);

      try {
        const response = await originalFetch.apply(this, arguments);
        const durationMs = Date.now() - startTime;
        
        recordTrace({
          ...reqRecord,
          status: response.status,
          statusText: response.statusText,
          durationMs,
          ok: response.ok
        });

        return response;
      } catch (err) {
        const durationMs = Date.now() - startTime;
        recordTrace({
          ...reqRecord,
          status: 0,
          statusText: 'Fetch Error',
          durationMs,
          error: err.message,
          ok: false
        });
        throw err;
      }
    };
  }

  // Intercept XMLHttpRequest in browser environments
  if (typeof global.XMLHttpRequest === 'function') {
    const XHR = global.XMLHttpRequest;
    const originalOpen = XHR.prototype.open;
    const originalSend = XHR.prototype.send;
    const originalSetRequestHeader = XHR.prototype.setRequestHeader;

    XHR.prototype.open = function (method, url) {
      this.__skidora_req = {
        id: `xhr_${Date.now()}_${Math.random().toString(36).substr(2, 5)}`,
        timestamp: new Date().toISOString(),
        method: method.toUpperCase(),
        url: String(url),
        headers: {},
        body: null
      };
      return originalOpen.apply(this, arguments);
    };

    XHR.prototype.setRequestHeader = function (header, value) {
      if (this.__skidora_req) {
        this.__skidora_req.headers[header] = value;
      }
      return originalSetRequestHeader.apply(this, arguments);
    };

    XHR.prototype.send = function (body) {
      if (this.__skidora_req) {
        this.__skidora_req.body = body;
        this.__skidora_req.curl = toCurl(this.__skidora_req);
        const reqData = this.__skidora_req;
        const startTime = Date.now();

        this.addEventListener('loadend', function () {
          recordTrace({
            ...reqData,
            status: this.status,
            statusText: this.statusText,
            durationMs: Date.now() - startTime,
            ok: this.status >= 200 && this.status < 300
          });
        });
      }
      return originalSend.apply(this, arguments);
    };
  }

  // Global API
  global.__skidora = {
    version: '1.0.0-habitat-trace',
    toCurl,
    getTraces: () => [...traces],
    getFailed: () => traces.filter(t => t.status >= 400 || t.error),
    clear: () => { traces.length = 0; },
    exportJson: () => {
      const payload = JSON.stringify(traces, null, 2);
      if (typeof document !== 'undefined') {
        const blob = new Blob([payload], { type: 'application/json' });
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = `skidora-trace-${Date.now()}.json`;
        a.click();
      }
      return payload;
    }
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = global.__skidora;
  }

})(typeof window !== 'undefined' ? window : globalThis);
