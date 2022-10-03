import * as rts from './rts.mjs';
import module from './curl-gen-wasm.wasm.mjs';
import req from './curl-gen-wasm.req.mjs';

async function handleModule(m) {
    const asterius = await rts.newAsteriusInstance(Object.assign(req, { module: m }));

    const checkThreads = document.getElementById('checkThreads');
    const checkRandom = document.getElementById('checkRandom');

    const inputText = document.getElementById('inputText');
    const outputText = document.getElementById('outputText');

    let scriptExt = ".txt";

    document.getElementById('generateBashButton').addEventListener('click', async _ => {
        outputText.value = await asterius.exports.generateBash(checkThreads.checked, checkRandom.checked, inputText.value);
        scriptExt = ".sh"
    });

    document.getElementById('generatePwshButton').addEventListener('click', async _ => {
        outputText.value = await asterius.exports.generatePwsh(checkThreads.checked, checkRandom.checked, inputText.value);
        scriptExt = ".ps1"
    });

    document.getElementById('downloadButton').addEventListener('click', _ => {
        var element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(outputText.value));
        element.setAttribute('download', 'script' + scriptExt);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
    });
}

module.then(handleModule);