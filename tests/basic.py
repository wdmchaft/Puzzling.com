import simplejson as json
import requests

# Raw User Data
root = "http://localhost:3000"
  
# CREATE USER
def create_user(name, password):
  payload = {"name"  : name,
           "password" : password,
           "user_data" : 
            json.dumps({"first"   : "John",
                        "last"    : "Realname",
                        "city"    : "NYC",
                        "school"  : "Columbia"
                      })
       }



  r = requests.post(root + "/login", data=payload)
  print r.content
  return json.loads(r.content)

# CHECK USER PASSWORD
def check_password(name, password):
  r = requests.get(root + "/login?name=" + name + "&password=" + password)
  print r.content
  return json.loads(r.content)

# CHANGE USER PASSWORD
def change_password(name, password, token):
  r = requests.put(root + "/login", data={"name" : name, "password" : password, "authtoken" : token})
  print r.content
  return json.loads(r.content)

# DELETE USER
def delete_user(name, token):
  r = requests.delete(root + "/login", data={"name" : name, "authtoken" : token})
  print r.content
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
  print "-------- Beginning Basic Test ---------"
  obj = create_user("johndoe", "nobody")
  token = obj["authtoken"]

  assert(obj["username"] == "johndoe"), "Couldn't create user"
  print "Success: Created user"
  assert(check_password("johndoe", "nobody")["authtoken"]!= None), "Password didn't match after creation!"
  print "Success: Password checked"
  assert(change_password("johndoe", "somebody", token)["status"] == "SUCCESS"), "Couldn't change password"
  print "Success: Changed password"
  assert(check_password("johndoe", "somebody")["authtoken"] != None), "After changing password, couldn't authenticate"
  print "Success: Password checked"
  assert(delete_user("johndoe", token)["status"] == "SUCCESS"), "Couldn't delete user"
  print "Success: Deleted user"
  print "-------- All Basic Tests Passed ! ------------"


def error_test():
  
  obj = create_user("a", "a")
  token = obj["authtoken"]

  print "------- Beginning Error Testing -------"
  assert(obj["username"] == "a"), "Couldn't create user"
  print "Success: Created user"
  assert(not "authtoken" in check_password("a", "asdf")), "Was able to authenticate with erroneous password"
  print "Success: Bad password rejected"
  assert(change_password("a", "asdf", token)["status"] == "SUCCESS"), "Couldn't change password"
  print "Success: Changed password"

  assert(not "username" in check_password("b", "basdfasdf")), "Was able to check password of non-existent user"
  print "Success: Can't change password of non-existent user"
  assert(not "authtoken" in change_password("b", "asfas", token)), "Was able to change password of non-existent user"
  print "Success: Can't change password of non-existent user"
  assert(not "status" in delete_user("b", token)), "Was able to delete non-existent user"
  print "Success: Couldn't delete non-existent user"

  assert(not "username" in create_user("a", "a")), "Was able to create duplicated user"
  print "Success: Couldn't create duplicated user"
  assert(delete_user("a", token)["status"] == "SUCCESS"), "Wasn't able to delete user"
  print "Successfully deleted user"
  print "------ All Error Tests Passed! -------"

############ What to execute ############

basic_test()
error_test()


