import urllib.request
import requests
import json

for arch in ["arm32v7", "amd64", "i386"]:
  try:

    url = 'http://olip.ideascube.org/' + arch + '/descriptor.json'
    print ("[+]======================[+]")
    print ("Verify URL for catalog {}\n".format(url))
    print ("List of broken URL")
    response = requests.get(url)
    current_content = response.json()

    for c in current_content["applications"]:
      for p in c["contents"]:
        dl_path = p["download_path"]
        try:
          f = urllib.request.urlopen(dl_path)
        except urllib.error.HTTPError:
          print(dl_path)

  except :
          print("\n!! Wrong Arch type, {} is not recognize !!".format(arch))
          break