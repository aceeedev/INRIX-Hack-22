import requests
from credentials_manager import CredentialsManager
from shapely.geometry import Point, Polygon

class DrivePolygon:
  def __init__(self, time_length, target_location):
    self.generate(time_length, target_location)

  def generate(self, time_length, target_location):
    ### Fetching
    Token = CredentialsManager().get_token()[0]

    url = "https://api.iq.inrix.com/drivetimePolygons?center=" + str(target_location[0]) + "%7C" + str(target_location[1]) + "&rangeType=A&duration=" + str(time_length)

    headers = {
      'Authorization': 'Bearer ' + str(Token),
      'accept': 'text/xml'
    }

    response = requests.get(url=url, headers=headers)
    response.raise_for_status()
    
    ### Parsing
    coords_string = response.text[314:(len(response.text) - 75)]
    coords1D = coords_string.split(' ')
    coords = []
    for i in range(0, len(coords1D), 2):
      coords.append((float(coords1D[i]), float(coords1D[i+1])))

    ### Turn into Shapely Object
    self.coords = coords

  def check(self, my_coords):
    p = Point(float(my_coords[0]), float(my_coords[1]))
    return p.within(Polygon(self.coords))
