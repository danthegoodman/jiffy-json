# jiffy-json

A cli for easily building JSON.

## Installation

The program is a single script, written in python. 
You will need `python2.7` on your path.

You can download the script by itself or clone the repo. 
Add it to your path somehow and alias or symlink it to `jj` if you like.

```
curl https://raw.githubusercontent.com/danthegoodman/jiffy-json/master/jiffy-json -o jiffy-json
```


## Quick Documentation:

### Primitives:

Each argument represents the key and value for an item in the json output.
They are separated a colon.

Generally, the values are considered strings.
However, some patterns have been been given special treatment:
* `true` and `false`, which turn into the boolean values
* `null`, which turns into null.
* `[]`, which is an empty array
* `{}`, which is an empty object
* any number, which turns into the number.

```
> jiffy-json name:"Sophie Hatter" gender:female age:20 isMarried:false
{"name":"Sophie Hatter","gender":"female","age":20,"isMarried":false}
```

This type detection may be overridden by specifying the key as an explicit string.

```
> jiffy-json 'pi(s):3.14'
{"pi":"3.14"}
```


### Objects:

As seen above, multple arguments may be given to form an object.
If a key is a period separated path, nested objects will be generated.

```
> jiffy-json type:'Tesla Model S' features.cruiseControl:true features.autoPilot:true
{"type":"Tesla Model S","features":{"cruiseControl":true,"autoPilot":true}}
```


### Arrays:

In the key path, you may use `[0]` to generate arrays.

```
> jiffy-json pets[0]:Spot pets[1]:Porthos
{"pets":["Spot", "Porthos"]}
```

You can also use a "push" syntax by omitting the index. This will append values to the array.

```
> jiffy-json pets[]:Spot pets[]:Porthos
{"pets":["Spot", "Porthos"]}
```


### Complete Documentation


Take a look at the unit tests in [test.sh](test.sh).
They were designed to be a readable documentation of all supported features.


### Feedback? Bugs?

Open an issue. Pull requests are also accepted :)

