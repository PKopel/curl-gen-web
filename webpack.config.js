const CopyWebpackPlugin = require("copy-webpack-plugin");
const path = require('path');

module.exports = {
  mode: 'production',
  entry: `${process.env.ASTERIUS_OUTPUT_DIR}/curl-gen-wasm.mjs`,
  output: {
    path: path.resolve(__dirname, 'server'),
    filename: 'index.js',
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        { from: 'index.html', context: 'static/' },
        { from: 'index.css', context: 'static/' },
        { from: '*.wasm', context: `${process.env.ASTERIUS_OUTPUT_DIR}` }
      ]
    })
  ],
  devServer: {
    contentBase: 'server',
    open: true
  }
};
