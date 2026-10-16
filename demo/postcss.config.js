// Bootstrap 6 writes its custom properties unprefixed in Sass and adds the
// `bs-` prefix at build time, so its JavaScript (which sets e.g.
// `--bs-range-fill`) only lines up with CSS that has been run through this.
module.exports = {
  plugins: [
    require("postcss-prefix-custom-properties")({ prefix: "bs-" }),
    require("autoprefixer")
  ]
}
