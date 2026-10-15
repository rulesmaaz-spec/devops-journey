# string
log = '192.168.1.10 - - [15/May/2026:10:00:00 +0000] "GET /api/health HTTP/1.1" 200 1234'

# numbers
status_code = 200
response_size = 2345

# list
request_type = ["GET", "DELETE", "POST", "PUT"]

# dictionaries key value mapping  (most usefull structure for counting)
status_count = {"200": 150, "201": 130}

# conditionals
status = 450
if 200 <= status < 300:
    print ("success")
elif 400 <= status < 500:
    print ("client error")
else:
    print ("server error") 

# loop 
endpoint = ["api/user", "api/health", "/login"]
for ep in endpoint:
     print(ep)
#
status_counts = {200: 150, 404: 45, 500: 2}
for code, count in status_counts.items():
    print(f'{code}: {count}')

# fuction
code = 402
def classify_status(code):
    if 200 <= code <300:
      return "success"
    elif 400 <= code < 500:
      return "client error"
    else:
       return "server error"

print(classify_status(code))
