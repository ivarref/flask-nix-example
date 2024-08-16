from flask import Flask
from pathlib import Path
import sys

app = Flask(__name__)

def sorted_directory_listing_with_pathlib_glob(directory):
    path_object = Path(directory)
    items = path_object.glob('**/*')
    sorted_items = sorted(items, key=lambda item: item.absolute())
    items = [str(item.absolute()) for item in sorted_items]
    items = [item for item in items if "curl" in item]
    return items

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

def main():
    for dir in sorted_directory_listing_with_pathlib_glob("/"):
        print(dir)
    for p in sys.path:
        print("PATH: " + str(p))
    app.run()

if __name__ == '__main__':
    main()
