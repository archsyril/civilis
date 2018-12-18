import random, times
type
  Earth {.magic: Bool.} = enum
    WATER = 0, LAND = 1
  LandFeature = enum
    PLAINS, HILLS, MOUNTAINS, FOREST
  Tile = object
    case `type`: Earth
    of LAND: land: LandFeature
    else: discard
  World[W, H: static[int]] = array[H, array[W, Tile]]
  Point = tuple
    x,y: int
  Line = array[2, Point]
  Triangle = array[3, Point]
  Square = array[3, Point]
#converter pointToBool(point: Point): bool= 
proc initPoint(x,y: int): Point= result.x = x; result.y = y
template randPoint: Point= initPoint(rand(W), rand(H))
proc randPoints[W,H](world: World[W,H], num: static[int]): array[num, Point]=
  for i in 0..<num:
    result[i] = randPoint()

template height: untyped= 0..<H
template height_b(a,b: int): untyped= 1+a..<(H+b)
template width: untyped= 0..<W
template width_b(a,b: int): untyped= 1+a..<(W+b)
template point: untyped= initPoint(x,y)
template thisTile(world: World): untyped= world[y][x]
template `thisTile=`(world: World, asgn: Tile): untyped= world[y][x] = asgn
template thisTile(world: World, xr, yr: int): untyped= world[y-yr][x-xr]
template pos(world: World, point: Point): untyped= world[point.y][point.x]
iterator dimensions[W,H](world: World[W,H]): Point=
  for y in height:
    for x in width:
      yield (x, y)
iterator dimensions[W,H](world: World[W,H], l,h: int): Point=
  for y in height_b(l,h):
    for x in width_b(l,h):
      yield (x, y)
iterator rdimensions[W,H](world: World[W,H], l,h: int): Point=
  for y in countdown(H+h-1,l):
    for x in countdown(W+h-1,l):
      yield (x, y)
proc initWorld[W,H](default: Earth = WATER): World[W,H]=
  for y in height:
    for x in width:
      result.thisTile.type = default
converter tileToChar(tile: Tile): char=
  case tile.type:
  of WATER: ' '
  of LAND:
    case tile.land:
    of PLAINS: '-'
    of HILLS: '~'
    of MOUNTAINS: '^'
    of FOREST: 't'
proc `$`[W,H](world: World[W,H]): string=
  for y in height:
    for x in width:
      result.add(world.thisTile)
    result.add('\n')

template sign(p1, p2, p3: Point): int=
  (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
proc contains(tri: Triangle, chck: Point): bool=
  let
    d1 = chck.sign(tri[0], tri[1])
    d2 = chck.sign(tri[1], tri[2])
    d3 = chck.sign(tri[2], tri[0])
    hasNeg = d1 < 0 or d2 < 0 or d3 < 0
    hasPos = d1 > 0 or d2 > 0 or d3 > 0
  return not (hasNeg and hasPos)
proc fill[W,H](world: var World[W,H], triangle: Triangle, `with`: Earth = LAND)=
  for x,y in world.dimensions:
    if point in triangle:
      world.thisTile.type = `with`
proc fill[W,H](world: var World[W,H], triangles: seq[Triangle], `with`: Earth = LAND)=
  for x,y in world.dimensions:
    for triangle in triangles:
      if point in triangle:
        world.thisTile.type = `with`
#[Generators]#
proc generateLand[W,H](world: var World[W,H], masses: int)=
  var triangles: seq[Triangle]
  for i in 0..<masses:
    triangles.add(world.randPoints(3))
  world.fill(triangles)
proc makeRugged[W,H](world: var World[W,H])=
  for x,y in world.dimensions(0, 0):
    if world.thisTile.type:
      if rand(0..32) == 0:
        world.thisTile = Tile(`type`: WATER)
      world.thisTile(rand(0..1), rand(0..1)).type = LAND
  for x,y in world.rdimensions(0, -1):
    if world.thisTile.type:
      if rand(0..32) == 0:
        world.thisTile = Tile(`type`: WATER)
      world.thisTile(rand(-1..0), rand(-1..0)).type = LAND

proc generateNoisyLand[W,H](world: var World[W,H])=
  for x,y in world.dimensions_b:
    world.thisTile(rand(-1..1), rand(-1..1)).type = LAND
proc generateMountains()= discard
type
  TinyWorld = World[ 32,  16]
  SmallWorld = World[ 64,  32]
  MediumWorld = World[128,  64]
  LargeWorld = World[256, 128]
  HugeWorld = World[512, 256]
when isMainModule:
  randomize(10)
  #randomize((int64)epochTime() * 1000000)
  var world: LargeWorld
  world.generateLand(8)
  world.makeRugged()
  echo world
