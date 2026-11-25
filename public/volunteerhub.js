'use strict';
// Progressive enhancement: search remains a normal GET form without JS.
const filter = document.querySelector('#opportunity-filter');
if (filter) {
  let timer, request;
  async function refresh() {
    request?.abort();
    const controller = new AbortController(); request = controller;
    const url = new URL(filter.action, location.origin);
    url.search = new URLSearchParams(new FormData(filter));
    const results = document.querySelector('#opportunity-results');
    results.setAttribute('aria-busy', 'true');
    try {
      const response = await fetch(url, {signal: controller.signal, headers: {'Accept':'text/html'}});
      if (!response.ok) throw new Error('Search failed');
      const doc = new DOMParser().parseFromString(await response.text(), 'text/html');
      const next = doc.querySelector('#opportunity-results');
      if (!next) { location.assign(response.url); return; }
      if (request !== controller) return;
      results.replaceChildren(...next.childNodes);
      history.replaceState(null, '', url);
    } catch (error) { if (error.name !== 'AbortError') location.assign(url); }
    finally { if (request === controller) results.removeAttribute('aria-busy'); }
  }
  filter.addEventListener('submit', e => {e.preventDefault();clearTimeout(timer);refresh();});
  filter.addEventListener('input', () => {clearTimeout(timer);timer=setTimeout(refresh, 250);});
}
document.querySelectorAll('[data-email]').forEach(button => button.addEventListener('click', () => {
  document.querySelector('#email').value = button.dataset.email;
  document.querySelector('#password').value = 'Volunteer123!';
  document.querySelector('#password').focus();
}));
document.querySelector('#print-certificate')?.addEventListener('click', () => window.print());
