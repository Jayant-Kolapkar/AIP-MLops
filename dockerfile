FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
COPY sample_page.html /usr/share/nginx/html/sample_page.html

COPY sample_image.jpg /usr/share/nginx/html/sample_image.jpg

COPY styles.css /usr/share/nginx/html/styles.css
