// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

// Alpine.js for client-side interactivity
import Alpine from "alpinejs";

// Helper function to get/set cookies
function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(";").shift();
  return null;
}

function setCookie(name, value, days = 365) {
  const expires = new Date(Date.now() + days * 864e5).toUTCString();
  document.cookie = `${name}=${value}; expires=${expires}; path=/; SameSite=Lax`;
}

// Language switcher Alpine component
Alpine.data("languageSwitcher", () => ({
  locale: getCookie("locale") || "en",

  init() {
    this.updateLocale();
  },

  switchLocale(newLocale) {
    this.locale = newLocale;
    setCookie("locale", newLocale);
    // Reload page to apply new locale on server-side
    window.location.reload();
  },

  updateLocale() {
    // Update HTML lang attribute
    document.documentElement.lang = this.locale === "en" ? "en" : "pt-BR";
  },
}));

// Start Alpine
window.Alpine = Alpine;
Alpine.start();

// LiveSocket configuration with Alpine integration
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

// Hooks for Alpine + LiveView integration
let Hooks = {};
Hooks.Alpine = {
  mounted() {
    Alpine.initTree(this.el);
  },
  updated() {
    Alpine.initTree(this.el);
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  dom: {
    // Preserve Alpine state during LiveView updates
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

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
