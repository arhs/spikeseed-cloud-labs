#!/usr/bin/env python3

import json
import sys
import time
import urllib
import boto3

def main(retries, sleep):
  endpoint = sys.argv[1]
  secured_header = sys.argv[2]

  current_retry = 0
  ok = False
  while current_retry < retries:
    req =  urllib.request.Request(f'{endpoint}/api/v1/hello', method='GET')
    req.add_header('x-com-token', secured_header)

    try:
      with urllib.request.urlopen(req) as response:
        if response.getcode() == 200:
          ok = True

      break
    except:
      pass # do nothing

    current_retry += 1
    time.sleep(sleep)

    if not ok:
      exit(1)

if __name__ == "__main__":
  main(10, 30) # 10 retries, sleeps 30s between retries
