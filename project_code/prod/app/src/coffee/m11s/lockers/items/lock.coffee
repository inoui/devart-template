class mk.m11s.lockers.Lock

  constructor: (@type, @part, @seed) ->
    @symbol = mk.Scene::assets['locker'+(@type+1)]
    @item = @symbol.place()
    scale = rng(@seed)*0.3 + 0.7
    if @part.name is "torso"
      scale = rng(@seed)*0.3 + 1.0
    @item.scale scale

    @view = new paper.Group()
    @view.pivot = new paper.Point 0, 0
    @view.transformContent = false
    @view.addChild @item
    @view.z = 2000
    weights = mk.helpers.getRandomWeights @part.joints, @seed
    @follower = new mk.helpers.PartFillFollower @view, @part, weights, rng(@seed) * 100 + 200

    @available = true
    @flying = false
    @out = false

  clean: ->
    # @view.removeChildren()
    @view.remove()

  breakFree: ->
    delayed 300, =>
      view = @view
      rngk = @seed+'breakFree'
      @velX = (rng(rngk)+1) / 20
      @velY = -(rng(rngk)+1) / 30
      @velRotation = (rng(rngk)+1) / 40
      @flying = true
      @follower = null

  update: (dt) ->
    if @out then return
    if @flying
      @view.position.y += @velY * dt
      if @view.position.y < -window.viewport.height*0.5
        @out = true
        return
      @view.position.x += @velX * dt
      @view.rotate @velRotation * dt
      @velX *= 1.02
      @velY *= 1.04
      @velRotation *= 1.02
    else
      @follower.update()
      if @part.name is 'head'
        @view.position.y += 15