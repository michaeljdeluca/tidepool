// The JavaScript implementation of the
// http://download.oracle.com/javase/6/docs/api/java/util/Collections.html
Processing.prototype.Collections = ((function() {
  var c = {};
  c.sort = function(list, comparator) {
    var comp;
    if (!comparator) {
      comp = function(x, y) {
        if (typeof x === "object") {
          return x.compareTo(y);
        }
        return x == y ? 0 : (x < y ? -1 : 1);
      };
    } else {
      comp = comparator.compare;
    }
    
    function quicksort(left, right) {
      if (left >= right) {
        return;
      }
      var i = left, j  = right, c = (left + right) >> 1;
      while (i <= c && j >= c) {
        while (comp(list.get(i), list.get(c)) < 0 && i <= c) {
          ++i;
        }
        while (comp(list.get(j), list.get(c)) > 0 && j >= c) {
          --j;
        }
        var tmp = list.get(i);
        list.set(i, list.get(j));
        list.set(j, tmp);
        i++;
        j--;
        if (i - 1 === c) {
          c = ++j;
        } else if (j + 1 === c) {
          c = --i;
        }
      }
      quicksort(left, c - 1);
      quicksort(c + 1, right);
    }
    
    quicksort(0, list.size() - 1);
  };
  
  return c;
})());
