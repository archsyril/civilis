import coordinates
import algorithm
type
  World*[W,H: static[int]] = array[H, array[W, Region]]
  Region* = ref object
    north*, east*, south*, west*: Region
    terrain*: Terrain
    biome*: Biome
    ownedBy*: Civilization
    city*: City
    unit*: Unit
  Terrain* = enum OCEAN, COAST, PLAINS, HILLS, MOUNTAINS
  Biome* = enum COLD, COOL, NEUTRAL, WARM, HOT
  Civilization* = ref object
    name*: string
    gold*: int
    units*: seq[Unit]
    cities*: seq[City]
  City* = ref object
    name*: string
    population*: uint
    owned*: seq[Region]
    where*: Region
  Unit* = ref object
    name*: ref string
    hp*, damage*: int
    move*, attackRange*: uint
    where*: Region
    who*: Civilization
  Special* = enum
    STONE, IRON
const
  Water* = {OCEAN, COAST}
  Land*  = {PLAINS, HILLS, MOUNTAINS}
template `==`*[T](t: T, st: set[T]): bool= t in st
template `!=`*[T](t: T, st: set[T]): bool= t notin st

template height = countup(0, H-1)
template width  = countup(0, W-1)
template height(l,h: int) = countup(0+l, H+h-1)
template width(l,h: int)  = countup(0+l, W+h-1)
template rheight= countdown(H-1, 0)
template rwidth = countdown(W-1, 0)
template rheight(l,h: int)= countdown(H+h-1, 0+l)
template rwidth(l,h: int) = countdown(W+h-1, 0+l)
template region* = world[y][x]
template region*(world: World): Region= world[y][x]
template relregion*(rx, ry: int): Region= world[y+ry][x+rx]
template relregion*(world: World, rx, ry: int): Region= world[y+ry][x+rx]
template mnmx(p1, p2: Point): tuple[lx, hx, ly, hy: int]=
  (min(p1.x, p2.x), max(p1.x, p2.x), min(p1.y, p2.y), max(p1.y, p2.y))

iterator dimensions*[W,H](world: World[W,H]): Point=
  for y in height:
    for x in width:
      yield (x,y)
iterator rdimensions*[W,H](world: World[W,H]): Point=
  for y in rheight:
    for x in rwidth:
      yield (x,y)
iterator dimensions*(p1, p2: Point): Point=
  let t = mnmx(p1, p2)
  for y in countup(t.ly, t.hy):
    for x in countup(t.lx, t.hx):
      yield (x,y)
iterator rdimensions*(p1, p2: Point): Point=
  let t = mnmx(p1, p2)
  for y in countdown(t.hy, t.ly):
    for x in countdown(t.hx, t.lx):
      yield (x,y)

template `$`(t: Terrain): string=
  case t:
  of OCEAN: " "
  of COAST: "."
  of PLAINS: "-"
  of HILLS: "="
  of MOUNTAINS: "^"
proc showTerrain*[W,H](world: var World[W,H]): string=
  for y in height:
    for x in width:
      result.add($region.terrain)
    result.add('\n')

template `$`(b: Biome): string=
  case b:
  of COLD: "1"
  of COOL: "2"
  of NEUTRAL: "3"
  of WARM: "4"
  of HOT: "5"
proc showBiomes*[W,H](world: var World[W,H]): string=
  for y in height:
    for x in width:
      result.add($region.biome)
    result.add('\n')

template inBounds(rx, ry: int): bool= x+rx in 0..W-1 and y+ry in 0..H-1

proc newWorld*[W,H]: World[W,H]=
  for x,y in result.dimensions:
    new result.region
    result.region.biome = NEUTRAL
    if inBounds( 0, -1):
      result.region.north = result.relregion( 0, -1)
    if inBounds(-1,  0):
      result.region.east  = result.relregion(-1,  0)
    if inBounds( 0,  1):
      result.region.south = result.relregion( 0,  1)
    if inBounds( 1,  0):
      result.region.west  = result.relregion( 1,  0)
      