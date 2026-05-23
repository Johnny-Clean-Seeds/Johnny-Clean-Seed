async function sha256hex(text) {
  const data = new TextEncoder().encode(text);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, "0")).join("");
}

async function openSite() {
  const input = document.getElementById("code").value || "";
  const test = await sha256hex(window.siteSalt + input);

  if (test !== window.siteCheck) {
    document.getElementById("message").textContent = "Access denied.";
    return;
  }

  if (document.getElementById("remember").checked) {
    localStorage.setItem("project-index-token", input);
  } else {
    localStorage.removeItem("project-index-token");
  }

  document.getElementById("gate").classList.add("hidden");
  document.getElementById("app").classList.remove("hidden");
  await loadItems();
}

async function loadItems() {
  const list = document.getElementById("list");
  const copyBox = document.getElementById("copyBox");
  let allText = "";

  for (const item of window.siteItems) {
    const res = await fetch(item.path);
    const text = await res.text();

    const d = document.createElement("details");
    const s = document.createElement("summary");
    const p = document.createElement("pre");

    s.textContent = item.name;
    p.textContent = text;

    d.appendChild(s);
    d.appendChild(p);
    list.appendChild(d);

    allText += "\\n\\n===== " + item.name + " =====\\n" + text;
  }

  copyBox.value = allText.trim();
}

document.getElementById("openBtn").addEventListener("click", openSite);
document.getElementById("code").addEventListener("keydown", e => {
  if (e.key === "Enter") openSite();
});
document.getElementById("copyBtn").addEventListener("click", async () => {
  const box = document.getElementById("copyBox");
  box.select();
  await navigator.clipboard.writeText(box.value);
});

const saved = localStorage.getItem("project-index-token");
if (saved) {
  document.getElementById("code").value = saved;
  document.getElementById("remember").checked = true;
}
