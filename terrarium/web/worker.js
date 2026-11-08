// terrarium/web/worker.js -- minimal WASM host worker for grain-emu.
//
// Loads grain-emu.wasm and boots a freestanding RISC-V ELF.
// Console UART output is posted to the main page as text messages.
// No disk, no screen, no envoy -- just UART proof of life.

let x = null;

function view(ptr, len) {
  return new Uint8Array(x.memory.buffer, ptr, len);
}

const dec = new TextDecoder();

const imports = {
  env: {
    host_console(ptr, len) {
      postMessage({ type: 'log', text: dec.decode(view(ptr, len)) });
    },
    host_port(port, ptr, len) {
      postMessage({ type: 'output', port, text: dec.decode(view(ptr, len)) });
    },
    host_entropy(ptr, len) {
      crypto.getRandomValues(view(ptr, len));
    },
    host_now_ms() {
      return performance.now();
    },
    host_disk_flushed() {},
    host_display(x, y, w, h) {},
  },
};

let stopped = false;
let timer = null;

function loop() {
  if (stopped || !x) return;
  const t0 = performance.now();
  let rc;
  while (performance.now() - t0 < 30) {
    rc = x.grain_run(2_000_000);
    if (rc === 0) {
      postMessage({ type: 'exit', code: x.grain_exit_code() });
      return;
    }
    if (rc === 2) {
      timer = setTimeout(loop, x.grain_wake_ms());
      return;
    }
    if (rc !== 3) break;
  }
  timer = setTimeout(loop, 0);
}

async function start(msg) {
  const [wasm, image] = await Promise.all([
    fetch(msg.wasm || 'grain-emu.wasm').then(r => r.arrayBuffer()),
    fetch(msg.image).then(r => {
      if (!r.ok) throw new Error(msg.image + ': ' + r.status);
      return r.arrayBuffer();
    }),
  ]);
  const { instance } = await WebAssembly.instantiate(wasm, imports);
  x = instance.exports;

  const bytes = new Uint8Array(image);
  const p = x.grain_alloc(bytes.length);
  view(p, bytes.length).set(bytes);

  const harts = msg.harts || 1;
  const ram_mib = msg.ram_mib || 128;
  const mask = 0;
  const rc = x.grain_start(p, bytes.length, harts, ram_mib, mask, true);
  if (rc !== 0) throw new Error('grain-emu did not start (rc=' + rc + ')');

  postMessage({ type: 'started' });
  loop();
}

onmessage = (e) => {
  const m = e.data;
  if (m.type === 'start') {
    start(m).catch(err => postMessage({ type: 'error', message: String(err.message || err) }));
  } else if (m.type === 'stop') {
    stopped = true;
    if (timer !== null) clearTimeout(timer);
  }
};
