# Laura Crowley – Portfolio

Static website (HTML, CSS, vanilla JavaScript). No build step.

```
index.html
css/styles.css
js/main.js
images/            (logos, mock-ups, tech logos; projects/ and websites/ are filled by the script below)
files/             (CV PDF, filled by the script below)
download-missing-images.py
```

## First-time setup
Some images were hosted on Brizy's servers and weren't in the saved page. Run once (needs internet):

    python3 download-missing-images.py

Then open `index.html` in a browser (or serve the folder with any static host).

## Contact form
Posts to FormSubmit and emails lauramcrowley00@gmail.com. The first submission after the site is live
sends an activation email to that address; click the link once and later messages arrive normally.

## Editing
- Colours and fonts: variables at the top of `css/styles.css`.
- Add a website tile: copy a `<li class="tile">` block in `index.html` and add its screenshot to `images/websites/`.
