mohammad@mohammad:~/devops-journey$ python3 function.py
mohammad@mohammad:~/devops-journey$ 

# fuction
code = 402
def classify_status(code):
    if 200 <= code <300:
      return "success"
    elif 400 <= code < 500:
      return "client error"
    else:
       return "server error"
