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
    return bus.channel('autos-list').subscribe('compile', function(compile) {
      var key;
      key = compile.view.attr('data-source');
      return compile.view.brokers([key], function(data) {
        return compile.link({
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
    return bus.channel('autos-show').subscribe('compile', function(compile) {
      var key;
      key = compile.view.attr('data-source');
      return compile.view.brokers([key], function(data) {
        var ref;
        return compile.link({
          auto: (ref = data[key]) != null ? ref[selection] : void 0
        });
      });
    });
  }
});


},{}]},{},[1,2,3,4])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL3Vzci9sb2NhbC9saWIvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsIi9Vc2Vycy9jbWFja2VuemllL3Byb2plY3RzL2M0L3Rlc3QvYnJva2VyL21vZHVsZXMvY2Fycy9iaWtlcy1zZXJ2aWNlLmNvZmZlZSIsIi9Vc2Vycy9jbWFja2VuemllL3Byb2plY3RzL2M0L3Rlc3QvYnJva2VyL21vZHVsZXMvY2Fycy9jYXJzLXNlcnZpY2UuY29mZmVlIiwiL1VzZXJzL2NtYWNrZW56aWUvcHJvamVjdHMvYzQvdGVzdC9icm9rZXIvbW9kdWxlcy9jYXJzL3ZpZXdzL2F1dG9zLWxpc3QuY29mZmVlIiwiL1VzZXJzL2NtYWNrZW56aWUvcHJvamVjdHMvYzQvdGVzdC9icm9rZXIvbW9kdWxlcy9jYXJzL3ZpZXdzL2F1dG9zLXNob3cuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQUEsSUFBQSxLQUFBOztBQUFBLEtBQUEsR0FBUTtFQUFDO0FBQUEsSUFDUCxJQUFBLEVBQU8sVUFEQTtBQUFBLElBRVAsS0FBQSxFQUFPLFdBRkE7QUFBQSxJQUdQLElBQUEsRUFBTyxNQUhBO0FBQUEsSUFJUCxLQUFBLEVBQU8sMERBSkE7R0FBRDtDQUFSLENBQUE7O0FBQUEsRUFPQSxDQUFHLFNBQUMsR0FBRCxHQUFBO0FBRUQsTUFBQSxFQUFBO0FBQUEsRUFBQSxFQUFBLEdBQUssU0FBQSxHQUFBO1dBQUcsR0FBRyxDQUFDLE9BQUosQ0FBWSxXQUFaLENBQXdCLENBQUMsT0FBekIsQ0FBaUMsS0FBakMsRUFBd0M7QUFBQSxNQUFBLEtBQUEsRUFBTyxLQUFQO0tBQXhDLEVBQUg7RUFBQSxDQUFMLENBQUE7U0FDQSxVQUFBLENBQVcsRUFBWCxFQUFlLElBQWYsRUFIQztBQUFBLENBQUgsQ0FQQSxDQUFBOzs7O0FDQUEsSUFBQSxJQUFBOztBQUFBLElBQUEsR0FBTztFQUFDO0FBQUEsSUFDTixJQUFBLEVBQU8sT0FERDtBQUFBLElBRU4sS0FBQSxFQUFPLFlBRkQ7QUFBQSxJQUdOLElBQUEsRUFBTyxNQUhEO0FBQUEsSUFJTixLQUFBLEVBQU8sMkRBSkQ7R0FBRCxFQUtKO0FBQUEsSUFDRCxJQUFBLEVBQU0sT0FETDtBQUFBLElBRUQsS0FBQSxFQUFPLE1BRk47QUFBQSxJQUdELElBQUEsRUFBTSxNQUhMO0FBQUEsSUFJRCxLQUFBLEVBQU8sMEVBSk47R0FMSTtDQUFQLENBQUE7O0FBQUEsRUFZQSxDQUFHLFNBQUMsR0FBRCxHQUFBO0FBRUQsTUFBQSxFQUFBO0FBQUEsRUFBQSxFQUFBLEdBQUssU0FBQSxHQUFBO1dBQUcsR0FBRyxDQUFDLE9BQUosQ0FBWSxXQUFaLENBQXdCLENBQUMsT0FBekIsQ0FBaUMsS0FBakMsRUFBd0M7QUFBQSxNQUFBLElBQUEsRUFBTSxJQUFOO0tBQXhDLEVBQUg7RUFBQSxDQUFMLENBQUE7U0FDQSxVQUFBLENBQVcsRUFBWCxFQUFlLElBQWYsRUFIQztBQUFBLENBQUgsQ0FaQSxDQUFBOzs7O0FDQUEsRUFBRSxDQUFDLElBQUgsQ0FBUSxZQUFSLEVBQ0U7QUFBQSxFQUFBLElBQUEsRUFBTSwrQkFBTjtBQUFBLEVBQ0EsSUFBQSxFQUFNLFNBQUMsR0FBRCxHQUFBO1dBQ0osR0FBRyxDQUFDLE9BQUosQ0FBWSxZQUFaLENBQXlCLENBQUMsU0FBMUIsQ0FBb0MsU0FBcEMsRUFBK0MsU0FBQyxPQUFELEdBQUE7QUFDN0MsVUFBQSxHQUFBO0FBQUEsTUFBQSxHQUFBLEdBQU0sT0FBTyxDQUFDLElBQUksQ0FBQyxJQUFiLENBQWtCLGFBQWxCLENBQU4sQ0FBQTthQUNBLE9BQU8sQ0FBQyxJQUFJLENBQUMsT0FBYixDQUFxQixDQUFDLEdBQUQsQ0FBckIsRUFBNEIsU0FBQyxJQUFELEdBQUE7ZUFDMUIsT0FBTyxDQUFDLElBQVIsQ0FBYTtBQUFBLFVBQUEsS0FBQSxFQUFPLElBQUssQ0FBQSxHQUFBLENBQVo7QUFBQSxVQUFrQixNQUFBLEVBQVEsR0FBMUI7U0FBYixFQUQwQjtNQUFBLENBQTVCLEVBRjZDO0lBQUEsQ0FBL0MsRUFESTtFQUFBLENBRE47Q0FERixDQUFBLENBQUE7Ozs7QUNBQSxFQUFFLENBQUMsSUFBSCxDQUFRLFlBQVIsRUFDRTtBQUFBLEVBQUEsSUFBQSxFQUFNLCtCQUFOO0FBQUEsRUFDQSxJQUFBLEVBQU0sU0FBQyxHQUFELEdBQUE7QUFDSixRQUFBLFNBQUE7QUFBQSxJQUFBLFNBQUEsR0FBWSxJQUFaLENBQUE7QUFBQSxJQUVBLEdBQUcsQ0FBQyxPQUFKLENBQVksWUFBWixDQUF5QixDQUFDLFNBQTFCLENBQW9DLFFBQXBDLEVBQThDLFNBQUMsSUFBRCxHQUFBO0FBQzVDLE1BQUEsU0FBQSxHQUFZLElBQUksQ0FBQyxJQUFqQixDQUFBO2FBQ0EsR0FBRyxDQUFDLE9BQUosQ0FBWSxZQUFaLENBQXlCLENBQUMsT0FBMUIsQ0FBa0MsT0FBbEMsRUFGNEM7SUFBQSxDQUE5QyxDQUZBLENBQUE7V0FNQSxHQUFHLENBQUMsT0FBSixDQUFZLFlBQVosQ0FBeUIsQ0FBQyxTQUExQixDQUFvQyxTQUFwQyxFQUErQyxTQUFDLE9BQUQsR0FBQTtBQUM3QyxVQUFBLEdBQUE7QUFBQSxNQUFBLEdBQUEsR0FBTSxPQUFPLENBQUMsSUFBSSxDQUFDLElBQWIsQ0FBa0IsYUFBbEIsQ0FBTixDQUFBO2FBQ0EsT0FBTyxDQUFDLElBQUksQ0FBQyxPQUFiLENBQXFCLENBQUMsR0FBRCxDQUFyQixFQUE0QixTQUFDLElBQUQsR0FBQTtBQUMxQixZQUFBLEdBQUE7ZUFBQSxPQUFPLENBQUMsSUFBUixDQUFhO0FBQUEsVUFBQSxJQUFBLGlDQUFpQixDQUFBLFNBQUEsVUFBakI7U0FBYixFQUQwQjtNQUFBLENBQTVCLEVBRjZDO0lBQUEsQ0FBL0MsRUFQSTtFQUFBLENBRE47Q0FERixDQUFBLENBQUEiLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXNDb250ZW50IjpbIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dmFyIGY9bmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKTt0aHJvdyBmLmNvZGU9XCJNT0RVTEVfTk9UX0ZPVU5EXCIsZn12YXIgbD1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwobC5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxsLGwuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIiwiQklLRVMgPSBbe1xuICBtYWtlOiAgJ0thd2FzYWtpJ1xuICBtb2RlbDogJ05pbmphIDMwMCdcbiAgeWVhcjogICcyMDEzJ1xuICBpbWFnZTogJ2h0dHA6Ly93d3cubmljZWN5Y2xlLmNvbS92L3ZzcGZpbGVzL3Bob3Rvcy8yNzk5LTI3LTIuanBnJ1xufV1cblxuYzQgKGJ1cykgLT5cbiAgIyBtaW1pY3Mgc29tZSBzb3J0IG9mIGxvbmcgbG9hZCB0aW1lXG4gIGZuID0gLT4gYnVzLmNoYW5uZWwoJ2M0LmJyb2tlcicpLnB1Ymxpc2ggJ3B1dCcsIGJpa2VzOiBCSUtFU1xuICBzZXRUaW1lb3V0IGZuLCAyODAwXG4iLCJDQVJTID0gW3tcbiAgbWFrZTogICdEb2RnZSdcbiAgbW9kZWw6ICdDaGFsbGVuZ2VyJ1xuICB5ZWFyOiAgJzIwMTUnXG4gIGltYWdlOiAnaHR0cDovL3pvbWJpZWRyaXZlLmNvbS9pbWFnZXMvMjAxNS1kb2RnZS1jaGFsbGVuZ2VyLTQuanBnJ1xufSwge1xuICBtYWtlOiAnQXJpZWwnXG4gIG1vZGVsOiAnQXRvbSdcbiAgeWVhcjogJzIwMTUnXG4gIGltYWdlOiAnaHR0cDovL3VwbG9hZC53aWtpbWVkaWEub3JnL3dpa2lwZWRpYS9jb21tb25zLzgvOGEvQXJpZWxBdG9tR29vZHdvb2QuanBnJ1xufV1cblxuYzQgKGJ1cykgLT5cbiAgIyBtaW1pY3Mgc29tZSBzb3J0IG9mIGxvbmcgbG9hZCB0aW1lXG4gIGZuID0gLT4gYnVzLmNoYW5uZWwoJ2M0LmJyb2tlcicpLnB1Ymxpc2ggJ3B1dCcsIGNhcnM6IENBUlNcbiAgc2V0VGltZW91dCBmbiwgMzAwMFxuIiwiYzQudmlldyAnYXV0b3MtbGlzdCcsXG4gIHBhdGg6ICcvbW9kdWxlcy9jYXJzL3ZpZXdzL2xpc3QuaHRtbCdcbiAgaW5pdDogKGJ1cykgLT5cbiAgICBidXMuY2hhbm5lbCgnYXV0b3MtbGlzdCcpLnN1YnNjcmliZSAnY29tcGlsZScsIChjb21waWxlKSAtPlxuICAgICAga2V5ID0gY29tcGlsZS52aWV3LmF0dHIgJ2RhdGEtc291cmNlJ1xuICAgICAgY29tcGlsZS52aWV3LmJyb2tlcnMgW2tleV0sIChkYXRhKSAtPlxuICAgICAgICBjb21waWxlLmxpbmsgYXV0b3M6IGRhdGFba2V5XSwgc291cmNlOiBrZXlcbiIsImM0LnZpZXcgJ2F1dG9zLXNob3cnLFxuICBwYXRoOiAnL21vZHVsZXMvY2Fycy92aWV3cy9zaG93Lmh0bWwnXG4gIGluaXQ6IChidXMpIC0+XG4gICAgc2VsZWN0aW9uID0gbnVsbFxuXG4gICAgYnVzLmNoYW5uZWwoJ2F1dG9zLXNob3cnKS5zdWJzY3JpYmUgJ3BhcmFtcycsIChkYXRhKSAtPlxuICAgICAgc2VsZWN0aW9uID0gZGF0YS5hdXRvXG4gICAgICBidXMuY2hhbm5lbCgnYXV0b3Mtc2hvdycpLnB1Ymxpc2ggJ3N0YWxlJ1xuXG4gICAgYnVzLmNoYW5uZWwoJ2F1dG9zLXNob3cnKS5zdWJzY3JpYmUgJ2NvbXBpbGUnLCAoY29tcGlsZSkgLT5cbiAgICAgIGtleSA9IGNvbXBpbGUudmlldy5hdHRyICdkYXRhLXNvdXJjZSdcbiAgICAgIGNvbXBpbGUudmlldy5icm9rZXJzIFtrZXldLCAoZGF0YSkgLT5cbiAgICAgICAgY29tcGlsZS5saW5rIGF1dG86IGRhdGFba2V5XT9bc2VsZWN0aW9uXVxuIl19
