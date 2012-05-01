
import requests

payload = {"username"     : "puzzling",
           "password" : "password",
           "user_data": "{}"}

r = requests.post("http://localhost:3000/login", data=payload)
print "---------------"
print r.content
print "---------------"
