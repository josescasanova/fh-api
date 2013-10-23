fancyhands-python
=========

Python library for the [Fancy Hands API]. Signup [here.]

Version
----

0.1

Requirements
-----------
* [oauth2]

Installation
--------------

```sh
git clone git@github.com:fancyhands/fancyhands-python.git
cd fancyhands-python
python setup.py install
```
Usage
----------
##### Get all your custom requests:

```python
from fancyhands import FancyhandsClient

api_key = 'your_api_key'
secret = 'your_api_secret'

client = FancyhandsClient(api_key, secret)
requests = client.custom_get()
```

License
----
MIT

  [Fancy Hands API]: https://www.fancyhands.com/developer
  [here.]: https://www.fancyhands.com/api/explorer
