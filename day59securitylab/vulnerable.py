import os

# Bandit will flag this: Use of eval() is a security risk
user_input = "print('hello')"
eval(user_input)

# Bandit will flag this: Hardcoded password
password = "supersecret123"

# Bandit will flag this: Using subprocess with shell=True
os.system("ls -la")
