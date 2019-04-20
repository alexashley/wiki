type issues: implicit downcasting and implicit dynamic:
analysis_options.yaml (the a in YAML is important, as I learned). 

```analyzer:
  strong-mode:
    implicit-dynamic: false
    implicit-casts: false
    declaration-casts: false
```

