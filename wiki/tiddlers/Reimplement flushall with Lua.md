`flushall` was disabled on the instance I was using.

```
eval "local k = redis.call('keys', '*'); for _, k in ipairs(k) do redis.call('del', k) end" 0
```