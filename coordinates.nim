import random
type
  Point*    = tuple[x,y: int]
  Line*     = array[2, Point]
  Triangle* = array[3, Point]
  Square*   = array[4, Point]
  Chain*    = seq[Line]

template point*: Point= (x,y)
template p*(x,y: int): Point= (x,y)
template randPoint*(max_x, max_y: int): Point= (rand(max_x), rand(max_y))
template sign*(p1, p2, p3: Point): int=
  (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)

proc randPoints*[N: static[int]](max_x, max_y: int): array[N, Point]=
  for i in 0..<N:
    result[i] = randPoint(max_x, max_y)

template randTriangle*(max_x, max_y: int): array[3, Point]=
  randPoints[3](max_x, max_y)

proc contains*(tri: Triangle, chck: Point): bool=
  let
    d1 = chck.sign(tri[0], tri[1])
    d2 = chck.sign(tri[1], tri[2])
    d3 = chck.sign(tri[2], tri[0])
    hasNeg = d1 < 0 or d2 < 0 or d3 < 0
    hasPos = d1 > 0 or d2 > 0 or d3 > 0
  return not (hasNeg and hasPos)