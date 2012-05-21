import simplejson as json
import requests
from user import *

# Constants

puzzlePath = "http://localhost:3000/puzzle"
appPath = "http://localhost:3000/papp"

# Univeral header for all 
# Puzzling.com requests

header = {"puzzle_api_key": getkey(),
          "puzzle_auth_token" : ''}

user2_token = ''
user1_id = ''

""" Puzzles """
# POST
def createPuzzle(name, type, setupData, solutionData, additionalData="{}"):
  global header
  payload = {
            "name"            : name,
            "type"            : type,
            "setupData"       : json.dumps(setupData),
            "solutionData"    : solutionData,
            "additionalData"  : additionalData
            }
  r = requests.post(puzzlePath, headers=header, data=payload)
  print r.content
  return json.loads(r.content)

# POST
def takePuzzle(authToken, puzzle_id):
  global header
  payload = {
            "authToken" : authToken,
            "puzzle_id" : puzzle_id
            }
  r = requests.post(puzzlePath + "/%s" % puzzle_id, headers=header, data=payload)
  print r.content
  return json.loads(r.content)

# GET suggested puzzles fior user
def getPuzzleForUser(authToken, user_id):
  global header
  r = requests.get(puzzlePath + "?%s" % user_id, headers=header)
  print r.content
  return json.loads(r.content)

# GET puzzle for user
def getPuzzle(puzzle_id):
  global header
  r = requests.get(puzzlePath + "/%s" % puzzle_id, headers=header)
  print r.content
  return json.loads(r.content)

# GET puzzles created for user
def getUsersPuzzles(user_id):
  global header
  r = requests.get(puzzlePath + "/user/%s" % user_id, headers=header)
  print r.content
  return json.loads(r.content)

def deletePuzzle(puzzle_id):
  global header
  body = {"puzzle_id" : puzzle_id}
  r = requests.delete(puzzlePath, headers=header, data=body)
  return json.loads(r.content)

""" pApps """

# POST
def createApp(name):
  global header
  body = {"name" : name}
  r = requests.post(appPath, headers=header, data=body)
  print r.content
  return json.loads(r.content)

# DELETE
def deleteApp(name):
  global header
  body = {"name" : name}
  r = requests.delete(appPath + '/delete/', headers=header, data=body)
  print r.content
  return json.loads(r.content)

# GET
def getAppIDs(name):
  global header
  r = requests.get(appPath + '/%s' % name, headers=header)
  print r.content
  json.loads(r.content)

########### Testing ############

# dpes basic setup; must be called before doing any testing
def setup():
  global header, user2_token, user1_id
  obj = create_user('Jim', 'password', header)
  assert "username" in obj and obj["username"] == 'Jim', "Couldn't create user with valid username"
  user1_id = obj["user_id"]

  obj = get_auth_token('Jim', 'password', header)
  assert "authToken" in obj, "Auth token wasn't returned after trying to create user"
  header["puzzle_auth_token"] = obj["authToken"]

  obj = create_user('John', 'password', header)
  assert "username" in obj and obj["username"] == 'John', "Couldn't create second user"
  assert "authToken" in obj, "Auth token didn't appear for second user"

  user2_token = obj["authToken"]

def basicTest():
  global header, user2_token, user1_id

  print "------ Beginning puzzle and app testing --------"
  
  res = createApp("sample")
  assert "success" in res, "Couldn't create application"
  res = deleteApp("sample")
  assert "success" in res, "Couldn't delete application after creating it"

  res = createApp("sudoku")
  assert "success" in res, "Couldn't create application"
  res = createPuzzle(name="easySudoku", type='brainteaser', solutionData='{}', setupData='{}')
  assert "success" in res, "Couldn't create puzzle"
  puzzle_id = res["puzzle_id"]
  res = getPuzzle(puzzle_id)
  assert "puzzle_id" in res and res["puzzle_id"] == puzzle_id, "Couldn't retrieve puzzle"
  res = takePuzzle(user2_token, puzzle_id)
  assert "newPlayerRating" in res, "Couldn't take puzzle"
  
  res = getUsersPuzzles(user1_id)
  assert len(res) == 1, "Couldn't get puzzles for user"

  res = deletePuzzle(puzzle_id)
  assert "success" in res, "Couldn't delete puzzle"
  res = deleteApp("sudoku")
  assert "success" in res, "Couldn't delete sudoku application after creating it"
  res = delete_user("John", user2_token, header)
  assert "success" in res, "Couldn't delete user John"

  res = delete_user("Jim", header['puzzle_auth_token'], header)
  assert "success" in res, "Couldn't delete user Jim"
  print "------ All puzzle and app tests pass ! ------"
  

######## What to execute #########
# Sets up the header
setup()

# Test follow 
basicTest()
