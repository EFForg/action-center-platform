const { generateWebpackConfig, merge } = require("shakapacker");

module.exports = merge(generateWebpackConfig(), {
  resolve: {
    extensions: [".css", ".js", ".jsx", ".ts", ".tsx"],
  },
});
