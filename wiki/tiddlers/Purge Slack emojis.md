Combine with an extension like [this](https://chrome.google.com/webstore/detail/user-javascript-and-css/nbhcbdghjpllgmfilhnhkllmkecfmpld) and say goodbye to annoying animated emojis. Paste the following into the browser console when Slack is open.

```javascript
hideEmojis = () => {
    const emojisIHate = /parrot|groovy/;
    const allEmojis = window.self
        && window.self.emoji
        && window.self.emoji.map
        && window.self.emoji.map.colons;

    if (!allEmojis) {
        return console.error('Something ain\'t right');
    }

    const emojisToPurge = [...new Set(
        Object.entries(allEmojis)
            .filter(([displayName]) => emojisIHate.test(displayName))
            .map(([, codepoint]) => codepoint)
            .sort()
    )];

    if (!emojisToPurge.length) {
        return console.warn('No matching emojis found');
    }

    const [longest] = emojisToPurge.map((codepoint) => codepoint.length).sort((a, b) => b - a);
    const pad = (text) => {
        const tabCount = Math.ceil((longest - text.length) / 4);

        return new Array(tabCount + 1).join('\t');
    };
    const css = [...emojisToPurge]
        .map((codepoint) => `span[data-codepoints="${codepoint}"]${pad(codepoint)}{ visibility: hidden !important; }`)
        .join('\n');

    const textArea = document.createElement("textarea");

    textArea.style.position = 'fixed';
    textArea.style.top = '0';
    textArea.style.left = '0';
    textArea.style.background = 'transparent';
    textArea.value = css;

    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();

    try {
        document.execCommand('copy');
    } catch (error) {
        console.error('Copy failed', error);
        console.log(css);
    } finally {
        document.body.removeChild(textArea);
    }
};
```