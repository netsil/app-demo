import base64
import os
from random import randint, choice
import requests

APP_FE_HOST = os.environ.get('APP_FE_HOST', '127.0.0.1')
APP_FE_PORT = os.environ.get('APP_FE_PORT', '30001')
APP_ENDPOINT = 'http://' + APP_FE_HOST + ':' + APP_FE_PORT 

urls = [
"/",
"/category.html",
"/basket.html",
"/orders"
]
def main():
    base64string = base64.encodestring('%s:%s' % ('user', 'password')).replace('\n', '')

    catalogue = requests.get(APP_ENDPOINT + "/catalogue").json()
    for url in urls:
        resp = requests.get(APP_ENDPOINT + url)
        print "Status of " + url + ": " + str(resp.status_code)
        
        # Post random item
        category_item = choice(catalogue)
        item_id = category_item["id"]
        requests.delete(APP_ENDPOINT + "/cart")
        cart_resp = requests.post(APP_ENDPOINT + "/cart", json={"id": item_id, "quantity": 1})
        print "Status of getting cart item " + item_id + ": " + str(cart_resp.status_code)

        detail_resp = requests.get(APP_ENDPOINT + "/detail.html?id={}".format(item_id))
        print "Status of getting detailed " + item_id  + ": " + str(detail_resp.status_code)
      
main()
