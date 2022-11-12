# get the user's local location

import geocoder
g = geocoder.ip('me')
print(g.latlng)