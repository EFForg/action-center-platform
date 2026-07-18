const { generateWebpackConfig, merge } = require("shakapacker-webpack");

module.exports = merge(generateWebpackConfig(), {
  resolve: {
    extensions: [".css", ".js", ".jsx", ".ts", ".tsx"],
  },
});
