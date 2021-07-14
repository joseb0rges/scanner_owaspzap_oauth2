import requests
import sys 
from requests.auth import HTTPBasicAuth


def getToken(url_api,user,password):  

    data = requests.post(url_api, auth=HTTPBasicAuth(user,password)).json()
    token = data["access_token"]
    
    return token


def main():

    url_api= sys.argv[1]
    user= sys.argv[2]
    password=sys.argv[3]

    print(getToken(url_api,user,password))
    
main()
