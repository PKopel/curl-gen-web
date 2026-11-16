import { WASI, OpenFile, File, ConsoleStdout } from '@bjorn3/browser_wasi_shim';
import createJsffiImports from '../build/wasm/curl-gen-wasm.mjs';

async function handleModule() {
    const wasi = new WASI([], [], [
        new OpenFile(new File([])),
        ConsoleStdout.lineBuffered(message => console.log(message)),
        ConsoleStdout.lineBuffered(message => console.error(message)),
    ]);
    const wasm = await WebAssembly.compileStreaming(fetch('./curl-gen-wasm.wasm'));
    const exports = {};
    const imports = {
        wasi_snapshot_preview1: wasi.wasiImport,
        ghc_wasm_jsffi: createJsffiImports(exports),
    };
    const { instance } = await WebAssembly.instantiate(wasm, imports);
    Object.assign(exports, instance.exports);
    wasi.initialize(instance);

    const threads = document.getElementById('checkThreads');
    const random = document.getElementById('checkRandom');
    const input = document.getElementById('inputText');
    const output = document.getElementById('outputText');
    let file = ".txt";

    document.getElementById('generateBashButton').addEventListener('click', async _ => {
        output.value = await exports.generateBash(threads.checked, random.checked, input.value);
        file = ".sh"
    });

    document.getElementById('generatePwshButton').addEventListener('click', async _ => {
        output.value = await exports.generatePwsh(threads.checked, random.checked, input.value);
        file = ".ps1"
    });

    document.getElementById('downloadButton').addEventListener('click', _ => {
        const download = document.createElement('a');
        download.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(output.value));
        download.setAttribute('download', 'script' + file);
        download.click();
    });
}

handleModule();