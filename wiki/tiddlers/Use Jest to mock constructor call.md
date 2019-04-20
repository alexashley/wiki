To mock a constructor with Jest, must use `mockImplementation` and return an object. Returning a string doesn't work, nor does using `mockReturnValue` and returning a function.

```javascript
// a.js
export default class Foo {
    constructor() {
         // horrible things here 
    }

    test() {}
}

// a.spec.js
import Foo from './a';

jest.mock('./a');

Foo.mockImplementation(() => ({ test: jest }));

```

