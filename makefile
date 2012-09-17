clean:
	rm -f app/src/javascript/*.js
	rm -f app/src/css/*.css
	rm -f app/app.html

build: clean
	compass compile
	coffee -o app/src/javascript -c app/src/coffee
	haml --no-escape-attrs app/src/haml/app.haml app/app.html
