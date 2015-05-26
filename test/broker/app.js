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
c4.view('autos-index', {
  path: '/modules/autos/views/index.html',
  compile: function(compiler) {
    return compiler.link();
  }
});


},{}],4:[function(require,module,exports){
c4.view('autos-list', {
  path: '/modules/autos/views/list.html',
  compile: function(compiler) {
    var key, link, view;
    view = compiler.view, link = compiler.link;
    key = view.attr('data-source');
    return view.broker([key], function(data) {
      return link({
        autos: data[key],
        source: key
      });
    });
  }
});


},{}],5:[function(require,module,exports){
c4.view('autos-show', {
  path: '/modules/autos/views/show.html',
  compile: function(compiler) {
    var key, link, view;
    view = compiler.view, link = compiler.link;
    key = view.attr('data-source');
    return view.broker([key, 'params'], function(data) {
      var ref, ref1, selection;
      selection = (ref = data.params) != null ? ref.auto : void 0;
      return link({
        auto: (ref1 = data[key]) != null ? ref1[selection] : void 0
      });
    });
  }
});


},{}]},{},[1,2,3,4,5])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL3Vzci9sb2NhbC9saWIvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsIi9Vc2Vycy9jbWFja2VuemllL3Byb2plY3RzL2M0L3Rlc3QvYnJva2VyL21vZHVsZXMvYXV0b3Mvc2VydmljZXMvYmlrZXMtc2VydmljZS5jb2ZmZWUiLCIvVXNlcnMvY21hY2tlbnppZS9wcm9qZWN0cy9jNC90ZXN0L2Jyb2tlci9tb2R1bGVzL2F1dG9zL3NlcnZpY2VzL2NhcnMtc2VydmljZS5jb2ZmZWUiLCIvVXNlcnMvY21hY2tlbnppZS9wcm9qZWN0cy9jNC90ZXN0L2Jyb2tlci9tb2R1bGVzL2F1dG9zL3ZpZXdzL2F1dG9zLWluZGV4LmNvZmZlZSIsIi9Vc2Vycy9jbWFja2VuemllL3Byb2plY3RzL2M0L3Rlc3QvYnJva2VyL21vZHVsZXMvYXV0b3Mvdmlld3MvYXV0b3MtbGlzdC5jb2ZmZWUiLCIvVXNlcnMvY21hY2tlbnppZS9wcm9qZWN0cy9jNC90ZXN0L2Jyb2tlci9tb2R1bGVzL2F1dG9zL3ZpZXdzL2F1dG9zLXNob3cuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQUEsSUFBQSxLQUFBOztBQUFBLEtBQUEsR0FBUTtFQUFDO0FBQUEsSUFDUCxJQUFBLEVBQU8sVUFEQTtBQUFBLElBRVAsS0FBQSxFQUFPLFdBRkE7QUFBQSxJQUdQLElBQUEsRUFBTyxNQUhBO0FBQUEsSUFJUCxLQUFBLEVBQU8sMERBSkE7R0FBRDtDQUFSLENBQUE7O0FBQUEsRUFPQSxDQUFHLFNBQUMsR0FBRCxHQUFBO0FBRUQsTUFBQSxFQUFBO0FBQUEsRUFBQSxFQUFBLEdBQUssU0FBQSxHQUFBO1dBQUcsR0FBRyxDQUFDLE9BQUosQ0FBWSxXQUFaLENBQXdCLENBQUMsT0FBekIsQ0FBaUMsS0FBakMsRUFBd0M7QUFBQSxNQUFBLEtBQUEsRUFBTyxLQUFQO0tBQXhDLEVBQUg7RUFBQSxDQUFMLENBQUE7U0FDQSxVQUFBLENBQVcsRUFBWCxFQUFlLElBQWYsRUFIQztBQUFBLENBQUgsQ0FQQSxDQUFBOzs7O0FDQUEsSUFBQSxJQUFBOztBQUFBLElBQUEsR0FBTztFQUFDO0FBQUEsSUFDTixJQUFBLEVBQU8sT0FERDtBQUFBLElBRU4sS0FBQSxFQUFPLFlBRkQ7QUFBQSxJQUdOLElBQUEsRUFBTyxNQUhEO0FBQUEsSUFJTixLQUFBLEVBQU8sMkRBSkQ7R0FBRCxFQUtKO0FBQUEsSUFDRCxJQUFBLEVBQU0sT0FETDtBQUFBLElBRUQsS0FBQSxFQUFPLE1BRk47QUFBQSxJQUdELElBQUEsRUFBTSxNQUhMO0FBQUEsSUFJRCxLQUFBLEVBQU8sMEVBSk47R0FMSTtDQUFQLENBQUE7O0FBQUEsRUFZQSxDQUFHLFNBQUMsR0FBRCxHQUFBO0FBRUQsTUFBQSxFQUFBO0FBQUEsRUFBQSxFQUFBLEdBQUssU0FBQSxHQUFBO1dBQUcsR0FBRyxDQUFDLE9BQUosQ0FBWSxXQUFaLENBQXdCLENBQUMsT0FBekIsQ0FBaUMsS0FBakMsRUFBd0M7QUFBQSxNQUFBLElBQUEsRUFBTSxJQUFOO0tBQXhDLEVBQUg7RUFBQSxDQUFMLENBQUE7U0FDQSxVQUFBLENBQVcsRUFBWCxFQUFlLElBQWYsRUFIQztBQUFBLENBQUgsQ0FaQSxDQUFBOzs7O0FDQUEsRUFBRSxDQUFDLElBQUgsQ0FBUSxhQUFSLEVBQ0U7QUFBQSxFQUFBLElBQUEsRUFBTSxpQ0FBTjtBQUFBLEVBQ0EsT0FBQSxFQUFTLFNBQUMsUUFBRCxHQUFBO1dBQWMsUUFBUSxDQUFDLElBQVQsQ0FBQSxFQUFkO0VBQUEsQ0FEVDtDQURGLENBQUEsQ0FBQTs7OztBQ0FBLEVBQUUsQ0FBQyxJQUFILENBQVEsWUFBUixFQUNFO0FBQUEsRUFBQSxJQUFBLEVBQU0sZ0NBQU47QUFBQSxFQUNBLE9BQUEsRUFBUyxTQUFDLFFBQUQsR0FBQTtBQUNQLFFBQUEsZUFBQTtBQUFBLElBQUMsZ0JBQUEsSUFBRCxFQUFPLGdCQUFBLElBQVAsQ0FBQTtBQUFBLElBQ0EsR0FBQSxHQUFNLElBQUksQ0FBQyxJQUFMLENBQVUsYUFBVixDQUROLENBQUE7V0FFQSxJQUFJLENBQUMsTUFBTCxDQUFZLENBQUMsR0FBRCxDQUFaLEVBQW1CLFNBQUMsSUFBRCxHQUFBO2FBQ2pCLElBQUEsQ0FBSztBQUFBLFFBQUEsS0FBQSxFQUFPLElBQUssQ0FBQSxHQUFBLENBQVo7QUFBQSxRQUFrQixNQUFBLEVBQVEsR0FBMUI7T0FBTCxFQURpQjtJQUFBLENBQW5CLEVBSE87RUFBQSxDQURUO0NBREYsQ0FBQSxDQUFBOzs7O0FDQUEsRUFBRSxDQUFDLElBQUgsQ0FBUSxZQUFSLEVBQ0U7QUFBQSxFQUFBLElBQUEsRUFBTSxnQ0FBTjtBQUFBLEVBQ0EsT0FBQSxFQUFTLFNBQUMsUUFBRCxHQUFBO0FBQ1AsUUFBQSxlQUFBO0FBQUEsSUFBQyxnQkFBQSxJQUFELEVBQU8sZ0JBQUEsSUFBUCxDQUFBO0FBQUEsSUFDQSxHQUFBLEdBQU0sSUFBSSxDQUFDLElBQUwsQ0FBVSxhQUFWLENBRE4sQ0FBQTtXQUVBLElBQUksQ0FBQyxNQUFMLENBQVksQ0FBQyxHQUFELEVBQU0sUUFBTixDQUFaLEVBQTZCLFNBQUMsSUFBRCxHQUFBO0FBQzNCLFVBQUEsb0JBQUE7QUFBQSxNQUFBLFNBQUEsb0NBQXVCLENBQUUsYUFBekIsQ0FBQTthQUNBLElBQUEsQ0FBSztBQUFBLFFBQUEsSUFBQSxtQ0FBaUIsQ0FBQSxTQUFBLFVBQWpCO09BQUwsRUFGMkI7SUFBQSxDQUE3QixFQUhPO0VBQUEsQ0FEVDtDQURGLENBQUEsQ0FBQSIsImZpbGUiOiJnZW5lcmF0ZWQuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt2YXIgZj1uZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpO3Rocm93IGYuY29kZT1cIk1PRFVMRV9OT1RfRk9VTkRcIixmfXZhciBsPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChsLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGwsbC5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJCSUtFUyA9IFt7XG4gIG1ha2U6ICAnS2F3YXNha2knXG4gIG1vZGVsOiAnTmluamEgMzAwJ1xuICB5ZWFyOiAgJzIwMTMnXG4gIGltYWdlOiAnaHR0cDovL3d3dy5uaWNlY3ljbGUuY29tL3YvdnNwZmlsZXMvcGhvdG9zLzI3OTktMjctMi5qcGcnXG59XVxuXG5jNCAoYnVzKSAtPlxuICAjIG1pbWljcyBzb21lIHNvcnQgb2YgbG9uZyBsb2FkIHRpbWVcbiAgZm4gPSAtPiBidXMuY2hhbm5lbCgnYzQuYnJva2VyJykucHVibGlzaCAncHV0JywgYmlrZXM6IEJJS0VTXG4gIHNldFRpbWVvdXQgZm4sIDI4MDBcbiIsIkNBUlMgPSBbe1xuICBtYWtlOiAgJ0RvZGdlJ1xuICBtb2RlbDogJ0NoYWxsZW5nZXInXG4gIHllYXI6ICAnMjAxNSdcbiAgaW1hZ2U6ICdodHRwOi8vem9tYmllZHJpdmUuY29tL2ltYWdlcy8yMDE1LWRvZGdlLWNoYWxsZW5nZXItNC5qcGcnXG59LCB7XG4gIG1ha2U6ICdBcmllbCdcbiAgbW9kZWw6ICdBdG9tJ1xuICB5ZWFyOiAnMjAxNSdcbiAgaW1hZ2U6ICdodHRwOi8vdXBsb2FkLndpa2ltZWRpYS5vcmcvd2lraXBlZGlhL2NvbW1vbnMvOC84YS9BcmllbEF0b21Hb29kd29vZC5qcGcnXG59XVxuXG5jNCAoYnVzKSAtPlxuICAjIG1pbWljcyBzb21lIHNvcnQgb2YgbG9uZyBsb2FkIHRpbWVcbiAgZm4gPSAtPiBidXMuY2hhbm5lbCgnYzQuYnJva2VyJykucHVibGlzaCAncHV0JywgY2FyczogQ0FSU1xuICBzZXRUaW1lb3V0IGZuLCAzMDAwXG4iLCJjNC52aWV3ICdhdXRvcy1pbmRleCcsXG4gIHBhdGg6ICcvbW9kdWxlcy9hdXRvcy92aWV3cy9pbmRleC5odG1sJ1xuICBjb21waWxlOiAoY29tcGlsZXIpIC0+IGNvbXBpbGVyLmxpbmsoKVxuIiwiYzQudmlldyAnYXV0b3MtbGlzdCcsXG4gIHBhdGg6ICcvbW9kdWxlcy9hdXRvcy92aWV3cy9saXN0Lmh0bWwnXG4gIGNvbXBpbGU6IChjb21waWxlcikgLT5cbiAgICB7dmlldywgbGlua30gPSBjb21waWxlclxuICAgIGtleSA9IHZpZXcuYXR0ciAnZGF0YS1zb3VyY2UnXG4gICAgdmlldy5icm9rZXIgW2tleV0sIChkYXRhKSAtPlxuICAgICAgbGluayBhdXRvczogZGF0YVtrZXldLCBzb3VyY2U6IGtleVxuIiwiYzQudmlldyAnYXV0b3Mtc2hvdycsXG4gIHBhdGg6ICcvbW9kdWxlcy9hdXRvcy92aWV3cy9zaG93Lmh0bWwnXG4gIGNvbXBpbGU6IChjb21waWxlcikgLT5cbiAgICB7dmlldywgbGlua30gPSBjb21waWxlclxuICAgIGtleSA9IHZpZXcuYXR0ciAnZGF0YS1zb3VyY2UnXG4gICAgdmlldy5icm9rZXIgW2tleSwgJ3BhcmFtcyddLCAoZGF0YSkgLT5cbiAgICAgIHNlbGVjdGlvbiA9IGRhdGEucGFyYW1zPy5hdXRvXG4gICAgICBsaW5rIGF1dG86IGRhdGFba2V5XT9bc2VsZWN0aW9uXVxuIl19
