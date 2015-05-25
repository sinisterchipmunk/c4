(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var BIKES;

BIKES = [
  {
    make: 'Kawasaki',
    model: 'Ninja 300',
    year: '2013',
    image: 'http://www.nicecycle.com/v/vspfiles/photos/2799-27-2.jpg'
  }
];

c4(function(bus) {
  var fn;
  fn = function() {
    return bus.channel('c4.broker').publish('put', {
      bikes: BIKES
    });
  };
  return setTimeout(fn, 2800);
});


},{}],2:[function(require,module,exports){
var CARS;

CARS = [
  {
    make: 'Dodge',
    model: 'Challenger',
    year: '2015',
    image: 'http://zombiedrive.com/images/2015-dodge-challenger-4.jpg'
  }, {
    make: 'Ariel',
    model: 'Atom',
    year: '2015',
    image: 'http://upload.wikimedia.org/wikipedia/commons/8/8a/ArielAtomGoodwood.jpg'
  }
];

c4(function(bus) {
  var fn;
  fn = function() {
    return bus.channel('c4.broker').publish('put', {
      cars: CARS
    });
  };
  return setTimeout(fn, 3000);
});


},{}],3:[function(require,module,exports){
c4.view('autos-list', {
  path: '/modules/cars/views/list.html',
  init: function(bus) {
    return bus.channel('autos-list').subscribe('compile', function(compiler) {
      var key, link, view;
      view = compiler.view, link = compiler.link;
      key = view.attr('data-source');
      return view.broker([key], function(data) {
        return link({
          autos: data[key],
          source: key
        });
      });
    });
  }
});


},{}],4:[function(require,module,exports){
c4.view('autos-show', {
  path: '/modules/cars/views/show.html',
  init: function(bus) {
    var selection;
    selection = null;
    bus.channel('autos-show').subscribe('params', function(data) {
      selection = data.auto;
      return bus.channel('autos-show').publish('stale');
    });
    return bus.channel('autos-show').subscribe('compile', function(compiler) {
      var key, link, view;
      view = compiler.view, link = compiler.link;
      key = view.attr('data-source');
      return view.broker([key], function(data) {
        var ref;
        return link({
          auto: (ref = data[key]) != null ? ref[selection] : void 0
        });
      });
    });
  }
});


},{}]},{},[1,2,3,4])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL3Vzci9sb2NhbC9saWIvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsIi9Vc2Vycy9jbWFja2VuemllL3Byb2plY3RzL2M0L3Rlc3QvYnJva2VyL21vZHVsZXMvY2Fycy9zZXJ2aWNlcy9iaWtlcy1zZXJ2aWNlLmNvZmZlZSIsIi9Vc2Vycy9jbWFja2VuemllL3Byb2plY3RzL2M0L3Rlc3QvYnJva2VyL21vZHVsZXMvY2Fycy9zZXJ2aWNlcy9jYXJzLXNlcnZpY2UuY29mZmVlIiwiL1VzZXJzL2NtYWNrZW56aWUvcHJvamVjdHMvYzQvdGVzdC9icm9rZXIvbW9kdWxlcy9jYXJzL3ZpZXdzL2F1dG9zLWxpc3QuY29mZmVlIiwiL1VzZXJzL2NtYWNrZW56aWUvcHJvamVjdHMvYzQvdGVzdC9icm9rZXIvbW9kdWxlcy9jYXJzL3ZpZXdzL2F1dG9zLXNob3cuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQUEsSUFBQSxLQUFBOztBQUFBLEtBQUEsR0FBUTtFQUFDO0FBQUEsSUFDUCxJQUFBLEVBQU8sVUFEQTtBQUFBLElBRVAsS0FBQSxFQUFPLFdBRkE7QUFBQSxJQUdQLElBQUEsRUFBTyxNQUhBO0FBQUEsSUFJUCxLQUFBLEVBQU8sMERBSkE7R0FBRDtDQUFSLENBQUE7O0FBQUEsRUFPQSxDQUFHLFNBQUMsR0FBRCxHQUFBO0FBRUQsTUFBQSxFQUFBO0FBQUEsRUFBQSxFQUFBLEdBQUssU0FBQSxHQUFBO1dBQUcsR0FBRyxDQUFDLE9BQUosQ0FBWSxXQUFaLENBQXdCLENBQUMsT0FBekIsQ0FBaUMsS0FBakMsRUFBd0M7QUFBQSxNQUFBLEtBQUEsRUFBTyxLQUFQO0tBQXhDLEVBQUg7RUFBQSxDQUFMLENBQUE7U0FDQSxVQUFBLENBQVcsRUFBWCxFQUFlLElBQWYsRUFIQztBQUFBLENBQUgsQ0FQQSxDQUFBOzs7O0FDQUEsSUFBQSxJQUFBOztBQUFB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WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIkJJS0VTID0gW3tcbiAgbWFrZTogICdLYXdhc2FraSdcbiAgbW9kZWw6ICdOaW5qYSAzMDAnXG4gIHllYXI6ICAnMjAxMydcbiAgaW1hZ2U6ICdodHRwOi8vd3d3Lm5pY2VjeWNsZS5jb20vdi92c3BmaWxlcy9waG90b3MvMjc5OS0yNy0yLmpwZydcbn1dXG5cbmM0IChidXMpIC0+XG4gICMgbWltaWNzIHNvbWUgc29ydCBvZiBsb25nIGxvYWQgdGltZVxuICBmbiA9IC0+IGJ1cy5jaGFubmVsKCdjNC5icm9rZXInKS5wdWJsaXNoICdwdXQnLCBiaWtlczogQklLRVNcbiAgc2V0VGltZW91dCBmbiwgMjgwMFxuIiwiQ0FSUyA9IFt7XG4gIG1ha2U6ICAnRG9kZ2UnXG4gIG1vZGVsOiAnQ2hhbGxlbmdlcidcbiAgeWVhcjogICcyMDE1J1xuICBpbWFnZTogJ2h0dHA6Ly96b21iaWVkcml2ZS5jb20vaW1hZ2VzLzIwMTUtZG9kZ2UtY2hhbGxlbmdlci00LmpwZydcbn0sIHtcbiAgbWFrZTogJ0FyaWVsJ1xuICBtb2RlbDogJ0F0b20nXG4gIHllYXI6ICcyMDE1J1xuICBpbWFnZTogJ2h0dHA6Ly91cGxvYWQud2lraW1lZGlhLm9yZy93aWtpcGVkaWEvY29tbW9ucy84LzhhL0FyaWVsQXRvbUdvb2R3b29kLmpwZydcbn1dXG5cbmM0IChidXMpIC0+XG4gICMgbWltaWNzIHNvbWUgc29ydCBvZiBsb25nIGxvYWQgdGltZVxuICBmbiA9IC0+IGJ1cy5jaGFubmVsKCdjNC5icm9rZXInKS5wdWJsaXNoICdwdXQnLCBjYXJzOiBDQVJTXG4gIHNldFRpbWVvdXQgZm4sIDMwMDBcbiIsImM0LnZpZXcgJ2F1dG9zLWxpc3QnLFxuICBwYXRoOiAnL21vZHVsZXMvY2Fycy92aWV3cy9saXN0Lmh0bWwnXG4gIGluaXQ6IChidXMpIC0+XG4gICAgYnVzLmNoYW5uZWwoJ2F1dG9zLWxpc3QnKS5zdWJzY3JpYmUgJ2NvbXBpbGUnLCAoY29tcGlsZXIpIC0+XG4gICAgICB7dmlldywgbGlua30gPSBjb21waWxlclxuICAgICAga2V5ID0gdmlldy5hdHRyICdkYXRhLXNvdXJjZSdcbiAgICAgIHZpZXcuYnJva2VyIFtrZXldLCAoZGF0YSkgLT5cbiAgICAgICAgbGluayBhdXRvczogZGF0YVtrZXldLCBzb3VyY2U6IGtleVxuIiwiYzQudmlldyAnYXV0b3Mtc2hvdycsXG4gIHBhdGg6ICcvbW9kdWxlcy9jYXJzL3ZpZXdzL3Nob3cuaHRtbCdcbiAgaW5pdDogKGJ1cykgLT5cbiAgICBzZWxlY3Rpb24gPSBudWxsXG5cbiAgICBidXMuY2hhbm5lbCgnYXV0b3Mtc2hvdycpLnN1YnNjcmliZSAncGFyYW1zJywgKGRhdGEpIC0+XG4gICAgICBzZWxlY3Rpb24gPSBkYXRhLmF1dG9cbiAgICAgIGJ1cy5jaGFubmVsKCdhdXRvcy1zaG93JykucHVibGlzaCAnc3RhbGUnXG5cbiAgICBidXMuY2hhbm5lbCgnYXV0b3Mtc2hvdycpLnN1YnNjcmliZSAnY29tcGlsZScsIChjb21waWxlcikgLT5cbiAgICAgIHt2aWV3LCBsaW5rfSA9IGNvbXBpbGVyXG4gICAgICBrZXkgPSB2aWV3LmF0dHIgJ2RhdGEtc291cmNlJ1xuICAgICAgdmlldy5icm9rZXIgW2tleV0sIChkYXRhKSAtPlxuICAgICAgICBsaW5rIGF1dG86IGRhdGFba2V5XT9bc2VsZWN0aW9uXVxuIl19
