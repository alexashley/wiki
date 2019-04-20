```javascript
Array.from(document.querySelectorAll('*'))
     .filter((e) => e.offsetWidth > document.documentElement.offsetWidth);
```