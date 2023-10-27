# Flask Walkthrough 
Walkthrough for using Flask for the first time

## Installation

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install requirements.txt.

```bash
pip install -r requirements.txt
```

## Usage
To make your first Flask app
```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
  return 'Hello World!'

if __name__ == '__main__':
  app.run(debug=True)
```

## Useful links to documentation
[Flask](https://flask.palletsprojects.com/en/3.0.x/quickstart/)
[Bootstrap](https://getbootstrap.com/docs/5.3/getting-started/introduction/)
