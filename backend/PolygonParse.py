import requests
from credentials_manager import CredentialsManager

Token = CredentialsManager().get_token()[0]

# print(Token)

### Fetching

url = "https://api.iq.inrix.com/drivetimePolygons?center=37.7705%7C-122.446527&rangeType=A&duration=42 "

payload={}
headers = {
  'Authorization': 'Bearer' + Token
}

response = requests.request("GET", url, headers=headers, data=payload)

### Parsing

coords_string = response.text[314:(len(response.text) - 75)]
print(len(coords_string))

coords1D = coords_string.split(' ')

coords = []
for i in range(0, len(coords1D), 2):
    coords.append((float(coords1D[i]), float(coords1D[i+1])))

#print(coords)

import matplotlib.pyplot as plt
from shapely.geometry import Point, Polygon

# Create Point objects
p1 = Point(37.83, -122.48)
p2 = Point(coords[24][0], coords[24][1])
p3 = Point(37.67, -122.66)
p4 = Point(37.74, -122.47)

# Create a square
poly = Polygon(coords)

# PIP test with 'within'
print(p1.within(poly))   # True
print(p2.within(poly)) 
print(p3.within(poly))
print(p4.within(poly))

# plt.plot(coords)

x = []
y = []
for i, j in coords:
  x.append(i)
  y.append(j)

plt.plot(x, y)
plt.plot(37.83, -122.48, 'go')
plt.plot(coords[24][0], coords[24][1], 'ro')
plt.plot(37.67, -122.54, 'ro')
plt.plot(37.74, -122.47, 'go')
plt.show()