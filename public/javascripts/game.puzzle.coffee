jQuery(document).ready ->

  class puzzleGame
    constructor: (@debug, @xsplit, @ysplit) ->
      @time = 0

    init: (@resources) ->
      @solution = @resources[Math.floor(Math.random() * @resources.length)]
      @reset()
      @generateChoiceField(@resources)
      @generateTiles()
      @initTimer()

    initTimer: () ->
      console.log @time
      time = 0
      counter = ->
        time += 1
        $('#timer').text('Time: ' + time)
      setInterval(counter, 1000)

    generateTiles: ->
      tileTemplate = $('#tileTemplate')
      tiles = @xsplit * @ysplit
      imgWidth = $('#tileTemplate').width()
      imgHeight = $('#tileTemplate').height()
      tileWidth = imgWidth/@xsplit
      tileHeight = imgHeight/@ysplit
      i = 0
      col = 0
      while col < @ysplit
        row = 0
        while row < @xsplit
          tile = $(tileTemplate.clone())
          tile.draggable({containment:$('#gameArea')})
          tile.show()
          tile.addClass 'tile'
          tile.removeAttr 'id', ''
          tile.css {
            'background-image': 'url(' + @solution['High resolution image'] + ')',
            'background-position': -row*tileWidth+'px ' + -col*tileHeight+'px',
            'width': tileWidth,
            'height': tileHeight,
            'left': Math.floor(Math.random() * 50) + 'px',
            'top': Math.floor(Math.random() * 50) + 'px'
          }
          $('#gameArea').append(tile)
          i++
          row++
          if @debug
            console.log('created', i, 'tile at', row-1, col)
        col++
      tileTemplate.hide()
      if @debug
        console.log('--- Width', imgWidth, 'Height', imgHeight, 'TileWidth', tileWidth, 'TileHight',tileHeight)
        console.log('solution', @getAnswer())

    generateChoiceField: (choices) ->
      i = 1
      for choice in choices
        if choice == @solution 
          $('#selectionArea').append('<div class="choice" id="choice'+i+'"><img class="img-responsive" src="'+ choice['Thumbnail image']+'"</div>')
          @setAnswerValue(i)
        else
          $('#selectionArea').append('<div class="choice" id="choice'+i+'"><img class="img-responsive" src="'+ choice['Thumbnail image']+'"</div>')
        i++

    setAnswerValue:(value) ->
      @solutionValue = value

    getAnswer: ->
      return [@solution, @solutionValue]

    reset: ->
      $('#selectionArea, #gameArea').empty()

    gameWin: ->
      alert('you won')

    gameLose: ->
      alert('you lost')

  retrieveResources = (amount) ->
    reqParam = {
      resource_id: 'cf6e12d8-bd8d-4232-9843-7fa3195cee1c',
      limit: amount
    }
    $.ajax {
      url: 'http://data.gov.au/api/action/datastore_search',
      data: reqParam,
      dataType: 'jsonp',
      cache: true
    }

  processData = (data) ->
    processedData = []
    for item in data.result.records
      if item['High resolution image']
        processedData.push(item)
    return processedData

  currentGame = null
  $('#play').click ->
    currentGame = new puzzleGame false, 8, 8
    retrieveResources(50).then (res) ->
      currentGame.init(processData(res))
      return
    return

  $('#selectionArea').on 'click', '.choice', ->
    if parseInt($(this).attr('id').match(/[0-9]+/)) == currentGame.getAnswer()[1]
      currentGame.gameWin()
    else
      currentGame.gameLose()
    return

  $('#reset').click ->
    currentGame.reset()
    return

  return
   
