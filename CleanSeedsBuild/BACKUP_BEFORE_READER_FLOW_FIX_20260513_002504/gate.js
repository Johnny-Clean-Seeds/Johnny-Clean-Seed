(() => {
  const ACCESS_HASH = '52C531BF9B3EE927C51C5A1FFF45658A4FF911027F3B76ADE35085B7003643D4';
  const STORE_KEY = 'waka-seed-porch-access-v2';
  const $ = (id) => document.getElementById(id);
  const enc = new TextEncoder();
  let fileCache = new Map();
  let activeFile = null;

  async function sha256hex(text) {
    const hash = await crypto.subtle.digest('SHA-256', enc.encode(text));
    return Array.from(new Uint8Array(hash)).map((b) => b.toString(16).padStart(2, '0')).join('').toUpperCase();
  }

  function files() {
    return (window.SITE_MANIFEST && Array.isArray(window.SITE_MANIFEST.files)) ? window.SITE_MANIFEST.files : [];
  }

  function fileLabel(file) {
    return `${file.path}\n${file.size} bytes`;
  }

  function setStatus(id, text) {
    $(id).textContent = text;
    if (text) {
      window.setTimeout(() => {
        if ($(id).textContent === text) $(id).textContent = '';
      }, 2600);
    }
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
      'WaKa137 Clean Seed Porch - Human Read Me',
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
      '3. Use Browse The Data to open one file at a time.',
      '4. Use the copy button directly under the text box you want to copy.',
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
    $('viewer').value = '';
    activeFile = null;
    window.scrollTo(0, 0);
  }

  function initializeApp() {
    $('humanReadme').value = buildHumanReadme();
    $('aiPacket').value = buildAiPacketSkeleton();
    $('dataCount').textContent = `${files().length} files`;
    renderList();
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

    for (const file of visible) {
      const btn = document.createElement('button');
      btn.type = 'button';
      btn.textContent = fileLabel(file);
      btn.title = file.sha256;
      if (activeFile && activeFile.path === file.path) btn.classList.add('active');
      btn.addEventListener('click', () => openFile(file));
      list.appendChild(btn);
    }
  }

  async function openFile(file) {
    activeFile = file;
    $('fileTitle').textContent = file.path;
    $('fileMeta').textContent = `${file.size} bytes | sha256 ${file.sha256}`;
    $('viewer').value = 'Loading...';

    try {
      $('viewer').value = await readFile(file);
      renderList();
    }
    catch (error) {
      $('viewer').value = `FAILED TO LOAD FILE\n${error.message}`;
    }
  }

  async function copyTextFrom(id, statusId, label) {
    const text = $(id).value || '';
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
    $('aiPacket').value = text;
    setStatus('copyStatus', `Copied all ${files().length} data files.`);
  }

  $('openBtn').addEventListener('click', openGate);
  $('lockBtn').addEventListener('click', lock);
  $('search').addEventListener('input', renderList);
  $('copyHumanBtn').addEventListener('click', () => copyTextFrom('humanReadme', 'humanCopyStatus', 'Human Read Me'));
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
