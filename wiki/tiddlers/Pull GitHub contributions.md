```js
Array.from(document.getElementsByClassName('day'))
  .map(day => {return {date: day.getAttribute('data-date'), commits: day.getAttribute('data-count')} })
  .filter(({commits}) => {return commits > 0})
```