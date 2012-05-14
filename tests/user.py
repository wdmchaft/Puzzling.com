import simplejson as json
import requests
import copy

# Setup

def getkey():
  url = "http://localhost:3000/getApiToken/f843c91381ffab599b09957f7480d3e9"
  r = requests.get(url)
  return r.content

root = "http://localhost:3000"
header = {"puzzle_api_key" : getkey(),
          "puzzle_auth_token" : ''}

# CREATE USER
def create_user(name, password, h):
  payload = {"username"  : name,
           "password" : password,
           "user_data" : 
            json.dumps({"first"   : "John",
                        "last"    : "Realname",
                        "city"    : "NYC",
                        "school"  : "Columbia"
                      })
       }

  r = requests.post(root + "/login", data=payload, headers=h)
  return json.loads(r.content)

# CHECK USER PASSWORD
def check_password(name, password, h):
  r = requests.get(root + "/login?username=" + name + "&password=" + password, headers=h)
  return json.loads(r.content)

# CHANGE USER PASSWORD
def change_password(name, password, token, h):
  payload = {"username" : name, "password" : password}
  header = deepcopy(h)
  header["puzzle_auth_token"] = token
  r = requests.put(root + "/login", data=payload, headers=h)
  return json.loads(r.content)

# DELETE USER
def delete_user(name, token, h):
  header = copy.deepcopy(h)
  header["puzzle_auth_token"] = token
  payload = {"username" : name, "authToken" : token}
  r = requests.delete(root + "/login", data=payload, headers=h)
  return json.loads(r.content)

def get_auth_token(name, pw, h):
  r = requests.get(root + '/login/?username=%s&password=%s' % (name, pw), headers=h)
  return json.loads(r.content)

def get_user_data(name, token, h):
  payload = {"username" : name}
  header = copy.deepcopy(h)
  header["puzzle_auth_token"] = token
  r = request.get(root + '/login', data=payload, headers=h)
  return json.loads(r.content)

############# Testing ##############

"""
Basic
- Create
- Check Password
- Change Password 
- Check Password
- Delete User
"""
def basic_test():
  global header
  print "-------- Beginning Basic Test ---------"
  obj = create_user("johndoe", "nobody", header)
  token = obj["authToken"]

  assert(obj["username"] == "johndoe"), "Couldn't create user"
  print "Success: Created user"
  assert(check_password("johndoe", "nobody", header)["authToken"]!= None), "Password didn't match after creation!"
  print "Success: Password checked"
  assert(change_password("johndoe", "somebody", token, header)["status"] == "SUCCESS"), "Couldn't change password"
  print "Success: Changed password"
  assert(check_password("johndoe", "somebody")["authToken"] != None), "After changing password, couldn't authenticate"
  print "Success: Password checked"
  assert(delete_user("johndoe", token)["status"] == "SUCCESS"), "Couldn't delete user"
  print "Success: Deleted user"
  print "-------- All Basic Tests Passed ! ------------"


def error_test():
  global header
  obj = create_user("a", "a")
  token = obj["authToken"]

  print "------- Beginning Error Testing -------"
  assert(obj["username"] == "a"), "Couldn't create user"
  print "Success: Created user"
  assert(not "authToken" in check_password("a", "asdf", header)), "Was able to authenticate with erroneous password"
  print "Success: Bad password rejected"
  assert(change_password("a", "asdf", header)["status"] == "SUCCESS"), "Couldn't change password"
  print "Success: Changed password"

  assert(not "username" in check_password("b", "basdfasdf", header)), "Was able to check password of non-existent user"
  print "Success: Can't change password of non-existent user"
  assert(not "authToken" in change_password("b", "asfas", token, header)), "Was able to change password of non-existent user"
  print "Success: Can't change password of non-existent user"
  assert(not "status" in delete_user("b", token, header)), "Was able to delete non-existent user"
  print "Success: Couldn't delete non-existent user"

  assert(not "username" in create_user("a", "a", header)), "Was able to create duplicated user"
  print "Success: Couldn't create duplicated user"
  assert(delete_user("a", token, header)["status"] == "SUCCESS"), "Wasn't able to delete user"
  print "Successfully deleted user"
  print "------ All Error Tests Passed! -------"

############ What to execute ############

# basic_test()
# error_test()


