api.unmapAllExcept(["h", "j", "k", "l", "f", "u", "d", "gg", "G", "0", "$", "i"])
api.unmapAllExcept(["i", "gg", "G"], /.*youtube.com\/.*/)  // /.*youtube.com\/watch.*/ requires reloading video pages because surfingkeys is bad
settings.richHintsForKeystroke = 0;
settings.lurkingPattern = new RegExp([
  '.*monkeytype\\.com.*',
  '.*calendar\\.google\\.com.*',
  '.*docs\\.google\\.com.*',
  '.*figma\\.com.*',
  '.*leetcode\\.com.*',
  '.*photopea\\.com.*',
  '.*web\\.whatsapp\\.com.*',
  '.*hackerrank\\.com.*',
  '.*humanbenchmark.com\\/tests\\/typing',
  '.*app.*ironcalc.com.*',
  '.*excalidraw.com.*'	
].join('|'), 'i');

light_theme = `
.sk_theme {
    font-family: sans-serif;
    border-radius: 10px;
    font-size: 11pt;
    background: #ffffff;
    color: #333;
    padding: 0;
    margin: 0;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    font-family: monospace;
}
.sk_theme .separator {
    display: none;
}
.sk_theme #sk_omnibarSearchArea {
    border: none;
    margin: 0.5rem;
}
.sk_theme .url {
    font-family: monospace;
    font-size: 10pt;
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchArea .resultPage {
    font-size: 8pt;
}
.sk_theme #sk_omnibarSearchArea input {
    margin: 0;
    padding: 0;
}
.sk_theme #sk_omnibarSearchResult {
    margin: 0;
    padding: 0;
}
.sk_theme #sk_omnibarSearchResult ul li {
    padding-left: 0.5rem;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #fafafa;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #eeeeee;
}
#sk_status, #sk_find {
	font-size: 12pt;
}`;


// incomplete
dark_theme = `
.sk_theme {
    font-family: sans-serif;
    border-radius: 10px;
    font-size: 11pt;
    background: #242424;
    color: #fff;
    padding: 0;
    margin: 0;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    font-family: monospace;
}
.sk_theme .separator {
    display: none;
}
.sk_theme #sk_omnibarSearchArea {
    border: none;
    margin: 0.5rem;
}
.sk_theme .url {
    font-family: monospace;
    font-size: 10pt;
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchArea .resultPage {
    font-size: 8pt;
}
.sk_theme #sk_omnibarSearchArea input {
    margin: 0;
    padding: 0;
}
.sk_theme #sk_omnibarSearchResult {
    margin: 0;
    padding: 0;
}
.sk_theme #sk_omnibarSearchResult ul li {
    padding-left: 0.5rem;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #fafafa;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #eeeeee;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;

settings.theme = `
@media (prefers-color-scheme: light) {
	${light_theme}
}

@media (prefers-color-scheme: dark) {
	${dark_theme}
}
`
