import * as rts from './rts.mjs';
import module from './curl-gen-wasm.wasm.mjs';
import req from './curl-gen-wasm.req.mjs';

function download(filename, text) {
    var element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
    element.setAttribute('download', filename);

    element.style.display = 'none';
    document.body.appendChild(element);

    element.click();

    document.body.removeChild(element);
}

async function handleModule(m) {
    const asterius = await rts.newAsteriusInstance(Object.assign(req, { module: m }));

    const generatePwshButton = document.getElementById('generatePwshButton');
    const generateBashButton = document.getElementById('generateBashButton');
    const downloadButton = document.getElementById('downloadButton');

    const checkThreads = document.getElementById('checkThreads');
    const checkRandom = document.getElementById('checkRandom');

    const inputText = document.getElementById('inputText');
    const outputText = document.getElementById('outputText');

    let scriptExt = ".txt";

    generateBashButton.addEventListener('click', async _ => {
        outputText.value = await asterius.exports.generateBash(checkThreads.checked, checkRandom.checked, inputText.value)
        scriptExt = ".sh"
    });

    generatePwshButton.addEventListener('click', async _ => {
        outputText.value = await asterius.exports.generatePwsh(checkThreads.checked, checkRandom.checked, inputText.value)
        scriptExt = ".ps1"
    });

    downloadButton.addEventListener('click', _ => {
        download("script" + scriptExt, outputText.value);
    });

}

module.then(handleModule);