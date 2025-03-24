import math

def haversine(lat1, lon1, lat2, lon2):
    # Promień Ziemi w metrach
    R = 6371000

    # Przekształcenie stopni na radiany
    lat1_rad = math.radians(lat1)
    lon1_rad = math.radians(lon1)
    lat2_rad = math.radians(lat2)
    lon2_rad = math.radians(lon2)

    # Obliczenie różnic między punktami
    delta_lat = lat2_rad - lat1_rad
    delta_lon = lon2_rad - lon1_rad

    # Wzór haversine
    a = math.sin(delta_lat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(delta_lon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    # Odległość w metrach
    distance = R * c

    # Zaokrąglenie do części dziesiętnych
    return round(distance, 1)

# Przykład użycia
lat1 = 51.94333264
 # Szerokość geograficzna punktu 1 (w stopniach)
lon1 = 20.85943984
 # Długość geograficzna punktu 1 (w stopniach)
lat2 = 51.94383244
 # Szerokość geograficzna punktu 2 (w stopniach)
lon2 = 20.85943792

  # Długość geograficzna punktu 2 (w stopniach)

# Obliczenie odległości
distance = haversine(lat1, lon1, lat2, lon2)

print(f"Odległość między punktami wynosi: {distance} metrów")
