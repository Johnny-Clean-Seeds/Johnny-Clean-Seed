(() => {
  const ACCESS_HASH = '52C531BF9B3EE927C51C5A1FFF45658A4FF911027F3B76ADE35085B7003643D4';
  const STORE_KEY = 'waka-seed-porch-access-v2';
  const $ = (id) => document.getElementById(id);
  const enc = new TextEncoder();
  let fileCache = new Map();
  let activeFile = null;
  let streamTimer = null;

  async function sha256hex(text) {
    const hash = await crypto.subtle.digest('SHA-256', enc.encode(text));
    return Array.from(new Uint8Array(hash)).map((b) => b.toString(16).padStart(2, '0')).join('').toUpperCase();
  }

  function files() {
    return (window.SITE_MANIFEST && Array.isArray(window.SITE_MANIFEST.files)) ? window.SITE_MANIFEST.files : [];
  }

  function formatBytes(size) {
    if (size >= 1024 * 1024) return `${(size / (1024 * 1024)).toFixed(2)} MB`;
    if (size >= 1024) return `${(size / 1024).toFixed(1)} KB`;
    return `${size} bytes`;
  }

  function fileLabel(file) {
    return `${file.path} - ${formatBytes(file.size)}`;
  }

  function setStatus(id, text) {
    $(id).textContent = text;
    if (text) {
      window.setTimeout(() => {
        if ($(id).textContent === text) $(id).textContent = '';
      }, 2600);
    }
  }

  function outputText(id) {
    return $(id).textContent || '';
  }

  function setOutput(id, text) {
    $(id).textContent = text;
  }

  function streamOutput(id, text) {
    const node = $(id);
    if (streamTimer) window.clearInterval(streamTimer);
    node.textContent = '';
    node.classList.add('streaming');

    const total = text.length;
    const chunk = Math.max(18, Math.ceil(total / 90));
    let index = 0;

    streamTimer = window.setInterval(() => {
      index = Math.min(index + chunk, total);
      node.textContent = text.slice(0, index);
      if (index >= total) {
        window.clearInterval(streamTimer);
        streamTimer = null;
        node.classList.remove('streaming');
      }
    }, 12);
  }

  async function readFile(file) {
    if (fileCache.has(file.path)) return fileCache.get(file.path);
    const res = await fetch(file.url);
    if (!res.ok) throw new Error(`Could not load ${file.path}`);
    const text = await res.text();
    fileCache.set(file.path, text);
    return text;
  }

  function buildHumanReadme() {
    const list = files().map((file) => `- ${file.path} (${file.size} bytes)`).join('\n');
    return [
      'WaKa137 Clean Seed Bridge - Start Here',
      '',
      'What this page is:',
      'A clean, readable front desk for the Clean Seed Bridge V1 data. The front page keeps the homemade 1990s mom-site look. The logged-in side is the back-door reader for us.',
      '',
      'What is here:',
      list,
      '',
      'How to use it:',
      '1. Read this Human Section first for the plain meaning.',
      '2. Use the AI Section when you want to copy a structured packet into an assistant.',
      '3. Use Choose A File to see every public data file by name.',
      '4. Use Search Inside All Files when you want the search box to check file contents too.',
      '5. Use Load, Copy, Open, or Download beside each file.',
      '6. Use the copy button directly under the text box you want to copy.',
      '',
      'Clean rule:',
      'This page reads and copies the public bridge data. It does not upload, delete, move, clean, promote, or decide final authority.',
      '',
      'Current idea:',
      'The bridge reports state so a human or AI can see what exists without guessing from chat memory.'
    ].join('\n');
  }

  function buildAiPacketSkeleton() {
    const manifestLines = files().map((file) => {
      return `- path: ${file.path}\n  url: ${file.url}\n  size: ${file.size}\n  sha256: ${file.sha256}\n  modifiedUtc: ${file.modifiedUtc}`;
    }).join('\n');

    return [
      'AI HANDOFF PACKET - WAKA137 CLEAN SEED BRIDGE',
      '',
      'STATUS:',
      'This page exposes the public Clean Seed Bridge V1 data files listed in window.SITE_MANIFEST.',
      '',
      'AUTHORITY:',
      'The bridge reports state. It is not final authority. Do not treat copied text as permission to delete, move, upload, clean, promote, or override the user.',
      '',
      'HUMAN TAG:',
      'WaKa137',
      '',
      'DATA FILE MANIFEST:',
      manifestLines,
      '',
      'AI READING ORDER:',
      '1. CURRENT_STATE.txt',
      '2. NEXT_GATE.txt',
      '3. state.json',
      '4. PROJECT_MANIFEST.json',
      '5. SHED_INDEX.json',
      '6. GAP_TODO_MATCHES.json',
      '7. BRIDGE_OUTPUT_HASHES.json',
      '',
      'COPY NOTE:',
      'Use "Copy All Data Files" when the receiving AI needs the full packet contents.'
    ].join('\n');
  }

  async function buildAllDataPacket() {
    const chunks = [];
    chunks.push(buildAiPacketSkeleton());
    chunks.push('\n\nFULL DATA FILE CONTENTS:');

    for (const file of files()) {
      const text = await readFile(file);
      chunks.push([
        '',
        `===== ${file.path} =====`,
        `url: ${file.url}`,
        `size: ${file.size}`,
        `sha256: ${file.sha256}`,
        `modifiedUtc: ${file.modifiedUtc}`,
        '',
        text
      ].join('\n'));
    }

    return chunks.join('\n');
  }

  async function openGate() {
    const code = $('code').value || '';
    if (await sha256hex(code) !== ACCESS_HASH) {
      $('message').textContent = 'Access denied. Mom said check the sticky note.';
      return;
    }

    if ($('remember').checked) localStorage.setItem(STORE_KEY, code);
    else localStorage.removeItem(STORE_KEY);

    $('gate').classList.add('hidden');
    $('app').classList.remove('hidden');
    $('message').textContent = '';
    window.scrollTo(0, 0);
    initializeApp();
  }

  function lock() {
    $('app').classList.add('hidden');
    $('gate').classList.remove('hidden');
    setOutput('viewer', '');
    activeFile = null;
    window.scrollTo(0, 0);
  }

  function initializeApp() {
    setOutput('humanReadme', buildHumanReadme());
    setOutput('aiPacket', buildAiPacketSkeleton());
    $('dataCount').textContent = `${files().length} files`;
    renderList();
    const startFile = files().find((file) => file.path === 'CURRENT_STATE.txt') || files()[0];
    if (startFile) {
      openFile(startFile);
    }
    else {
      setOutput('viewer', 'No public data files are listed in the manifest.');
    }
  }

  function renderList() {
    const q = ($('search').value || '').toLowerCase();
    const visible = files().filter((file) => {
      const cached = fileCache.get(file.path) || '';
      return !q ||
        file.path.toLowerCase().includes(q) ||
        file.sha256.toLowerCase().includes(q) ||
        cached.toLowerCase().includes(q);
    });

    $('counts').textContent = `${files().length} public data files | ${visible.length} shown | Generated ${window.SITE_MANIFEST.generatedUtc || 'unknown time'}`;
    const list = $('fileList');
    list.innerHTML = '';

    if (visible.length === 0) {
      const empty = document.createElement('p');
      empty.className = 'empty-list';
      empty.textContent = 'No matching files yet. Clear the search or load all file text.';
      list.appendChild(empty);
      return;
    }

    for (const file of visible) {
      const row = document.createElement('article');
      row.className = 'file-row';
      if (activeFile && activeFile.path === file.path) row.classList.add('active');

      const info = document.createElement('div');
      info.className = 'file-info';

      const name = document.createElement('strong');
      name.textContent = file.path;

      const meta = document.createElement('span');
      meta.textContent = `${formatBytes(file.size)} | sha256 ${file.sha256.slice(0, 14)}...`;
      meta.title = file.sha256;

      info.appendChild(name);
      info.appendChild(meta);

      const actions = document.createElement('div');
      actions.className = 'file-row-actions';

      const loadBtn = document.createElement('button');
      loadBtn.type = 'button';
      loadBtn.className = 'mini-metal';
      loadBtn.dataset.action = 'load';
      loadBtn.dataset.path = file.path;
      loadBtn.textContent = 'Load';

      const copyBtn = document.createElement('button');
      copyBtn.type = 'button';
      copyBtn.className = 'mini-metal';
      copyBtn.dataset.action = 'copy';
      copyBtn.dataset.path = file.path;
      copyBtn.textContent = 'Copy';

      const openLink = document.createElement('a');
      openLink.className = 'mini-metal';
      openLink.href = file.url;
      openLink.target = '_blank';
      openLink.rel = 'noopener';
      openLink.textContent = 'Open';

      const downloadLink = document.createElement('a');
      downloadLink.className = 'mini-metal';
      downloadLink.href = file.url;
      downloadLink.download = file.path.split('/').pop();
      downloadLink.textContent = 'Download';

      actions.appendChild(loadBtn);
      actions.appendChild(copyBtn);
      actions.appendChild(openLink);
      actions.appendChild(downloadLink);

      row.appendChild(info);
      row.appendChild(actions);
      list.appendChild(row);
    }
  }

  function findFile(path) {
    return files().find((file) => file.path === path);
  }

  function handleFileListClick(event) {
    const control = event.target.closest('[data-action][data-path]');
    if (!control) return;

    const file = findFile(control.dataset.path);
    if (!file) return;

    if (control.dataset.action === 'load') {
      openFile(file);
    }

    if (control.dataset.action === 'copy') {
      copyFile(file);
    }
  }

  async function openFile(file) {
    activeFile = file;
    $('fileTitle').textContent = file.path;
    $('fileMeta').textContent = `${formatBytes(file.size)} | sha256 ${file.sha256}`;
    setOutput('viewer', 'Loading...');
    $('openLoadedLink').href = file.url;
    $('downloadLoadedLink').href = file.url;
    $('downloadLoadedLink').download = file.path.split('/').pop();
    $('openLoadedLink').classList.remove('disabled');
    $('downloadLoadedLink').classList.remove('disabled');

    try {
      streamOutput('viewer', await readFile(file));
      renderList();
    }
    catch (error) {
      setOutput('viewer', `FAILED TO LOAD FILE\n${error.message}`);
    }
  }

  async function copyFile(file) {
    try {
      const text = await readFile(file);
      await navigator.clipboard.writeText(text);
      setStatus('loadedCopyStatus', `Copied ${file.path}.`);
      if (!activeFile || activeFile.path !== file.path) openFile(file);
      else renderList();
    }
    catch (error) {
      setStatus('loadedCopyStatus', `Could not copy ${file.path}.`);
    }
  }

  async function copyTextFrom(id, statusId, label) {
    const text = outputText(id);
    if (!text.trim()) {
      setStatus(statusId, 'Nothing loaded to copy yet.');
      return;
    }
    await navigator.clipboard.writeText(text);
    setStatus(statusId, `Copied ${label}.`);
  }

  async function copyAll() {
    $('copyStatus').textContent = 'Building full packet...';
    const text = await buildAllDataPacket();
    await navigator.clipboard.writeText(text);
    streamOutput('aiPacket', text);
    setStatus('copyStatus', `Copied all ${files().length} data files.`);
  }

  async function loadAllForSearch() {
    $('counts').textContent = 'Loading all public data files for search...';
    for (const file of files()) {
      await readFile(file);
    }
    renderList();
    setStatus('loadedCopyStatus', 'Search can now read inside all loaded files.');
  }

  $('openBtn').addEventListener('click', openGate);
  $('lockBtn').addEventListener('click', lock);
  $('fileList').addEventListener('click', handleFileListClick);
  $('search').addEventListener('input', renderList);
  $('searchAllBtn').addEventListener('click', loadAllForSearch);
  $('copyHumanBtn').addEventListener('click', () => copyTextFrom('humanReadme', 'humanCopyStatus', 'overview'));
  $('copyAiBtn').addEventListener('click', () => copyTextFrom('aiPacket', 'copyStatus', 'AI handoff'));
  $('copyAllBtn').addEventListener('click', copyAll);
  $('copyLoadedBtn').addEventListener('click', () => copyTextFrom('viewer', 'loadedCopyStatus', 'loaded file text'));
  $('code').addEventListener('keydown', (event) => {
    if (event.key === 'Enter') openGate();
  });

  const saved = localStorage.getItem(STORE_KEY);
  if (saved) {
    $('code').value = saved;
    $('remember').checked = true;
  }
})();
