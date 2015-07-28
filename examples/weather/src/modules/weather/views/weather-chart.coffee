allColors = null

c4.view 'weather-chart',
  path: '/modules/weather/views/weather-chart.html'
  compile: (compiler) ->
    {view, link, bus} = compiler

    unless allColors?.length
      allColors = d3.scale.category10().range()
    color = allColors.shift()

    view.broker 'weather', view.attr('data-topic'), (data) ->
      link
        title: view.attr 'data-title'

      nv.addGraph ->
        chart = nv.models.lineChart()
          .x (temp) -> temp.label
          .y (temp) -> temp.value
          .color [color]
          .useInteractiveGuideline true
          .width 300
          .height 300

        chart.xAxis
          .tickFormat (d) -> d3.time.format('%I %p') new Date d

        chart.yAxis
          .tickFormat (d) -> parseInt(d) + (view.attr('data-y-suffix') || '')

        d3.select(view.find("svg")[0])
          .datum [ {
            key: view.attr('data-key')
            values: data[view.attr 'data-topic']
          } ]
          .call chart
        nv.utils.windowResize(chart.update);
        chart
