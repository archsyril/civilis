import coordinates, world
import random

proc fill[W,H](world: var World[W,H], triangle: Triangle, `with`: Terrain = PLAINS)=
  for x,y in world.dimensions:
    if point in triangle:
      region.terrain = `with`
proc fill[W,H](world: var World[W,H], triangles: seq[Triangle], `with`: Terrain = PLAINS)=
  for x,y in world.dimensions:
    for triangle in triangles:
      if point in triangle:
        region.terrain = `with`

proc generateLand*[W,H](world: var World[W,H], masses: int)=
  var triangles: seq[Triangle]
  for i in 0..<masses:
    triangles.add(randTriangle(W,H))
  world.fill(triangles)

proc makeRugged*[W,H](world: var World[W,H])=
  const rmChance = W div 3
  for x,y in dimensions(p(0, 0), p(W-2, H-2)):
    if region.terrain != WATER:
      if rand(0..rmChance) == 0:
        region.terrain = OCEAN
      echo x, ' ', y
      relregion(rand(0..1), rand(0..1)).terrain = PLAINS
  for x,y in rdimensions(p(1, 1), p(W-1, H-1)):
    if region.terrain != WATER:
      if rand(0..rmChance) == 0:
        region.terrain = OCEAN
      echo x, ' ', y
      relregion(rand(-1..0), rand(-1..0)).terrain = PLAINS

proc generateTerrain*[W,H](world: var World[W,H], masses: int)=
  var triangles: seq[Triangle]
  for i in 0..<masses:
    triangles.add(randTriangle(W,H))
  world.fill(triangles)

proc generateMountains*[W,H](world: var World[W,H])=
  for x,y in world.dimensions:
    discard