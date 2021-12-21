module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Foreign.EasyFFI

import Graphics.Three.Scene as Scene
import Graphics.Three.Camera as Camera
import Graphics.Three.Renderer as Renderer
import Graphics.Three.Geometry as Geometry
import Graphics.Three.Material as Material
import Graphics.Three.Object3D as Object3D


main :: Effect Unit
main = do
  log "untitled NFRF project"
  scene <- Scene.create
  camera <- Camera.createPerspective 75.0 (16.0/9.0) 0.1 100.0
  renderer <- Renderer.createWebGL { antialias: true }
  Renderer.setSize renderer 400.0 400.0
  Renderer.appendToDomByID renderer "canvas"
  geometry <- Geometry.createBox 1.0 1.0 1.0
  material <- Material.createMeshBasic { color: "red" }
  mesh <- Object3D.createMesh geometry material
  Scene.addObject scene mesh
  Object3D.setPosition camera 0.0 0.0 5.0
  requestAnimationFrame $ animate renderer scene camera mesh
  log "finished."

animate :: Renderer.Renderer -> Scene.Scene -> Camera.PerspectiveCamera -> Object3D.Mesh -> Effect Unit
animate renderer scene camera mesh = do
  Object3D.rotateIncrement mesh 0.01 0.01 0.0
  Renderer.render renderer scene camera
  requestAnimationFrame $ animate renderer scene camera mesh
  log "."

requestAnimationFrame :: Effect Unit -> Effect Unit
requestAnimationFrame = unsafeForeignProcedure ["callback", ""] "window.requestAnimationFrame(callback)"
