import world, generator, coordinates
import random, times
template TinyWorld:  World= newWorld[32, 16]()
template SmallWorld: World= newWorld[64, 32]()
when isMainModule:
  randomize((int64)epochTime() * 1000000)
  var urth = TinyWorld()
  urth.generateTerrain(4)
  echo urth.showTerrain
  urth.makeRugged()
  echo urth.showTerrain