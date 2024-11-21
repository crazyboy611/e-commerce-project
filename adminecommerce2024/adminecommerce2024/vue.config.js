const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 3000, // Thay đổi cổng theo nhu cầu của bạn
  },
})
