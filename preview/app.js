// Radio BB - Logika Aplikacji Mobilnej (Live Stream & UI)

const STREAM_URLS = [
  "https://s3.slotex.pl/shoutcast/7010/stream?sid=1",
  "https://s3.slotex.pl:7010/stream/1/?sid=1"
];
let currentStreamIndex = 0;
const METADATA_PROXY_URL = "/api/now-playing";
const METADATA_DIRECT_URL = "https://radiobb.pl/wp-json/radio-bb/v1/now-playing";
const NEWS_RSS_URL = "https://beskidzka24.pl/feed/";

// Harmonogram ramówki tygodniowej (Poniedziałek - Niedziela)
const WEEKLY_SCHEDULE = {
  1: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Niezwykłe historie, reportaże i wspomnienia z kronikarskich archiwów." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Dźwiękowy zapis najciekawszych materiałów i relacji Beskidzkiej TV." },
    { time: "04:30", title: "Bes kitu", desc: "Świeże spojrzenie na wydarzenia kulturalne i społeczne regionu." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Poranny przegląd najciekawszych materiałów wideo z Beskidów." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Humorystyczne, codzienne spojrzenie w gwiazdy z przymrużeniem oka." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Praktyczne porady i podpowiedzi na codzienne wyzwania." },
    { time: "11:10", title: "Bes kitu", desc: "Południowe wydanie audycji autorskiej." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Druga odsłona kosmicznych przepowiedni na dobry humor." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Fascynujące retrospekcje z życia Bielska-Białej i okolic." },
    { time: "14:05", title: "Opowieści Strasznej Treści", desc: "Legendy, tajemnice i mroczne opowieści z beskidzkich szlaków." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Wywiady z autorami, recenzje nowości wydawniczych." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Najlepsza wieczorna selekcja muzyczna dla nocnych marków." },
    { time: "22:30", title: "Życie bez końca", desc: "Nocne rozmowy o filozofii, pasjach i sensie życia." }
  ],
  2: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Niezwykłe historie i kroniki." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Dźwiękowe relacje wideo." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Poranny przegląd Beskidzkiej TV." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Humorystyczne spojrzenie w gwiazdy." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Praktyczne porady codzienne." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Przepowiednie na popołudnie." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Archiwalne wspomnienia." },
    { time: "14:05", title: "Redaktor w podróży", desc: "Wyprawy, ciekawostki turystyczne i relacje ze szlaków." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Rekomendacje literackie na wieczór." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Beskidzkie rytmy wieczorne." }
  ],
  3: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Wspomnienia z Podbeskidzia." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Relacje Beskidzkiej TV." },
    { time: "04:30", title: "Bes kitu", desc: "Komentarze i wydarzenia." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Poranny przegląd relacji." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Humor z gwiazd." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Porady życiowe." },
    { time: "11:10", title: "Bes kitu", desc: "Środek tygodnia bez kitu." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Kosmiczne rady." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Karty historii." },
    { time: "14:05", title: "Ikony popkultury", desc: "Sylwetki legend muzyki, kina i estrady." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Wieczór z literaturą." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Najlepsze nagrania wieczoru." }
  ],
  4: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Historia regionu." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Relacje reporterskie." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Materiały wideo." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Gwiazdy z uśmiechem." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Sprytne wskazówki." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Dobre wiadomości." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Kronikarskie opowieści." },
    { time: "14:05", title: "Opowieści Strasznej Treści", desc: "Legendy i beskidzkie tajemnice." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Książki na wieczór." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Rozgrzewka przed weekendem." }
  ],
  5: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Z archiwum kroniki." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Materiały tygodnia." },
    { time: "04:30", title: "Bes kitu", desc: "Piątkowe spojrzenie." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Piątkowy poranek z TV." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Horoskop na weekend." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Weekendowe pomysły." },
    { time: "11:10", title: "Bes kitu", desc: "Kultura i muzyka." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Druga część horoskopu." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Perełki archiwalne." },
    { time: "14:05", title: "Redaktor w podróży", desc: "Beskidzkie szlaki na weekend." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Lektury weekendowe." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Muzyczny start w piątkową noc." },
    { time: "22:30", title: "Życie bez końca", desc: "Nocne rozmowy." }
  ],
  6: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Nocne archiwa." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Podsumowanie wideo." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Sobotni poranek." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Sobotni humor z gwiazd." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Weekendowy poradnik." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Przepowiednie sobotnie." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Dawne Bielsko i Beskidy." },
    { time: "14:05", title: "Ikony popkultury", desc: "Wielkie przeboje i artyści." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Książki na weekend." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Sobotnia impreza na antenie." }
  ],
  7: [
    { time: "02:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Niedzielne archiwa." },
    { time: "03:20", title: "Z Beskidzkiej TV", desc: "Najlepsze reportaże." },
    { time: "04:30", title: "Bes kitu", desc: "Niedzielny poranek." },
    { time: "08:15", title: "Z Beskidzkiej TV", desc: "Niedzielne wejście w dzień." },
    { time: "09:30", title: "Horoskopy bez wtopy", desc: "Niedzielne gwiazdy." },
    { time: "10:30", title: "Wujek Dobra Rada", desc: "Spokojne porady na niedzielę." },
    { time: "11:10", title: "Bes kitu", desc: "Niedzielne pasmo autorskie." },
    { time: "11:30", title: "Horoskopy bez wtopy", desc: "Horoskop na nadchodzący tydzień." },
    { time: "12:30", title: "Z archiwum Kroniki Beskidzkiej", desc: "Złote karty kroniki." },
    { time: "14:05", title: "Ikony popkultury", desc: "Klasyka i najlepsi wykonawcy." },
    { time: "19:05", title: "Strefa dobrej książki", desc: "Relaks przy dobrej książce." },
    { time: "20:10", title: "Gramy nie śpimy", desc: "Wieczorne wyciszenie muzyczne." },
    { time: "22:30", title: "Życie bez końca", desc: "Głębokie rozmowy na koniec tygodnia." }
  ]
};

const DAY_NAMES = { 1: "Pn", 2: "Wt", 3: "Śr", 4: "Czw", 5: "Pt", 6: "Sob", 7: "Nd" };

// Zmienne stanu aplikacji
const audioEl = document.getElementById("radio-audio");
let isPlaying = false;
let isBuffering = false;
let sleepTimerId = null;
let sleepSecondsRemaining = 0;
let currentTabId = "tab-player";
let selectedScheduleDay = (new Date().getDay() === 0 ? 7 : new Date().getDay());

// Inicjalizacja po załadowaniu DOM
document.addEventListener("DOMContentLoaded", () => {
  initClock();
  initPlayerControls();
  initNavigation();
  initSchedule();
  initNews();
  initSleepTimer();
  initVisualizer();
  startMetadataPolling();
  initBannerActions();
});

// Zegar na pasku statusu Androida
function initClock() {
  const clockEl = document.getElementById("clock-display");
  function update() {
    const now = new Date();
    const h = String(now.getHours()).padStart(2, "0");
    const m = String(now.getMinutes()).padStart(2, "0");
    clockEl.textContent = `${h}:${m}`;
  }
  update();
  setInterval(update, 1000);
}

// Obsługa odtwarzacza audio
function initPlayerControls() {
  const mainPlayBtn = document.getElementById("main-play-btn");
  const miniPlayBtn = document.getElementById("mini-play-btn");
  const volumeSlider = document.getElementById("volume-slider");
  const volumeVal = document.getElementById("volume-val");
  const muteBtn = document.getElementById("mute-btn");
  const liveIndicator = document.getElementById("live-indicator");

  function playStream(index) {
    if (index >= STREAM_URLS.length) {
      console.warn("Wszystkie adresy strumienia Radia BB zawiodły");
      setBufferingState(false);
      setPlayingState(false);
      return;
    }
    currentStreamIndex = index;
    const url = STREAM_URLS[index] + (STREAM_URLS[index].includes("?") ? "&" : "?") + "_t=" + Date.now();
    audioEl.src = url;
    audioEl.load();

    const promise = audioEl.play();
    if (promise !== undefined) {
      promise.then(() => {
        setBufferingState(false);
        setPlayingState(true);
      }).catch(err => {
        console.warn("Błąd strumienia [" + index + "]:", err);
        if (index + 1 < STREAM_URLS.length) {
          playStream(index + 1);
        } else {
          setBufferingState(false);
          setPlayingState(false);
        }
      });
    }
  }

  function togglePlay() {
    if (isPlaying) {
      audioEl.pause();
      setPlayingState(false);
    } else {
      setBufferingState(true);
      playStream(0);
    }
  }

  mainPlayBtn.addEventListener("click", togglePlay);
  miniPlayBtn.addEventListener("click", (e) => {
    e.stopPropagation();
    togglePlay();
  });

  audioEl.addEventListener("playing", () => {
    setBufferingState(false);
    setPlayingState(true);
  });

  audioEl.addEventListener("waiting", () => {
    setBufferingState(true);
  });

  audioEl.addEventListener("pause", () => {
    setPlayingState(false);
  });

  audioEl.addEventListener("error", (e) => {
    console.warn("Zdarzenie błędu audio:", e);
    if (isPlaying && currentStreamIndex + 1 < STREAM_URLS.length) {
      playStream(currentStreamIndex + 1);
    } else {
      setBufferingState(false);
      setPlayingState(false);
    }
  });

  // Regulacja głośności
  let previousVolume = 0.8;
  volumeSlider.addEventListener("input", (e) => {
    const val = e.target.value / 100;
    audioEl.volume = val;
    volumeVal.textContent = `${e.target.value}%`;
  });

  muteBtn.addEventListener("click", () => {
    if (audioEl.volume > 0) {
      previousVolume = audioEl.volume;
      audioEl.volume = 0;
      volumeSlider.value = 0;
      volumeVal.textContent = "0%";
    } else {
      audioEl.volume = previousVolume || 0.8;
      volumeSlider.value = Math.round(audioEl.volume * 100);
      volumeVal.textContent = `${volumeSlider.value}%`;
    }
  });

  // Udostępnianie
  document.getElementById("share-radio-btn").addEventListener("click", () => {
    if (navigator.share) {
      navigator.share({
        title: "Radio BB – Beskidzkie brzmienia",
        text: "Słucham Radia BB na żywo! Dołącz do mnie:",
        url: "https://radiobb.pl"
      }).catch(() => {});
    } else {
      navigator.clipboard.writeText("https://radiobb.pl");
      alert("Skopiowano link do Radia BB (radiobb.pl) do schowka!");
    }
  });
}

function setPlayingState(playing) {
  isPlaying = playing;
  const playIcons = document.querySelectorAll(".icon-play, .mini-icon-play");
  const pauseIcons = document.querySelectorAll(".icon-pause, .mini-icon-pause");
  const liveIndicator = document.getElementById("live-indicator");
  const miniStatus = document.getElementById("mini-status");

  playIcons.forEach(el => el.style.display = playing ? "none" : "block");
  pauseIcons.forEach(el => el.style.display = playing ? "block" : "none");

  if (playing) {
    liveIndicator.classList.add("playing");
    miniStatus.textContent = "Nadaje na żywo";
    miniStatus.style.color = "var(--amber)";
  } else {
    liveIndicator.classList.remove("playing");
    miniStatus.textContent = "Zatrzymano";
    miniStatus.style.color = "var(--text-muted)";
  }
}

function setBufferingState(buffering) {
  isBuffering = buffering;
  const spinner = document.getElementById("buffering-spinner");
  const playIcon = document.querySelector(".icon-play");
  const pauseIcon = document.querySelector(".icon-pause");

  if (buffering) {
    spinner.style.display = "block";
    playIcon.style.display = "none";
    pauseIcon.style.display = "none";
  } else {
    spinner.style.display = "none";
    setPlayingState(isPlaying);
  }
}

// Odpytywanie endpointu Now Playing (RDS)
function startMetadataPolling() {
  async function fetchMetadata() {
    let titleFound = false;

    // 1. Próba z lokalnego proxy serwera (brak problemów z CORS w przeglądarce)
    try {
      const res = await fetch(METADATA_PROXY_URL, { cache: "no-store" });
      if (res.ok) {
        const data = await res.json();
        if (data.title && data.title.trim()) {
          document.getElementById("now-playing-title").textContent = data.title;
          document.getElementById("mini-title").textContent = data.title;
          titleFound = true;
        }
      }
    } catch (_) {}

    // 2. Jeśli proxy niedostępne (np. tryb plikowy), próba bezpośrednia
    if (!titleFound) {
      try {
        const res = await fetch(METADATA_DIRECT_URL, { cache: "no-store" });
        if (res.ok) {
          const data = await res.json();
          if (data.title && data.title.trim()) {
            document.getElementById("now-playing-title").textContent = data.title;
            document.getElementById("mini-title").textContent = data.title;
            titleFound = true;
          }
        }
      } catch (_) {}
    }

    updateCurrentShowBadge();
  }

  fetchMetadata();
  setInterval(fetchMetadata, 10000);
}

function updateCurrentShowBadge() {
  const now = new Date();
  const day = (now.getDay() === 0 ? 7 : now.getDay());
  const list = WEEKLY_SCHEDULE[day] || [];
  const currentMinutes = now.getHours() * 60 + now.getMinutes();

  let active = null;
  for (let i = 0; i < list.length; i++) {
    const p = list[i];
    const [h, m] = p.time.split(":").map(Number);
    if (h * 60 + m <= currentMinutes) {
      active = p;
    } else {
      break;
    }
  }

  const badgeEl = document.getElementById("current-show-badge");
  if (active) {
    badgeEl.textContent = `AUDYCJA: ${active.title.toUpperCase()} (${active.time})`;
  } else {
    badgeEl.textContent = "AUDYCJA: MUZYKA W TWOIM RYTMIE";
  }
}

// Nawigacja dolna
function initNavigation() {
  const tabs = document.querySelectorAll(".nav-tab");
  const miniPlayer = document.getElementById("mini-player");

  tabs.forEach(btn => {
    btn.addEventListener("click", () => {
      const targetId = btn.getAttribute("data-tab");
      switchTab(targetId);
    });
  });

  miniPlayer.addEventListener("click", () => {
    switchTab("tab-player");
  });
}

function switchTab(tabId) {
  currentTabId = tabId;

  // Ukryj wszystkie strony
  document.querySelectorAll(".tab-page").forEach(page => page.classList.remove("active"));
  document.getElementById(tabId).classList.add("active");

  // Aktywuj przycisk w nawigacji
  document.querySelectorAll(".nav-tab").forEach(btn => {
    btn.classList.toggle("active", btn.getAttribute("data-tab") === tabId);
  });

  // Pokaż/ukryj mini player
  const miniPlayer = document.getElementById("mini-player");
  if (tabId === "tab-player") {
    miniPlayer.style.display = "none";
  } else {
    miniPlayer.style.display = "flex";
  }
}

// Inicjalizacja Ramówki
function initSchedule() {
  const daysBar = document.getElementById("schedule-days-bar");
  daysBar.innerHTML = "";

  const todayDay = (new Date().getDay() === 0 ? 7 : new Date().getDay());

  for (let d = 1; d <= 7; d++) {
    const chip = document.createElement("button");
    chip.className = `day-chip ${d === selectedScheduleDay ? "active" : ""} ${d === todayDay ? "today" : ""}`;
    chip.textContent = DAY_NAMES[d];
    chip.addEventListener("click", () => {
      selectedScheduleDay = d;
      document.querySelectorAll(".day-chip").forEach(c => c.classList.remove("active"));
      chip.classList.add("active");
      renderScheduleList();
    });
    daysBar.appendChild(chip);
  }

  renderScheduleList();
}

function renderScheduleList() {
  const listEl = document.getElementById("schedule-list");
  listEl.innerHTML = "";

  const now = new Date();
  const todayDay = (now.getDay() === 0 ? 7 : now.getDay());
  const isToday = selectedScheduleDay === todayDay;
  const currentMinutes = now.getHours() * 60 + now.getMinutes();

  const progs = WEEKLY_SCHEDULE[selectedScheduleDay] || [];

  progs.forEach((prog, index) => {
    const [h, m] = prog.time.split(":").map(Number);
    const progMin = h * 60 + m;
    const nextProg = progs[index + 1];
    let isLive = false;

    if (isToday) {
      if (nextProg) {
        const [nh, nm] = nextProg.time.split(":").map(Number);
        isLive = progMin <= currentMinutes && (nh * 60 + nm) > currentMinutes;
      } else {
        isLive = progMin <= currentMinutes;
      }
    }

    const card = document.createElement("div");
    card.className = `prog-card ${isLive ? "live-now" : ""}`;
    card.innerHTML = `
      <div class="prog-time">${prog.time}</div>
      <div class="prog-details">
        <div class="prog-title-row">
          <span class="prog-title">${prog.title}</span>
          ${isLive ? '<span class="prog-badge-live">TERAZ</span>' : ''}
        </div>
        <p class="prog-desc">${prog.desc}</p>
      </div>
    `;
    listEl.appendChild(card);
  });
}

// Inicjalizacja Wiadomości (RSS z Beskidzka24.pl)
async function initNews() {
  const container = document.getElementById("news-container");
  try {
    // Używamy RSS2JSON lub bezpośredniego pobrania
    const apiUrl = `https://api.rss2json.com/v1/api.json?rss_url=${encodeURIComponent(NEWS_RSS_URL)}`;
    const res = await fetch(apiUrl);
    if (res.ok) {
      const data = await res.json();
      if (data.items && data.items.length > 0) {
        renderNewsList(data.items);
        return;
      }
    }
  } catch (err) {
    console.warn("Błąd pobierania RSS:", err);
  }

  // Fallback wiadomości
  renderFallbackNews();
}

function renderNewsList(items) {
  const container = document.getElementById("news-container");
  container.innerHTML = "";

  items.slice(0, 10).forEach(item => {
    const dateStr = item.pubDate ? item.pubDate.substring(0, 16) : "Dzisiaj";
    const card = document.createElement("a");
    card.href = item.link;
    card.target = "_blank";
    card.className = "news-card";
    card.innerHTML = `
      <div class="news-meta">
        <span>BESKIDZKA24.PL</span>
        <span>${dateStr}</span>
      </div>
      <h3 class="news-title">${item.title}</h3>
      <p class="news-excerpt">${stripHtml(item.description).substring(0, 120)}...</p>
      <span class="news-readmore">Czytaj w serwisie ↗</span>
    `;
    container.appendChild(card);
  });
}

function renderFallbackNews() {
  const container = document.getElementById("news-container");
  container.innerHTML = `
    <a href="https://beskidzka24.pl" target="_blank" class="news-card">
      <div class="news-meta"><span>BESKIDZKA24.PL</span><span>Bieżące</span></div>
      <h3 class="news-title">Nowe Radio BB nadaje z Bielska-Białej i Beskidów!</h3>
      <p class="news-excerpt">Beskidzkie brzmienia w nowej rozgłośni radiowej Beskidzkiej Grupy Medialnej. Sprawdź najnowsze audycje i muzykę.</p>
      <span class="news-readmore">Czytaj na portalu ↗</span>
    </a>
    <a href="https://kronika.beskidzka.pl" target="_blank" class="news-card">
      <div class="news-meta"><span>KRONIKA BESKIDZKA</span><span>Wydanie</span></div>
      <h3 class="news-title">Najświeższe wydanie Kroniki Beskidzkiej w kioskach i online</h3>
      <p class="news-excerpt">Sprawdź najważniejsze tematy tygodnia z życia mieszkańców Podbeskidzia, Bielska-Białej, Żywca i Cieszyna.</p>
      <span class="news-readmore">Czytaj na portalu ↗</span>
    </a>
  `;
}

function stripHtml(html) {
  const tmp = document.createElement("div");
  tmp.innerHTML = html;
  return tmp.textContent || tmp.innerText || "";
}

// Sleep Timer
function initSleepTimer() {
  const trigger = document.getElementById("sleep-timer-trigger");
  const modal = document.getElementById("sleep-modal");
  const closeModal = document.getElementById("close-sleep-modal");
  const activeBox = document.getElementById("sleep-active-box");
  const minLeftEl = document.getElementById("sleep-min-left");
  const cancelBtn = document.getElementById("cancel-sleep-btn");
  const sleepBtnText = document.getElementById("sleep-btn-text");

  trigger.addEventListener("click", () => {
    modal.style.display = "flex";
  });

  closeModal.addEventListener("click", () => {
    modal.style.display = "none";
  });

  modal.addEventListener("click", (e) => {
    if (e.target === modal) modal.style.display = "none";
  });

  document.querySelectorAll(".timer-chip").forEach(chip => {
    chip.addEventListener("click", () => {
      const minutes = parseInt(chip.getAttribute("data-time"), 10);
      startSleepCountdown(minutes);
      modal.style.display = "none";
    });
  });

  cancelBtn.addEventListener("click", () => {
    clearInterval(sleepTimerId);
    sleepTimerId = null;
    sleepSecondsRemaining = 0;
    activeBox.style.display = "none";
    trigger.classList.remove("active");
    sleepBtnText.textContent = "Sleep";
    modal.style.display = "none";
  });

  function startSleepCountdown(minutes) {
    clearInterval(sleepTimerId);
    sleepSecondsRemaining = minutes * 60;
    trigger.classList.add("active");
    activeBox.style.display = "flex";
    minLeftEl.textContent = minutes;
    sleepBtnText.textContent = `${minutes}m`;

    sleepTimerId = setInterval(() => {
      sleepSecondsRemaining--;
      const minLeft = Math.ceil(sleepSecondsRemaining / 60);
      minLeftEl.textContent = minLeft;
      sleepBtnText.textContent = `${minLeft}m`;

      if (sleepSecondsRemaining <= 0) {
        clearInterval(sleepTimerId);
        sleepTimerId = null;
        trigger.classList.remove("active");
        activeBox.style.display = "none";
        sleepBtnText.textContent = "Sleep";
        audioEl.pause();
        setPlayingState(false);
      }
    }, 1000);
  }
}

// Animowany wizualizer grani Beskidów (Canvas)
function initVisualizer() {
  const canvas = document.getElementById("mountainCanvas");
  const ctx = canvas.getContext("2d");
  let phase = 0;

  function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const w = canvas.width;
    const h = canvas.height;

    // Linia 1: Miękka głęboka grań
    ctx.beginPath();
    ctx.strokeStyle = "rgba(11, 110, 158, 0.45)";
    ctx.lineWidth = 2.0;

    const points = 24;
    const dx = w / points;

    for (let i = 0; i <= points; i++) {
      const x = i * dx;
      const baseRidge = Math.sin(i * 0.45) * 10 + Math.cos(i * 0.8) * 6;
      const wave = isPlaying ? Math.cos(phase + i * 0.5) * 8 : 0;
      const y = (h * 0.55) - (baseRidge * 0.8) + wave;
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    ctx.stroke();

    // Linia 2: Główna grań neon cyan
    ctx.beginPath();
    ctx.strokeStyle = isPlaying ? "#1387bb" : "#0b6e9e";
    ctx.lineWidth = 2.6;

    for (let i = 0; i <= points; i++) {
      const x = i * dx;
      const baseRidge = Math.sin(i * 0.45) * 10 + Math.cos(i * 0.8) * 6;
      const wave = isPlaying ? Math.sin(phase + i * 0.6) * 11 : 0;
      const y = (h * 0.58) - baseRidge - wave;
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    ctx.stroke();

    if (isPlaying) {
      phase += 0.06;
    }
    requestAnimationFrame(draw);
  }

  requestAnimationFrame(draw);
}

// Akcje paska desktopowego
function initBannerActions() {
  const toggleBtn = document.getElementById("toggle-frame-btn");
  const phone = document.getElementById("phone-container");
  const copyBtn = document.getElementById("copy-stream-btn");

  toggleBtn.addEventListener("click", () => {
    phone.classList.toggle("frameless");
    toggleBtn.textContent = phone.classList.contains("frameless")
      ? "Pokaż ramkę telefonu"
      : "Przełącz ramkę telefonu";
  });

  copyBtn.addEventListener("click", () => {
    navigator.clipboard.writeText(STREAM_URL);
    copyBtn.textContent = "Skopiowano!";
    setTimeout(() => {
      copyBtn.textContent = "Kopiuj link strumienia";
    }, 2000);
  });
}
