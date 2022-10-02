import * as rts from './rts.mjs';
import module from './curl-gen-wasm.wasm.mjs';
import req from './curl-gen-wasm.req.mjs';

async function handleModule(m) {
    const asterius = await rts.newAsteriusInstance(Object.assign(req, { module: m }));

    const generatePwshButton = document.getElementById('generatePwshButton');
    const generateBashButton = document.getElementById('generateBashButton');

    const checkThreads = document.getElementById('checkThreads').checked;
    const checkRandom = document.getElementById('checkRandom').checked;

    const inputText = document.getElementById('inputText');
    const outputText = document.getElementById('outputText');

    generateBashButton.addEventListener('click', async event => {
        outputText.value = await asterius.exports.generateBash(checkThreads, checkRandom, inputText.value)
    });

    generatePwshButton.addEventListener('click', async event => {
        outputText.value = await asterius.exports.generatePwsh(checkThreads, checkRandom, inputText.value)
    });

}

module.then(handleModule);