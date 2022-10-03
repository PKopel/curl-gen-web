import * as rts from './rts.mjs';
import module from './curl-gen-wasm.wasm.mjs';
import req from './curl-gen-wasm.req.mjs';

async function handleModule(m) {
    const asterius = await rts.newAsteriusInstance(Object.assign(req, { module: m }));
    const threads = document.getElementById('checkThreads');
    const random = document.getElementById('checkRandom');
    const input = document.getElementById('inputText');
    const output = document.getElementById('outputText');
    let file = ".txt";

    document.getElementById('generateBashButton').addEventListener('click', async _ => {
        output.value = await asterius.exports.generateBash(threads.checked, random.checked, input.value);
        file = ".sh"
    });

    document.getElementById('generatePwshButton').addEventListener('click', async _ => {
        output.value = await asterius.exports.generatePwsh(threads.checked, random.checked, input.value);
        file = ".ps1"
    });

    document.getElementById('downloadButton').addEventListener('click', _ => {
        const download = document.createElement('a');
        download.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(output.value));
        download.setAttribute('download', 'script' + file);
        download.click();
    });
}

module.then(handleModule);