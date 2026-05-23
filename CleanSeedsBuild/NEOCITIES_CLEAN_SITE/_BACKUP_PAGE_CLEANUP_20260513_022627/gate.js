(() => {
  const ACCESS_HASH = '52C531BF9B3EE927C51C5A1FFF45658A4FF911027F3B76ADE35085B7003643D4';
  const STORE_KEY = 'seed-porch-access-v3';
  const $ = (id) => document.getElementById(id);
  const enc = new TextEncoder();
  const fileCache = new Map();
  let activeFile = null;
  let activeGroup = 'all';
  let streamTimer = null;

  const groups = [
    { id: 'all', label: 'All Files', match: () => true },
    { id: 'readme', label: 'Read Me / State', match: (file) => /CURRENT_STATE|NEXT_GATE|state\.json/i.test(file.path) },
    { id: 'maps', label: 'Manifest / Index', match: (file) => /MANIFEST|SHED_INDEX/i.test(file.path) },
    { id: 'todo', label: 'Todo / Gaps', match: (file) => /GAP|TODO/i.test(file.path) },
    { id: 'hashes', label: 'Hashes', match: (file) => /HASH/i.test(file.path) }
  ];

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

  function displayName(file) {
    return file.path;
  }

  function outputText(id) {
    return $(id).textContent || '';
  }

  function setOutput(id, text) {
    $(id).textContent = text;
  }

  function setStatus(id, text) {
    $(id).textContent = text;
    if (text) {
      window.setTimeout(() => {
        if ($(id).textContent === text) $(id).textContent = '';
      }, 2600);
    }
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

  function buildReadme() {
    return [
      'README // CLEAN SEED FILES',
      '==========================',
      '',
      'Public reader for the current Clean Seed notes and file summaries.',
      '',
      '1. Use group buttons to narrow the file list.',
      '2. Use search when you know a word, filename, or hash.',
      '3. Click a file row or View to stream the file into the page.',
      '4. Use Copy or Download only after opening the file you want.',
      '',
      'PUBLIC SAFETY RULE',
      'Exact local machine paths are removed from these public copies.'
    ].join('\n');
  }

  function updateTicker() {
    const ticker = $('tickerText');
    const counter = $('visitorCounter');
    const count = files().length;
    const now = new Date();
    const stamp = now.toLocaleString([], { weekday: 'short', hour: '2-digit', minute: '2-digit' });

    if (ticker) {
      ticker.textContent = `LIVE GARDEN TICKER // ${count} public packet files // last local view ${stamp} // porch open // no mystery jars`;
    }

    if (counter) {
      const key = 'seed-porch-local-visit-count';
      const next = Number(localStorage.getItem(key) || '0') + 1;
      localStorage.setItem(key, String(next));
      counter.textContent = `LOCAL VISIT: ${String(next).padStart(6, '0')}`;
    }
  }

  function groupFor(file) {
    return groups.find((group) => group.id !== 'all' && group.match(file)) || groups[0];
  }

  function selectedGroup() {
    return groups.find((group) => group.id === activeGroup) || groups[0];
  }

  function renderGroups() {
    const nav = $('groupList');
    nav.innerHTML = '';

    for (const group of groups) {
      const count = files().filter(group.match).length;
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'group-chip';
      if (group.id === activeGroup) button.classList.add('active');
      button.textContent = `${group.label} (${count})`;
      button.addEventListener('click', () => {
        activeGroup = group.id;
        renderGroups();
        renderList();
        $('filesSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
      });
      nav.appendChild(button);
    }
  }

  function initializeApp() {
    setOutput('readmeOutput', buildReadme());
    $('dataCount').textContent = `${files().length} files`;
    renderGroups();
    renderList();
    const startFile = files().find((file) => file.path === 'CURRENT_STATE.txt') || files()[0];
    if (startFile) openFile(startFile);
    else setOutput('viewer', 'No public data files are listed.');
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

  function visibleFiles() {
    const q = ($('search').value || '').toLowerCase();
    const group = selectedGroup();

    return files().filter((file) => {
      const cached = fileCache.get(file.path) || '';
      const matchesGroup = group.match(file);
      const matchesSearch = !q ||
        file.path.toLowerCase().includes(q) ||
        file.sha256.toLowerCase().includes(q) ||
        cached.toLowerCase().includes(q);

      return matchesGroup && matchesSearch;
    });
  }

  function renderList() {
    const visible = visibleFiles();
    const groupLabel = selectedGroup().label;
    $('counts').textContent = `${groupLabel} | ${visible.length} shown | ${files().length} total`;

    const list = $('fileList');
    list.innerHTML = '';

    if (visible.length === 0) {
      const empty = document.createElement('p');
      empty.className = 'empty-list';
      empty.textContent = 'No matching files. Try All Files, clear search, or Search File Text.';
      list.appendChild(empty);
      return;
    }

    for (const file of visible) {
      const row = document.createElement('article');
      row.className = 'file-row';
      row.tabIndex = 0;
      row.setAttribute('role', 'button');
      row.dataset.action = 'load';
      row.dataset.path = file.path;
      row.title = `Open ${file.path}`;
      if (activeFile && activeFile.path === file.path) row.classList.add('active');

      const info = document.createElement('button');
      info.type = 'button';
      info.className = 'file-info file-open';
      info.dataset.action = 'load';
      info.dataset.path = file.path;

      const name = document.createElement('strong');
      name.textContent = displayName(file);

      const meta = document.createElement('span');
      const groupName = groupFor(file).label;
      meta.textContent = `${groupName} | ${formatBytes(file.size)} | sha256 ${file.sha256.slice(0, 14)}...`;
      meta.title = file.sha256;

      info.appendChild(name);
      info.appendChild(meta);

      const actions = document.createElement('div');
      actions.className = 'file-row-actions compact';

      const viewBtn = document.createElement('button');
      viewBtn.type = 'button';
      viewBtn.className = 'mini-metal';
      viewBtn.dataset.action = 'load';
      viewBtn.dataset.path = file.path;
      viewBtn.textContent = 'View';

      const copyBtn = document.createElement('button');
      copyBtn.type = 'button';
      copyBtn.className = 'mini-metal';
      copyBtn.dataset.action = 'copy';
      copyBtn.dataset.path = file.path;
      copyBtn.textContent = 'Copy';

      actions.appendChild(viewBtn);
      actions.appendChild(copyBtn);
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

    if (control.dataset.action === 'copy') {
      event.stopPropagation();
      copyFile(file);
      return;
    }

    openFile(file);
  }

  function handleFileListKeydown(event) {
    if (event.key !== 'Enter' && event.key !== ' ') return;
    const control = event.target.closest('[data-action][data-path]');
    if (!control) return;

    event.preventDefault();
    const file = findFile(control.dataset.path);
    if (!file) return;

    if (control.dataset.action === 'copy') copyFile(file);
    else openFile(file);
  }

  async function openFile(file) {
    activeFile = file;
    $('fileTitle').textContent = displayName(file);
    $('fileMeta').textContent = `${groupFor(file).label} | ${formatBytes(file.size)} | sha256 ${file.sha256}`;
    setOutput('viewer', 'Loading...');
    $('downloadLoadedLink').href = file.url;
    $('downloadLoadedLink').download = file.path.split('/').pop();
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

  async function loadAllForSearch() {
    $('counts').textContent = 'Loading file text for search...';
    for (const file of files()) {
      await readFile(file);
    }
    renderList();
    setStatus('loadedCopyStatus', 'Search can now read loaded file text.');
  }

  $('openBtn').addEventListener('click', openGate);
  $('lockBtn').addEventListener('click', lock);
  $('fileList').addEventListener('click', handleFileListClick);
  $('fileList').addEventListener('keydown', handleFileListKeydown);
  $('search').addEventListener('input', renderList);
  $('searchAllBtn').addEventListener('click', loadAllForSearch);
  $('copyReadmeBtn').addEventListener('click', () => copyTextFrom('readmeOutput', 'readmeCopyStatus', 'README'));
  $('copyLoadedBtn').addEventListener('click', () => copyTextFrom('viewer', 'loadedCopyStatus', 'selected file text'));
  $('code').addEventListener('keydown', (event) => {
    if (event.key === 'Enter') openGate();
  });

  updateTicker();
  window.setInterval(updateTicker, 30000);

  const saved = localStorage.getItem(STORE_KEY);
  if (saved) {
    $('code').value = saved;
    $('remember').checked = true;
  }
})();