This was driving me mad:

```javascript
// works
reverse=a=>[...a].map(_=>a.pop())
// doesn't work
reverse=a=>[...a].map(a.pop)
```

Finally figured this out... it's context. A more minimal reproduction is `let b = a.pop; b()`, which fails with the same error:

```
TypeError: Cannot convert undefined or null to object
    at pop (<anonymous>)
```