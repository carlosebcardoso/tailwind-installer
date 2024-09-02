#!/bin/bash

help=$"--h: shows available commands
default: default tailwindcss installation
vue: tailwindcss installation for VueJS
vue -c: installs tailwindcss for VueJS and removes default boilerplate
vue -c -r: installs tailwindcss for VueJS and removes default vue router boilerplate"


function tailwind() {
  function defaultInstall() {
    npm init -y
    npm install -D tailwindcss
    npx tailwindcss init

    printf '/** @type {import('tailwindcss').Config} */
  module.exports = {
    content: ["./src/**/*.{html,js}"],
    theme: {
      extend: {},
    },
    plugins: [],
  }' > tailwind.config.js

    mkdir src
    cd src

    touch input.css
    printf '@tailwind base;
  @tailwind components;
  @tailwind utilities;' > input.css

    touch index.html
    printf '<!doctype html>
  <html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="./output.css" rel="stylesheet">
  </head>
  <body>
    <h1 class="text-3xl font-bold underline">
      Hello world!
    </h1>
  </body>
  </html>' > index.html
    
    cd ..
    sed -i 6's/$/,&/' package.json
    sed -i '7 i \ \ \ \ "dev": "npx tailwindcss -i ./src/input.css -o ./src/output.css --watch"' package.json
  }

  function vueInstall() {
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init -p

    printf '/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}' > tailwind.config.js

    cd src/assets
    touch style.css

    printf '@tailwind base;
@tailwind components;
@tailwind utilities;' > style.css

    cd ../..

    sed -i "1 i import './assets/style.css'" src/main.js
  }

  case $1 in
    "--h")
      echo "$help"
    ;;
    
    "default")
      defaultInstall
    ;;


    "vue")
      if [ $2 = '-c' ]; then
        echo clear
        rm src/assets/*.*
        rm src/components/icons/*.*
        rmdir src/components/icons/
        rm src/components/*.*
        sed -i "1 d" src/main.js

        printf '<script setup>

</script>

<template>
  <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
</template>' > src/App.vue
        if [ $3 = '-r' ]; then
          echo router
          rm src/views/*.*
          printf "import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    
  ]
})

export default router
" > src/router/index.js
        fi
      fi

      vueInstall
    ;;

    *)
      echo "$help"
    ;;
  esac
  unset -f defaultInstall
  unset -f vueInstall
}


export -f tailwind