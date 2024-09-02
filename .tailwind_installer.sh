#!/bin/bash

help=$"--h: shows available commands
default: default tailwindcss installation
vue: tailwindcss installation for VueJS"

function tailwind() {
  case $1 in
    "--h")
    echo "$help"
    ;;
    
    "default")
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
      ;;
    *)
    echo "$help"
    ;;
  esac
}
