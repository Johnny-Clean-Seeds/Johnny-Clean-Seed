(() => {
  const ACCESS_HASH = "9411BA42080886163A9623155FA29785F7C2BDC137F9A6A0FCF6D5661930B818";
  const STORE_KEY = 'garden-note-access-v1';
  const $ = (id) => document.getElementById(id);
  const enc = new TextEncoder();
  async function sha256hex(text) { const hash = await crypto.subtle.digest('SHA-256', enc.encode(text)); return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('').toUpperCase(); }
  async function openGate() { const code = $('code').value || ''; if (await sha256hex(code) !== ACCESS_HASH) { $('message').textContent = 'Nope.'; return; } if ($('remember').checked) localStorage.setItem(STORE_KEY, code); else localStorage.removeItem(STORE_KEY); $('gate').classList.add('hidden'); $('app').classList.remove('hidden'); renderList(); }
  function lock() { $('app').classList.add('hidden'); $('gate').classList.remove('hidden'); $('viewer').value = ''; }
  function renderList() { const q = ($('search').value || '').toLowerCase(); const files = (window.SITE_MANIFEST.files || []).filter(f => !q || f.path.toLowerCase().includes(q) || f.sha256.toLowerCase().includes(q)); $('counts').textContent = window.SITE_MANIFEST.files.length + ' files | ' + files.length + ' shown'; const list = $('fileList'); list.innerHTML = ''; for (const file of files) { const btn = document.createElement('button'); btn.textContent = file.path; btn.title = file.sha256; btn.addEventListener('click', () => openFile(file)); list.appendChild(btn); } }
  async function openFile(file) { $('fileTitle').textContent = file.path; $('fileMeta').textContent = file.size + ' bytes | ' + file.sha256; const res = await fetch(file.url); $('viewer').value = await res.text(); }
  async function copyAll() { let text = ''; for (const file of window.SITE_MANIFEST.files || []) { const res = await fetch(file.url); text += '===== ' + file.path + ' =====\nsha256: ' + file.sha256 + '\nsize: ' + file.size + '\n\n' + await res.text() + '\n\n'; } await navigator.clipboard.writeText(text.trim()); $('copyStatus').textContent = 'Copied ' + window.SITE_MANIFEST.files.length + ' files.'; }
  $('openBtn').addEventListener('click', openGate); $('lockBtn').addEventListener('click', lock); $('search').addEventListener('input', renderList); $('copyAllBtn').addEventListener('click', copyAll); $('code').addEventListener('keydown', e => { if (e.key === 'Enter') openGate(); });
  const saved = localStorage.getItem(STORE_KEY); if (saved) { $('code').value = saved; $('remember').checked = true; }
})();
