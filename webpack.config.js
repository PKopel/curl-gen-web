const CopyWebpackPlugin = require("copy-webpack-plugin");
const path = require('path');

module.exports = {
  mode: 'production',
  entry: './static/index.mjs',
  output: {
    path: path.resolve(__dirname, 'server'),
    filename: 'index.js',
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        { from: 'index.html', context: 'static/' },
        { from: 'index.css', context: 'static/' },
        { from: 'curl-gen-wasm.wasm', context: `${process.env.WASM_OUTPUT_DIR}` }
      ]
    })
  ],
  devServer: {
    static: 'server',
    open: true
  }
};
