api.unmap("h", /youtube.com/);
api.unmap("j", /youtube.com/);
api.unmap("k", /youtube.com/);
api.unmap("l", /youtube.com/);
api.unmap("i", /youtube.com/);
api.unmap("t", /youtube.com/);
api.unmap("f", /youtube.com/);
api.unmap("m", /youtube.com/);
api.unmap("c", /youtube.com/);
api.unmap("w", /youtube.com/);
api.unmap("a", /youtube.com/);
api.unmap("s", /youtube.com/);
api.unmap("d", /youtube.com/);
api.unmap("+", /youtube.com/);
api.unmap("-", /youtube.com/);
api.unmap("]", /youtube.com/);
api.unmap("[", /youtube.com/);
api.unmap(">>", /youtube.com/);
api.unmap("<<", /youtube.com/);
api.unmap(",", /youtube.com/);
api.unmap(".", /youtube.com/);
api.unmap("0", /youtube.com/);
api.unmap("1", /youtube.com/);
api.unmap("2", /youtube.com/);
api.unmap("3", /youtube.com/);
api.unmap("4", /youtube.com/);
api.unmap("5", /youtube.com/);
api.unmap("6", /youtube.com/);
api.unmap("7", /youtube.com/);
api.unmap("8", /youtube.com/);
api.unmap("9", /youtube.com/);

api.map("<Ctrl-y>", "<Alt-s>");
api.map("gt", "R");
api.map("gT", "E");
api.map("g<Tab>", "<Ctrl-6>");
api.map("<Ctrl-o>", "S");
api.map("<Ctrl-i>", "F");

settings.lurkingPattern = /https:\/\/.*monkeytype\.com.*|.*calendar\.google\.com.*|.*docs\.google\.com.*|.*figma\.com.*|.*leetcode\.com.*|.*photopea\.com.*|.*web\.whatsapp\.com.*|.*hackerrank\.com.*|.*humanbenchmark.com\/tests\/typing/i;


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
    font-size: 20pt;
}`;

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

// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>
