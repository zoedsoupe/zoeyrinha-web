// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

function setCookie(name, value, days = 365) {
  const expires = new Date(Date.now() + days * 864e5).toUTCString();
  document.cookie = `${name}=${value}; expires=${expires}; path=/; SameSite=Lax`;
}

// Language switcher: store the choice and reload so SetLocale picks it up.
document.querySelectorAll("#locale-switcher [data-locale]").forEach((btn) =>
  btn.addEventListener("click", () => {
    setCookie("locale", btn.dataset.locale);
    window.location.reload();
  }),
);

// Share buttons: copy the canonical URL, flash the "copied!" label.
document.querySelectorAll("[data-share-path]").forEach((btn) => {
  const label = btn.querySelector("[data-share-label]");
  const copied = btn.querySelector("[data-share-copied]");

  btn.addEventListener("click", () => {
    navigator.clipboard.writeText(window.location.origin + btn.dataset.sharePath);
    label.hidden = true;
    copied.hidden = false;
    setTimeout(() => {
      label.hidden = false;
      copied.hidden = true;
    }, 2000);
  });
});

// Copy button on code blocks. Labels come from the body data attributes so
// they follow the page locale.
const copyLabel = document.body.dataset.copyLabel || "copy";
const copiedLabel = document.body.dataset.copiedLabel || "copied!";

document.querySelectorAll(".prose pre").forEach((pre) => {
  pre.classList.add("group", "relative");

  const btn = document.createElement("button");
  btn.type = "button";
  btn.textContent = copyLabel;
  btn.className =
    "absolute top-2 right-2 font-mono text-xs text-gray hover:text-pink transition-colors cursor-pointer sm:opacity-0 sm:group-hover:opacity-100";

  btn.addEventListener("click", () => {
    navigator.clipboard.writeText(pre.querySelector("code").innerText);
    btn.textContent = copiedLabel;
    setTimeout(() => (btn.textContent = copyLabel), 2000);
  });

  pre.appendChild(btn);
});

// Konami code: a few seconds of maximum glitch. Skipped entirely for users
// who prefer reduced motion.
const KONAMI = [
  "ArrowUp", "ArrowUp", "ArrowDown", "ArrowDown",
  "ArrowLeft", "ArrowRight", "ArrowLeft", "ArrowRight", "b", "a",
];
let konamiProgress = 0;
const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

document.addEventListener("keydown", (e) => {
  konamiProgress = e.key === KONAMI[konamiProgress] ? konamiProgress + 1 : 0;

  if (konamiProgress === KONAMI.length) {
    konamiProgress = 0;
    if (reducedMotion.matches) return;
    document.body.classList.add("glitch-storm");
    setTimeout(() => document.body.classList.remove("glitch-storm"), 3000);
  }
});

// LiveSocket: only pages embedding a LiveView (post comments) pay for a
// websocket. Everything else is plain static HTML.
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

if (document.querySelector("[data-phx-session]")) {
  liveSocket.connect();
}

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// PWA
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () =>
    navigator.serviceWorker.register("/sw.js"),
  );
}
