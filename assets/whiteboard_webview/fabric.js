var fabric = fabric || { version: "5.3.0" };
if (
  ("undefined" != typeof exports
    ? (exports.fabric = fabric)
    : "function" == typeof define &&
      define.amd &&
      define([], function () {
        return fabric;
      }),
  "undefined" != typeof document && "undefined" != typeof window)
)
  (fabric.document =
    document instanceof
    ("undefined" != typeof HTMLDocument ? HTMLDocument : Document)
      ? document
      : document.implementation.createHTMLDocument("")),
    (fabric.window = window);
else {
  var jsdom = require("jsdom"),
    virtualWindow = new jsdom.JSDOM(
      decodeURIComponent(
        "%3C!DOCTYPE%20html%3E%3Chtml%3E%3Chead%3E%3C%2Fhead%3E%3Cbody%3E%3C%2Fbody%3E%3C%2Fhtml%3E"
      ),
      { features: { FetchExternalResources: ["img"] }, resources: "usable" }
    ).window;
  (fabric.document = virtualWindow.document),
    (fabric.jsdomImplForWrapper =
      require("jsdom/lib/jsdom/living/generated/utils").implForWrapper),
    (fabric.nodeCanvas = require("jsdom/lib/jsdom/utils").Canvas),
    (fabric.window = virtualWindow),
    (DOMParser = fabric.window.DOMParser);
}
(fabric.isTouchSupported =
  "ontouchstart" in fabric.window ||
  "ontouchstart" in fabric.document ||
  (fabric.window &&
    fabric.window.navigator &&
    fabric.window.navigator.maxTouchPoints > 0)),
  (fabric.isLikelyNode =
    "undefined" != typeof Buffer && "undefined" == typeof window),
  (fabric.SHARED_ATTRIBUTES = [
    "display",
    "transform",
    "fill",
    "fill-opacity",
    "fill-rule",
    "opacity",
    "stroke",
    "stroke-dasharray",
    "stroke-linecap",
    "stroke-dashoffset",
    "stroke-linejoin",
    "stroke-miterlimit",
    "stroke-opacity",
    "stroke-width",
    "id",
    "paint-order",
    "vector-effect",
    "instantiated_by_use",
    "clip-path",
  ]),
  (fabric.DPI = 96),
  (fabric.reNum = "(?:[-+]?(?:\\d+|\\d*\\.\\d+)(?:[eE][-+]?\\d+)?)"),
  (fabric.commaWsp = "(?:\\s+,?\\s*|,\\s*)"),
  (fabric.rePathCommand =
    /([-+]?((\d+\.\d+)|((\d+)|(\.\d+)))(?:[eE][-+]?\d+)?)/gi),
  (fabric.reNonWord = /[ \n\.,;!\?\-]/),
  (fabric.fontPaths = {}),
  (fabric.iMatrix = [1, 0, 0, 1, 0, 0]),
  (fabric.svgNS = "http://www.w3.org/2000/svg"),
  (fabric.perfLimitSizeTotal = 2097152),
  (fabric.maxCacheSideLimit = 4096),
  (fabric.minCacheSideLimit = 256),
  (fabric.charWidthsCache = {}),
  (fabric.textureSize = 2048),
  (fabric.disableStyleCopyPaste = !1),
  (fabric.enableGLFiltering = !0),
  (fabric.devicePixelRatio =
    fabric.window.devicePixelRatio ||
    fabric.window.webkitDevicePixelRatio ||
    fabric.window.mozDevicePixelRatio ||
    1),
  (fabric.browserShadowBlurConstant = 1),
  (fabric.arcToSegmentsCache = {}),
  (fabric.boundsOfCurveCache = {}),
  (fabric.cachesBoundsOfCurve = !0),
  (fabric.forceGLPutImageData = !1),
  (fabric.initFilterBackend = function () {
    return fabric.enableGLFiltering &&
      fabric.isWebglSupported &&
      fabric.isWebglSupported(fabric.textureSize)
      ? (console.log("max texture size: " + fabric.maxTextureSize),
        new fabric.WebglFilterBackend({ tileSize: fabric.textureSize }))
      : fabric.Canvas2dFilterBackend
      ? new fabric.Canvas2dFilterBackend()
      : void 0;
  });
"undefined" != typeof document &&
  "undefined" != typeof window &&
  (window.fabric = fabric);
if ("undefined" == typeof eventjs) var eventjs = {};
if (
  ((function (e) {
    "use strict";
    (e.modifyEventListener = !1),
      (e.modifySelectors = !1),
      (e.configure = function (t) {
        isFinite(t.modifyEventListener) &&
          (e.modifyEventListener = t.modifyEventListener),
          isFinite(t.modifySelectors) &&
            (e.modifySelectors = t.modifySelectors),
          l === !1 && e.modifyEventListener && p(),
          g === !1 && e.modifySelectors && m();
      }),
      (e.add = function (e, t, r, o) {
        return n(e, t, r, o, "add");
      }),
      (e.remove = function (e, t, r, o) {
        return n(e, t, r, o, "remove");
      }),
      (e.returnFalse = function () {
        return !1;
      }),
      (e.stop = function (e) {
        e &&
          (e.stopPropagation && e.stopPropagation(),
          (e.cancelBubble = !0),
          (e.cancelBubbleCount = 0));
      }),
      (e.prevent = function (e) {
        e &&
          (e.preventDefault
            ? e.preventDefault()
            : e.preventManipulation
            ? e.preventManipulation()
            : (e.returnValue = !1));
      }),
      (e.cancel = function (t) {
        e.stop(t), e.prevent(t);
      }),
      (e.blur = function () {
        var e = document.activeElement;
        if (e) {
          var t = document.activeElement.nodeName;
          ("INPUT" === t || "TEXTAREA" === t || "true" === e.contentEditable) &&
            e.blur &&
            e.blur();
        }
      }),
      (e.getEventSupport = function (e, t) {
        if (
          ("string" == typeof e && ((t = e), (e = window)),
          (t = "on" + t),
          t in e)
        )
          return !0;
        if (
          (e.setAttribute || (e = document.createElement("div")),
          e.setAttribute && e.removeAttribute)
        ) {
          e.setAttribute(t, "");
          var n = "function" == typeof e[t];
          return (
            "undefined" != typeof e[t] && (e[t] = null), e.removeAttribute(t), n
          );
        }
      });
    var t = function (e) {
        if (!e || "object" != typeof e) return e;
        var n = new e.constructor();
        for (var r in e)
          n[r] = e[r] && "object" == typeof e[r] ? t(e[r]) : e[r];
        return n;
      },
      n = function (i, s, d, l, p, g) {
        if (((l = l || {}), "[object Object]" === String(i))) {
          var m = i;
          if (((i = m.target), delete m.target, !m.type || !m.listener)) {
            for (var y in m) {
              var j = m[y];
              "function" != typeof j && (l[y] = j);
            }
            var w = {};
            for (var h in m) {
              var y = h.split(","),
                b = m[h],
                x = {};
              for (var P in l) x[P] = l[P];
              if ("function" == typeof b) var d = b;
              else {
                if ("function" != typeof b.listener) continue;
                var d = b.listener;
                for (var P in b) "function" != typeof b[P] && (x[P] = b[P]);
              }
              for (var E = 0; E < y.length; E++)
                w[h] = eventjs.add(i, y[E], d, x, p);
            }
            return w;
          }
          (s = m.type), delete m.type, (d = m.listener), delete m.listener;
          for (var h in m) l[h] = m[h];
        }
        if (i && s && d) {
          if ("string" == typeof i && "ready" === s) {
            if (!window.eventjs_stallOnReady) {
              var M = new Date().getTime(),
                T = l.timeout,
                D = l.interval || 1e3 / 60,
                G = window.setInterval(function () {
                  new Date().getTime() - M > T && window.clearInterval(G),
                    document.querySelector(i) &&
                      (window.clearInterval(G), setTimeout(d, 1));
                }, D);
              return;
            }
            (s = "load"), (i = window);
          }
          if ("string" == typeof i) {
            if (((i = document.querySelectorAll(i)), 0 === i.length))
              return o("Missing target on listener!", arguments);
            1 === i.length && (i = i[0]);
          }
          var L,
            k = {};
          if (i.length > 0 && i !== window) {
            for (var S = 0, C = i.length; C > S; S++)
              (L = n(i[S], s, d, t(l), p)), L && (k[S] = L);
            return r(k);
          }
          if (
            ("string" == typeof s &&
              ((s = s.toLowerCase()),
              -1 !== s.indexOf(" ")
                ? (s = s.split(" "))
                : -1 !== s.indexOf(",") && (s = s.split(","))),
            "string" != typeof s)
          ) {
            if ("number" == typeof s.length)
              for (var H = 0, F = s.length; F > H; H++)
                (L = n(i, s[H], d, t(l), p)), L && (k[s[H]] = L);
            else
              for (var h in s)
                (L =
                  "function" == typeof s[h]
                    ? n(i, h, s[h], t(l), p)
                    : n(i, h, s[h].listener, t(s[h]), p)),
                  L && (k[h] = L);
            return r(k);
          }
          if ((0 === s.indexOf("on") && (s = s.slice(2)), "object" != typeof i))
            return o("Target is not defined!", arguments);
          if ("function" != typeof d)
            return o("Listener is not a function!", arguments);
          var X = l.useCapture || !1,
            Y = v(i) + "." + v(d) + "." + (X ? 1 : 0);
          if (e.Gesture && e.Gesture._gestureHandlers[s]) {
            if (((Y = s + Y), "remove" === p)) {
              if (!u[Y]) return;
              u[Y].remove(), delete u[Y];
            } else if ("add" === p) {
              if (u[Y]) return u[Y].add(), u[Y];
              if (l.useCall && !e.modifyEventListener) {
                var _ = d;
                d = function (e, t) {
                  for (var n in t) e[n] = t[n];
                  return _.call(i, e);
                };
              }
              (l.gesture = s),
                (l.target = i),
                (l.listener = d),
                (l.fromOverwrite = g),
                (u[Y] = e.proxy[s](l));
            }
            return u[Y];
          }
          for (var U, O = a(s), E = 0; E < O.length; E++)
            if (((s = O[E]), (U = s + "." + Y), "remove" === p)) {
              if (!u[U]) continue;
              i[c](s, d, X), delete u[U];
            } else if ("add" === p) {
              if (u[U]) return u[U];
              i[f](s, d, X),
                (u[U] = {
                  id: U,
                  type: s,
                  target: i,
                  listener: d,
                  remove: function () {
                    for (var t = 0; t < O.length; t++) e.remove(i, O[t], d, l);
                  },
                });
            }
          return u[U];
        }
      },
      r = function (e) {
        return {
          remove: function () {
            for (var t in e) e[t].remove();
          },
          add: function () {
            for (var t in e) e[t].add();
          },
        };
      },
      o = function (e, t) {
        "undefined" != typeof console &&
          "undefined" != typeof console.error &&
          console.error(e, t);
      },
      i = {
        msPointer: ["MSPointerDown", "MSPointerMove", "MSPointerUp"],
        touch: ["touchstart", "touchmove", "touchend"],
        mouse: ["mousedown", "mousemove", "mouseup"],
      },
      s = {
        MSPointerDown: 0,
        MSPointerMove: 1,
        MSPointerUp: 2,
        touchstart: 0,
        touchmove: 1,
        touchend: 2,
        mousedown: 0,
        mousemove: 1,
        mouseup: 2,
      },
      a =
        ((function () {
          (e.supports = {}),
            window.navigator.msPointerEnabled && (e.supports.msPointer = !0),
            e.getEventSupport("touchstart") && (e.supports.touch = !0),
            e.getEventSupport("mousedown") && (e.supports.mouse = !0);
        })(),
        (function () {
          return function (t) {
            var n = document.addEventListener ? "" : "on",
              r = s[t];
            if (isFinite(r)) {
              var o = [];
              for (var a in e.supports) o.push(n + i[a][r]);
              return o;
            }
            return [n + t];
          };
        })()),
      u = {},
      d = 0,
      v = function (e) {
        return e === window
          ? "#window"
          : e === document
          ? "#document"
          : (e.uniqueID || (e.uniqueID = "e" + d++), e.uniqueID);
      },
      f = document.addEventListener ? "addEventListener" : "attachEvent",
      c = document.removeEventListener ? "removeEventListener" : "detachEvent";
    e.createPointerEvent = function (t, n, r) {
      var o = n.gesture,
        i = n.target,
        s = t.changedTouches || e.proxy.getCoords(t);
      if (s.length) {
        var a = s[0];
        (n.pointers = r ? [] : s),
          (n.pageX = a.pageX),
          (n.pageY = a.pageY),
          (n.x = n.pageX),
          (n.y = n.pageY);
      }
      var u = document.createEvent("Event");
      u.initEvent(o, !0, !0), (u.originalEvent = t);
      for (var d in n) "target" !== d && (u[d] = n[d]);
      var v = u.type;
      e.Gesture &&
        e.Gesture._gestureHandlers[v] &&
        n.oldListener.call(i, u, n, !1);
    };
    var l = !1,
      p = function () {
        if (window.HTMLElement) {
          var t = function (t) {
            var r = function (r) {
              var o = r + "EventListener",
                i = t[o];
              t[o] = function (t, o, s) {
                if (e.Gesture && e.Gesture._gestureHandlers[t]) {
                  var u = s;
                  "object" == typeof s
                    ? (u.useCall = !0)
                    : (u = { useCall: !0, useCapture: s }),
                    n(this, t, o, u, r, !0);
                } else
                  for (var d = a(t), v = 0; v < d.length; v++)
                    i.call(this, d[v], o, s);
              };
            };
            r("add"), r("remove");
          };
          navigator.userAgent.match(/Firefox/)
            ? (t(HTMLDivElement.prototype), t(HTMLCanvasElement.prototype))
            : t(HTMLElement.prototype),
            t(document),
            t(window);
        }
      },
      g = !1,
      m = function () {
        var e = NodeList.prototype;
        (e.removeEventListener = function (e, t, n) {
          for (var r = 0, o = this.length; o > r; r++)
            this[r].removeEventListener(e, t, n);
        }),
          (e.addEventListener = function (e, t, n) {
            for (var r = 0, o = this.length; o > r; r++)
              this[r].addEventListener(e, t, n);
          });
      };
    return e;
  })(eventjs),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    e.pointerSetup = function (e, t) {
      (e.target = e.target || window),
        (e.doc = e.target.ownerDocument || e.target),
        (e.minFingers = e.minFingers || e.fingers || 1),
        (e.maxFingers = e.maxFingers || e.fingers || 1 / 0),
        (e.position = e.position || "relative"),
        delete e.fingers,
        (t = t || {}),
        (t.enabled = !0),
        (t.gesture = e.gesture),
        (t.target = e.target),
        (t.env = e.env),
        eventjs.modifyEventListener &&
          e.fromOverwrite &&
          ((e.oldListener = e.listener),
          (e.listener = eventjs.createPointerEvent));
      var n = 0,
        r =
          0 === t.gesture.indexOf("pointer") && eventjs.modifyEventListener
            ? "pointer"
            : "mouse";
      return (
        e.oldListener && (t.oldListener = e.oldListener),
        (t.listener = e.listener),
        (t.proxy = function (n) {
          (t.defaultListener = e.listener), (e.listener = n), n(e.event, t);
        }),
        (t.add = function () {
          t.enabled !== !0 &&
            (e.onPointerDown &&
              eventjs.add(e.target, r + "down", e.onPointerDown),
            e.onPointerMove && eventjs.add(e.doc, r + "move", e.onPointerMove),
            e.onPointerUp && eventjs.add(e.doc, r + "up", e.onPointerUp),
            (t.enabled = !0));
        }),
        (t.remove = function () {
          t.enabled !== !1 &&
            (e.onPointerDown &&
              eventjs.remove(e.target, r + "down", e.onPointerDown),
            e.onPointerMove &&
              eventjs.remove(e.doc, r + "move", e.onPointerMove),
            e.onPointerUp && eventjs.remove(e.doc, r + "up", e.onPointerUp),
            t.reset(),
            (t.enabled = !1));
        }),
        (t.pause = function (t) {
          !e.onPointerMove ||
            (t && !t.move) ||
            eventjs.remove(e.doc, r + "move", e.onPointerMove),
            !e.onPointerUp ||
              (t && !t.up) ||
              eventjs.remove(e.doc, r + "up", e.onPointerUp),
            (n = e.fingers),
            (e.fingers = 0);
        }),
        (t.resume = function (t) {
          !e.onPointerMove ||
            (t && !t.move) ||
            eventjs.add(e.doc, r + "move", e.onPointerMove),
            !e.onPointerUp ||
              (t && !t.up) ||
              eventjs.add(e.doc, r + "up", e.onPointerUp),
            (e.fingers = n);
        }),
        (t.reset = function () {
          (e.tracker = {}), (e.fingers = 0);
        }),
        t
      );
    };
    var t = eventjs.supports;
    (eventjs.isMouse = !!t.mouse),
      (eventjs.isMSPointer = !!t.touch),
      (eventjs.isTouch = !!t.msPointer),
      (e.pointerStart = function (t, n, r) {
        var o = (t.type || "mousedown").toUpperCase();
        0 === o.indexOf("MOUSE")
          ? ((eventjs.isMouse = !0),
            (eventjs.isTouch = !1),
            (eventjs.isMSPointer = !1))
          : 0 === o.indexOf("TOUCH")
          ? ((eventjs.isMouse = !1),
            (eventjs.isTouch = !0),
            (eventjs.isMSPointer = !1))
          : 0 === o.indexOf("MSPOINTER") &&
            ((eventjs.isMouse = !1),
            (eventjs.isTouch = !1),
            (eventjs.isMSPointer = !0));
        var i = function (e, t) {
          var n = r.bbox,
            o = (a[t] = {});
          switch (r.position) {
            case "absolute":
              (o.offsetX = 0), (o.offsetY = 0);
              break;
            case "differenceFromLast":
              (o.offsetX = e.pageX), (o.offsetY = e.pageY);
              break;
            case "difference":
              (o.offsetX = e.pageX), (o.offsetY = e.pageY);
              break;
            case "move":
              (o.offsetX = e.pageX - n.x1), (o.offsetY = e.pageY - n.y1);
              break;
            default:
              (o.offsetX = n.x1 - n.scrollLeft),
                (o.offsetY = n.y1 - n.scrollTop);
          }
          var i = e.pageX - o.offsetX,
            s = e.pageY - o.offsetY;
          (o.rotation = 0),
            (o.scale = 1),
            (o.startTime = o.moveTime = new Date().getTime()),
            (o.move = { x: i, y: s }),
            (o.start = { x: i, y: s }),
            r.fingers++;
        };
        (r.event = t),
          n.defaultListener &&
            ((r.listener = n.defaultListener), delete n.defaultListener);
        for (
          var s = !r.fingers,
            a = r.tracker,
            u = t.changedTouches || e.getCoords(t),
            d = u.length,
            v = 0;
          d > v;
          v++
        ) {
          var f = u[v],
            c = f.identifier || 1 / 0;
          if (r.fingers) {
            if (r.fingers >= r.maxFingers) {
              var l = [];
              for (var c in r.tracker) l.push(c);
              return (n.identifier = l.join(",")), s;
            }
            var p = 0;
            for (var g in a) {
              if (a[g].up) {
                delete a[g], i(f, c), (r.cancel = !0);
                break;
              }
              p++;
            }
            if (a[c]) continue;
            i(f, c);
          } else
            (a = r.tracker = {}),
              (n.bbox = r.bbox = e.getBoundingBox(r.target)),
              (r.fingers = 0),
              (r.cancel = !1),
              i(f, c);
        }
        var l = [];
        for (var c in r.tracker) l.push(c);
        return (n.identifier = l.join(",")), s;
      }),
      (e.pointerEnd = function (e, t, n, r) {
        for (var o = e.touches || [], i = o.length, s = {}, a = 0; i > a; a++) {
          var u = o[a],
            d = u.identifier;
          s[d || 1 / 0] = !0;
        }
        for (var d in n.tracker) {
          var v = n.tracker[d];
          s[d] ||
            v.up ||
            (r &&
              r(
                {
                  pageX: v.pageX,
                  pageY: v.pageY,
                  changedTouches: [
                    {
                      pageX: v.pageX,
                      pageY: v.pageY,
                      identifier: "Infinity" === d ? 1 / 0 : d,
                    },
                  ],
                },
                "up"
              ),
            (v.up = !0),
            n.fingers--);
        }
        if (0 !== n.fingers) return !1;
        var f = [];
        n.gestureFingers = 0;
        for (var d in n.tracker) n.gestureFingers++, f.push(d);
        return (t.identifier = f.join(",")), !0;
      }),
      (e.getCoords = function (t) {
        return (
          (e.getCoords =
            "undefined" != typeof t.pageX
              ? function (e) {
                  return Array({
                    type: "mouse",
                    x: e.pageX,
                    y: e.pageY,
                    pageX: e.pageX,
                    pageY: e.pageY,
                    identifier: e.pointerId || 1 / 0,
                  });
                }
              : function (e) {
                  var t = document.documentElement;
                  return (
                    (e = e || window.event),
                    Array({
                      type: "mouse",
                      x: e.clientX + t.scrollLeft,
                      y: e.clientY + t.scrollTop,
                      pageX: e.clientX + t.scrollLeft,
                      pageY: e.clientY + t.scrollTop,
                      identifier: 1 / 0,
                    })
                  );
                }),
          e.getCoords(t)
        );
      }),
      (e.getCoord = function (t) {
        if ("ontouchstart" in window) {
          var n = 0,
            r = 0;
          e.getCoord = function (e) {
            var t = e.changedTouches;
            return t && t.length
              ? { x: (n = t[0].pageX), y: (r = t[0].pageY) }
              : { x: n, y: r };
          };
        } else
          e.getCoord =
            "undefined" != typeof t.pageX && "undefined" != typeof t.pageY
              ? function (e) {
                  return { x: e.pageX, y: e.pageY };
                }
              : function (e) {
                  var t = document.documentElement;
                  return (
                    (e = e || window.event),
                    { x: e.clientX + t.scrollLeft, y: e.clientY + t.scrollTop }
                  );
                };
        return e.getCoord(t);
      });
    var n = function (e, t) {
      var n = parseFloat(e.getPropertyValue(t), 10);
      return isFinite(n) ? n : 0;
    };
    return (
      (e.getBoundingBox = function (e) {
        (e === window || e === document) && (e = document.body);
        var t = {},
          r = e.getBoundingClientRect();
        (t.width = r.width),
          (t.height = r.height),
          (t.x1 = r.left),
          (t.y1 = r.top),
          (t.scaleX = r.width / e.offsetWidth || 1),
          (t.scaleY = r.height / e.offsetHeight || 1),
          (t.scrollLeft = 0),
          (t.scrollTop = 0);
        var o = window.getComputedStyle(e),
          i = "border-box" === o.getPropertyValue("box-sizing");
        if (i === !1) {
          var s = n(o, "border-left-width"),
            a = n(o, "border-right-width"),
            u = n(o, "border-bottom-width"),
            d = n(o, "border-top-width");
          (t.border = [s, a, d, u]),
            (t.x1 += s),
            (t.y1 += d),
            (t.width -= a + s),
            (t.height -= u + d);
        }
        (t.x2 = t.x1 + t.width), (t.y2 = t.y1 + t.height);
        for (
          var v = o.getPropertyValue("position"),
            f = "fixed" === v ? e : e.parentNode;
          null !== f && f !== document.body && void 0 !== f.scrollTop;

        ) {
          var o = window.getComputedStyle(f),
            v = o.getPropertyValue("position");
          if ("absolute" === v);
          else {
            if ("fixed" === v) {
              (t.scrollTop -= f.parentNode.scrollTop),
                (t.scrollLeft -= f.parentNode.scrollLeft);
              break;
            }
            (t.scrollLeft += f.scrollLeft), (t.scrollTop += f.scrollTop);
          }
          f = f.parentNode;
        }
        return (
          (t.scrollBodyLeft =
            void 0 !== window.pageXOffset
              ? window.pageXOffset
              : (
                  document.documentElement ||
                  document.body.parentNode ||
                  document.body
                ).scrollLeft),
          (t.scrollBodyTop =
            void 0 !== window.pageYOffset
              ? window.pageYOffset
              : (
                  document.documentElement ||
                  document.body.parentNode ||
                  document.body
                ).scrollTop),
          (t.scrollLeft -= t.scrollBodyLeft),
          (t.scrollTop -= t.scrollBodyTop),
          t
        );
      }),
      (function () {
        var t,
          n = navigator.userAgent.toLowerCase(),
          r = -1 !== n.indexOf("macintosh");
        (t =
          r && -1 !== n.indexOf("khtml")
            ? { 91: !0, 93: !0 }
            : r && -1 !== n.indexOf("firefox")
            ? { 224: !0 }
            : { 17: !0 }),
          (e.metaTrackerReset = function () {
            (eventjs.fnKey = e.fnKey = !1),
              (eventjs.metaKey = e.metaKey = !1),
              (eventjs.escKey = e.escKey = !1),
              (eventjs.ctrlKey = e.ctrlKey = !1),
              (eventjs.shiftKey = e.shiftKey = !1),
              (eventjs.altKey = e.altKey = !1);
          })(),
          (e.metaTracker = function (n) {
            var r = "keydown" === n.type;
            27 === n.keyCode && (eventjs.escKey = e.escKey = r),
              t[n.keyCode] && (eventjs.metaKey = e.metaKey = r),
              (eventjs.ctrlKey = e.ctrlKey = n.ctrlKey),
              (eventjs.shiftKey = e.shiftKey = n.shiftKey),
              (eventjs.altKey = e.altKey = n.altKey);
          });
      })(),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ((eventjs.MutationObserver = (function () {
    var e =
        window.MutationObserver ||
        window.WebKitMutationObserver ||
        window.MozMutationObserver,
      t =
        !e &&
        (function () {
          var e = document.createElement("p"),
            t = !1,
            n = function () {
              t = !0;
            };
          if (e.addEventListener) e.addEventListener("DOMAttrModified", n, !1);
          else {
            if (!e.attachEvent) return !1;
            e.attachEvent("onDOMAttrModified", n);
          }
          return e.setAttribute("id", "target"), t;
        })();
    return function (n, r) {
      if (e) {
        var o = { subtree: !1, attributes: !0 },
          i = new e(function (e) {
            e.forEach(function (e) {
              r.call(e.target, e.attributeName);
            });
          });
        i.observe(n, o);
      } else
        t
          ? eventjs.add(n, "DOMAttrModified", function (e) {
              r.call(n, e.attrName);
            })
          : "onpropertychange" in document.body &&
            eventjs.add(n, "propertychange", function () {
              r.call(n, window.event.propertyName);
            });
    };
  })()),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.click = function (t) {
        (t.gesture = t.gesture || "click"),
          (t.maxFingers = t.maxFingers || t.fingers || 1),
          (t.onPointerDown = function (r) {
            e.pointerStart(r, n, t) &&
              eventjs.add(t.target, "mouseup", t.onPointerUp);
          }),
          (t.onPointerUp = function (r) {
            if (e.pointerEnd(r, n, t)) {
              eventjs.remove(t.target, "mouseup", t.onPointerUp);
              var o = r.changedTouches || e.getCoords(r),
                i = o[0],
                s = t.bbox,
                a = e.getBoundingBox(t.target),
                u = i.pageY - a.scrollBodyTop,
                d = i.pageX - a.scrollBodyLeft;
              if (
                d > s.x1 &&
                u > s.y1 &&
                d < s.x2 &&
                u < s.y2 &&
                s.scrollTop === a.scrollTop
              ) {
                for (var v in t.tracker) break;
                var f = t.tracker[v];
                (n.x = f.start.x), (n.y = f.start.y), t.listener(r, n);
              }
            }
          });
        var n = e.pointerSetup(t);
        return (
          (n.state = "click"),
          eventjs.add(t.target, "mousedown", t.onPointerDown),
          n
        );
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.click = e.click),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.dbltap = e.dblclick =
        function (t) {
          (t.gesture = t.gesture || "dbltap"),
            (t.maxFingers = t.maxFingers || t.fingers || 1);
          var n,
            r,
            o,
            i,
            s,
            a = 700;
          (t.onPointerDown = function (d) {
            var v = d.changedTouches || e.getCoords(d);
            n && !r
              ? ((s = v[0]), (r = new Date().getTime() - n))
              : ((i = v[0]),
                (n = new Date().getTime()),
                (r = 0),
                clearTimeout(o),
                (o = setTimeout(function () {
                  n = 0;
                }, a))),
              e.pointerStart(d, u, t) &&
                (eventjs
                  .add(t.target, "mousemove", t.onPointerMove)
                  .listener(d),
                eventjs.add(t.target, "mouseup", t.onPointerUp));
          }),
            (t.onPointerMove = function (a) {
              if (n && !r) {
                var u = a.changedTouches || e.getCoords(a);
                s = u[0];
              }
              var d = t.bbox,
                v = s.pageX - d.x1,
                f = s.pageY - d.y1;
              (v > 0 &&
                v < d.width &&
                f > 0 &&
                f < d.height &&
                Math.abs(s.pageX - i.pageX) <= 25 &&
                Math.abs(s.pageY - i.pageY) <= 25) ||
                (eventjs.remove(t.target, "mousemove", t.onPointerMove),
                clearTimeout(o),
                (n = r = 0));
            }),
            (t.onPointerUp = function (i) {
              if (
                (e.pointerEnd(i, u, t) &&
                  (eventjs.remove(t.target, "mousemove", t.onPointerMove),
                  eventjs.remove(t.target, "mouseup", t.onPointerUp)),
                n && r)
              ) {
                if (a >= r) {
                  u.state = t.gesture;
                  for (var s in t.tracker) break;
                  var d = t.tracker[s];
                  (u.x = d.start.x), (u.y = d.start.y), t.listener(i, u);
                }
                clearTimeout(o), (n = r = 0);
              }
            });
          var u = e.pointerSetup(t);
          return (
            (u.state = "dblclick"),
            eventjs.add(t.target, "mousedown", t.onPointerDown),
            u
          );
        }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.dbltap = e.dbltap),
      (eventjs.Gesture._gestureHandlers.dblclick = e.dblclick),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.dragElement = function (t, n) {
        e.drag({
          event: n,
          target: t,
          position: "move",
          listener: function (e, n) {
            (t.style.left = n.x + "px"),
              (t.style.top = n.y + "px"),
              eventjs.prevent(e);
          },
        });
      }),
      (e.drag = function (t) {
        (t.gesture = "drag"),
          (t.onPointerDown = function (r) {
            e.pointerStart(r, n, t) &&
              (t.monitor ||
                (eventjs.add(t.doc, "mousemove", t.onPointerMove),
                eventjs.add(t.doc, "mouseup", t.onPointerUp))),
              t.onPointerMove(r, "down");
          }),
          (t.onPointerMove = function (r, o) {
            if (!t.tracker) return t.onPointerDown(r);
            for (
              var i = (t.bbox, r.changedTouches || e.getCoords(r)),
                s = i.length,
                a = 0;
              s > a;
              a++
            ) {
              var u = i[a],
                d = u.identifier || 1 / 0,
                v = t.tracker[d];
              v &&
                ((v.pageX = u.pageX),
                (v.pageY = u.pageY),
                (n.state = o || "move"),
                (n.identifier = d),
                (n.start = v.start),
                (n.fingers = t.fingers),
                "differenceFromLast" === t.position
                  ? ((n.x = v.pageX - v.offsetX),
                    (n.y = v.pageY - v.offsetY),
                    (v.offsetX = v.pageX),
                    (v.offsetY = v.pageY))
                  : ((n.x = v.pageX - v.offsetX), (n.y = v.pageY - v.offsetY)),
                t.listener(r, n));
            }
          }),
          (t.onPointerUp = function (r) {
            e.pointerEnd(r, n, t, t.onPointerMove) &&
              (t.monitor ||
                (eventjs.remove(t.doc, "mousemove", t.onPointerMove),
                eventjs.remove(t.doc, "mouseup", t.onPointerUp)));
          });
        var n = e.pointerSetup(t);
        return (
          t.event
            ? t.onPointerDown(t.event)
            : (eventjs.add(t.target, "mousedown", t.onPointerDown),
              t.monitor &&
                (eventjs.add(t.doc, "mousemove", t.onPointerMove),
                eventjs.add(t.doc, "mouseup", t.onPointerUp))),
          n
        );
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.drag = e.drag),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    var t = Math.PI / 180,
      n = function (e, t) {
        var n = 0,
          r = 0,
          o = 0;
        for (var i in t) {
          var s = t[i];
          s.up || ((n += s.move.x), (r += s.move.y), o++);
        }
        return (e.x = n /= o), (e.y = r /= o), e;
      };
    return (
      (e.gesture = function (r) {
        (r.gesture = r.gesture || "gesture"),
          (r.minFingers = r.minFingers || r.fingers || 2),
          (r.onPointerDown = function (t) {
            var i = r.fingers;
            if (
              (e.pointerStart(t, o, r) &&
                (eventjs.add(r.doc, "mousemove", r.onPointerMove),
                eventjs.add(r.doc, "mouseup", r.onPointerUp)),
              r.fingers === r.minFingers && i !== r.fingers)
            ) {
              (o.fingers = r.minFingers),
                (o.scale = 1),
                (o.rotation = 0),
                (o.state = "start");
              var s = "";
              for (var a in r.tracker) s += a;
              (o.identifier = parseInt(s)), n(o, r.tracker), r.listener(t, o);
            }
          }),
          (r.onPointerMove = function (i) {
            for (
              var s = r.bbox,
                a = r.tracker,
                u = i.changedTouches || e.getCoords(i),
                d = u.length,
                v = 0;
              d > v;
              v++
            ) {
              var f = u[v],
                c = f.identifier || 1 / 0,
                l = a[c];
              l && ((l.move.x = f.pageX - s.x1), (l.move.y = f.pageY - s.y1));
            }
            if (!(r.fingers < r.minFingers)) {
              var u = [],
                p = 0,
                g = 0;
              n(o, a);
              for (var c in a) {
                var f = a[c];
                if (!f.up) {
                  var m = f.start;
                  if (!m.distance) {
                    var y = m.x - o.x,
                      j = m.y - o.y;
                    (m.distance = Math.sqrt(y * y + j * j)),
                      (m.angle = Math.atan2(y, j) / t);
                  }
                  var y = f.move.x - o.x,
                    j = f.move.y - o.y,
                    w = Math.sqrt(y * y + j * j);
                  0 !== m.distance && (p += w / m.distance);
                  var h = Math.atan2(y, j) / t,
                    b = ((m.angle - h + 360) % 360) - 180;
                  (f.DEG2 = f.DEG1),
                    (f.DEG1 = b > 0 ? b : -b),
                    "undefined" != typeof f.DEG2 &&
                      (b > 0
                        ? (f.rotation += f.DEG1 - f.DEG2)
                        : (f.rotation -= f.DEG1 - f.DEG2),
                      (g += f.rotation)),
                    u.push(f.move);
                }
              }
              (o.touches = u),
                (o.fingers = r.fingers),
                (o.scale = p / r.fingers),
                (o.rotation = g / r.fingers),
                (o.state = "change"),
                r.listener(i, o);
            }
          }),
          (r.onPointerUp = function (t) {
            var n = r.fingers;
            e.pointerEnd(t, o, r) &&
              (eventjs.remove(r.doc, "mousemove", r.onPointerMove),
              eventjs.remove(r.doc, "mouseup", r.onPointerUp)),
              n === r.minFingers &&
                r.fingers < r.minFingers &&
                ((o.fingers = r.fingers), (o.state = "end"), r.listener(t, o));
          });
        var o = e.pointerSetup(r);
        return eventjs.add(r.target, "mousedown", r.onPointerDown), o;
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.gesture = e.gesture),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.pointerdown =
        e.pointermove =
        e.pointerup =
          function (t) {
            if (
              ((t.gesture = t.gesture || "pointer"), !t.target.isPointerEmitter)
            ) {
              var n = !0;
              (t.onPointerDown = function (e) {
                (n = !1), (r.gesture = "pointerdown"), t.listener(e, r);
              }),
                (t.onPointerMove = function (e) {
                  (r.gesture = "pointermove"), t.listener(e, r, n);
                }),
                (t.onPointerUp = function (e) {
                  (n = !0), (r.gesture = "pointerup"), t.listener(e, r, !0);
                });
              var r = e.pointerSetup(t);
              return (
                eventjs.add(t.target, "mousedown", t.onPointerDown),
                eventjs.add(t.target, "mousemove", t.onPointerMove),
                eventjs.add(t.doc, "mouseup", t.onPointerUp),
                (t.target.isPointerEmitter = !0),
                r
              );
            }
          }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.pointerdown = e.pointerdown),
      (eventjs.Gesture._gestureHandlers.pointermove = e.pointermove),
      (eventjs.Gesture._gestureHandlers.pointerup = e.pointerup),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.shake = function (e) {
        var t = {
            gesture: "devicemotion",
            acceleration: {},
            accelerationIncludingGravity: {},
            target: e.target,
            listener: e.listener,
            remove: function () {
              window.removeEventListener("devicemotion", d, !1);
            },
          },
          n = 4,
          r = 1e3,
          o = 200,
          i = 3,
          s = new Date().getTime(),
          a = { x: 0, y: 0, z: 0 },
          u = {
            x: { count: 0, value: 0 },
            y: { count: 0, value: 0 },
            z: { count: 0, value: 0 },
          },
          d = function (d) {
            var v = 0.8,
              f = d.accelerationIncludingGravity;
            if (
              ((a.x = v * a.x + (1 - v) * f.x),
              (a.y = v * a.y + (1 - v) * f.y),
              (a.z = v * a.z + (1 - v) * f.z),
              (t.accelerationIncludingGravity = a),
              (t.acceleration.x = f.x - a.x),
              (t.acceleration.y = f.y - a.y),
              (t.acceleration.z = f.z - a.z),
              "devicemotion" === e.gesture)
            )
              return void e.listener(d, t);
            for (
              var c = "xyz", l = new Date().getTime(), p = 0, g = c.length;
              g > p;
              p++
            ) {
              var m = c[p],
                y = t.acceleration[m],
                j = u[m],
                w = Math.abs(y);
              if (!(r > l - s) && w > n) {
                var h = (l * y) / w,
                  b = Math.abs(h + j.value);
                j.value && o > b
                  ? ((j.value = h),
                    j.count++,
                    j.count === i &&
                      (e.listener(d, t), (s = l), (j.value = 0), (j.count = 0)))
                  : ((j.value = h), (j.count = 1));
              }
            }
          };
        return window.addEventListener
          ? (window.addEventListener("devicemotion", d, !1), t)
          : void 0;
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.shake = e.shake),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    var t = Math.PI / 180;
    return (
      (e.swipe = function (n) {
        (n.snap = n.snap || 90),
          (n.threshold = n.threshold || 1),
          (n.gesture = n.gesture || "swipe"),
          (n.onPointerDown = function (t) {
            e.pointerStart(t, r, n) &&
              (eventjs.add(n.doc, "mousemove", n.onPointerMove).listener(t),
              eventjs.add(n.doc, "mouseup", n.onPointerUp));
          }),
          (n.onPointerMove = function (t) {
            for (
              var r = t.changedTouches || e.getCoords(t), o = r.length, i = 0;
              o > i;
              i++
            ) {
              var s = r[i],
                a = s.identifier || 1 / 0,
                u = n.tracker[a];
              u &&
                ((u.move.x = s.pageX),
                (u.move.y = s.pageY),
                (u.moveTime = new Date().getTime()));
            }
          }),
          (n.onPointerUp = function (o) {
            if (e.pointerEnd(o, r, n)) {
              eventjs.remove(n.doc, "mousemove", n.onPointerMove),
                eventjs.remove(n.doc, "mouseup", n.onPointerUp);
              var i,
                s,
                a,
                u,
                d = { x: 0, y: 0 },
                v = 0,
                f = 0,
                c = 0;
              for (var l in n.tracker) {
                var p = n.tracker[l],
                  g = p.move.x - p.start.x,
                  m = p.move.y - p.start.y;
                (v += p.move.x),
                  (f += p.move.y),
                  (d.x += p.start.x),
                  (d.y += p.start.y),
                  c++;
                var y = Math.sqrt(g * g + m * m),
                  j = p.moveTime - p.startTime,
                  u = Math.atan2(g, m) / t + 180,
                  s = j ? y / j : 0;
                if ("undefined" == typeof a) (a = u), (i = s);
                else {
                  if (!(Math.abs(u - a) <= 20)) return;
                  (a = (a + u) / 2), (i = (i + s) / 2);
                }
              }
              var w = n.gestureFingers;
              n.minFingers <= w &&
                n.maxFingers >= w &&
                i > n.threshold &&
                ((d.x /= c),
                (d.y /= c),
                (r.start = d),
                (r.x = v / c),
                (r.y = f / c),
                (r.angle = -(
                  (((a / n.snap + 0.5) >> 0) * n.snap || 360) - 360
                )),
                (r.velocity = i),
                (r.fingers = w),
                (r.state = "swipe"),
                n.listener(o, r));
            }
          });
        var r = e.pointerSetup(n);
        return eventjs.add(n.target, "mousedown", n.onPointerDown), r;
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.swipe = e.swipe),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.longpress = function (t) {
        return (t.gesture = "longpress"), e.tap(t);
      }),
      (e.tap = function (t) {
        (t.delay = t.delay || 500),
          (t.timeout = t.timeout || 250),
          (t.driftDeviance = t.driftDeviance || 10),
          (t.gesture = t.gesture || "tap");
        var n, r;
        (t.onPointerDown = function (i) {
          if (e.pointerStart(i, o, t)) {
            if (
              ((n = new Date().getTime()),
              eventjs.add(t.doc, "mousemove", t.onPointerMove).listener(i),
              eventjs.add(t.doc, "mouseup", t.onPointerUp),
              "longpress" !== t.gesture)
            )
              return;
            r = setTimeout(function () {
              if (!(i.cancelBubble && ++i.cancelBubbleCount > 1)) {
                var e = 0;
                for (var n in t.tracker) {
                  var r = t.tracker[n];
                  if (r.end === !0) return;
                  if (t.cancel) return;
                  e++;
                }
                t.minFingers <= e &&
                  t.maxFingers >= e &&
                  ((o.state = "start"),
                  (o.fingers = e),
                  (o.x = r.start.x),
                  (o.y = r.start.y),
                  t.listener(i, o));
              }
            }, t.delay);
          }
        }),
          (t.onPointerMove = function (n) {
            for (
              var r = t.bbox,
                o = n.changedTouches || e.getCoords(n),
                i = o.length,
                s = 0;
              i > s;
              s++
            ) {
              var a = o[s],
                u = a.identifier || 1 / 0,
                d = t.tracker[u];
              if (d) {
                var v = a.pageX - r.x1 - parseInt(window.scrollX),
                  f = a.pageY - r.y1 - parseInt(window.scrollY),
                  c = v - d.start.x,
                  l = f - d.start.y,
                  p = Math.sqrt(c * c + l * l);
                if (
                  !(
                    v > 0 &&
                    v < r.width &&
                    f > 0 &&
                    f < r.height &&
                    p <= t.driftDeviance
                  )
                )
                  return (
                    eventjs.remove(t.doc, "mousemove", t.onPointerMove),
                    void (t.cancel = !0)
                  );
              }
            }
          }),
          (t.onPointerUp = function (i) {
            if (e.pointerEnd(i, o, t)) {
              if (
                (clearTimeout(r),
                eventjs.remove(t.doc, "mousemove", t.onPointerMove),
                eventjs.remove(t.doc, "mouseup", t.onPointerUp),
                i.cancelBubble && ++i.cancelBubbleCount > 1)
              )
                return;
              if ("longpress" === t.gesture)
                return void (
                  "start" === o.state && ((o.state = "end"), t.listener(i, o))
                );
              if (t.cancel) return;
              if (new Date().getTime() - n > t.timeout) return;
              var s = t.gestureFingers;
              t.minFingers <= s &&
                t.maxFingers >= s &&
                ((o.state = "tap"),
                (o.fingers = t.gestureFingers),
                t.listener(i, o));
            }
          });
        var o = e.pointerSetup(t);
        return eventjs.add(t.target, "mousedown", t.onPointerDown), o;
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.tap = e.tap),
      (eventjs.Gesture._gestureHandlers.longpress = e.longpress),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof eventjs)
)
  var eventjs = {};
if (
  ("undefined" == typeof eventjs.proxy && (eventjs.proxy = {}),
  (eventjs.proxy = (function (e) {
    "use strict";
    return (
      (e.wheelPreventElasticBounce = function (e) {
        e &&
          ("string" == typeof e && (e = document.querySelector(e)),
          eventjs.add(e, "wheel", function (e, t) {
            t.preventElasticBounce(), eventjs.stop(e);
          }));
      }),
      (e.wheel = function (e) {
        var t,
          n = e.timeout || 150,
          r = 0,
          o = {
            gesture: "wheel",
            state: "start",
            wheelDelta: 0,
            target: e.target,
            listener: e.listener,
            preventElasticBounce: function (e) {
              var t = this.target,
                n = t.scrollTop,
                r = n + t.offsetHeight,
                o = t.scrollHeight;
              r === o && this.wheelDelta <= 0
                ? eventjs.cancel(e)
                : 0 === n && this.wheelDelta >= 0 && eventjs.cancel(e),
                eventjs.stop(e);
            },
            add: function () {
              e.target[s](u, i, !1);
            },
            remove: function () {
              e.target[a](u, i, !1);
            },
          },
          i = function (i) {
            (i = i || window.event),
              (o.state = r++ ? "change" : "start"),
              (o.wheelDelta = i.detail ? -20 * i.detail : i.wheelDelta),
              e.listener(i, o),
              clearTimeout(t),
              (t = setTimeout(function () {
                (r = 0),
                  (o.state = "end"),
                  (o.wheelDelta = 0),
                  e.listener(i, o);
              }, n));
          },
          s = document.addEventListener ? "addEventListener" : "attachEvent",
          a = document.removeEventListener
            ? "removeEventListener"
            : "detachEvent",
          u = eventjs.getEventSupport("mousewheel")
            ? "mousewheel"
            : "DOMMouseScroll";
        return e.target[s](u, i, !1), o;
      }),
      (eventjs.Gesture = eventjs.Gesture || {}),
      (eventjs.Gesture._gestureHandlers =
        eventjs.Gesture._gestureHandlers || {}),
      (eventjs.Gesture._gestureHandlers.wheel = e.wheel),
      e
    );
  })(eventjs.proxy)),
  "undefined" == typeof Event)
)
  var Event = {};
"undefined" == typeof Event.proxy && (Event.proxy = {}),
  (Event.proxy = (function (e) {
    "use strict";
    return (
      (e.orientation = function (e) {
        var t = {
            gesture: "orientationchange",
            previous: null,
            current: window.orientation,
            target: e.target,
            listener: e.listener,
            remove: function () {
              window.removeEventListener("orientationchange", n, !1);
            },
          },
          n = function (n) {
            return (
              (t.previous = t.current),
              (t.current = window.orientation),
              null !== t.previous && t.previous != t.current
                ? void e.listener(n, t)
                : void 0
            );
          };
        return (
          window.DeviceOrientationEvent &&
            window.addEventListener("orientationchange", n, !1),
          t
        );
      }),
      (Event.Gesture = Event.Gesture || {}),
      (Event.Gesture._gestureHandlers = Event.Gesture._gestureHandlers || {}),
      (Event.Gesture._gestureHandlers.orientation = e.orientation),
      e
    );
  })(Event.proxy));
!(function () {
  function e(e, t) {
    if (this.__eventListeners[e]) {
      var n = this.__eventListeners[e];
      t ? (n[n.indexOf(t)] = !1) : fabric.util.array.fill(n, !1);
    }
  }
  function t(e, t) {
    if (
      (this.__eventListeners || (this.__eventListeners = {}),
      1 === arguments.length)
    )
      for (var n in e) this.on(n, e[n]);
    else
      this.__eventListeners[e] || (this.__eventListeners[e] = []),
        this.__eventListeners[e].push(t);
    return this;
  }
  function n(e, t) {
    var n = function () {
      t.apply(this, arguments), this.off(e, n);
    }.bind(this);
    this.on(e, n);
  }
  function r(e, t) {
    if (1 === arguments.length) for (var r in e) n.call(this, r, e[r]);
    else n.call(this, e, t);
    return this;
  }
  function o(t, n) {
    if (!this.__eventListeners) return this;
    if (0 === arguments.length)
      for (t in this.__eventListeners) e.call(this, t);
    else if (1 === arguments.length && "object" == typeof arguments[0])
      for (var r in t) e.call(this, r, t[r]);
    else e.call(this, t, n);
    return this;
  }
  function i(e, t) {
    if (!this.__eventListeners) return this;
    var n = this.__eventListeners[e];
    if (!n) return this;
    for (var r = 0, o = n.length; o > r; r++) n[r] && n[r].call(this, t || {});
    return (
      (this.__eventListeners[e] = n.filter(function (e) {
        return e !== !1;
      })),
      this
    );
  }
  fabric.Observable = { fire: i, on: t, once: r, off: o };
})();
fabric.Collection = {
  _objects: [],
  add: function () {
    if (
      (this._objects.push.apply(this._objects, arguments), this._onObjectAdded)
    )
      for (var e = 0, t = arguments.length; t > e; e++)
        this._onObjectAdded(arguments[e]);
    return this.renderOnAddRemove && this.requestRenderAll(), this;
  },
  insertAt: function (e, t, n) {
    var r = this._objects;
    return (
      n ? (r[t] = e) : r.splice(t, 0, e),
      this._onObjectAdded && this._onObjectAdded(e),
      this.renderOnAddRemove && this.requestRenderAll(),
      this
    );
  },
  remove: function () {
    for (
      var e, t = this._objects, n = !1, r = 0, o = arguments.length;
      o > r;
      r++
    )
      (e = t.indexOf(arguments[r])),
        -1 !== e &&
          ((n = !0),
          t.splice(e, 1),
          this._onObjectRemoved && this._onObjectRemoved(arguments[r]));
    return this.renderOnAddRemove && n && this.requestRenderAll(), this;
  },
  forEachObject: function (e, t) {
    for (var n = this.getObjects(), r = 0, o = n.length; o > r; r++)
      e.call(t, n[r], r, n);
    return this;
  },
  getObjects: function (e) {
    return "undefined" == typeof e
      ? this._objects.concat()
      : this._objects.filter(function (t) {
          return t.type === e;
        });
  },
  item: function (e) {
    return this._objects[e];
  },
  isEmpty: function () {
    return 0 === this._objects.length;
  },
  size: function () {
    return this._objects.length;
  },
  contains: function (e, t) {
    return this._objects.indexOf(e) > -1
      ? !0
      : t
      ? this._objects.some(function (t) {
          return "function" == typeof t.contains && t.contains(e, !0);
        })
      : !1;
  },
  complexity: function () {
    return this._objects.reduce(function (e, t) {
      return (e += t.complexity ? t.complexity() : 0);
    }, 0);
  },
};
fabric.CommonMethods = {
  _setOptions: function (e) {
    for (var t in e) this.set(t, e[t]);
  },
  _initGradient: function (e, t) {
    !e ||
      !e.colorStops ||
      e instanceof fabric.Gradient ||
      this.set(t, new fabric.Gradient(e));
  },
  _initPattern: function (e, t, n) {
    !e || !e.source || e instanceof fabric.Pattern
      ? n && n()
      : this.set(t, new fabric.Pattern(e, n));
  },
  _setObject: function (e) {
    for (var t in e) this._set(t, e[t]);
  },
  set: function (e, t) {
    return "object" == typeof e ? this._setObject(e) : this._set(e, t), this;
  },
  _set: function (e, t) {
    this[e] = t;
  },
  toggle: function (e) {
    var t = this.get(e);
    return "boolean" == typeof t && this.set(e, !t), this;
  },
  get: function (e) {
    return this[e];
  },
};
!(function (e) {
  var t = Math.sqrt,
    n = Math.atan2,
    r = Math.pow,
    i = Math.PI / 180,
    o = Math.PI / 2;
  fabric.util = {
    cos: function (e) {
      if (0 === e) return 1;
      0 > e && (e = -e);
      var t = e / o;
      switch (t) {
        case 1:
        case 3:
          return 0;
        case 2:
          return -1;
      }
      return Math.cos(e);
    },
    sin: function (e) {
      if (0 === e) return 0;
      var t = e / o,
        n = 1;
      switch ((0 > e && (n = -1), t)) {
        case 1:
          return n;
        case 2:
          return 0;
        case 3:
          return -n;
      }
      return Math.sin(e);
    },
    removeFromArray: function (e, t) {
      var n = e.indexOf(t);
      return -1 !== n && e.splice(n, 1), e;
    },
    getRandomInt: function (e, t) {
      return Math.floor(Math.random() * (t - e + 1)) + e;
    },
    degreesToRadians: function (e) {
      return e * i;
    },
    radiansToDegrees: function (e) {
      return e / i;
    },
    rotatePoint: function (e, t, n) {
      var r = new fabric.Point(e.x - t.x, e.y - t.y),
        i = fabric.util.rotateVector(r, n);
      return new fabric.Point(i.x, i.y).addEquals(t);
    },
    rotateVector: function (e, t) {
      var n = fabric.util.sin(t),
        r = fabric.util.cos(t),
        i = e.x * r - e.y * n,
        o = e.x * n + e.y * r;
      return { x: i, y: o };
    },
    createVector: function (e, t) {
      return new fabric.Point(t.x - e.x, t.y - e.y);
    },
    calcAngleBetweenVectors: function (e, t) {
      return Math.acos(
        (e.x * t.x + e.y * t.y) / (Math.hypot(e.x, e.y) * Math.hypot(t.x, t.y))
      );
    },
    getHatVector: function (e) {
      return new fabric.Point(e.x, e.y).multiply(1 / Math.hypot(e.x, e.y));
    },
    getBisector: function (e, t, n) {
      var r = fabric.util.createVector(e, t),
        i = fabric.util.createVector(e, n),
        o = fabric.util.calcAngleBetweenVectors(r, i),
        a = fabric.util.calcAngleBetweenVectors(
          fabric.util.rotateVector(r, o),
          i
        ),
        s = (o * (0 === a ? 1 : -1)) / 2;
      return {
        vector: fabric.util.getHatVector(fabric.util.rotateVector(r, s)),
        angle: o,
      };
    },
    projectStrokeOnPoints: function (e, t, n) {
      var r = [],
        i = t.strokeWidth / 2,
        o = t.strokeUniform
          ? new fabric.Point(1 / t.scaleX, 1 / t.scaleY)
          : new fabric.Point(1, 1),
        a = function (e) {
          var t = i / Math.hypot(e.x, e.y);
          return new fabric.Point(e.x * t * o.x, e.y * t * o.y);
        };
      return e.length <= 1
        ? r
        : (e.forEach(function (s, u) {
            var c,
              f,
              d = new fabric.Point(s.x, s.y);
            0 === u
              ? ((f = e[u + 1]),
                (c = n
                  ? a(fabric.util.createVector(f, d)).addEquals(d)
                  : e[e.length - 1]))
              : u === e.length - 1
              ? ((c = e[u - 1]),
                (f = n ? a(fabric.util.createVector(c, d)).addEquals(d) : e[0]))
              : ((c = e[u - 1]), (f = e[u + 1]));
            var l,
              v,
              p = fabric.util.getBisector(d, c, f),
              g = p.vector,
              m = p.angle;
            return "miter" === t.strokeLineJoin &&
              ((l = -i / Math.sin(m / 2)),
              (v = new fabric.Point(g.x * l * o.x, g.y * l * o.y)),
              Math.hypot(v.x, v.y) / i <= t.strokeMiterLimit)
              ? (r.push(d.add(v)), void r.push(d.subtract(v)))
              : ((l = -i * Math.SQRT2),
                (v = new fabric.Point(g.x * l * o.x, g.y * l * o.y)),
                r.push(d.add(v)),
                void r.push(d.subtract(v)));
          }),
          r);
    },
    transformPoint: function (e, t, n) {
      return n
        ? new fabric.Point(t[0] * e.x + t[2] * e.y, t[1] * e.x + t[3] * e.y)
        : new fabric.Point(
            t[0] * e.x + t[2] * e.y + t[4],
            t[1] * e.x + t[3] * e.y + t[5]
          );
    },
    makeBoundingBoxFromPoints: function (e, t) {
      if (t)
        for (var n = 0; n < e.length; n++)
          e[n] = fabric.util.transformPoint(e[n], t);
      var r = [e[0].x, e[1].x, e[2].x, e[3].x],
        i = fabric.util.array.min(r),
        o = fabric.util.array.max(r),
        a = o - i,
        s = [e[0].y, e[1].y, e[2].y, e[3].y],
        u = fabric.util.array.min(s),
        c = fabric.util.array.max(s),
        f = c - u;
      return { left: i, top: u, width: a, height: f };
    },
    invertTransform: function (e) {
      var t = 1 / (e[0] * e[3] - e[1] * e[2]),
        n = [t * e[3], -t * e[1], -t * e[2], t * e[0]],
        r = fabric.util.transformPoint({ x: e[4], y: e[5] }, n, !0);
      return (n[4] = -r.x), (n[5] = -r.y), n;
    },
    toFixed: function (e, t) {
      return parseFloat(Number(e).toFixed(t));
    },
    parseUnit: function (e, t) {
      var n = /\D{0,2}$/.exec(e),
        r = parseFloat(e);
      switch ((t || (t = fabric.Text.DEFAULT_SVG_FONT_SIZE), n[0])) {
        case "mm":
          return (r * fabric.DPI) / 25.4;
        case "cm":
          return (r * fabric.DPI) / 2.54;
        case "in":
          return r * fabric.DPI;
        case "pt":
          return (r * fabric.DPI) / 72;
        case "pc":
          return ((r * fabric.DPI) / 72) * 12;
        case "em":
          return r * t;
        default:
          return r;
      }
    },
    falseFunction: function () {
      return !1;
    },
    getKlass: function (e, t) {
      return (
        (e = fabric.util.string.camelize(
          e.charAt(0).toUpperCase() + e.slice(1)
        )),
        fabric.util.resolveNamespace(t)[e]
      );
    },
    getSvgAttributes: function (e) {
      var t = ["instantiated_by_use", "style", "id", "class"];
      switch (e) {
        case "linearGradient":
          t = t.concat([
            "x1",
            "y1",
            "x2",
            "y2",
            "gradientUnits",
            "gradientTransform",
          ]);
          break;
        case "radialGradient":
          t = t.concat([
            "gradientUnits",
            "gradientTransform",
            "cx",
            "cy",
            "r",
            "fx",
            "fy",
            "fr",
          ]);
          break;
        case "stop":
          t = t.concat(["offset", "stop-color", "stop-opacity"]);
      }
      return t;
    },
    resolveNamespace: function (t) {
      if (!t) return fabric;
      var n,
        r = t.split("."),
        i = r.length,
        o = e || fabric.window;
      for (n = 0; i > n; ++n) o = o[r[n]];
      return o;
    },
    loadImage: function (e, t, n, r) {
      if (!e) return void (t && t.call(n, e));
      var i = fabric.util.createImage(),
        o = function () {
          t && t.call(n, i, !1), (i = i.onload = i.onerror = null);
        };
      (i.onload = o),
        (i.onerror = function () {
          fabric.log("Error loading " + i.src),
            t && t.call(n, null, !0),
            (i = i.onload = i.onerror = null);
        }),
        0 !== e.indexOf("data") &&
          void 0 !== r &&
          null !== r &&
          (i.crossOrigin = r),
        "data:image/svg" === e.substring(0, 14) &&
          ((i.onload = null), fabric.util.loadImageInDom(i, o)),
        (i.src = e);
    },
    loadImageInDom: function (e, t) {
      var n = fabric.document.createElement("div");
      (n.style.width = n.style.height = "1px"),
        (n.style.left = n.style.top = "-100%"),
        (n.style.position = "absolute"),
        n.appendChild(e),
        fabric.document.querySelector("body").appendChild(n),
        (e.onload = function () {
          t(), n.parentNode.removeChild(n), (n = null);
        });
    },
    enlivenObjects: function (e, t, n, r) {
      function i() {
        ++a === s &&
          t &&
          t(
            o.filter(function (e) {
              return e;
            })
          );
      }
      e = e || [];
      var o = [],
        a = 0,
        s = e.length;
      return s
        ? void e.forEach(function (e, t) {
            if (!e || !e.type) return void i();
            var a = fabric.util.getKlass(e.type, n);
            a.fromObject(e, function (n, a) {
              a || (o[t] = n), r && r(e, n, a), i();
            });
          })
        : void (t && t(o));
    },
    enlivenObjectEnlivables: function (e, t, n) {
      var r = fabric.Object.ENLIVEN_PROPS.filter(function (t) {
        return !!e[t];
      });
      fabric.util.enlivenObjects(
        r.map(function (t) {
          return e[t];
        }),
        function (e) {
          var i = {};
          r.forEach(function (n, r) {
            (i[n] = e[r]), t && (t[n] = e[r]);
          }),
            n && n(i);
        }
      );
    },
    enlivenPatterns: function (e, t) {
      function n() {
        ++i === o && t && t(r);
      }
      e = e || [];
      var r = [],
        i = 0,
        o = e.length;
      return o
        ? void e.forEach(function (e, t) {
            e && e.source
              ? new fabric.Pattern(e, function (e) {
                  (r[t] = e), n();
                })
              : ((r[t] = e), n());
          })
        : void (t && t(r));
    },
    groupSVGElements: function (e, t, n) {
      var r;
      return e && 1 === e.length
        ? e[0]
        : (t &&
            (t.width && t.height
              ? (t.centerPoint = { x: t.width / 2, y: t.height / 2 })
              : (delete t.width, delete t.height)),
          (r = new fabric.Group(e, t)),
          "undefined" != typeof n && (r.sourcePath = n),
          r);
    },
    populateWithProperties: function (e, t, n) {
      if (n && Array.isArray(n))
        for (var r = 0, i = n.length; i > r; r++)
          n[r] in e && (t[n[r]] = e[n[r]]);
    },
    createCanvasElement: function () {
      return fabric.document.createElement("canvas");
    },
    copyCanvasElement: function (e) {
      var t = fabric.util.createCanvasElement();
      return (
        (t.width = e.width),
        (t.height = e.height),
        t.getContext("2d").drawImage(e, 0, 0),
        t
      );
    },
    toDataURL: function (e, t, n) {
      return e.toDataURL("image/" + t, n);
    },
    createImage: function () {
      return fabric.document.createElement("img");
    },
    multiplyTransformMatrices: function (e, t, n) {
      return [
        e[0] * t[0] + e[2] * t[1],
        e[1] * t[0] + e[3] * t[1],
        e[0] * t[2] + e[2] * t[3],
        e[1] * t[2] + e[3] * t[3],
        n ? 0 : e[0] * t[4] + e[2] * t[5] + e[4],
        n ? 0 : e[1] * t[4] + e[3] * t[5] + e[5],
      ];
    },
    qrDecompose: function (e) {
      var o = n(e[1], e[0]),
        a = r(e[0], 2) + r(e[1], 2),
        s = t(a),
        u = (e[0] * e[3] - e[2] * e[1]) / s,
        c = n(e[0] * e[2] + e[1] * e[3], a);
      return {
        angle: o / i,
        scaleX: s,
        scaleY: u,
        skewX: c / i,
        skewY: 0,
        translateX: e[4],
        translateY: e[5],
      };
    },
    calcRotateMatrix: function (e) {
      if (!e.angle) return fabric.iMatrix.concat();
      var t = fabric.util.degreesToRadians(e.angle),
        n = fabric.util.cos(t),
        r = fabric.util.sin(t);
      return [n, r, -r, n, 0, 0];
    },
    calcDimensionsMatrix: function (e) {
      var t = "undefined" == typeof e.scaleX ? 1 : e.scaleX,
        n = "undefined" == typeof e.scaleY ? 1 : e.scaleY,
        r = [e.flipX ? -t : t, 0, 0, e.flipY ? -n : n, 0, 0],
        i = fabric.util.multiplyTransformMatrices,
        o = fabric.util.degreesToRadians;
      return (
        e.skewX && (r = i(r, [1, 0, Math.tan(o(e.skewX)), 1], !0)),
        e.skewY && (r = i(r, [1, Math.tan(o(e.skewY)), 0, 1], !0)),
        r
      );
    },
    composeMatrix: function (e) {
      var t = [1, 0, 0, 1, e.translateX || 0, e.translateY || 0],
        n = fabric.util.multiplyTransformMatrices;
      return (
        e.angle && (t = n(t, fabric.util.calcRotateMatrix(e))),
        (1 !== e.scaleX ||
          1 !== e.scaleY ||
          e.skewX ||
          e.skewY ||
          e.flipX ||
          e.flipY) &&
          (t = n(t, fabric.util.calcDimensionsMatrix(e))),
        t
      );
    },
    resetObjectTransform: function (e) {
      (e.scaleX = 1),
        (e.scaleY = 1),
        (e.skewX = 0),
        (e.skewY = 0),
        (e.flipX = !1),
        (e.flipY = !1),
        e.rotate(0);
    },
    saveObjectTransform: function (e) {
      return {
        scaleX: e.scaleX,
        scaleY: e.scaleY,
        skewX: e.skewX,
        skewY: e.skewY,
        angle: e.angle,
        left: e.left,
        flipX: e.flipX,
        flipY: e.flipY,
        top: e.top,
      };
    },
    isTransparent: function (e, t, n, r) {
      r > 0 && (t > r ? (t -= r) : (t = 0), n > r ? (n -= r) : (n = 0));
      var i,
        o,
        a = !0,
        s = e.getImageData(t, n, 2 * r || 1, 2 * r || 1),
        u = s.data.length;
      for (i = 3; u > i && ((o = s.data[i]), (a = 0 >= o), a !== !1); i += 4);
      return (s = null), a;
    },
    parsePreserveAspectRatioAttribute: function (e) {
      var t,
        n = "meet",
        r = "Mid",
        i = "Mid",
        o = e.split(" ");
      return (
        o &&
          o.length &&
          ((n = o.pop()),
          "meet" !== n && "slice" !== n
            ? ((t = n), (n = "meet"))
            : o.length && (t = o.pop())),
        (r = "none" !== t ? t.slice(1, 4) : "none"),
        (i = "none" !== t ? t.slice(5, 8) : "none"),
        { meetOrSlice: n, alignX: r, alignY: i }
      );
    },
    clearFabricFontCache: function (e) {
      (e = (e || "").toLowerCase()),
        e
          ? fabric.charWidthsCache[e] && delete fabric.charWidthsCache[e]
          : (fabric.charWidthsCache = {});
    },
    limitDimsByArea: function (e, t) {
      var n = Math.sqrt(t * e),
        r = Math.floor(t / n);
      return { x: Math.floor(n), y: r };
    },
    capValue: function (e, t, n) {
      return Math.max(e, Math.min(t, n));
    },
    findScaleToFit: function (e, t) {
      return Math.min(t.width / e.width, t.height / e.height);
    },
    findScaleToCover: function (e, t) {
      return Math.max(t.width / e.width, t.height / e.height);
    },
    matrixToSVG: function (e) {
      return (
        "matrix(" +
        e
          .map(function (e) {
            return fabric.util.toFixed(e, fabric.Object.NUM_FRACTION_DIGITS);
          })
          .join(" ") +
        ")"
      );
    },
    removeTransformFromObject: function (e, t) {
      var n = fabric.util.invertTransform(t),
        r = fabric.util.multiplyTransformMatrices(n, e.calcOwnMatrix());
      fabric.util.applyTransformToObject(e, r);
    },
    addTransformToObject: function (e, t) {
      fabric.util.applyTransformToObject(
        e,
        fabric.util.multiplyTransformMatrices(t, e.calcOwnMatrix())
      );
    },
    applyTransformToObject: function (e, t) {
      var n = fabric.util.qrDecompose(t),
        r = new fabric.Point(n.translateX, n.translateY);
      (e.flipX = !1),
        (e.flipY = !1),
        e.set("scaleX", n.scaleX),
        e.set("scaleY", n.scaleY),
        (e.skewX = n.skewX),
        (e.skewY = n.skewY),
        (e.angle = n.angle),
        e.setPositionByOrigin(r, "center", "center");
    },
    sizeAfterTransform: function (e, t, n) {
      var r = e / 2,
        i = t / 2,
        o = [
          { x: -r, y: -i },
          { x: r, y: -i },
          { x: -r, y: i },
          { x: r, y: i },
        ],
        a = fabric.util.calcDimensionsMatrix(n),
        s = fabric.util.makeBoundingBoxFromPoints(o, a);
      return { x: s.width, y: s.height };
    },
    mergeClipPaths: function (e, t) {
      var n = e,
        r = t;
      n.inverted && !r.inverted && ((n = t), (r = e)),
        fabric.util.applyTransformToObject(
          r,
          fabric.util.multiplyTransformMatrices(
            fabric.util.invertTransform(n.calcTransformMatrix()),
            r.calcTransformMatrix()
          )
        );
      var i = n.inverted && r.inverted;
      return (
        i && (n.inverted = r.inverted = !1),
        new fabric.Group([n], { clipPath: r, inverted: i })
      );
    },
    hasStyleChanged: function (e, t, n) {
      return (
        (n = n || !1),
        e.fill !== t.fill ||
          e.stroke !== t.stroke ||
          e.strokeWidth !== t.strokeWidth ||
          e.fontSize !== t.fontSize ||
          e.fontFamily !== t.fontFamily ||
          e.fontWeight !== t.fontWeight ||
          e.fontStyle !== t.fontStyle ||
          e.deltaY !== t.deltaY ||
          (n &&
            (e.overline !== t.overline ||
              e.underline !== t.underline ||
              e.linethrough !== t.linethrough))
      );
    },
    stylesToArray: function (e, t) {
      for (
        var e = fabric.util.object.clone(e, !0),
          n = t.split("\n"),
          r = -1,
          i = {},
          o = [],
          a = 0;
        a < n.length;
        a++
      )
        if (e[a])
          for (var s = 0; s < n[a].length; s++) {
            r++;
            var u = e[a][s];
            if (u) {
              var c = fabric.util.hasStyleChanged(i, u, !0);
              c
                ? o.push({ start: r, end: r + 1, style: u })
                : o[o.length - 1].end++;
            }
            i = u || {};
          }
        else r += n[a].length;
      return o;
    },
    stylesFromArray: function (e, t) {
      if (!Array.isArray(e)) return e;
      for (
        var n = t.split("\n"), r = -1, i = 0, o = {}, a = 0;
        a < n.length;
        a++
      )
        for (var s = 0; s < n[a].length; s++)
          r++,
            e[i] &&
              e[i].start <= r &&
              r < e[i].end &&
              ((o[a] = o[a] || {}),
              (o[a][s] = Object.assign({}, e[i].style)),
              r === e[i].end - 1 && i++);
      return o;
    },
  };
})("undefined" != typeof exports ? exports : this);
!(function () {
  function e(e, t, n, r, i, o, a, s, u, c, f) {
    var l = fabric.util.cos(e),
      d = fabric.util.sin(e),
      v = fabric.util.cos(t),
      p = fabric.util.sin(t),
      g = n * i * v - r * o * p + a,
      m = r * i * v + n * o * p + s,
      h = c + u * (-n * i * d - r * o * l),
      y = f + u * (-r * i * d + n * o * l),
      b = g + u * (n * i * p + r * o * v),
      w = m + u * (r * i * p - n * o * v);
    return ["C", h, y, b, w, g, m];
  }
  function t(t, r, i, o, a, s, u) {
    var c = Math.PI,
      f = (u * c) / 180,
      l = fabric.util.sin(f),
      d = fabric.util.cos(f),
      v = 0,
      p = 0;
    (i = Math.abs(i)), (o = Math.abs(o));
    var g = -d * t * 0.5 - l * r * 0.5,
      m = -d * r * 0.5 + l * t * 0.5,
      h = i * i,
      y = o * o,
      b = m * m,
      w = g * g,
      x = h * y - h * b - y * w,
      j = 0;
    if (0 > x) {
      var P = Math.sqrt(1 - x / (h * y));
      (i *= P), (o *= P);
    } else j = (a === s ? -1 : 1) * Math.sqrt(x / (h * b + y * w));
    var M = (j * i * m) / o,
      E = (-j * o * g) / i,
      T = d * M - l * E + 0.5 * t,
      k = l * M + d * E + 0.5 * r,
      L = n(1, 0, (g - M) / i, (m - E) / o),
      _ = n((g - M) / i, (m - E) / o, (-g - M) / i, (-m - E) / o);
    0 === s && _ > 0 ? (_ -= 2 * c) : 1 === s && 0 > _ && (_ += 2 * c);
    for (
      var C = Math.ceil(Math.abs((_ / c) * 2)),
        D = [],
        O = _ / C,
        S = ((8 / 3) * Math.sin(O / 4) * Math.sin(O / 4)) / Math.sin(O / 2),
        G = L + O,
        Y = 0;
      C > Y;
      Y++
    )
      (D[Y] = e(L, G, d, l, i, o, T, k, S, v, p)),
        (v = D[Y][5]),
        (p = D[Y][6]),
        (L = G),
        (G += O);
    return D;
  }
  function n(e, t, n, r) {
    var i = Math.atan2(t, e),
      o = Math.atan2(r, n);
    return o >= i ? o - i : 2 * Math.PI - (i - o);
  }
  function r(e, t, n, r, i, o, a, s) {
    var u;
    if (
      fabric.cachesBoundsOfCurve &&
      ((u = E.call(arguments)), fabric.boundsOfCurveCache[u])
    )
      return fabric.boundsOfCurveCache[u];
    var c,
      f,
      l,
      d,
      v,
      p,
      g,
      m,
      h = Math.sqrt,
      y = Math.min,
      b = Math.max,
      w = Math.abs,
      x = [],
      j = [[], []];
    (f = 6 * e - 12 * n + 6 * i),
      (c = -3 * e + 9 * n - 9 * i + 3 * a),
      (l = 3 * n - 3 * e);
    for (var P = 0; 2 > P; ++P)
      if (
        (P > 0 &&
          ((f = 6 * t - 12 * r + 6 * o),
          (c = -3 * t + 9 * r - 9 * o + 3 * s),
          (l = 3 * r - 3 * t)),
        w(c) < 1e-12)
      ) {
        if (w(f) < 1e-12) continue;
        (d = -l / f), d > 0 && 1 > d && x.push(d);
      } else
        (g = f * f - 4 * l * c),
          0 > g ||
            ((m = h(g)),
            (v = (-f + m) / (2 * c)),
            v > 0 && 1 > v && x.push(v),
            (p = (-f - m) / (2 * c)),
            p > 0 && 1 > p && x.push(p));
    for (var M, T, k, L = x.length, _ = L; L--; )
      (d = x[L]),
        (k = 1 - d),
        (M =
          k * k * k * e +
          3 * k * k * d * n +
          3 * k * d * d * i +
          d * d * d * a),
        (j[0][L] = M),
        (T =
          k * k * k * t +
          3 * k * k * d * r +
          3 * k * d * d * o +
          d * d * d * s),
        (j[1][L] = T);
    (j[0][_] = e), (j[1][_] = t), (j[0][_ + 1] = a), (j[1][_ + 1] = s);
    var C = [
      { x: y.apply(null, j[0]), y: y.apply(null, j[1]) },
      { x: b.apply(null, j[0]), y: b.apply(null, j[1]) },
    ];
    return fabric.cachesBoundsOfCurve && (fabric.boundsOfCurveCache[u] = C), C;
  }
  function i(e, n, r) {
    for (
      var i = r[1],
        o = r[2],
        a = r[3],
        s = r[4],
        u = r[5],
        c = r[6],
        f = r[7],
        l = t(c - e, f - n, i, o, s, u, a),
        d = 0,
        v = l.length;
      v > d;
      d++
    )
      (l[d][1] += e),
        (l[d][2] += n),
        (l[d][3] += e),
        (l[d][4] += n),
        (l[d][5] += e),
        (l[d][6] += n);
    return l;
  }
  function o(e) {
    var t,
      n,
      r,
      o,
      a,
      s,
      u = 0,
      c = 0,
      f = e.length,
      l = 0,
      d = 0,
      v = [];
    for (n = 0; f > n; ++n) {
      switch (((r = !1), (t = e[n].slice(0)), t[0])) {
        case "l":
          (t[0] = "L"), (t[1] += u), (t[2] += c);
        case "L":
          (u = t[1]), (c = t[2]);
          break;
        case "h":
          t[1] += u;
        case "H":
          (t[0] = "L"), (t[2] = c), (u = t[1]);
          break;
        case "v":
          t[1] += c;
        case "V":
          (t[0] = "L"), (c = t[1]), (t[1] = u), (t[2] = c);
          break;
        case "m":
          (t[0] = "M"), (t[1] += u), (t[2] += c);
        case "M":
          (u = t[1]), (c = t[2]), (l = t[1]), (d = t[2]);
          break;
        case "c":
          (t[0] = "C"),
            (t[1] += u),
            (t[2] += c),
            (t[3] += u),
            (t[4] += c),
            (t[5] += u),
            (t[6] += c);
        case "C":
          (a = t[3]), (s = t[4]), (u = t[5]), (c = t[6]);
          break;
        case "s":
          (t[0] = "S"), (t[1] += u), (t[2] += c), (t[3] += u), (t[4] += c);
        case "S":
          "C" === o ? ((a = 2 * u - a), (s = 2 * c - s)) : ((a = u), (s = c)),
            (u = t[3]),
            (c = t[4]),
            (t[0] = "C"),
            (t[5] = t[3]),
            (t[6] = t[4]),
            (t[3] = t[1]),
            (t[4] = t[2]),
            (t[1] = a),
            (t[2] = s),
            (a = t[3]),
            (s = t[4]);
          break;
        case "q":
          (t[0] = "Q"), (t[1] += u), (t[2] += c), (t[3] += u), (t[4] += c);
        case "Q":
          (a = t[1]), (s = t[2]), (u = t[3]), (c = t[4]);
          break;
        case "t":
          (t[0] = "T"), (t[1] += u), (t[2] += c);
        case "T":
          "Q" === o ? ((a = 2 * u - a), (s = 2 * c - s)) : ((a = u), (s = c)),
            (t[0] = "Q"),
            (u = t[1]),
            (c = t[2]),
            (t[1] = a),
            (t[2] = s),
            (t[3] = u),
            (t[4] = c);
          break;
        case "a":
          (t[0] = "A"), (t[6] += u), (t[7] += c);
        case "A":
          (r = !0), (v = v.concat(i(u, c, t))), (u = t[6]), (c = t[7]);
          break;
        case "z":
        case "Z":
          (u = l), (c = d);
      }
      r || v.push(t), (o = t[0]);
    }
    return v;
  }
  function a(e, t, n, r) {
    return Math.sqrt((n - e) * (n - e) + (r - t) * (r - t));
  }
  function s(e) {
    return e * e * e;
  }
  function u(e) {
    return 3 * e * e * (1 - e);
  }
  function c(e) {
    return 3 * e * (1 - e) * (1 - e);
  }
  function f(e) {
    return (1 - e) * (1 - e) * (1 - e);
  }
  function l(e, t, n, r, i, o, a, l) {
    return function (d) {
      var v = s(d),
        p = u(d),
        g = c(d),
        m = f(d);
      return {
        x: a * v + i * p + n * g + e * m,
        y: l * v + o * p + r * g + t * m,
      };
    };
  }
  function d(e, t, n, r, i, o, a, s) {
    return function (u) {
      var c = 1 - u,
        f = 3 * c * c * (n - e) + 6 * c * u * (i - n) + 3 * u * u * (a - i),
        l = 3 * c * c * (r - t) + 6 * c * u * (o - r) + 3 * u * u * (s - o);
      return Math.atan2(l, f);
    };
  }
  function v(e) {
    return e * e;
  }
  function p(e) {
    return 2 * e * (1 - e);
  }
  function g(e) {
    return (1 - e) * (1 - e);
  }
  function m(e, t, n, r, i, o) {
    return function (a) {
      var s = v(a),
        u = p(a),
        c = g(a);
      return { x: i * s + n * u + e * c, y: o * s + r * u + t * c };
    };
  }
  function h(e, t, n, r, i, o) {
    return function (a) {
      var s = 1 - a,
        u = 2 * s * (n - e) + 2 * a * (i - n),
        c = 2 * s * (r - t) + 2 * a * (o - r);
      return Math.atan2(c, u);
    };
  }
  function y(e, t, n) {
    var r,
      i,
      o = { x: t, y: n },
      s = 0;
    for (i = 1; 100 >= i; i += 1)
      (r = e(i / 100)), (s += a(o.x, o.y, r.x, r.y)), (o = r);
    return s;
  }
  function b(e, t) {
    for (
      var n,
        r,
        i,
        o = 0,
        s = 0,
        u = e.iterator,
        c = { x: e.x, y: e.y },
        f = 0.01,
        l = e.angleFinder;
      t > s && f > 1e-4;

    )
      (n = u(o)),
        (i = o),
        (r = a(c.x, c.y, n.x, n.y)),
        r + s > t ? ((o -= f), (f /= 2)) : ((c = n), (o += f), (s += r));
    return (n.angle = l(i)), n;
  }
  function w(e) {
    for (
      var t,
        n,
        r,
        i,
        o = 0,
        s = e.length,
        u = 0,
        c = 0,
        f = 0,
        v = 0,
        p = [],
        g = 0;
      s > g;
      g++
    ) {
      switch (((t = e[g]), (r = { x: u, y: c, command: t[0] }), t[0])) {
        case "M":
          (r.length = 0), (f = u = t[1]), (v = c = t[2]);
          break;
        case "L":
          (r.length = a(u, c, t[1], t[2])), (u = t[1]), (c = t[2]);
          break;
        case "C":
          (n = l(u, c, t[1], t[2], t[3], t[4], t[5], t[6])),
            (i = d(u, c, t[1], t[2], t[3], t[4], t[5], t[6])),
            (r.iterator = n),
            (r.angleFinder = i),
            (r.length = y(n, u, c)),
            (u = t[5]),
            (c = t[6]);
          break;
        case "Q":
          (n = m(u, c, t[1], t[2], t[3], t[4])),
            (i = h(u, c, t[1], t[2], t[3], t[4])),
            (r.iterator = n),
            (r.angleFinder = i),
            (r.length = y(n, u, c)),
            (u = t[3]),
            (c = t[4]);
          break;
        case "Z":
        case "z":
          (r.destX = f),
            (r.destY = v),
            (r.length = a(u, c, f, v)),
            (u = f),
            (c = v);
      }
      (o += r.length), p.push(r);
    }
    return p.push({ length: o, x: u, y: c }), p;
  }
  function x(e, t, n) {
    n || (n = w(e));
    for (var r = 0; t - n[r].length > 0 && r < n.length - 2; )
      (t -= n[r].length), r++;
    var i,
      o = n[r],
      a = t / o.length,
      s = o.command,
      u = e[r];
    switch (s) {
      case "M":
        return { x: o.x, y: o.y, angle: 0 };
      case "Z":
      case "z":
        return (
          (i = new fabric.Point(o.x, o.y).lerp(
            new fabric.Point(o.destX, o.destY),
            a
          )),
          (i.angle = Math.atan2(o.destY - o.y, o.destX - o.x)),
          i
        );
      case "L":
        return (
          (i = new fabric.Point(o.x, o.y).lerp(
            new fabric.Point(u[1], u[2]),
            a
          )),
          (i.angle = Math.atan2(u[2] - o.y, u[1] - o.x)),
          i
        );
      case "C":
        return b(o, t);
      case "Q":
        return b(o, t);
    }
  }
  function j(e) {
    var t,
      n,
      r,
      i,
      o,
      a = [],
      s = [],
      u = fabric.rePathCommand,
      c = "[-+]?(?:\\d*\\.\\d+|\\d+\\.?)(?:[eE][-+]?\\d+)?\\s*",
      f = "(" + c + ")" + fabric.commaWsp,
      l = "([01])" + fabric.commaWsp + "?",
      d = f + "?" + f + "?" + f + l + l + f + "?(" + c + ")",
      v = new RegExp(d, "g");
    if (!e || !e.match) return a;
    o = e.match(/[mzlhvcsqta][^mzlhvcsqta]*/gi);
    for (var p, g = 0, m = o.length; m > g; g++) {
      (t = o[g]), (i = t.slice(1).trim()), (s.length = 0);
      var h = t.charAt(0);
      if (((p = [h]), "a" === h.toLowerCase()))
        for (var y; (y = v.exec(i)); )
          for (var b = 1; b < y.length; b++) s.push(y[b]);
      else for (; (r = u.exec(i)); ) s.push(r[0]);
      for (var b = 0, w = s.length; w > b; b++)
        (n = parseFloat(s[b])), isNaN(n) || p.push(n);
      var x = T[h.toLowerCase()],
        j = k[h] || h;
      if (p.length - 1 > x)
        for (var P = 1, M = p.length; M > P; P += x)
          a.push([h].concat(p.slice(P, P + x))), (h = j);
      else a.push(p);
    }
    return a;
  }
  function P(e, t) {
    var n,
      r = [],
      i = new fabric.Point(e[0].x, e[0].y),
      o = new fabric.Point(e[1].x, e[1].y),
      a = e.length,
      s = 1,
      u = 0,
      c = a > 2;
    for (
      t = t || 0,
        c &&
          ((s = e[2].x < o.x ? -1 : e[2].x === o.x ? 0 : 1),
          (u = e[2].y < o.y ? -1 : e[2].y === o.y ? 0 : 1)),
        r.push(["M", i.x - s * t, i.y - u * t]),
        n = 1;
      a > n;
      n++
    ) {
      if (!i.eq(o)) {
        var f = i.midPointFrom(o);
        r.push(["Q", i.x, i.y, f.x, f.y]);
      }
      (i = e[n]), n + 1 < e.length && (o = e[n + 1]);
    }
    return (
      c &&
        ((s = i.x > e[n - 2].x ? 1 : i.x === e[n - 2].x ? 0 : -1),
        (u = i.y > e[n - 2].y ? 1 : i.y === e[n - 2].y ? 0 : -1)),
      r.push(["L", i.x + s * t, i.y + u * t]),
      r
    );
  }
  function M(e, t, n) {
    return (
      n &&
        (t = fabric.util.multiplyTransformMatrices(t, [
          1,
          0,
          0,
          1,
          -n.x,
          -n.y,
        ])),
      e.map(function (e) {
        for (var n = e.slice(0), r = {}, i = 1; i < e.length - 1; i += 2)
          (r.x = e[i]),
            (r.y = e[i + 1]),
            (r = fabric.util.transformPoint(r, t)),
            (n[i] = r.x),
            (n[i + 1] = r.y);
        return n;
      })
    );
  }
  var E = Array.prototype.join,
    T = { m: 2, l: 2, h: 1, v: 1, c: 6, s: 4, q: 4, t: 2, a: 7 },
    k = { m: "l", M: "L" };
  (fabric.util.joinPath = function (e) {
    return e
      .map(function (e) {
        return e.join(" ");
      })
      .join(" ");
  }),
    (fabric.util.parsePath = j),
    (fabric.util.makePathSimpler = o),
    (fabric.util.getSmoothPathFromPoints = P),
    (fabric.util.getPathSegmentsInfo = w),
    (fabric.util.getBoundsOfCurve = r),
    (fabric.util.getPointOnPath = x),
    (fabric.util.transformPath = M);
})();
!(function () {
  function e(e, t) {
    for (var n = o.call(arguments, 2), r = [], i = 0, a = e.length; a > i; i++)
      r[i] = n.length ? e[i][t].apply(e[i], n) : e[i][t].call(e[i]);
    return r;
  }
  function t(e, t) {
    return i(e, t, function (e, t) {
      return e >= t;
    });
  }
  function n(e, t) {
    return i(e, t, function (e, t) {
      return t > e;
    });
  }
  function r(e, t) {
    for (var n = e.length; n--; ) e[n] = t;
    return e;
  }
  function i(e, t, n) {
    if (e && 0 !== e.length) {
      var r = e.length - 1,
        i = t ? e[r][t] : e[r];
      if (t) for (; r--; ) n(e[r][t], i) && (i = e[r][t]);
      else for (; r--; ) n(e[r], i) && (i = e[r]);
      return i;
    }
  }
  var o = Array.prototype.slice;
  fabric.util.array = { fill: r, invoke: e, min: n, max: t };
})();
!(function () {
  function e(t, n, r) {
    if (r)
      if (!fabric.isLikelyNode && n instanceof Element) t = n;
      else if (n instanceof Array) {
        t = [];
        for (var i = 0, o = n.length; o > i; i++) t[i] = e({}, n[i], r);
      } else if (n && "object" == typeof n)
        for (var a in n)
          "canvas" === a || "group" === a
            ? (t[a] = null)
            : n.hasOwnProperty(a) && (t[a] = e({}, n[a], r));
      else t = n;
    else for (var a in n) t[a] = n[a];
    return t;
  }
  function t(t, n) {
    return e({}, t, n);
  }
  (fabric.util.object = { extend: e, clone: t }),
    fabric.util.object.extend(fabric.util, fabric.Observable);
})();
!(function () {
  function e(e) {
    return e.replace(/-+(.)?/g, function (e, t) {
      return t ? t.toUpperCase() : "";
    });
  }
  function t(e, t) {
    return (
      e.charAt(0).toUpperCase() + (t ? e.slice(1) : e.slice(1).toLowerCase())
    );
  }
  function n(e) {
    return e
      .replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&apos;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }
  function r(e) {
    var t,
      n = 0,
      r = [];
    for (n = 0, t; n < e.length; n++) (t = i(e, n)) !== !1 && r.push(t);
    return r;
  }
  function i(e, t) {
    var n = e.charCodeAt(t);
    if (isNaN(n)) return "";
    if (55296 > n || n > 57343) return e.charAt(t);
    if (n >= 55296 && 56319 >= n) {
      if (e.length <= t + 1)
        throw "High surrogate without following low surrogate";
      var r = e.charCodeAt(t + 1);
      if (56320 > r || r > 57343)
        throw "High surrogate without following low surrogate";
      return e.charAt(t) + e.charAt(t + 1);
    }
    if (0 === t) throw "Low surrogate without preceding high surrogate";
    var i = e.charCodeAt(t - 1);
    if (55296 > i || i > 56319)
      throw "Low surrogate without preceding high surrogate";
    return !1;
  }
  fabric.util.string = {
    camelize: e,
    capitalize: t,
    escapeXml: n,
    graphemeSplit: r,
  };
})();
!(function () {
  function e() {}
  function t(e) {
    for (var t = null, n = this; n.constructor.superclass; ) {
      var i = n.constructor.superclass.prototype[e];
      if (n[e] !== i) {
        t = i;
        break;
      }
      n = n.constructor.superclass.prototype;
    }
    return t
      ? arguments.length > 1
        ? t.apply(this, r.call(arguments, 1))
        : t.call(this)
      : console.log(
          "tried to callSuper " + e + ", method not found in prototype chain",
          this
        );
  }
  function n() {
    function n() {
      this.initialize.apply(this, arguments);
    }
    var o = null,
      s = r.call(arguments, 0);
    "function" == typeof s[0] && (o = s.shift()),
      (n.superclass = o),
      (n.subclasses = []),
      o &&
        ((e.prototype = o.prototype),
        (n.prototype = new e()),
        o.subclasses.push(n));
    for (var u = 0, c = s.length; c > u; u++) a(n, s[u], o);
    return (
      n.prototype.initialize || (n.prototype.initialize = i),
      (n.prototype.constructor = n),
      (n.prototype.callSuper = t),
      n
    );
  }
  var r = Array.prototype.slice,
    i = function () {},
    o = (function () {
      for (var e in { toString: 1 }) if ("toString" === e) return !1;
      return !0;
    })(),
    a = function (e, t, n) {
      for (var r in t)
        (e.prototype[r] =
          r in e.prototype &&
          "function" == typeof e.prototype[r] &&
          (t[r] + "").indexOf("callSuper") > -1
            ? (function (e) {
                return function () {
                  var r = this.constructor.superclass;
                  this.constructor.superclass = n;
                  var i = t[e].apply(this, arguments);
                  return (
                    (this.constructor.superclass = r),
                    "initialize" !== e ? i : void 0
                  );
                };
              })(r)
            : t[r]),
          o &&
            (t.toString !== Object.prototype.toString &&
              (e.prototype.toString = t.toString),
            t.valueOf !== Object.prototype.valueOf &&
              (e.prototype.valueOf = t.valueOf));
    };
  fabric.util.createClass = n;
})();
!(function () {
  function e(e) {
    var t = e.changedTouches;
    return t && t[0] ? t[0] : e;
  }
  var t = !!fabric.document.createElement("div").attachEvent,
    n = ["touchstart", "touchmove", "touchend"];
  (fabric.util.addListener = function (e, n, r, i) {
    e && e.addEventListener(n, r, t ? !1 : i);
  }),
    (fabric.util.removeListener = function (e, n, r, i) {
      e && e.removeEventListener(n, r, t ? !1 : i);
    }),
    (fabric.util.getPointer = function (t) {
      var n = t.target,
        r = fabric.util.getScrollLeftTop(n),
        i = e(t);
      return { x: i.clientX + r.left, y: i.clientY + r.top };
    }),
    (fabric.util.isTouchEvent = function (e) {
      return n.indexOf(e.type) > -1 || "touch" === e.pointerType;
    });
})();
!(function () {
  function e(e, t) {
    var n = e.style;
    if (!n) return e;
    if ("string" == typeof t)
      return (
        (e.style.cssText += ";" + t),
        t.indexOf("opacity") > -1
          ? o(e, t.match(/opacity:\s*(\d?\.?\d*)/)[1])
          : e
      );
    for (var r in t)
      if ("opacity" === r) o(e, t[r]);
      else {
        var i =
          "float" === r || "cssFloat" === r
            ? "undefined" == typeof n.styleFloat
              ? "cssFloat"
              : "styleFloat"
            : r;
        n.setProperty(i, t[r]);
      }
    return e;
  }
  var t = fabric.document.createElement("div"),
    n = "string" == typeof t.style.opacity,
    r = "string" == typeof t.style.filter,
    i = /alpha\s*\(\s*opacity\s*=\s*([^\)]+)\)/,
    o = function (e) {
      return e;
    };
  n
    ? (o = function (e, t) {
        return (e.style.opacity = t), e;
      })
    : r &&
      (o = function (e, t) {
        var n = e.style;
        return (
          e.currentStyle && !e.currentStyle.hasLayout && (n.zoom = 1),
          i.test(n.filter)
            ? ((t = t >= 0.9999 ? "" : "alpha(opacity=" + 100 * t + ")"),
              (n.filter = n.filter.replace(i, t)))
            : (n.filter += " alpha(opacity=" + 100 * t + ")"),
          e
        );
      }),
    (fabric.util.setStyle = e);
})();
!(function () {
  function e(e) {
    return "string" == typeof e ? fabric.document.getElementById(e) : e;
  }
  function t(e, t) {
    var n = fabric.document.createElement(e);
    for (var r in t)
      "class" === r
        ? (n.className = t[r])
        : "for" === r
        ? (n.htmlFor = t[r])
        : n.setAttribute(r, t[r]);
    return n;
  }
  function n(e, t) {
    e &&
      -1 === (" " + e.className + " ").indexOf(" " + t + " ") &&
      (e.className += (e.className ? " " : "") + t);
  }
  function r(e, n, r) {
    return (
      "string" == typeof n && (n = t(n, r)),
      e.parentNode && e.parentNode.replaceChild(n, e),
      n.appendChild(e),
      n
    );
  }
  function i(e) {
    for (
      var t = 0,
        n = 0,
        r = fabric.document.documentElement,
        i = fabric.document.body || { scrollLeft: 0, scrollTop: 0 };
      e &&
      (e.parentNode || e.host) &&
      ((e = e.parentNode || e.host),
      e === fabric.document
        ? ((t = i.scrollLeft || r.scrollLeft || 0),
          (n = i.scrollTop || r.scrollTop || 0))
        : ((t += e.scrollLeft || 0), (n += e.scrollTop || 0)),
      1 !== e.nodeType || "fixed" !== e.style.position);

    );
    return { left: t, top: n };
  }
  function o(e) {
    var t,
      n,
      r = e && e.ownerDocument,
      o = { left: 0, top: 0 },
      a = { left: 0, top: 0 },
      s = {
        borderLeftWidth: "left",
        borderTopWidth: "top",
        paddingLeft: "left",
        paddingTop: "top",
      };
    if (!r) return a;
    for (var c in s) a[s[c]] += parseInt(v(e, c), 10) || 0;
    return (
      (t = r.documentElement),
      "undefined" != typeof e.getBoundingClientRect &&
        (o = e.getBoundingClientRect()),
      (n = i(e)),
      {
        left: o.left + n.left - (t.clientLeft || 0) + a.left,
        top: o.top + n.top - (t.clientTop || 0) + a.top,
      }
    );
  }
  function a(e) {
    var t = fabric.jsdomImplForWrapper(e);
    return t._canvas || t._image;
  }
  function s(e) {
    if (fabric.isLikelyNode) {
      var t = fabric.jsdomImplForWrapper(e);
      t &&
        ((t._image = null),
        (t._canvas = null),
        (t._currentSrc = null),
        (t._attributes = null),
        (t._classList = null));
    }
  }
  function c(e, t) {
    (e.imageSmoothingEnabled =
      e.imageSmoothingEnabled ||
      e.webkitImageSmoothingEnabled ||
      e.mozImageSmoothingEnabled ||
      e.msImageSmoothingEnabled ||
      e.oImageSmoothingEnabled),
      (e.imageSmoothingEnabled = t);
  }
  var u,
    f = Array.prototype.slice,
    l = function (e) {
      return f.call(e, 0);
    };
  try {
    u = l(fabric.document.childNodes) instanceof Array;
  } catch (d) {}
  u ||
    (l = function (e) {
      for (var t = new Array(e.length), n = e.length; n--; ) t[n] = e[n];
      return t;
    });
  var v;
  (v =
    fabric.document.defaultView && fabric.document.defaultView.getComputedStyle
      ? function (e, t) {
          var n = fabric.document.defaultView.getComputedStyle(e, null);
          return n ? n[t] : void 0;
        }
      : function (e, t) {
          var n = e.style[t];
          return !n && e.currentStyle && (n = e.currentStyle[t]), n;
        }),
    (function () {
      function e(e) {
        return (
          "undefined" != typeof e.onselectstart &&
            (e.onselectstart = fabric.util.falseFunction),
          r
            ? (e.style[r] = "none")
            : "string" == typeof e.unselectable && (e.unselectable = "on"),
          e
        );
      }
      function t(e) {
        return (
          "undefined" != typeof e.onselectstart && (e.onselectstart = null),
          r
            ? (e.style[r] = "")
            : "string" == typeof e.unselectable && (e.unselectable = ""),
          e
        );
      }
      var n = fabric.document.documentElement.style,
        r =
          "userSelect" in n
            ? "userSelect"
            : "MozUserSelect" in n
            ? "MozUserSelect"
            : "WebkitUserSelect" in n
            ? "WebkitUserSelect"
            : "KhtmlUserSelect" in n
            ? "KhtmlUserSelect"
            : "";
      (fabric.util.makeElementUnselectable = e),
        (fabric.util.makeElementSelectable = t);
    })(),
    (fabric.util.setImageSmoothing = c),
    (fabric.util.getById = e),
    (fabric.util.toArray = l),
    (fabric.util.addClass = n),
    (fabric.util.makeElement = t),
    (fabric.util.wrapElement = r),
    (fabric.util.getScrollLeftTop = i),
    (fabric.util.getElementOffset = o),
    (fabric.util.getNodeCanvas = a),
    (fabric.util.cleanUpJsdomNode = s);
})();
!(function () {
  function e(e, t) {
    return e + (/\?/.test(e) ? "&" : "?") + t;
  }
  function t() {}
  function n(n, r) {
    r || (r = {});
    var i = r.method ? r.method.toUpperCase() : "GET",
      o = r.onComplete || function () {},
      a = new fabric.window.XMLHttpRequest(),
      s = r.body || r.parameters;
    return (
      (a.onreadystatechange = function () {
        4 === a.readyState && (o(a), (a.onreadystatechange = t));
      }),
      "GET" === i &&
        ((s = null),
        "string" == typeof r.parameters && (n = e(n, r.parameters))),
      a.open(i, n, !0),
      ("POST" === i || "PUT" === i) &&
        a.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"),
      a.send(s),
      a
    );
  }
  fabric.util.request = n;
})();
(fabric.log = console.log), (fabric.warn = console.warn);
!(function () {
  function e() {
    return !1;
  }
  function t(e, t, n, r) {
    return -n * Math.cos((e / r) * (Math.PI / 2)) + n + t;
  }
  function n(n) {
    n || (n = {});
    var i,
      s = !1,
      c = function () {
        var e = fabric.runningAnimations.indexOf(i);
        return e > -1 && fabric.runningAnimations.splice(e, 1)[0];
      };
    return (
      (i = o(a(n), {
        cancel: function () {
          return (s = !0), c();
        },
        currentValue: "startValue" in n ? n.startValue : 0,
        completionRate: 0,
        durationRate: 0,
      })),
      fabric.runningAnimations.push(i),
      r(function (o) {
        var a,
          u = o || +new Date(),
          f = n.duration || 500,
          l = u + f,
          d = n.onChange || e,
          v = n.abort || e,
          p = n.onComplete || e,
          g = n.easing || t,
          m = "startValue" in n ? n.startValue.length > 0 : !1,
          h = "startValue" in n ? n.startValue : 0,
          y = "endValue" in n ? n.endValue : 100,
          b =
            n.byValue ||
            (m
              ? h.map(function (e, t) {
                  return y[t] - h[t];
                })
              : y - h);
        n.onStart && n.onStart(),
          (function w(e) {
            a = e || +new Date();
            var t = a > l ? f : a - u,
              n = t / f,
              o = m
                ? h.map(function (e, n) {
                    return g(t, h[n], b[n], f);
                  })
                : g(t, h, b, f),
              x = Math.abs(m ? (o[0] - h[0]) / b[0] : (o - h) / b);
            return (
              (i.currentValue = m ? o.slice() : o),
              (i.completionRate = x),
              (i.durationRate = n),
              s
                ? void 0
                : v(o, x, n)
                ? void c()
                : a > l
                ? ((i.currentValue = m ? y.slice() : y),
                  (i.completionRate = 1),
                  (i.durationRate = 1),
                  d(m ? y.slice() : y, 1, 1),
                  p(y, 1, 1),
                  void c())
                : (d(o, x, n), void r(w))
            );
          })(u);
      }),
      i.cancel
    );
  }
  function r() {
    return c.apply(fabric.window, arguments);
  }
  function i() {
    return u.apply(fabric.window, arguments);
  }
  var o = fabric.util.object.extend,
    a = fabric.util.object.clone,
    s = [];
  fabric.util.object.extend(s, {
    cancelAll: function () {
      var e = this.splice(0);
      return (
        e.forEach(function (e) {
          e.cancel();
        }),
        e
      );
    },
    cancelByCanvas: function (e) {
      if (!e) return [];
      var t = this.filter(function (t) {
        return "object" == typeof t.target && t.target.canvas === e;
      });
      return (
        t.forEach(function (e) {
          e.cancel();
        }),
        t
      );
    },
    cancelByTarget: function (e) {
      var t = this.findAnimationsByTarget(e);
      return (
        t.forEach(function (e) {
          e.cancel();
        }),
        t
      );
    },
    findAnimationIndex: function (e) {
      return this.indexOf(this.findAnimation(e));
    },
    findAnimation: function (e) {
      return this.find(function (t) {
        return t.cancel === e;
      });
    },
    findAnimationsByTarget: function (e) {
      return e
        ? this.filter(function (t) {
            return t.target === e;
          })
        : [];
    },
  });
  var c =
      fabric.window.requestAnimationFrame ||
      fabric.window.webkitRequestAnimationFrame ||
      fabric.window.mozRequestAnimationFrame ||
      fabric.window.oRequestAnimationFrame ||
      fabric.window.msRequestAnimationFrame ||
      function (e) {
        return fabric.window.setTimeout(e, 1e3 / 60);
      },
    u = fabric.window.cancelAnimationFrame || fabric.window.clearTimeout;
  (fabric.util.animate = n),
    (fabric.util.requestAnimFrame = r),
    (fabric.util.cancelAnimFrame = i),
    (fabric.runningAnimations = s);
})();
!(function () {
  function e(e, t, n) {
    var r =
      "rgba(" +
      parseInt(e[0] + n * (t[0] - e[0]), 10) +
      "," +
      parseInt(e[1] + n * (t[1] - e[1]), 10) +
      "," +
      parseInt(e[2] + n * (t[2] - e[2]), 10);
    return (
      (r += "," + (e && t ? parseFloat(e[3] + n * (t[3] - e[3])) : 1)),
      (r += ")")
    );
  }
  function t(t, n, r, o) {
    var i = new fabric.Color(t).getSource(),
      a = new fabric.Color(n).getSource(),
      s = o.onComplete,
      c = o.onChange;
    return (
      (o = o || {}),
      fabric.util.animate(
        fabric.util.object.extend(o, {
          duration: r || 500,
          startValue: i,
          endValue: a,
          byValue: a,
          easing: function (t, n, r, i) {
            var a = o.colorEasing
              ? o.colorEasing(t, i)
              : 1 - Math.cos((t / i) * (Math.PI / 2));
            return e(n, r, a);
          },
          onComplete: function (t, n, r) {
            return s ? s(e(a, a, 0), n, r) : void 0;
          },
          onChange: function (t, n, r) {
            if (c) {
              if (Array.isArray(t)) return c(e(t, t, 0), n, r);
              c(t, n, r);
            }
          },
        })
      )
    );
  }
  fabric.util.animateColor = t;
})();
!(function () {
  function e(e, t, n, r) {
    return (
      e < Math.abs(t)
        ? ((e = t), (r = n / 4))
        : (r =
            0 === t && 0 === e
              ? (n / (2 * Math.PI)) * Math.asin(1)
              : (n / (2 * Math.PI)) * Math.asin(t / e)),
      { a: e, c: t, p: n, s: r }
    );
  }
  function t(e, t, n) {
    return (
      e.a *
      Math.pow(2, 10 * (t -= 1)) *
      Math.sin((2 * (t * n - e.s) * Math.PI) / e.p)
    );
  }
  function n(e, t, n, r) {
    return n * ((e = e / r - 1) * e * e + 1) + t;
  }
  function r(e, t, n, r) {
    return (
      (e /= r / 2),
      1 > e ? (n / 2) * e * e * e + t : (n / 2) * ((e -= 2) * e * e + 2) + t
    );
  }
  function i(e, t, n, r) {
    return n * (e /= r) * e * e * e + t;
  }
  function o(e, t, n, r) {
    return -n * ((e = e / r - 1) * e * e * e - 1) + t;
  }
  function a(e, t, n, r) {
    return (
      (e /= r / 2),
      1 > e
        ? (n / 2) * e * e * e * e + t
        : (-n / 2) * ((e -= 2) * e * e * e - 2) + t
    );
  }
  function s(e, t, n, r) {
    return n * (e /= r) * e * e * e * e + t;
  }
  function u(e, t, n, r) {
    return n * ((e = e / r - 1) * e * e * e * e + 1) + t;
  }
  function c(e, t, n, r) {
    return (
      (e /= r / 2),
      1 > e
        ? (n / 2) * e * e * e * e * e + t
        : (n / 2) * ((e -= 2) * e * e * e * e + 2) + t
    );
  }
  function f(e, t, n, r) {
    return -n * Math.cos((e / r) * (Math.PI / 2)) + n + t;
  }
  function l(e, t, n, r) {
    return n * Math.sin((e / r) * (Math.PI / 2)) + t;
  }
  function d(e, t, n, r) {
    return (-n / 2) * (Math.cos((Math.PI * e) / r) - 1) + t;
  }
  function v(e, t, n, r) {
    return 0 === e ? t : n * Math.pow(2, 10 * (e / r - 1)) + t;
  }
  function p(e, t, n, r) {
    return e === r ? t + n : n * (-Math.pow(2, (-10 * e) / r) + 1) + t;
  }
  function g(e, t, n, r) {
    return 0 === e
      ? t
      : e === r
      ? t + n
      : ((e /= r / 2),
        1 > e
          ? (n / 2) * Math.pow(2, 10 * (e - 1)) + t
          : (n / 2) * (-Math.pow(2, -10 * --e) + 2) + t);
  }
  function m(e, t, n, r) {
    return -n * (Math.sqrt(1 - (e /= r) * e) - 1) + t;
  }
  function h(e, t, n, r) {
    return n * Math.sqrt(1 - (e = e / r - 1) * e) + t;
  }
  function y(e, t, n, r) {
    return (
      (e /= r / 2),
      1 > e
        ? (-n / 2) * (Math.sqrt(1 - e * e) - 1) + t
        : (n / 2) * (Math.sqrt(1 - (e -= 2) * e) + 1) + t
    );
  }
  function b(n, r, i, o) {
    var a = 1.70158,
      s = 0,
      u = i;
    if (0 === n) return r;
    if (((n /= o), 1 === n)) return r + i;
    s || (s = 0.3 * o);
    var c = e(u, i, s, a);
    return -t(c, n, o) + r;
  }
  function w(t, n, r, i) {
    var o = 1.70158,
      a = 0,
      s = r;
    if (0 === t) return n;
    if (((t /= i), 1 === t)) return n + r;
    a || (a = 0.3 * i);
    var u = e(s, r, a, o);
    return (
      u.a *
        Math.pow(2, -10 * t) *
        Math.sin((2 * (t * i - u.s) * Math.PI) / u.p) +
      u.c +
      n
    );
  }
  function x(n, r, i, o) {
    var a = 1.70158,
      s = 0,
      u = i;
    if (0 === n) return r;
    if (((n /= o / 2), 2 === n)) return r + i;
    s || (s = 0.3 * o * 1.5);
    var c = e(u, i, s, a);
    return 1 > n
      ? -0.5 * t(c, n, o) + r
      : c.a *
          Math.pow(2, -10 * (n -= 1)) *
          Math.sin((2 * (n * o - c.s) * Math.PI) / c.p) *
          0.5 +
          c.c +
          r;
  }
  function j(e, t, n, r, i) {
    return (
      void 0 === i && (i = 1.70158), n * (e /= r) * e * ((i + 1) * e - i) + t
    );
  }
  function M(e, t, n, r, i) {
    return (
      void 0 === i && (i = 1.70158),
      n * ((e = e / r - 1) * e * ((i + 1) * e + i) + 1) + t
    );
  }
  function P(e, t, n, r, i) {
    return (
      void 0 === i && (i = 1.70158),
      (e /= r / 2),
      1 > e
        ? (n / 2) * e * e * (((i *= 1.525) + 1) * e - i) + t
        : (n / 2) * ((e -= 2) * e * (((i *= 1.525) + 1) * e + i) + 2) + t
    );
  }
  function E(e, t, n, r) {
    return n - T(r - e, 0, n, r) + t;
  }
  function T(e, t, n, r) {
    return (e /= r) < 1 / 2.75
      ? 7.5625 * n * e * e + t
      : 2 / 2.75 > e
      ? n * (7.5625 * (e -= 1.5 / 2.75) * e + 0.75) + t
      : 2.5 / 2.75 > e
      ? n * (7.5625 * (e -= 2.25 / 2.75) * e + 0.9375) + t
      : n * (7.5625 * (e -= 2.625 / 2.75) * e + 0.984375) + t;
  }
  function S(e, t, n, r) {
    return r / 2 > e
      ? 0.5 * E(2 * e, 0, n, r) + t
      : 0.5 * T(2 * e - r, 0, n, r) + 0.5 * n + t;
  }
  fabric.util.ease = {
    easeInQuad: function (e, t, n, r) {
      return n * (e /= r) * e + t;
    },
    easeOutQuad: function (e, t, n, r) {
      return -n * (e /= r) * (e - 2) + t;
    },
    easeInOutQuad: function (e, t, n, r) {
      return (
        (e /= r / 2),
        1 > e ? (n / 2) * e * e + t : (-n / 2) * (--e * (e - 2) - 1) + t
      );
    },
    easeInCubic: function (e, t, n, r) {
      return n * (e /= r) * e * e + t;
    },
    easeOutCubic: n,
    easeInOutCubic: r,
    easeInQuart: i,
    easeOutQuart: o,
    easeInOutQuart: a,
    easeInQuint: s,
    easeOutQuint: u,
    easeInOutQuint: c,
    easeInSine: f,
    easeOutSine: l,
    easeInOutSine: d,
    easeInExpo: v,
    easeOutExpo: p,
    easeInOutExpo: g,
    easeInCirc: m,
    easeOutCirc: h,
    easeInOutCirc: y,
    easeInElastic: b,
    easeOutElastic: w,
    easeInOutElastic: x,
    easeInBack: j,
    easeOutBack: M,
    easeInOutBack: P,
    easeInBounce: E,
    easeOutBounce: T,
    easeInOutBounce: S,
  };
})();
!(function (e) {
  "use strict";
  function t(e) {
    return e in S ? S[e] : e;
  }
  function n(e, t, n, r) {
    var i,
      o = Array.isArray(t);
    if (("fill" !== e && "stroke" !== e) || "none" !== t) {
      if ("strokeUniform" === e) return "non-scaling-stroke" === t;
      if ("strokeDashArray" === e)
        t =
          "none" === t
            ? null
            : t.replace(/,/g, " ").split(/\s+/).map(parseFloat);
      else if ("transformMatrix" === e)
        t =
          n && n.transformMatrix
            ? j(n.transformMatrix, h.parseTransformAttribute(t))
            : h.parseTransformAttribute(t);
      else if ("visible" === e)
        (t = "none" !== t && "hidden" !== t), n && n.visible === !1 && (t = !1);
      else if ("opacity" === e)
        (t = parseFloat(t)),
          n && "undefined" != typeof n.opacity && (t *= n.opacity);
      else if ("textAnchor" === e)
        t = "start" === t ? "left" : "end" === t ? "right" : "center";
      else if ("charSpacing" === e) i = (x(t, r) / r) * 1e3;
      else if ("paintFirst" === e) {
        var a = t.indexOf("fill"),
          s = t.indexOf("stroke"),
          t = "fill";
        a > -1 && s > -1 && a > s
          ? (t = "stroke")
          : -1 === a && s > -1 && (t = "stroke");
      } else {
        if ("href" === e || "xlink:href" === e || "font" === e) return t;
        if ("imageSmoothing" === e) return "optimizeQuality" === t;
        i = o ? t.map(x) : x(t, r);
      }
    } else t = "";
    return !o && isNaN(i) ? t : i;
  }
  function r(e) {
    return new RegExp("^(" + e.join("|") + ")\\b", "i");
  }
  function i(e) {
    for (var t in k)
      if ("undefined" != typeof e[k[t]] && "" !== e[t]) {
        if ("undefined" == typeof e[t]) {
          if (!h.Object.prototype[t]) continue;
          e[t] = h.Object.prototype[t];
        }
        if (0 !== e[t].indexOf("url(")) {
          var n = new h.Color(e[t]);
          e[t] = n.setAlpha(w(n.getAlpha() * e[k[t]], 2)).toRgba();
        }
      }
    return e;
  }
  function o(e, t) {
    var n,
      r,
      i,
      o,
      a = [];
    for (i = 0, o = t.length; o > i; i++)
      (n = t[i]),
        (r = e.getElementsByTagName(n)),
        (a = a.concat(Array.prototype.slice.call(r)));
    return a;
  }
  function a(e, t) {
    var n, r;
    e.replace(/;\s*$/, "")
      .split(";")
      .forEach(function (e) {
        var i = e.split(":");
        (n = i[0].trim().toLowerCase()), (r = i[1].trim()), (t[n] = r);
      });
  }
  function s(e, t) {
    var n, r;
    for (var i in e)
      "undefined" != typeof e[i] &&
        ((n = i.toLowerCase()), (r = e[i]), (t[n] = r));
  }
  function u(e, t) {
    var n = {};
    for (var r in h.cssRules[t])
      if (c(e, r.split(" ")))
        for (var i in h.cssRules[t][r]) n[i] = h.cssRules[t][r][i];
    return n;
  }
  function c(e, t) {
    var n,
      r = !0;
    return (
      (n = l(e, t.pop())),
      n && t.length && (r = f(e, t)),
      n && r && 0 === t.length
    );
  }
  function f(e, t) {
    for (
      var n, r = !0;
      e.parentNode && 1 === e.parentNode.nodeType && t.length;

    )
      r && (n = t.pop()), (e = e.parentNode), (r = l(e, n));
    return 0 === t.length;
  }
  function l(e, t) {
    var n,
      r,
      i = e.nodeName,
      o = e.getAttribute("class"),
      a = e.getAttribute("id");
    if (
      ((n = new RegExp("^" + i, "i")),
      (t = t.replace(n, "")),
      a &&
        t.length &&
        ((n = new RegExp("#" + a + "(?![a-zA-Z\\-]+)", "i")),
        (t = t.replace(n, ""))),
      o && t.length)
    )
      for (o = o.split(" "), r = o.length; r--; )
        (n = new RegExp("\\." + o[r] + "(?![a-zA-Z\\-]+)", "i")),
          (t = t.replace(n, ""));
    return 0 === t.length;
  }
  function d(e, t) {
    var n;
    if ((e.getElementById && (n = e.getElementById(t)), n)) return n;
    var r,
      i,
      o,
      a = e.getElementsByTagName("*");
    for (i = 0, o = a.length; o > i; i++)
      if (((r = a[i]), t === r.getAttribute("id"))) return r;
  }
  function v(e) {
    for (var t = o(e, ["use", "svg:use"]), n = 0; t.length && n < t.length; ) {
      var r = t[n],
        i = r.getAttribute("xlink:href") || r.getAttribute("href");
      if (null === i) return;
      var a,
        s,
        u,
        c,
        f,
        l = i.slice(1),
        v = r.getAttribute("x") || 0,
        g = r.getAttribute("y") || 0,
        m = d(e, l).cloneNode(!0),
        y =
          (m.getAttribute("transform") || "") +
          " translate(" +
          v +
          ", " +
          g +
          ")",
        b = t.length,
        w = h.svgNS;
      if ((p(m), /^svg$/i.test(m.nodeName))) {
        var x = m.ownerDocument.createElementNS(w, "g");
        for (u = 0, c = m.attributes, f = c.length; f > u; u++)
          (s = c.item(u)), x.setAttributeNS(w, s.nodeName, s.nodeValue);
        for (; m.firstChild; ) x.appendChild(m.firstChild);
        m = x;
      }
      for (u = 0, c = r.attributes, f = c.length; f > u; u++)
        (s = c.item(u)),
          "x" !== s.nodeName &&
            "y" !== s.nodeName &&
            "xlink:href" !== s.nodeName &&
            "href" !== s.nodeName &&
            ("transform" === s.nodeName
              ? (y = s.nodeValue + " " + y)
              : m.setAttribute(s.nodeName, s.nodeValue));
      m.setAttribute("transform", y),
        m.setAttribute("instantiated_by_use", "1"),
        m.removeAttribute("id"),
        (a = r.parentNode),
        a.replaceChild(m, r),
        t.length === b && n++;
    }
  }
  function p(e) {
    if (!h.svgViewBoxElementsRegEx.test(e.nodeName)) return {};
    var t,
      n,
      r,
      i,
      o = e.getAttribute("viewBox"),
      a = 1,
      s = 1,
      u = 0,
      c = 0,
      f = e.getAttribute("width"),
      l = e.getAttribute("height"),
      d = e.getAttribute("x") || 0,
      v = e.getAttribute("y") || 0,
      p = e.getAttribute("preserveAspectRatio") || "",
      g = !o || !(o = o.match(O)),
      m = !f || !l || "100%" === f || "100%" === l,
      y = g && m,
      b = {},
      w = "",
      j = 0,
      M = 0;
    if (
      ((b.width = 0),
      (b.height = 0),
      (b.toBeParsed = y),
      g &&
        (d || v) &&
        e.parentNode &&
        "#document" !== e.parentNode.nodeName &&
        ((w = " translate(" + x(d) + " " + x(v) + ") "),
        (r = (e.getAttribute("transform") || "") + w),
        e.setAttribute("transform", r),
        e.removeAttribute("x"),
        e.removeAttribute("y")),
      y)
    )
      return b;
    if (g) return (b.width = x(f)), (b.height = x(l)), b;
    if (
      ((u = -parseFloat(o[1])),
      (c = -parseFloat(o[2])),
      (t = parseFloat(o[3])),
      (n = parseFloat(o[4])),
      (b.minX = u),
      (b.minY = c),
      (b.viewBoxWidth = t),
      (b.viewBoxHeight = n),
      m
        ? ((b.width = t), (b.height = n))
        : ((b.width = x(f)),
          (b.height = x(l)),
          (a = b.width / t),
          (s = b.height / n)),
      (p = h.util.parsePreserveAspectRatioAttribute(p)),
      "none" !== p.alignX &&
        ("meet" === p.meetOrSlice && (s = a = a > s ? s : a),
        "slice" === p.meetOrSlice && (s = a = a > s ? a : s),
        (j = b.width - t * a),
        (M = b.height - n * a),
        "Mid" === p.alignX && (j /= 2),
        "Mid" === p.alignY && (M /= 2),
        "Min" === p.alignX && (j = 0),
        "Min" === p.alignY && (M = 0)),
      1 === a && 1 === s && 0 === u && 0 === c && 0 === d && 0 === v)
    )
      return b;
    if (
      ((d || v) &&
        "#document" !== e.parentNode.nodeName &&
        (w = " translate(" + x(d) + " " + x(v) + ") "),
      (r =
        w +
        " matrix(" +
        a +
        " 0 0 " +
        s +
        " " +
        (u * a + j) +
        " " +
        (c * s + M) +
        ") "),
      "svg" === e.nodeName)
    ) {
      for (i = e.ownerDocument.createElementNS(h.svgNS, "g"); e.firstChild; )
        i.appendChild(e.firstChild);
      e.appendChild(i);
    } else
      (i = e),
        i.removeAttribute("x"),
        i.removeAttribute("y"),
        (r = i.getAttribute("transform") + r);
    return i.setAttribute("transform", r), b;
  }
  function g(e, t) {
    for (; e && (e = e.parentNode); )
      if (
        e.nodeName &&
        t.test(e.nodeName.replace("svg:", "")) &&
        !e.getAttribute("instantiated_by_use")
      )
        return !0;
    return !1;
  }
  function m(e, t) {
    var n = [
        "gradientTransform",
        "x1",
        "x2",
        "y1",
        "y2",
        "gradientUnits",
        "cx",
        "cy",
        "r",
        "fx",
        "fy",
      ],
      r = "xlink:href",
      i = t.getAttribute(r).slice(1),
      o = d(e, i);
    if (
      (o && o.getAttribute(r) && m(e, o),
      n.forEach(function (e) {
        o &&
          !t.hasAttribute(e) &&
          o.hasAttribute(e) &&
          t.setAttribute(e, o.getAttribute(e));
      }),
      !t.children.length)
    )
      for (var a = o.cloneNode(!0); a.firstChild; ) t.appendChild(a.firstChild);
    t.removeAttribute(r);
  }
  var h = e.fabric || (e.fabric = {}),
    y = h.util.object.extend,
    b = h.util.object.clone,
    w = h.util.toFixed,
    x = h.util.parseUnit,
    j = h.util.multiplyTransformMatrices,
    M = [
      "path",
      "circle",
      "polygon",
      "polyline",
      "ellipse",
      "rect",
      "line",
      "image",
      "text",
    ],
    E = ["symbol", "image", "marker", "pattern", "view", "svg"],
    P = ["pattern", "defs", "symbol", "metadata", "clipPath", "mask", "desc"],
    T = ["symbol", "g", "a", "svg", "clipPath", "defs"],
    S = {
      cx: "left",
      x: "left",
      r: "radius",
      cy: "top",
      y: "top",
      display: "visible",
      visibility: "visible",
      transform: "transformMatrix",
      "fill-opacity": "fillOpacity",
      "fill-rule": "fillRule",
      "font-family": "fontFamily",
      "font-size": "fontSize",
      "font-style": "fontStyle",
      "font-weight": "fontWeight",
      "letter-spacing": "charSpacing",
      "paint-order": "paintFirst",
      "stroke-dasharray": "strokeDashArray",
      "stroke-dashoffset": "strokeDashOffset",
      "stroke-linecap": "strokeLineCap",
      "stroke-linejoin": "strokeLineJoin",
      "stroke-miterlimit": "strokeMiterLimit",
      "stroke-opacity": "strokeOpacity",
      "stroke-width": "strokeWidth",
      "text-decoration": "textDecoration",
      "text-anchor": "textAnchor",
      opacity: "opacity",
      "clip-path": "clipPath",
      "clip-rule": "clipRule",
      "vector-effect": "strokeUniform",
      "image-rendering": "imageSmoothing",
    },
    k = { stroke: "strokeOpacity", fill: "fillOpacity" },
    A = "font-size",
    C = "clip-path";
  (h.svgValidTagNamesRegEx = r(M)),
    (h.svgViewBoxElementsRegEx = r(E)),
    (h.svgInvalidAncestorsRegEx = r(P)),
    (h.svgValidParentsRegEx = r(T)),
    (h.cssRules = {}),
    (h.gradientDefs = {}),
    (h.clipPaths = {}),
    (h.parseTransformAttribute = (function () {
      function e(e, t) {
        var n = h.util.cos(t[0]),
          r = h.util.sin(t[0]),
          i = 0,
          o = 0;
        3 === t.length && ((i = t[1]), (o = t[2])),
          (e[0] = n),
          (e[1] = r),
          (e[2] = -r),
          (e[3] = n),
          (e[4] = i - (n * i - r * o)),
          (e[5] = o - (r * i + n * o));
      }
      function t(e, t) {
        var n = t[0],
          r = 2 === t.length ? t[1] : t[0];
        (e[0] = n), (e[3] = r);
      }
      function n(e, t, n) {
        e[n] = Math.tan(h.util.degreesToRadians(t[0]));
      }
      function r(e, t) {
        (e[4] = t[0]), 2 === t.length && (e[5] = t[1]);
      }
      var i = h.iMatrix,
        o = h.reNum,
        a = h.commaWsp,
        s = "(?:(skewX)\\s*\\(\\s*(" + o + ")\\s*\\))",
        u = "(?:(skewY)\\s*\\(\\s*(" + o + ")\\s*\\))",
        c =
          "(?:(rotate)\\s*\\(\\s*(" +
          o +
          ")(?:" +
          a +
          "(" +
          o +
          ")" +
          a +
          "(" +
          o +
          "))?\\s*\\))",
        f = "(?:(scale)\\s*\\(\\s*(" + o + ")(?:" + a + "(" + o + "))?\\s*\\))",
        l =
          "(?:(translate)\\s*\\(\\s*(" +
          o +
          ")(?:" +
          a +
          "(" +
          o +
          "))?\\s*\\))",
        d =
          "(?:(matrix)\\s*\\(\\s*(" +
          o +
          ")" +
          a +
          "(" +
          o +
          ")" +
          a +
          "(" +
          o +
          ")" +
          a +
          "(" +
          o +
          ")" +
          a +
          "(" +
          o +
          ")" +
          a +
          "(" +
          o +
          ")\\s*\\))",
        v = "(?:" + d + "|" + l + "|" + f + "|" + c + "|" + s + "|" + u + ")",
        p = "(?:" + v + "(?:" + a + "*" + v + ")*)",
        g = "^\\s*(?:" + p + "?)\\s*$",
        m = new RegExp(g),
        y = new RegExp(v, "g");
      return function (o) {
        var a = i.concat(),
          s = [];
        if (!o || (o && !m.test(o))) return a;
        o.replace(y, function (o) {
          var u = new RegExp(v).exec(o).filter(function (e) {
              return !!e;
            }),
            c = u[1],
            f = u.slice(2).map(parseFloat);
          switch (c) {
            case "translate":
              r(a, f);
              break;
            case "rotate":
              (f[0] = h.util.degreesToRadians(f[0])), e(a, f);
              break;
            case "scale":
              t(a, f);
              break;
            case "skewX":
              n(a, f, 2);
              break;
            case "skewY":
              n(a, f, 1);
              break;
            case "matrix":
              a = f;
          }
          s.push(a.concat()), (a = i.concat());
        });
        for (var u = s[0]; s.length > 1; )
          s.shift(), (u = h.util.multiplyTransformMatrices(u, s[0]));
        return u;
      };
    })());
  var O = new RegExp(
    "^\\s*(" +
      h.reNum +
      "+)\\s*,?\\s*(" +
      h.reNum +
      "+)\\s*,?\\s*(" +
      h.reNum +
      "+)\\s*,?\\s*(" +
      h.reNum +
      "+)\\s*$"
  );
  h.parseSVGDocument = function (e, t, n, r) {
    if (e) {
      v(e);
      var i,
        o,
        a = h.Object.__uid++,
        s = p(e),
        u = h.util.toArray(e.getElementsByTagName("*"));
      if (
        ((s.crossOrigin = r && r.crossOrigin),
        (s.svgUid = a),
        0 === u.length && h.isLikelyNode)
      ) {
        u = e.selectNodes('//*[name(.)!="svg"]');
        var c = [];
        for (i = 0, o = u.length; o > i; i++) c[i] = u[i];
        u = c;
      }
      var f = u.filter(function (e) {
        return (
          p(e),
          h.svgValidTagNamesRegEx.test(e.nodeName.replace("svg:", "")) &&
            !g(e, h.svgInvalidAncestorsRegEx)
        );
      });
      if (!f || (f && !f.length)) return void (t && t([], {}));
      var l = {};
      u
        .filter(function (e) {
          return "clipPath" === e.nodeName.replace("svg:", "");
        })
        .forEach(function (e) {
          var t = e.getAttribute("id");
          l[t] = h.util
            .toArray(e.getElementsByTagName("*"))
            .filter(function (e) {
              return h.svgValidTagNamesRegEx.test(
                e.nodeName.replace("svg:", "")
              );
            });
        }),
        (h.gradientDefs[a] = h.getGradientDefs(e)),
        (h.cssRules[a] = h.getCSSRules(e)),
        (h.clipPaths[a] = l),
        h.parseElements(
          f,
          function (e, n) {
            t &&
              (t(e, s, n, u),
              delete h.gradientDefs[a],
              delete h.cssRules[a],
              delete h.clipPaths[a]);
          },
          b(s),
          n,
          r
        );
    }
  };
  var L = new RegExp(
    "(normal|italic)?\\s*(normal|small-caps)?\\s*(normal|bold|bolder|lighter|100|200|300|400|500|600|700|800|900)?\\s*(" +
      h.reNum +
      "(?:px|cm|mm|em|pt|pc|in)*)(?:\\/(normal|" +
      h.reNum +
      "))?\\s+(.*)"
  );
  y(h, {
    parseFontDeclaration: function (e, t) {
      var n = e.match(L);
      if (n) {
        var r = n[1],
          i = n[3],
          o = n[4],
          a = n[5],
          s = n[6];
        r && (t.fontStyle = r),
          i && (t.fontWeight = isNaN(parseFloat(i)) ? i : parseFloat(i)),
          o && (t.fontSize = x(o)),
          s && (t.fontFamily = s),
          a && (t.lineHeight = "normal" === a ? 1 : a);
      }
    },
    getGradientDefs: function (e) {
      var t,
        n = [
          "linearGradient",
          "radialGradient",
          "svg:linearGradient",
          "svg:radialGradient",
        ],
        r = o(e, n),
        i = 0,
        a = {};
      for (i = r.length; i--; )
        (t = r[i]),
          t.getAttribute("xlink:href") && m(e, t),
          (a[t.getAttribute("id")] = t);
      return a;
    },
    parseAttributes: function (e, r, o) {
      if (e) {
        var a,
          s,
          c,
          f = {};
        "undefined" == typeof o && (o = e.getAttribute("svgUid")),
          e.parentNode &&
            h.svgValidParentsRegEx.test(e.parentNode.nodeName) &&
            (f = h.parseAttributes(e.parentNode, r, o));
        var l = r.reduce(function (t, n) {
            return (a = e.getAttribute(n)), a && (t[n] = a), t;
          }, {}),
          d = y(u(e, o), h.parseStyleAttribute(e));
        (l = y(l, d)),
          d[C] && e.setAttribute(C, d[C]),
          (s = c = f.fontSize || h.Text.DEFAULT_SVG_FONT_SIZE),
          l[A] && (l[A] = s = x(l[A], c));
        var v,
          p,
          g = {};
        for (var m in l) (v = t(m)), (p = n(v, l[m], f, s)), (g[v] = p);
        g && g.font && h.parseFontDeclaration(g.font, g);
        var b = y(f, g);
        return h.svgValidParentsRegEx.test(e.nodeName) ? b : i(b);
      }
    },
    parseElements: function (e, t, n, r, i) {
      new h.ElementsParser(e, t, n, r, i).parse();
    },
    parseStyleAttribute: function (e) {
      var t = {},
        n = e.getAttribute("style");
      return n ? ("string" == typeof n ? a(n, t) : s(n, t), t) : t;
    },
    parsePointsAttribute: function (e) {
      if (!e) return null;
      (e = e.replace(/,/g, " ").trim()), (e = e.split(/\s+/));
      var t,
        n,
        r = [];
      for (t = 0, n = e.length; n > t; t += 2)
        r.push({ x: parseFloat(e[t]), y: parseFloat(e[t + 1]) });
      return r;
    },
    getCSSRules: function (e) {
      var t,
        n,
        r,
        i = e.getElementsByTagName("style"),
        o = {};
      for (t = 0, n = i.length; n > t; t++) {
        var a = i[t].textContent;
        (a = a.replace(/\/\*[\s\S]*?\*\//g, "")),
          "" !== a.trim() &&
            ((r = a.split("}")),
            (r = r.filter(function (e) {
              return e.trim();
            })),
            r.forEach(function (e) {
              var r = e.split("{"),
                i = {},
                a = r[1].trim(),
                s = a.split(";").filter(function (e) {
                  return e.trim();
                });
              for (t = 0, n = s.length; n > t; t++) {
                var u = s[t].split(":"),
                  c = u[0].trim(),
                  f = u[1].trim();
                i[c] = f;
              }
              (e = r[0].trim()),
                e.split(",").forEach(function (e) {
                  (e = e.replace(/^svg/i, "").trim()),
                    "" !== e &&
                      (o[e]
                        ? h.util.object.extend(o[e], i)
                        : (o[e] = h.util.object.clone(i)));
                });
            }));
      }
      return o;
    },
    loadSVGFromURL: function (e, t, n, r) {
      function i(e) {
        var i = e.responseXML;
        return i && i.documentElement
          ? void h.parseSVGDocument(
              i.documentElement,
              function (e, n, r, i) {
                t && t(e, n, r, i);
              },
              n,
              r
            )
          : (t && t(null), !1);
      }
      (e = e.replace(/^\n\s*/, "").trim()),
        new h.util.request(e, { method: "get", onComplete: i });
    },
    loadSVGFromString: function (e, t, n, r) {
      var i = new h.window.DOMParser(),
        o = i.parseFromString(e.trim(), "text/xml");
      h.parseSVGDocument(
        o.documentElement,
        function (e, n, r, i) {
          t(e, n, r, i);
        },
        n,
        r
      );
    },
  });
})("undefined" != typeof exports ? exports : this);
(fabric.ElementsParser = function (e, t, n, r, i, o) {
  (this.elements = e),
    (this.callback = t),
    (this.options = n),
    (this.reviver = r),
    (this.svgUid = (n && n.svgUid) || 0),
    (this.parsingOptions = i),
    (this.regexUrl = /^url\(['"]?#([^'"]+)['"]?\)/g),
    (this.doc = o);
}),
  (function (e) {
    (e.parse = function () {
      (this.instances = new Array(this.elements.length)),
        (this.numElements = this.elements.length),
        this.createObjects();
    }),
      (e.createObjects = function () {
        var e = this;
        this.elements.forEach(function (t, n) {
          t.setAttribute("svgUid", e.svgUid), e.createObject(t, n);
        });
      }),
      (e.findTag = function (e) {
        return fabric[
          fabric.util.string.capitalize(e.tagName.replace("svg:", ""))
        ];
      }),
      (e.createObject = function (e, t) {
        var n = this.findTag(e);
        if (n && n.fromElement)
          try {
            n.fromElement(e, this.createCallback(t, e), this.options);
          } catch (r) {
            fabric.log(r);
          }
        else this.checkIfDone();
      }),
      (e.createCallback = function (e, t) {
        var n = this;
        return function (r) {
          var i;
          n.resolveGradient(r, t, "fill"),
            n.resolveGradient(r, t, "stroke"),
            r instanceof fabric.Image &&
              r._originalElement &&
              (i = r.parsePreserveAspectRatioAttribute(t)),
            r._removeTransformMatrix(i),
            n.resolveClipPath(r, t),
            n.reviver && n.reviver(t, r),
            (n.instances[e] = r),
            n.checkIfDone();
        };
      }),
      (e.extractPropertyDefinition = function (e, t, n) {
        var r = e[t],
          i = this.regexUrl;
        if (i.test(r)) {
          i.lastIndex = 0;
          var o = i.exec(r)[1];
          return (i.lastIndex = 0), fabric[n][this.svgUid][o];
        }
      }),
      (e.resolveGradient = function (e, t, n) {
        var r = this.extractPropertyDefinition(e, n, "gradientDefs");
        if (r) {
          var i = t.getAttribute(n + "-opacity"),
            o = fabric.Gradient.fromElement(r, e, i, this.options);
          e.set(n, o);
        }
      }),
      (e.createClipPathCallback = function (e, t) {
        return function (e) {
          e._removeTransformMatrix(), (e.fillRule = e.clipRule), t.push(e);
        };
      }),
      (e.resolveClipPath = function (e, t) {
        var n,
          r,
          i,
          o,
          a,
          s,
          c = this.extractPropertyDefinition(e, "clipPath", "clipPaths");
        if (c) {
          (o = []), (i = fabric.util.invertTransform(e.calcTransformMatrix()));
          for (
            var u = c[0].parentNode, f = t;
            f.parentNode && f.getAttribute("clip-path") !== e.clipPath;

          )
            f = f.parentNode;
          f.parentNode.appendChild(u);
          for (var l = 0; l < c.length; l++)
            (n = c[l]),
              (r = this.findTag(n)),
              r.fromElement(n, this.createClipPathCallback(e, o), this.options);
          (c = 1 === o.length ? o[0] : new fabric.Group(o)),
            (a = fabric.util.multiplyTransformMatrices(
              i,
              c.calcTransformMatrix()
            )),
            c.clipPath && this.resolveClipPath(c, f);
          var s = fabric.util.qrDecompose(a);
          (c.flipX = !1),
            (c.flipY = !1),
            c.set("scaleX", s.scaleX),
            c.set("scaleY", s.scaleY),
            (c.angle = s.angle),
            (c.skewX = s.skewX),
            (c.skewY = 0),
            c.setPositionByOrigin(
              { x: s.translateX, y: s.translateY },
              "center",
              "center"
            ),
            (e.clipPath = c);
        } else delete e.clipPath;
      }),
      (e.checkIfDone = function () {
        0 === --this.numElements &&
          ((this.instances = this.instances.filter(function (e) {
            return null != e;
          })),
          this.callback(this.instances, this.elements));
      });
  })(fabric.ElementsParser.prototype);
!(function (e) {
  "use strict";
  function t(e, t) {
    (this.x = e), (this.y = t);
  }
  var n = e.fabric || (e.fabric = {});
  return n.Point
    ? void n.warn("fabric.Point is already defined")
    : ((n.Point = t),
      void (t.prototype = {
        type: "point",
        constructor: t,
        add: function (e) {
          return new t(this.x + e.x, this.y + e.y);
        },
        addEquals: function (e) {
          return (this.x += e.x), (this.y += e.y), this;
        },
        scalarAdd: function (e) {
          return new t(this.x + e, this.y + e);
        },
        scalarAddEquals: function (e) {
          return (this.x += e), (this.y += e), this;
        },
        subtract: function (e) {
          return new t(this.x - e.x, this.y - e.y);
        },
        subtractEquals: function (e) {
          return (this.x -= e.x), (this.y -= e.y), this;
        },
        scalarSubtract: function (e) {
          return new t(this.x - e, this.y - e);
        },
        scalarSubtractEquals: function (e) {
          return (this.x -= e), (this.y -= e), this;
        },
        multiply: function (e) {
          return new t(this.x * e, this.y * e);
        },
        multiplyEquals: function (e) {
          return (this.x *= e), (this.y *= e), this;
        },
        divide: function (e) {
          return new t(this.x / e, this.y / e);
        },
        divideEquals: function (e) {
          return (this.x /= e), (this.y /= e), this;
        },
        eq: function (e) {
          return this.x === e.x && this.y === e.y;
        },
        lt: function (e) {
          return this.x < e.x && this.y < e.y;
        },
        lte: function (e) {
          return this.x <= e.x && this.y <= e.y;
        },
        gt: function (e) {
          return this.x > e.x && this.y > e.y;
        },
        gte: function (e) {
          return this.x >= e.x && this.y >= e.y;
        },
        lerp: function (e, n) {
          return (
            "undefined" == typeof n && (n = 0.5),
            (n = Math.max(Math.min(1, n), 0)),
            new t(this.x + (e.x - this.x) * n, this.y + (e.y - this.y) * n)
          );
        },
        distanceFrom: function (e) {
          var t = this.x - e.x,
            n = this.y - e.y;
          return Math.sqrt(t * t + n * n);
        },
        midPointFrom: function (e) {
          return this.lerp(e);
        },
        min: function (e) {
          return new t(Math.min(this.x, e.x), Math.min(this.y, e.y));
        },
        max: function (e) {
          return new t(Math.max(this.x, e.x), Math.max(this.y, e.y));
        },
        toString: function () {
          return this.x + "," + this.y;
        },
        setXY: function (e, t) {
          return (this.x = e), (this.y = t), this;
        },
        setX: function (e) {
          return (this.x = e), this;
        },
        setY: function (e) {
          return (this.y = e), this;
        },
        setFromPoint: function (e) {
          return (this.x = e.x), (this.y = e.y), this;
        },
        swap: function (e) {
          var t = this.x,
            n = this.y;
          (this.x = e.x), (this.y = e.y), (e.x = t), (e.y = n);
        },
        clone: function () {
          return new t(this.x, this.y);
        },
      }));
})("undefined" != typeof exports ? exports : this);
!(function (e) {
  "use strict";
  function t(e) {
    (this.status = e), (this.points = []);
  }
  var n = e.fabric || (e.fabric = {});
  return n.Intersection
    ? void n.warn("fabric.Intersection is already defined")
    : ((n.Intersection = t),
      (n.Intersection.prototype = {
        constructor: t,
        appendPoint: function (e) {
          return this.points.push(e), this;
        },
        appendPoints: function (e) {
          return (this.points = this.points.concat(e)), this;
        },
      }),
      (n.Intersection.intersectLineLine = function (e, r, i, o) {
        var a,
          s = (o.x - i.x) * (e.y - i.y) - (o.y - i.y) * (e.x - i.x),
          u = (r.x - e.x) * (e.y - i.y) - (r.y - e.y) * (e.x - i.x),
          c = (o.y - i.y) * (r.x - e.x) - (o.x - i.x) * (r.y - e.y);
        if (0 !== c) {
          var f = s / c,
            l = u / c;
          f >= 0 && 1 >= f && l >= 0 && 1 >= l
            ? ((a = new t("Intersection")),
              a.appendPoint(
                new n.Point(e.x + f * (r.x - e.x), e.y + f * (r.y - e.y))
              ))
            : (a = new t());
        } else a = new t(0 === s || 0 === u ? "Coincident" : "Parallel");
        return a;
      }),
      (n.Intersection.intersectLinePolygon = function (e, n, r) {
        var i,
          o,
          a,
          s,
          u = new t(),
          c = r.length;
        for (s = 0; c > s; s++)
          (i = r[s]),
            (o = r[(s + 1) % c]),
            (a = t.intersectLineLine(e, n, i, o)),
            u.appendPoints(a.points);
        return u.points.length > 0 && (u.status = "Intersection"), u;
      }),
      (n.Intersection.intersectPolygonPolygon = function (e, n) {
        var r,
          i = new t(),
          o = e.length;
        for (r = 0; o > r; r++) {
          var a = e[r],
            s = e[(r + 1) % o],
            u = t.intersectLinePolygon(a, s, n);
          i.appendPoints(u.points);
        }
        return i.points.length > 0 && (i.status = "Intersection"), i;
      }),
      void (n.Intersection.intersectPolygonRectangle = function (e, r, i) {
        var o = r.min(i),
          a = r.max(i),
          s = new n.Point(a.x, o.y),
          u = new n.Point(o.x, a.y),
          c = t.intersectLinePolygon(o, s, e),
          f = t.intersectLinePolygon(s, a, e),
          l = t.intersectLinePolygon(a, u, e),
          d = t.intersectLinePolygon(u, o, e),
          p = new t();
        return (
          p.appendPoints(c.points),
          p.appendPoints(f.points),
          p.appendPoints(l.points),
          p.appendPoints(d.points),
          p.points.length > 0 && (p.status = "Intersection"),
          p
        );
      }));
})("undefined" != typeof exports ? exports : this);
!(function (e) {
  "use strict";
  function t(e) {
    e ? this._tryParsingColor(e) : this.setSource([0, 0, 0, 1]);
  }
  function n(e, t, n) {
    return (
      0 > n && (n += 1),
      n > 1 && (n -= 1),
      1 / 6 > n
        ? e + 6 * (t - e) * n
        : 0.5 > n
        ? t
        : 2 / 3 > n
        ? e + (t - e) * (2 / 3 - n) * 6
        : e
    );
  }
  var r = e.fabric || (e.fabric = {});
  return r.Color
    ? void r.warn("fabric.Color is already defined.")
    : ((r.Color = t),
      (r.Color.prototype = {
        _tryParsingColor: function (e) {
          var n;
          e in t.colorNameMap && (e = t.colorNameMap[e]),
            "transparent" === e && (n = [255, 255, 255, 0]),
            n || (n = t.sourceFromHex(e)),
            n || (n = t.sourceFromRgb(e)),
            n || (n = t.sourceFromHsl(e)),
            n || (n = [0, 0, 0, 1]),
            n && this.setSource(n);
        },
        _rgbToHsl: function (e, t, n) {
          (e /= 255), (t /= 255), (n /= 255);
          var i,
            o,
            a,
            s = r.util.array.max([e, t, n]),
            u = r.util.array.min([e, t, n]);
          if (((a = (s + u) / 2), s === u)) i = o = 0;
          else {
            var c = s - u;
            switch (((o = a > 0.5 ? c / (2 - s - u) : c / (s + u)), s)) {
              case e:
                i = (t - n) / c + (n > t ? 6 : 0);
                break;
              case t:
                i = (n - e) / c + 2;
                break;
              case n:
                i = (e - t) / c + 4;
            }
            i /= 6;
          }
          return [
            Math.round(360 * i),
            Math.round(100 * o),
            Math.round(100 * a),
          ];
        },
        getSource: function () {
          return this._source;
        },
        setSource: function (e) {
          this._source = e;
        },
        toRgb: function () {
          var e = this.getSource();
          return "rgb(" + e[0] + "," + e[1] + "," + e[2] + ")";
        },
        toRgba: function () {
          var e = this.getSource();
          return "rgba(" + e[0] + "," + e[1] + "," + e[2] + "," + e[3] + ")";
        },
        toHsl: function () {
          var e = this.getSource(),
            t = this._rgbToHsl(e[0], e[1], e[2]);
          return "hsl(" + t[0] + "," + t[1] + "%," + t[2] + "%)";
        },
        toHsla: function () {
          var e = this.getSource(),
            t = this._rgbToHsl(e[0], e[1], e[2]);
          return "hsla(" + t[0] + "," + t[1] + "%," + t[2] + "%," + e[3] + ")";
        },
        toHex: function () {
          var e,
            t,
            n,
            r = this.getSource();
          return (
            (e = r[0].toString(16)),
            (e = 1 === e.length ? "0" + e : e),
            (t = r[1].toString(16)),
            (t = 1 === t.length ? "0" + t : t),
            (n = r[2].toString(16)),
            (n = 1 === n.length ? "0" + n : n),
            e.toUpperCase() + t.toUpperCase() + n.toUpperCase()
          );
        },
        toHexa: function () {
          var e,
            t = this.getSource();
          return (
            (e = Math.round(255 * t[3])),
            (e = e.toString(16)),
            (e = 1 === e.length ? "0" + e : e),
            this.toHex() + e.toUpperCase()
          );
        },
        getAlpha: function () {
          return this.getSource()[3];
        },
        setAlpha: function (e) {
          var t = this.getSource();
          return (t[3] = e), this.setSource(t), this;
        },
        toGrayscale: function () {
          var e = this.getSource(),
            t = parseInt(
              (0.3 * e[0] + 0.59 * e[1] + 0.11 * e[2]).toFixed(0),
              10
            ),
            n = e[3];
          return this.setSource([t, t, t, n]), this;
        },
        toBlackWhite: function (e) {
          var t = this.getSource(),
            n = (0.3 * t[0] + 0.59 * t[1] + 0.11 * t[2]).toFixed(0),
            r = t[3];
          return (
            (e = e || 127),
            (n = Number(n) < Number(e) ? 0 : 255),
            this.setSource([n, n, n, r]),
            this
          );
        },
        overlayWith: function (e) {
          e instanceof t || (e = new t(e));
          var n,
            r = [],
            i = this.getAlpha(),
            o = 0.5,
            a = this.getSource(),
            s = e.getSource();
          for (n = 0; 3 > n; n++) r.push(Math.round(a[n] * (1 - o) + s[n] * o));
          return (r[3] = i), this.setSource(r), this;
        },
      }),
      (r.Color.reRGBa =
        /^rgba?\(\s*(\d{1,3}(?:\.\d+)?\%?)\s*,\s*(\d{1,3}(?:\.\d+)?\%?)\s*,\s*(\d{1,3}(?:\.\d+)?\%?)\s*(?:\s*,\s*((?:\d*\.?\d+)?)\s*)?\)$/i),
      (r.Color.reHSLa =
        /^hsla?\(\s*(\d{1,3})\s*,\s*(\d{1,3}\%)\s*,\s*(\d{1,3}\%)\s*(?:\s*,\s*(\d+(?:\.\d+)?)\s*)?\)$/i),
      (r.Color.reHex =
        /^#?([0-9a-f]{8}|[0-9a-f]{6}|[0-9a-f]{4}|[0-9a-f]{3})$/i),
      (r.Color.colorNameMap = {
        aliceblue: "#F0F8FF",
        antiquewhite: "#FAEBD7",
        aqua: "#00FFFF",
        aquamarine: "#7FFFD4",
        azure: "#F0FFFF",
        beige: "#F5F5DC",
        bisque: "#FFE4C4",
        black: "#000000",
        blanchedalmond: "#FFEBCD",
        blue: "#0000FF",
        blueviolet: "#8A2BE2",
        brown: "#A52A2A",
        burlywood: "#DEB887",
        cadetblue: "#5F9EA0",
        chartreuse: "#7FFF00",
        chocolate: "#D2691E",
        coral: "#FF7F50",
        cornflowerblue: "#6495ED",
        cornsilk: "#FFF8DC",
        crimson: "#DC143C",
        cyan: "#00FFFF",
        darkblue: "#00008B",
        darkcyan: "#008B8B",
        darkgoldenrod: "#B8860B",
        darkgray: "#A9A9A9",
        darkgrey: "#A9A9A9",
        darkgreen: "#006400",
        darkkhaki: "#BDB76B",
        darkmagenta: "#8B008B",
        darkolivegreen: "#556B2F",
        darkorange: "#FF8C00",
        darkorchid: "#9932CC",
        darkred: "#8B0000",
        darksalmon: "#E9967A",
        darkseagreen: "#8FBC8F",
        darkslateblue: "#483D8B",
        darkslategray: "#2F4F4F",
        darkslategrey: "#2F4F4F",
        darkturquoise: "#00CED1",
        darkviolet: "#9400D3",
        deeppink: "#FF1493",
        deepskyblue: "#00BFFF",
        dimgray: "#696969",
        dimgrey: "#696969",
        dodgerblue: "#1E90FF",
        firebrick: "#B22222",
        floralwhite: "#FFFAF0",
        forestgreen: "#228B22",
        fuchsia: "#FF00FF",
        gainsboro: "#DCDCDC",
        ghostwhite: "#F8F8FF",
        gold: "#FFD700",
        goldenrod: "#DAA520",
        gray: "#808080",
        grey: "#808080",
        green: "#008000",
        greenyellow: "#ADFF2F",
        honeydew: "#F0FFF0",
        hotpink: "#FF69B4",
        indianred: "#CD5C5C",
        indigo: "#4B0082",
        ivory: "#FFFFF0",
        khaki: "#F0E68C",
        lavender: "#E6E6FA",
        lavenderblush: "#FFF0F5",
        lawngreen: "#7CFC00",
        lemonchiffon: "#FFFACD",
        lightblue: "#ADD8E6",
        lightcoral: "#F08080",
        lightcyan: "#E0FFFF",
        lightgoldenrodyellow: "#FAFAD2",
        lightgray: "#D3D3D3",
        lightgrey: "#D3D3D3",
        lightgreen: "#90EE90",
        lightpink: "#FFB6C1",
        lightsalmon: "#FFA07A",
        lightseagreen: "#20B2AA",
        lightskyblue: "#87CEFA",
        lightslategray: "#778899",
        lightslategrey: "#778899",
        lightsteelblue: "#B0C4DE",
        lightyellow: "#FFFFE0",
        lime: "#00FF00",
        limegreen: "#32CD32",
        linen: "#FAF0E6",
        magenta: "#FF00FF",
        maroon: "#800000",
        mediumaquamarine: "#66CDAA",
        mediumblue: "#0000CD",
        mediumorchid: "#BA55D3",
        mediumpurple: "#9370DB",
        mediumseagreen: "#3CB371",
        mediumslateblue: "#7B68EE",
        mediumspringgreen: "#00FA9A",
        mediumturquoise: "#48D1CC",
        mediumvioletred: "#C71585",
        midnightblue: "#191970",
        mintcream: "#F5FFFA",
        mistyrose: "#FFE4E1",
        moccasin: "#FFE4B5",
        navajowhite: "#FFDEAD",
        navy: "#000080",
        oldlace: "#FDF5E6",
        olive: "#808000",
        olivedrab: "#6B8E23",
        orange: "#FFA500",
        orangered: "#FF4500",
        orchid: "#DA70D6",
        palegoldenrod: "#EEE8AA",
        palegreen: "#98FB98",
        paleturquoise: "#AFEEEE",
        palevioletred: "#DB7093",
        papayawhip: "#FFEFD5",
        peachpuff: "#FFDAB9",
        peru: "#CD853F",
        pink: "#FFC0CB",
        plum: "#DDA0DD",
        powderblue: "#B0E0E6",
        purple: "#800080",
        rebeccapurple: "#663399",
        red: "#FF0000",
        rosybrown: "#BC8F8F",
        royalblue: "#4169E1",
        saddlebrown: "#8B4513",
        salmon: "#FA8072",
        sandybrown: "#F4A460",
        seagreen: "#2E8B57",
        seashell: "#FFF5EE",
        sienna: "#A0522D",
        silver: "#C0C0C0",
        skyblue: "#87CEEB",
        slateblue: "#6A5ACD",
        slategray: "#708090",
        slategrey: "#708090",
        snow: "#FFFAFA",
        springgreen: "#00FF7F",
        steelblue: "#4682B4",
        tan: "#D2B48C",
        teal: "#008080",
        thistle: "#D8BFD8",
        tomato: "#FF6347",
        turquoise: "#40E0D0",
        violet: "#EE82EE",
        wheat: "#F5DEB3",
        white: "#FFFFFF",
        whitesmoke: "#F5F5F5",
        yellow: "#FFFF00",
        yellowgreen: "#9ACD32",
      }),
      (r.Color.fromRgb = function (e) {
        return t.fromSource(t.sourceFromRgb(e));
      }),
      (r.Color.sourceFromRgb = function (e) {
        var n = e.match(t.reRGBa);
        if (n) {
          var r =
              (parseInt(n[1], 10) / (/%$/.test(n[1]) ? 100 : 1)) *
              (/%$/.test(n[1]) ? 255 : 1),
            i =
              (parseInt(n[2], 10) / (/%$/.test(n[2]) ? 100 : 1)) *
              (/%$/.test(n[2]) ? 255 : 1),
            o =
              (parseInt(n[3], 10) / (/%$/.test(n[3]) ? 100 : 1)) *
              (/%$/.test(n[3]) ? 255 : 1);
          return [
            parseInt(r, 10),
            parseInt(i, 10),
            parseInt(o, 10),
            n[4] ? parseFloat(n[4]) : 1,
          ];
        }
      }),
      (r.Color.fromRgba = t.fromRgb),
      (r.Color.fromHsl = function (e) {
        return t.fromSource(t.sourceFromHsl(e));
      }),
      (r.Color.sourceFromHsl = function (e) {
        var r = e.match(t.reHSLa);
        if (r) {
          var i,
            o,
            a,
            s = (((parseFloat(r[1]) % 360) + 360) % 360) / 360,
            u = parseFloat(r[2]) / (/%$/.test(r[2]) ? 100 : 1),
            c = parseFloat(r[3]) / (/%$/.test(r[3]) ? 100 : 1);
          if (0 === u) i = o = a = c;
          else {
            var l = 0.5 >= c ? c * (u + 1) : c + u - c * u,
              f = 2 * c - l;
            (i = n(f, l, s + 1 / 3)),
              (o = n(f, l, s)),
              (a = n(f, l, s - 1 / 3));
          }
          return [
            Math.round(255 * i),
            Math.round(255 * o),
            Math.round(255 * a),
            r[4] ? parseFloat(r[4]) : 1,
          ];
        }
      }),
      (r.Color.fromHsla = t.fromHsl),
      (r.Color.fromHex = function (e) {
        return t.fromSource(t.sourceFromHex(e));
      }),
      (r.Color.sourceFromHex = function (e) {
        if (e.match(t.reHex)) {
          var n = e.slice(e.indexOf("#") + 1),
            r = 3 === n.length || 4 === n.length,
            i = 8 === n.length || 4 === n.length,
            o = r ? n.charAt(0) + n.charAt(0) : n.substring(0, 2),
            a = r ? n.charAt(1) + n.charAt(1) : n.substring(2, 4),
            s = r ? n.charAt(2) + n.charAt(2) : n.substring(4, 6),
            u = i ? (r ? n.charAt(3) + n.charAt(3) : n.substring(6, 8)) : "FF";
          return [
            parseInt(o, 16),
            parseInt(a, 16),
            parseInt(s, 16),
            parseFloat((parseInt(u, 16) / 255).toFixed(2)),
          ];
        }
      }),
      void (r.Color.fromSource = function (e) {
        var n = new t();
        return n.setSource(e), n;
      }));
})("undefined" != typeof exports ? exports : this);
!(function (e) {
  "use strict";
  function t(e, t) {
    var n = e.angle + G(Math.atan2(t.y, t.x)) + 360;
    return Math.round((n % 360) / 45);
  }
  function n(e, t) {
    var n = t.transform.target,
      r = n.canvas,
      i = C.util.object.clone(t);
    (i.target = n), r && r.fire("object:" + e, i), n.fire(e, t);
  }
  function r(e, t) {
    var n = t.canvas,
      r = n.uniScaleKey,
      i = e[r];
    return (n.uniformScaling && !i) || (!n.uniformScaling && i);
  }
  function i(e) {
    return e.originX === I && e.originY === I;
  }
  function o(e, t, n) {
    var r = e.lockScalingX,
      i = e.lockScalingY;
    return r && i
      ? !0
      : !t && (r || i) && n
      ? !0
      : r && "x" === t
      ? !0
      : i && "y" === t
      ? !0
      : !1;
  }
  function a(e, n, i) {
    var a = "not-allowed",
      s = r(e, i),
      c = "";
    if (
      (0 !== n.x && 0 === n.y ? (c = "x") : 0 === n.x && 0 !== n.y && (c = "y"),
      o(i, c, s))
    )
      return a;
    var u = t(i, n);
    return X[u] + "-resize";
  }
  function s(e, n, r) {
    var i = "not-allowed";
    if (0 !== n.x && r.lockSkewingY) return i;
    if (0 !== n.y && r.lockSkewingX) return i;
    var o = t(r, n) % 4;
    return O[o] + "-resize";
  }
  function c(e, t, n) {
    return e[n.canvas.altActionKey]
      ? Y.skewCursorStyleHandler(e, t, n)
      : Y.scaleCursorStyleHandler(e, t, n);
  }
  function u(e, t, n) {
    var r = e[n.canvas.altActionKey];
    return 0 === t.x
      ? r
        ? "skewX"
        : "scaleY"
      : 0 === t.y
      ? r
        ? "skewY"
        : "scaleX"
      : void 0;
  }
  function f(e, t, n) {
    return n.lockRotation ? "not-allowed" : t.cursorStyle;
  }
  function l(e, t, n, r) {
    return { e: e, transform: t, pointer: { x: n, y: r } };
  }
  function d(e) {
    return function (t, n, r, i) {
      var o = n.target,
        a = o.getCenterPoint(),
        s = o.translateToOriginPoint(a, n.originX, n.originY),
        c = e(t, n, r, i);
      return o.setPositionByOrigin(s, n.originX, n.originY), c;
    };
  }
  function p(e, t) {
    return function (r, i, o, a) {
      var s = t(r, i, o, a);
      return s && n(e, l(r, i, o, a)), s;
    };
  }
  function v(e, t, n, r, i) {
    var o = e.target,
      a = o.controls[e.corner],
      s = o.canvas.getZoom(),
      c = o.padding / s,
      u = o.toLocalPoint(new C.Point(r, i), t, n);
    return (
      u.x >= c && (u.x -= c),
      u.x <= -c && (u.x += c),
      u.y >= c && (u.y -= c),
      u.y <= c && (u.y += c),
      (u.x -= a.offsetX),
      (u.y -= a.offsetY),
      u
    );
  }
  function g(e) {
    return e.flipX !== e.flipY;
  }
  function h(e, t, n, r, i) {
    if (0 !== e[t]) {
      var o = e._getTransformedDimensions()[r],
        a = (i / o) * e[n];
      e.set(n, a);
    }
  }
  function m(e, t, n, r) {
    var i,
      o = t.target,
      a = o._getTransformedDimensions(0, o.skewY),
      s = v(t, t.originX, t.originY, n, r),
      c = Math.abs(2 * s.x) - a.x,
      u = o.skewX;
    2 > c
      ? (i = 0)
      : ((i = G(Math.atan2(c / o.scaleX, a.y / o.scaleY))),
        t.originX === L && t.originY === F && (i = -i),
        t.originX === _ && t.originY === D && (i = -i),
        g(o) && (i = -i));
    var f = u !== i;
    if (f) {
      var l = o._getTransformedDimensions().y;
      o.set("skewX", i), h(o, "skewY", "scaleY", "y", l);
    }
    return f;
  }
  function y(e, t, n, r) {
    var i,
      o = t.target,
      a = o._getTransformedDimensions(o.skewX, 0),
      s = v(t, t.originX, t.originY, n, r),
      c = Math.abs(2 * s.y) - a.y,
      u = o.skewY;
    2 > c
      ? (i = 0)
      : ((i = G(Math.atan2(c / o.scaleY, a.x / o.scaleX))),
        t.originX === L && t.originY === F && (i = -i),
        t.originX === _ && t.originY === D && (i = -i),
        g(o) && (i = -i));
    var f = u !== i;
    if (f) {
      var l = o._getTransformedDimensions().x;
      o.set("skewY", i), h(o, "skewX", "scaleX", "x", l);
    }
    return f;
  }
  function b(e, t, n, r) {
    var i,
      o = t.target,
      a = o.skewX,
      s = t.originY;
    if (o.lockSkewingX) return !1;
    if (0 === a) {
      var c = v(t, I, I, n, r);
      i = c.x > 0 ? L : _;
    } else
      a > 0 && (i = s === D ? L : _),
        0 > a && (i = s === D ? _ : L),
        g(o) && (i = i === L ? _ : L);
    t.originX = i;
    var u = p("skewing", d(m));
    return u(e, t, n, r);
  }
  function x(e, t, n, r) {
    var i,
      o = t.target,
      a = o.skewY,
      s = t.originX;
    if (o.lockSkewingY) return !1;
    if (0 === a) {
      var c = v(t, I, I, n, r);
      i = c.y > 0 ? D : F;
    } else
      a > 0 && (i = s === L ? D : F),
        0 > a && (i = s === L ? F : D),
        g(o) && (i = i === D ? F : D);
    t.originY = i;
    var u = p("skewing", d(y));
    return u(e, t, n, r);
  }
  function w(e, t, n, r) {
    var i = t,
      o = i.target,
      a = o.translateToOriginPoint(o.getCenterPoint(), i.originX, i.originY);
    if (o.lockRotation) return !1;
    var s = Math.atan2(i.ey - a.y, i.ex - a.x),
      c = Math.atan2(r - a.y, n - a.x),
      u = G(c - s + i.theta),
      f = !0;
    if (o.snapAngle > 0) {
      var l = o.snapAngle,
        d = o.snapThreshold || l,
        p = Math.ceil(u / l) * l,
        v = Math.floor(u / l) * l;
      Math.abs(u - v) < d ? (u = v) : Math.abs(u - p) < d && (u = p);
    }
    return (
      0 > u && (u = 360 + u), (u %= 360), (f = o.angle !== u), (o.angle = u), f
    );
  }
  function j(e, t, n, a, s) {
    s = s || {};
    var c,
      u,
      f,
      l,
      d,
      p,
      g = t.target,
      h = g.lockScalingX,
      m = g.lockScalingY,
      y = s.by,
      b = r(e, g),
      x = o(g, y, b),
      w = t.gestureScale;
    if (x) return !1;
    if (w) (u = t.scaleX * w), (f = t.scaleY * w);
    else {
      if (
        ((c = v(t, t.originX, t.originY, n, a)),
        (d = "y" !== y ? R(c.x) : 1),
        (p = "x" !== y ? R(c.y) : 1),
        t.signX || (t.signX = d),
        t.signY || (t.signY = p),
        g.lockScalingFlip && (t.signX !== d || t.signY !== p))
      )
        return !1;
      if (((l = g._getTransformedDimensions()), b && !y)) {
        var j = Math.abs(c.x) + Math.abs(c.y),
          P = t.original,
          M =
            Math.abs((l.x * P.scaleX) / g.scaleX) +
            Math.abs((l.y * P.scaleY) / g.scaleY),
          E = j / M;
        (u = P.scaleX * E), (f = P.scaleY * E);
      } else
        (u = Math.abs((c.x * g.scaleX) / l.x)),
          (f = Math.abs((c.y * g.scaleY) / l.y));
      i(t) && ((u *= 2), (f *= 2)),
        t.signX !== d &&
          "y" !== y &&
          ((t.originX = N[t.originX]), (u *= -1), (t.signX = d)),
        t.signY !== p &&
          "x" !== y &&
          ((t.originY = N[t.originY]), (f *= -1), (t.signY = p));
    }
    var k = g.scaleX,
      S = g.scaleY;
    return (
      y
        ? ("x" === y && g.set("scaleX", u), "y" === y && g.set("scaleY", f))
        : (!h && g.set("scaleX", u), !m && g.set("scaleY", f)),
      k !== g.scaleX || S !== g.scaleY
    );
  }
  function P(e, t, n, r) {
    return j(e, t, n, r);
  }
  function M(e, t, n, r) {
    return j(e, t, n, r, { by: "x" });
  }
  function E(e, t, n, r) {
    return j(e, t, n, r, { by: "y" });
  }
  function k(e, t, n, r) {
    return e[t.target.canvas.altActionKey]
      ? Y.skewHandlerX(e, t, n, r)
      : Y.scalingY(e, t, n, r);
  }
  function S(e, t, n, r) {
    return e[t.target.canvas.altActionKey]
      ? Y.skewHandlerY(e, t, n, r)
      : Y.scalingX(e, t, n, r);
  }
  function T(e, t, n, r) {
    var o = t.target,
      a = v(t, t.originX, t.originY, n, r),
      s = o.strokeWidth / (o.strokeUniform ? o.scaleX : 1),
      c = i(t) ? 2 : 1,
      u = o.width,
      f = Math.abs((a.x * c) / o.scaleX) - s;
    return o.set("width", Math.max(f, 0)), u !== f;
  }
  function A(e, t, r, i) {
    var o = t.target,
      a = r - t.offsetX,
      s = i - t.offsetY,
      c = !o.get("lockMovementX") && o.left !== a,
      u = !o.get("lockMovementY") && o.top !== s;
    return (
      c && o.set("left", a),
      u && o.set("top", s),
      (c || u) && n("moving", l(e, t, r, i)),
      c || u
    );
  }
  var C = e.fabric || (e.fabric = {}),
    X = ["e", "se", "s", "sw", "w", "nw", "n", "ne", "e"],
    O = ["ns", "nesw", "ew", "nwse"],
    Y = {},
    L = "left",
    D = "top",
    _ = "right",
    F = "bottom",
    I = "center",
    N = { top: F, bottom: D, left: _, right: L, center: I },
    G = C.util.radiansToDegrees,
    R =
      Math.sign ||
      function (e) {
        return (e > 0) - (0 > e) || +e;
      };
  (Y.scaleCursorStyleHandler = a),
    (Y.skewCursorStyleHandler = s),
    (Y.scaleSkewCursorStyleHandler = c),
    (Y.rotationWithSnapping = p("rotating", d(w))),
    (Y.scalingEqually = p("scaling", d(P))),
    (Y.scalingX = p("scaling", d(M))),
    (Y.scalingY = p("scaling", d(E))),
    (Y.scalingYOrSkewingX = k),
    (Y.scalingXOrSkewingY = S),
    (Y.changeWidth = p("resizing", d(T))),
    (Y.skewHandlerX = b),
    (Y.skewHandlerY = x),
    (Y.dragHandler = A),
    (Y.scaleOrSkewActionName = u),
    (Y.rotationStyleHandler = f),
    (Y.fireEvent = n),
    (Y.wrapWithFixedAnchor = d),
    (Y.wrapWithFireEvent = p),
    (Y.getLocalPoint = v),
    (C.controlsUtils = Y);
})("undefined" != typeof exports ? exports : this);
!(function (e) {
  "use strict";
  function t(e, t, n, r, i) {
    r = r || {};
    var o,
      a = this.sizeX || r.cornerSize || i.cornerSize,
      s = this.sizeY || r.cornerSize || i.cornerSize,
      c =
        "undefined" != typeof r.transparentCorners
          ? r.transparentCorners
          : i.transparentCorners,
      u = c ? "stroke" : "fill",
      l = !c && (r.cornerStrokeColor || i.cornerStrokeColor),
      f = t,
      d = n;
    e.save(),
      (e.fillStyle = r.cornerColor || i.cornerColor),
      (e.strokeStyle = r.cornerStrokeColor || i.cornerStrokeColor),
      a > s
        ? ((o = a), e.scale(1, s / a), (d = (n * a) / s))
        : s > a
        ? ((o = s), e.scale(a / s, 1), (f = (t * s) / a))
        : (o = a),
      (e.lineWidth = 1),
      e.beginPath(),
      e.arc(f, d, o / 2, 0, 2 * Math.PI, !1),
      e[u](),
      l && e.stroke(),
      e.restore();
  }
  function n(e, t, n, r, o) {
    r = r || {};
    var a = this.sizeX || r.cornerSize || o.cornerSize,
      s = this.sizeY || r.cornerSize || o.cornerSize,
      c =
        "undefined" != typeof r.transparentCorners
          ? r.transparentCorners
          : o.transparentCorners,
      u = c ? "stroke" : "fill",
      l = !c && (r.cornerStrokeColor || o.cornerStrokeColor),
      f = a / 2,
      d = s / 2;
    e.save(),
      (e.fillStyle = r.cornerColor || o.cornerColor),
      (e.strokeStyle = r.cornerStrokeColor || o.cornerStrokeColor),
      (e.lineWidth = 1),
      e.translate(t, n),
      e.rotate(i(o.angle)),
      e[u + "Rect"](-f, -d, a, s),
      l && e.strokeRect(-f, -d, a, s),
      e.restore();
  }
  var r = e.fabric || (e.fabric = {}),
    i = r.util.degreesToRadians,
    o = r.controlsUtils;
  (o.renderCircleControl = t), (o.renderSquareControl = n);
})("undefined" != typeof exports ? exports : this);
!(function (e) {
  "use strict";
  function t(e) {
    for (var t in e) this[t] = e[t];
  }
  var n = e.fabric || (e.fabric = {});
  (n.Control = t),
    (n.Control.prototype = {
      visible: !0,
      actionName: "scale",
      angle: 0,
      x: 0,
      y: 0,
      offsetX: 0,
      offsetY: 0,
      sizeX: null,
      sizeY: null,
      touchSizeX: null,
      touchSizeY: null,
      cursorStyle: "crosshair",
      withConnection: !1,
      actionHandler: function () {},
      mouseDownHandler: function () {},
      mouseUpHandler: function () {},
      getActionHandler: function () {
        return this.actionHandler;
      },
      getMouseDownHandler: function () {
        return this.mouseDownHandler;
      },
      getMouseUpHandler: function () {
        return this.mouseUpHandler;
      },
      cursorStyleHandler: function (e, t) {
        return t.cursorStyle;
      },
      getActionName: function (e, t) {
        return t.actionName;
      },
      getVisibility: function (e, t) {
        var n = e._controlsVisibility;
        return n && "undefined" != typeof n[t] ? n[t] : this.visible;
      },
      setVisibility: function (e) {
        this.visible = e;
      },
      positionHandler: function (e, t) {
        var r = n.util.transformPoint(
          { x: this.x * e.x + this.offsetX, y: this.y * e.y + this.offsetY },
          t
        );
        return r;
      },
      calcCornerCoords: function (e, t, r, i, o) {
        var a,
          s,
          u,
          c,
          l = o ? this.touchSizeX : this.sizeX,
          f = o ? this.touchSizeY : this.sizeY;
        if (l && f && l !== f) {
          var d = Math.atan2(f, l),
            p = Math.sqrt(l * l + f * f) / 2,
            v = d - n.util.degreesToRadians(e),
            g = Math.PI / 2 - d - n.util.degreesToRadians(e);
          (a = p * n.util.cos(v)),
            (s = p * n.util.sin(v)),
            (u = p * n.util.cos(g)),
            (c = p * n.util.sin(g));
        } else {
          var h = l && f ? l : t;
          p = 0.7071067812 * h;
          var v = n.util.degreesToRadians(45 - e);
          (a = u = p * n.util.cos(v)), (s = c = p * n.util.sin(v));
        }
        return {
          tl: { x: r - c, y: i - u },
          tr: { x: r + a, y: i - s },
          bl: { x: r - a, y: i + s },
          br: { x: r + c, y: i + u },
        };
      },
      render: function (e, t, r, i, o) {
        switch (((i = i || {}), i.cornerStyle || o.cornerStyle)) {
          case "circle":
            n.controlsUtils.renderCircleControl.call(this, e, t, r, i, o);
            break;
          default:
            n.controlsUtils.renderSquareControl.call(this, e, t, r, i, o);
        }
      },
    });
})("undefined" != typeof exports ? exports : this);
!(function () {
  function e(e, t) {
    var n,
      r,
      i,
      o,
      a = e.getAttribute("style"),
      s = e.getAttribute("offset") || 0;
    if (
      ((s = parseFloat(s) / (/%$/.test(s) ? 100 : 1)),
      (s = 0 > s ? 0 : s > 1 ? 1 : s),
      a)
    ) {
      var c = a.split(/\s*;\s*/);
      for ("" === c[c.length - 1] && c.pop(), o = c.length; o--; ) {
        var u = c[o].split(/\s*:\s*/),
          l = u[0].trim(),
          f = u[1].trim();
        "stop-color" === l ? (n = f) : "stop-opacity" === l && (i = f);
      }
    }
    return (
      n || (n = e.getAttribute("stop-color") || "rgb(0,0,0)"),
      i || (i = e.getAttribute("stop-opacity")),
      (n = new fabric.Color(n)),
      (r = n.getAlpha()),
      (i = isNaN(parseFloat(i)) ? 1 : parseFloat(i)),
      (i *= r * t),
      { offset: s, color: n.toRgb(), opacity: i }
    );
  }
  function t(e) {
    return {
      x1: e.getAttribute("x1") || 0,
      y1: e.getAttribute("y1") || 0,
      x2: e.getAttribute("x2") || "100%",
      y2: e.getAttribute("y2") || 0,
    };
  }
  function n(e) {
    return {
      x1: e.getAttribute("fx") || e.getAttribute("cx") || "50%",
      y1: e.getAttribute("fy") || e.getAttribute("cy") || "50%",
      r1: 0,
      x2: e.getAttribute("cx") || "50%",
      y2: e.getAttribute("cy") || "50%",
      r2: e.getAttribute("r") || "50%",
    };
  }
  function r(e, t, n, r) {
    var i, o;
    Object.keys(t).forEach(function (e) {
      (i = t[e]),
        "Infinity" === i
          ? (o = 1)
          : "-Infinity" === i
          ? (o = 0)
          : ((o = parseFloat(t[e], 10)),
            "string" == typeof i &&
              /^(\d+\.\d+)%|(\d+)%$/.test(i) &&
              ((o *= 0.01),
              "pixels" === r &&
                (("x1" === e || "x2" === e || "r2" === e) &&
                  (o *= n.viewBoxWidth || n.width),
                ("y1" === e || "y2" === e) &&
                  (o *= n.viewBoxHeight || n.height)))),
        (t[e] = o);
    });
  }
  var i = fabric.util.object.clone;
  (fabric.Gradient = fabric.util.createClass({
    offsetX: 0,
    offsetY: 0,
    gradientTransform: null,
    gradientUnits: "pixels",
    type: "linear",
    initialize: function (e) {
      e || (e = {}), e.coords || (e.coords = {});
      var t,
        n = this;
      Object.keys(e).forEach(function (t) {
        n[t] = e[t];
      }),
        this.id
          ? (this.id += "_" + fabric.Object.__uid++)
          : (this.id = fabric.Object.__uid++),
        (t = {
          x1: e.coords.x1 || 0,
          y1: e.coords.y1 || 0,
          x2: e.coords.x2 || 0,
          y2: e.coords.y2 || 0,
        }),
        "radial" === this.type &&
          ((t.r1 = e.coords.r1 || 0), (t.r2 = e.coords.r2 || 0)),
        (this.coords = t),
        (this.colorStops = e.colorStops.slice());
    },
    addColorStop: function (e) {
      for (var t in e) {
        var n = new fabric.Color(e[t]);
        this.colorStops.push({
          offset: parseFloat(t),
          color: n.toRgb(),
          opacity: n.getAlpha(),
        });
      }
      return this;
    },
    toObject: function (e) {
      var t = {
        type: this.type,
        coords: this.coords,
        colorStops: this.colorStops,
        offsetX: this.offsetX,
        offsetY: this.offsetY,
        gradientUnits: this.gradientUnits,
        gradientTransform: this.gradientTransform
          ? this.gradientTransform.concat()
          : this.gradientTransform,
      };
      return fabric.util.populateWithProperties(this, t, e), t;
    },
    toSVG: function (e, t) {
      var n,
        r,
        o,
        a,
        s = i(this.coords, !0),
        t = t || {},
        c = i(this.colorStops, !0),
        u = s.r1 > s.r2,
        l = this.gradientTransform
          ? this.gradientTransform.concat()
          : fabric.iMatrix.concat(),
        f = -this.offsetX,
        d = -this.offsetY,
        p = !!t.additionalTransform,
        g =
          "pixels" === this.gradientUnits
            ? "userSpaceOnUse"
            : "objectBoundingBox";
      if (
        (c.sort(function (e, t) {
          return e.offset - t.offset;
        }),
        "objectBoundingBox" === g
          ? ((f /= e.width), (d /= e.height))
          : ((f += e.width / 2), (d += e.height / 2)),
        "path" === e.type &&
          "percentage" !== this.gradientUnits &&
          ((f -= e.pathOffset.x), (d -= e.pathOffset.y)),
        (l[4] -= f),
        (l[5] -= d),
        (a = 'id="SVGID_' + this.id + '" gradientUnits="' + g + '"'),
        (a +=
          ' gradientTransform="' +
          (p ? t.additionalTransform + " " : "") +
          fabric.util.matrixToSVG(l) +
          '" '),
        "linear" === this.type
          ? (o = [
              "<linearGradient ",
              a,
              ' x1="',
              s.x1,
              '" y1="',
              s.y1,
              '" x2="',
              s.x2,
              '" y2="',
              s.y2,
              '">\n',
            ])
          : "radial" === this.type &&
            (o = [
              "<radialGradient ",
              a,
              ' cx="',
              u ? s.x1 : s.x2,
              '" cy="',
              u ? s.y1 : s.y2,
              '" r="',
              u ? s.r1 : s.r2,
              '" fx="',
              u ? s.x2 : s.x1,
              '" fy="',
              u ? s.y2 : s.y1,
              '">\n',
            ]),
        "radial" === this.type)
      ) {
        if (u)
          for (c = c.concat(), c.reverse(), n = 0, r = c.length; r > n; n++)
            c[n].offset = 1 - c[n].offset;
        var v = Math.min(s.r1, s.r2);
        if (v > 0) {
          var h = Math.max(s.r1, s.r2),
            m = v / h;
          for (n = 0, r = c.length; r > n; n++)
            c[n].offset += m * (1 - c[n].offset);
        }
      }
      for (n = 0, r = c.length; r > n; n++) {
        var y = c[n];
        o.push(
          "<stop ",
          'offset="',
          100 * y.offset + "%",
          '" style="stop-color:',
          y.color,
          "undefined" != typeof y.opacity ? ";stop-opacity: " + y.opacity : ";",
          '"/>\n'
        );
      }
      return (
        o.push(
          "linear" === this.type ? "</linearGradient>\n" : "</radialGradient>\n"
        ),
        o.join("")
      );
    },
    toLive: function (e) {
      var t,
        n,
        r,
        i = fabric.util.object.clone(this.coords);
      if (this.type) {
        for (
          "linear" === this.type
            ? (t = e.createLinearGradient(i.x1, i.y1, i.x2, i.y2))
            : "radial" === this.type &&
              (t = e.createRadialGradient(i.x1, i.y1, i.r1, i.x2, i.y2, i.r2)),
            n = 0,
            r = this.colorStops.length;
          r > n;
          n++
        ) {
          var o = this.colorStops[n].color,
            a = this.colorStops[n].opacity,
            s = this.colorStops[n].offset;
          "undefined" != typeof a &&
            (o = new fabric.Color(o).setAlpha(a).toRgba()),
            t.addColorStop(s, o);
        }
        return t;
      }
    },
  })),
    fabric.util.object.extend(fabric.Gradient, {
      fromElement: function (i, o, a, s) {
        var c = parseFloat(a) / (/%$/.test(a) ? 100 : 1);
        (c = 0 > c ? 0 : c > 1 ? 1 : c), isNaN(c) && (c = 1);
        var u,
          l,
          f,
          d,
          p = i.getElementsByTagName("stop"),
          g =
            "userSpaceOnUse" === i.getAttribute("gradientUnits")
              ? "pixels"
              : "percentage",
          v = i.getAttribute("gradientTransform") || "",
          h = [],
          m = 0,
          y = 0;
        for (
          "linearGradient" === i.nodeName || "LINEARGRADIENT" === i.nodeName
            ? ((u = "linear"), (l = t(i)))
            : ((u = "radial"), (l = n(i))),
            f = p.length;
          f--;

        )
          h.push(e(p[f], c));
        (d = fabric.parseTransformAttribute(v)),
          r(o, l, s, g),
          "pixels" === g && ((m = -o.left), (y = -o.top));
        var b = new fabric.Gradient({
          id: i.getAttribute("id"),
          type: u,
          coords: l,
          colorStops: h,
          gradientUnits: g,
          gradientTransform: d,
          offsetX: m,
          offsetY: y,
        });
        return b;
      },
    });
})();
!(function () {
  "use strict";
  var e = fabric.util.toFixed;
  fabric.Pattern = fabric.util.createClass({
    repeat: "repeat",
    offsetX: 0,
    offsetY: 0,
    crossOrigin: "",
    patternTransform: null,
    initialize: function (e, t) {
      if (
        (e || (e = {}),
        (this.id = fabric.Object.__uid++),
        this.setOptions(e),
        !e.source || (e.source && "string" != typeof e.source))
      )
        return void (t && t(this));
      var r = this;
      (this.source = fabric.util.createImage()),
        fabric.util.loadImage(
          e.source,
          function (e, n) {
            (r.source = e), t && t(r, n);
          },
          null,
          this.crossOrigin
        );
    },
    toObject: function (t) {
      var r,
        n,
        i = fabric.Object.NUM_FRACTION_DIGITS;
      return (
        "string" == typeof this.source.src
          ? (r = this.source.src)
          : "object" == typeof this.source &&
            this.source.toDataURL &&
            (r = this.source.toDataURL()),
        (n = {
          type: "pattern",
          source: r,
          repeat: this.repeat,
          crossOrigin: this.crossOrigin,
          offsetX: e(this.offsetX, i),
          offsetY: e(this.offsetY, i),
          patternTransform: this.patternTransform
            ? this.patternTransform.concat()
            : null,
        }),
        fabric.util.populateWithProperties(this, n, t),
        n
      );
    },
    toSVG: function (e) {
      var t = "function" == typeof this.source ? this.source() : this.source,
        r = t.width / e.width,
        n = t.height / e.height,
        i = this.offsetX / e.width,
        o = this.offsetY / e.height,
        a = "";
      return (
        ("repeat-x" === this.repeat || "no-repeat" === this.repeat) &&
          ((n = 1), o && (n += Math.abs(o))),
        ("repeat-y" === this.repeat || "no-repeat" === this.repeat) &&
          ((r = 1), i && (r += Math.abs(i))),
        t.src ? (a = t.src) : t.toDataURL && (a = t.toDataURL()),
        '<pattern id="SVGID_' +
          this.id +
          '" x="' +
          i +
          '" y="' +
          o +
          '" width="' +
          r +
          '" height="' +
          n +
          '">\n<image x="0" y="0" width="' +
          t.width +
          '" height="' +
          t.height +
          '" xlink:href="' +
          a +
          '"></image>\n</pattern>\n'
      );
    },
    setOptions: function (e) {
      for (var t in e) this[t] = e[t];
    },
    toLive: function (e) {
      var t = this.source;
      if (!t) return "";
      if ("undefined" != typeof t.src) {
        if (!t.complete) return "";
        if (0 === t.naturalWidth || 0 === t.naturalHeight) return "";
      }
      return e.createPattern(t, this.repeat);
    },
  });
})();
!(function (e) {
  "use strict";
  var t = e.fabric || (e.fabric = {}),
    r = t.util.toFixed;
  return t.Shadow
    ? void t.warn("fabric.Shadow is already defined.")
    : ((t.Shadow = t.util.createClass({
        color: "rgb(0,0,0)",
        blur: 0,
        offsetX: 0,
        offsetY: 0,
        affectStroke: !1,
        includeDefaultValues: !0,
        nonScaling: !1,
        initialize: function (e) {
          "string" == typeof e && (e = this._parseShadow(e));
          for (var r in e) this[r] = e[r];
          this.id = t.Object.__uid++;
        },
        _parseShadow: function (e) {
          var r = e.trim(),
            n = t.Shadow.reOffsetsAndBlur.exec(r) || [],
            i = r.replace(t.Shadow.reOffsetsAndBlur, "") || "rgb(0,0,0)";
          return {
            color: i.trim(),
            offsetX: parseFloat(n[1], 10) || 0,
            offsetY: parseFloat(n[2], 10) || 0,
            blur: parseFloat(n[3], 10) || 0,
          };
        },
        toString: function () {
          return [this.offsetX, this.offsetY, this.blur, this.color].join(
            "px "
          );
        },
        toSVG: function (e) {
          var n = 40,
            i = 40,
            o = t.Object.NUM_FRACTION_DIGITS,
            a = t.util.rotateVector(
              { x: this.offsetX, y: this.offsetY },
              t.util.degreesToRadians(-e.angle)
            ),
            s = 20,
            c = new t.Color(this.color);
          return (
            e.width &&
              e.height &&
              ((n = 100 * r((Math.abs(a.x) + this.blur) / e.width, o) + s),
              (i = 100 * r((Math.abs(a.y) + this.blur) / e.height, o) + s)),
            e.flipX && (a.x *= -1),
            e.flipY && (a.y *= -1),
            '<filter id="SVGID_' +
              this.id +
              '" y="-' +
              i +
              '%" height="' +
              (100 + 2 * i) +
              '%" x="-' +
              n +
              '%" width="' +
              (100 + 2 * n) +
              '%" >\n	<feGaussianBlur in="SourceAlpha" stdDeviation="' +
              r(this.blur ? this.blur / 2 : 0, o) +
              '"></feGaussianBlur>\n	<feOffset dx="' +
              r(a.x, o) +
              '" dy="' +
              r(a.y, o) +
              '" result="oBlur" ></feOffset>\n	<feFlood flood-color="' +
              c.toRgb() +
              '" flood-opacity="' +
              c.getAlpha() +
              '"/>\n	<feComposite in2="oBlur" operator="in" />\n	<feMerge>\n		<feMergeNode></feMergeNode>\n		<feMergeNode in="SourceGraphic"></feMergeNode>\n	</feMerge>\n</filter>\n'
          );
        },
        toObject: function () {
          if (this.includeDefaultValues)
            return {
              color: this.color,
              blur: this.blur,
              offsetX: this.offsetX,
              offsetY: this.offsetY,
              affectStroke: this.affectStroke,
              nonScaling: this.nonScaling,
            };
          var e = {},
            r = t.Shadow.prototype;
          return (
            [
              "color",
              "blur",
              "offsetX",
              "offsetY",
              "affectStroke",
              "nonScaling",
            ].forEach(function (t) {
              this[t] !== r[t] && (e[t] = this[t]);
            }, this),
            e
          );
        },
      })),
      void (t.Shadow.reOffsetsAndBlur =
        /(?:\s|^)(-?\d+(?:\.\d*)?(?:px)?(?:\s?|$))?(-?\d+(?:\.\d*)?(?:px)?(?:\s?|$))?(\d+(?:\.\d*)?(?:px)?)?(?:\s?|$)(?:$|\s)/));
})("undefined" != typeof exports ? exports : this);
!(function () {
  "use strict";
  if (fabric.StaticCanvas)
    return void fabric.warn("fabric.StaticCanvas is already defined.");
  var e = fabric.util.object.extend,
    t = fabric.util.getElementOffset,
    r = fabric.util.removeFromArray,
    n = fabric.util.toFixed,
    i = fabric.util.transformPoint,
    o = fabric.util.invertTransform,
    a = fabric.util.getNodeCanvas,
    s = fabric.util.createCanvasElement,
    c = new Error("Could not initialize `canvas` element");
  (fabric.StaticCanvas = fabric.util.createClass(fabric.CommonMethods, {
    initialize: function (e, t) {
      t || (t = {}),
        (this.renderAndResetBound = this.renderAndReset.bind(this)),
        (this.requestRenderAllBound = this.requestRenderAll.bind(this)),
        this._initStatic(e, t);
    },
    backgroundColor: "",
    backgroundImage: null,
    overlayColor: "",
    overlayImage: null,
    includeDefaultValues: !0,
    stateful: !1,
    renderOnAddRemove: !0,
    controlsAboveOverlay: !1,
    allowTouchScrolling: !1,
    imageSmoothingEnabled: !0,
    viewportTransform: fabric.iMatrix.concat(),
    backgroundVpt: !0,
    overlayVpt: !0,
    enableRetinaScaling: !0,
    vptCoords: {},
    skipOffscreen: !0,
    clipPath: void 0,
    _initStatic: function (e, t) {
      var r = this.requestRenderAllBound;
      (this._objects = []),
        this._createLowerCanvas(e),
        this._initOptions(t),
        this.interactive || this._initRetinaScaling(),
        t.overlayImage && this.setOverlayImage(t.overlayImage, r),
        t.backgroundImage && this.setBackgroundImage(t.backgroundImage, r),
        t.backgroundColor && this.setBackgroundColor(t.backgroundColor, r),
        t.overlayColor && this.setOverlayColor(t.overlayColor, r),
        this.calcOffset();
    },
    _isRetinaScaling: function () {
      return fabric.devicePixelRatio > 1 && this.enableRetinaScaling;
    },
    getRetinaScaling: function () {
      return this._isRetinaScaling() ? Math.max(1, fabric.devicePixelRatio) : 1;
    },
    _initRetinaScaling: function () {
      if (this._isRetinaScaling()) {
        var e = fabric.devicePixelRatio;
        this.__initRetinaScaling(e, this.lowerCanvasEl, this.contextContainer),
          this.upperCanvasEl &&
            this.__initRetinaScaling(e, this.upperCanvasEl, this.contextTop);
      }
    },
    __initRetinaScaling: function (e, t, r) {
      t.setAttribute("width", this.width * e),
        t.setAttribute("height", this.height * e),
        r.scale(e, e);
    },
    calcOffset: function () {
      return (this._offset = t(this.lowerCanvasEl)), this;
    },
    setOverlayImage: function (e, t, r) {
      return this.__setBgOverlayImage("overlayImage", e, t, r);
    },
    setBackgroundImage: function (e, t, r) {
      return this.__setBgOverlayImage("backgroundImage", e, t, r);
    },
    setOverlayColor: function (e, t) {
      return this.__setBgOverlayColor("overlayColor", e, t);
    },
    setBackgroundColor: function (e, t) {
      return this.__setBgOverlayColor("backgroundColor", e, t);
    },
    __setBgOverlayImage: function (e, t, r, n) {
      return (
        "string" == typeof t
          ? fabric.util.loadImage(
              t,
              function (t, i) {
                if (t) {
                  var o = new fabric.Image(t, n);
                  (this[e] = o), (o.canvas = this);
                }
                r && r(t, i);
              },
              this,
              n && n.crossOrigin
            )
          : (n && t.setOptions(n),
            (this[e] = t),
            t && (t.canvas = this),
            r && r(t, !1)),
        this
      );
    },
    __setBgOverlayColor: function (e, t, r) {
      return (
        (this[e] = t),
        this._initGradient(t, e),
        this._initPattern(t, e, r),
        this
      );
    },
    _createCanvasElement: function () {
      var e = s();
      if (!e) throw c;
      if ((e.style || (e.style = {}), "undefined" == typeof e.getContext))
        throw c;
      return e;
    },
    _initOptions: function (e) {
      var t = this.lowerCanvasEl;
      this._setOptions(e),
        (this.width = this.width || parseInt(t.width, 10) || 0),
        (this.height = this.height || parseInt(t.height, 10) || 0),
        this.lowerCanvasEl.style &&
          ((t.width = this.width),
          (t.height = this.height),
          (t.style.width = this.width + "px"),
          (t.style.height = this.height + "px"),
          (this.viewportTransform = this.viewportTransform.slice()));
    },
    _createLowerCanvas: function (e) {
      (this.lowerCanvasEl =
        e && e.getContext
          ? e
          : fabric.util.getById(e) || this._createCanvasElement()),
        fabric.util.addClass(this.lowerCanvasEl, "lower-canvas"),
        (this._originalCanvasStyle = this.lowerCanvasEl.style),
        this.interactive && this._applyCanvasStyle(this.lowerCanvasEl),
        (this.contextContainer = this.lowerCanvasEl.getContext("2d"));
    },
    getWidth: function () {
      return this.width;
    },
    getHeight: function () {
      return this.height;
    },
    setWidth: function (e, t) {
      return this.setDimensions({ width: e }, t);
    },
    setHeight: function (e, t) {
      return this.setDimensions({ height: e }, t);
    },
    setDimensions: function (e, t) {
      var r;
      t = t || {};
      for (var n in e)
        (r = e[n]),
          t.cssOnly ||
            (this._setBackstoreDimension(n, e[n]),
            (r += "px"),
            (this.hasLostContext = !0)),
          t.backstoreOnly || this._setCssDimension(n, r);
      return (
        this._isCurrentlyDrawing &&
          this.freeDrawingBrush &&
          this.freeDrawingBrush._setBrushStyles(this.contextTop),
        this._initRetinaScaling(),
        this.calcOffset(),
        t.cssOnly || this.requestRenderAll(),
        this
      );
    },
    _setBackstoreDimension: function (e, t) {
      return (
        (this.lowerCanvasEl[e] = t),
        this.upperCanvasEl && (this.upperCanvasEl[e] = t),
        this.cacheCanvasEl && (this.cacheCanvasEl[e] = t),
        (this[e] = t),
        this
      );
    },
    _setCssDimension: function (e, t) {
      return (
        (this.lowerCanvasEl.style[e] = t),
        this.upperCanvasEl && (this.upperCanvasEl.style[e] = t),
        this.wrapperEl && (this.wrapperEl.style[e] = t),
        this
      );
    },
    getZoom: function () {
      return this.viewportTransform[0];
    },
    setViewportTransform: function (e) {
      var t,
        r,
        n,
        i = this._activeObject,
        o = this.backgroundImage,
        a = this.overlayImage;
      for (
        this.viewportTransform = e, r = 0, n = this._objects.length;
        n > r;
        r++
      )
        (t = this._objects[r]), t.group || t.setCoords(!0);
      return (
        i && i.setCoords(),
        o && o.setCoords(!0),
        a && a.setCoords(!0),
        this.calcViewportBoundaries(),
        this.renderOnAddRemove && this.requestRenderAll(),
        this
      );
    },
    zoomToPoint: function (e, t) {
      var r = e,
        n = this.viewportTransform.slice(0);
      (e = i(e, o(this.viewportTransform))), (n[0] = t), (n[3] = t);
      var a = i(e, n);
      return (
        (n[4] += r.x - a.x), (n[5] += r.y - a.y), this.setViewportTransform(n)
      );
    },
    setZoom: function (e) {
      return this.zoomToPoint(new fabric.Point(0, 0), e), this;
    },
    absolutePan: function (e) {
      var t = this.viewportTransform.slice(0);
      return (t[4] = -e.x), (t[5] = -e.y), this.setViewportTransform(t);
    },
    relativePan: function (e) {
      return this.absolutePan(
        new fabric.Point(
          -e.x - this.viewportTransform[4],
          -e.y - this.viewportTransform[5]
        )
      );
    },
    getElement: function () {
      return this.lowerCanvasEl;
    },
    _onObjectAdded: function (e) {
      this.stateful && e.setupState(),
        e._set("canvas", this),
        e.setCoords(),
        this.fire("object:added", { target: e }),
        e.fire("added");
    },
    _onObjectRemoved: function (e) {
      this.fire("object:removed", { target: e }),
        e.fire("removed"),
        delete e.canvas;
    },
    clearContext: function (e) {
      return e.clearRect(0, 0, this.width, this.height), this;
    },
    getContext: function () {
      return this.contextContainer;
    },
    clear: function () {
      return (
        this.remove.apply(this, this.getObjects()),
        (this.backgroundImage = null),
        (this.overlayImage = null),
        (this.backgroundColor = ""),
        (this.overlayColor = ""),
        this._hasITextHandlers &&
          (this.off("mouse:up", this._mouseUpITextHandler),
          (this._iTextInstances = null),
          (this._hasITextHandlers = !1)),
        this.clearContext(this.contextContainer),
        this.fire("canvas:cleared"),
        this.renderOnAddRemove && this.requestRenderAll(),
        this
      );
    },
    renderAll: function () {
      var e = this.contextContainer;
      return this.renderCanvas(e, this._objects), this;
    },
    renderAndReset: function () {
      (this.isRendering = 0), this.renderAll();
    },
    requestRenderAll: function () {
      return (
        this.isRendering ||
          (this.isRendering = fabric.util.requestAnimFrame(
            this.renderAndResetBound
          )),
        this
      );
    },
    calcViewportBoundaries: function () {
      var e = {},
        t = this.width,
        r = this.height,
        n = o(this.viewportTransform);
      return (
        (e.tl = i({ x: 0, y: 0 }, n)),
        (e.br = i({ x: t, y: r }, n)),
        (e.tr = new fabric.Point(e.br.x, e.tl.y)),
        (e.bl = new fabric.Point(e.tl.x, e.br.y)),
        (this.vptCoords = e),
        e
      );
    },
    cancelRequestedRender: function () {
      this.isRendering &&
        (fabric.util.cancelAnimFrame(this.isRendering), (this.isRendering = 0));
    },
    renderCanvas: function (e, t) {
      var r = this.viewportTransform,
        n = this.clipPath;
      this.cancelRequestedRender(),
        this.calcViewportBoundaries(),
        this.clearContext(e),
        fabric.util.setImageSmoothing(e, this.imageSmoothingEnabled),
        this.fire("before:render", { ctx: e }),
        this._renderBackground(e),
        e.save(),
        e.transform(r[0], r[1], r[2], r[3], r[4], r[5]),
        this._renderObjects(e, t),
        e.restore(),
        !this.controlsAboveOverlay && this.interactive && this.drawControls(e),
        n &&
          ((n.canvas = this),
          n.shouldCache(),
          (n._transformDone = !0),
          n.renderCache({ forClipping: !0 }),
          this.drawClipPathOnCanvas(e)),
        this._renderOverlay(e),
        this.controlsAboveOverlay && this.interactive && this.drawControls(e),
        this.fire("after:render", { ctx: e });
    },
    drawClipPathOnCanvas: function (e) {
      var t = this.viewportTransform,
        r = this.clipPath;
      e.save(),
        e.transform(t[0], t[1], t[2], t[3], t[4], t[5]),
        (e.globalCompositeOperation = "destination-in"),
        r.transform(e),
        e.scale(1 / r.zoomX, 1 / r.zoomY),
        e.drawImage(r._cacheCanvas, -r.cacheTranslationX, -r.cacheTranslationY),
        e.restore();
    },
    _renderObjects: function (e, t) {
      var r, n;
      for (r = 0, n = t.length; n > r; ++r) t[r] && t[r].render(e);
    },
    _renderBackgroundOrOverlay: function (e, t) {
      var r = this[t + "Color"],
        n = this[t + "Image"],
        i = this.viewportTransform,
        o = this[t + "Vpt"];
      if (r || n) {
        if (r) {
          e.save(),
            e.beginPath(),
            e.moveTo(0, 0),
            e.lineTo(this.width, 0),
            e.lineTo(this.width, this.height),
            e.lineTo(0, this.height),
            e.closePath(),
            (e.fillStyle = r.toLive ? r.toLive(e, this) : r),
            o && e.transform(i[0], i[1], i[2], i[3], i[4], i[5]),
            e.transform(1, 0, 0, 1, r.offsetX || 0, r.offsetY || 0);
          var a = r.gradientTransform || r.patternTransform;
          a && e.transform(a[0], a[1], a[2], a[3], a[4], a[5]),
            e.fill(),
            e.restore();
        }
        n &&
          (e.save(),
          o && e.transform(i[0], i[1], i[2], i[3], i[4], i[5]),
          n.render(e),
          e.restore());
      }
    },
    _renderBackground: function (e) {
      this._renderBackgroundOrOverlay(e, "background");
    },
    _renderOverlay: function (e) {
      this._renderBackgroundOrOverlay(e, "overlay");
    },
    getCenter: function () {
      return { top: this.height / 2, left: this.width / 2 };
    },
    getCenterPoint: function () {
      return new fabric.Point(this.width / 2, this.height / 2);
    },
    centerObjectH: function (e) {
      return this._centerObject(
        e,
        new fabric.Point(this.getCenterPoint().x, e.getCenterPoint().y)
      );
    },
    centerObjectV: function (e) {
      return this._centerObject(
        e,
        new fabric.Point(e.getCenterPoint().x, this.getCenterPoint().y)
      );
    },
    centerObject: function (e) {
      var t = this.getCenterPoint();
      return this._centerObject(e, t);
    },
    viewportCenterObject: function (e) {
      var t = this.getVpCenter();
      return this._centerObject(e, t);
    },
    viewportCenterObjectH: function (e) {
      var t = this.getVpCenter();
      return (
        this._centerObject(e, new fabric.Point(t.x, e.getCenterPoint().y)), this
      );
    },
    viewportCenterObjectV: function (e) {
      var t = this.getVpCenter();
      return this._centerObject(e, new fabric.Point(e.getCenterPoint().x, t.y));
    },
    getVpCenter: function () {
      var e = this.getCenterPoint(),
        t = o(this.viewportTransform);
      return i(e, t);
    },
    _centerObject: function (e, t) {
      return (
        e.setPositionByOrigin(t, "center", "center"),
        e.setCoords(),
        this.renderOnAddRemove && this.requestRenderAll(),
        this
      );
    },
    toDatalessJSON: function (e) {
      return this.toDatalessObject(e);
    },
    toObject: function (e) {
      return this._toObjectMethod("toObject", e);
    },
    toDatalessObject: function (e) {
      return this._toObjectMethod("toDatalessObject", e);
    },
    _toObjectMethod: function (t, r) {
      var n = this.clipPath,
        i = { version: fabric.version, objects: this._toObjects(t, r) };
      return (
        n &&
          !n.excludeFromExport &&
          (i.clipPath = this._toObject(this.clipPath, t, r)),
        e(i, this.__serializeBgOverlay(t, r)),
        fabric.util.populateWithProperties(this, i, r),
        i
      );
    },
    _toObjects: function (e, t) {
      return this._objects
        .filter(function (e) {
          return !e.excludeFromExport;
        })
        .map(function (r) {
          return this._toObject(r, e, t);
        }, this);
    },
    _toObject: function (e, t, r) {
      var n;
      this.includeDefaultValues ||
        ((n = e.includeDefaultValues), (e.includeDefaultValues = !1));
      var i = e[t](r);
      return this.includeDefaultValues || (e.includeDefaultValues = n), i;
    },
    __serializeBgOverlay: function (e, t) {
      var r = {},
        n = this.backgroundImage,
        i = this.overlayImage,
        o = this.backgroundColor,
        a = this.overlayColor;
      return (
        o && o.toObject
          ? o.excludeFromExport || (r.background = o.toObject(t))
          : o && (r.background = o),
        a && a.toObject
          ? a.excludeFromExport || (r.overlay = a.toObject(t))
          : a && (r.overlay = a),
        n &&
          !n.excludeFromExport &&
          (r.backgroundImage = this._toObject(n, e, t)),
        i && !i.excludeFromExport && (r.overlayImage = this._toObject(i, e, t)),
        r
      );
    },
    svgViewportTransformation: !0,
    toSVG: function (e, t) {
      e || (e = {}), (e.reviver = t);
      var r = [];
      return (
        this._setSVGPreamble(r, e),
        this._setSVGHeader(r, e),
        this.clipPath &&
          r.push('<g clip-path="url(#' + this.clipPath.clipPathId + ')" >\n'),
        this._setSVGBgOverlayColor(r, "background"),
        this._setSVGBgOverlayImage(r, "backgroundImage", t),
        this._setSVGObjects(r, t),
        this.clipPath && r.push("</g>\n"),
        this._setSVGBgOverlayColor(r, "overlay"),
        this._setSVGBgOverlayImage(r, "overlayImage", t),
        r.push("</svg>"),
        r.join("")
      );
    },
    _setSVGPreamble: function (e, t) {
      t.suppressPreamble ||
        e.push(
          '<?xml version="1.0" encoding="',
          t.encoding || "UTF-8",
          '" standalone="no" ?>\n',
          '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" ',
          '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
        );
    },
    _setSVGHeader: function (e, t) {
      var r,
        i = t.width || this.width,
        o = t.height || this.height,
        a = 'viewBox="0 0 ' + this.width + " " + this.height + '" ',
        s = fabric.Object.NUM_FRACTION_DIGITS;
      t.viewBox
        ? (a =
            'viewBox="' +
            t.viewBox.x +
            " " +
            t.viewBox.y +
            " " +
            t.viewBox.width +
            " " +
            t.viewBox.height +
            '" ')
        : this.svgViewportTransformation &&
          ((r = this.viewportTransform),
          (a =
            'viewBox="' +
            n(-r[4] / r[0], s) +
            " " +
            n(-r[5] / r[3], s) +
            " " +
            n(this.width / r[0], s) +
            " " +
            n(this.height / r[3], s) +
            '" ')),
        e.push(
          "<svg ",
          'xmlns="http://www.w3.org/2000/svg" ',
          'xmlns:xlink="http://www.w3.org/1999/xlink" ',
          'version="1.1" ',
          'width="',
          i,
          '" ',
          'height="',
          o,
          '" ',
          a,
          'xml:space="preserve">\n',
          "<desc>Created with Fabric.js ",
          fabric.version,
          "</desc>\n",
          "<defs>\n",
          this.createSVGFontFacesMarkup(),
          this.createSVGRefElementsMarkup(),
          this.createSVGClipPathMarkup(t),
          "</defs>\n"
        );
    },
    createSVGClipPathMarkup: function (e) {
      var t = this.clipPath;
      return t
        ? ((t.clipPathId = "CLIPPATH_" + fabric.Object.__uid++),
          '<clipPath id="' +
            t.clipPathId +
            '" >\n' +
            this.clipPath.toClipPathSVG(e.reviver) +
            "</clipPath>\n")
        : "";
    },
    createSVGRefElementsMarkup: function () {
      var e = this,
        t = ["background", "overlay"].map(function (t) {
          var r = e[t + "Color"];
          if (r && r.toLive) {
            var n = e[t + "Vpt"],
              i = e.viewportTransform,
              o = {
                width: e.width / (n ? i[0] : 1),
                height: e.height / (n ? i[3] : 1),
              };
            return r.toSVG(o, {
              additionalTransform: n ? fabric.util.matrixToSVG(i) : "",
            });
          }
        });
      return t.join("");
    },
    createSVGFontFacesMarkup: function () {
      var e,
        t,
        r,
        n,
        i,
        o,
        a,
        s,
        c,
        u = "",
        l = {},
        f = fabric.fontPaths,
        h = [];
      for (
        this._objects.forEach(function p(e) {
          h.push(e), e._objects && e._objects.forEach(p);
        }),
          s = 0,
          c = h.length;
        c > s;
        s++
      )
        if (
          ((e = h[s]),
          (t = e.fontFamily),
          -1 !== e.type.indexOf("text") &&
            !l[t] &&
            f[t] &&
            ((l[t] = !0), e.styles))
        ) {
          r = e.styles;
          for (i in r) {
            n = r[i];
            for (a in n)
              (o = n[a]), (t = o.fontFamily), !l[t] && f[t] && (l[t] = !0);
          }
        }
      for (var d in l)
        u += [
          "		@font-face {\n",
          "			font-family: '",
          d,
          "';\n",
          "			src: url('",
          f[d],
          "');\n",
          "		}\n",
        ].join("");
      return (
        u &&
          (u = [
            '	<style type="text/css">',
            "<![CDATA[\n",
            u,
            "]]>",
            "</style>\n",
          ].join("")),
        u
      );
    },
    _setSVGObjects: function (e, t) {
      var r,
        n,
        i,
        o = this._objects;
      for (n = 0, i = o.length; i > n; n++)
        (r = o[n]), r.excludeFromExport || this._setSVGObject(e, r, t);
    },
    _setSVGObject: function (e, t, r) {
      e.push(t.toSVG(r));
    },
    _setSVGBgOverlayImage: function (e, t, r) {
      this[t] &&
        !this[t].excludeFromExport &&
        this[t].toSVG &&
        e.push(this[t].toSVG(r));
    },
    _setSVGBgOverlayColor: function (e, t) {
      var r = this[t + "Color"],
        n = this.viewportTransform,
        i = this.width,
        o = this.height;
      if (r)
        if (r.toLive) {
          var a = r.repeat,
            s = fabric.util.invertTransform(n),
            c = this[t + "Vpt"],
            u = c ? fabric.util.matrixToSVG(s) : "";
          e.push(
            '<rect transform="' + u + " translate(",
            i / 2,
            ",",
            o / 2,
            ')"',
            ' x="',
            r.offsetX - i / 2,
            '" y="',
            r.offsetY - o / 2,
            '" ',
            'width="',
            "repeat-y" === a || "no-repeat" === a ? r.source.width : i,
            '" height="',
            "repeat-x" === a || "no-repeat" === a ? r.source.height : o,
            '" fill="url(#SVGID_' + r.id + ')"',
            "></rect>\n"
          );
        } else
          e.push(
            '<rect x="0" y="0" width="100%" height="100%" ',
            'fill="',
            r,
            '"',
            "></rect>\n"
          );
    },
    sendToBack: function (e) {
      if (!e) return this;
      var t,
        n,
        i,
        o = this._activeObject;
      if (e === o && "activeSelection" === e.type)
        for (i = o._objects, t = i.length; t--; )
          (n = i[t]), r(this._objects, n), this._objects.unshift(n);
      else r(this._objects, e), this._objects.unshift(e);
      return this.renderOnAddRemove && this.requestRenderAll(), this;
    },
    bringToFront: function (e) {
      if (!e) return this;
      var t,
        n,
        i,
        o = this._activeObject;
      if (e === o && "activeSelection" === e.type)
        for (i = o._objects, t = 0; t < i.length; t++)
          (n = i[t]), r(this._objects, n), this._objects.push(n);
      else r(this._objects, e), this._objects.push(e);
      return this.renderOnAddRemove && this.requestRenderAll(), this;
    },
    sendBackwards: function (e, t) {
      if (!e) return this;
      var n,
        i,
        o,
        a,
        s,
        c = this._activeObject,
        u = 0;
      if (e === c && "activeSelection" === e.type)
        for (s = c._objects, n = 0; n < s.length; n++)
          (i = s[n]),
            (o = this._objects.indexOf(i)),
            o > 0 + u &&
              ((a = o - 1), r(this._objects, i), this._objects.splice(a, 0, i)),
            u++;
      else
        (o = this._objects.indexOf(e)),
          0 !== o &&
            ((a = this._findNewLowerIndex(e, o, t)),
            r(this._objects, e),
            this._objects.splice(a, 0, e));
      return this.renderOnAddRemove && this.requestRenderAll(), this;
    },
    _findNewLowerIndex: function (e, t, r) {
      var n, i;
      if (r)
        for (n = t, i = t - 1; i >= 0; --i) {
          var o =
            e.intersectsWithObject(this._objects[i]) ||
            e.isContainedWithinObject(this._objects[i]) ||
            this._objects[i].isContainedWithinObject(e);
          if (o) {
            n = i;
            break;
          }
        }
      else n = t - 1;
      return n;
    },
    bringForward: function (e, t) {
      if (!e) return this;
      var n,
        i,
        o,
        a,
        s,
        c = this._activeObject,
        u = 0;
      if (e === c && "activeSelection" === e.type)
        for (s = c._objects, n = s.length; n--; )
          (i = s[n]),
            (o = this._objects.indexOf(i)),
            o < this._objects.length - 1 - u &&
              ((a = o + 1), r(this._objects, i), this._objects.splice(a, 0, i)),
            u++;
      else
        (o = this._objects.indexOf(e)),
          o !== this._objects.length - 1 &&
            ((a = this._findNewUpperIndex(e, o, t)),
            r(this._objects, e),
            this._objects.splice(a, 0, e));
      return this.renderOnAddRemove && this.requestRenderAll(), this;
    },
    _findNewUpperIndex: function (e, t, r) {
      var n, i, o;
      if (r)
        for (n = t, i = t + 1, o = this._objects.length; o > i; ++i) {
          var a =
            e.intersectsWithObject(this._objects[i]) ||
            e.isContainedWithinObject(this._objects[i]) ||
            this._objects[i].isContainedWithinObject(e);
          if (a) {
            n = i;
            break;
          }
        }
      else n = t + 1;
      return n;
    },
    moveTo: function (e, t) {
      return (
        r(this._objects, e),
        this._objects.splice(t, 0, e),
        this.renderOnAddRemove && this.requestRenderAll()
      );
    },
    dispose: function () {
      return (
        this.isRendering &&
          (fabric.util.cancelAnimFrame(this.isRendering),
          (this.isRendering = 0)),
        this.forEachObject(function (e) {
          e.dispose && e.dispose();
        }),
        (this._objects = []),
        this.backgroundImage &&
          this.backgroundImage.dispose &&
          this.backgroundImage.dispose(),
        (this.backgroundImage = null),
        this.overlayImage &&
          this.overlayImage.dispose &&
          this.overlayImage.dispose(),
        (this.overlayImage = null),
        (this._iTextInstances = null),
        (this.contextContainer = null),
        this.lowerCanvasEl.classList.remove("lower-canvas"),
        fabric.util.setStyle(this.lowerCanvasEl, this._originalCanvasStyle),
        delete this._originalCanvasStyle,
        this.lowerCanvasEl.setAttribute("width", this.width),
        this.lowerCanvasEl.setAttribute("height", this.height),
        fabric.util.cleanUpJsdomNode(this.lowerCanvasEl),
        (this.lowerCanvasEl = void 0),
        this
      );
    },
    toString: function () {
      return (
        "#<fabric.Canvas (" +
        this.complexity() +
        "): { objects: " +
        this._objects.length +
        " }>"
      );
    },
  })),
    e(fabric.StaticCanvas.prototype, fabric.Observable),
    e(fabric.StaticCanvas.prototype, fabric.Collection),
    e(fabric.StaticCanvas.prototype, fabric.DataURLExporter),
    e(fabric.StaticCanvas, {
      EMPTY_JSON: '{"objects": [], "background": "white"}',
      supports: function (e) {
        var t = s();
        if (!t || !t.getContext) return null;
        var r = t.getContext("2d");
        if (!r) return null;
        switch (e) {
          case "setLineDash":
            return "undefined" != typeof r.setLineDash;
          default:
            return null;
        }
      },
    }),
    (fabric.StaticCanvas.prototype.toJSON =
      fabric.StaticCanvas.prototype.toObject),
    fabric.isLikelyNode &&
      ((fabric.StaticCanvas.prototype.createPNGStream = function () {
        var e = a(this.lowerCanvasEl);
        return e && e.createPNGStream();
      }),
      (fabric.StaticCanvas.prototype.createJPEGStream = function (e) {
        var t = a(this.lowerCanvasEl);
        return t && t.createJPEGStream(e);
      }));
})();
fabric.BaseBrush = fabric.util.createClass({
  color: "rgb(0, 0, 0)",
  width: 1,
  shadow: null,
  strokeLineCap: "round",
  strokeLineJoin: "round",
  strokeMiterLimit: 10,
  strokeDashArray: null,
  limitedToCanvasSize: !1,
  _setBrushStyles: function (e) {
    (e.strokeStyle = this.color),
      (e.lineWidth = this.width),
      (e.lineCap = this.strokeLineCap),
      (e.miterLimit = this.strokeMiterLimit),
      (e.lineJoin = this.strokeLineJoin),
      e.setLineDash(this.strokeDashArray || []);
  },
  _saveAndTransform: function (e) {
    var t = this.canvas.viewportTransform;
    e.save(), e.transform(t[0], t[1], t[2], t[3], t[4], t[5]);
  },
  _setShadow: function () {
    if (this.shadow) {
      var e = this.canvas,
        t = this.shadow,
        r = e.contextTop,
        n = e.getZoom();
      e && e._isRetinaScaling() && (n *= fabric.devicePixelRatio),
        (r.shadowColor = t.color),
        (r.shadowBlur = t.blur * n),
        (r.shadowOffsetX = t.offsetX * n),
        (r.shadowOffsetY = t.offsetY * n);
    }
  },
  needsFullRender: function () {
    var e = new fabric.Color(this.color);
    return e.getAlpha() < 1 || !!this.shadow;
  },
  _resetShadow: function () {
    var e = this.canvas.contextTop;
    (e.shadowColor = ""),
      (e.shadowBlur = e.shadowOffsetX = e.shadowOffsetY = 0);
  },
  _isOutSideCanvas: function (e) {
    return (
      e.x < 0 ||
      e.x > this.canvas.getWidth() ||
      e.y < 0 ||
      e.y > this.canvas.getHeight()
    );
  },
});
!(function () {
  fabric.PencilBrush = fabric.util.createClass(fabric.BaseBrush, {
    decimate: 0.4,
    drawStraightLine: !1,
    straightLineKey: "shiftKey",
    initialize: function (e) {
      (this.canvas = e), (this._points = []);
    },
    needsFullRender: function () {
      return this.callSuper("needsFullRender") || this._hasStraightLine;
    },
    _drawSegment: function (e, t, r) {
      var n = t.midPointFrom(r);
      return e.quadraticCurveTo(t.x, t.y, n.x, n.y), n;
    },
    onMouseDown: function (e, t) {
      this.canvas._isMainEvent(t.e) &&
        ((this.drawStraightLine = t.e[this.straightLineKey]),
        this._prepareForDrawing(e),
        this._captureDrawingPath(e),
        this._render());
    },
    onMouseMove: function (e, t) {
      if (
        this.canvas._isMainEvent(t.e) &&
        ((this.drawStraightLine = t.e[this.straightLineKey]),
        (this.limitedToCanvasSize !== !0 || !this._isOutSideCanvas(e)) &&
          this._captureDrawingPath(e) &&
          this._points.length > 1)
      )
        if (this.needsFullRender())
          this.canvas.clearContext(this.canvas.contextTop), this._render();
        else {
          var r = this._points,
            n = r.length,
            i = this.canvas.contextTop;
          this._saveAndTransform(i),
            this.oldEnd &&
              (i.beginPath(), i.moveTo(this.oldEnd.x, this.oldEnd.y)),
            (this.oldEnd = this._drawSegment(i, r[n - 2], r[n - 1], !0)),
            i.stroke(),
            i.restore();
        }
    },
    onMouseUp: function (e) {
      return this.canvas._isMainEvent(e.e)
        ? ((this.drawStraightLine = !1),
          (this.oldEnd = void 0),
          this._finalizeAndAddPath(),
          !1)
        : !0;
    },
    _prepareForDrawing: function (e) {
      var t = new fabric.Point(e.x, e.y);
      this._reset(), this._addPoint(t), this.canvas.contextTop.moveTo(t.x, t.y);
    },
    _addPoint: function (e) {
      return this._points.length > 1 &&
        e.eq(this._points[this._points.length - 1])
        ? !1
        : (this.drawStraightLine &&
            this._points.length > 1 &&
            ((this._hasStraightLine = !0), this._points.pop()),
          this._points.push(e),
          !0);
    },
    _reset: function () {
      (this._points = []),
        this._setBrushStyles(this.canvas.contextTop),
        this._setShadow(),
        (this._hasStraightLine = !1);
    },
    _captureDrawingPath: function (e) {
      var t = new fabric.Point(e.x, e.y);
      return this._addPoint(t);
    },
    _render: function (e) {
      var t,
        r,
        n = this._points[0],
        i = this._points[1];
      if (
        ((e = e || this.canvas.contextTop),
        this._saveAndTransform(e),
        e.beginPath(),
        2 === this._points.length && n.x === i.x && n.y === i.y)
      ) {
        var o = this.width / 1e3;
        (n = new fabric.Point(n.x, n.y)),
          (i = new fabric.Point(i.x, i.y)),
          (n.x -= o),
          (i.x += o);
      }
      for (e.moveTo(n.x, n.y), t = 1, r = this._points.length; r > t; t++)
        this._drawSegment(e, n, i),
          (n = this._points[t]),
          (i = this._points[t + 1]);
      e.lineTo(n.x, n.y), e.stroke(), e.restore();
    },
    convertPointsToSVGPath: function (e) {
      var t = this.width / 1e3;
      return fabric.util.getSmoothPathFromPoints(e, t);
    },
    _isEmptySVGPath: function (e) {
      var t = fabric.util.joinPath(e);
      return "M 0 0 Q 0 0 0 0 L 0 0" === t;
    },
    createPath: function (e) {
      var t = new fabric.Path(e, {
        fill: null,
        stroke: this.color,
        strokeWidth: this.width,
        strokeLineCap: this.strokeLineCap,
        strokeMiterLimit: this.strokeMiterLimit,
        strokeLineJoin: this.strokeLineJoin,
        strokeDashArray: this.strokeDashArray,
      });
      return (
        this.shadow &&
          ((this.shadow.affectStroke = !0),
          (t.shadow = new fabric.Shadow(this.shadow))),
        t
      );
    },
    decimatePoints: function (e, t) {
      if (e.length <= 2) return e;
      var r,
        n,
        i = this.canvas.getZoom(),
        o = Math.pow(t / i, 2),
        a = e.length - 1,
        s = e[0],
        c = [s];
      for (r = 1; a - 1 > r; r++)
        (n = Math.pow(s.x - e[r].x, 2) + Math.pow(s.y - e[r].y, 2)),
          n >= o && ((s = e[r]), c.push(s));
      return c.push(e[a]), c;
    },
    _finalizeAndAddPath: function () {
      var e = this.canvas.contextTop;
      e.closePath(),
        this.decimate &&
          (this._points = this.decimatePoints(this._points, this.decimate));
      var t = this.convertPointsToSVGPath(this._points);
      if (this._isEmptySVGPath(t)) return void this.canvas.requestRenderAll();
      var r = this.createPath(t);
      this.canvas.clearContext(this.canvas.contextTop),
        this.canvas.fire("before:path:created", { path: r }),
        this.canvas.add(r),
        this.canvas.requestRenderAll(),
        r.setCoords(),
        this._resetShadow(),
        this.canvas.fire("path:created", { path: r });
    },
  });
})();
fabric.CircleBrush = fabric.util.createClass(fabric.BaseBrush, {
  width: 10,
  initialize: function (e) {
    (this.canvas = e), (this.points = []);
  },
  drawDot: function (e) {
    var t = this.addPoint(e),
      r = this.canvas.contextTop;
    this._saveAndTransform(r), this.dot(r, t), r.restore();
  },
  dot: function (e, t) {
    (e.fillStyle = t.fill),
      e.beginPath(),
      e.arc(t.x, t.y, t.radius, 0, 2 * Math.PI, !1),
      e.closePath(),
      e.fill();
  },
  onMouseDown: function (e) {
    (this.points.length = 0),
      this.canvas.clearContext(this.canvas.contextTop),
      this._setShadow(),
      this.drawDot(e);
  },
  _render: function () {
    var e,
      t,
      r = this.canvas.contextTop,
      n = this.points;
    for (this._saveAndTransform(r), e = 0, t = n.length; t > e; e++)
      this.dot(r, n[e]);
    r.restore();
  },
  onMouseMove: function (e) {
    (this.limitedToCanvasSize === !0 && this._isOutSideCanvas(e)) ||
      (this.needsFullRender()
        ? (this.canvas.clearContext(this.canvas.contextTop),
          this.addPoint(e),
          this._render())
        : this.drawDot(e));
  },
  onMouseUp: function () {
    var e,
      t,
      r = this.canvas.renderOnAddRemove;
    this.canvas.renderOnAddRemove = !1;
    var n = [];
    for (e = 0, t = this.points.length; t > e; e++) {
      var i = this.points[e],
        o = new fabric.Circle({
          radius: i.radius,
          left: i.x,
          top: i.y,
          originX: "center",
          originY: "center",
          fill: i.fill,
        });
      this.shadow && (o.shadow = new fabric.Shadow(this.shadow)), n.push(o);
    }
    var a = new fabric.Group(n);
    (a.canvas = this.canvas),
      this.canvas.fire("before:path:created", { path: a }),
      this.canvas.add(a),
      this.canvas.fire("path:created", { path: a }),
      this.canvas.clearContext(this.canvas.contextTop),
      this._resetShadow(),
      (this.canvas.renderOnAddRemove = r),
      this.canvas.requestRenderAll();
  },
  addPoint: function (e) {
    var t = new fabric.Point(e.x, e.y),
      r =
        fabric.util.getRandomInt(
          Math.max(0, this.width - 20),
          this.width + 20
        ) / 2,
      n = new fabric.Color(this.color)
        .setAlpha(fabric.util.getRandomInt(0, 100) / 100)
        .toRgba();
    return (t.radius = r), (t.fill = n), this.points.push(t), t;
  },
});
fabric.SprayBrush = fabric.util.createClass(fabric.BaseBrush, {
  width: 10,
  density: 20,
  dotWidth: 1,
  dotWidthVariance: 1,
  randomOpacity: !1,
  optimizeOverlapping: !0,
  initialize: function (e) {
    (this.canvas = e), (this.sprayChunks = []);
  },
  onMouseDown: function (e) {
    (this.sprayChunks.length = 0),
      this.canvas.clearContext(this.canvas.contextTop),
      this._setShadow(),
      this.addSprayChunk(e),
      this.render(this.sprayChunkPoints);
  },
  onMouseMove: function (e) {
    (this.limitedToCanvasSize === !0 && this._isOutSideCanvas(e)) ||
      (this.addSprayChunk(e), this.render(this.sprayChunkPoints));
  },
  onMouseUp: function () {
    var e = this.canvas.renderOnAddRemove;
    this.canvas.renderOnAddRemove = !1;
    for (var t = [], r = 0, n = this.sprayChunks.length; n > r; r++)
      for (var i = this.sprayChunks[r], o = 0, a = i.length; a > o; o++) {
        var s = new fabric.Rect({
          width: i[o].width,
          height: i[o].width,
          left: i[o].x + 1,
          top: i[o].y + 1,
          originX: "center",
          originY: "center",
          fill: this.color,
        });
        t.push(s);
      }
    this.optimizeOverlapping && (t = this._getOptimizedRects(t));
    var c = new fabric.Group(t);
    this.shadow && c.set("shadow", new fabric.Shadow(this.shadow)),
      this.canvas.fire("before:path:created", { path: c }),
      this.canvas.add(c),
      this.canvas.fire("path:created", { path: c }),
      this.canvas.clearContext(this.canvas.contextTop),
      this._resetShadow(),
      (this.canvas.renderOnAddRemove = e),
      this.canvas.requestRenderAll();
  },
  _getOptimizedRects: function (e) {
    var t,
      r,
      n,
      i = {};
    for (r = 0, n = e.length; n > r; r++)
      (t = e[r].left + "" + e[r].top), i[t] || (i[t] = e[r]);
    var o = [];
    for (t in i) o.push(i[t]);
    return o;
  },
  render: function (e) {
    var t,
      r,
      n = this.canvas.contextTop;
    for (
      n.fillStyle = this.color, this._saveAndTransform(n), t = 0, r = e.length;
      r > t;
      t++
    ) {
      var i = e[t];
      "undefined" != typeof i.opacity && (n.globalAlpha = i.opacity),
        n.fillRect(i.x, i.y, i.width, i.width);
    }
    n.restore();
  },
  _render: function () {
    var e,
      t,
      r = this.canvas.contextTop;
    for (
      r.fillStyle = this.color,
        this._saveAndTransform(r),
        e = 0,
        t = this.sprayChunks.length;
      t > e;
      e++
    )
      this.render(this.sprayChunks[e]);
    r.restore();
  },
  addSprayChunk: function (e) {
    this.sprayChunkPoints = [];
    var t,
      r,
      n,
      i,
      o = this.width / 2;
    for (i = 0; i < this.density; i++) {
      (t = fabric.util.getRandomInt(e.x - o, e.x + o)),
        (r = fabric.util.getRandomInt(e.y - o, e.y + o)),
        (n = this.dotWidthVariance
          ? fabric.util.getRandomInt(
              Math.max(1, this.dotWidth - this.dotWidthVariance),
              this.dotWidth + this.dotWidthVariance
            )
          : this.dotWidth);
      var a = new fabric.Point(t, r);
      (a.width = n),
        this.randomOpacity &&
          (a.opacity = fabric.util.getRandomInt(0, 100) / 100),
        this.sprayChunkPoints.push(a);
    }
    this.sprayChunks.push(this.sprayChunkPoints);
  },
});
fabric.PatternBrush = fabric.util.createClass(fabric.PencilBrush, {
  getPatternSrc: function () {
    var e = 20,
      t = 5,
      r = fabric.util.createCanvasElement(),
      n = r.getContext("2d");
    return (
      (r.width = r.height = e + t),
      (n.fillStyle = this.color),
      n.beginPath(),
      n.arc(e / 2, e / 2, e / 2, 0, 2 * Math.PI, !1),
      n.closePath(),
      n.fill(),
      r
    );
  },
  getPatternSrcFunction: function () {
    return String(this.getPatternSrc).replace(
      "this.color",
      '"' + this.color + '"'
    );
  },
  getPattern: function (e) {
    return e.createPattern(this.source || this.getPatternSrc(), "repeat");
  },
  _setBrushStyles: function (e) {
    this.callSuper("_setBrushStyles", e), (e.strokeStyle = this.getPattern(e));
  },
  createPath: function (e) {
    var t = this.callSuper("createPath", e),
      r = t._getLeftTopCoords().scalarAdd(t.strokeWidth / 2);
    return (
      (t.stroke = new fabric.Pattern({
        source: this.source || this.getPatternSrcFunction(),
        offsetX: -r.x,
        offsetY: -r.y,
      })),
      t
    );
  },
});
!(function () {
  var e = fabric.util.getPointer,
    t = fabric.util.degreesToRadians,
    r = fabric.util.isTouchEvent;
  fabric.Canvas = fabric.util.createClass(fabric.StaticCanvas, {
    initialize: function (e, t) {
      t || (t = {}),
        (this.renderAndResetBound = this.renderAndReset.bind(this)),
        (this.requestRenderAllBound = this.requestRenderAll.bind(this)),
        this._initStatic(e, t),
        this._initInteractive(),
        this._createCacheCanvas();
    },
    uniformScaling: !0,
    uniScaleKey: "shiftKey",
    centeredScaling: !1,
    centeredRotation: !1,
    centeredKey: "altKey",
    altActionKey: "shiftKey",
    interactive: !0,
    selection: !0,
    selectionKey: "shiftKey",
    altSelectionKey: null,
    selectionColor: "rgba(100, 100, 255, 0.3)",
    selectionDashArray: [],
    selectionBorderColor: "rgba(255, 255, 255, 0.3)",
    selectionLineWidth: 1,
    selectionFullyContained: !1,
    hoverCursor: "move",
    moveCursor: "move",
    defaultCursor: "default",
    freeDrawingCursor: "crosshair",
    notAllowedCursor: "not-allowed",
    containerClass: "canvas-container",
    perPixelTargetFind: !1,
    targetFindTolerance: 0,
    skipTargetFind: !1,
    isDrawingMode: !1,
    preserveObjectStacking: !1,
    snapAngle: 0,
    snapThreshold: null,
    stopContextMenu: !1,
    fireRightClick: !1,
    fireMiddleClick: !1,
    targets: [],
    enablePointerEvents: !1,
    _hoveredTarget: null,
    _hoveredTargets: [],
    _initInteractive: function () {
      (this._currentTransform = null),
        (this._groupSelector = null),
        this._initWrapperElement(),
        this._createUpperCanvas(),
        this._initEventListeners(),
        this._initRetinaScaling(),
        (this.freeDrawingBrush =
          fabric.PencilBrush && new fabric.PencilBrush(this)),
        this.calcOffset();
    },
    _chooseObjectsToRender: function () {
      var e,
        t,
        r,
        n = this.getActiveObjects();
      if (n.length > 0 && !this.preserveObjectStacking) {
        (t = []), (r = []);
        for (var i = 0, o = this._objects.length; o > i; i++)
          (e = this._objects[i]), -1 === n.indexOf(e) ? t.push(e) : r.push(e);
        n.length > 1 && (this._activeObject._objects = r), t.push.apply(t, r);
      } else t = this._objects;
      return t;
    },
    renderAll: function () {
      !this.contextTopDirty ||
        this._groupSelector ||
        this.isDrawingMode ||
        (this.clearContext(this.contextTop), (this.contextTopDirty = !1)),
        this.hasLostContext &&
          (this.renderTopLayer(this.contextTop), (this.hasLostContext = !1));
      var e = this.contextContainer;
      return this.renderCanvas(e, this._chooseObjectsToRender()), this;
    },
    renderTopLayer: function (e) {
      e.save(),
        this.isDrawingMode &&
          this._isCurrentlyDrawing &&
          (this.freeDrawingBrush && this.freeDrawingBrush._render(),
          (this.contextTopDirty = !0)),
        this.selection &&
          this._groupSelector &&
          (this._drawSelection(e), (this.contextTopDirty = !0)),
        e.restore();
    },
    renderTop: function () {
      var e = this.contextTop;
      return (
        this.clearContext(e),
        this.renderTopLayer(e),
        this.fire("after:render"),
        this
      );
    },
    _normalizePointer: function (e, t) {
      var r = e.calcTransformMatrix(),
        n = fabric.util.invertTransform(r),
        i = this.restorePointerVpt(t);
      return fabric.util.transformPoint(i, n);
    },
    isTargetTransparent: function (e, t, r) {
      if (e.shouldCache() && e._cacheCanvas && e !== this._activeObject) {
        var n = this._normalizePointer(e, { x: t, y: r }),
          i = Math.max(e.cacheTranslationX + n.x * e.zoomX, 0),
          o = Math.max(e.cacheTranslationY + n.y * e.zoomY, 0),
          s = fabric.util.isTransparent(
            e._cacheContext,
            Math.round(i),
            Math.round(o),
            this.targetFindTolerance
          );
        return s;
      }
      var a = this.contextCache,
        c = e.selectionBackgroundColor,
        u = this.viewportTransform;
      (e.selectionBackgroundColor = ""),
        this.clearContext(a),
        a.save(),
        a.transform(u[0], u[1], u[2], u[3], u[4], u[5]),
        e.render(a),
        a.restore(),
        (e.selectionBackgroundColor = c);
      var s = fabric.util.isTransparent(a, t, r, this.targetFindTolerance);
      return s;
    },
    _isSelectionKeyPressed: function (e) {
      var t = !1;
      return (t = Array.isArray(this.selectionKey)
        ? !!this.selectionKey.find(function (t) {
            return e[t] === !0;
          })
        : e[this.selectionKey]);
    },
    _shouldClearSelection: function (e, t) {
      var r = this.getActiveObjects(),
        n = this._activeObject;
      return (
        !t ||
        (t &&
          n &&
          r.length > 1 &&
          -1 === r.indexOf(t) &&
          n !== t &&
          !this._isSelectionKeyPressed(e)) ||
        (t && !t.evented) ||
        (t && !t.selectable && n && n !== t)
      );
    },
    _shouldCenterTransform: function (e, t, r) {
      if (e) {
        var n;
        return (
          "scale" === t || "scaleX" === t || "scaleY" === t || "resizing" === t
            ? (n = this.centeredScaling || e.centeredScaling)
            : "rotate" === t &&
              (n = this.centeredRotation || e.centeredRotation),
          n ? !r : r
        );
      }
    },
    _getOriginFromCorner: function (e, t) {
      var r = { x: e.originX, y: e.originY };
      return (
        "ml" === t || "tl" === t || "bl" === t
          ? (r.x = "right")
          : ("mr" === t || "tr" === t || "br" === t) && (r.x = "left"),
        "tl" === t || "mt" === t || "tr" === t
          ? (r.y = "bottom")
          : ("bl" === t || "mb" === t || "br" === t) && (r.y = "top"),
        r
      );
    },
    _getActionFromCorner: function (e, t, r, n) {
      if (!t || !e) return "drag";
      var i = n.controls[t];
      return i.getActionName(r, i, n);
    },
    _setupCurrentTransform: function (e, r, n) {
      if (r) {
        var i = this.getPointer(e),
          o = r.__corner,
          s = r.controls[o],
          a =
            n && o
              ? s.getActionHandler(e, r, s)
              : fabric.controlsUtils.dragHandler,
          c = this._getActionFromCorner(n, o, e, r),
          u = this._getOriginFromCorner(r, o),
          l = e[this.centeredKey],
          h = {
            target: r,
            action: c,
            actionHandler: a,
            corner: o,
            scaleX: r.scaleX,
            scaleY: r.scaleY,
            skewX: r.skewX,
            skewY: r.skewY,
            offsetX: i.x - r.left,
            offsetY: i.y - r.top,
            originX: u.x,
            originY: u.y,
            ex: i.x,
            ey: i.y,
            lastX: i.x,
            lastY: i.y,
            theta: t(r.angle),
            width: r.width * r.scaleX,
            shiftKey: e.shiftKey,
            altKey: l,
            original: fabric.util.saveObjectTransform(r),
          };
        this._shouldCenterTransform(r, c, l) &&
          ((h.originX = "center"), (h.originY = "center")),
          (h.original.originX = u.x),
          (h.original.originY = u.y),
          (this._currentTransform = h),
          this._beforeTransform(e);
      }
    },
    setCursor: function (e) {
      this.upperCanvasEl.style.cursor = e;
    },
    _drawSelection: function (e) {
      var t = this._groupSelector,
        r = new fabric.Point(t.ex, t.ey),
        n = fabric.util.transformPoint(r, this.viewportTransform),
        i = new fabric.Point(t.ex + t.left, t.ey + t.top),
        o = fabric.util.transformPoint(i, this.viewportTransform),
        s = Math.min(n.x, o.x),
        a = Math.min(n.y, o.y),
        c = Math.max(n.x, o.x),
        u = Math.max(n.y, o.y),
        l = this.selectionLineWidth / 2;
      this.selectionColor &&
        ((e.fillStyle = this.selectionColor), e.fillRect(s, a, c - s, u - a)),
        this.selectionLineWidth &&
          this.selectionBorderColor &&
          ((e.lineWidth = this.selectionLineWidth),
          (e.strokeStyle = this.selectionBorderColor),
          (s += l),
          (a += l),
          (c -= l),
          (u -= l),
          fabric.Object.prototype._setLineDash.call(
            this,
            e,
            this.selectionDashArray
          ),
          e.strokeRect(s, a, c - s, u - a));
    },
    findTarget: function (e, t) {
      if (!this.skipTargetFind) {
        var n,
          i,
          o = !0,
          s = this.getPointer(e, o),
          a = this._activeObject,
          c = this.getActiveObjects(),
          u = r(e),
          l = (c.length > 1 && !t) || 1 === c.length;
        if (((this.targets = []), l && a._findTargetCorner(s, u))) return a;
        if (c.length > 1 && !t && a === this._searchPossibleTargets([a], s))
          return a;
        if (1 === c.length && a === this._searchPossibleTargets([a], s)) {
          if (!this.preserveObjectStacking) return a;
          (n = a), (i = this.targets), (this.targets = []);
        }
        var h = this._searchPossibleTargets(this._objects, s);
        return (
          e[this.altSelectionKey] &&
            h &&
            n &&
            h !== n &&
            ((h = n), (this.targets = i)),
          h
        );
      }
    },
    _checkTarget: function (e, t, r) {
      if (t && t.visible && t.evented && t.containsPoint(e)) {
        if ((!this.perPixelTargetFind && !t.perPixelTargetFind) || t.isEditing)
          return !0;
        var n = this.isTargetTransparent(t, r.x, r.y);
        if (!n) return !0;
      }
    },
    _searchPossibleTargets: function (e, t) {
      for (var r, n, i = e.length; i--; ) {
        var o = e[i],
          s = o.group ? this._normalizePointer(o.group, t) : t;
        if (this._checkTarget(s, o, t)) {
          (r = e[i]),
            r.subTargetCheck &&
              r instanceof fabric.Group &&
              ((n = this._searchPossibleTargets(r._objects, t)),
              n && this.targets.push(n));
          break;
        }
      }
      return r;
    },
    restorePointerVpt: function (e) {
      return fabric.util.transformPoint(
        e,
        fabric.util.invertTransform(this.viewportTransform)
      );
    },
    getPointer: function (t, r) {
      if (this._absolutePointer && !r) return this._absolutePointer;
      if (this._pointer && r) return this._pointer;
      var n,
        i = e(t),
        o = this.upperCanvasEl,
        s = o.getBoundingClientRect(),
        a = s.width || 0,
        c = s.height || 0;
      (a && c) ||
        ("top" in s && "bottom" in s && (c = Math.abs(s.top - s.bottom)),
        "right" in s && "left" in s && (a = Math.abs(s.right - s.left))),
        this.calcOffset(),
        (i.x = i.x - this._offset.left),
        (i.y = i.y - this._offset.top),
        r || (i = this.restorePointerVpt(i));
      var u = this.getRetinaScaling();
      return (
        1 !== u && ((i.x /= u), (i.y /= u)),
        (n =
          0 === a || 0 === c
            ? { width: 1, height: 1 }
            : { width: o.width / a, height: o.height / c }),
        { x: i.x * n.width, y: i.y * n.height }
      );
    },
    _createUpperCanvas: function () {
      var e = this.lowerCanvasEl.className.replace(/\s*lower-canvas\s*/, ""),
        t = this.lowerCanvasEl,
        r = this.upperCanvasEl;
      r
        ? (r.className = "")
        : ((r = this._createCanvasElement()), (this.upperCanvasEl = r)),
        fabric.util.addClass(r, "upper-canvas " + e),
        this.wrapperEl.appendChild(r),
        this._copyCanvasStyle(t, r),
        this._applyCanvasStyle(r),
        (this.contextTop = r.getContext("2d"));
    },
    getTopContext: function () {
      return this.contextTop;
    },
    _createCacheCanvas: function () {
      (this.cacheCanvasEl = this._createCanvasElement()),
        this.cacheCanvasEl.setAttribute("width", this.width),
        this.cacheCanvasEl.setAttribute("height", this.height),
        (this.contextCache = this.cacheCanvasEl.getContext("2d"));
    },
    _initWrapperElement: function () {
      (this.wrapperEl = fabric.util.wrapElement(this.lowerCanvasEl, "div", {
        class: this.containerClass,
      })),
        fabric.util.setStyle(this.wrapperEl, {
          width: this.width + "px",
          height: this.height + "px",
          position: "relative",
        }),
        fabric.util.makeElementUnselectable(this.wrapperEl);
    },
    _applyCanvasStyle: function (e) {
      var t = this.width || e.width,
        r = this.height || e.height;
      fabric.util.setStyle(e, {
        position: "absolute",
        width: t + "px",
        height: r + "px",
        left: 0,
        top: 0,
        "touch-action": this.allowTouchScrolling ? "manipulation" : "none",
        "-ms-touch-action": this.allowTouchScrolling ? "manipulation" : "none",
      }),
        (e.width = t),
        (e.height = r),
        fabric.util.makeElementUnselectable(e);
    },
    _copyCanvasStyle: function (e, t) {
      t.style.cssText = e.style.cssText;
    },
    getSelectionContext: function () {
      return this.contextTop;
    },
    getSelectionElement: function () {
      return this.upperCanvasEl;
    },
    getActiveObject: function () {
      return this._activeObject;
    },
    getActiveObjects: function () {
      var e = this._activeObject;
      return e
        ? "activeSelection" === e.type && e._objects
          ? e._objects.slice(0)
          : [e]
        : [];
    },
    _onObjectRemoved: function (e) {
      e === this._activeObject &&
        (this.fire("before:selection:cleared", { target: e }),
        this._discardActiveObject(),
        this.fire("selection:cleared", { target: e }),
        e.fire("deselected")),
        e === this._hoveredTarget &&
          ((this._hoveredTarget = null), (this._hoveredTargets = [])),
        this.callSuper("_onObjectRemoved", e);
    },
    _fireSelectionEvents: function (e, t) {
      var r = !1,
        n = this.getActiveObjects(),
        i = [],
        o = [];
      e.forEach(function (e) {
        -1 === n.indexOf(e) &&
          ((r = !0), e.fire("deselected", { e: t, target: e }), o.push(e));
      }),
        n.forEach(function (n) {
          -1 === e.indexOf(n) &&
            ((r = !0), n.fire("selected", { e: t, target: n }), i.push(n));
        }),
        e.length > 0 && n.length > 0
          ? r &&
            this.fire("selection:updated", { e: t, selected: i, deselected: o })
          : n.length > 0
          ? this.fire("selection:created", { e: t, selected: i })
          : e.length > 0 &&
            this.fire("selection:cleared", { e: t, deselected: o });
    },
    setActiveObject: function (e, t) {
      var r = this.getActiveObjects();
      return this._setActiveObject(e, t), this._fireSelectionEvents(r, t), this;
    },
    _setActiveObject: function (e, t) {
      return this._activeObject === e
        ? !1
        : this._discardActiveObject(t, e)
        ? e.onSelect({ e: t })
          ? !1
          : ((this._activeObject = e), !0)
        : !1;
    },
    _discardActiveObject: function (e, t) {
      var r = this._activeObject;
      if (r) {
        if (r.onDeselect({ e: e, object: t })) return !1;
        this._activeObject = null;
      }
      return !0;
    },
    discardActiveObject: function (e) {
      var t = this.getActiveObjects(),
        r = this.getActiveObject();
      return (
        t.length && this.fire("before:selection:cleared", { target: r, e: e }),
        this._discardActiveObject(e),
        this._fireSelectionEvents(t, e),
        this
      );
    },
    dispose: function () {
      var e = this.wrapperEl;
      return (
        this.removeListeners(),
        e.removeChild(this.upperCanvasEl),
        e.removeChild(this.lowerCanvasEl),
        (this.contextCache = null),
        (this.contextTop = null),
        ["upperCanvasEl", "cacheCanvasEl"].forEach(
          function (e) {
            fabric.util.cleanUpJsdomNode(this[e]), (this[e] = void 0);
          }.bind(this)
        ),
        e.parentNode &&
          e.parentNode.replaceChild(this.lowerCanvasEl, this.wrapperEl),
        delete this.wrapperEl,
        fabric.StaticCanvas.prototype.dispose.call(this),
        this
      );
    },
    clear: function () {
      return (
        this.discardActiveObject(),
        this.clearContext(this.contextTop),
        this.callSuper("clear")
      );
    },
    drawControls: function (e) {
      var t = this._activeObject;
      t && t._renderControls(e);
    },
    _toObject: function (e, t, r) {
      var n = this._realizeGroupTransformOnObject(e),
        i = this.callSuper("_toObject", e, t, r);
      return this._unwindGroupTransformOnObject(e, n), i;
    },
    _realizeGroupTransformOnObject: function (e) {
      if (
        e.group &&
        "activeSelection" === e.group.type &&
        this._activeObject === e.group
      ) {
        var t = [
            "angle",
            "flipX",
            "flipY",
            "left",
            "scaleX",
            "scaleY",
            "skewX",
            "skewY",
            "top",
          ],
          r = {};
        return (
          t.forEach(function (t) {
            r[t] = e[t];
          }),
          fabric.util.addTransformToObject(
            e,
            this._activeObject.calcOwnMatrix()
          ),
          r
        );
      }
      return null;
    },
    _unwindGroupTransformOnObject: function (e, t) {
      t && e.set(t);
    },
    _setSVGObject: function (e, t, r) {
      var n = this._realizeGroupTransformOnObject(t);
      this.callSuper("_setSVGObject", e, t, r),
        this._unwindGroupTransformOnObject(t, n);
    },
    setViewportTransform: function (e) {
      this.renderOnAddRemove &&
        this._activeObject &&
        this._activeObject.isEditing &&
        this._activeObject.clearContextTop(),
        fabric.StaticCanvas.prototype.setViewportTransform.call(this, e);
    },
  });
  for (var n in fabric.StaticCanvas)
    "prototype" !== n && (fabric.Canvas[n] = fabric.StaticCanvas[n]);
})();
!(function () {
  function e(e, t) {
    return e.button && e.button === t - 1;
  }
  var t = fabric.util.addListener,
    n = fabric.util.removeListener,
    r = 3,
    i = 2,
    o = 1,
    s = { passive: !1 };
  fabric.util.object.extend(fabric.Canvas.prototype, {
    mainTouchId: null,
    _initEventListeners: function () {
      this.removeListeners(), this._bindEvents(), this.addOrRemove(t, "add");
    },
    _getEventPrefix: function () {
      return this.enablePointerEvents ? "pointer" : "mouse";
    },
    addOrRemove: function (e, t) {
      var n = this.upperCanvasEl,
        r = this._getEventPrefix();
      e(fabric.window, "resize", this._onResize),
        e(n, r + "down", this._onMouseDown),
        e(n, r + "move", this._onMouseMove, s),
        e(n, r + "out", this._onMouseOut),
        e(n, r + "enter", this._onMouseEnter),
        e(n, "wheel", this._onMouseWheel),
        e(n, "contextmenu", this._onContextMenu),
        e(n, "dblclick", this._onDoubleClick),
        e(n, "dragover", this._onDragOver),
        e(n, "dragenter", this._onDragEnter),
        e(n, "dragleave", this._onDragLeave),
        e(n, "drop", this._onDrop),
        this.enablePointerEvents || e(n, "touchstart", this._onTouchStart, s),
        "undefined" != typeof eventjs &&
          t in eventjs &&
          (eventjs[t](n, "gesture", this._onGesture),
          eventjs[t](n, "drag", this._onDrag),
          eventjs[t](n, "orientation", this._onOrientationChange),
          eventjs[t](n, "shake", this._onShake),
          eventjs[t](n, "longpress", this._onLongPress));
    },
    removeListeners: function () {
      this.addOrRemove(n, "remove");
      var e = this._getEventPrefix();
      n(fabric.document, e + "up", this._onMouseUp),
        n(fabric.document, "touchend", this._onTouchEnd, s),
        n(fabric.document, e + "move", this._onMouseMove, s),
        n(fabric.document, "touchmove", this._onMouseMove, s);
    },
    _bindEvents: function () {
      this.eventsBound ||
        ((this._onMouseDown = this._onMouseDown.bind(this)),
        (this._onTouchStart = this._onTouchStart.bind(this)),
        (this._onMouseMove = this._onMouseMove.bind(this)),
        (this._onMouseUp = this._onMouseUp.bind(this)),
        (this._onTouchEnd = this._onTouchEnd.bind(this)),
        (this._onResize = this._onResize.bind(this)),
        (this._onGesture = this._onGesture.bind(this)),
        (this._onDrag = this._onDrag.bind(this)),
        (this._onShake = this._onShake.bind(this)),
        (this._onLongPress = this._onLongPress.bind(this)),
        (this._onOrientationChange = this._onOrientationChange.bind(this)),
        (this._onMouseWheel = this._onMouseWheel.bind(this)),
        (this._onMouseOut = this._onMouseOut.bind(this)),
        (this._onMouseEnter = this._onMouseEnter.bind(this)),
        (this._onContextMenu = this._onContextMenu.bind(this)),
        (this._onDoubleClick = this._onDoubleClick.bind(this)),
        (this._onDragOver = this._onDragOver.bind(this)),
        (this._onDragEnter = this._simpleEventHandler.bind(this, "dragenter")),
        (this._onDragLeave = this._simpleEventHandler.bind(this, "dragleave")),
        (this._onDrop = this._onDrop.bind(this)),
        (this.eventsBound = !0));
    },
    _onGesture: function (e, t) {
      this.__onTransformGesture && this.__onTransformGesture(e, t);
    },
    _onDrag: function (e, t) {
      this.__onDrag && this.__onDrag(e, t);
    },
    _onMouseWheel: function (e) {
      this.__onMouseWheel(e);
    },
    _onMouseOut: function (e) {
      var t = this._hoveredTarget;
      this.fire("mouse:out", { target: t, e: e }),
        (this._hoveredTarget = null),
        t && t.fire("mouseout", { e: e });
      var n = this;
      this._hoveredTargets.forEach(function (r) {
        n.fire("mouse:out", { target: t, e: e }),
          r && t.fire("mouseout", { e: e });
      }),
        (this._hoveredTargets = []),
        this._iTextInstances &&
          this._iTextInstances.forEach(function (e) {
            e.isEditing && e.hiddenTextarea.focus();
          });
    },
    _onMouseEnter: function (e) {
      this._currentTransform ||
        this.findTarget(e) ||
        (this.fire("mouse:over", { target: null, e: e }),
        (this._hoveredTarget = null),
        (this._hoveredTargets = []));
    },
    _onOrientationChange: function (e, t) {
      this.__onOrientationChange && this.__onOrientationChange(e, t);
    },
    _onShake: function (e, t) {
      this.__onShake && this.__onShake(e, t);
    },
    _onLongPress: function (e, t) {
      this.__onLongPress && this.__onLongPress(e, t);
    },
    _onDragOver: function (e) {
      e.preventDefault();
      var t = this._simpleEventHandler("dragover", e);
      this._fireEnterLeaveEvents(t, e);
    },
    _onDrop: function (e) {
      return (
        this._simpleEventHandler("drop:before", e),
        this._simpleEventHandler("drop", e)
      );
    },
    _onContextMenu: function (e) {
      return (
        this.stopContextMenu && (e.stopPropagation(), e.preventDefault()), !1
      );
    },
    _onDoubleClick: function (e) {
      this._cacheTransformEventData(e),
        this._handleEvent(e, "dblclick"),
        this._resetTransformEventData(e);
    },
    getPointerId: function (e) {
      var t = e.changedTouches;
      return t
        ? t[0] && t[0].identifier
        : this.enablePointerEvents
        ? e.pointerId
        : -1;
    },
    _isMainEvent: function (e) {
      return e.isPrimary === !0
        ? !0
        : e.isPrimary === !1
        ? !1
        : "touchend" === e.type && 0 === e.touches.length
        ? !0
        : e.changedTouches
        ? e.changedTouches[0].identifier === this.mainTouchId
        : !0;
    },
    _onTouchStart: function (e) {
      e.preventDefault(),
        null === this.mainTouchId && (this.mainTouchId = this.getPointerId(e)),
        this.__onMouseDown(e),
        this._resetTransformEventData();
      var r = this.upperCanvasEl,
        i = this._getEventPrefix();
      t(fabric.document, "touchend", this._onTouchEnd, s),
        t(fabric.document, "touchmove", this._onMouseMove, s),
        n(r, i + "down", this._onMouseDown);
    },
    _onMouseDown: function (e) {
      this.__onMouseDown(e), this._resetTransformEventData();
      var r = this.upperCanvasEl,
        i = this._getEventPrefix();
      n(r, i + "move", this._onMouseMove, s),
        t(fabric.document, i + "up", this._onMouseUp),
        t(fabric.document, i + "move", this._onMouseMove, s);
    },
    _onTouchEnd: function (e) {
      if (!(e.touches.length > 0)) {
        this.__onMouseUp(e),
          this._resetTransformEventData(),
          (this.mainTouchId = null);
        var r = this._getEventPrefix();
        n(fabric.document, "touchend", this._onTouchEnd, s),
          n(fabric.document, "touchmove", this._onMouseMove, s);
        var i = this;
        this._willAddMouseDown && clearTimeout(this._willAddMouseDown),
          (this._willAddMouseDown = setTimeout(function () {
            t(i.upperCanvasEl, r + "down", i._onMouseDown),
              (i._willAddMouseDown = 0);
          }, 400));
      }
    },
    _onMouseUp: function (e) {
      this.__onMouseUp(e), this._resetTransformEventData();
      var r = this.upperCanvasEl,
        i = this._getEventPrefix();
      this._isMainEvent(e) &&
        (n(fabric.document, i + "up", this._onMouseUp),
        n(fabric.document, i + "move", this._onMouseMove, s),
        t(r, i + "move", this._onMouseMove, s));
    },
    _onMouseMove: function (e) {
      !this.allowTouchScrolling && e.preventDefault && e.preventDefault(),
        this.__onMouseMove(e);
    },
    _onResize: function () {
      this.calcOffset();
    },
    _shouldRender: function (e) {
      var t = this._activeObject;
      return !!t != !!e || (t && e && t !== e)
        ? !0
        : t && t.isEditing
        ? !1
        : !1;
    },
    __onMouseUp: function (t) {
      var n,
        s = this._currentTransform,
        a = this._groupSelector,
        c = !1,
        u = !a || (0 === a.left && 0 === a.top);
      if (
        (this._cacheTransformEventData(t),
        (n = this._target),
        this._handleEvent(t, "up:before"),
        e(t, r))
      )
        return void (this.fireRightClick && this._handleEvent(t, "up", r, u));
      if (e(t, i))
        return (
          this.fireMiddleClick && this._handleEvent(t, "up", i, u),
          void this._resetTransformEventData()
        );
      if (this.isDrawingMode && this._isCurrentlyDrawing)
        return void this._onMouseUpInDrawingMode(t);
      if (this._isMainEvent(t)) {
        if (
          (s && (this._finalizeCurrentTransform(t), (c = s.actionPerformed)),
          !u)
        ) {
          var l = n === this._activeObject;
          this._maybeGroupObjects(t),
            c ||
              (c = this._shouldRender(n) || (!l && n === this._activeObject));
        }
        var f, h;
        if (n) {
          if (
            ((f = n._findTargetCorner(
              this.getPointer(t, !0),
              fabric.util.isTouchEvent(t)
            )),
            n.selectable && n !== this._activeObject && "up" === n.activeOn)
          )
            this.setActiveObject(n, t), (c = !0);
          else {
            var d = n.controls[f],
              v = d && d.getMouseUpHandler(t, n, d);
            v && ((h = this.getPointer(t)), v(t, s, h.x, h.y));
          }
          n.isMoving = !1;
        }
        if (s && (s.target !== n || s.corner !== f)) {
          var p = s.target && s.target.controls[s.corner],
            g = p && p.getMouseUpHandler(t, n, d);
          (h = h || this.getPointer(t)), g && g(t, s, h.x, h.y);
        }
        this._setCursorFromEvent(t, n),
          this._handleEvent(t, "up", o, u),
          (this._groupSelector = null),
          (this._currentTransform = null),
          n && (n.__corner = 0),
          c ? this.requestRenderAll() : u || this.renderTop();
      }
    },
    _simpleEventHandler: function (e, t) {
      var n = this.findTarget(t),
        r = this.targets,
        i = { e: t, target: n, subTargets: r };
      if ((this.fire(e, i), n && n.fire(e, i), !r)) return n;
      for (var o = 0; o < r.length; o++) r[o].fire(e, i);
      return n;
    },
    _handleEvent: function (e, t, n, r) {
      var i = this._target,
        s = this.targets || [],
        a = {
          e: e,
          target: i,
          subTargets: s,
          button: n || o,
          isClick: r || !1,
          pointer: this._pointer,
          absolutePointer: this._absolutePointer,
          transform: this._currentTransform,
        };
      "up" === t &&
        ((a.currentTarget = this.findTarget(e)),
        (a.currentSubTargets = this.targets)),
        this.fire("mouse:" + t, a),
        i && i.fire("mouse" + t, a);
      for (var c = 0; c < s.length; c++) s[c].fire("mouse" + t, a);
    },
    _finalizeCurrentTransform: function (e) {
      var t = this._currentTransform,
        n = t.target,
        r = { e: e, target: n, transform: t, action: t.action };
      n._scaling && (n._scaling = !1),
        n.setCoords(),
        (t.actionPerformed || (this.stateful && n.hasStateChanged())) &&
          this._fire("modified", r);
    },
    _onMouseDownInDrawingMode: function (e) {
      (this._isCurrentlyDrawing = !0),
        this.getActiveObject() &&
          this.discardActiveObject(e).requestRenderAll();
      var t = this.getPointer(e);
      this.freeDrawingBrush.onMouseDown(t, { e: e, pointer: t }),
        this._handleEvent(e, "down");
    },
    _onMouseMoveInDrawingMode: function (e) {
      if (this._isCurrentlyDrawing) {
        var t = this.getPointer(e);
        this.freeDrawingBrush.onMouseMove(t, { e: e, pointer: t });
      }
      this.setCursor(this.freeDrawingCursor), this._handleEvent(e, "move");
    },
    _onMouseUpInDrawingMode: function (e) {
      var t = this.getPointer(e);
      (this._isCurrentlyDrawing = this.freeDrawingBrush.onMouseUp({
        e: e,
        pointer: t,
      })),
        this._handleEvent(e, "up");
    },
    __onMouseDown: function (t) {
      this._cacheTransformEventData(t), this._handleEvent(t, "down:before");
      var n = this._target;
      if (e(t, r))
        return void (this.fireRightClick && this._handleEvent(t, "down", r));
      if (e(t, i))
        return void (this.fireMiddleClick && this._handleEvent(t, "down", i));
      if (this.isDrawingMode) return void this._onMouseDownInDrawingMode(t);
      if (this._isMainEvent(t) && !this._currentTransform) {
        var o = this._pointer;
        this._previousPointer = o;
        var s = this._shouldRender(n),
          a = this._shouldGroup(t, n);
        if (
          (this._shouldClearSelection(t, n)
            ? this.discardActiveObject(t)
            : a && (this._handleGrouping(t, n), (n = this._activeObject)),
          !this.selection ||
            (n && (n.selectable || n.isEditing || n === this._activeObject)) ||
            (this._groupSelector = {
              ex: this._absolutePointer.x,
              ey: this._absolutePointer.y,
              top: 0,
              left: 0,
            }),
          n)
        ) {
          var c = n === this._activeObject;
          n.selectable && "down" === n.activeOn && this.setActiveObject(n, t);
          var u = n._findTargetCorner(
            this.getPointer(t, !0),
            fabric.util.isTouchEvent(t)
          );
          if (((n.__corner = u), n === this._activeObject && (u || !a))) {
            this._setupCurrentTransform(t, n, c);
            var l = n.controls[u],
              o = this.getPointer(t),
              f = l && l.getMouseDownHandler(t, n, l);
            f && f(t, this._currentTransform, o.x, o.y);
          }
        }
        this._handleEvent(t, "down"), (s || a) && this.requestRenderAll();
      }
    },
    _resetTransformEventData: function () {
      (this._target = null),
        (this._pointer = null),
        (this._absolutePointer = null);
    },
    _cacheTransformEventData: function (e) {
      this._resetTransformEventData(),
        (this._pointer = this.getPointer(e, !0)),
        (this._absolutePointer = this.restorePointerVpt(this._pointer)),
        (this._target = this._currentTransform
          ? this._currentTransform.target
          : this.findTarget(e) || null);
    },
    _beforeTransform: function (e) {
      var t = this._currentTransform;
      this.stateful && t.target.saveState(),
        this.fire("before:transform", { e: e, transform: t });
    },
    __onMouseMove: function (e) {
      this._handleEvent(e, "move:before"), this._cacheTransformEventData(e);
      var t, n;
      if (this.isDrawingMode) return void this._onMouseMoveInDrawingMode(e);
      if (this._isMainEvent(e)) {
        var r = this._groupSelector;
        r
          ? ((n = this._absolutePointer),
            (r.left = n.x - r.ex),
            (r.top = n.y - r.ey),
            this.renderTop())
          : this._currentTransform
          ? this._transformObject(e)
          : ((t = this.findTarget(e) || null),
            this._setCursorFromEvent(e, t),
            this._fireOverOutEvents(t, e)),
          this._handleEvent(e, "move"),
          this._resetTransformEventData();
      }
    },
    _fireOverOutEvents: function (e, t) {
      var n = this._hoveredTarget,
        r = this._hoveredTargets,
        i = this.targets,
        o = Math.max(r.length, i.length);
      this.fireSyntheticInOutEvents(e, t, {
        oldTarget: n,
        evtOut: "mouseout",
        canvasEvtOut: "mouse:out",
        evtIn: "mouseover",
        canvasEvtIn: "mouse:over",
      });
      for (var s = 0; o > s; s++)
        this.fireSyntheticInOutEvents(i[s], t, {
          oldTarget: r[s],
          evtOut: "mouseout",
          evtIn: "mouseover",
        });
      (this._hoveredTarget = e), (this._hoveredTargets = this.targets.concat());
    },
    _fireEnterLeaveEvents: function (e, t) {
      var n = this._draggedoverTarget,
        r = this._hoveredTargets,
        i = this.targets,
        o = Math.max(r.length, i.length);
      this.fireSyntheticInOutEvents(e, t, {
        oldTarget: n,
        evtOut: "dragleave",
        evtIn: "dragenter",
      });
      for (var s = 0; o > s; s++)
        this.fireSyntheticInOutEvents(i[s], t, {
          oldTarget: r[s],
          evtOut: "dragleave",
          evtIn: "dragenter",
        });
      this._draggedoverTarget = e;
    },
    fireSyntheticInOutEvents: function (e, t, n) {
      var r,
        i,
        o,
        s,
        a = n.oldTarget,
        c = a !== e,
        u = n.canvasEvtIn,
        l = n.canvasEvtOut;
      c &&
        ((r = { e: t, target: e, previousTarget: a }),
        (i = { e: t, target: a, nextTarget: e })),
        (s = e && c),
        (o = a && c),
        o && (l && this.fire(l, i), a.fire(n.evtOut, i)),
        s && (u && this.fire(u, r), e.fire(n.evtIn, r));
    },
    __onMouseWheel: function (e) {
      this._cacheTransformEventData(e),
        this._handleEvent(e, "wheel"),
        this._resetTransformEventData();
    },
    _transformObject: function (e) {
      var t = this.getPointer(e),
        n = this._currentTransform;
      (n.reset = !1),
        (n.shiftKey = e.shiftKey),
        (n.altKey = e[this.centeredKey]),
        this._performTransformAction(e, n, t),
        n.actionPerformed && this.requestRenderAll();
    },
    _performTransformAction: function (e, t, n) {
      var r = n.x,
        i = n.y,
        o = t.action,
        s = !1,
        a = t.actionHandler;
      a && (s = a(e, t, r, i)),
        "drag" === o &&
          s &&
          ((t.target.isMoving = !0),
          this.setCursor(t.target.moveCursor || this.moveCursor)),
        (t.actionPerformed = t.actionPerformed || s);
    },
    _fire: fabric.controlsUtils.fireEvent,
    _setCursorFromEvent: function (e, t) {
      if (!t) return this.setCursor(this.defaultCursor), !1;
      var n = t.hoverCursor || this.hoverCursor,
        r =
          this._activeObject && "activeSelection" === this._activeObject.type
            ? this._activeObject
            : null,
        i =
          (!r || !r.contains(t)) && t._findTargetCorner(this.getPointer(e, !0));
      i
        ? this.setCursor(this.getCornerCursor(i, t, e))
        : (t.subTargetCheck &&
            this.targets
              .concat()
              .reverse()
              .map(function (e) {
                n = e.hoverCursor || n;
              }),
          this.setCursor(n));
    },
    getCornerCursor: function (e, t, n) {
      var r = t.controls[e];
      return r.cursorStyleHandler(n, r, t);
    },
  });
})();
!(function () {
  var e = Math.min,
    t = Math.max;
  fabric.util.object.extend(fabric.Canvas.prototype, {
    _shouldGroup: function (e, t) {
      var n = this._activeObject;
      return (
        n &&
        this._isSelectionKeyPressed(e) &&
        t &&
        t.selectable &&
        this.selection &&
        (n !== t || "activeSelection" === n.type) &&
        !t.onSelect({ e: e })
      );
    },
    _handleGrouping: function (e, t) {
      var n = this._activeObject;
      n.__corner ||
        ((t !== n || ((t = this.findTarget(e, !0)), t && t.selectable)) &&
          (n && "activeSelection" === n.type
            ? this._updateActiveSelection(t, e)
            : this._createActiveSelection(t, e)));
    },
    _updateActiveSelection: function (e, t) {
      var n = this._activeObject,
        r = n._objects.slice(0);
      n.contains(e)
        ? (n.removeWithUpdate(e),
          (this._hoveredTarget = e),
          (this._hoveredTargets = this.targets.concat()),
          1 === n.size() && this._setActiveObject(n.item(0), t))
        : (n.addWithUpdate(e),
          (this._hoveredTarget = n),
          (this._hoveredTargets = this.targets.concat())),
        this._fireSelectionEvents(r, t);
    },
    _createActiveSelection: function (e, t) {
      var n = this.getActiveObjects(),
        r = this._createGroup(e);
      (this._hoveredTarget = r),
        this._setActiveObject(r, t),
        this._fireSelectionEvents(n, t);
    },
    _createGroup: function (e) {
      var t = this._objects,
        n = t.indexOf(this._activeObject) < t.indexOf(e),
        r = n ? [this._activeObject, e] : [e, this._activeObject];
      return (
        this._activeObject.isEditing && this._activeObject.exitEditing(),
        new fabric.ActiveSelection(r, { canvas: this })
      );
    },
    _groupSelectedObjects: function (e) {
      var t,
        n = this._collectObjects(e);
      1 === n.length
        ? this.setActiveObject(n[0], e)
        : n.length > 1 &&
          ((t = new fabric.ActiveSelection(n.reverse(), { canvas: this })),
          this.setActiveObject(t, e));
    },
    _collectObjects: function (n) {
      for (
        var r,
          i = [],
          o = this._groupSelector.ex,
          s = this._groupSelector.ey,
          a = o + this._groupSelector.left,
          c = s + this._groupSelector.top,
          u = new fabric.Point(e(o, a), e(s, c)),
          l = new fabric.Point(t(o, a), t(s, c)),
          f = !this.selectionFullyContained,
          h = o === a && s === c,
          d = this._objects.length;
        d-- &&
        ((r = this._objects[d]),
        !(
          r &&
          r.selectable &&
          r.visible &&
          ((f && r.intersectsWithRect(u, l, !0)) ||
            r.isContainedWithinRect(u, l, !0) ||
            (f && r.containsPoint(u, null, !0)) ||
            (f && r.containsPoint(l, null, !0))) &&
          (i.push(r), h)
        ));

      );
      return (
        i.length > 1 &&
          (i = i.filter(function (e) {
            return !e.onSelect({ e: n });
          })),
        i
      );
    },
    _maybeGroupObjects: function (e) {
      this.selection && this._groupSelector && this._groupSelectedObjects(e),
        this.setCursor(this.defaultCursor),
        (this._groupSelector = null);
    },
  });
})();
!(function () {
  fabric.util.object.extend(fabric.StaticCanvas.prototype, {
    toDataURL: function (e) {
      e || (e = {});
      var t = e.format || "png",
        r = e.quality || 1,
        n =
          (e.multiplier || 1) *
          (e.enableRetinaScaling ? this.getRetinaScaling() : 1),
        i = this.toCanvasElement(n, e);
      return fabric.util.toDataURL(i, t, r);
    },
    toCanvasElement: function (e, t) {
      (e = e || 1), (t = t || {});
      var r = (t.width || this.width) * e,
        n = (t.height || this.height) * e,
        i = this.getZoom(),
        o = this.width,
        s = this.height,
        a = i * e,
        c = this.viewportTransform,
        u = (c[4] - (t.left || 0)) * e,
        l = (c[5] - (t.top || 0)) * e,
        h = this.interactive,
        f = [a, 0, 0, a, u, l],
        d = this.enableRetinaScaling,
        v = fabric.util.createCanvasElement(),
        p = this.contextTop;
      return (
        (v.width = r),
        (v.height = n),
        (this.contextTop = null),
        (this.enableRetinaScaling = !1),
        (this.interactive = !1),
        (this.viewportTransform = f),
        (this.width = r),
        (this.height = n),
        this.calcViewportBoundaries(),
        this.renderCanvas(v.getContext("2d"), this._objects),
        (this.viewportTransform = c),
        (this.width = o),
        (this.height = s),
        this.calcViewportBoundaries(),
        (this.interactive = h),
        (this.enableRetinaScaling = d),
        (this.contextTop = p),
        v
      );
    },
  });
})();
fabric.util.object.extend(fabric.StaticCanvas.prototype, {
  loadFromJSON: function (e, t, r) {
    if (e) {
      var n =
          "string" == typeof e ? JSON.parse(e) : fabric.util.object.clone(e),
        i = this,
        o = n.clipPath,
        s = this.renderOnAddRemove;
      return (
        (this.renderOnAddRemove = !1),
        delete n.clipPath,
        this._enlivenObjects(
          n.objects,
          function (e) {
            i.clear(),
              i._setBgOverlay(n, function () {
                o
                  ? i._enlivenObjects([o], function (r) {
                      (i.clipPath = r[0]), i.__setupCanvas.call(i, n, e, s, t);
                    })
                  : i.__setupCanvas.call(i, n, e, s, t);
              });
          },
          r
        ),
        this
      );
    }
  },
  __setupCanvas: function (e, t, r, n) {
    var i = this;
    t.forEach(function (e, t) {
      i.insertAt(e, t);
    }),
      (this.renderOnAddRemove = r),
      delete e.objects,
      delete e.backgroundImage,
      delete e.overlayImage,
      delete e.background,
      delete e.overlay,
      this._setOptions(e),
      this.renderAll(),
      n && n();
  },
  _setBgOverlay: function (e, t) {
    var r = {
      backgroundColor: !1,
      overlayColor: !1,
      backgroundImage: !1,
      overlayImage: !1,
    };
    if (!(e.backgroundImage || e.overlayImage || e.background || e.overlay))
      return void (t && t());
    var n = function () {
      r.backgroundImage &&
        r.overlayImage &&
        r.backgroundColor &&
        r.overlayColor &&
        t &&
        t();
    };
    this.__setBgOverlay("backgroundImage", e.backgroundImage, r, n),
      this.__setBgOverlay("overlayImage", e.overlayImage, r, n),
      this.__setBgOverlay("backgroundColor", e.background, r, n),
      this.__setBgOverlay("overlayColor", e.overlay, r, n);
  },
  __setBgOverlay: function (e, t, r, n) {
    var i = this;
    return t
      ? void ("backgroundImage" === e || "overlayImage" === e
          ? fabric.util.enlivenObjects([t], function (t) {
              (i[e] = t[0]), (r[e] = !0), n && n();
            })
          : this["set" + fabric.util.string.capitalize(e, !0)](t, function () {
              (r[e] = !0), n && n();
            }))
      : ((r[e] = !0), void (n && n()));
  },
  _enlivenObjects: function (e, t, r) {
    return e && 0 !== e.length
      ? void fabric.util.enlivenObjects(
          e,
          function (e) {
            t && t(e);
          },
          null,
          r
        )
      : void (t && t([]));
  },
  _toDataURL: function (e, t) {
    this.clone(function (r) {
      t(r.toDataURL(e));
    });
  },
  _toDataURLWithMultiplier: function (e, t, r) {
    this.clone(function (n) {
      r(n.toDataURLWithMultiplier(e, t));
    });
  },
  clone: function (e, t) {
    var r = JSON.stringify(this.toJSON(t));
    this.cloneWithoutData(function (t) {
      t.loadFromJSON(r, function () {
        e && e(t);
      });
    });
  },
  cloneWithoutData: function (e) {
    var t = fabric.util.createCanvasElement();
    (t.width = this.width), (t.height = this.height);
    var r = new fabric.Canvas(t);
    this.backgroundImage
      ? (r.setBackgroundImage(this.backgroundImage.src, function () {
          r.renderAll(), e && e(r);
        }),
        (r.backgroundImageOpacity = this.backgroundImageOpacity),
        (r.backgroundImageStretch = this.backgroundImageStretch))
      : e && e(r);
  },
});
!(function () {
  var e = fabric.util.degreesToRadians,
    t = fabric.util.radiansToDegrees;
  fabric.util.object.extend(fabric.Canvas.prototype, {
    __onTransformGesture: function (e, t) {
      if (
        !this.isDrawingMode &&
        e.touches &&
        2 === e.touches.length &&
        "gesture" === t.gesture
      ) {
        var r = this.findTarget(e);
        "undefined" != typeof r &&
          ((this.__gesturesParams = { e: e, self: t, target: r }),
          this.__gesturesRenderer()),
          this.fire("touch:gesture", { target: r, e: e, self: t });
      }
    },
    __gesturesParams: null,
    __gesturesRenderer: function () {
      if (null !== this.__gesturesParams && null !== this._currentTransform) {
        var e = this.__gesturesParams.self,
          t = this._currentTransform,
          r = this.__gesturesParams.e;
        (t.action = "scale"),
          (t.originX = t.originY = "center"),
          this._scaleObjectBy(e.scale, r),
          0 !== e.rotation &&
            ((t.action = "rotate"), this._rotateObjectByAngle(e.rotation, r)),
          this.requestRenderAll(),
          (t.action = "drag");
      }
    },
    __onDrag: function (e, t) {
      this.fire("touch:drag", { e: e, self: t });
    },
    __onOrientationChange: function (e, t) {
      this.fire("touch:orientation", { e: e, self: t });
    },
    __onShake: function (e, t) {
      this.fire("touch:shake", { e: e, self: t });
    },
    __onLongPress: function (e, t) {
      this.fire("touch:longpress", { e: e, self: t });
    },
    _scaleObjectBy: function (e, t) {
      var r = this._currentTransform,
        n = r.target;
      return (
        (r.gestureScale = e),
        (n._scaling = !0),
        fabric.controlsUtils.scalingEqually(t, r, 0, 0)
      );
    },
    _rotateObjectByAngle: function (r, n) {
      var i = this._currentTransform;
      i.target.get("lockRotation") ||
        (i.target.rotate(t(e(r) + i.theta)),
        this._fire("rotating", { target: i.target, e: n, transform: i }));
    },
  });
})();
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.extend,
    r = e.util.object.clone,
    n = e.util.toFixed,
    o = e.util.string.capitalize,
    s = e.util.degreesToRadians,
    a = !e.isLikelyNode,
    c = 2;
  e.Object ||
    ((e.Object = e.util.createClass(e.CommonMethods, {
      type: "object",
      originX: "left",
      originY: "top",
      top: 0,
      left: 0,
      width: 0,
      height: 0,
      scaleX: 1,
      scaleY: 1,
      flipX: !1,
      flipY: !1,
      opacity: 1,
      angle: 0,
      skewX: 0,
      skewY: 0,
      cornerSize: 13,
      touchCornerSize: 24,
      transparentCorners: !0,
      hoverCursor: null,
      moveCursor: null,
      padding: 0,
      borderColor: "rgb(178,204,255)",
      borderDashArray: null,
      cornerColor: "rgb(178,204,255)",
      cornerStrokeColor: null,
      cornerStyle: "rect",
      cornerDashArray: null,
      centeredScaling: !1,
      centeredRotation: !0,
      fill: "rgb(0,0,0)",
      fillRule: "nonzero",
      globalCompositeOperation: "source-over",
      backgroundColor: "",
      selectionBackgroundColor: "",
      stroke: null,
      strokeWidth: 1,
      strokeDashArray: null,
      strokeDashOffset: 0,
      strokeLineCap: "butt",
      strokeLineJoin: "miter",
      strokeMiterLimit: 4,
      shadow: null,
      borderOpacityWhenMoving: 0.4,
      borderScaleFactor: 1,
      minScaleLimit: 0,
      selectable: !0,
      evented: !0,
      visible: !0,
      hasControls: !0,
      hasBorders: !0,
      perPixelTargetFind: !1,
      includeDefaultValues: !0,
      lockMovementX: !1,
      lockMovementY: !1,
      lockRotation: !1,
      lockScalingX: !1,
      lockScalingY: !1,
      lockSkewingX: !1,
      lockSkewingY: !1,
      lockScalingFlip: !1,
      excludeFromExport: !1,
      objectCaching: a,
      statefullCache: !1,
      noScaleCache: !0,
      strokeUniform: !1,
      dirty: !0,
      __corner: 0,
      paintFirst: "fill",
      activeOn: "down",
      stateProperties:
        "top left width height scaleX scaleY flipX flipY originX originY transformMatrix stroke strokeWidth strokeDashArray strokeLineCap strokeDashOffset strokeLineJoin strokeMiterLimit angle opacity fill globalCompositeOperation shadow visible backgroundColor skewX skewY fillRule paintFirst clipPath strokeUniform".split(
          " "
        ),
      cacheProperties:
        "fill stroke strokeWidth strokeDashArray width height paintFirst strokeUniform strokeLineCap strokeDashOffset strokeLineJoin strokeMiterLimit backgroundColor clipPath".split(
          " "
        ),
      colorProperties: "fill stroke backgroundColor".split(" "),
      clipPath: void 0,
      inverted: !1,
      absolutePositioned: !1,
      initialize: function (t) {
        t && this.setOptions(t);
      },
      _createCacheCanvas: function () {
        (this._cacheProperties = {}),
          (this._cacheCanvas = e.util.createCanvasElement()),
          (this._cacheContext = this._cacheCanvas.getContext("2d")),
          this._updateCacheCanvas(),
          (this.dirty = !0);
      },
      _limitCacheSize: function (t) {
        var i = e.perfLimitSizeTotal,
          r = t.width,
          n = t.height,
          o = e.maxCacheSideLimit,
          s = e.minCacheSideLimit;
        if (o >= r && o >= n && i >= r * n)
          return s > r && (t.width = s), s > n && (t.height = s), t;
        var a = r / n,
          c = e.util.limitDimsByArea(a, i),
          l = e.util.capValue,
          u = l(s, c.x, o),
          h = l(s, c.y, o);
        return (
          r > u && ((t.zoomX /= r / u), (t.width = u), (t.capped = !0)),
          n > h && ((t.zoomY /= n / h), (t.height = h), (t.capped = !0)),
          t
        );
      },
      _getCacheCanvasDimensions: function () {
        var t = this.getTotalObjectScaling(),
          e = this._getTransformedDimensions(0, 0),
          i = (e.x * t.scaleX) / this.scaleX,
          r = (e.y * t.scaleY) / this.scaleY;
        return {
          width: i + c,
          height: r + c,
          zoomX: t.scaleX,
          zoomY: t.scaleY,
          x: i,
          y: r,
        };
      },
      _updateCacheCanvas: function () {
        var t = this.canvas;
        if (this.noScaleCache && t && t._currentTransform) {
          var i = t._currentTransform.target,
            r = t._currentTransform.action;
          if (this === i && r.slice && "scale" === r.slice(0, 5)) return !1;
        }
        var n,
          o,
          s = this._cacheCanvas,
          a = this._limitCacheSize(this._getCacheCanvasDimensions()),
          c = e.minCacheSideLimit,
          l = a.width,
          u = a.height,
          h = a.zoomX,
          f = a.zoomY,
          d = l !== this.cacheWidth || u !== this.cacheHeight,
          v = this.zoomX !== h || this.zoomY !== f,
          g = d || v,
          p = 0,
          m = 0,
          b = !1;
        if (d) {
          var y = this._cacheCanvas.width,
            _ = this._cacheCanvas.height,
            w = l > y || u > _,
            x = (0.9 * y > l || 0.9 * _ > u) && y > c && _ > c;
          (b = w || x),
            w &&
              !a.capped &&
              (l > c || u > c) &&
              ((p = 0.1 * l), (m = 0.1 * u));
        }
        return (
          this instanceof e.Text &&
            this.path &&
            ((g = !0),
            (b = !0),
            (p += this.getHeightOfLine(0) * this.zoomX),
            (m += this.getHeightOfLine(0) * this.zoomY)),
          g
            ? (b
                ? ((s.width = Math.ceil(l + p)), (s.height = Math.ceil(u + m)))
                : (this._cacheContext.setTransform(1, 0, 0, 1, 0, 0),
                  this._cacheContext.clearRect(0, 0, s.width, s.height)),
              (n = a.x / 2),
              (o = a.y / 2),
              (this.cacheTranslationX = Math.round(s.width / 2 - n) + n),
              (this.cacheTranslationY = Math.round(s.height / 2 - o) + o),
              (this.cacheWidth = l),
              (this.cacheHeight = u),
              this._cacheContext.translate(
                this.cacheTranslationX,
                this.cacheTranslationY
              ),
              this._cacheContext.scale(h, f),
              (this.zoomX = h),
              (this.zoomY = f),
              !0)
            : !1
        );
      },
      setOptions: function (t) {
        this._setOptions(t),
          this._initGradient(t.fill, "fill"),
          this._initGradient(t.stroke, "stroke"),
          this._initPattern(t.fill, "fill"),
          this._initPattern(t.stroke, "stroke");
      },
      transform: function (t) {
        var e =
            (this.group && !this.group._transformDone) ||
            (this.group && this.canvas && t === this.canvas.contextTop),
          i = this.calcTransformMatrix(!e);
        t.transform(i[0], i[1], i[2], i[3], i[4], i[5]);
      },
      toObject: function (t) {
        var i = e.Object.NUM_FRACTION_DIGITS,
          r = {
            type: this.type,
            version: e.version,
            originX: this.originX,
            originY: this.originY,
            left: n(this.left, i),
            top: n(this.top, i),
            width: n(this.width, i),
            height: n(this.height, i),
            fill:
              this.fill && this.fill.toObject
                ? this.fill.toObject()
                : this.fill,
            stroke:
              this.stroke && this.stroke.toObject
                ? this.stroke.toObject()
                : this.stroke,
            strokeWidth: n(this.strokeWidth, i),
            strokeDashArray: this.strokeDashArray
              ? this.strokeDashArray.concat()
              : this.strokeDashArray,
            strokeLineCap: this.strokeLineCap,
            strokeDashOffset: this.strokeDashOffset,
            strokeLineJoin: this.strokeLineJoin,
            strokeUniform: this.strokeUniform,
            strokeMiterLimit: n(this.strokeMiterLimit, i),
            scaleX: n(this.scaleX, i),
            scaleY: n(this.scaleY, i),
            angle: n(this.angle, i),
            flipX: this.flipX,
            flipY: this.flipY,
            opacity: n(this.opacity, i),
            shadow:
              this.shadow && this.shadow.toObject
                ? this.shadow.toObject()
                : this.shadow,
            visible: this.visible,
            backgroundColor: this.backgroundColor,
            fillRule: this.fillRule,
            paintFirst: this.paintFirst,
            globalCompositeOperation: this.globalCompositeOperation,
            skewX: n(this.skewX, i),
            skewY: n(this.skewY, i),
          };
        return (
          this.clipPath &&
            !this.clipPath.excludeFromExport &&
            ((r.clipPath = this.clipPath.toObject(t)),
            (r.clipPath.inverted = this.clipPath.inverted),
            (r.clipPath.absolutePositioned = this.clipPath.absolutePositioned)),
          e.util.populateWithProperties(this, r, t),
          this.includeDefaultValues || (r = this._removeDefaultValues(r)),
          r
        );
      },
      toDatalessObject: function (t) {
        return this.toObject(t);
      },
      _removeDefaultValues: function (t) {
        var i = e.util.getKlass(t.type).prototype,
          r = i.stateProperties;
        return (
          r.forEach(function (e) {
            "left" !== e &&
              "top" !== e &&
              (t[e] === i[e] && delete t[e],
              Array.isArray(t[e]) &&
                Array.isArray(i[e]) &&
                0 === t[e].length &&
                0 === i[e].length &&
                delete t[e]);
          }),
          t
        );
      },
      toString: function () {
        return "#<fabric." + o(this.type) + ">";
      },
      getObjectScaling: function () {
        if (!this.group) return { scaleX: this.scaleX, scaleY: this.scaleY };
        var t = e.util.qrDecompose(this.calcTransformMatrix());
        return { scaleX: Math.abs(t.scaleX), scaleY: Math.abs(t.scaleY) };
      },
      getTotalObjectScaling: function () {
        var t = this.getObjectScaling(),
          e = t.scaleX,
          i = t.scaleY;
        if (this.canvas) {
          var r = this.canvas.getZoom(),
            n = this.canvas.getRetinaScaling();
          (e *= r * n), (i *= r * n);
        }
        return { scaleX: e, scaleY: i };
      },
      getObjectOpacity: function () {
        var t = this.opacity;
        return this.group && (t *= this.group.getObjectOpacity()), t;
      },
      _set: function (t, i) {
        var r = "scaleX" === t || "scaleY" === t,
          n = this[t] !== i,
          o = !1;
        return (
          r && (i = this._constrainScale(i)),
          "scaleX" === t && 0 > i
            ? ((this.flipX = !this.flipX), (i *= -1))
            : "scaleY" === t && 0 > i
            ? ((this.flipY = !this.flipY), (i *= -1))
            : "shadow" !== t || !i || i instanceof e.Shadow
            ? "dirty" === t && this.group && this.group.set("dirty", i)
            : (i = new e.Shadow(i)),
          (this[t] = i),
          n &&
            ((o = this.group && this.group.isOnACache()),
            this.cacheProperties.indexOf(t) > -1
              ? ((this.dirty = !0), o && this.group.set("dirty", !0))
              : o &&
                this.stateProperties.indexOf(t) > -1 &&
                this.group.set("dirty", !0)),
          this
        );
      },
      setOnGroup: function () {},
      getViewportTransform: function () {
        return this.canvas && this.canvas.viewportTransform
          ? this.canvas.viewportTransform
          : e.iMatrix.concat();
      },
      isNotVisible: function () {
        return (
          0 === this.opacity ||
          (!this.width && !this.height && 0 === this.strokeWidth) ||
          !this.visible
        );
      },
      render: function (t) {
        this.isNotVisible() ||
          ((!this.canvas ||
            !this.canvas.skipOffscreen ||
            this.group ||
            this.isOnScreen()) &&
            (t.save(),
            this._setupCompositeOperation(t),
            this.drawSelectionBackground(t),
            this.transform(t),
            this._setOpacity(t),
            this._setShadow(t, this),
            this.shouldCache()
              ? (this.renderCache(), this.drawCacheOnCanvas(t))
              : (this._removeCacheCanvas(),
                (this.dirty = !1),
                this.drawObject(t),
                this.objectCaching &&
                  this.statefullCache &&
                  this.saveState({ propertySet: "cacheProperties" })),
            t.restore()));
      },
      renderCache: function (t) {
        (t = t || {}),
          (this._cacheCanvas && this._cacheContext) ||
            this._createCacheCanvas(),
          this.isCacheDirty() &&
            (this.statefullCache &&
              this.saveState({ propertySet: "cacheProperties" }),
            this.drawObject(this._cacheContext, t.forClipping),
            (this.dirty = !1));
      },
      _removeCacheCanvas: function () {
        (this._cacheCanvas = null),
          (this._cacheContext = null),
          (this.cacheWidth = 0),
          (this.cacheHeight = 0);
      },
      hasStroke: function () {
        return (
          this.stroke && "transparent" !== this.stroke && 0 !== this.strokeWidth
        );
      },
      hasFill: function () {
        return this.fill && "transparent" !== this.fill;
      },
      needsItsOwnCache: function () {
        return "stroke" === this.paintFirst &&
          this.hasFill() &&
          this.hasStroke() &&
          "object" == typeof this.shadow
          ? !0
          : this.clipPath
          ? !0
          : !1;
      },
      shouldCache: function () {
        return (
          (this.ownCaching =
            this.needsItsOwnCache() ||
            (this.objectCaching && (!this.group || !this.group.isOnACache()))),
          this.ownCaching
        );
      },
      willDrawShadow: function () {
        return (
          !!this.shadow &&
          (0 !== this.shadow.offsetX || 0 !== this.shadow.offsetY)
        );
      },
      drawClipPathOnCache: function (t, i) {
        if (
          (t.save(),
          (t.globalCompositeOperation = i.inverted
            ? "destination-out"
            : "destination-in"),
          i.absolutePositioned)
        ) {
          var r = e.util.invertTransform(this.calcTransformMatrix());
          t.transform(r[0], r[1], r[2], r[3], r[4], r[5]);
        }
        i.transform(t),
          t.scale(1 / i.zoomX, 1 / i.zoomY),
          t.drawImage(
            i._cacheCanvas,
            -i.cacheTranslationX,
            -i.cacheTranslationY
          ),
          t.restore();
      },
      drawObject: function (t, e) {
        var i = this.fill,
          r = this.stroke;
        e
          ? ((this.fill = "black"),
            (this.stroke = ""),
            this._setClippingProperties(t))
          : this._renderBackground(t),
          this._render(t),
          this._drawClipPath(t, this.clipPath),
          (this.fill = i),
          (this.stroke = r);
      },
      _drawClipPath: function (t, e) {
        e &&
          ((e.canvas = this.canvas),
          e.shouldCache(),
          (e._transformDone = !0),
          e.renderCache({ forClipping: !0 }),
          this.drawClipPathOnCache(t, e));
      },
      drawCacheOnCanvas: function (t) {
        t.scale(1 / this.zoomX, 1 / this.zoomY),
          t.drawImage(
            this._cacheCanvas,
            -this.cacheTranslationX,
            -this.cacheTranslationY
          );
      },
      isCacheDirty: function (t) {
        if (this.isNotVisible()) return !1;
        if (
          this._cacheCanvas &&
          this._cacheContext &&
          !t &&
          this._updateCacheCanvas()
        )
          return !0;
        if (
          this.dirty ||
          (this.clipPath && this.clipPath.absolutePositioned) ||
          (this.statefullCache && this.hasStateChanged("cacheProperties"))
        ) {
          if (this._cacheCanvas && this._cacheContext && !t) {
            var e = this.cacheWidth / this.zoomX,
              i = this.cacheHeight / this.zoomY;
            this._cacheContext.clearRect(-e / 2, -i / 2, e, i);
          }
          return !0;
        }
        return !1;
      },
      _renderBackground: function (t) {
        if (this.backgroundColor) {
          var e = this._getNonTransformedDimensions();
          (t.fillStyle = this.backgroundColor),
            t.fillRect(-e.x / 2, -e.y / 2, e.x, e.y),
            this._removeShadow(t);
        }
      },
      _setOpacity: function (t) {
        this.group && !this.group._transformDone
          ? (t.globalAlpha = this.getObjectOpacity())
          : (t.globalAlpha *= this.opacity);
      },
      _setStrokeStyles: function (t, e) {
        var i = e.stroke;
        i &&
          ((t.lineWidth = e.strokeWidth),
          (t.lineCap = e.strokeLineCap),
          (t.lineDashOffset = e.strokeDashOffset),
          (t.lineJoin = e.strokeLineJoin),
          (t.miterLimit = e.strokeMiterLimit),
          i.toLive
            ? "percentage" === i.gradientUnits ||
              i.gradientTransform ||
              i.patternTransform
              ? this._applyPatternForTransformedGradient(t, i)
              : ((t.strokeStyle = i.toLive(t, this)),
                this._applyPatternGradientTransform(t, i))
            : (t.strokeStyle = e.stroke));
      },
      _setFillStyles: function (t, e) {
        var i = e.fill;
        i &&
          (i.toLive
            ? ((t.fillStyle = i.toLive(t, this)),
              this._applyPatternGradientTransform(t, e.fill))
            : (t.fillStyle = i));
      },
      _setClippingProperties: function (t) {
        (t.globalAlpha = 1),
          (t.strokeStyle = "transparent"),
          (t.fillStyle = "#000000");
      },
      _setLineDash: function (t, e) {
        e &&
          0 !== e.length &&
          (1 & e.length && e.push.apply(e, e), t.setLineDash(e));
      },
      _renderControls: function (t, i) {
        var r,
          n,
          o,
          a = this.getViewportTransform(),
          c = this.calcTransformMatrix();
        (i = i || {}),
          (n =
            "undefined" != typeof i.hasBorders
              ? i.hasBorders
              : this.hasBorders),
          (o =
            "undefined" != typeof i.hasControls
              ? i.hasControls
              : this.hasControls),
          (c = e.util.multiplyTransformMatrices(a, c)),
          (r = e.util.qrDecompose(c)),
          t.save(),
          t.translate(r.translateX, r.translateY),
          (t.lineWidth = 1 * this.borderScaleFactor),
          this.group ||
            (t.globalAlpha = this.isMoving ? this.borderOpacityWhenMoving : 1),
          this.flipX && (r.angle -= 180),
          t.rotate(s(this.group ? r.angle : this.angle)),
          i.forActiveSelection || this.group
            ? n && this.drawBordersInGroup(t, r, i)
            : n && this.drawBorders(t, i),
          o && this.drawControls(t, i),
          t.restore();
      },
      _setShadow: function (t) {
        if (this.shadow) {
          var i,
            r = this.shadow,
            n = this.canvas,
            o = (n && n.viewportTransform[0]) || 1,
            s = (n && n.viewportTransform[3]) || 1;
          (i = r.nonScaling
            ? { scaleX: 1, scaleY: 1 }
            : this.getObjectScaling()),
            n &&
              n._isRetinaScaling() &&
              ((o *= e.devicePixelRatio), (s *= e.devicePixelRatio)),
            (t.shadowColor = r.color),
            (t.shadowBlur =
              (r.blur *
                e.browserShadowBlurConstant *
                (o + s) *
                (i.scaleX + i.scaleY)) /
              4),
            (t.shadowOffsetX = r.offsetX * o * i.scaleX),
            (t.shadowOffsetY = r.offsetY * s * i.scaleY);
        }
      },
      _removeShadow: function (t) {
        this.shadow &&
          ((t.shadowColor = ""),
          (t.shadowBlur = t.shadowOffsetX = t.shadowOffsetY = 0));
      },
      _applyPatternGradientTransform: function (t, e) {
        if (!e || !e.toLive) return { offsetX: 0, offsetY: 0 };
        var i = e.gradientTransform || e.patternTransform,
          r = -this.width / 2 + e.offsetX || 0,
          n = -this.height / 2 + e.offsetY || 0;
        return (
          "percentage" === e.gradientUnits
            ? t.transform(this.width, 0, 0, this.height, r, n)
            : t.transform(1, 0, 0, 1, r, n),
          i && t.transform(i[0], i[1], i[2], i[3], i[4], i[5]),
          { offsetX: r, offsetY: n }
        );
      },
      _renderPaintInOrder: function (t) {
        "stroke" === this.paintFirst
          ? (this._renderStroke(t), this._renderFill(t))
          : (this._renderFill(t), this._renderStroke(t));
      },
      _render: function () {},
      _renderFill: function (t) {
        this.fill &&
          (t.save(),
          this._setFillStyles(t, this),
          "evenodd" === this.fillRule ? t.fill("evenodd") : t.fill(),
          t.restore());
      },
      _renderStroke: function (t) {
        if (this.stroke && 0 !== this.strokeWidth) {
          if (
            (this.shadow && !this.shadow.affectStroke && this._removeShadow(t),
            t.save(),
            this.strokeUniform && this.group)
          ) {
            var e = this.getObjectScaling();
            t.scale(1 / e.scaleX, 1 / e.scaleY);
          } else
            this.strokeUniform && t.scale(1 / this.scaleX, 1 / this.scaleY);
          this._setLineDash(t, this.strokeDashArray),
            this._setStrokeStyles(t, this),
            t.stroke(),
            t.restore();
        }
      },
      _applyPatternForTransformedGradient: function (t, i) {
        var r,
          n = this._limitCacheSize(this._getCacheCanvasDimensions()),
          o = e.util.createCanvasElement(),
          s = this.canvas.getRetinaScaling(),
          a = n.x / this.scaleX / s,
          c = n.y / this.scaleY / s;
        (o.width = a),
          (o.height = c),
          (r = o.getContext("2d")),
          r.beginPath(),
          r.moveTo(0, 0),
          r.lineTo(a, 0),
          r.lineTo(a, c),
          r.lineTo(0, c),
          r.closePath(),
          r.translate(a / 2, c / 2),
          r.scale(n.zoomX / this.scaleX / s, n.zoomY / this.scaleY / s),
          this._applyPatternGradientTransform(r, i),
          (r.fillStyle = i.toLive(t)),
          r.fill(),
          t.translate(
            -this.width / 2 - this.strokeWidth / 2,
            -this.height / 2 - this.strokeWidth / 2
          ),
          t.scale((s * this.scaleX) / n.zoomX, (s * this.scaleY) / n.zoomY),
          (t.strokeStyle = r.createPattern(o, "no-repeat"));
      },
      _findCenterFromElement: function () {
        return { x: this.left + this.width / 2, y: this.top + this.height / 2 };
      },
      _assignTransformMatrixProps: function () {
        if (this.transformMatrix) {
          var t = e.util.qrDecompose(this.transformMatrix);
          (this.flipX = !1),
            (this.flipY = !1),
            this.set("scaleX", t.scaleX),
            this.set("scaleY", t.scaleY),
            (this.angle = t.angle),
            (this.skewX = t.skewX),
            (this.skewY = 0);
        }
      },
      _removeTransformMatrix: function (t) {
        var i = this._findCenterFromElement();
        this.transformMatrix &&
          (this._assignTransformMatrixProps(),
          (i = e.util.transformPoint(i, this.transformMatrix))),
          (this.transformMatrix = null),
          t &&
            ((this.scaleX *= t.scaleX),
            (this.scaleY *= t.scaleY),
            (this.cropX = t.cropX),
            (this.cropY = t.cropY),
            (i.x += t.offsetLeft),
            (i.y += t.offsetTop),
            (this.width = t.width),
            (this.height = t.height)),
          this.setPositionByOrigin(i, "center", "center");
      },
      clone: function (t, i) {
        var r = this.toObject(i);
        this.constructor.fromObject
          ? this.constructor.fromObject(r, t)
          : e.Object._fromObject("Object", r, t);
      },
      cloneAsImage: function (t, i) {
        var r = this.toCanvasElement(i);
        return t && t(new e.Image(r)), this;
      },
      toCanvasElement: function (t) {
        t || (t = {});
        var i = e.util,
          r = i.saveObjectTransform(this),
          n = this.group,
          o = this.shadow,
          s = Math.abs,
          a =
            (t.multiplier || 1) *
            (t.enableRetinaScaling ? e.devicePixelRatio : 1);
        delete this.group,
          t.withoutTransform && i.resetObjectTransform(this),
          t.withoutShadow && (this.shadow = null);
        var c,
          l,
          u,
          h,
          f = e.util.createCanvasElement(),
          d = this.getBoundingRect(!0, !0),
          v = this.shadow,
          g = { x: 0, y: 0 };
        v &&
          ((l = v.blur),
          (c = v.nonScaling
            ? { scaleX: 1, scaleY: 1 }
            : this.getObjectScaling()),
          (g.x = 2 * Math.round(s(v.offsetX) + l) * s(c.scaleX)),
          (g.y = 2 * Math.round(s(v.offsetY) + l) * s(c.scaleY))),
          (u = d.width + g.x),
          (h = d.height + g.y),
          (f.width = Math.ceil(u)),
          (f.height = Math.ceil(h));
        var p = new e.StaticCanvas(f, {
          enableRetinaScaling: !1,
          renderOnAddRemove: !1,
          skipOffscreen: !1,
        });
        "jpeg" === t.format && (p.backgroundColor = "#fff"),
          this.setPositionByOrigin(
            new e.Point(p.width / 2, p.height / 2),
            "center",
            "center"
          );
        var m = this.canvas;
        p.add(this);
        var b = p.toCanvasElement(a || 1, t);
        return (
          (this.shadow = o),
          this.set("canvas", m),
          n && (this.group = n),
          this.set(r).setCoords(),
          (p._objects = []),
          p.dispose(),
          (p = null),
          b
        );
      },
      toDataURL: function (t) {
        return (
          t || (t = {}),
          e.util.toDataURL(
            this.toCanvasElement(t),
            t.format || "png",
            t.quality || 1
          )
        );
      },
      isType: function (t) {
        return arguments.length > 1
          ? Array.from(arguments).includes(this.type)
          : this.type === t;
      },
      complexity: function () {
        return 1;
      },
      toJSON: function (t) {
        return this.toObject(t);
      },
      rotate: function (t) {
        var e =
          ("center" !== this.originX || "center" !== this.originY) &&
          this.centeredRotation;
        return (
          e && this._setOriginToCenter(),
          this.set("angle", t),
          e && this._resetOrigin(),
          this
        );
      },
      centerH: function () {
        return this.canvas && this.canvas.centerObjectH(this), this;
      },
      viewportCenterH: function () {
        return this.canvas && this.canvas.viewportCenterObjectH(this), this;
      },
      centerV: function () {
        return this.canvas && this.canvas.centerObjectV(this), this;
      },
      viewportCenterV: function () {
        return this.canvas && this.canvas.viewportCenterObjectV(this), this;
      },
      center: function () {
        return this.canvas && this.canvas.centerObject(this), this;
      },
      viewportCenter: function () {
        return this.canvas && this.canvas.viewportCenterObject(this), this;
      },
      getLocalPointer: function (t, i) {
        i = i || this.canvas.getPointer(t);
        var r = new e.Point(i.x, i.y),
          n = this._getLeftTopCoords();
        return (
          this.angle && (r = e.util.rotatePoint(r, n, s(-this.angle))),
          { x: r.x - n.x, y: r.y - n.y }
        );
      },
      _setupCompositeOperation: function (t) {
        this.globalCompositeOperation &&
          (t.globalCompositeOperation = this.globalCompositeOperation);
      },
      dispose: function () {
        e.runningAnimations && e.runningAnimations.cancelByTarget(this);
      },
    })),
    e.util.createAccessors && e.util.createAccessors(e.Object),
    i(e.Object.prototype, e.Observable),
    (e.Object.NUM_FRACTION_DIGITS = 2),
    (e.Object.ENLIVEN_PROPS = ["clipPath"]),
    (e.Object._fromObject = function (t, i, n, o) {
      var s = e[t];
      (i = r(i, !0)),
        e.util.enlivenPatterns([i.fill, i.stroke], function (t) {
          "undefined" != typeof t[0] && (i.fill = t[0]),
            "undefined" != typeof t[1] && (i.stroke = t[1]),
            e.util.enlivenObjectEnlivables(i, i, function () {
              var t = o ? new s(i[o], i) : new s(i);
              n && n(t);
            });
        });
    }),
    (e.Object.__uid = 0));
})("undefined" != typeof exports ? exports : this);
!(function () {
  var t = fabric.util.degreesToRadians,
    e = { left: -0.5, center: 0, right: 0.5 },
    n = { top: -0.5, center: 0, bottom: 0.5 };
  fabric.util.object.extend(fabric.Object.prototype, {
    translateToGivenOrigin: function (t, r, i, o, s) {
      var a,
        c,
        u,
        l = t.x,
        h = t.y;
      return (
        "string" == typeof r ? (r = e[r]) : (r -= 0.5),
        "string" == typeof o ? (o = e[o]) : (o -= 0.5),
        (a = o - r),
        "string" == typeof i ? (i = n[i]) : (i -= 0.5),
        "string" == typeof s ? (s = n[s]) : (s -= 0.5),
        (c = s - i),
        (a || c) &&
          ((u = this._getTransformedDimensions()),
          (l = t.x + a * u.x),
          (h = t.y + c * u.y)),
        new fabric.Point(l, h)
      );
    },
    translateToCenterPoint: function (e, n, r) {
      var i = this.translateToGivenOrigin(e, n, r, "center", "center");
      return this.angle ? fabric.util.rotatePoint(i, e, t(this.angle)) : i;
    },
    translateToOriginPoint: function (e, n, r) {
      var i = this.translateToGivenOrigin(e, "center", "center", n, r);
      return this.angle ? fabric.util.rotatePoint(i, e, t(this.angle)) : i;
    },
    getCenterPoint: function () {
      var t = new fabric.Point(this.left, this.top);
      return this.translateToCenterPoint(t, this.originX, this.originY);
    },
    getPointByOrigin: function (t, e) {
      var n = this.getCenterPoint();
      return this.translateToOriginPoint(n, t, e);
    },
    toLocalPoint: function (e, n, r) {
      var i,
        o,
        s = this.getCenterPoint();
      return (
        (i =
          "undefined" != typeof n && "undefined" != typeof r
            ? this.translateToGivenOrigin(s, "center", "center", n, r)
            : new fabric.Point(this.left, this.top)),
        (o = new fabric.Point(e.x, e.y)),
        this.angle && (o = fabric.util.rotatePoint(o, s, -t(this.angle))),
        o.subtractEquals(i)
      );
    },
    setPositionByOrigin: function (t, e, n) {
      var r = this.translateToCenterPoint(t, e, n),
        i = this.translateToOriginPoint(r, this.originX, this.originY);
      this.set("left", i.x), this.set("top", i.y);
    },
    adjustPosition: function (n) {
      var r,
        i,
        o = t(this.angle),
        s = this.getScaledWidth(),
        a = fabric.util.cos(o) * s,
        c = fabric.util.sin(o) * s;
      (r =
        "string" == typeof this.originX ? e[this.originX] : this.originX - 0.5),
        (i = "string" == typeof n ? e[n] : n - 0.5),
        (this.left += a * (i - r)),
        (this.top += c * (i - r)),
        this.setCoords(),
        (this.originX = n);
    },
    _setOriginToCenter: function () {
      (this._originalOriginX = this.originX),
        (this._originalOriginY = this.originY);
      var t = this.getCenterPoint();
      (this.originX = "center"),
        (this.originY = "center"),
        (this.left = t.x),
        (this.top = t.y);
    },
    _resetOrigin: function () {
      var t = this.translateToOriginPoint(
        this.getCenterPoint(),
        this._originalOriginX,
        this._originalOriginY
      );
      (this.originX = this._originalOriginX),
        (this.originY = this._originalOriginY),
        (this.left = t.x),
        (this.top = t.y),
        (this._originalOriginX = null),
        (this._originalOriginY = null);
    },
    _getLeftTopCoords: function () {
      return this.translateToOriginPoint(this.getCenterPoint(), "left", "top");
    },
  });
})();
!(function () {
  function t(t) {
    return [
      new fabric.Point(t.tl.x, t.tl.y),
      new fabric.Point(t.tr.x, t.tr.y),
      new fabric.Point(t.br.x, t.br.y),
      new fabric.Point(t.bl.x, t.bl.y),
    ];
  }
  var e = fabric.util,
    i = e.degreesToRadians,
    r = e.multiplyTransformMatrices,
    n = e.transformPoint;
  e.object.extend(fabric.Object.prototype, {
    oCoords: null,
    aCoords: null,
    lineCoords: null,
    ownMatrixCache: null,
    matrixCache: null,
    controls: {},
    _getCoords: function (t, e) {
      return e
        ? t
          ? this.calcACoords()
          : this.calcLineCoords()
        : ((this.aCoords && this.lineCoords) || this.setCoords(!0),
          t ? this.aCoords : this.lineCoords);
    },
    getCoords: function (e, i) {
      return t(this._getCoords(e, i));
    },
    intersectsWithRect: function (t, e, i, r) {
      var n = this.getCoords(i, r),
        o = fabric.Intersection.intersectPolygonRectangle(n, t, e);
      return "Intersection" === o.status;
    },
    intersectsWithObject: function (t, e, i) {
      var r = fabric.Intersection.intersectPolygonPolygon(
        this.getCoords(e, i),
        t.getCoords(e, i)
      );
      return (
        "Intersection" === r.status ||
        t.isContainedWithinObject(this, e, i) ||
        this.isContainedWithinObject(t, e, i)
      );
    },
    isContainedWithinObject: function (t, e, i) {
      for (
        var r = this.getCoords(e, i),
          n = e ? t.aCoords : t.lineCoords,
          o = 0,
          s = t._getImageLines(n);
        4 > o;
        o++
      )
        if (!t.containsPoint(r[o], s)) return !1;
      return !0;
    },
    isContainedWithinRect: function (t, e, i, r) {
      var n = this.getBoundingRect(i, r);
      return (
        n.left >= t.x &&
        n.left + n.width <= e.x &&
        n.top >= t.y &&
        n.top + n.height <= e.y
      );
    },
    containsPoint: function (t, e, i, r) {
      var n = this._getCoords(i, r),
        e = e || this._getImageLines(n),
        o = this._findCrossPoints(t, e);
      return 0 !== o && o % 2 === 1;
    },
    isOnScreen: function (t) {
      if (!this.canvas) return !1;
      var e = this.canvas.vptCoords.tl,
        i = this.canvas.vptCoords.br,
        r = this.getCoords(!0, t);
      return r.some(function (t) {
        return t.x <= i.x && t.x >= e.x && t.y <= i.y && t.y >= e.y;
      })
        ? !0
        : this.intersectsWithRect(e, i, !0, t)
        ? !0
        : this._containsCenterOfCanvas(e, i, t);
    },
    _containsCenterOfCanvas: function (t, e, i) {
      var r = { x: (t.x + e.x) / 2, y: (t.y + e.y) / 2 };
      return this.containsPoint(r, null, !0, i) ? !0 : !1;
    },
    isPartiallyOnScreen: function (t) {
      if (!this.canvas) return !1;
      var e = this.canvas.vptCoords.tl,
        i = this.canvas.vptCoords.br;
      if (this.intersectsWithRect(e, i, !0, t)) return !0;
      var r = this.getCoords(!0, t).every(function (t) {
        return (t.x >= i.x || t.x <= e.x) && (t.y >= i.y || t.y <= e.y);
      });
      return r && this._containsCenterOfCanvas(e, i, t);
    },
    _getImageLines: function (t) {
      var e = {
        topline: { o: t.tl, d: t.tr },
        rightline: { o: t.tr, d: t.br },
        bottomline: { o: t.br, d: t.bl },
        leftline: { o: t.bl, d: t.tl },
      };
      return e;
    },
    _findCrossPoints: function (t, e) {
      var i,
        r,
        n,
        o,
        s,
        a,
        c = 0;
      for (var l in e)
        if (
          ((a = e[l]),
          !(
            (a.o.y < t.y && a.d.y < t.y) ||
            (a.o.y >= t.y && a.d.y >= t.y) ||
            (a.o.x === a.d.x && a.o.x >= t.x
              ? (s = a.o.x)
              : ((i = 0),
                (r = (a.d.y - a.o.y) / (a.d.x - a.o.x)),
                (n = t.y - i * t.x),
                (o = a.o.y - r * a.o.x),
                (s = -(n - o) / (i - r))),
            s >= t.x && (c += 1),
            2 !== c)
          ))
        )
          break;
      return c;
    },
    getBoundingRect: function (t, i) {
      var r = this.getCoords(t, i);
      return e.makeBoundingBoxFromPoints(r);
    },
    getScaledWidth: function () {
      return this._getTransformedDimensions().x;
    },
    getScaledHeight: function () {
      return this._getTransformedDimensions().y;
    },
    _constrainScale: function (t) {
      return Math.abs(t) < this.minScaleLimit
        ? 0 > t
          ? -this.minScaleLimit
          : this.minScaleLimit
        : 0 === t
        ? 1e-4
        : t;
    },
    scale: function (t) {
      return this._set("scaleX", t), this._set("scaleY", t), this.setCoords();
    },
    scaleToWidth: function (t, e) {
      var i = this.getBoundingRect(e).width / this.getScaledWidth();
      return this.scale(t / this.width / i);
    },
    scaleToHeight: function (t, e) {
      var i = this.getBoundingRect(e).height / this.getScaledHeight();
      return this.scale(t / this.height / i);
    },
    calcLineCoords: function () {
      var t = this.getViewportTransform(),
        r = this.padding,
        o = i(this.angle),
        s = e.cos(o),
        a = e.sin(o),
        c = s * r,
        l = a * r,
        h = c + l,
        u = c - l,
        f = this.calcACoords(),
        d = { tl: n(f.tl, t), tr: n(f.tr, t), bl: n(f.bl, t), br: n(f.br, t) };
      return (
        r &&
          ((d.tl.x -= u),
          (d.tl.y -= h),
          (d.tr.x += h),
          (d.tr.y -= u),
          (d.bl.x -= h),
          (d.bl.y += u),
          (d.br.x += u),
          (d.br.y += h)),
        d
      );
    },
    calcOCoords: function () {
      var t = this._calcRotateMatrix(),
        e = this._calcTranslateMatrix(),
        i = this.getViewportTransform(),
        n = r(i, e),
        o = r(n, t),
        o = r(o, [1 / i[0], 0, 0, 1 / i[3], 0, 0]),
        s = this._calculateCurrentDimensions(),
        a = {};
      return (
        this.forEachControl(function (t, e, i) {
          a[e] = t.positionHandler(s, o, i);
        }),
        a
      );
    },
    calcACoords: function () {
      var t = this._calcRotateMatrix(),
        e = this._calcTranslateMatrix(),
        i = r(e, t),
        o = this._getTransformedDimensions(),
        s = o.x / 2,
        a = o.y / 2;
      return {
        tl: n({ x: -s, y: -a }, i),
        tr: n({ x: s, y: -a }, i),
        bl: n({ x: -s, y: a }, i),
        br: n({ x: s, y: a }, i),
      };
    },
    setCoords: function (t) {
      return (
        (this.aCoords = this.calcACoords()),
        (this.lineCoords = this.group ? this.aCoords : this.calcLineCoords()),
        t
          ? this
          : ((this.oCoords = this.calcOCoords()),
            this._setCornerCoords && this._setCornerCoords(),
            this)
      );
    },
    _calcRotateMatrix: function () {
      return e.calcRotateMatrix(this);
    },
    _calcTranslateMatrix: function () {
      var t = this.getCenterPoint();
      return [1, 0, 0, 1, t.x, t.y];
    },
    transformMatrixKey: function (t) {
      var e = "_",
        i = "";
      return (
        !t && this.group && (i = this.group.transformMatrixKey(t) + e),
        i +
          this.top +
          e +
          this.left +
          e +
          this.scaleX +
          e +
          this.scaleY +
          e +
          this.skewX +
          e +
          this.skewY +
          e +
          this.angle +
          e +
          this.originX +
          e +
          this.originY +
          e +
          this.width +
          e +
          this.height +
          e +
          this.strokeWidth +
          this.flipX +
          this.flipY
      );
    },
    calcTransformMatrix: function (t) {
      var e = this.calcOwnMatrix();
      if (t || !this.group) return e;
      var i = this.transformMatrixKey(t),
        n = this.matrixCache || (this.matrixCache = {});
      return n.key === i
        ? n.value
        : (this.group && (e = r(this.group.calcTransformMatrix(!1), e)),
          (n.key = i),
          (n.value = e),
          e);
    },
    calcOwnMatrix: function () {
      var t = this.transformMatrixKey(!0),
        i = this.ownMatrixCache || (this.ownMatrixCache = {});
      if (i.key === t) return i.value;
      var r = this._calcTranslateMatrix(),
        n = {
          angle: this.angle,
          translateX: r[4],
          translateY: r[5],
          scaleX: this.scaleX,
          scaleY: this.scaleY,
          skewX: this.skewX,
          skewY: this.skewY,
          flipX: this.flipX,
          flipY: this.flipY,
        };
      return (i.key = t), (i.value = e.composeMatrix(n)), i.value;
    },
    _getNonTransformedDimensions: function () {
      var t = this.strokeWidth,
        e = this.width + t,
        i = this.height + t;
      return { x: e, y: i };
    },
    _getTransformedDimensions: function (t, i) {
      "undefined" == typeof t && (t = this.skewX),
        "undefined" == typeof i && (i = this.skewY);
      var r,
        n,
        o,
        s = 0 === t && 0 === i;
      if (
        (this.strokeUniform
          ? ((n = this.width), (o = this.height))
          : ((r = this._getNonTransformedDimensions()), (n = r.x), (o = r.y)),
        s)
      )
        return this._finalizeDimensions(n * this.scaleX, o * this.scaleY);
      var a = e.sizeAfterTransform(n, o, {
        scaleX: this.scaleX,
        scaleY: this.scaleY,
        skewX: t,
        skewY: i,
      });
      return this._finalizeDimensions(a.x, a.y);
    },
    _finalizeDimensions: function (t, e) {
      return this.strokeUniform
        ? { x: t + this.strokeWidth, y: e + this.strokeWidth }
        : { x: t, y: e };
    },
    _calculateCurrentDimensions: function () {
      var t = this.getViewportTransform(),
        e = this._getTransformedDimensions(),
        i = n(e, t, !0);
      return i.scalarAdd(2 * this.padding);
    },
  });
})();
fabric.util.object.extend(fabric.Object.prototype, {
  sendToBack: function () {
    return (
      this.group
        ? fabric.StaticCanvas.prototype.sendToBack.call(this.group, this)
        : this.canvas && this.canvas.sendToBack(this),
      this
    );
  },
  bringToFront: function () {
    return (
      this.group
        ? fabric.StaticCanvas.prototype.bringToFront.call(this.group, this)
        : this.canvas && this.canvas.bringToFront(this),
      this
    );
  },
  sendBackwards: function (t) {
    return (
      this.group
        ? fabric.StaticCanvas.prototype.sendBackwards.call(this.group, this, t)
        : this.canvas && this.canvas.sendBackwards(this, t),
      this
    );
  },
  bringForward: function (t) {
    return (
      this.group
        ? fabric.StaticCanvas.prototype.bringForward.call(this.group, this, t)
        : this.canvas && this.canvas.bringForward(this, t),
      this
    );
  },
  moveTo: function (t) {
    return (
      this.group && "activeSelection" !== this.group.type
        ? fabric.StaticCanvas.prototype.moveTo.call(this.group, this, t)
        : this.canvas && this.canvas.moveTo(this, t),
      this
    );
  },
});
!(function () {
  function t(t, e) {
    if (e) {
      if (e.toLive) return t + ": url(#SVGID_" + e.id + "); ";
      var i = new fabric.Color(e),
        r = t + ": " + i.toRgb() + "; ",
        n = i.getAlpha();
      return 1 !== n && (r += t + "-opacity: " + n.toString() + "; "), r;
    }
    return t + ": none; ";
  }
  var e = fabric.util.toFixed;
  fabric.util.object.extend(fabric.Object.prototype, {
    getSvgStyles: function (e) {
      var i = this.fillRule ? this.fillRule : "nonzero",
        r = this.strokeWidth ? this.strokeWidth : "0",
        n = this.strokeDashArray ? this.strokeDashArray.join(" ") : "none",
        o = this.strokeDashOffset ? this.strokeDashOffset : "0",
        s = this.strokeLineCap ? this.strokeLineCap : "butt",
        a = this.strokeLineJoin ? this.strokeLineJoin : "miter",
        c = this.strokeMiterLimit ? this.strokeMiterLimit : "4",
        l = "undefined" != typeof this.opacity ? this.opacity : "1",
        h = this.visible ? "" : " visibility: hidden;",
        u = e ? "" : this.getSvgFilter(),
        f = t("fill", this.fill),
        d = t("stroke", this.stroke);
      return [
        d,
        "stroke-width: ",
        r,
        "; ",
        "stroke-dasharray: ",
        n,
        "; ",
        "stroke-linecap: ",
        s,
        "; ",
        "stroke-dashoffset: ",
        o,
        "; ",
        "stroke-linejoin: ",
        a,
        "; ",
        "stroke-miterlimit: ",
        c,
        "; ",
        f,
        "fill-rule: ",
        i,
        "; ",
        "opacity: ",
        l,
        ";",
        u,
        h,
      ].join("");
    },
    getSvgSpanStyles: function (e, i) {
      var r = "; ",
        n = e.fontFamily
          ? "font-family: " +
            (-1 === e.fontFamily.indexOf("'") &&
            -1 === e.fontFamily.indexOf('"')
              ? "'" + e.fontFamily + "'"
              : e.fontFamily) +
            r
          : "",
        o = e.strokeWidth ? "stroke-width: " + e.strokeWidth + r : "",
        n = n,
        s = e.fontSize ? "font-size: " + e.fontSize + "px" + r : "",
        a = e.fontStyle ? "font-style: " + e.fontStyle + r : "",
        c = e.fontWeight ? "font-weight: " + e.fontWeight + r : "",
        l = e.fill ? t("fill", e.fill) : "",
        h = e.stroke ? t("stroke", e.stroke) : "",
        u = this.getSvgTextDecoration(e),
        f = e.deltaY ? "baseline-shift: " + -e.deltaY + "; " : "";
      return (
        u && (u = "text-decoration: " + u + r),
        [h, o, n, s, a, c, u, l, f, i ? "white-space: pre; " : ""].join("")
      );
    },
    getSvgTextDecoration: function (t) {
      return ["overline", "underline", "line-through"]
        .filter(function (e) {
          return t[e.replace("-", "")];
        })
        .join(" ");
    },
    getSvgFilter: function () {
      return this.shadow ? "filter: url(#SVGID_" + this.shadow.id + ");" : "";
    },
    getSvgCommons: function () {
      return [
        this.id ? 'id="' + this.id + '" ' : "",
        this.clipPath
          ? 'clip-path="url(#' + this.clipPath.clipPathId + ')" '
          : "",
      ].join("");
    },
    getSvgTransform: function (t, e) {
      var i = t ? this.calcTransformMatrix() : this.calcOwnMatrix(),
        r = 'transform="' + fabric.util.matrixToSVG(i);
      return r + (e || "") + '" ';
    },
    _setSVGBg: function (t) {
      if (this.backgroundColor) {
        var i = fabric.Object.NUM_FRACTION_DIGITS;
        t.push(
          "		<rect ",
          this._getFillAttributes(this.backgroundColor),
          ' x="',
          e(-this.width / 2, i),
          '" y="',
          e(-this.height / 2, i),
          '" width="',
          e(this.width, i),
          '" height="',
          e(this.height, i),
          '"></rect>\n'
        );
      }
    },
    toSVG: function (t) {
      return this._createBaseSVGMarkup(this._toSVG(t), { reviver: t });
    },
    toClipPathSVG: function (t) {
      return (
        "	" + this._createBaseClipPathSVGMarkup(this._toSVG(t), { reviver: t })
      );
    },
    _createBaseClipPathSVGMarkup: function (t, e) {
      e = e || {};
      var i = e.reviver,
        r = e.additionalTransform || "",
        n = [this.getSvgTransform(!0, r), this.getSvgCommons()].join(""),
        o = t.indexOf("COMMON_PARTS");
      return (t[o] = n), i ? i(t.join("")) : t.join("");
    },
    _createBaseSVGMarkup: function (t, e) {
      e = e || {};
      var i,
        r,
        n = e.noStyle,
        o = e.reviver,
        s = n ? "" : 'style="' + this.getSvgStyles() + '" ',
        a = e.withShadow ? 'style="' + this.getSvgFilter() + '" ' : "",
        c = this.clipPath,
        l = this.strokeUniform ? 'vector-effect="non-scaling-stroke" ' : "",
        h = c && c.absolutePositioned,
        u = this.stroke,
        f = this.fill,
        d = this.shadow,
        g = [],
        v = t.indexOf("COMMON_PARTS"),
        p = e.additionalTransform;
      return (
        c &&
          ((c.clipPathId = "CLIPPATH_" + fabric.Object.__uid++),
          (r =
            '<clipPath id="' +
            c.clipPathId +
            '" >\n' +
            c.toClipPathSVG(o) +
            "</clipPath>\n")),
        h && g.push("<g ", a, this.getSvgCommons(), " >\n"),
        g.push(
          "<g ",
          this.getSvgTransform(!1),
          h ? "" : a + this.getSvgCommons(),
          " >\n"
        ),
        (i = [
          s,
          l,
          n ? "" : this.addPaintOrder(),
          " ",
          p ? 'transform="' + p + '" ' : "",
        ].join("")),
        (t[v] = i),
        f && f.toLive && g.push(f.toSVG(this)),
        u && u.toLive && g.push(u.toSVG(this)),
        d && g.push(d.toSVG(this)),
        c && g.push(r),
        g.push(t.join("")),
        g.push("</g>\n"),
        h && g.push("</g>\n"),
        o ? o(g.join("")) : g.join("")
      );
    },
    addPaintOrder: function () {
      return "fill" !== this.paintFirst
        ? ' paint-order="' + this.paintFirst + '" '
        : "";
    },
  });
})();
!(function () {
  function t(t, e, r) {
    var n = {},
      o = !0;
    r.forEach(function (e) {
      n[e] = t[e];
    }),
      i(t[e], n, o);
  }
  function e(t, i, r) {
    if (t === i) return !0;
    if (Array.isArray(t)) {
      if (!Array.isArray(i) || t.length !== i.length) return !1;
      for (var n = 0, o = t.length; o > n; n++) if (!e(t[n], i[n])) return !1;
      return !0;
    }
    if (t && "object" == typeof t) {
      var s,
        a = Object.keys(t);
      if (
        !i ||
        "object" != typeof i ||
        (!r && a.length !== Object.keys(i).length)
      )
        return !1;
      for (var n = 0, o = a.length; o > n; n++)
        if (((s = a[n]), "canvas" !== s && "group" !== s && !e(t[s], i[s])))
          return !1;
      return !0;
    }
  }
  var i = fabric.util.object.extend,
    r = "stateProperties";
  fabric.util.object.extend(fabric.Object.prototype, {
    hasStateChanged: function (t) {
      t = t || r;
      var i = "_" + t;
      return Object.keys(this[i]).length < this[t].length
        ? !0
        : !e(this[i], this, !0);
    },
    saveState: function (e) {
      var i = (e && e.propertySet) || r,
        n = "_" + i;
      return this[n]
        ? (t(this, n, this[i]),
          e && e.stateProperties && t(this, n, e.stateProperties),
          this)
        : this.setupState(e);
    },
    setupState: function (t) {
      t = t || {};
      var e = t.propertySet || r;
      return (t.propertySet = e), (this["_" + e] = {}), this.saveState(t), this;
    },
  });
})();
!(function () {
  var t = fabric.util.degreesToRadians;
  fabric.util.object.extend(fabric.Object.prototype, {
    _findTargetCorner: function (t, e) {
      if (
        !this.hasControls ||
        this.group ||
        !this.canvas ||
        this.canvas._activeObject !== this
      )
        return !1;
      var i,
        r,
        n,
        o = t.x,
        s = t.y,
        a = Object.keys(this.oCoords),
        c = a.length - 1;
      for (this.__corner = 0; c >= 0; c--)
        if (
          ((n = a[c]),
          this.isControlVisible(n) &&
            ((r = this._getImageLines(
              e ? this.oCoords[n].touchCorner : this.oCoords[n].corner
            )),
            (i = this._findCrossPoints({ x: o, y: s }, r)),
            0 !== i && i % 2 === 1))
        )
          return (this.__corner = n), n;
      return !1;
    },
    forEachControl: function (t) {
      for (var e in this.controls) t(this.controls[e], e, this);
    },
    _setCornerCoords: function () {
      var t = this.oCoords;
      for (var e in t) {
        var i = this.controls[e];
        (t[e].corner = i.calcCornerCoords(
          this.angle,
          this.cornerSize,
          t[e].x,
          t[e].y,
          !1
        )),
          (t[e].touchCorner = i.calcCornerCoords(
            this.angle,
            this.touchCornerSize,
            t[e].x,
            t[e].y,
            !0
          ));
      }
    },
    drawSelectionBackground: function (e) {
      if (
        !this.selectionBackgroundColor ||
        (this.canvas && !this.canvas.interactive) ||
        (this.canvas && this.canvas._activeObject !== this)
      )
        return this;
      e.save();
      var i = this.getCenterPoint(),
        r = this._calculateCurrentDimensions(),
        n = this.canvas.viewportTransform;
      return (
        e.translate(i.x, i.y),
        e.scale(1 / n[0], 1 / n[3]),
        e.rotate(t(this.angle)),
        (e.fillStyle = this.selectionBackgroundColor),
        e.fillRect(-r.x / 2, -r.y / 2, r.x, r.y),
        e.restore(),
        this
      );
    },
    drawBorders: function (t, e) {
      e = e || {};
      var i = this._calculateCurrentDimensions(),
        r = this.borderScaleFactor,
        n = i.x + r,
        o = i.y + r,
        s =
          "undefined" != typeof e.hasControls
            ? e.hasControls
            : this.hasControls,
        a = !1;
      return (
        t.save(),
        (t.strokeStyle = e.borderColor || this.borderColor),
        this._setLineDash(t, e.borderDashArray || this.borderDashArray),
        t.strokeRect(-n / 2, -o / 2, n, o),
        s &&
          (t.beginPath(),
          this.forEachControl(function (e, i, r) {
            e.withConnection &&
              e.getVisibility(r, i) &&
              ((a = !0),
              t.moveTo(e.x * n, e.y * o),
              t.lineTo(e.x * n + e.offsetX, e.y * o + e.offsetY));
          }),
          a && t.stroke()),
        t.restore(),
        this
      );
    },
    drawBordersInGroup: function (t, e, i) {
      i = i || {};
      var r = fabric.util.sizeAfterTransform(this.width, this.height, e),
        n = this.strokeWidth,
        o = this.strokeUniform,
        s = this.borderScaleFactor,
        a = r.x + n * (o ? this.canvas.getZoom() : e.scaleX) + s,
        c = r.y + n * (o ? this.canvas.getZoom() : e.scaleY) + s;
      return (
        t.save(),
        this._setLineDash(t, i.borderDashArray || this.borderDashArray),
        (t.strokeStyle = i.borderColor || this.borderColor),
        t.strokeRect(-a / 2, -c / 2, a, c),
        t.restore(),
        this
      );
    },
    drawControls: function (t, e) {
      (e = e || {}), t.save();
      var i,
        r,
        n = this.canvas.getRetinaScaling();
      return (
        t.setTransform(n, 0, 0, n, 0, 0),
        (t.strokeStyle = t.fillStyle = e.cornerColor || this.cornerColor),
        this.transparentCorners ||
          (t.strokeStyle = e.cornerStrokeColor || this.cornerStrokeColor),
        this._setLineDash(t, e.cornerDashArray || this.cornerDashArray),
        this.setCoords(),
        this.group && (i = this.group.calcTransformMatrix()),
        this.forEachControl(function (n, o, s) {
          (r = s.oCoords[o]),
            n.getVisibility(s, o) &&
              (i && (r = fabric.util.transformPoint(r, i)),
              n.render(t, r.x, r.y, e, s));
        }),
        t.restore(),
        this
      );
    },
    isControlVisible: function (t) {
      return this.controls[t] && this.controls[t].getVisibility(this, t);
    },
    setControlVisible: function (t, e) {
      return (
        this._controlsVisibility || (this._controlsVisibility = {}),
        (this._controlsVisibility[t] = e),
        this
      );
    },
    setControlsVisibility: function (t) {
      t || (t = {});
      for (var e in t) this.setControlVisible(e, t[e]);
      return this;
    },
    onDeselect: function () {},
    onSelect: function () {},
  });
})();
fabric.util.object.extend(fabric.StaticCanvas.prototype, {
  FX_DURATION: 500,
  fxCenterObjectH: function (t, e) {
    e = e || {};
    var i = function () {},
      r = e.onComplete || i,
      n = e.onChange || i,
      o = this;
    return fabric.util.animate({
      target: this,
      startValue: t.left,
      endValue: this.getCenterPoint().x,
      duration: this.FX_DURATION,
      onChange: function (e) {
        t.set("left", e), o.requestRenderAll(), n();
      },
      onComplete: function () {
        t.setCoords(), r();
      },
    });
  },
  fxCenterObjectV: function (t, e) {
    e = e || {};
    var i = function () {},
      r = e.onComplete || i,
      n = e.onChange || i,
      o = this;
    return fabric.util.animate({
      target: this,
      startValue: t.top,
      endValue: this.getCenterPoint().y,
      duration: this.FX_DURATION,
      onChange: function (e) {
        t.set("top", e), o.requestRenderAll(), n();
      },
      onComplete: function () {
        t.setCoords(), r();
      },
    });
  },
  fxRemove: function (t, e) {
    e = e || {};
    var i = function () {},
      r = e.onComplete || i,
      n = e.onChange || i,
      o = this;
    return fabric.util.animate({
      target: this,
      startValue: t.opacity,
      endValue: 0,
      duration: this.FX_DURATION,
      onChange: function (e) {
        t.set("opacity", e), o.requestRenderAll(), n();
      },
      onComplete: function () {
        o.remove(t), r();
      },
    });
  },
}),
  fabric.util.object.extend(fabric.Object.prototype, {
    animate: function () {
      if (arguments[0] && "object" == typeof arguments[0]) {
        var t,
          e,
          i = [],
          r = [];
        for (t in arguments[0]) i.push(t);
        for (var n = 0, o = i.length; o > n; n++)
          (t = i[n]),
            (e = n !== o - 1),
            r.push(this._animate(t, arguments[0][t], arguments[1], e));
        return r;
      }
      return this._animate.apply(this, arguments);
    },
    _animate: function (t, e, i, r) {
      var n,
        o = this;
      (e = e.toString()),
        (i = i ? fabric.util.object.clone(i) : {}),
        ~t.indexOf(".") && (n = t.split("."));
      var s =
          o.colorProperties.indexOf(t) > -1 ||
          (n && o.colorProperties.indexOf(n[1]) > -1),
        a = n ? this.get(n[0])[n[1]] : this.get(t);
      "from" in i || (i.from = a),
        s ||
          (e = ~e.indexOf("=")
            ? a + parseFloat(e.replace("=", ""))
            : parseFloat(e));
      var c = {
        target: this,
        startValue: i.from,
        endValue: e,
        byValue: i.by,
        easing: i.easing,
        duration: i.duration,
        abort:
          i.abort &&
          function (t, e, r) {
            return i.abort.call(o, t, e, r);
          },
        onChange: function (e, s, a) {
          n ? (o[n[0]][n[1]] = e) : o.set(t, e),
            r || (i.onChange && i.onChange(e, s, a));
        },
        onComplete: function (t, e, n) {
          r || (o.setCoords(), i.onComplete && i.onComplete(t, e, n));
        },
      };
      return s
        ? fabric.util.animateColor(c.startValue, c.endValue, c.duration, c)
        : fabric.util.animate(c);
    },
  });
!(function (t) {
  "use strict";
  function e(t, e) {
    var i = t.origin,
      r = t.axis1,
      n = t.axis2,
      s = t.dimension,
      o = e.nearest,
      a = e.center,
      c = e.farthest;
    return function () {
      switch (this.get(i)) {
        case o:
          return Math.min(this.get(r), this.get(n));
        case a:
          return Math.min(this.get(r), this.get(n)) + 0.5 * this.get(s);
        case c:
          return Math.max(this.get(r), this.get(n));
      }
    };
  }
  var i = t.fabric || (t.fabric = {}),
    r = i.util.object.extend,
    n = i.util.object.clone,
    s = { x1: 1, x2: 1, y1: 1, y2: 1 };
  return i.Line
    ? void i.warn("fabric.Line is already defined")
    : ((i.Line = i.util.createClass(i.Object, {
        type: "line",
        x1: 0,
        y1: 0,
        x2: 0,
        y2: 0,
        cacheProperties: i.Object.prototype.cacheProperties.concat(
          "x1",
          "x2",
          "y1",
          "y2"
        ),
        initialize: function (t, e) {
          t || (t = [0, 0, 0, 0]),
            this.callSuper("initialize", e),
            this.set("x1", t[0]),
            this.set("y1", t[1]),
            this.set("x2", t[2]),
            this.set("y2", t[3]),
            this._setWidthHeight(e);
        },
        _setWidthHeight: function (t) {
          t || (t = {}),
            (this.width = Math.abs(this.x2 - this.x1)),
            (this.height = Math.abs(this.y2 - this.y1)),
            (this.left = "left" in t ? t.left : this._getLeftToOriginX()),
            (this.top = "top" in t ? t.top : this._getTopToOriginY());
        },
        _set: function (t, e) {
          return (
            this.callSuper("_set", t, e),
            "undefined" != typeof s[t] && this._setWidthHeight(),
            this
          );
        },
        _getLeftToOriginX: e(
          { origin: "originX", axis1: "x1", axis2: "x2", dimension: "width" },
          { nearest: "left", center: "center", farthest: "right" }
        ),
        _getTopToOriginY: e(
          { origin: "originY", axis1: "y1", axis2: "y2", dimension: "height" },
          { nearest: "top", center: "center", farthest: "bottom" }
        ),
        _render: function (t) {
          t.beginPath();
          var e = this.calcLinePoints();
          t.moveTo(e.x1, e.y1),
            t.lineTo(e.x2, e.y2),
            (t.lineWidth = this.strokeWidth);
          var i = t.strokeStyle;
          (t.strokeStyle = this.stroke || t.fillStyle),
            this.stroke && this._renderStroke(t),
            (t.strokeStyle = i);
        },
        _findCenterFromElement: function () {
          return { x: (this.x1 + this.x2) / 2, y: (this.y1 + this.y2) / 2 };
        },
        toObject: function (t) {
          return r(this.callSuper("toObject", t), this.calcLinePoints());
        },
        _getNonTransformedDimensions: function () {
          var t = this.callSuper("_getNonTransformedDimensions");
          return (
            "butt" === this.strokeLineCap &&
              (0 === this.width && (t.y -= this.strokeWidth),
              0 === this.height && (t.x -= this.strokeWidth)),
            t
          );
        },
        calcLinePoints: function () {
          var t = this.x1 <= this.x2 ? -1 : 1,
            e = this.y1 <= this.y2 ? -1 : 1,
            i = t * this.width * 0.5,
            r = e * this.height * 0.5,
            n = t * this.width * -0.5,
            s = e * this.height * -0.5;
          return { x1: i, x2: n, y1: r, y2: s };
        },
        _toSVG: function () {
          var t = this.calcLinePoints();
          return [
            "<line ",
            "COMMON_PARTS",
            'x1="',
            t.x1,
            '" y1="',
            t.y1,
            '" x2="',
            t.x2,
            '" y2="',
            t.y2,
            '" />\n',
          ];
        },
      })),
      (i.Line.ATTRIBUTE_NAMES = i.SHARED_ATTRIBUTES.concat(
        "x1 y1 x2 y2".split(" ")
      )),
      (i.Line.fromElement = function (t, e, n) {
        n = n || {};
        var s = i.parseAttributes(t, i.Line.ATTRIBUTE_NAMES),
          o = [s.x1 || 0, s.y1 || 0, s.x2 || 0, s.y2 || 0];
        e(new i.Line(o, r(s, n)));
      }),
      void (i.Line.fromObject = function (t, e) {
        function r(t) {
          delete t.points, e && e(t);
        }
        var s = n(t, !0);
        (s.points = [t.x1, t.y1, t.x2, t.y2]),
          i.Object._fromObject("Line", s, r, "points");
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  function e(t) {
    return "radius" in t && t.radius >= 0;
  }
  var i = t.fabric || (t.fabric = {}),
    r = i.util.degreesToRadians;
  return i.Circle
    ? void i.warn("fabric.Circle is already defined.")
    : ((i.Circle = i.util.createClass(i.Object, {
        type: "circle",
        radius: 0,
        startAngle: 0,
        endAngle: 360,
        cacheProperties: i.Object.prototype.cacheProperties.concat(
          "radius",
          "startAngle",
          "endAngle"
        ),
        _set: function (t, e) {
          return (
            this.callSuper("_set", t, e),
            "radius" === t && this.setRadius(e),
            this
          );
        },
        toObject: function (t) {
          return this.callSuper(
            "toObject",
            ["radius", "startAngle", "endAngle"].concat(t)
          );
        },
        _toSVG: function () {
          var t,
            e = 0,
            n = 0,
            o = (this.endAngle - this.startAngle) % 360;
          if (0 === o)
            t = [
              "<circle ",
              "COMMON_PARTS",
              'cx="' + e + '" cy="' + n + '" ',
              'r="',
              this.radius,
              '" />\n',
            ];
          else {
            var s = r(this.startAngle),
              a = r(this.endAngle),
              c = this.radius,
              l = i.util.cos(s) * c,
              h = i.util.sin(s) * c,
              u = i.util.cos(a) * c,
              f = i.util.sin(a) * c,
              d = o > 180 ? "1" : "0";
            t = [
              '<path d="M ' + l + " " + h,
              " A " + c + " " + c,
              " 0 ",
              +d + " 1",
              " " + u + " " + f,
              '" ',
              "COMMON_PARTS",
              " />\n",
            ];
          }
          return t;
        },
        _render: function (t) {
          t.beginPath(),
            t.arc(0, 0, this.radius, r(this.startAngle), r(this.endAngle), !1),
            this._renderPaintInOrder(t);
        },
        getRadiusX: function () {
          return this.get("radius") * this.get("scaleX");
        },
        getRadiusY: function () {
          return this.get("radius") * this.get("scaleY");
        },
        setRadius: function (t) {
          return (
            (this.radius = t), this.set("width", 2 * t).set("height", 2 * t)
          );
        },
      })),
      (i.Circle.ATTRIBUTE_NAMES = i.SHARED_ATTRIBUTES.concat(
        "cx cy r".split(" ")
      )),
      (i.Circle.fromElement = function (t, r) {
        var n = i.parseAttributes(t, i.Circle.ATTRIBUTE_NAMES);
        if (!e(n))
          throw new Error(
            "value of `r` attribute is required and can not be negative"
          );
        (n.left = (n.left || 0) - n.radius),
          (n.top = (n.top || 0) - n.radius),
          r(new i.Circle(n));
      }),
      void (i.Circle.fromObject = function (t, e) {
        i.Object._fromObject("Circle", t, e);
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {});
  return e.Triangle
    ? void e.warn("fabric.Triangle is already defined")
    : ((e.Triangle = e.util.createClass(e.Object, {
        type: "triangle",
        width: 100,
        height: 100,
        _render: function (t) {
          var e = this.width / 2,
            i = this.height / 2;
          t.beginPath(),
            t.moveTo(-e, i),
            t.lineTo(0, -i),
            t.lineTo(e, i),
            t.closePath(),
            this._renderPaintInOrder(t);
        },
        _toSVG: function () {
          var t = this.width / 2,
            e = this.height / 2,
            i = [-t + " " + e, "0 " + -e, t + " " + e].join(",");
          return ["<polygon ", "COMMON_PARTS", 'points="', i, '" />'];
        },
      })),
      void (e.Triangle.fromObject = function (t, i) {
        return e.Object._fromObject("Triangle", t, i);
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = 2 * Math.PI;
  return e.Ellipse
    ? void e.warn("fabric.Ellipse is already defined.")
    : ((e.Ellipse = e.util.createClass(e.Object, {
        type: "ellipse",
        rx: 0,
        ry: 0,
        cacheProperties: e.Object.prototype.cacheProperties.concat("rx", "ry"),
        initialize: function (t) {
          this.callSuper("initialize", t),
            this.set("rx", (t && t.rx) || 0),
            this.set("ry", (t && t.ry) || 0);
        },
        _set: function (t, e) {
          switch ((this.callSuper("_set", t, e), t)) {
            case "rx":
              (this.rx = e), this.set("width", 2 * e);
              break;
            case "ry":
              (this.ry = e), this.set("height", 2 * e);
          }
          return this;
        },
        getRx: function () {
          return this.get("rx") * this.get("scaleX");
        },
        getRy: function () {
          return this.get("ry") * this.get("scaleY");
        },
        toObject: function (t) {
          return this.callSuper("toObject", ["rx", "ry"].concat(t));
        },
        _toSVG: function () {
          return [
            "<ellipse ",
            "COMMON_PARTS",
            'cx="0" cy="0" ',
            'rx="',
            this.rx,
            '" ry="',
            this.ry,
            '" />\n',
          ];
        },
        _render: function (t) {
          t.beginPath(),
            t.save(),
            t.transform(1, 0, 0, this.ry / this.rx, 0, 0),
            t.arc(0, 0, this.rx, 0, i, !1),
            t.restore(),
            this._renderPaintInOrder(t);
        },
      })),
      (e.Ellipse.ATTRIBUTE_NAMES = e.SHARED_ATTRIBUTES.concat(
        "cx cy rx ry".split(" ")
      )),
      (e.Ellipse.fromElement = function (t, i) {
        var r = e.parseAttributes(t, e.Ellipse.ATTRIBUTE_NAMES);
        (r.left = (r.left || 0) - r.rx),
          (r.top = (r.top || 0) - r.ry),
          i(new e.Ellipse(r));
      }),
      void (e.Ellipse.fromObject = function (t, i) {
        e.Object._fromObject("Ellipse", t, i);
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.extend;
  return e.Rect
    ? void e.warn("fabric.Rect is already defined")
    : ((e.Rect = e.util.createClass(e.Object, {
        stateProperties: e.Object.prototype.stateProperties.concat("rx", "ry"),
        type: "rect",
        rx: 0,
        ry: 0,
        cacheProperties: e.Object.prototype.cacheProperties.concat("rx", "ry"),
        initialize: function (t) {
          this.callSuper("initialize", t), this._initRxRy();
        },
        _initRxRy: function () {
          this.rx && !this.ry
            ? (this.ry = this.rx)
            : this.ry && !this.rx && (this.rx = this.ry);
        },
        _render: function (t) {
          var e = this.rx ? Math.min(this.rx, this.width / 2) : 0,
            i = this.ry ? Math.min(this.ry, this.height / 2) : 0,
            r = this.width,
            n = this.height,
            s = -this.width / 2,
            o = -this.height / 2,
            a = 0 !== e || 0 !== i,
            c = 0.4477152502;
          t.beginPath(),
            t.moveTo(s + e, o),
            t.lineTo(s + r - e, o),
            a &&
              t.bezierCurveTo(s + r - c * e, o, s + r, o + c * i, s + r, o + i),
            t.lineTo(s + r, o + n - i),
            a &&
              t.bezierCurveTo(
                s + r,
                o + n - c * i,
                s + r - c * e,
                o + n,
                s + r - e,
                o + n
              ),
            t.lineTo(s + e, o + n),
            a &&
              t.bezierCurveTo(s + c * e, o + n, s, o + n - c * i, s, o + n - i),
            t.lineTo(s, o + i),
            a && t.bezierCurveTo(s, o + c * i, s + c * e, o, s + e, o),
            t.closePath(),
            this._renderPaintInOrder(t);
        },
        toObject: function (t) {
          return this.callSuper("toObject", ["rx", "ry"].concat(t));
        },
        _toSVG: function () {
          var t = -this.width / 2,
            e = -this.height / 2;
          return [
            "<rect ",
            "COMMON_PARTS",
            'x="',
            t,
            '" y="',
            e,
            '" rx="',
            this.rx,
            '" ry="',
            this.ry,
            '" width="',
            this.width,
            '" height="',
            this.height,
            '" />\n',
          ];
        },
      })),
      (e.Rect.ATTRIBUTE_NAMES = e.SHARED_ATTRIBUTES.concat(
        "x y rx ry width height".split(" ")
      )),
      (e.Rect.fromElement = function (t, r, n) {
        if (!t) return r(null);
        n = n || {};
        var s = e.parseAttributes(t, e.Rect.ATTRIBUTE_NAMES);
        (s.left = s.left || 0),
          (s.top = s.top || 0),
          (s.height = s.height || 0),
          (s.width = s.width || 0);
        var o = new e.Rect(i(n ? e.util.object.clone(n) : {}, s));
        (o.visible = o.visible && o.width > 0 && o.height > 0), r(o);
      }),
      void (e.Rect.fromObject = function (t, i) {
        return e.Object._fromObject("Rect", t, i);
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.extend,
    r = e.util.array.min,
    n = e.util.array.max,
    s = e.util.toFixed,
    o = e.util.projectStrokeOnPoints;
  return e.Polyline
    ? void e.warn("fabric.Polyline is already defined")
    : ((e.Polyline = e.util.createClass(e.Object, {
        type: "polyline",
        points: null,
        exactBoundingBox: !1,
        cacheProperties: e.Object.prototype.cacheProperties.concat("points"),
        initialize: function (t, e) {
          (e = e || {}),
            (this.points = t || []),
            this.callSuper("initialize", e),
            this._setPositionDimensions(e);
        },
        _projectStrokeOnPoints: function () {
          return o(this.points, this, !0);
        },
        _setPositionDimensions: function (t) {
          var e,
            i = this._calcDimensions(t),
            r = this.exactBoundingBox ? this.strokeWidth : 0;
          (this.width = i.width - r),
            (this.height = i.height - r),
            t.fromSVG ||
              (e = this.translateToGivenOrigin(
                {
                  x: i.left - this.strokeWidth / 2 + r / 2,
                  y: i.top - this.strokeWidth / 2 + r / 2,
                },
                "left",
                "top",
                this.originX,
                this.originY
              )),
            "undefined" == typeof t.left &&
              (this.left = t.fromSVG ? i.left : e.x),
            "undefined" == typeof t.top && (this.top = t.fromSVG ? i.top : e.y),
            (this.pathOffset = {
              x: i.left + this.width / 2 + r / 2,
              y: i.top + this.height / 2 + r / 2,
            });
        },
        _calcDimensions: function () {
          var t = this.exactBoundingBox
              ? this._projectStrokeOnPoints()
              : this.points,
            e = r(t, "x") || 0,
            i = r(t, "y") || 0,
            s = n(t, "x") || 0,
            o = n(t, "y") || 0,
            a = s - e,
            c = o - i;
          return { left: e, top: i, width: a, height: c };
        },
        toObject: function (t) {
          return i(this.callSuper("toObject", t), {
            points: this.points.concat(),
          });
        },
        _toSVG: function () {
          for (
            var t = [],
              i = this.pathOffset.x,
              r = this.pathOffset.y,
              n = e.Object.NUM_FRACTION_DIGITS,
              o = 0,
              a = this.points.length;
            a > o;
            o++
          )
            t.push(
              s(this.points[o].x - i, n),
              ",",
              s(this.points[o].y - r, n),
              " "
            );
          return [
            "<" + this.type + " ",
            "COMMON_PARTS",
            'points="',
            t.join(""),
            '" />\n',
          ];
        },
        commonRender: function (t) {
          var e,
            i = this.points.length,
            r = this.pathOffset.x,
            n = this.pathOffset.y;
          if (!i || isNaN(this.points[i - 1].y)) return !1;
          t.beginPath(), t.moveTo(this.points[0].x - r, this.points[0].y - n);
          for (var s = 0; i > s; s++)
            (e = this.points[s]), t.lineTo(e.x - r, e.y - n);
          return !0;
        },
        _render: function (t) {
          this.commonRender(t) && this._renderPaintInOrder(t);
        },
        complexity: function () {
          return this.get("points").length;
        },
      })),
      (e.Polyline.ATTRIBUTE_NAMES = e.SHARED_ATTRIBUTES.concat()),
      (e.Polyline.fromElementGenerator = function (t) {
        return function (r, n, s) {
          if (!r) return n(null);
          s || (s = {});
          var o = e.parsePointsAttribute(r.getAttribute("points")),
            a = e.parseAttributes(r, e[t].ATTRIBUTE_NAMES);
          (a.fromSVG = !0), n(new e[t](o, i(a, s)));
        };
      }),
      (e.Polyline.fromElement = e.Polyline.fromElementGenerator("Polyline")),
      void (e.Polyline.fromObject = function (t, i) {
        return e.Object._fromObject("Polyline", t, i, "points");
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.projectStrokeOnPoints;
  return e.Polygon
    ? void e.warn("fabric.Polygon is already defined")
    : ((e.Polygon = e.util.createClass(e.Polyline, {
        type: "polygon",
        _projectStrokeOnPoints: function () {
          return i(this.points, this);
        },
        _render: function (t) {
          this.commonRender(t) && (t.closePath(), this._renderPaintInOrder(t));
        },
      })),
      (e.Polygon.ATTRIBUTE_NAMES = e.SHARED_ATTRIBUTES.concat()),
      (e.Polygon.fromElement = e.Polyline.fromElementGenerator("Polygon")),
      void (e.Polygon.fromObject = function (t, i) {
        e.Object._fromObject("Polygon", t, i, "points");
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.array.min,
    r = e.util.array.max,
    n = e.util.object.extend,
    s = e.util.object.clone,
    o = e.util.toFixed;
  return e.Path
    ? void e.warn("fabric.Path is already defined")
    : ((e.Path = e.util.createClass(e.Object, {
        type: "path",
        path: null,
        cacheProperties: e.Object.prototype.cacheProperties.concat(
          "path",
          "fillRule"
        ),
        stateProperties: e.Object.prototype.stateProperties.concat("path"),
        initialize: function (t, e) {
          (e = s(e || {})),
            delete e.path,
            this.callSuper("initialize", e),
            this._setPath(t || [], e);
        },
        _setPath: function (t, i) {
          (this.path = e.util.makePathSimpler(
            Array.isArray(t) ? t : e.util.parsePath(t)
          )),
            e.Polyline.prototype._setPositionDimensions.call(this, i || {});
        },
        _renderPathCommands: function (t) {
          var e,
            i = 0,
            r = 0,
            n = 0,
            s = 0,
            o = 0,
            a = 0,
            c = -this.pathOffset.x,
            h = -this.pathOffset.y;
          t.beginPath();
          for (var l = 0, u = this.path.length; u > l; ++l)
            switch (((e = this.path[l]), e[0])) {
              case "L":
                (n = e[1]), (s = e[2]), t.lineTo(n + c, s + h);
                break;
              case "M":
                (n = e[1]),
                  (s = e[2]),
                  (i = n),
                  (r = s),
                  t.moveTo(n + c, s + h);
                break;
              case "C":
                (n = e[5]),
                  (s = e[6]),
                  (o = e[3]),
                  (a = e[4]),
                  t.bezierCurveTo(
                    e[1] + c,
                    e[2] + h,
                    o + c,
                    a + h,
                    n + c,
                    s + h
                  );
                break;
              case "Q":
                t.quadraticCurveTo(e[1] + c, e[2] + h, e[3] + c, e[4] + h),
                  (n = e[3]),
                  (s = e[4]),
                  (o = e[1]),
                  (a = e[2]);
                break;
              case "z":
              case "Z":
                (n = i), (s = r), t.closePath();
            }
        },
        _render: function (t) {
          this._renderPathCommands(t), this._renderPaintInOrder(t);
        },
        toString: function () {
          return (
            "#<fabric.Path (" +
            this.complexity() +
            '): { "top": ' +
            this.top +
            ', "left": ' +
            this.left +
            " }>"
          );
        },
        toObject: function (t) {
          return n(this.callSuper("toObject", t), {
            path: this.path.map(function (t) {
              return t.slice();
            }),
          });
        },
        toDatalessObject: function (t) {
          var e = this.toObject(["sourcePath"].concat(t));
          return e.sourcePath && delete e.path, e;
        },
        _toSVG: function () {
          var t = e.util.joinPath(this.path);
          return [
            "<path ",
            "COMMON_PARTS",
            'd="',
            t,
            '" stroke-linecap="round" ',
            "/>\n",
          ];
        },
        _getOffsetTransform: function () {
          var t = e.Object.NUM_FRACTION_DIGITS;
          return (
            " translate(" +
            o(-this.pathOffset.x, t) +
            ", " +
            o(-this.pathOffset.y, t) +
            ")"
          );
        },
        toClipPathSVG: function (t) {
          var e = this._getOffsetTransform();
          return (
            "	" +
            this._createBaseClipPathSVGMarkup(this._toSVG(), {
              reviver: t,
              additionalTransform: e,
            })
          );
        },
        toSVG: function (t) {
          var e = this._getOffsetTransform();
          return this._createBaseSVGMarkup(this._toSVG(), {
            reviver: t,
            additionalTransform: e,
          });
        },
        complexity: function () {
          return this.path.length;
        },
        _calcDimensions: function () {
          for (
            var t,
              n,
              s = [],
              o = [],
              a = 0,
              c = 0,
              h = 0,
              l = 0,
              u = 0,
              f = this.path.length;
            f > u;
            ++u
          ) {
            switch (((t = this.path[u]), t[0])) {
              case "L":
                (h = t[1]), (l = t[2]), (n = []);
                break;
              case "M":
                (h = t[1]), (l = t[2]), (a = h), (c = l), (n = []);
                break;
              case "C":
                (n = e.util.getBoundsOfCurve(
                  h,
                  l,
                  t[1],
                  t[2],
                  t[3],
                  t[4],
                  t[5],
                  t[6]
                )),
                  (h = t[5]),
                  (l = t[6]);
                break;
              case "Q":
                (n = e.util.getBoundsOfCurve(
                  h,
                  l,
                  t[1],
                  t[2],
                  t[1],
                  t[2],
                  t[3],
                  t[4]
                )),
                  (h = t[3]),
                  (l = t[4]);
                break;
              case "z":
              case "Z":
                (h = a), (l = c);
            }
            n.forEach(function (t) {
              s.push(t.x), o.push(t.y);
            }),
              s.push(h),
              o.push(l);
          }
          var d = i(s) || 0,
            g = i(o) || 0,
            p = r(s) || 0,
            v = r(o) || 0,
            m = p - d,
            b = v - g;
          return { left: d, top: g, width: m, height: b };
        },
      })),
      (e.Path.fromObject = function (t, i) {
        if ("string" == typeof t.sourcePath) {
          var r = t.sourcePath;
          e.loadSVGFromURL(r, function (e) {
            var r = e[0];
            r.setOptions(t), i && i(r);
          });
        } else e.Object._fromObject("Path", t, i, "path");
      }),
      (e.Path.ATTRIBUTE_NAMES = e.SHARED_ATTRIBUTES.concat(["d"])),
      void (e.Path.fromElement = function (t, i, r) {
        var s = e.parseAttributes(t, e.Path.ATTRIBUTE_NAMES);
        (s.fromSVG = !0), i(new e.Path(s.d, n(s, r)));
      }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.array.min,
    r = e.util.array.max;
  e.Group ||
    ((e.Group = e.util.createClass(e.Object, e.Collection, {
      type: "group",
      strokeWidth: 0,
      subTargetCheck: !1,
      cacheProperties: [],
      useSetOnGroup: !1,
      initialize: function (t, e, i) {
        (e = e || {}),
          (this._objects = []),
          i && this.callSuper("initialize", e),
          (this._objects = t || []);
        for (var r = this._objects.length; r--; ) this._objects[r].group = this;
        if (i) this._updateObjectsACoords();
        else {
          var n = e && e.centerPoint;
          void 0 !== e.originX && (this.originX = e.originX),
            void 0 !== e.originY && (this.originY = e.originY),
            n || this._calcBounds(),
            this._updateObjectsCoords(n),
            delete e.centerPoint,
            this.callSuper("initialize", e);
        }
        this.setCoords();
      },
      _updateObjectsACoords: function () {
        for (var t = !0, e = this._objects.length; e--; )
          this._objects[e].setCoords(t);
      },
      _updateObjectsCoords: function (t) {
        for (
          var t = t || this.getCenterPoint(), e = this._objects.length;
          e--;

        )
          this._updateObjectCoords(this._objects[e], t);
      },
      _updateObjectCoords: function (t, e) {
        var i = t.left,
          r = t.top,
          n = !0;
        t.set({ left: i - e.x, top: r - e.y }),
          (t.group = this),
          t.setCoords(n);
      },
      toString: function () {
        return "#<fabric.Group: (" + this.complexity() + ")>";
      },
      addWithUpdate: function (t) {
        var i = !!this.group;
        return (
          this._restoreObjectsState(),
          e.util.resetObjectTransform(this),
          t &&
            (i &&
              e.util.removeTransformFromObject(
                t,
                this.group.calcTransformMatrix()
              ),
            this._objects.push(t),
            (t.group = this),
            t._set("canvas", this.canvas)),
          this._calcBounds(),
          this._updateObjectsCoords(),
          (this.dirty = !0),
          i ? this.group.addWithUpdate() : this.setCoords(),
          this
        );
      },
      removeWithUpdate: function (t) {
        return (
          this._restoreObjectsState(),
          e.util.resetObjectTransform(this),
          this.remove(t),
          this._calcBounds(),
          this._updateObjectsCoords(),
          this.setCoords(),
          (this.dirty = !0),
          this
        );
      },
      _onObjectAdded: function (t) {
        (this.dirty = !0), (t.group = this), t._set("canvas", this.canvas);
      },
      _onObjectRemoved: function (t) {
        (this.dirty = !0), delete t.group;
      },
      _set: function (t, i) {
        var r = this._objects.length;
        if (this.useSetOnGroup) for (; r--; ) this._objects[r].setOnGroup(t, i);
        if ("canvas" === t) for (; r--; ) this._objects[r]._set(t, i);
        e.Object.prototype._set.call(this, t, i);
      },
      toObject: function (t) {
        var i = this.includeDefaultValues,
          r = this._objects
            .filter(function (t) {
              return !t.excludeFromExport;
            })
            .map(function (e) {
              var r = e.includeDefaultValues;
              e.includeDefaultValues = i;
              var n = e.toObject(t);
              return (e.includeDefaultValues = r), n;
            }),
          n = e.Object.prototype.toObject.call(this, t);
        return (n.objects = r), n;
      },
      toDatalessObject: function (t) {
        var i,
          r = this.sourcePath;
        if (r) i = r;
        else {
          var n = this.includeDefaultValues;
          i = this._objects.map(function (e) {
            var i = e.includeDefaultValues;
            e.includeDefaultValues = n;
            var r = e.toDatalessObject(t);
            return (e.includeDefaultValues = i), r;
          });
        }
        var s = e.Object.prototype.toDatalessObject.call(this, t);
        return (s.objects = i), s;
      },
      render: function (t) {
        (this._transformDone = !0),
          this.callSuper("render", t),
          (this._transformDone = !1);
      },
      shouldCache: function () {
        var t = e.Object.prototype.shouldCache.call(this);
        if (t)
          for (var i = 0, r = this._objects.length; r > i; i++)
            if (this._objects[i].willDrawShadow())
              return (this.ownCaching = !1), !1;
        return t;
      },
      willDrawShadow: function () {
        if (e.Object.prototype.willDrawShadow.call(this)) return !0;
        for (var t = 0, i = this._objects.length; i > t; t++)
          if (this._objects[t].willDrawShadow()) return !0;
        return !1;
      },
      isOnACache: function () {
        return this.ownCaching || (this.group && this.group.isOnACache());
      },
      drawObject: function (t) {
        for (var e = 0, i = this._objects.length; i > e; e++)
          this._objects[e].render(t);
        this._drawClipPath(t, this.clipPath);
      },
      isCacheDirty: function (t) {
        if (this.callSuper("isCacheDirty", t)) return !0;
        if (!this.statefullCache) return !1;
        for (var e = 0, i = this._objects.length; i > e; e++)
          if (this._objects[e].isCacheDirty(!0)) {
            if (this._cacheCanvas) {
              var r = this.cacheWidth / this.zoomX,
                n = this.cacheHeight / this.zoomY;
              this._cacheContext.clearRect(-r / 2, -n / 2, r, n);
            }
            return !0;
          }
        return !1;
      },
      _restoreObjectsState: function () {
        var t = this.calcOwnMatrix();
        return (
          this._objects.forEach(function (i) {
            e.util.addTransformToObject(i, t), delete i.group, i.setCoords();
          }),
          this
        );
      },
      destroy: function () {
        return (
          this._objects.forEach(function (t) {
            t.set("dirty", !0);
          }),
          this._restoreObjectsState()
        );
      },
      dispose: function () {
        this.callSuper("dispose"),
          this.forEachObject(function (t) {
            t.dispose && t.dispose();
          }),
          (this._objects = []);
      },
      toActiveSelection: function () {
        if (this.canvas) {
          var t = this._objects,
            i = this.canvas;
          this._objects = [];
          var r = this.toObject();
          delete r.objects;
          var n = new e.ActiveSelection([]);
          return (
            n.set(r),
            (n.type = "activeSelection"),
            i.remove(this),
            t.forEach(function (t) {
              (t.group = n), (t.dirty = !0), i.add(t);
            }),
            (n.canvas = i),
            (n._objects = t),
            (i._activeObject = n),
            n.setCoords(),
            n
          );
        }
      },
      ungroupOnCanvas: function () {
        return this._restoreObjectsState();
      },
      setObjectsCoords: function () {
        var t = !0;
        return (
          this.forEachObject(function (e) {
            e.setCoords(t);
          }),
          this
        );
      },
      _calcBounds: function (t) {
        for (
          var e,
            i,
            r,
            n,
            s = [],
            o = [],
            a = ["tr", "br", "bl", "tl"],
            c = 0,
            h = this._objects.length,
            l = a.length;
          h > c;
          ++c
        ) {
          for (e = this._objects[c], r = e.calcACoords(), n = 0; l > n; n++)
            (i = a[n]), s.push(r[i].x), o.push(r[i].y);
          e.aCoords = r;
        }
        this._getBounds(s, o, t);
      },
      _getBounds: function (t, n, s) {
        var o = new e.Point(i(t), i(n)),
          a = new e.Point(r(t), r(n)),
          c = o.y || 0,
          h = o.x || 0,
          l = a.x - o.x || 0,
          u = a.y - o.y || 0;
        (this.width = l),
          (this.height = u),
          s || this.setPositionByOrigin({ x: h, y: c }, "left", "top");
      },
      _toSVG: function (t) {
        for (
          var e = ["<g ", "COMMON_PARTS", " >\n"],
            i = 0,
            r = this._objects.length;
          r > i;
          i++
        )
          e.push("		", this._objects[i].toSVG(t));
        return e.push("</g>\n"), e;
      },
      getSvgStyles: function () {
        var t =
            "undefined" != typeof this.opacity && 1 !== this.opacity
              ? "opacity: " + this.opacity + ";"
              : "",
          e = this.visible ? "" : " visibility: hidden;";
        return [t, this.getSvgFilter(), e].join("");
      },
      toClipPathSVG: function (t) {
        for (var e = [], i = 0, r = this._objects.length; r > i; i++)
          e.push("	", this._objects[i].toClipPathSVG(t));
        return this._createBaseClipPathSVGMarkup(e, { reviver: t });
      },
    })),
    (e.Group.fromObject = function (t, i) {
      var r = t.objects,
        n = e.util.object.clone(t, !0);
      return (
        delete n.objects,
        "string" == typeof r
          ? void e.loadSVGFromURL(r, function (s) {
              var o = e.util.groupSVGElements(s, t, r);
              o.set(n), i && i(o);
            })
          : void e.util.enlivenObjects(r, function (r) {
              var n = e.util.object.clone(t, !0);
              delete n.objects,
                e.util.enlivenObjectEnlivables(t, n, function () {
                  i && i(new e.Group(r, n, !0));
                });
            })
      );
    }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {});
  e.ActiveSelection ||
    ((e.ActiveSelection = e.util.createClass(e.Group, {
      type: "activeSelection",
      initialize: function (t, i) {
        (i = i || {}), (this._objects = t || []);
        for (var r = this._objects.length; r--; ) this._objects[r].group = this;
        i.originX && (this.originX = i.originX),
          i.originY && (this.originY = i.originY),
          this._calcBounds(),
          this._updateObjectsCoords(),
          e.Object.prototype.initialize.call(this, i),
          this.setCoords();
      },
      toGroup: function () {
        var t = this._objects.concat();
        this._objects = [];
        var i = e.Object.prototype.toObject.call(this),
          r = new e.Group([]);
        if (
          (delete i.type,
          r.set(i),
          t.forEach(function (t) {
            t.canvas.remove(t), (t.group = r);
          }),
          (r._objects = t),
          !this.canvas)
        )
          return r;
        var n = this.canvas;
        return n.add(r), (n._activeObject = r), r.setCoords(), r;
      },
      onDeselect: function () {
        return this.destroy(), !1;
      },
      toString: function () {
        return "#<fabric.ActiveSelection: (" + this.complexity() + ")>";
      },
      shouldCache: function () {
        return !1;
      },
      isOnACache: function () {
        return !1;
      },
      _renderControls: function (t, e, i) {
        t.save(),
          (t.globalAlpha = this.isMoving ? this.borderOpacityWhenMoving : 1),
          this.callSuper("_renderControls", t, e),
          (i = i || {}),
          "undefined" == typeof i.hasControls && (i.hasControls = !1),
          (i.forActiveSelection = !0);
        for (var r = 0, n = this._objects.length; n > r; r++)
          this._objects[r]._renderControls(t, i);
        t.restore();
      },
    })),
    (e.ActiveSelection.fromObject = function (t, i) {
      e.util.enlivenObjects(t.objects, function (r) {
        delete t.objects, i && i(new e.ActiveSelection(r, t, !0));
      });
    }));
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = fabric.util.object.extend;
  return (
    t.fabric || (t.fabric = {}),
    t.fabric.Image
      ? void fabric.warn("fabric.Image is already defined.")
      : ((fabric.Image = fabric.util.createClass(fabric.Object, {
          type: "image",
          strokeWidth: 0,
          srcFromAttribute: !1,
          _lastScaleX: 1,
          _lastScaleY: 1,
          _filterScalingX: 1,
          _filterScalingY: 1,
          minimumScaleTrigger: 0.5,
          stateProperties: fabric.Object.prototype.stateProperties.concat(
            "cropX",
            "cropY"
          ),
          cacheProperties: fabric.Object.prototype.cacheProperties.concat(
            "cropX",
            "cropY"
          ),
          cacheKey: "",
          cropX: 0,
          cropY: 0,
          imageSmoothing: !0,
          initialize: function (t, e) {
            e || (e = {}),
              (this.filters = []),
              (this.cacheKey = "texture" + fabric.Object.__uid++),
              this.callSuper("initialize", e),
              this._initElement(t, e);
          },
          getElement: function () {
            return this._element || {};
          },
          setElement: function (t, e) {
            return (
              this.removeTexture(this.cacheKey),
              this.removeTexture(this.cacheKey + "_filtered"),
              (this._element = t),
              (this._originalElement = t),
              this._initConfig(e),
              0 !== this.filters.length && this.applyFilters(),
              this.resizeFilter && this.applyResizeFilters(),
              this
            );
          },
          removeTexture: function (t) {
            var e = fabric.filterBackend;
            e && e.evictCachesForKey && e.evictCachesForKey(t);
          },
          dispose: function () {
            this.callSuper("dispose"),
              this.removeTexture(this.cacheKey),
              this.removeTexture(this.cacheKey + "_filtered"),
              (this._cacheContext = void 0),
              [
                "_originalElement",
                "_element",
                "_filteredEl",
                "_cacheCanvas",
              ].forEach(
                function (t) {
                  fabric.util.cleanUpJsdomNode(this[t]), (this[t] = void 0);
                }.bind(this)
              );
          },
          getCrossOrigin: function () {
            return (
              this._originalElement &&
              (this._originalElement.crossOrigin || null)
            );
          },
          getOriginalSize: function () {
            var t = this.getElement();
            return {
              width: t.naturalWidth || t.width,
              height: t.naturalHeight || t.height,
            };
          },
          _stroke: function (t) {
            if (this.stroke && 0 !== this.strokeWidth) {
              var e = this.width / 2,
                i = this.height / 2;
              t.beginPath(),
                t.moveTo(-e, -i),
                t.lineTo(e, -i),
                t.lineTo(e, i),
                t.lineTo(-e, i),
                t.lineTo(-e, -i),
                t.closePath();
            }
          },
          toObject: function (t) {
            var i = [];
            this.filters.forEach(function (t) {
              t && i.push(t.toObject());
            });
            var r = e(
              this.callSuper("toObject", ["cropX", "cropY"].concat(t)),
              {
                src: this.getSrc(),
                crossOrigin: this.getCrossOrigin(),
                filters: i,
              }
            );
            return (
              this.resizeFilter &&
                (r.resizeFilter = this.resizeFilter.toObject()),
              r
            );
          },
          hasCrop: function () {
            return (
              this.cropX ||
              this.cropY ||
              this.width < this._element.width ||
              this.height < this._element.height
            );
          },
          _toSVG: function () {
            var t,
              e = [],
              i = [],
              r = this._element,
              n = -this.width / 2,
              s = -this.height / 2,
              o = "",
              a = "";
            if (!r) return [];
            if (this.hasCrop()) {
              var c = fabric.Object.__uid++;
              e.push(
                '<clipPath id="imageCrop_' + c + '">\n',
                '	<rect x="' +
                  n +
                  '" y="' +
                  s +
                  '" width="' +
                  this.width +
                  '" height="' +
                  this.height +
                  '" />\n',
                "</clipPath>\n"
              ),
                (o = ' clip-path="url(#imageCrop_' + c + ')" ');
            }
            if (
              (this.imageSmoothing || (a = '" image-rendering="optimizeSpeed'),
              i.push(
                "	<image ",
                "COMMON_PARTS",
                'xlink:href="',
                this.getSvgSrc(!0),
                '" x="',
                n - this.cropX,
                '" y="',
                s - this.cropY,
                '" width="',
                r.width || r.naturalWidth,
                '" height="',
                r.height || r.height,
                a,
                '"',
                o,
                "></image>\n"
              ),
              this.stroke || this.strokeDashArray)
            ) {
              var h = this.fill;
              (this.fill = null),
                (t = [
                  "	<rect ",
                  'x="',
                  n,
                  '" y="',
                  s,
                  '" width="',
                  this.width,
                  '" height="',
                  this.height,
                  '" style="',
                  this.getSvgStyles(),
                  '"/>\n',
                ]),
                (this.fill = h);
            }
            return (e =
              "fill" !== this.paintFirst ? e.concat(t, i) : e.concat(i, t));
          },
          getSrc: function (t) {
            var e = t ? this._element : this._originalElement;
            return e
              ? e.toDataURL
                ? e.toDataURL()
                : this.srcFromAttribute
                ? e.getAttribute("src")
                : e.src
              : this.src || "";
          },
          setSrc: function (t, e, i) {
            return (
              fabric.util.loadImage(
                t,
                function (t, r) {
                  this.setElement(t, i),
                    this._setWidthHeight(),
                    e && e(this, r);
                },
                this,
                i && i.crossOrigin
              ),
              this
            );
          },
          toString: function () {
            return '#<fabric.Image: { src: "' + this.getSrc() + '" }>';
          },
          applyResizeFilters: function () {
            var t = this.resizeFilter,
              e = this.minimumScaleTrigger,
              i = this.getTotalObjectScaling(),
              r = i.scaleX,
              n = i.scaleY,
              s = this._filteredEl || this._originalElement;
            if ((this.group && this.set("dirty", !0), !t || (r > e && n > e)))
              return (
                (this._element = s),
                (this._filterScalingX = 1),
                (this._filterScalingY = 1),
                (this._lastScaleX = r),
                void (this._lastScaleY = n)
              );
            fabric.filterBackend ||
              (fabric.filterBackend = fabric.initFilterBackend());
            var o = fabric.util.createCanvasElement(),
              a = this._filteredEl
                ? this.cacheKey + "_filtered"
                : this.cacheKey,
              c = s.width,
              h = s.height;
            (o.width = c),
              (o.height = h),
              (this._element = o),
              (this._lastScaleX = t.scaleX = r),
              (this._lastScaleY = t.scaleY = n),
              fabric.filterBackend.applyFilters([t], s, c, h, this._element, a),
              (this._filterScalingX = o.width / this._originalElement.width),
              (this._filterScalingY = o.height / this._originalElement.height);
          },
          applyFilters: function (t) {
            if (
              ((t = t || this.filters || []),
              (t = t.filter(function (t) {
                return t && !t.isNeutralState();
              })),
              this.set("dirty", !0),
              this.removeTexture(this.cacheKey + "_filtered"),
              0 === t.length)
            )
              return (
                (this._element = this._originalElement),
                (this._filteredEl = null),
                (this._filterScalingX = 1),
                (this._filterScalingY = 1),
                this
              );
            var e = this._originalElement,
              i = e.naturalWidth || e.width,
              r = e.naturalHeight || e.height;
            if (this._element === this._originalElement) {
              var n = fabric.util.createCanvasElement();
              (n.width = i),
                (n.height = r),
                (this._element = n),
                (this._filteredEl = n);
            } else
              (this._element = this._filteredEl),
                this._filteredEl.getContext("2d").clearRect(0, 0, i, r),
                (this._lastScaleX = 1),
                (this._lastScaleY = 1);
            return (
              fabric.filterBackend ||
                (fabric.filterBackend = fabric.initFilterBackend()),
              fabric.filterBackend.applyFilters(
                t,
                this._originalElement,
                i,
                r,
                this._element,
                this.cacheKey
              ),
              (this._originalElement.width !== this._element.width ||
                this._originalElement.height !== this._element.height) &&
                ((this._filterScalingX =
                  this._element.width / this._originalElement.width),
                (this._filterScalingY =
                  this._element.height / this._originalElement.height)),
              this
            );
          },
          _render: function (t) {
            fabric.util.setImageSmoothing(t, this.imageSmoothing),
              this.isMoving !== !0 &&
                this.resizeFilter &&
                this._needsResize() &&
                this.applyResizeFilters(),
              this._stroke(t),
              this._renderPaintInOrder(t);
          },
          drawCacheOnCanvas: function (t) {
            fabric.util.setImageSmoothing(t, this.imageSmoothing),
              fabric.Object.prototype.drawCacheOnCanvas.call(this, t);
          },
          shouldCache: function () {
            return this.needsItsOwnCache();
          },
          _renderFill: function (t) {
            var e = this._element;
            if (e) {
              var i = this._filterScalingX,
                r = this._filterScalingY,
                n = this.width,
                s = this.height,
                o = Math.min,
                a = Math.max,
                c = a(this.cropX, 0),
                h = a(this.cropY, 0),
                l = e.naturalWidth || e.width,
                u = e.naturalHeight || e.height,
                f = c * i,
                d = h * r,
                g = o(n * i, l - f),
                p = o(s * r, u - d),
                v = -n / 2,
                m = -s / 2,
                b = o(n, l / i - c),
                y = o(s, u / r - h);
              e && t.drawImage(e, f, d, g, p, v, m, b, y);
            }
          },
          _needsResize: function () {
            var t = this.getTotalObjectScaling();
            return (
              t.scaleX !== this._lastScaleX || t.scaleY !== this._lastScaleY
            );
          },
          _resetWidthHeight: function () {
            this.set(this.getOriginalSize());
          },
          _initElement: function (t, e) {
            this.setElement(fabric.util.getById(t), e),
              fabric.util.addClass(this.getElement(), fabric.Image.CSS_CANVAS);
          },
          _initConfig: function (t) {
            t || (t = {}), this.setOptions(t), this._setWidthHeight(t);
          },
          _initFilters: function (t, e) {
            t && t.length
              ? fabric.util.enlivenObjects(
                  t,
                  function (t) {
                    e && e(t);
                  },
                  "fabric.Image.filters"
                )
              : e && e();
          },
          _setWidthHeight: function (t) {
            t || (t = {});
            var e = this.getElement();
            (this.width = t.width || e.naturalWidth || e.width || 0),
              (this.height = t.height || e.naturalHeight || e.height || 0);
          },
          parsePreserveAspectRatioAttribute: function () {
            var t,
              e = fabric.util.parsePreserveAspectRatioAttribute(
                this.preserveAspectRatio || ""
              ),
              i = this._element.width,
              r = this._element.height,
              n = 1,
              s = 1,
              o = 0,
              a = 0,
              c = 0,
              h = 0,
              l = this.width,
              u = this.height,
              f = { width: l, height: u };
            return (
              !e || ("none" === e.alignX && "none" === e.alignY)
                ? ((n = l / i), (s = u / r))
                : ("meet" === e.meetOrSlice &&
                    ((n = s = fabric.util.findScaleToFit(this._element, f)),
                    (t = (l - i * n) / 2),
                    "Min" === e.alignX && (o = -t),
                    "Max" === e.alignX && (o = t),
                    (t = (u - r * s) / 2),
                    "Min" === e.alignY && (a = -t),
                    "Max" === e.alignY && (a = t)),
                  "slice" === e.meetOrSlice &&
                    ((n = s = fabric.util.findScaleToCover(this._element, f)),
                    (t = i - l / n),
                    "Mid" === e.alignX && (c = t / 2),
                    "Max" === e.alignX && (c = t),
                    (t = r - u / s),
                    "Mid" === e.alignY && (h = t / 2),
                    "Max" === e.alignY && (h = t),
                    (i = l / n),
                    (r = u / s))),
              {
                width: i,
                height: r,
                scaleX: n,
                scaleY: s,
                offsetLeft: o,
                offsetTop: a,
                cropX: c,
                cropY: h,
              }
            );
          },
        })),
        (fabric.Image.CSS_CANVAS = "canvas-img"),
        (fabric.Image.prototype.getSvgSrc = fabric.Image.prototype.getSrc),
        (fabric.Image.fromObject = function (t, e) {
          var i = fabric.util.object.clone(t);
          fabric.util.loadImage(
            i.src,
            function (t, r) {
              return r
                ? void (e && e(null, !0))
                : void fabric.Image.prototype._initFilters.call(
                    i,
                    i.filters,
                    function (r) {
                      (i.filters = r || []),
                        fabric.Image.prototype._initFilters.call(
                          i,
                          [i.resizeFilter],
                          function (r) {
                            (i.resizeFilter = r[0]),
                              fabric.util.enlivenObjectEnlivables(
                                i,
                                i,
                                function () {
                                  var r = new fabric.Image(t, i);
                                  e(r, !1);
                                }
                              );
                          }
                        );
                    }
                  );
            },
            null,
            i.crossOrigin
          );
        }),
        (fabric.Image.fromURL = function (t, e, i) {
          fabric.util.loadImage(
            t,
            function (t, r) {
              e && e(new fabric.Image(t, i), r);
            },
            null,
            i && i.crossOrigin
          );
        }),
        (fabric.Image.ATTRIBUTE_NAMES = fabric.SHARED_ATTRIBUTES.concat(
          "x y width height preserveAspectRatio xlink:href crossOrigin image-rendering".split(
            " "
          )
        )),
        void (fabric.Image.fromElement = function (t, i, r) {
          var n = fabric.parseAttributes(t, fabric.Image.ATTRIBUTE_NAMES);
          fabric.Image.fromURL(
            n["xlink:href"],
            i,
            e(r ? fabric.util.object.clone(r) : {}, n)
          );
        }))
  );
})("undefined" != typeof exports ? exports : this);
fabric.util.object.extend(fabric.Object.prototype, {
  _getAngleValueForStraighten: function () {
    var t = this.angle % 360;
    return t > 0 ? 90 * Math.round((t - 1) / 90) : 90 * Math.round(t / 90);
  },
  straighten: function () {
    return this.rotate(this._getAngleValueForStraighten());
  },
  fxStraighten: function (t) {
    t = t || {};
    var e = function () {},
      i = t.onComplete || e,
      r = t.onChange || e,
      n = this;
    return fabric.util.animate({
      target: this,
      startValue: this.get("angle"),
      endValue: this._getAngleValueForStraighten(),
      duration: this.FX_DURATION,
      onChange: function (t) {
        n.rotate(t), r();
      },
      onComplete: function () {
        n.setCoords(), i();
      },
    });
  },
}),
  fabric.util.object.extend(fabric.StaticCanvas.prototype, {
    straightenObject: function (t) {
      return t.straighten(), this.requestRenderAll(), this;
    },
    fxStraightenObject: function (t) {
      return t.fxStraighten({ onChange: this.requestRenderAllBound });
    },
  });
function resizeCanvasIfNeeded(t) {
  var e = t.targetCanvas,
    i = e.width,
    r = e.height,
    n = t.destinationWidth,
    s = t.destinationHeight;
  (i !== n || r !== s) && ((e.width = n), (e.height = s));
}
function copyGLTo2DDrawImage(t, e) {
  var i = t.canvas,
    r = e.targetCanvas,
    n = r.getContext("2d");
  n.translate(0, r.height), n.scale(1, -1);
  var s = i.height - r.height;
  n.drawImage(i, 0, s, r.width, r.height, 0, 0, r.width, r.height);
}
function copyGLTo2DPutImageData(t, e) {
  var i = e.targetCanvas,
    r = i.getContext("2d"),
    n = e.destinationWidth,
    s = e.destinationHeight,
    o = n * s * 4,
    a = new Uint8Array(this.imageBuffer, 0, o),
    c = new Uint8ClampedArray(this.imageBuffer, 0, o);
  t.readPixels(0, 0, n, s, t.RGBA, t.UNSIGNED_BYTE, a);
  var h = new ImageData(c, n, s);
  r.putImageData(h, 0, 0);
}
!(function () {
  "use strict";
  function t(t, e) {
    var i = "precision " + e + " float;\nvoid main(){}",
      r = t.createShader(t.FRAGMENT_SHADER);
    return (
      t.shaderSource(r, i),
      t.compileShader(r),
      t.getShaderParameter(r, t.COMPILE_STATUS) ? !0 : !1
    );
  }
  function e(t) {
    t && t.tileSize && (this.tileSize = t.tileSize),
      this.setupGLContext(this.tileSize, this.tileSize),
      this.captureGPUInfo();
  }
  (fabric.isWebglSupported = function (e) {
    if (fabric.isLikelyNode) return !1;
    e = e || fabric.WebglFilterBackend.prototype.tileSize;
    var i = document.createElement("canvas"),
      r = i.getContext("webgl") || i.getContext("experimental-webgl"),
      n = !1;
    if (r) {
      (fabric.maxTextureSize = r.getParameter(r.MAX_TEXTURE_SIZE)),
        (n = fabric.maxTextureSize >= e);
      for (var s = ["highp", "mediump", "lowp"], o = 0; 3 > o; o++)
        if (t(r, s[o])) {
          fabric.webGlPrecision = s[o];
          break;
        }
    }
    return (this.isSupported = n), n;
  }),
    (fabric.WebglFilterBackend = e),
    (e.prototype = {
      tileSize: 2048,
      resources: {},
      setupGLContext: function (t, e) {
        this.dispose(),
          this.createWebGLCanvas(t, e),
          (this.aPosition = new Float32Array([0, 0, 0, 1, 1, 0, 1, 1])),
          this.chooseFastestCopyGLTo2DMethod(t, e);
      },
      chooseFastestCopyGLTo2DMethod: function (t, e) {
        var i,
          r = "undefined" != typeof window.performance;
        try {
          new ImageData(1, 1), (i = !0);
        } catch (n) {
          i = !1;
        }
        var s = "undefined" != typeof ArrayBuffer,
          o = "undefined" != typeof Uint8ClampedArray;
        if (r && i && s && o) {
          var a = fabric.util.createCanvasElement(),
            c = new ArrayBuffer(t * e * 4);
          if (fabric.forceGLPutImageData)
            return (
              (this.imageBuffer = c),
              void (this.copyGLTo2D = copyGLTo2DPutImageData)
            );
          var h,
            l,
            u,
            f = {
              imageBuffer: c,
              destinationWidth: t,
              destinationHeight: e,
              targetCanvas: a,
            };
          (a.width = t),
            (a.height = e),
            (h = window.performance.now()),
            copyGLTo2DDrawImage.call(f, this.gl, f),
            (l = window.performance.now() - h),
            (h = window.performance.now()),
            copyGLTo2DPutImageData.call(f, this.gl, f),
            (u = window.performance.now() - h),
            l > u
              ? ((this.imageBuffer = c),
                (this.copyGLTo2D = copyGLTo2DPutImageData))
              : (this.copyGLTo2D = copyGLTo2DDrawImage);
        }
      },
      createWebGLCanvas: function (t, e) {
        var i = fabric.util.createCanvasElement();
        (i.width = t), (i.height = e);
        var r = {
            alpha: !0,
            premultipliedAlpha: !1,
            depth: !1,
            stencil: !1,
            antialias: !1,
          },
          n = i.getContext("webgl", r);
        n || (n = i.getContext("experimental-webgl", r)),
          n && (n.clearColor(0, 0, 0, 0), (this.canvas = i), (this.gl = n));
      },
      applyFilters: function (t, e, i, r, n, s) {
        var o,
          a = this.gl;
        s && (o = this.getCachedTexture(s, e));
        var c = {
            originalWidth: e.width || e.originalWidth,
            originalHeight: e.height || e.originalHeight,
            sourceWidth: i,
            sourceHeight: r,
            destinationWidth: i,
            destinationHeight: r,
            context: a,
            sourceTexture: this.createTexture(a, i, r, !o && e),
            targetTexture: this.createTexture(a, i, r),
            originalTexture: o || this.createTexture(a, i, r, !o && e),
            passes: t.length,
            webgl: !0,
            aPosition: this.aPosition,
            programCache: this.programCache,
            pass: 0,
            filterBackend: this,
            targetCanvas: n,
          },
          h = a.createFramebuffer();
        return (
          a.bindFramebuffer(a.FRAMEBUFFER, h),
          t.forEach(function (t) {
            t && t.applyTo(c);
          }),
          resizeCanvasIfNeeded(c),
          this.copyGLTo2D(a, c),
          a.bindTexture(a.TEXTURE_2D, null),
          a.deleteTexture(c.sourceTexture),
          a.deleteTexture(c.targetTexture),
          a.deleteFramebuffer(h),
          n.getContext("2d").setTransform(1, 0, 0, 1, 0, 0),
          c
        );
      },
      dispose: function () {
        this.canvas && ((this.canvas = null), (this.gl = null)),
          this.clearWebGLCaches();
      },
      clearWebGLCaches: function () {
        (this.programCache = {}), (this.textureCache = {});
      },
      createTexture: function (t, e, i, r) {
        var n = t.createTexture();
        return (
          t.bindTexture(t.TEXTURE_2D, n),
          t.texParameteri(t.TEXTURE_2D, t.TEXTURE_MAG_FILTER, t.NEAREST),
          t.texParameteri(t.TEXTURE_2D, t.TEXTURE_MIN_FILTER, t.NEAREST),
          t.texParameteri(t.TEXTURE_2D, t.TEXTURE_WRAP_S, t.CLAMP_TO_EDGE),
          t.texParameteri(t.TEXTURE_2D, t.TEXTURE_WRAP_T, t.CLAMP_TO_EDGE),
          r
            ? t.texImage2D(t.TEXTURE_2D, 0, t.RGBA, t.RGBA, t.UNSIGNED_BYTE, r)
            : t.texImage2D(
                t.TEXTURE_2D,
                0,
                t.RGBA,
                e,
                i,
                0,
                t.RGBA,
                t.UNSIGNED_BYTE,
                null
              ),
          n
        );
      },
      getCachedTexture: function (t, e) {
        if (this.textureCache[t]) return this.textureCache[t];
        var i = this.createTexture(this.gl, e.width, e.height, e);
        return (this.textureCache[t] = i), i;
      },
      evictCachesForKey: function (t) {
        this.textureCache[t] &&
          (this.gl.deleteTexture(this.textureCache[t]),
          delete this.textureCache[t]);
      },
      copyGLTo2D: copyGLTo2DDrawImage,
      captureGPUInfo: function () {
        if (this.gpuInfo) return this.gpuInfo;
        var t = this.gl,
          e = { renderer: "", vendor: "" };
        if (!t) return e;
        var i = t.getExtension("WEBGL_debug_renderer_info");
        if (i) {
          var r = t.getParameter(i.UNMASKED_RENDERER_WEBGL),
            n = t.getParameter(i.UNMASKED_VENDOR_WEBGL);
          r && (e.renderer = r.toLowerCase()),
            n && (e.vendor = n.toLowerCase());
        }
        return (this.gpuInfo = e), e;
      },
    });
})();
!(function () {
  "use strict";
  function t() {}
  var e = function () {};
  (fabric.Canvas2dFilterBackend = t),
    (t.prototype = {
      evictCachesForKey: e,
      dispose: e,
      clearWebGLCaches: e,
      resources: {},
      applyFilters: function (t, e, i, r, n) {
        var s = n.getContext("2d");
        s.drawImage(e, 0, 0, i, r);
        var o = s.getImageData(0, 0, i, r),
          a = s.getImageData(0, 0, i, r),
          c = {
            sourceWidth: i,
            sourceHeight: r,
            imageData: o,
            originalEl: e,
            originalImageData: a,
            canvasEl: n,
            ctx: s,
            filterBackend: this,
          };
        return (
          t.forEach(function (t) {
            t.applyTo(c);
          }),
          (c.imageData.width !== i || c.imageData.height !== r) &&
            ((n.width = c.imageData.width), (n.height = c.imageData.height)),
          s.putImageData(c.imageData, 0, 0),
          c
        );
      },
    });
})();
(fabric.Image = fabric.Image || {}),
  (fabric.Image.filters = fabric.Image.filters || {}),
  (fabric.Image.filters.BaseFilter = fabric.util.createClass({
    type: "BaseFilter",
    vertexSource:
      "attribute vec2 aPosition;\nvarying vec2 vTexCoord;\nvoid main() {\nvTexCoord = aPosition;\ngl_Position = vec4(aPosition * 2.0 - 1.0, 0.0, 1.0);\n}",
    fragmentSource:
      "precision highp float;\nvarying vec2 vTexCoord;\nuniform sampler2D uTexture;\nvoid main() {\ngl_FragColor = texture2D(uTexture, vTexCoord);\n}",
    initialize: function (t) {
      t && this.setOptions(t);
    },
    setOptions: function (t) {
      for (var e in t) this[e] = t[e];
    },
    createProgram: function (t, e, i) {
      (e = e || this.fragmentSource),
        (i = i || this.vertexSource),
        "highp" !== fabric.webGlPrecision &&
          (e = e.replace(
            /precision highp float/g,
            "precision " + fabric.webGlPrecision + " float"
          ));
      var r = t.createShader(t.VERTEX_SHADER);
      if (
        (t.shaderSource(r, i),
        t.compileShader(r),
        !t.getShaderParameter(r, t.COMPILE_STATUS))
      )
        throw new Error(
          "Vertex shader compile error for " +
            this.type +
            ": " +
            t.getShaderInfoLog(r)
        );
      var n = t.createShader(t.FRAGMENT_SHADER);
      if (
        (t.shaderSource(n, e),
        t.compileShader(n),
        !t.getShaderParameter(n, t.COMPILE_STATUS))
      )
        throw new Error(
          "Fragment shader compile error for " +
            this.type +
            ": " +
            t.getShaderInfoLog(n)
        );
      var s = t.createProgram();
      if (
        (t.attachShader(s, r),
        t.attachShader(s, n),
        t.linkProgram(s),
        !t.getProgramParameter(s, t.LINK_STATUS))
      )
        throw new Error(
          'Shader link error for "${this.type}" ' + t.getProgramInfoLog(s)
        );
      var o = this.getAttributeLocations(t, s),
        a = this.getUniformLocations(t, s) || {};
      return (
        (a.uStepW = t.getUniformLocation(s, "uStepW")),
        (a.uStepH = t.getUniformLocation(s, "uStepH")),
        { program: s, attributeLocations: o, uniformLocations: a }
      );
    },
    getAttributeLocations: function (t, e) {
      return { aPosition: t.getAttribLocation(e, "aPosition") };
    },
    getUniformLocations: function () {
      return {};
    },
    sendAttributeData: function (t, e, i) {
      var r = e.aPosition,
        n = t.createBuffer();
      t.bindBuffer(t.ARRAY_BUFFER, n),
        t.enableVertexAttribArray(r),
        t.vertexAttribPointer(r, 2, t.FLOAT, !1, 0, 0),
        t.bufferData(t.ARRAY_BUFFER, i, t.STATIC_DRAW);
    },
    _setupFrameBuffer: function (t) {
      var e,
        i,
        r = t.context;
      t.passes > 1
        ? ((e = t.destinationWidth),
          (i = t.destinationHeight),
          (t.sourceWidth !== e || t.sourceHeight !== i) &&
            (r.deleteTexture(t.targetTexture),
            (t.targetTexture = t.filterBackend.createTexture(r, e, i))),
          r.framebufferTexture2D(
            r.FRAMEBUFFER,
            r.COLOR_ATTACHMENT0,
            r.TEXTURE_2D,
            t.targetTexture,
            0
          ))
        : (r.bindFramebuffer(r.FRAMEBUFFER, null), r.finish());
    },
    _swapTextures: function (t) {
      t.passes--, t.pass++;
      var e = t.targetTexture;
      (t.targetTexture = t.sourceTexture), (t.sourceTexture = e);
    },
    isNeutralState: function () {
      var t = this.mainParameter,
        e = fabric.Image.filters[this.type].prototype;
      if (t) {
        if (Array.isArray(e[t])) {
          for (var i = e[t].length; i--; )
            if (this[t][i] !== e[t][i]) return !1;
          return !0;
        }
        return e[t] === this[t];
      }
      return !1;
    },
    applyTo: function (t) {
      t.webgl
        ? (this._setupFrameBuffer(t),
          this.applyToWebGL(t),
          this._swapTextures(t))
        : this.applyTo2d(t);
    },
    retrieveShader: function (t) {
      return (
        t.programCache.hasOwnProperty(this.type) ||
          (t.programCache[this.type] = this.createProgram(t.context)),
        t.programCache[this.type]
      );
    },
    applyToWebGL: function (t) {
      var e = t.context,
        i = this.retrieveShader(t);
      0 === t.pass && t.originalTexture
        ? e.bindTexture(e.TEXTURE_2D, t.originalTexture)
        : e.bindTexture(e.TEXTURE_2D, t.sourceTexture),
        e.useProgram(i.program),
        this.sendAttributeData(e, i.attributeLocations, t.aPosition),
        e.uniform1f(i.uniformLocations.uStepW, 1 / t.sourceWidth),
        e.uniform1f(i.uniformLocations.uStepH, 1 / t.sourceHeight),
        this.sendUniformData(e, i.uniformLocations),
        e.viewport(0, 0, t.destinationWidth, t.destinationHeight),
        e.drawArrays(e.TRIANGLE_STRIP, 0, 4);
    },
    bindAdditionalTexture: function (t, e, i) {
      t.activeTexture(i),
        t.bindTexture(t.TEXTURE_2D, e),
        t.activeTexture(t.TEXTURE0);
    },
    unbindAdditionalTexture: function (t, e) {
      t.activeTexture(e),
        t.bindTexture(t.TEXTURE_2D, null),
        t.activeTexture(t.TEXTURE0);
    },
    getMainParameter: function () {
      return this[this.mainParameter];
    },
    setMainParameter: function (t) {
      this[this.mainParameter] = t;
    },
    sendUniformData: function () {},
    createHelpLayer: function (t) {
      if (!t.helpLayer) {
        var e = document.createElement("canvas");
        (e.width = t.sourceWidth),
          (e.height = t.sourceHeight),
          (t.helpLayer = e);
      }
    },
    toObject: function () {
      var t = { type: this.type },
        e = this.mainParameter;
      return e && (t[e] = this[e]), t;
    },
    toJSON: function () {
      return this.toObject();
    },
  })),
  (fabric.Image.filters.BaseFilter.fromObject = function (t, e) {
    var i = new fabric.Image.filters[t.type](t);
    return e && e(i), i;
  });
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.ColorMatrix = r(i.BaseFilter, {
    type: "ColorMatrix",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nvarying vec2 vTexCoord;\nuniform mat4 uColorMatrix;\nuniform vec4 uConstants;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\ncolor *= uColorMatrix;\ncolor += uConstants;\ngl_FragColor = color;\n}",
    matrix: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
    mainParameter: "matrix",
    colorsOnly: !0,
    initialize: function (t) {
      this.callSuper("initialize", t), (this.matrix = this.matrix.slice(0));
    },
    applyTo2d: function (t) {
      var e,
        i,
        r,
        n,
        s,
        o = t.imageData,
        a = o.data,
        c = a.length,
        h = this.matrix,
        l = this.colorsOnly;
      for (s = 0; c > s; s += 4)
        (e = a[s]),
          (i = a[s + 1]),
          (r = a[s + 2]),
          l
            ? ((a[s] = e * h[0] + i * h[1] + r * h[2] + 255 * h[4]),
              (a[s + 1] = e * h[5] + i * h[6] + r * h[7] + 255 * h[9]),
              (a[s + 2] = e * h[10] + i * h[11] + r * h[12] + 255 * h[14]))
            : ((n = a[s + 3]),
              (a[s] = e * h[0] + i * h[1] + r * h[2] + n * h[3] + 255 * h[4]),
              (a[s + 1] =
                e * h[5] + i * h[6] + r * h[7] + n * h[8] + 255 * h[9]),
              (a[s + 2] =
                e * h[10] + i * h[11] + r * h[12] + n * h[13] + 255 * h[14]),
              (a[s + 3] =
                e * h[15] + i * h[16] + r * h[17] + n * h[18] + 255 * h[19]));
    },
    getUniformLocations: function (t, e) {
      return {
        uColorMatrix: t.getUniformLocation(e, "uColorMatrix"),
        uConstants: t.getUniformLocation(e, "uConstants"),
      };
    },
    sendUniformData: function (t, e) {
      var i = this.matrix,
        r = [
          i[0],
          i[1],
          i[2],
          i[3],
          i[5],
          i[6],
          i[7],
          i[8],
          i[10],
          i[11],
          i[12],
          i[13],
          i[15],
          i[16],
          i[17],
          i[18],
        ],
        n = [i[4], i[9], i[14], i[19]];
      t.uniformMatrix4fv(e.uColorMatrix, !1, r), t.uniform4fv(e.uConstants, n);
    },
  })),
    (e.Image.filters.ColorMatrix.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Brightness = r(i.BaseFilter, {
    type: "Brightness",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform float uBrightness;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\ncolor.rgb += uBrightness;\ngl_FragColor = color;\n}",
    brightness: 0,
    mainParameter: "brightness",
    applyTo2d: function (t) {
      if (0 !== this.brightness) {
        var e,
          i = t.imageData,
          r = i.data,
          n = r.length,
          o = Math.round(255 * this.brightness);
        for (e = 0; n > e; e += 4)
          (r[e] = r[e] + o),
            (r[e + 1] = r[e + 1] + o),
            (r[e + 2] = r[e + 2] + o);
      }
    },
    getUniformLocations: function (t, e) {
      return { uBrightness: t.getUniformLocation(e, "uBrightness") };
    },
    sendUniformData: function (t, e) {
      t.uniform1f(e.uBrightness, this.brightness);
    },
  })),
    (e.Image.filters.Brightness.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.extend,
    r = e.Image.filters,
    n = e.util.createClass;
  (r.Convolute = n(r.BaseFilter, {
    type: "Convolute",
    opaque: !1,
    matrix: [0, 0, 0, 0, 1, 0, 0, 0, 0],
    fragmentSource: {
      Convolute_3_1:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[9];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 0);\nfor (float h = 0.0; h < 3.0; h+=1.0) {\nfor (float w = 0.0; w < 3.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 1), uStepH * (h - 1));\ncolor += texture2D(uTexture, vTexCoord + matrixPos) * uMatrix[int(h * 3.0 + w)];\n}\n}\ngl_FragColor = color;\n}",
      Convolute_3_0:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[9];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 1);\nfor (float h = 0.0; h < 3.0; h+=1.0) {\nfor (float w = 0.0; w < 3.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 1.0), uStepH * (h - 1.0));\ncolor.rgb += texture2D(uTexture, vTexCoord + matrixPos).rgb * uMatrix[int(h * 3.0 + w)];\n}\n}\nfloat alpha = texture2D(uTexture, vTexCoord).a;\ngl_FragColor = color;\ngl_FragColor.a = alpha;\n}",
      Convolute_5_1:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[25];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 0);\nfor (float h = 0.0; h < 5.0; h+=1.0) {\nfor (float w = 0.0; w < 5.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 2.0), uStepH * (h - 2.0));\ncolor += texture2D(uTexture, vTexCoord + matrixPos) * uMatrix[int(h * 5.0 + w)];\n}\n}\ngl_FragColor = color;\n}",
      Convolute_5_0:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[25];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 1);\nfor (float h = 0.0; h < 5.0; h+=1.0) {\nfor (float w = 0.0; w < 5.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 2.0), uStepH * (h - 2.0));\ncolor.rgb += texture2D(uTexture, vTexCoord + matrixPos).rgb * uMatrix[int(h * 5.0 + w)];\n}\n}\nfloat alpha = texture2D(uTexture, vTexCoord).a;\ngl_FragColor = color;\ngl_FragColor.a = alpha;\n}",
      Convolute_7_1:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[49];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 0);\nfor (float h = 0.0; h < 7.0; h+=1.0) {\nfor (float w = 0.0; w < 7.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 3.0), uStepH * (h - 3.0));\ncolor += texture2D(uTexture, vTexCoord + matrixPos) * uMatrix[int(h * 7.0 + w)];\n}\n}\ngl_FragColor = color;\n}",
      Convolute_7_0:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[49];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 1);\nfor (float h = 0.0; h < 7.0; h+=1.0) {\nfor (float w = 0.0; w < 7.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 3.0), uStepH * (h - 3.0));\ncolor.rgb += texture2D(uTexture, vTexCoord + matrixPos).rgb * uMatrix[int(h * 7.0 + w)];\n}\n}\nfloat alpha = texture2D(uTexture, vTexCoord).a;\ngl_FragColor = color;\ngl_FragColor.a = alpha;\n}",
      Convolute_9_1:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[81];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 0);\nfor (float h = 0.0; h < 9.0; h+=1.0) {\nfor (float w = 0.0; w < 9.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 4.0), uStepH * (h - 4.0));\ncolor += texture2D(uTexture, vTexCoord + matrixPos) * uMatrix[int(h * 9.0 + w)];\n}\n}\ngl_FragColor = color;\n}",
      Convolute_9_0:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform float uMatrix[81];\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = vec4(0, 0, 0, 1);\nfor (float h = 0.0; h < 9.0; h+=1.0) {\nfor (float w = 0.0; w < 9.0; w+=1.0) {\nvec2 matrixPos = vec2(uStepW * (w - 4.0), uStepH * (h - 4.0));\ncolor.rgb += texture2D(uTexture, vTexCoord + matrixPos).rgb * uMatrix[int(h * 9.0 + w)];\n}\n}\nfloat alpha = texture2D(uTexture, vTexCoord).a;\ngl_FragColor = color;\ngl_FragColor.a = alpha;\n}",
    },
    retrieveShader: function (t) {
      var e = Math.sqrt(this.matrix.length),
        i = this.type + "_" + e + "_" + (this.opaque ? 1 : 0),
        r = this.fragmentSource[i];
      return (
        t.programCache.hasOwnProperty(i) ||
          (t.programCache[i] = this.createProgram(t.context, r)),
        t.programCache[i]
      );
    },
    applyTo2d: function (t) {
      var e,
        i,
        r,
        n,
        o,
        s,
        a,
        c,
        h,
        l,
        u,
        f,
        d,
        g = t.imageData,
        p = g.data,
        v = this.matrix,
        m = Math.round(Math.sqrt(v.length)),
        b = Math.floor(m / 2),
        y = g.width,
        _ = g.height,
        x = t.ctx.createImageData(y, _),
        w = x.data,
        C = this.opaque ? 1 : 0;
      for (u = 0; _ > u; u++)
        for (l = 0; y > l; l++) {
          for (
            o = 4 * (u * y + l), e = 0, i = 0, r = 0, n = 0, d = 0;
            m > d;
            d++
          )
            for (f = 0; m > f; f++)
              (a = u + d - b),
                (s = l + f - b),
                0 > a ||
                  a >= _ ||
                  0 > s ||
                  s >= y ||
                  ((c = 4 * (a * y + s)),
                  (h = v[d * m + f]),
                  (e += p[c] * h),
                  (i += p[c + 1] * h),
                  (r += p[c + 2] * h),
                  C || (n += p[c + 3] * h));
          (w[o] = e),
            (w[o + 1] = i),
            (w[o + 2] = r),
            (w[o + 3] = C ? p[o + 3] : n);
        }
      t.imageData = x;
    },
    getUniformLocations: function (t, e) {
      return {
        uMatrix: t.getUniformLocation(e, "uMatrix"),
        uOpaque: t.getUniformLocation(e, "uOpaque"),
        uHalfSize: t.getUniformLocation(e, "uHalfSize"),
        uSize: t.getUniformLocation(e, "uSize"),
      };
    },
    sendUniformData: function (t, e) {
      t.uniform1fv(e.uMatrix, this.matrix);
    },
    toObject: function () {
      return i(this.callSuper("toObject"), {
        opaque: this.opaque,
        matrix: this.matrix,
      });
    },
  })),
    (e.Image.filters.Convolute.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Grayscale = r(i.BaseFilter, {
    type: "Grayscale",
    fragmentSource: {
      average:
        "precision highp float;\nuniform sampler2D uTexture;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nfloat average = (color.r + color.b + color.g) / 3.0;\ngl_FragColor = vec4(average, average, average, color.a);\n}",
      lightness:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform int uMode;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 col = texture2D(uTexture, vTexCoord);\nfloat average = (max(max(col.r, col.g),col.b) + min(min(col.r, col.g),col.b)) / 2.0;\ngl_FragColor = vec4(average, average, average, col.a);\n}",
      luminosity:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform int uMode;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 col = texture2D(uTexture, vTexCoord);\nfloat average = 0.21 * col.r + 0.72 * col.g + 0.07 * col.b;\ngl_FragColor = vec4(average, average, average, col.a);\n}",
    },
    mode: "average",
    mainParameter: "mode",
    applyTo2d: function (t) {
      var e,
        i,
        r = t.imageData,
        n = r.data,
        o = n.length,
        s = this.mode;
      for (e = 0; o > e; e += 4)
        "average" === s
          ? (i = (n[e] + n[e + 1] + n[e + 2]) / 3)
          : "lightness" === s
          ? (i =
              (Math.min(n[e], n[e + 1], n[e + 2]) +
                Math.max(n[e], n[e + 1], n[e + 2])) /
              2)
          : "luminosity" === s &&
            (i = 0.21 * n[e] + 0.72 * n[e + 1] + 0.07 * n[e + 2]),
          (n[e] = i),
          (n[e + 1] = i),
          (n[e + 2] = i);
    },
    retrieveShader: function (t) {
      var e = this.type + "_" + this.mode;
      if (!t.programCache.hasOwnProperty(e)) {
        var i = this.fragmentSource[this.mode];
        t.programCache[e] = this.createProgram(t.context, i);
      }
      return t.programCache[e];
    },
    getUniformLocations: function (t, e) {
      return { uMode: t.getUniformLocation(e, "uMode") };
    },
    sendUniformData: function (t, e) {
      var i = 1;
      t.uniform1i(e.uMode, i);
    },
    isNeutralState: function () {
      return !1;
    },
  })),
    (e.Image.filters.Grayscale.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Invert = r(i.BaseFilter, {
    type: "Invert",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform int uInvert;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nif (uInvert == 1) {\ngl_FragColor = vec4(1.0 - color.r,1.0 -color.g,1.0 -color.b,color.a);\n} else {\ngl_FragColor = color;\n}\n}",
    invert: !0,
    mainParameter: "invert",
    applyTo2d: function (t) {
      var e,
        i = t.imageData,
        r = i.data,
        n = r.length;
      for (e = 0; n > e; e += 4)
        (r[e] = 255 - r[e]),
          (r[e + 1] = 255 - r[e + 1]),
          (r[e + 2] = 255 - r[e + 2]);
    },
    isNeutralState: function () {
      return !this.invert;
    },
    getUniformLocations: function (t, e) {
      return { uInvert: t.getUniformLocation(e, "uInvert") };
    },
    sendUniformData: function (t, e) {
      t.uniform1i(e.uInvert, this.invert);
    },
  })),
    (e.Image.filters.Invert.fromObject = e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.extend,
    r = e.Image.filters,
    n = e.util.createClass;
  (r.Noise = n(r.BaseFilter, {
    type: "Noise",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform float uStepH;\nuniform float uNoise;\nuniform float uSeed;\nvarying vec2 vTexCoord;\nfloat rand(vec2 co, float seed, float vScale) {\nreturn fract(sin(dot(co.xy * vScale ,vec2(12.9898 , 78.233))) * 43758.5453 * (seed + 0.01) / 2.0);\n}\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\ncolor.rgb += (0.5 - rand(vTexCoord, uSeed, 0.1 / uStepH)) * uNoise;\ngl_FragColor = color;\n}",
    mainParameter: "noise",
    noise: 0,
    applyTo2d: function (t) {
      if (0 !== this.noise) {
        var e,
          i,
          r = t.imageData,
          n = r.data,
          o = n.length,
          s = this.noise;
        for (e = 0, o = n.length; o > e; e += 4)
          (i = (0.5 - Math.random()) * s),
            (n[e] += i),
            (n[e + 1] += i),
            (n[e + 2] += i);
      }
    },
    getUniformLocations: function (t, e) {
      return {
        uNoise: t.getUniformLocation(e, "uNoise"),
        uSeed: t.getUniformLocation(e, "uSeed"),
      };
    },
    sendUniformData: function (t, e) {
      t.uniform1f(e.uNoise, this.noise / 255),
        t.uniform1f(e.uSeed, Math.random());
    },
    toObject: function () {
      return i(this.callSuper("toObject"), { noise: this.noise });
    },
  })),
    (e.Image.filters.Noise.fromObject = e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Pixelate = r(i.BaseFilter, {
    type: "Pixelate",
    blocksize: 4,
    mainParameter: "blocksize",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform float uBlocksize;\nuniform float uStepW;\nuniform float uStepH;\nvarying vec2 vTexCoord;\nvoid main() {\nfloat blockW = uBlocksize * uStepW;\nfloat blockH = uBlocksize * uStepW;\nint posX = int(vTexCoord.x / blockW);\nint posY = int(vTexCoord.y / blockH);\nfloat fposX = float(posX);\nfloat fposY = float(posY);\nvec2 squareCoords = vec2(fposX * blockW, fposY * blockH);\nvec4 color = texture2D(uTexture, squareCoords);\ngl_FragColor = color;\n}",
    applyTo2d: function (t) {
      var e,
        i,
        r,
        n,
        o,
        s,
        a,
        c,
        h,
        l,
        u,
        f = t.imageData,
        d = f.data,
        g = f.height,
        p = f.width;
      for (i = 0; g > i; i += this.blocksize)
        for (r = 0; p > r; r += this.blocksize)
          for (
            e = 4 * i * p + 4 * r,
              n = d[e],
              o = d[e + 1],
              s = d[e + 2],
              a = d[e + 3],
              l = Math.min(i + this.blocksize, g),
              u = Math.min(r + this.blocksize, p),
              c = i;
            l > c;
            c++
          )
            for (h = r; u > h; h++)
              (e = 4 * c * p + 4 * h),
                (d[e] = n),
                (d[e + 1] = o),
                (d[e + 2] = s),
                (d[e + 3] = a);
    },
    isNeutralState: function () {
      return 1 === this.blocksize;
    },
    getUniformLocations: function (t, e) {
      return {
        uBlocksize: t.getUniformLocation(e, "uBlocksize"),
        uStepW: t.getUniformLocation(e, "uStepW"),
        uStepH: t.getUniformLocation(e, "uStepH"),
      };
    },
    sendUniformData: function (t, e) {
      t.uniform1f(e.uBlocksize, this.blocksize);
    },
  })),
    (e.Image.filters.Pixelate.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.extend,
    r = e.Image.filters,
    n = e.util.createClass;
  (r.RemoveColor = n(r.BaseFilter, {
    type: "RemoveColor",
    color: "#FFFFFF",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform vec4 uLow;\nuniform vec4 uHigh;\nvarying vec2 vTexCoord;\nvoid main() {\ngl_FragColor = texture2D(uTexture, vTexCoord);\nif(all(greaterThan(gl_FragColor.rgb,uLow.rgb)) && all(greaterThan(uHigh.rgb,gl_FragColor.rgb))) {\ngl_FragColor.a = 0.0;\n}\n}",
    distance: 0.02,
    useAlpha: !1,
    applyTo2d: function (t) {
      var i,
        r,
        n,
        o,
        s = t.imageData,
        a = s.data,
        c = 255 * this.distance,
        h = new e.Color(this.color).getSource(),
        l = [h[0] - c, h[1] - c, h[2] - c],
        u = [h[0] + c, h[1] + c, h[2] + c];
      for (i = 0; i < a.length; i += 4)
        (r = a[i]),
          (n = a[i + 1]),
          (o = a[i + 2]),
          r > l[0] &&
            n > l[1] &&
            o > l[2] &&
            r < u[0] &&
            n < u[1] &&
            o < u[2] &&
            (a[i + 3] = 0);
    },
    getUniformLocations: function (t, e) {
      return {
        uLow: t.getUniformLocation(e, "uLow"),
        uHigh: t.getUniformLocation(e, "uHigh"),
      };
    },
    sendUniformData: function (t, i) {
      var r = new e.Color(this.color).getSource(),
        n = parseFloat(this.distance),
        o = [0 + r[0] / 255 - n, 0 + r[1] / 255 - n, 0 + r[2] / 255 - n, 1],
        s = [r[0] / 255 + n, r[1] / 255 + n, r[2] / 255 + n, 1];
      t.uniform4fv(i.uLow, o), t.uniform4fv(i.uHigh, s);
    },
    toObject: function () {
      return i(this.callSuper("toObject"), {
        color: this.color,
        distance: this.distance,
      });
    },
  })),
    (e.Image.filters.RemoveColor.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass,
    n = {
      Brownie: [
        0.5997, 0.34553, -0.27082, 0, 0.186, -0.0377, 0.86095, 0.15059, 0,
        -0.1449, 0.24113, -0.07441, 0.44972, 0, -0.02965, 0, 0, 0, 1, 0,
      ],
      Vintage: [
        0.62793, 0.32021, -0.03965, 0, 0.03784, 0.02578, 0.64411, 0.03259, 0,
        0.02926, 0.0466, -0.08512, 0.52416, 0, 0.02023, 0, 0, 0, 1, 0,
      ],
      Kodachrome: [
        1.12855, -0.39673, -0.03992, 0, 0.24991, -0.16404, 1.08352, -0.05498, 0,
        0.09698, -0.16786, -0.56034, 1.60148, 0, 0.13972, 0, 0, 0, 1, 0,
      ],
      Technicolor: [
        1.91252, -0.85453, -0.09155, 0, 0.04624, -0.30878, 1.76589, -0.10601, 0,
        -0.27589, -0.2311, -0.75018, 1.84759, 0, 0.12137, 0, 0, 0, 1, 0,
      ],
      Polaroid: [
        1.438, -0.062, -0.062, 0, 0, -0.122, 1.378, -0.122, 0, 0, -0.016,
        -0.016, 1.483, 0, 0, 0, 0, 0, 1, 0,
      ],
      Sepia: [
        0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534,
        0.131, 0, 0, 0, 0, 0, 1, 0,
      ],
      BlackWhite: [
        1.5, 1.5, 1.5, 0, -1, 1.5, 1.5, 1.5, 0, -1, 1.5, 1.5, 1.5, 0, -1, 0, 0,
        0, 1, 0,
      ],
    };
  for (var o in n)
    (i[o] = r(i.ColorMatrix, {
      type: o,
      matrix: n[o],
      mainParameter: !1,
      colorsOnly: !0,
    })),
      (e.Image.filters[o].fromObject = e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric,
    i = e.Image.filters,
    r = e.util.createClass;
  (i.BlendColor = r(i.BaseFilter, {
    type: "BlendColor",
    color: "#F95C63",
    mode: "multiply",
    alpha: 1,
    fragmentSource: {
      multiply: "gl_FragColor.rgb *= uColor.rgb;\n",
      screen:
        "gl_FragColor.rgb = 1.0 - (1.0 - gl_FragColor.rgb) * (1.0 - uColor.rgb);\n",
      add: "gl_FragColor.rgb += uColor.rgb;\n",
      diff: "gl_FragColor.rgb = abs(gl_FragColor.rgb - uColor.rgb);\n",
      subtract: "gl_FragColor.rgb -= uColor.rgb;\n",
      lighten: "gl_FragColor.rgb = max(gl_FragColor.rgb, uColor.rgb);\n",
      darken: "gl_FragColor.rgb = min(gl_FragColor.rgb, uColor.rgb);\n",
      exclusion:
        "gl_FragColor.rgb += uColor.rgb - 2.0 * (uColor.rgb * gl_FragColor.rgb);\n",
      overlay:
        "if (uColor.r < 0.5) {\ngl_FragColor.r *= 2.0 * uColor.r;\n} else {\ngl_FragColor.r = 1.0 - 2.0 * (1.0 - gl_FragColor.r) * (1.0 - uColor.r);\n}\nif (uColor.g < 0.5) {\ngl_FragColor.g *= 2.0 * uColor.g;\n} else {\ngl_FragColor.g = 1.0 - 2.0 * (1.0 - gl_FragColor.g) * (1.0 - uColor.g);\n}\nif (uColor.b < 0.5) {\ngl_FragColor.b *= 2.0 * uColor.b;\n} else {\ngl_FragColor.b = 1.0 - 2.0 * (1.0 - gl_FragColor.b) * (1.0 - uColor.b);\n}\n",
      tint: "gl_FragColor.rgb *= (1.0 - uColor.a);\ngl_FragColor.rgb += uColor.rgb;\n",
    },
    buildSource: function (t) {
      return (
        "precision highp float;\nuniform sampler2D uTexture;\nuniform vec4 uColor;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\ngl_FragColor = color;\nif (color.a > 0.0) {\n" +
        this.fragmentSource[t] +
        "}\n}"
      );
    },
    retrieveShader: function (t) {
      var e,
        i = this.type + "_" + this.mode;
      return (
        t.programCache.hasOwnProperty(i) ||
          ((e = this.buildSource(this.mode)),
          (t.programCache[i] = this.createProgram(t.context, e))),
        t.programCache[i]
      );
    },
    applyTo2d: function (t) {
      var i,
        r,
        n,
        o,
        s,
        a,
        c,
        l = t.imageData,
        h = l.data,
        u = h.length,
        f = 1 - this.alpha;
      (c = new e.Color(this.color).getSource()),
        (i = c[0] * this.alpha),
        (r = c[1] * this.alpha),
        (n = c[2] * this.alpha);
      for (var d = 0; u > d; d += 4)
        switch (((o = h[d]), (s = h[d + 1]), (a = h[d + 2]), this.mode)) {
          case "multiply":
            (h[d] = (o * i) / 255),
              (h[d + 1] = (s * r) / 255),
              (h[d + 2] = (a * n) / 255);
            break;
          case "screen":
            (h[d] = 255 - ((255 - o) * (255 - i)) / 255),
              (h[d + 1] = 255 - ((255 - s) * (255 - r)) / 255),
              (h[d + 2] = 255 - ((255 - a) * (255 - n)) / 255);
            break;
          case "add":
            (h[d] = o + i), (h[d + 1] = s + r), (h[d + 2] = a + n);
            break;
          case "diff":
          case "difference":
            (h[d] = Math.abs(o - i)),
              (h[d + 1] = Math.abs(s - r)),
              (h[d + 2] = Math.abs(a - n));
            break;
          case "subtract":
            (h[d] = o - i), (h[d + 1] = s - r), (h[d + 2] = a - n);
            break;
          case "darken":
            (h[d] = Math.min(o, i)),
              (h[d + 1] = Math.min(s, r)),
              (h[d + 2] = Math.min(a, n));
            break;
          case "lighten":
            (h[d] = Math.max(o, i)),
              (h[d + 1] = Math.max(s, r)),
              (h[d + 2] = Math.max(a, n));
            break;
          case "overlay":
            (h[d] =
              128 > i
                ? (2 * o * i) / 255
                : 255 - (2 * (255 - o) * (255 - i)) / 255),
              (h[d + 1] =
                128 > r
                  ? (2 * s * r) / 255
                  : 255 - (2 * (255 - s) * (255 - r)) / 255),
              (h[d + 2] =
                128 > n
                  ? (2 * a * n) / 255
                  : 255 - (2 * (255 - a) * (255 - n)) / 255);
            break;
          case "exclusion":
            (h[d] = i + o - (2 * i * o) / 255),
              (h[d + 1] = r + s - (2 * r * s) / 255),
              (h[d + 2] = n + a - (2 * n * a) / 255);
            break;
          case "tint":
            (h[d] = i + o * f), (h[d + 1] = r + s * f), (h[d + 2] = n + a * f);
        }
    },
    getUniformLocations: function (t, e) {
      return { uColor: t.getUniformLocation(e, "uColor") };
    },
    sendUniformData: function (t, i) {
      var r = new e.Color(this.color).getSource();
      (r[0] = (this.alpha * r[0]) / 255),
        (r[1] = (this.alpha * r[1]) / 255),
        (r[2] = (this.alpha * r[2]) / 255),
        (r[3] = this.alpha),
        t.uniform4fv(i.uColor, r);
    },
    toObject: function () {
      return {
        type: this.type,
        color: this.color,
        mode: this.mode,
        alpha: this.alpha,
      };
    },
  })),
    (e.Image.filters.BlendColor.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric,
    i = e.Image.filters,
    r = e.util.createClass;
  (i.BlendImage = r(i.BaseFilter, {
    type: "BlendImage",
    image: null,
    mode: "multiply",
    alpha: 1,
    vertexSource:
      "attribute vec2 aPosition;\nvarying vec2 vTexCoord;\nvarying vec2 vTexCoord2;\nuniform mat3 uTransformMatrix;\nvoid main() {\nvTexCoord = aPosition;\nvTexCoord2 = (uTransformMatrix * vec3(aPosition, 1.0)).xy;\ngl_Position = vec4(aPosition * 2.0 - 1.0, 0.0, 1.0);\n}",
    fragmentSource: {
      multiply:
        "precision highp float;\nuniform sampler2D uTexture;\nuniform sampler2D uImage;\nuniform vec4 uColor;\nvarying vec2 vTexCoord;\nvarying vec2 vTexCoord2;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nvec4 color2 = texture2D(uImage, vTexCoord2);\ncolor.rgba *= color2.rgba;\ngl_FragColor = color;\n}",
      mask: "precision highp float;\nuniform sampler2D uTexture;\nuniform sampler2D uImage;\nuniform vec4 uColor;\nvarying vec2 vTexCoord;\nvarying vec2 vTexCoord2;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nvec4 color2 = texture2D(uImage, vTexCoord2);\ncolor.a = color2.a;\ngl_FragColor = color;\n}",
    },
    retrieveShader: function (t) {
      var e = this.type + "_" + this.mode,
        i = this.fragmentSource[this.mode];
      return (
        t.programCache.hasOwnProperty(e) ||
          (t.programCache[e] = this.createProgram(t.context, i)),
        t.programCache[e]
      );
    },
    applyToWebGL: function (t) {
      var e = t.context,
        i = this.createTexture(t.filterBackend, this.image);
      this.bindAdditionalTexture(e, i, e.TEXTURE1),
        this.callSuper("applyToWebGL", t),
        this.unbindAdditionalTexture(e, e.TEXTURE1);
    },
    createTexture: function (t, e) {
      return t.getCachedTexture(e.cacheKey, e._element);
    },
    calculateMatrix: function () {
      var t = this.image,
        e = t._element.width,
        i = t._element.height;
      return [
        1 / t.scaleX,
        0,
        0,
        0,
        1 / t.scaleY,
        0,
        -t.left / e,
        -t.top / i,
        1,
      ];
    },
    applyTo2d: function (t) {
      var i,
        r,
        n,
        o,
        s,
        a,
        c,
        h,
        l,
        u,
        f,
        d = t.imageData,
        g = t.filterBackend.resources,
        p = d.data,
        v = p.length,
        m = d.width,
        b = d.height,
        y = this.image;
      g.blendImage || (g.blendImage = e.util.createCanvasElement()),
        (l = g.blendImage),
        (u = l.getContext("2d")),
        l.width !== m || l.height !== b
          ? ((l.width = m), (l.height = b))
          : u.clearRect(0, 0, m, b),
        u.setTransform(y.scaleX, 0, 0, y.scaleY, y.left, y.top),
        u.drawImage(y._element, 0, 0, m, b),
        (f = u.getImageData(0, 0, m, b).data);
      for (var x = 0; v > x; x += 4)
        switch (
          ((s = p[x]),
          (a = p[x + 1]),
          (c = p[x + 2]),
          (h = p[x + 3]),
          (i = f[x]),
          (r = f[x + 1]),
          (n = f[x + 2]),
          (o = f[x + 3]),
          this.mode)
        ) {
          case "multiply":
            (p[x] = (s * i) / 255),
              (p[x + 1] = (a * r) / 255),
              (p[x + 2] = (c * n) / 255),
              (p[x + 3] = (h * o) / 255);
            break;
          case "mask":
            p[x + 3] = o;
        }
    },
    getUniformLocations: function (t, e) {
      return {
        uTransformMatrix: t.getUniformLocation(e, "uTransformMatrix"),
        uImage: t.getUniformLocation(e, "uImage"),
      };
    },
    sendUniformData: function (t, e) {
      var i = this.calculateMatrix();
      t.uniform1i(e.uImage, 1), t.uniformMatrix3fv(e.uTransformMatrix, !1, i);
    },
    toObject: function () {
      return {
        type: this.type,
        image: this.image && this.image.toObject(),
        mode: this.mode,
        alpha: this.alpha,
      };
    },
  })),
    (e.Image.filters.BlendImage.fromObject = function (t, i) {
      e.Image.fromObject(t.image, function (r) {
        var n = e.util.object.clone(t);
        (n.image = r), i(new e.Image.filters.BlendImage(n));
      });
    });
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = Math.pow,
    r = Math.floor,
    n = Math.sqrt,
    o = Math.abs,
    s = Math.round,
    a = Math.sin,
    c = Math.ceil,
    l = e.Image.filters,
    h = e.util.createClass;
  (l.Resize = h(l.BaseFilter, {
    type: "Resize",
    resizeType: "hermite",
    scaleX: 1,
    scaleY: 1,
    lanczosLobes: 3,
    getUniformLocations: function (t, e) {
      return {
        uDelta: t.getUniformLocation(e, "uDelta"),
        uTaps: t.getUniformLocation(e, "uTaps"),
      };
    },
    sendUniformData: function (t, e) {
      t.uniform2fv(
        e.uDelta,
        this.horizontal ? [1 / this.width, 0] : [0, 1 / this.height]
      ),
        t.uniform1fv(e.uTaps, this.taps);
    },
    retrieveShader: function (t) {
      var e = this.getFilterWindow(),
        i = this.type + "_" + e;
      if (!t.programCache.hasOwnProperty(i)) {
        var r = this.generateShader(e);
        t.programCache[i] = this.createProgram(t.context, r);
      }
      return t.programCache[i];
    },
    getFilterWindow: function () {
      var t = this.tempScale;
      return Math.ceil(this.lanczosLobes / t);
    },
    getTaps: function () {
      for (
        var t = this.lanczosCreate(this.lanczosLobes),
          e = this.tempScale,
          i = this.getFilterWindow(),
          r = new Array(i),
          n = 1;
        i >= n;
        n++
      )
        r[n - 1] = t(n * e);
      return r;
    },
    generateShader: function (t) {
      for (
        var t, e = new Array(t), i = this.fragmentSourceTOP, r = 1;
        t >= r;
        r++
      )
        e[r - 1] = r + ".0 * uDelta";
      return (
        (i += "uniform float uTaps[" + t + "];\n"),
        (i += "void main() {\n"),
        (i += "  vec4 color = texture2D(uTexture, vTexCoord);\n"),
        (i += "  float sum = 1.0;\n"),
        e.forEach(function (t, e) {
          (i +=
            "  color += texture2D(uTexture, vTexCoord + " +
            t +
            ") * uTaps[" +
            e +
            "];\n"),
            (i +=
              "  color += texture2D(uTexture, vTexCoord - " +
              t +
              ") * uTaps[" +
              e +
              "];\n"),
            (i += "  sum += 2.0 * uTaps[" + e + "];\n");
        }),
        (i += "  gl_FragColor = color / sum;\n"),
        (i += "}")
      );
    },
    fragmentSourceTOP:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform vec2 uDelta;\nvarying vec2 vTexCoord;\n",
    applyTo: function (t) {
      t.webgl
        ? (t.passes++,
          (this.width = t.sourceWidth),
          (this.horizontal = !0),
          (this.dW = Math.round(this.width * this.scaleX)),
          (this.dH = t.sourceHeight),
          (this.tempScale = this.dW / this.width),
          (this.taps = this.getTaps()),
          (t.destinationWidth = this.dW),
          this._setupFrameBuffer(t),
          this.applyToWebGL(t),
          this._swapTextures(t),
          (t.sourceWidth = t.destinationWidth),
          (this.height = t.sourceHeight),
          (this.horizontal = !1),
          (this.dH = Math.round(this.height * this.scaleY)),
          (this.tempScale = this.dH / this.height),
          (this.taps = this.getTaps()),
          (t.destinationHeight = this.dH),
          this._setupFrameBuffer(t),
          this.applyToWebGL(t),
          this._swapTextures(t),
          (t.sourceHeight = t.destinationHeight))
        : this.applyTo2d(t);
    },
    isNeutralState: function () {
      return 1 === this.scaleX && 1 === this.scaleY;
    },
    lanczosCreate: function (t) {
      return function (e) {
        if (e >= t || -t >= e) return 0;
        if (1.1920929e-7 > e && e > -1.1920929e-7) return 1;
        e *= Math.PI;
        var i = e / t;
        return ((a(e) / e) * a(i)) / i;
      };
    },
    applyTo2d: function (t) {
      var e = t.imageData,
        i = this.scaleX,
        r = this.scaleY;
      (this.rcpScaleX = 1 / i), (this.rcpScaleY = 1 / r);
      var n,
        o = e.width,
        a = e.height,
        c = s(o * i),
        l = s(a * r);
      "sliceHack" === this.resizeType
        ? (n = this.sliceByTwo(t, o, a, c, l))
        : "hermite" === this.resizeType
        ? (n = this.hermiteFastResize(t, o, a, c, l))
        : "bilinear" === this.resizeType
        ? (n = this.bilinearFiltering(t, o, a, c, l))
        : "lanczos" === this.resizeType &&
          (n = this.lanczosResize(t, o, a, c, l)),
        (t.imageData = n);
    },
    sliceByTwo: function (t, i, n, o, s) {
      var a,
        c,
        l = t.imageData,
        h = 0.5,
        u = !1,
        f = !1,
        d = i * h,
        g = n * h,
        p = e.filterBackend.resources,
        v = 0,
        m = 0,
        b = i,
        y = 0;
      for (
        p.sliceByTwo || (p.sliceByTwo = document.createElement("canvas")),
          a = p.sliceByTwo,
          (a.width < 1.5 * i || a.height < n) &&
            ((a.width = 1.5 * i), (a.height = n)),
          c = a.getContext("2d"),
          c.clearRect(0, 0, 1.5 * i, n),
          c.putImageData(l, 0, 0),
          o = r(o),
          s = r(s);
        !u || !f;

      )
        (i = d),
          (n = g),
          o < r(d * h) ? (d = r(d * h)) : ((d = o), (u = !0)),
          s < r(g * h) ? (g = r(g * h)) : ((g = s), (f = !0)),
          c.drawImage(a, v, m, i, n, b, y, d, g),
          (v = b),
          (m = y),
          (y += g);
      return c.getImageData(v, m, o, s);
    },
    lanczosResize: function (t, e, s, a, l) {
      function h(t) {
        var c, T, S, O, j, P, E, k, M, A, D;
        for (C.x = (t + 0.5) * p, w.x = r(C.x), c = 0; l > c; c++) {
          for (
            C.y = (c + 0.5) * v,
              w.y = r(C.y),
              j = 0,
              P = 0,
              E = 0,
              k = 0,
              M = 0,
              T = w.x - y;
            T <= w.x + y;
            T++
          )
            if (!(0 > T || T >= e)) {
              (A = r(1e3 * o(T - C.x))), _[A] || (_[A] = {});
              for (var F = w.y - x; F <= w.y + x; F++)
                0 > F ||
                  F >= s ||
                  ((D = r(1e3 * o(F - C.y))),
                  _[A][D] || (_[A][D] = g(n(i(A * m, 2) + i(D * b, 2)) / 1e3)),
                  (S = _[A][D]),
                  S > 0 &&
                    ((O = 4 * (F * e + T)),
                    (j += S),
                    (P += S * u[O]),
                    (E += S * u[O + 1]),
                    (k += S * u[O + 2]),
                    (M += S * u[O + 3])));
            }
          (O = 4 * (c * a + t)),
            (d[O] = P / j),
            (d[O + 1] = E / j),
            (d[O + 2] = k / j),
            (d[O + 3] = M / j);
        }
        return ++t < a ? h(t) : f;
      }
      var u = t.imageData.data,
        f = t.ctx.createImageData(a, l),
        d = f.data,
        g = this.lanczosCreate(this.lanczosLobes),
        p = this.rcpScaleX,
        v = this.rcpScaleY,
        m = 2 / this.rcpScaleX,
        b = 2 / this.rcpScaleY,
        y = c((p * this.lanczosLobes) / 2),
        x = c((v * this.lanczosLobes) / 2),
        _ = {},
        C = {},
        w = {};
      return h(0);
    },
    bilinearFiltering: function (t, e, i, n, o) {
      var s,
        a,
        c,
        l,
        h,
        u,
        f,
        d,
        g,
        p,
        v,
        m,
        b,
        y = 0,
        x = this.rcpScaleX,
        _ = this.rcpScaleY,
        C = 4 * (e - 1),
        w = t.imageData,
        T = w.data,
        S = t.ctx.createImageData(n, o),
        O = S.data;
      for (f = 0; o > f; f++)
        for (d = 0; n > d; d++)
          for (
            h = r(x * d),
              u = r(_ * f),
              g = x * d - h,
              p = _ * f - u,
              b = 4 * (u * e + h),
              v = 0;
            4 > v;
            v++
          )
            (s = T[b + v]),
              (a = T[b + 4 + v]),
              (c = T[b + C + v]),
              (l = T[b + C + 4 + v]),
              (m =
                s * (1 - g) * (1 - p) +
                a * g * (1 - p) +
                c * p * (1 - g) +
                l * g * p),
              (O[y++] = m);
      return S;
    },
    hermiteFastResize: function (t, e, i, s, a) {
      for (
        var l = this.rcpScaleX,
          h = this.rcpScaleY,
          u = c(l / 2),
          f = c(h / 2),
          d = t.imageData,
          g = d.data,
          p = t.ctx.createImageData(s, a),
          v = p.data,
          m = 0;
        a > m;
        m++
      )
        for (var b = 0; s > b; b++) {
          for (
            var y = 4 * (b + m * s),
              x = 0,
              _ = 0,
              C = 0,
              w = 0,
              T = 0,
              S = 0,
              O = 0,
              j = (m + 0.5) * h,
              P = r(m * h);
            (m + 1) * h > P;
            P++
          )
            for (
              var E = o(j - (P + 0.5)) / f,
                k = (b + 0.5) * l,
                M = E * E,
                A = r(b * l);
              (b + 1) * l > A;
              A++
            ) {
              var D = o(k - (A + 0.5)) / u,
                F = n(M + D * D);
              (F > 1 && -1 > F) ||
                ((x = 2 * F * F * F - 3 * F * F + 1),
                x > 0 &&
                  ((D = 4 * (A + P * e)),
                  (O += x * g[D + 3]),
                  (C += x),
                  g[D + 3] < 255 && (x = (x * g[D + 3]) / 250),
                  (w += x * g[D]),
                  (T += x * g[D + 1]),
                  (S += x * g[D + 2]),
                  (_ += x)));
            }
          (v[y] = w / _),
            (v[y + 1] = T / _),
            (v[y + 2] = S / _),
            (v[y + 3] = O / C);
        }
      return p;
    },
    toObject: function () {
      return {
        type: this.type,
        scaleX: this.scaleX,
        scaleY: this.scaleY,
        resizeType: this.resizeType,
        lanczosLobes: this.lanczosLobes,
      };
    },
  })),
    (e.Image.filters.Resize.fromObject = e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Contrast = r(i.BaseFilter, {
    type: "Contrast",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform float uContrast;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nfloat contrastF = 1.015 * (uContrast + 1.0) / (1.0 * (1.015 - uContrast));\ncolor.rgb = contrastF * (color.rgb - 0.5) + 0.5;\ngl_FragColor = color;\n}",
    contrast: 0,
    mainParameter: "contrast",
    applyTo2d: function (t) {
      if (0 !== this.contrast) {
        var e,
          i,
          r = t.imageData,
          n = r.data,
          i = n.length,
          o = Math.floor(255 * this.contrast),
          s = (259 * (o + 255)) / (255 * (259 - o));
        for (e = 0; i > e; e += 4)
          (n[e] = s * (n[e] - 128) + 128),
            (n[e + 1] = s * (n[e + 1] - 128) + 128),
            (n[e + 2] = s * (n[e + 2] - 128) + 128);
      }
    },
    getUniformLocations: function (t, e) {
      return { uContrast: t.getUniformLocation(e, "uContrast") };
    },
    sendUniformData: function (t, e) {
      t.uniform1f(e.uContrast, this.contrast);
    },
  })),
    (e.Image.filters.Contrast.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Saturation = r(i.BaseFilter, {
    type: "Saturation",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform float uSaturation;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nfloat rgMax = max(color.r, color.g);\nfloat rgbMax = max(rgMax, color.b);\ncolor.r += rgbMax != color.r ? (rgbMax - color.r) * uSaturation : 0.00;\ncolor.g += rgbMax != color.g ? (rgbMax - color.g) * uSaturation : 0.00;\ncolor.b += rgbMax != color.b ? (rgbMax - color.b) * uSaturation : 0.00;\ngl_FragColor = color;\n}",
    saturation: 0,
    mainParameter: "saturation",
    applyTo2d: function (t) {
      if (0 !== this.saturation) {
        var e,
          i,
          r = t.imageData,
          n = r.data,
          o = n.length,
          s = -this.saturation;
        for (e = 0; o > e; e += 4)
          (i = Math.max(n[e], n[e + 1], n[e + 2])),
            (n[e] += i !== n[e] ? (i - n[e]) * s : 0),
            (n[e + 1] += i !== n[e + 1] ? (i - n[e + 1]) * s : 0),
            (n[e + 2] += i !== n[e + 2] ? (i - n[e + 2]) * s : 0);
      }
    },
    getUniformLocations: function (t, e) {
      return { uSaturation: t.getUniformLocation(e, "uSaturation") };
    },
    sendUniformData: function (t, e) {
      t.uniform1f(e.uSaturation, -this.saturation);
    },
  })),
    (e.Image.filters.Saturation.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Blur = r(i.BaseFilter, {
    type: "Blur",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform vec2 uDelta;\nvarying vec2 vTexCoord;\nconst float nSamples = 15.0;\nvec3 v3offset = vec3(12.9898, 78.233, 151.7182);\nfloat random(vec3 scale) {\nreturn fract(sin(dot(gl_FragCoord.xyz, scale)) * 43758.5453);\n}\nvoid main() {\nvec4 color = vec4(0.0);\nfloat total = 0.0;\nfloat offset = random(v3offset);\nfor (float t = -nSamples; t <= nSamples; t++) {\nfloat percent = (t + offset - 0.5) / nSamples;\nfloat weight = 1.0 - abs(percent);\ncolor += texture2D(uTexture, vTexCoord + uDelta * percent) * weight;\ntotal += weight;\n}\ngl_FragColor = color / total;\n}",
    blur: 0,
    mainParameter: "blur",
    applyTo: function (t) {
      t.webgl
        ? ((this.aspectRatio = t.sourceWidth / t.sourceHeight),
          t.passes++,
          this._setupFrameBuffer(t),
          (this.horizontal = !0),
          this.applyToWebGL(t),
          this._swapTextures(t),
          this._setupFrameBuffer(t),
          (this.horizontal = !1),
          this.applyToWebGL(t),
          this._swapTextures(t))
        : this.applyTo2d(t);
    },
    applyTo2d: function (t) {
      t.imageData = this.simpleBlur(t);
    },
    simpleBlur: function (t) {
      var i,
        r,
        n = t.filterBackend.resources,
        o = t.imageData.width,
        a = t.imageData.height;
      n.blurLayer1 ||
        ((n.blurLayer1 = e.util.createCanvasElement()),
        (n.blurLayer2 = e.util.createCanvasElement())),
        (i = n.blurLayer1),
        (r = n.blurLayer2),
        (i.width !== o || i.height !== a) &&
          ((r.width = i.width = o), (r.height = i.height = a));
      var s,
        c,
        l,
        h,
        u = i.getContext("2d"),
        f = r.getContext("2d"),
        d = 15,
        g = 0.06 * this.blur * 0.5;
      for (
        u.putImageData(t.imageData, 0, 0), f.clearRect(0, 0, o, a), h = -d;
        d >= h;
        h++
      )
        (s = (Math.random() - 0.5) / 4),
          (c = h / d),
          (l = g * c * o + s),
          (f.globalAlpha = 1 - Math.abs(c)),
          f.drawImage(i, l, s),
          u.drawImage(r, 0, 0),
          (f.globalAlpha = 1),
          f.clearRect(0, 0, r.width, r.height);
      for (h = -d; d >= h; h++)
        (s = (Math.random() - 0.5) / 4),
          (c = h / d),
          (l = g * c * a + s),
          (f.globalAlpha = 1 - Math.abs(c)),
          f.drawImage(i, s, l),
          u.drawImage(r, 0, 0),
          (f.globalAlpha = 1),
          f.clearRect(0, 0, r.width, r.height);
      t.ctx.drawImage(i, 0, 0);
      var p = t.ctx.getImageData(0, 0, i.width, i.height);
      return (u.globalAlpha = 1), u.clearRect(0, 0, i.width, i.height), p;
    },
    getUniformLocations: function (t, e) {
      return { delta: t.getUniformLocation(e, "uDelta") };
    },
    sendUniformData: function (t, e) {
      var i = this.chooseRightDelta();
      t.uniform2fv(e.delta, i);
    },
    chooseRightDelta: function () {
      var t,
        e = 1,
        i = [0, 0];
      return (
        this.horizontal
          ? this.aspectRatio > 1 && (e = 1 / this.aspectRatio)
          : this.aspectRatio < 1 && (e = this.aspectRatio),
        (t = e * this.blur * 0.12),
        this.horizontal ? (i[0] = t) : (i[1] = t),
        i
      );
    },
  })),
    (i.Blur.fromObject = e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Gamma = r(i.BaseFilter, {
    type: "Gamma",
    fragmentSource:
      "precision highp float;\nuniform sampler2D uTexture;\nuniform vec3 uGamma;\nvarying vec2 vTexCoord;\nvoid main() {\nvec4 color = texture2D(uTexture, vTexCoord);\nvec3 correction = (1.0 / uGamma);\ncolor.r = pow(color.r, correction.r);\ncolor.g = pow(color.g, correction.g);\ncolor.b = pow(color.b, correction.b);\ngl_FragColor = color;\ngl_FragColor.rgb *= color.a;\n}",
    gamma: [1, 1, 1],
    mainParameter: "gamma",
    initialize: function (t) {
      (this.gamma = [1, 1, 1]), i.BaseFilter.prototype.initialize.call(this, t);
    },
    applyTo2d: function (t) {
      var e,
        i = t.imageData,
        r = i.data,
        n = this.gamma,
        o = r.length,
        a = 1 / n[0],
        s = 1 / n[1],
        c = 1 / n[2];
      for (
        this.rVals ||
          ((this.rVals = new Uint8Array(256)),
          (this.gVals = new Uint8Array(256)),
          (this.bVals = new Uint8Array(256))),
          e = 0,
          o = 256;
        o > e;
        e++
      )
        (this.rVals[e] = 255 * Math.pow(e / 255, a)),
          (this.gVals[e] = 255 * Math.pow(e / 255, s)),
          (this.bVals[e] = 255 * Math.pow(e / 255, c));
      for (e = 0, o = r.length; o > e; e += 4)
        (r[e] = this.rVals[r[e]]),
          (r[e + 1] = this.gVals[r[e + 1]]),
          (r[e + 2] = this.bVals[r[e + 2]]);
    },
    getUniformLocations: function (t, e) {
      return { uGamma: t.getUniformLocation(e, "uGamma") };
    },
    sendUniformData: function (t, e) {
      t.uniform3fv(e.uGamma, this.gamma);
    },
  })),
    (e.Image.filters.Gamma.fromObject = e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.Composed = r(i.BaseFilter, {
    type: "Composed",
    subFilters: [],
    initialize: function (t) {
      this.callSuper("initialize", t),
        (this.subFilters = this.subFilters.slice(0));
    },
    applyTo: function (t) {
      (t.passes += this.subFilters.length - 1),
        this.subFilters.forEach(function (e) {
          e.applyTo(t);
        });
    },
    toObject: function () {
      return e.util.object.extend(this.callSuper("toObject"), {
        subFilters: this.subFilters.map(function (t) {
          return t.toObject();
        }),
      });
    },
    isNeutralState: function () {
      return !this.subFilters.some(function (t) {
        return !t.isNeutralState();
      });
    },
  })),
    (e.Image.filters.Composed.fromObject = function (t, i) {
      var r = t.subFilters || [],
        n = r.map(function (t) {
          return new e.Image.filters[t.type](t);
        }),
        o = new e.Image.filters.Composed({ subFilters: n });
      return i && i(o), o;
    });
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.Image.filters,
    r = e.util.createClass;
  (i.HueRotation = r(i.ColorMatrix, {
    type: "HueRotation",
    rotation: 0,
    mainParameter: "rotation",
    calculateMatrix: function () {
      var t = this.rotation * Math.PI,
        i = e.util.cos(t),
        r = e.util.sin(t),
        n = 1 / 3,
        o = Math.sqrt(n) * r,
        a = 1 - i;
      (this.matrix = [
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0,
      ]),
        (this.matrix[0] = i + a / 3),
        (this.matrix[1] = n * a - o),
        (this.matrix[2] = n * a + o),
        (this.matrix[5] = n * a + o),
        (this.matrix[6] = i + n * a),
        (this.matrix[7] = n * a - o),
        (this.matrix[10] = n * a - o),
        (this.matrix[11] = n * a + o),
        (this.matrix[12] = i + n * a);
    },
    isNeutralState: function (t) {
      return (
        this.calculateMatrix(),
        i.BaseFilter.prototype.isNeutralState.call(this, t)
      );
    },
    applyTo: function (t) {
      this.calculateMatrix(), i.BaseFilter.prototype.applyTo.call(this, t);
    },
  })),
    (e.Image.filters.HueRotation.fromObject =
      e.Image.filters.BaseFilter.fromObject);
})("undefined" != typeof exports ? exports : this);
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {}),
    i = e.util.object.clone;
  if (e.Text) return void e.warn("fabric.Text is already defined");
  var r =
    "fontFamily fontWeight fontSize text underline overline linethrough textAlign fontStyle lineHeight textBackgroundColor charSpacing styles direction path pathStartOffset pathSide pathAlign".split(
      " "
    );
  (e.Text = e.util.createClass(e.Object, {
    _dimensionAffectingProps: [
      "fontSize",
      "fontWeight",
      "fontFamily",
      "fontStyle",
      "lineHeight",
      "text",
      "charSpacing",
      "textAlign",
      "styles",
      "path",
      "pathStartOffset",
      "pathSide",
      "pathAlign",
    ],
    _reNewline: /\r?\n/,
    _reSpacesAndTabs: /[ \t\r]/g,
    _reSpaceAndTab: /[ \t\r]/,
    _reWords: /\S+/g,
    type: "text",
    fontSize: 40,
    fontWeight: "normal",
    fontFamily: "Times New Roman",
    underline: !1,
    overline: !1,
    linethrough: !1,
    textAlign: "left",
    fontStyle: "normal",
    lineHeight: 1.16,
    superscript: { size: 0.6, baseline: -0.35 },
    subscript: { size: 0.6, baseline: 0.11 },
    textBackgroundColor: "",
    stateProperties: e.Object.prototype.stateProperties.concat(r),
    cacheProperties: e.Object.prototype.cacheProperties.concat(r),
    stroke: null,
    shadow: null,
    path: null,
    pathStartOffset: 0,
    pathSide: "left",
    pathAlign: "baseline",
    _fontSizeFraction: 0.222,
    offsets: { underline: 0.1, linethrough: -0.315, overline: -0.88 },
    _fontSizeMult: 1.13,
    charSpacing: 0,
    styles: null,
    _measuringContext: null,
    deltaY: 0,
    direction: "ltr",
    _styleProperties: [
      "stroke",
      "strokeWidth",
      "fill",
      "fontFamily",
      "fontSize",
      "fontWeight",
      "fontStyle",
      "underline",
      "overline",
      "linethrough",
      "deltaY",
      "textBackgroundColor",
    ],
    __charBounds: [],
    CACHE_FONT_SIZE: 400,
    MIN_TEXT_WIDTH: 2,
    initialize: function (t, e) {
      (this.styles = e ? e.styles || {} : {}),
        (this.text = t),
        (this.__skipDimension = !0),
        this.callSuper("initialize", e),
        this.path && this.setPathInfo(),
        (this.__skipDimension = !1),
        this.initDimensions(),
        this.setCoords(),
        this.setupState({ propertySet: "_dimensionAffectingProps" });
    },
    setPathInfo: function () {
      var t = this.path;
      t && (t.segmentsInfo = e.util.getPathSegmentsInfo(t.path));
    },
    getMeasuringContext: function () {
      return (
        e._measuringContext ||
          (e._measuringContext =
            (this.canvas && this.canvas.contextCache) ||
            e.util.createCanvasElement().getContext("2d")),
        e._measuringContext
      );
    },
    _splitText: function () {
      var t = this._splitTextIntoLines(this.text);
      return (
        (this.textLines = t.lines),
        (this._textLines = t.graphemeLines),
        (this._unwrappedTextLines = t._unwrappedLines),
        (this._text = t.graphemeText),
        t
      );
    },
    initDimensions: function () {
      this.__skipDimension ||
        (this._splitText(),
        this._clearCache(),
        this.path
          ? ((this.width = this.path.width), (this.height = this.path.height))
          : ((this.width =
              this.calcTextWidth() || this.cursorWidth || this.MIN_TEXT_WIDTH),
            (this.height = this.calcTextHeight())),
        -1 !== this.textAlign.indexOf("justify") && this.enlargeSpaces(),
        this.saveState({ propertySet: "_dimensionAffectingProps" }));
    },
    enlargeSpaces: function () {
      for (
        var t, e, i, r, n, o, s, a = 0, c = this._textLines.length;
        c > a;
        a++
      )
        if (
          ("justify" === this.textAlign ||
            (a !== c - 1 && !this.isEndOfWrapping(a))) &&
          ((r = 0),
          (n = this._textLines[a]),
          (e = this.getLineWidth(a)),
          e < this.width &&
            (s = this.textLines[a].match(this._reSpacesAndTabs)))
        ) {
          (i = s.length), (t = (this.width - e) / i);
          for (var h = 0, l = n.length; l >= h; h++)
            (o = this.__charBounds[a][h]),
              this._reSpaceAndTab.test(n[h])
                ? ((o.width += t),
                  (o.kernedWidth += t),
                  (o.left += r),
                  (r += t))
                : (o.left += r);
        }
    },
    isEndOfWrapping: function (t) {
      return t === this._textLines.length - 1;
    },
    missingNewlineOffset: function () {
      return 1;
    },
    toString: function () {
      return (
        "#<fabric.Text (" +
        this.complexity() +
        '): { "text": "' +
        this.text +
        '", "fontFamily": "' +
        this.fontFamily +
        '" }>'
      );
    },
    _getCacheCanvasDimensions: function () {
      var t = this.callSuper("_getCacheCanvasDimensions"),
        e = this.fontSize;
      return (t.width += e * t.zoomX), (t.height += e * t.zoomY), t;
    },
    _render: function (t) {
      var e = this.path;
      e && !e.isNotVisible() && e._render(t),
        this._setTextStyles(t),
        this._renderTextLinesBackground(t),
        this._renderTextDecoration(t, "underline"),
        this._renderText(t),
        this._renderTextDecoration(t, "overline"),
        this._renderTextDecoration(t, "linethrough");
    },
    _renderText: function (t) {
      "stroke" === this.paintFirst
        ? (this._renderTextStroke(t), this._renderTextFill(t))
        : (this._renderTextFill(t), this._renderTextStroke(t));
    },
    _setTextStyles: function (t, e, i) {
      if (((t.textBaseline = "alphabetical"), this.path))
        switch (this.pathAlign) {
          case "center":
            t.textBaseline = "middle";
            break;
          case "ascender":
            t.textBaseline = "top";
            break;
          case "descender":
            t.textBaseline = "bottom";
        }
      t.font = this._getFontDeclaration(e, i);
    },
    calcTextWidth: function () {
      for (
        var t = this.getLineWidth(0), e = 1, i = this._textLines.length;
        i > e;
        e++
      ) {
        var r = this.getLineWidth(e);
        r > t && (t = r);
      }
      return t;
    },
    _renderTextLine: function (t, e, i, r, n, o) {
      this._renderChars(t, e, i, r, n, o);
    },
    _renderTextLinesBackground: function (t) {
      if (this.textBackgroundColor || this.styleHas("textBackgroundColor")) {
        for (
          var e,
            i,
            r,
            n,
            o,
            s,
            a,
            c = t.fillStyle,
            h = this._getLeftOffset(),
            l = this._getTopOffset(),
            u = 0,
            f = 0,
            d = this.path,
            g = 0,
            p = this._textLines.length;
          p > g;
          g++
        )
          if (
            ((e = this.getHeightOfLine(g)),
            this.textBackgroundColor || this.styleHas("textBackgroundColor", g))
          ) {
            (r = this._textLines[g]),
              (i = this._getLineLeftOffset(g)),
              (f = 0),
              (u = 0),
              (n = this.getValueOfPropertyAt(g, 0, "textBackgroundColor"));
            for (var v = 0, m = r.length; m > v; v++)
              (o = this.__charBounds[g][v]),
                (s = this.getValueOfPropertyAt(g, v, "textBackgroundColor")),
                d
                  ? (t.save(),
                    t.translate(o.renderLeft, o.renderTop),
                    t.rotate(o.angle),
                    (t.fillStyle = s),
                    s &&
                      t.fillRect(
                        -o.width / 2,
                        (-e / this.lineHeight) * (1 - this._fontSizeFraction),
                        o.width,
                        e / this.lineHeight
                      ),
                    t.restore())
                  : s !== n
                  ? ((a = h + i + u),
                    "rtl" === this.direction && (a = this.width - a - f),
                    (t.fillStyle = n),
                    n && t.fillRect(a, l, f, e / this.lineHeight),
                    (u = o.left),
                    (f = o.width),
                    (n = s))
                  : (f += o.kernedWidth);
            s &&
              !d &&
              ((a = h + i + u),
              "rtl" === this.direction && (a = this.width - a - f),
              (t.fillStyle = s),
              t.fillRect(a, l, f, e / this.lineHeight)),
              (l += e);
          } else l += e;
        (t.fillStyle = c), this._removeShadow(t);
      }
    },
    getFontCache: function (t) {
      var i = t.fontFamily.toLowerCase();
      e.charWidthsCache[i] || (e.charWidthsCache[i] = {});
      var r = e.charWidthsCache[i],
        n = t.fontStyle.toLowerCase() + "_" + (t.fontWeight + "").toLowerCase();
      return r[n] || (r[n] = {}), r[n];
    },
    _measureChar: function (t, e, i, r) {
      var n,
        o,
        s,
        a,
        c = this.getFontCache(e),
        h = this._getFontDeclaration(e),
        l = this._getFontDeclaration(r),
        u = i + t,
        f = h === l,
        d = e.fontSize / this.CACHE_FONT_SIZE;
      if (
        (i && void 0 !== c[i] && (s = c[i]),
        void 0 !== c[t] && (a = n = c[t]),
        f && void 0 !== c[u] && ((o = c[u]), (a = o - s)),
        void 0 === n || void 0 === s || void 0 === o)
      ) {
        var g = this.getMeasuringContext();
        this._setTextStyles(g, e, !0);
      }
      return (
        void 0 === n && ((a = n = g.measureText(t).width), (c[t] = n)),
        void 0 === s && f && i && ((s = g.measureText(i).width), (c[i] = s)),
        f &&
          void 0 === o &&
          ((o = g.measureText(u).width), (c[u] = o), (a = o - s)),
        { width: n * d, kernedWidth: a * d }
      );
    },
    getHeightOfChar: function (t, e) {
      return this.getValueOfPropertyAt(t, e, "fontSize");
    },
    measureLine: function (t) {
      var e = this._measureLine(t);
      return (
        0 !== this.charSpacing && (e.width -= this._getWidthOfCharSpacing()),
        e.width < 0 && (e.width = 0),
        e
      );
    },
    _measureLine: function (t) {
      var i,
        r,
        n,
        o,
        s,
        a,
        c = 0,
        h = this._textLines[t],
        l = 0,
        u = new Array(h.length),
        f = 0,
        d = this.path,
        g = "right" === this.pathSide;
      for (this.__charBounds[t] = u, i = 0; i < h.length; i++)
        (r = h[i]),
          (o = this._getGraphemeBox(r, t, i, n)),
          (u[i] = o),
          (c += o.kernedWidth),
          (n = r);
      if (
        ((u[i] = {
          left: o ? o.left + o.width : 0,
          width: 0,
          kernedWidth: 0,
          height: this.fontSize,
        }),
        d)
      ) {
        switch (
          ((a = d.segmentsInfo[d.segmentsInfo.length - 1].length),
          (s = e.util.getPointOnPath(d.path, 0, d.segmentsInfo)),
          (s.x += d.pathOffset.x),
          (s.y += d.pathOffset.y),
          this.textAlign)
        ) {
          case "left":
            f = g ? a - c : 0;
            break;
          case "center":
            f = (a - c) / 2;
            break;
          case "right":
            f = g ? 0 : a - c;
        }
        for (
          f += this.pathStartOffset * (g ? -1 : 1), i = g ? h.length - 1 : 0;
          g ? i >= 0 : i < h.length;
          g ? i-- : i++
        )
          (o = u[i]),
            f > a ? (f %= a) : 0 > f && (f += a),
            this._setGraphemeOnPath(f, o, s),
            (f += o.kernedWidth);
      }
      return { width: c, numOfSpaces: l };
    },
    _setGraphemeOnPath: function (t, i, r) {
      var n = t + i.kernedWidth / 2,
        o = this.path,
        s = e.util.getPointOnPath(o.path, n, o.segmentsInfo);
      (i.renderLeft = s.x - r.x),
        (i.renderTop = s.y - r.y),
        (i.angle = s.angle + ("right" === this.pathSide ? Math.PI : 0));
    },
    _getGraphemeBox: function (t, e, i, r, n) {
      var o,
        s = this.getCompleteStyleDeclaration(e, i),
        a = r ? this.getCompleteStyleDeclaration(e, i - 1) : {},
        c = this._measureChar(t, s, r, a),
        h = c.kernedWidth,
        l = c.width;
      0 !== this.charSpacing &&
        ((o = this._getWidthOfCharSpacing()), (l += o), (h += o));
      var u = {
        width: l,
        left: 0,
        height: s.fontSize,
        kernedWidth: h,
        deltaY: s.deltaY,
      };
      if (i > 0 && !n) {
        var f = this.__charBounds[e][i - 1];
        u.left = f.left + f.width + c.kernedWidth - c.width;
      }
      return u;
    },
    getHeightOfLine: function (t) {
      if (this.__lineHeights[t]) return this.__lineHeights[t];
      for (
        var e = this._textLines[t],
          i = this.getHeightOfChar(t, 0),
          r = 1,
          n = e.length;
        n > r;
        r++
      )
        i = Math.max(this.getHeightOfChar(t, r), i);
      return (this.__lineHeights[t] = i * this.lineHeight * this._fontSizeMult);
    },
    calcTextHeight: function () {
      for (var t, e = 0, i = 0, r = this._textLines.length; r > i; i++)
        (t = this.getHeightOfLine(i)),
          (e += i === r - 1 ? t / this.lineHeight : t);
      return e;
    },
    _getLeftOffset: function () {
      return "ltr" === this.direction ? -this.width / 2 : this.width / 2;
    },
    _getTopOffset: function () {
      return -this.height / 2;
    },
    _renderTextCommon: function (t, e) {
      t.save();
      for (
        var i = 0,
          r = this._getLeftOffset(),
          n = this._getTopOffset(),
          o = 0,
          s = this._textLines.length;
        s > o;
        o++
      ) {
        var a = this.getHeightOfLine(o),
          c = a / this.lineHeight,
          h = this._getLineLeftOffset(o);
        this._renderTextLine(e, t, this._textLines[o], r + h, n + i + c, o),
          (i += a);
      }
      t.restore();
    },
    _renderTextFill: function (t) {
      (this.fill || this.styleHas("fill")) &&
        this._renderTextCommon(t, "fillText");
    },
    _renderTextStroke: function (t) {
      ((this.stroke && 0 !== this.strokeWidth) || !this.isEmptyStyles()) &&
        (this.shadow && !this.shadow.affectStroke && this._removeShadow(t),
        t.save(),
        this._setLineDash(t, this.strokeDashArray),
        t.beginPath(),
        this._renderTextCommon(t, "strokeText"),
        t.closePath(),
        t.restore());
    },
    _renderChars: function (t, i, r, n, o, s) {
      var a,
        c,
        h,
        l,
        u,
        f = this.getHeightOfLine(s),
        d = -1 !== this.textAlign.indexOf("justify"),
        g = "",
        p = 0,
        v = this.path,
        m = !d && 0 === this.charSpacing && this.isEmptyStyles(s) && !v,
        b = "ltr" === this.direction,
        y = "ltr" === this.direction ? 1 : -1,
        x = i.canvas.getAttribute("dir");
      if (
        (i.save(),
        x !== this.direction &&
          (i.canvas.setAttribute("dir", b ? "ltr" : "rtl"),
          (i.direction = b ? "ltr" : "rtl"),
          (i.textAlign = b ? "left" : "right")),
        (o -= (f * this._fontSizeFraction) / this.lineHeight),
        m)
      )
        return (
          this._renderChar(t, i, s, 0, r.join(""), n, o, f), void i.restore()
        );
      for (var _ = 0, C = r.length - 1; C >= _; _++)
        (l = _ === C || this.charSpacing || v),
          (g += r[_]),
          (h = this.__charBounds[s][_]),
          0 === p
            ? ((n += y * (h.kernedWidth - h.width)), (p += h.width))
            : (p += h.kernedWidth),
          d && !l && this._reSpaceAndTab.test(r[_]) && (l = !0),
          l ||
            ((a = a || this.getCompleteStyleDeclaration(s, _)),
            (c = this.getCompleteStyleDeclaration(s, _ + 1)),
            (l = e.util.hasStyleChanged(a, c, !1))),
          l &&
            (v
              ? (i.save(),
                i.translate(h.renderLeft, h.renderTop),
                i.rotate(h.angle),
                this._renderChar(t, i, s, _, g, -p / 2, 0, f),
                i.restore())
              : ((u = n), this._renderChar(t, i, s, _, g, u, o, f)),
            (g = ""),
            (a = c),
            (n += y * p),
            (p = 0));
      i.restore();
    },
    _applyPatternGradientTransformText: function (t) {
      var i,
        r = e.util.createCanvasElement(),
        n = this.width + this.strokeWidth,
        o = this.height + this.strokeWidth;
      return (
        (r.width = n),
        (r.height = o),
        (i = r.getContext("2d")),
        i.beginPath(),
        i.moveTo(0, 0),
        i.lineTo(n, 0),
        i.lineTo(n, o),
        i.lineTo(0, o),
        i.closePath(),
        i.translate(n / 2, o / 2),
        (i.fillStyle = t.toLive(i)),
        this._applyPatternGradientTransform(i, t),
        i.fill(),
        i.createPattern(r, "no-repeat")
      );
    },
    handleFiller: function (t, e, i) {
      var r, n;
      return i.toLive
        ? "percentage" === i.gradientUnits ||
          i.gradientTransform ||
          i.patternTransform
          ? ((r = -this.width / 2),
            (n = -this.height / 2),
            t.translate(r, n),
            (t[e] = this._applyPatternGradientTransformText(i)),
            { offsetX: r, offsetY: n })
          : ((t[e] = i.toLive(t, this)),
            this._applyPatternGradientTransform(t, i))
        : ((t[e] = i), { offsetX: 0, offsetY: 0 });
    },
    _setStrokeStyles: function (t, e) {
      return (
        (t.lineWidth = e.strokeWidth),
        (t.lineCap = this.strokeLineCap),
        (t.lineDashOffset = this.strokeDashOffset),
        (t.lineJoin = this.strokeLineJoin),
        (t.miterLimit = this.strokeMiterLimit),
        this.handleFiller(t, "strokeStyle", e.stroke)
      );
    },
    _setFillStyles: function (t, e) {
      return this.handleFiller(t, "fillStyle", e.fill);
    },
    _renderChar: function (t, e, i, r, n, o, s) {
      var a,
        c,
        h = this._getStyleDeclaration(i, r),
        l = this.getCompleteStyleDeclaration(i, r),
        u = "fillText" === t && l.fill,
        f = "strokeText" === t && l.stroke && l.strokeWidth;
      (f || u) &&
        (e.save(),
        u && (a = this._setFillStyles(e, l)),
        f && (c = this._setStrokeStyles(e, l)),
        (e.font = this._getFontDeclaration(l)),
        h && h.textBackgroundColor && this._removeShadow(e),
        h && h.deltaY && (s += h.deltaY),
        u && e.fillText(n, o - a.offsetX, s - a.offsetY),
        f && e.strokeText(n, o - c.offsetX, s - c.offsetY),
        e.restore());
    },
    setSuperscript: function (t, e) {
      return this._setScript(t, e, this.superscript);
    },
    setSubscript: function (t, e) {
      return this._setScript(t, e, this.subscript);
    },
    _setScript: function (t, e, i) {
      var r = this.get2DCursorLocation(t, !0),
        n = this.getValueOfPropertyAt(r.lineIndex, r.charIndex, "fontSize"),
        o = this.getValueOfPropertyAt(r.lineIndex, r.charIndex, "deltaY"),
        s = { fontSize: n * i.size, deltaY: o + n * i.baseline };
      return this.setSelectionStyles(s, t, e), this;
    },
    _getLineLeftOffset: function (t) {
      var e,
        i = this.getLineWidth(t),
        r = this.width - i,
        n = this.textAlign,
        o = this.direction,
        s = 0,
        e = this.isEndOfWrapping(t);
      return "justify" === n ||
        ("justify-center" === n && !e) ||
        ("justify-right" === n && !e) ||
        ("justify-left" === n && !e)
        ? 0
        : ("center" === n && (s = r / 2),
          "right" === n && (s = r),
          "justify-center" === n && (s = r / 2),
          "justify-right" === n && (s = r),
          "rtl" === o && (s -= r),
          s);
    },
    _clearCache: function () {
      (this.__lineWidths = []),
        (this.__lineHeights = []),
        (this.__charBounds = []);
    },
    _shouldClearDimensionCache: function () {
      var t = this._forceClearCache;
      return (
        t || (t = this.hasStateChanged("_dimensionAffectingProps")),
        t && ((this.dirty = !0), (this._forceClearCache = !1)),
        t
      );
    },
    getLineWidth: function (t) {
      if (void 0 !== this.__lineWidths[t]) return this.__lineWidths[t];
      var e = this.measureLine(t),
        i = e.width;
      return (this.__lineWidths[t] = i), i;
    },
    _getWidthOfCharSpacing: function () {
      return 0 !== this.charSpacing
        ? (this.fontSize * this.charSpacing) / 1e3
        : 0;
    },
    getValueOfPropertyAt: function (t, e, i) {
      var r = this._getStyleDeclaration(t, e);
      return r && "undefined" != typeof r[i] ? r[i] : this[i];
    },
    _renderTextDecoration: function (t, e) {
      if (this[e] || this.styleHas(e)) {
        for (
          var i,
            r,
            n,
            o,
            s,
            a,
            c,
            h,
            l,
            u,
            f,
            d,
            g,
            p,
            v,
            m,
            b = this._getLeftOffset(),
            y = this._getTopOffset(),
            x = this.path,
            _ = this._getWidthOfCharSpacing(),
            C = this.offsets[e],
            w = 0,
            S = this._textLines.length;
          S > w;
          w++
        )
          if (((i = this.getHeightOfLine(w)), this[e] || this.styleHas(e, w))) {
            (c = this._textLines[w]),
              (p = i / this.lineHeight),
              (o = this._getLineLeftOffset(w)),
              (u = 0),
              (f = 0),
              (h = this.getValueOfPropertyAt(w, 0, e)),
              (m = this.getValueOfPropertyAt(w, 0, "fill")),
              (l = y + p * (1 - this._fontSizeFraction)),
              (r = this.getHeightOfChar(w, 0)),
              (s = this.getValueOfPropertyAt(w, 0, "deltaY"));
            for (var T = 0, O = c.length; O > T; T++)
              if (
                ((d = this.__charBounds[w][T]),
                (g = this.getValueOfPropertyAt(w, T, e)),
                (v = this.getValueOfPropertyAt(w, T, "fill")),
                (n = this.getHeightOfChar(w, T)),
                (a = this.getValueOfPropertyAt(w, T, "deltaY")),
                x && g && v)
              )
                t.save(),
                  (t.fillStyle = m),
                  t.translate(d.renderLeft, d.renderTop),
                  t.rotate(d.angle),
                  t.fillRect(
                    -d.kernedWidth / 2,
                    C * n + a,
                    d.kernedWidth,
                    this.fontSize / 15
                  ),
                  t.restore();
              else if ((g !== h || v !== m || n !== r || a !== s) && f > 0) {
                var j = b + o + u;
                "rtl" === this.direction && (j = this.width - j - f),
                  h &&
                    m &&
                    ((t.fillStyle = m),
                    t.fillRect(j, l + C * r + s, f, this.fontSize / 15)),
                  (u = d.left),
                  (f = d.width),
                  (h = g),
                  (m = v),
                  (r = n),
                  (s = a);
              } else f += d.kernedWidth;
            var j = b + o + u;
            "rtl" === this.direction && (j = this.width - j - f),
              (t.fillStyle = v),
              g && v && t.fillRect(j, l + C * r + s, f - _, this.fontSize / 15),
              (y += i);
          } else y += i;
        this._removeShadow(t);
      }
    },
    _getFontDeclaration: function (t, i) {
      var r = t || this,
        n = this.fontFamily,
        o = e.Text.genericFonts.indexOf(n.toLowerCase()) > -1,
        s =
          void 0 === n ||
          n.indexOf("'") > -1 ||
          n.indexOf(",") > -1 ||
          n.indexOf('"') > -1 ||
          o
            ? r.fontFamily
            : '"' + r.fontFamily + '"';
      return [
        e.isLikelyNode ? r.fontWeight : r.fontStyle,
        e.isLikelyNode ? r.fontStyle : r.fontWeight,
        i ? this.CACHE_FONT_SIZE + "px" : r.fontSize + "px",
        s,
      ].join(" ");
    },
    render: function (t) {
      this.visible &&
        (!this.canvas ||
          !this.canvas.skipOffscreen ||
          this.group ||
          this.isOnScreen()) &&
        (this._shouldClearDimensionCache() && this.initDimensions(),
        this.callSuper("render", t));
    },
    _splitTextIntoLines: function (t) {
      for (
        var i = t.split(this._reNewline),
          r = new Array(i.length),
          n = ["\n"],
          o = [],
          s = 0;
        s < i.length;
        s++
      )
        (r[s] = e.util.string.graphemeSplit(i[s])), (o = o.concat(r[s], n));
      return (
        o.pop(),
        { _unwrappedLines: r, lines: i, graphemeText: o, graphemeLines: r }
      );
    },
    toObject: function (t) {
      var i = r.concat(t),
        n = this.callSuper("toObject", i);
      return (
        (n.styles = e.util.stylesToArray(this.styles, this.text)),
        n.path && (n.path = this.path.toObject()),
        n
      );
    },
    set: function (t, e) {
      this.callSuper("set", t, e);
      var i = !1,
        r = !1;
      if ("object" == typeof t)
        for (var n in t)
          "path" === n && this.setPathInfo(),
            (i = i || -1 !== this._dimensionAffectingProps.indexOf(n)),
            (r = r || "path" === n);
      else
        (i = -1 !== this._dimensionAffectingProps.indexOf(t)),
          (r = "path" === t);
      return (
        r && this.setPathInfo(),
        i && (this.initDimensions(), this.setCoords()),
        this
      );
    },
    complexity: function () {
      return 1;
    },
  })),
    (e.Text.ATTRIBUTE_NAMES = e.SHARED_ATTRIBUTES.concat(
      "x y dx dy font-family font-style font-weight font-size letter-spacing text-decoration text-anchor".split(
        " "
      )
    )),
    (e.Text.DEFAULT_SVG_FONT_SIZE = 16),
    (e.Text.fromElement = function (t, r, n) {
      if (!t) return r(null);
      var o = e.parseAttributes(t, e.Text.ATTRIBUTE_NAMES),
        s = o.textAnchor || "left";
      if (
        ((n = e.util.object.extend(n ? i(n) : {}, o)),
        (n.top = n.top || 0),
        (n.left = n.left || 0),
        o.textDecoration)
      ) {
        var a = o.textDecoration;
        -1 !== a.indexOf("underline") && (n.underline = !0),
          -1 !== a.indexOf("overline") && (n.overline = !0),
          -1 !== a.indexOf("line-through") && (n.linethrough = !0),
          delete n.textDecoration;
      }
      "dx" in o && (n.left += o.dx),
        "dy" in o && (n.top += o.dy),
        "fontSize" in n || (n.fontSize = e.Text.DEFAULT_SVG_FONT_SIZE);
      var c = "";
      "textContent" in t
        ? (c = t.textContent)
        : "firstChild" in t &&
          null !== t.firstChild &&
          "data" in t.firstChild &&
          null !== t.firstChild.data &&
          (c = t.firstChild.data),
        (c = c.replace(/^\s+|\s+$|\n+/g, "").replace(/\s+/g, " "));
      var h = n.strokeWidth;
      n.strokeWidth = 0;
      var l = new e.Text(c, n),
        u = l.getScaledHeight() / l.height,
        f = (l.height + l.strokeWidth) * l.lineHeight - l.height,
        d = f * u,
        g = l.getScaledHeight() + d,
        p = 0;
      "center" === s && (p = l.getScaledWidth() / 2),
        "right" === s && (p = l.getScaledWidth()),
        l.set({
          left: l.left - p,
          top:
            l.top -
            (g - l.fontSize * (0.07 + l._fontSizeFraction)) / l.lineHeight,
          strokeWidth: "undefined" != typeof h ? h : 1,
        }),
        r(l);
    }),
    (e.Text.fromObject = function (t, r) {
      var n = i(t),
        o = t.path;
      return (
        delete n.path,
        e.Object._fromObject(
          "Text",
          n,
          function (i) {
            (i.styles = e.util.stylesFromArray(t.styles, t.text)),
              o
                ? e.Object._fromObject(
                    "Path",
                    o,
                    function (t) {
                      i.set("path", t), r(i);
                    },
                    "path"
                  )
                : r(i);
          },
          "text"
        )
      );
    }),
    (e.Text.genericFonts = [
      "sans-serif",
      "serif",
      "cursive",
      "fantasy",
      "monospace",
    ]),
    e.util.createAccessors && e.util.createAccessors(e.Text);
})("undefined" != typeof exports ? exports : this);
!(function () {
  fabric.util.object.extend(fabric.Text.prototype, {
    isEmptyStyles: function (t) {
      if (!this.styles) return !0;
      if ("undefined" != typeof t && !this.styles[t]) return !0;
      var e = "undefined" == typeof t ? this.styles : { line: this.styles[t] };
      for (var i in e) for (var r in e[i]) for (var n in e[i][r]) return !1;
      return !0;
    },
    styleHas: function (t, e) {
      if (!this.styles || !t || "" === t) return !1;
      if ("undefined" != typeof e && !this.styles[e]) return !1;
      var i = "undefined" == typeof e ? this.styles : { 0: this.styles[e] };
      for (var r in i)
        for (var n in i[r]) if ("undefined" != typeof i[r][n][t]) return !0;
      return !1;
    },
    cleanStyle: function (t) {
      if (!this.styles || !t || "" === t) return !1;
      var e,
        i,
        r,
        n = this.styles,
        o = 0,
        s = !0,
        a = 0;
      for (var c in n) {
        e = 0;
        for (var h in n[c]) {
          var r = n[c][h],
            l = r.hasOwnProperty(t);
          o++,
            l
              ? (i ? r[t] !== i && (s = !1) : (i = r[t]),
                r[t] === this[t] && delete r[t])
              : (s = !1),
            0 !== Object.keys(r).length ? e++ : delete n[c][h];
        }
        0 === e && delete n[c];
      }
      for (var u = 0; u < this._textLines.length; u++)
        a += this._textLines[u].length;
      s && o === a && ((this[t] = i), this.removeStyle(t));
    },
    removeStyle: function (t) {
      if (this.styles && t && "" !== t) {
        var e,
          i,
          r,
          n = this.styles;
        for (i in n) {
          e = n[i];
          for (r in e)
            delete e[r][t], 0 === Object.keys(e[r]).length && delete e[r];
          0 === Object.keys(e).length && delete n[i];
        }
      }
    },
    _extendStyles: function (t, e) {
      var i = this.get2DCursorLocation(t);
      this._getLineStyle(i.lineIndex) || this._setLineStyle(i.lineIndex),
        this._getStyleDeclaration(i.lineIndex, i.charIndex) ||
          this._setStyleDeclaration(i.lineIndex, i.charIndex, {}),
        fabric.util.object.extend(
          this._getStyleDeclaration(i.lineIndex, i.charIndex),
          e
        );
    },
    get2DCursorLocation: function (t, e) {
      "undefined" == typeof t && (t = this.selectionStart);
      for (
        var i = e ? this._unwrappedTextLines : this._textLines,
          r = i.length,
          n = 0;
        r > n;
        n++
      ) {
        if (t <= i[n].length) return { lineIndex: n, charIndex: t };
        t -= i[n].length + this.missingNewlineOffset(n);
      }
      return {
        lineIndex: n - 1,
        charIndex: i[n - 1].length < t ? i[n - 1].length : t,
      };
    },
    getSelectionStyles: function (t, e, i) {
      "undefined" == typeof t && (t = this.selectionStart || 0),
        "undefined" == typeof e && (e = this.selectionEnd || t);
      for (var r = [], n = t; e > n; n++) r.push(this.getStyleAtPosition(n, i));
      return r;
    },
    getStyleAtPosition: function (t, e) {
      var i = this.get2DCursorLocation(t),
        r = e
          ? this.getCompleteStyleDeclaration(i.lineIndex, i.charIndex)
          : this._getStyleDeclaration(i.lineIndex, i.charIndex);
      return r || {};
    },
    setSelectionStyles: function (t, e, i) {
      "undefined" == typeof e && (e = this.selectionStart || 0),
        "undefined" == typeof i && (i = this.selectionEnd || e);
      for (var r = e; i > r; r++) this._extendStyles(r, t);
      return (this._forceClearCache = !0), this;
    },
    _getStyleDeclaration: function (t, e) {
      var i = this.styles && this.styles[t];
      return i ? i[e] : null;
    },
    getCompleteStyleDeclaration: function (t, e) {
      for (
        var i, r = this._getStyleDeclaration(t, e) || {}, n = {}, o = 0;
        o < this._styleProperties.length;
        o++
      )
        (i = this._styleProperties[o]),
          (n[i] = "undefined" == typeof r[i] ? this[i] : r[i]);
      return n;
    },
    _setStyleDeclaration: function (t, e, i) {
      this.styles[t][e] = i;
    },
    _deleteStyleDeclaration: function (t, e) {
      delete this.styles[t][e];
    },
    _getLineStyle: function (t) {
      return !!this.styles[t];
    },
    _setLineStyle: function (t) {
      this.styles[t] = {};
    },
    _deleteLineStyle: function (t) {
      delete this.styles[t];
    },
  });
})();
!(function () {
  function t(t) {
    t.textDecoration &&
      (t.textDecoration.indexOf("underline") > -1 && (t.underline = !0),
      t.textDecoration.indexOf("line-through") > -1 && (t.linethrough = !0),
      t.textDecoration.indexOf("overline") > -1 && (t.overline = !0),
      delete t.textDecoration);
  }
  (fabric.IText = fabric.util.createClass(fabric.Text, fabric.Observable, {
    type: "i-text",
    selectionStart: 0,
    selectionEnd: 0,
    selectionColor: "rgba(17,119,255,0.3)",
    isEditing: !1,
    editable: !0,
    editingBorderColor: "rgba(102,153,255,0.25)",
    cursorWidth: 2,
    cursorColor: "",
    cursorDelay: 1e3,
    cursorDuration: 600,
    caching: !0,
    hiddenTextareaContainer: null,
    _reSpace: /\s|\n/,
    _currentCursorOpacity: 0,
    _selectionDirection: null,
    _abortCursorAnimation: !1,
    __widthOfSpace: [],
    inCompositionMode: !1,
    initialize: function (t, e) {
      this.callSuper("initialize", t, e), this.initBehavior();
    },
    setSelectionStart: function (t) {
      (t = Math.max(t, 0)), this._updateAndFire("selectionStart", t);
    },
    setSelectionEnd: function (t) {
      (t = Math.min(t, this.text.length)),
        this._updateAndFire("selectionEnd", t);
    },
    _updateAndFire: function (t, e) {
      this[t] !== e && (this._fireSelectionChanged(), (this[t] = e)),
        this._updateTextarea();
    },
    _fireSelectionChanged: function () {
      this.fire("selection:changed"),
        this.canvas &&
          this.canvas.fire("text:selection:changed", { target: this });
    },
    initDimensions: function () {
      this.isEditing && this.initDelayedCursor(),
        this.clearContextTop(),
        this.callSuper("initDimensions");
    },
    render: function (t) {
      this.clearContextTop(),
        this.callSuper("render", t),
        (this.cursorOffsetCache = {}),
        this.renderCursorOrSelection();
    },
    _render: function (t) {
      this.callSuper("_render", t);
    },
    clearContextTop: function (t) {
      if (this.isEditing && this.canvas && this.canvas.contextTop) {
        var e = this.canvas.contextTop,
          i = this.canvas.viewportTransform;
        e.save(),
          e.transform(i[0], i[1], i[2], i[3], i[4], i[5]),
          this.transform(e),
          this._clearTextArea(e),
          t || e.restore();
      }
    },
    renderCursorOrSelection: function () {
      if (this.isEditing && this.canvas && this.canvas.contextTop) {
        var t = this._getCursorBoundaries(),
          e = this.canvas.contextTop;
        this.clearContextTop(!0),
          this.selectionStart === this.selectionEnd
            ? this.renderCursor(t, e)
            : this.renderSelection(t, e),
          e.restore();
      }
    },
    _clearTextArea: function (t) {
      var e = this.width + 4,
        i = this.height + 4;
      t.clearRect(-e / 2, -i / 2, e, i);
    },
    _getCursorBoundaries: function (t) {
      "undefined" == typeof t && (t = this.selectionStart);
      var e = this._getLeftOffset(),
        i = this._getTopOffset(),
        r = this._getCursorBoundariesOffsets(t);
      return { left: e, top: i, leftOffset: r.left, topOffset: r.top };
    },
    _getCursorBoundariesOffsets: function (t) {
      if (this.cursorOffsetCache && "top" in this.cursorOffsetCache)
        return this.cursorOffsetCache;
      var e,
        i,
        r,
        n,
        o = 0,
        s = 0,
        a = this.get2DCursorLocation(t);
      (r = a.charIndex), (i = a.lineIndex);
      for (var c = 0; i > c; c++) o += this.getHeightOfLine(c);
      e = this._getLineLeftOffset(i);
      var h = this.__charBounds[i][r];
      return (
        h && (s = h.left),
        0 !== this.charSpacing &&
          r === this._textLines[i].length &&
          (s -= this._getWidthOfCharSpacing()),
        (n = { top: o, left: e + (s > 0 ? s : 0) }),
        "rtl" === this.direction && (n.left *= -1),
        (this.cursorOffsetCache = n),
        this.cursorOffsetCache
      );
    },
    renderCursor: function (t, e) {
      var i = this.get2DCursorLocation(),
        r = i.lineIndex,
        n = i.charIndex > 0 ? i.charIndex - 1 : 0,
        o = this.getValueOfPropertyAt(r, n, "fontSize"),
        s = this.scaleX * this.canvas.getZoom(),
        a = this.cursorWidth / s,
        c = t.topOffset,
        h = this.getValueOfPropertyAt(r, n, "deltaY");
      (c +=
        ((1 - this._fontSizeFraction) * this.getHeightOfLine(r)) /
          this.lineHeight -
        o * (1 - this._fontSizeFraction)),
        this.inCompositionMode && this.renderSelection(t, e),
        (e.fillStyle =
          this.cursorColor || this.getValueOfPropertyAt(r, n, "fill")),
        (e.globalAlpha = this.__isMousedown ? 1 : this._currentCursorOpacity),
        e.fillRect(t.left + t.leftOffset - a / 2, c + t.top + h, a, o);
    },
    renderSelection: function (t, e) {
      for (
        var i = this.inCompositionMode
            ? this.hiddenTextarea.selectionStart
            : this.selectionStart,
          r = this.inCompositionMode
            ? this.hiddenTextarea.selectionEnd
            : this.selectionEnd,
          n = -1 !== this.textAlign.indexOf("justify"),
          o = this.get2DCursorLocation(i),
          s = this.get2DCursorLocation(r),
          a = o.lineIndex,
          c = s.lineIndex,
          h = o.charIndex < 0 ? 0 : o.charIndex,
          l = s.charIndex < 0 ? 0 : s.charIndex,
          u = a;
        c >= u;
        u++
      ) {
        var f = this._getLineLeftOffset(u) || 0,
          d = this.getHeightOfLine(u),
          g = 0,
          p = 0,
          v = 0;
        if ((u === a && (p = this.__charBounds[a][h].left), u >= a && c > u))
          v =
            n && !this.isEndOfWrapping(u)
              ? this.width
              : this.getLineWidth(u) || 5;
        else if (u === c)
          if (0 === l) v = this.__charBounds[c][l].left;
          else {
            var m = this._getWidthOfCharSpacing();
            v =
              this.__charBounds[c][l - 1].left +
              this.__charBounds[c][l - 1].width -
              m;
          }
        (g = d),
          (this.lineHeight < 1 || (u === c && this.lineHeight > 1)) &&
            (d /= this.lineHeight);
        var b = t.left + f + p,
          y = v - p,
          x = d,
          _ = 0;
        this.inCompositionMode
          ? ((e.fillStyle = this.compositionColor || "black"), (x = 1), (_ = d))
          : (e.fillStyle = this.selectionColor),
          "rtl" === this.direction && (b = this.width - b - y),
          e.fillRect(b, t.top + t.topOffset + _, y, x),
          (t.topOffset += g);
      }
    },
    getCurrentCharFontSize: function () {
      var t = this._getCurrentCharIndex();
      return this.getValueOfPropertyAt(t.l, t.c, "fontSize");
    },
    getCurrentCharColor: function () {
      var t = this._getCurrentCharIndex();
      return this.getValueOfPropertyAt(t.l, t.c, "fill");
    },
    _getCurrentCharIndex: function () {
      var t = this.get2DCursorLocation(this.selectionStart, !0),
        e = t.charIndex > 0 ? t.charIndex - 1 : 0;
      return { l: t.lineIndex, c: e };
    },
  })),
    (fabric.IText.fromObject = function (e, i) {
      if (
        ((e.styles = fabric.util.stylesFromArray(e.styles, e.text)),
        t(e),
        e.styles)
      )
        for (var r in e.styles) for (var n in e.styles[r]) t(e.styles[r][n]);
      fabric.Object._fromObject("IText", e, i, "text");
    });
})();
!(function () {
  var t = fabric.util.object.clone;
  fabric.util.object.extend(fabric.IText.prototype, {
    initBehavior: function () {
      this.initAddedHandler(),
        this.initRemovedHandler(),
        this.initCursorSelectionHandlers(),
        this.initDoubleClickSimulation(),
        (this.mouseMoveHandler = this.mouseMoveHandler.bind(this));
    },
    onDeselect: function () {
      this.isEditing && this.exitEditing(), (this.selected = !1);
    },
    initAddedHandler: function () {
      var t = this;
      this.on("added", function () {
        var e = t.canvas;
        e &&
          (e._hasITextHandlers ||
            ((e._hasITextHandlers = !0), t._initCanvasHandlers(e)),
          (e._iTextInstances = e._iTextInstances || []),
          e._iTextInstances.push(t));
      });
    },
    initRemovedHandler: function () {
      var t = this;
      this.on("removed", function () {
        var e = t.canvas;
        e &&
          ((e._iTextInstances = e._iTextInstances || []),
          fabric.util.removeFromArray(e._iTextInstances, t),
          0 === e._iTextInstances.length &&
            ((e._hasITextHandlers = !1), t._removeCanvasHandlers(e)));
      });
    },
    _initCanvasHandlers: function (t) {
      (t._mouseUpITextHandler = function () {
        t._iTextInstances &&
          t._iTextInstances.forEach(function (t) {
            t.__isMousedown = !1;
          });
      }),
        t.on("mouse:up", t._mouseUpITextHandler);
    },
    _removeCanvasHandlers: function (t) {
      t.off("mouse:up", t._mouseUpITextHandler);
    },
    _tick: function () {
      this._currentTickState = this._animateCursor(
        this,
        1,
        this.cursorDuration,
        "_onTickComplete"
      );
    },
    _animateCursor: function (t, e, i, r) {
      var n;
      return (
        (n = {
          isAborted: !1,
          abort: function () {
            this.isAborted = !0;
          },
        }),
        t.animate("_currentCursorOpacity", e, {
          duration: i,
          onComplete: function () {
            n.isAborted || t[r]();
          },
          onChange: function () {
            t.canvas &&
              t.selectionStart === t.selectionEnd &&
              t.renderCursorOrSelection();
          },
          abort: function () {
            return n.isAborted;
          },
        }),
        n
      );
    },
    _onTickComplete: function () {
      var t = this;
      this._cursorTimeout1 && clearTimeout(this._cursorTimeout1),
        (this._cursorTimeout1 = setTimeout(function () {
          t._currentTickCompleteState = t._animateCursor(
            t,
            0,
            this.cursorDuration / 2,
            "_tick"
          );
        }, 100));
    },
    initDelayedCursor: function (t) {
      var e = this,
        i = t ? 0 : this.cursorDelay;
      this.abortCursorAnimation(),
        (this._currentCursorOpacity = 1),
        (this._cursorTimeout2 = setTimeout(function () {
          e._tick();
        }, i));
    },
    abortCursorAnimation: function () {
      var t = this._currentTickState || this._currentTickCompleteState,
        e = this.canvas;
      this._currentTickState && this._currentTickState.abort(),
        this._currentTickCompleteState &&
          this._currentTickCompleteState.abort(),
        clearTimeout(this._cursorTimeout1),
        clearTimeout(this._cursorTimeout2),
        (this._currentCursorOpacity = 0),
        t && e && e.clearContext(e.contextTop || e.contextContainer);
    },
    selectAll: function () {
      return (
        (this.selectionStart = 0),
        (this.selectionEnd = this._text.length),
        this._fireSelectionChanged(),
        this._updateTextarea(),
        this
      );
    },
    getSelectedText: function () {
      return this._text.slice(this.selectionStart, this.selectionEnd).join("");
    },
    findWordBoundaryLeft: function (t) {
      var e = 0,
        i = t - 1;
      if (this._reSpace.test(this._text[i]))
        for (; this._reSpace.test(this._text[i]); ) e++, i--;
      for (; /\S/.test(this._text[i]) && i > -1; ) e++, i--;
      return t - e;
    },
    findWordBoundaryRight: function (t) {
      var e = 0,
        i = t;
      if (this._reSpace.test(this._text[i]))
        for (; this._reSpace.test(this._text[i]); ) e++, i++;
      for (; /\S/.test(this._text[i]) && i < this._text.length; ) e++, i++;
      return t + e;
    },
    findLineBoundaryLeft: function (t) {
      for (var e = 0, i = t - 1; !/\n/.test(this._text[i]) && i > -1; )
        e++, i--;
      return t - e;
    },
    findLineBoundaryRight: function (t) {
      for (
        var e = 0, i = t;
        !/\n/.test(this._text[i]) && i < this._text.length;

      )
        e++, i++;
      return t + e;
    },
    searchWordBoundary: function (t, e) {
      for (
        var i = this._text,
          r = this._reSpace.test(i[t]) ? t - 1 : t,
          n = i[r],
          o = fabric.reNonWord;
        !o.test(n) && r > 0 && r < i.length;

      )
        (r += e), (n = i[r]);
      return o.test(n) && (r += 1 === e ? 0 : 1), r;
    },
    selectWord: function (t) {
      t = t || this.selectionStart;
      var e = this.searchWordBoundary(t, -1),
        i = this.searchWordBoundary(t, 1);
      (this.selectionStart = e),
        (this.selectionEnd = i),
        this._fireSelectionChanged(),
        this._updateTextarea(),
        this.renderCursorOrSelection();
    },
    selectLine: function (t) {
      t = t || this.selectionStart;
      var e = this.findLineBoundaryLeft(t),
        i = this.findLineBoundaryRight(t);
      return (
        (this.selectionStart = e),
        (this.selectionEnd = i),
        this._fireSelectionChanged(),
        this._updateTextarea(),
        this
      );
    },
    enterEditing: function (t) {
      return !this.isEditing && this.editable
        ? (this.canvas &&
            (this.canvas.calcOffset(), this.exitEditingOnOthers(this.canvas)),
          (this.isEditing = !0),
          this.initHiddenTextarea(t),
          this.hiddenTextarea.focus(),
          (this.hiddenTextarea.value = this.text),
          this._updateTextarea(),
          this._saveEditingProps(),
          this._setEditingProps(),
          (this._textBeforeEdit = this.text),
          this._tick(),
          this.fire("editing:entered"),
          this._fireSelectionChanged(),
          this.canvas
            ? (this.canvas.fire("text:editing:entered", { target: this }),
              this.initMouseMoveHandler(),
              this.canvas.requestRenderAll(),
              this)
            : this)
        : void 0;
    },
    exitEditingOnOthers: function (t) {
      t._iTextInstances &&
        t._iTextInstances.forEach(function (t) {
          (t.selected = !1), t.isEditing && t.exitEditing();
        });
    },
    initMouseMoveHandler: function () {
      this.canvas.on("mouse:move", this.mouseMoveHandler);
    },
    mouseMoveHandler: function (t) {
      if (this.__isMousedown && this.isEditing) {
        var e = this.getSelectionStartFromPointer(t.e),
          i = this.selectionStart,
          r = this.selectionEnd;
        ((e === this.__selectionStartOnMouseDown && i !== r) ||
          (i !== e && r !== e)) &&
          (e > this.__selectionStartOnMouseDown
            ? ((this.selectionStart = this.__selectionStartOnMouseDown),
              (this.selectionEnd = e))
            : ((this.selectionStart = e),
              (this.selectionEnd = this.__selectionStartOnMouseDown)),
          (this.selectionStart !== i || this.selectionEnd !== r) &&
            (this.restartCursorIfNeeded(),
            this._fireSelectionChanged(),
            this._updateTextarea(),
            this.renderCursorOrSelection()));
      }
    },
    _setEditingProps: function () {
      (this.hoverCursor = "text"),
        this.canvas &&
          (this.canvas.defaultCursor = this.canvas.moveCursor = "text"),
        (this.borderColor = this.editingBorderColor),
        (this.hasControls = this.selectable = !1),
        (this.lockMovementX = this.lockMovementY = !0);
    },
    fromStringToGraphemeSelection: function (t, e, i) {
      var r = i.slice(0, t),
        n = fabric.util.string.graphemeSplit(r).length;
      if (t === e) return { selectionStart: n, selectionEnd: n };
      var o = i.slice(t, e),
        s = fabric.util.string.graphemeSplit(o).length;
      return { selectionStart: n, selectionEnd: n + s };
    },
    fromGraphemeToStringSelection: function (t, e, i) {
      var r = i.slice(0, t),
        n = r.join("").length;
      if (t === e) return { selectionStart: n, selectionEnd: n };
      var o = i.slice(t, e),
        s = o.join("").length;
      return { selectionStart: n, selectionEnd: n + s };
    },
    _updateTextarea: function () {
      if (((this.cursorOffsetCache = {}), this.hiddenTextarea)) {
        if (!this.inCompositionMode) {
          var t = this.fromGraphemeToStringSelection(
            this.selectionStart,
            this.selectionEnd,
            this._text
          );
          (this.hiddenTextarea.selectionStart = t.selectionStart),
            (this.hiddenTextarea.selectionEnd = t.selectionEnd);
        }
        this.updateTextareaPosition();
      }
    },
    updateFromTextArea: function () {
      if (this.hiddenTextarea) {
        (this.cursorOffsetCache = {}),
          (this.text = this.hiddenTextarea.value),
          this._shouldClearDimensionCache() &&
            (this.initDimensions(), this.setCoords());
        var t = this.fromStringToGraphemeSelection(
          this.hiddenTextarea.selectionStart,
          this.hiddenTextarea.selectionEnd,
          this.hiddenTextarea.value
        );
        (this.selectionEnd = this.selectionStart = t.selectionEnd),
          this.inCompositionMode || (this.selectionStart = t.selectionStart),
          this.updateTextareaPosition();
      }
    },
    updateTextareaPosition: function () {
      if (this.selectionStart === this.selectionEnd) {
        var t = this._calcTextareaPosition();
        (this.hiddenTextarea.style.left = t.left),
          (this.hiddenTextarea.style.top = t.top);
      }
    },
    _calcTextareaPosition: function () {
      if (!this.canvas) return { x: 1, y: 1 };
      var t = this.inCompositionMode
          ? this.compositionStart
          : this.selectionStart,
        e = this._getCursorBoundaries(t),
        i = this.get2DCursorLocation(t),
        r = i.lineIndex,
        n = i.charIndex,
        o = this.getValueOfPropertyAt(r, n, "fontSize") * this.lineHeight,
        s = e.leftOffset,
        a = this.calcTransformMatrix(),
        c = { x: e.left + s, y: e.top + e.topOffset + o },
        h = this.canvas.getRetinaScaling(),
        l = this.canvas.upperCanvasEl,
        u = l.width / h,
        f = l.height / h,
        d = u - o,
        g = f - o,
        p = l.clientWidth / u,
        v = l.clientHeight / f;
      return (
        (c = fabric.util.transformPoint(c, a)),
        (c = fabric.util.transformPoint(c, this.canvas.viewportTransform)),
        (c.x *= p),
        (c.y *= v),
        c.x < 0 && (c.x = 0),
        c.x > d && (c.x = d),
        c.y < 0 && (c.y = 0),
        c.y > g && (c.y = g),
        (c.x += this.canvas._offset.left),
        (c.y += this.canvas._offset.top),
        { left: c.x + "px", top: c.y + "px", fontSize: o + "px", charHeight: o }
      );
    },
    _saveEditingProps: function () {
      this._savedProps = {
        hasControls: this.hasControls,
        borderColor: this.borderColor,
        lockMovementX: this.lockMovementX,
        lockMovementY: this.lockMovementY,
        hoverCursor: this.hoverCursor,
        selectable: this.selectable,
        defaultCursor: this.canvas && this.canvas.defaultCursor,
        moveCursor: this.canvas && this.canvas.moveCursor,
      };
    },
    _restoreEditingProps: function () {
      this._savedProps &&
        ((this.hoverCursor = this._savedProps.hoverCursor),
        (this.hasControls = this._savedProps.hasControls),
        (this.borderColor = this._savedProps.borderColor),
        (this.selectable = this._savedProps.selectable),
        (this.lockMovementX = this._savedProps.lockMovementX),
        (this.lockMovementY = this._savedProps.lockMovementY),
        this.canvas &&
          ((this.canvas.defaultCursor = this._savedProps.defaultCursor),
          (this.canvas.moveCursor = this._savedProps.moveCursor)));
    },
    exitEditing: function () {
      var t = this._textBeforeEdit !== this.text,
        e = this.hiddenTextarea;
      return (
        (this.selected = !1),
        (this.isEditing = !1),
        (this.selectionEnd = this.selectionStart),
        e && (e.blur && e.blur(), e.parentNode && e.parentNode.removeChild(e)),
        (this.hiddenTextarea = null),
        this.abortCursorAnimation(),
        this._restoreEditingProps(),
        (this._currentCursorOpacity = 0),
        this._shouldClearDimensionCache() &&
          (this.initDimensions(), this.setCoords()),
        this.fire("editing:exited"),
        t && this.fire("modified"),
        this.canvas &&
          (this.canvas.off("mouse:move", this.mouseMoveHandler),
          this.canvas.fire("text:editing:exited", { target: this }),
          t && this.canvas.fire("object:modified", { target: this })),
        this
      );
    },
    _removeExtraneousStyles: function () {
      for (var t in this.styles) this._textLines[t] || delete this.styles[t];
    },
    removeStyleFromTo: function (t, e) {
      var i,
        r,
        n = this.get2DCursorLocation(t, !0),
        o = this.get2DCursorLocation(e, !0),
        s = n.lineIndex,
        a = n.charIndex,
        c = o.lineIndex,
        h = o.charIndex;
      if (s !== c) {
        if (this.styles[s])
          for (i = a; i < this._unwrappedTextLines[s].length; i++)
            delete this.styles[s][i];
        if (this.styles[c])
          for (i = h; i < this._unwrappedTextLines[c].length; i++)
            (r = this.styles[c][i]),
              r &&
                (this.styles[s] || (this.styles[s] = {}),
                (this.styles[s][a + i - h] = r));
        for (i = s + 1; c >= i; i++) delete this.styles[i];
        this.shiftLineStyles(c, s - c);
      } else if (this.styles[s]) {
        r = this.styles[s];
        var l,
          u,
          f = h - a;
        for (i = a; h > i; i++) delete r[i];
        for (u in this.styles[s])
          (l = parseInt(u, 10)), l >= h && ((r[l - f] = r[u]), delete r[u]);
      }
    },
    shiftLineStyles: function (e, i) {
      var r = t(this.styles);
      for (var n in this.styles) {
        var o = parseInt(n, 10);
        o > e &&
          ((this.styles[o + i] = r[o]), r[o - i] || delete this.styles[o]);
      }
    },
    restartCursorIfNeeded: function () {
      (!this._currentTickState ||
        this._currentTickState.isAborted ||
        !this._currentTickCompleteState ||
        this._currentTickCompleteState.isAborted) &&
        this.initDelayedCursor();
    },
    insertNewlineStyleObject: function (e, i, r, n) {
      var o,
        s = {},
        a = !1,
        c = this._unwrappedTextLines[e].length === i;
      r || (r = 1),
        this.shiftLineStyles(e, r),
        this.styles[e] && (o = this.styles[e][0 === i ? i : i - 1]);
      for (var h in this.styles[e]) {
        var l = parseInt(h, 10);
        l >= i &&
          ((a = !0),
          (s[l - i] = this.styles[e][h]),
          (c && 0 === i) || delete this.styles[e][h]);
      }
      var u = !1;
      for (a && !c && ((this.styles[e + r] = s), (u = !0)), u && r--; r > 0; )
        n && n[r - 1]
          ? (this.styles[e + r] = { 0: t(n[r - 1]) })
          : o
          ? (this.styles[e + r] = { 0: t(o) })
          : delete this.styles[e + r],
          r--;
      this._forceClearCache = !0;
    },
    insertCharStyleObject: function (e, i, r, n) {
      this.styles || (this.styles = {});
      var o = this.styles[e],
        s = o ? t(o) : {};
      r || (r = 1);
      for (var a in s) {
        var c = parseInt(a, 10);
        c >= i && ((o[c + r] = s[c]), s[c - r] || delete o[c]);
      }
      if (((this._forceClearCache = !0), n))
        for (; r--; )
          Object.keys(n[r]).length &&
            (this.styles[e] || (this.styles[e] = {}),
            (this.styles[e][i + r] = t(n[r])));
      else if (o)
        for (var h = o[i ? i - 1 : 1]; h && r--; ) this.styles[e][i + r] = t(h);
    },
    insertNewStyleBlock: function (t, e, i) {
      for (
        var r = this.get2DCursorLocation(e, !0), n = [0], o = 0, s = 0;
        s < t.length;
        s++
      )
        "\n" === t[s] ? (o++, (n[o] = 0)) : n[o]++;
      n[0] > 0 &&
        (this.insertCharStyleObject(r.lineIndex, r.charIndex, n[0], i),
        (i = i && i.slice(n[0] + 1))),
        o && this.insertNewlineStyleObject(r.lineIndex, r.charIndex + n[0], o);
      for (var s = 1; o > s; s++)
        n[s] > 0
          ? this.insertCharStyleObject(r.lineIndex + s, 0, n[s], i)
          : i &&
            this.styles[r.lineIndex + s] &&
            i[0] &&
            (this.styles[r.lineIndex + s][0] = i[0]),
          (i = i && i.slice(n[s] + 1));
      n[s] > 0 && this.insertCharStyleObject(r.lineIndex + s, 0, n[s], i);
    },
    setSelectionStartEndWithShift: function (t, e, i) {
      t >= i
        ? (e === t
            ? (this._selectionDirection = "left")
            : "right" === this._selectionDirection &&
              ((this._selectionDirection = "left"), (this.selectionEnd = t)),
          (this.selectionStart = i))
        : i > t && e > i
        ? "right" === this._selectionDirection
          ? (this.selectionEnd = i)
          : (this.selectionStart = i)
        : (e === t
            ? (this._selectionDirection = "right")
            : "left" === this._selectionDirection &&
              ((this._selectionDirection = "right"), (this.selectionStart = e)),
          (this.selectionEnd = i));
    },
    setSelectionInBoundaries: function () {
      var t = this.text.length;
      this.selectionStart > t
        ? (this.selectionStart = t)
        : this.selectionStart < 0 && (this.selectionStart = 0),
        this.selectionEnd > t
          ? (this.selectionEnd = t)
          : this.selectionEnd < 0 && (this.selectionEnd = 0);
    },
  });
})();
fabric.util.object.extend(fabric.IText.prototype, {
  initDoubleClickSimulation: function () {
    (this.__lastClickTime = +new Date()),
      (this.__lastLastClickTime = +new Date()),
      (this.__lastPointer = {}),
      this.on("mousedown", this.onMouseDown);
  },
  onMouseDown: function (t) {
    if (this.canvas) {
      this.__newClickTime = +new Date();
      var e = t.pointer;
      this.isTripleClick(e) &&
        (this.fire("tripleclick", t), this._stopEvent(t.e)),
        (this.__lastLastClickTime = this.__lastClickTime),
        (this.__lastClickTime = this.__newClickTime),
        (this.__lastPointer = e),
        (this.__lastIsEditing = this.isEditing),
        (this.__lastSelected = this.selected);
    }
  },
  isTripleClick: function (t) {
    return (
      this.__newClickTime - this.__lastClickTime < 500 &&
      this.__lastClickTime - this.__lastLastClickTime < 500 &&
      this.__lastPointer.x === t.x &&
      this.__lastPointer.y === t.y
    );
  },
  _stopEvent: function (t) {
    t.preventDefault && t.preventDefault(),
      t.stopPropagation && t.stopPropagation();
  },
  initCursorSelectionHandlers: function () {
    this.initMousedownHandler(), this.initMouseupHandler(), this.initClicks();
  },
  doubleClickHandler: function (t) {
    this.isEditing && this.selectWord(this.getSelectionStartFromPointer(t.e));
  },
  tripleClickHandler: function (t) {
    this.isEditing && this.selectLine(this.getSelectionStartFromPointer(t.e));
  },
  initClicks: function () {
    this.on("mousedblclick", this.doubleClickHandler),
      this.on("tripleclick", this.tripleClickHandler);
  },
  _mouseDownHandler: function (t) {
    !this.canvas ||
      !this.editable ||
      (t.e.button && 1 !== t.e.button) ||
      ((this.__isMousedown = !0),
      this.selected &&
        ((this.inCompositionMode = !1), this.setCursorByClick(t.e)),
      this.isEditing &&
        ((this.__selectionStartOnMouseDown = this.selectionStart),
        this.selectionStart === this.selectionEnd &&
          this.abortCursorAnimation(),
        this.renderCursorOrSelection()));
  },
  _mouseDownHandlerBefore: function (t) {
    !this.canvas ||
      !this.editable ||
      (t.e.button && 1 !== t.e.button) ||
      (this.selected = this === this.canvas._activeObject);
  },
  initMousedownHandler: function () {
    this.on("mousedown", this._mouseDownHandler),
      this.on("mousedown:before", this._mouseDownHandlerBefore);
  },
  initMouseupHandler: function () {
    this.on("mouseup", this.mouseUpHandler);
  },
  mouseUpHandler: function (t) {
    if (
      ((this.__isMousedown = !1),
      !(
        !this.editable ||
        this.group ||
        (t.transform && t.transform.actionPerformed) ||
        (t.e.button && 1 !== t.e.button)
      ))
    ) {
      if (this.canvas) {
        var e = this.canvas._activeObject;
        if (e && e !== this) return;
      }
      this.__lastSelected && !this.__corner
        ? ((this.selected = !1),
          (this.__lastSelected = !1),
          this.enterEditing(t.e),
          this.selectionStart === this.selectionEnd
            ? this.initDelayedCursor(!0)
            : this.renderCursorOrSelection())
        : (this.selected = !0);
    }
  },
  setCursorByClick: function (t) {
    var e = this.getSelectionStartFromPointer(t),
      i = this.selectionStart,
      r = this.selectionEnd;
    t.shiftKey
      ? this.setSelectionStartEndWithShift(i, r, e)
      : ((this.selectionStart = e), (this.selectionEnd = e)),
      this.isEditing && (this._fireSelectionChanged(), this._updateTextarea());
  },
  getSelectionStartFromPointer: function (t) {
    for (
      var e,
        i,
        r = this.getLocalPointer(t),
        n = 0,
        o = 0,
        s = 0,
        a = 0,
        c = 0,
        h = 0,
        l = this._textLines.length;
      l > h && s <= r.y;
      h++
    )
      (s += this.getHeightOfLine(h) * this.scaleY),
        (c = h),
        h > 0 &&
          (a +=
            this._textLines[h - 1].length + this.missingNewlineOffset(h - 1));
    (e = this._getLineLeftOffset(c)),
      (o = e * this.scaleX),
      (i = this._textLines[c]),
      "rtl" === this.direction && (r.x = this.width * this.scaleX - r.x + o);
    for (
      var u = 0, f = i.length;
      f > u &&
      ((n = o),
      (o += this.__charBounds[c][u].kernedWidth * this.scaleX),
      o <= r.x);
      u++
    )
      a++;
    return this._getNewSelectionStartFromOffset(r, n, o, a, f);
  },
  _getNewSelectionStartFromOffset: function (t, e, i, r, n) {
    var o = t.x - e,
      s = i - t.x,
      a = s > o || 0 > s ? 0 : 1,
      c = r + a;
    return (
      this.flipX && (c = n - c),
      c > this._text.length && (c = this._text.length),
      c
    );
  },
});
fabric.util.object.extend(fabric.IText.prototype, {
  initHiddenTextarea: function () {
    (this.hiddenTextarea = fabric.document.createElement("textarea")),
      this.hiddenTextarea.setAttribute("autocapitalize", "off"),
      this.hiddenTextarea.setAttribute("autocorrect", "off"),
      this.hiddenTextarea.setAttribute("autocomplete", "off"),
      this.hiddenTextarea.setAttribute("spellcheck", "false"),
      this.hiddenTextarea.setAttribute("data-fabric-hiddentextarea", ""),
      this.hiddenTextarea.setAttribute("wrap", "off");
    var t = this._calcTextareaPosition();
    (this.hiddenTextarea.style.cssText =
      "position: absolute; top: " +
      t.top +
      "; left: " +
      t.left +
      "; z-index: -999; opacity: 0; width: 1px; height: 1px; font-size: 1px; paddingｰtop: " +
      t.fontSize +
      ";"),
      this.hiddenTextareaContainer
        ? this.hiddenTextareaContainer.appendChild(this.hiddenTextarea)
        : fabric.document.body.appendChild(this.hiddenTextarea),
      fabric.util.addListener(
        this.hiddenTextarea,
        "keydown",
        this.onKeyDown.bind(this)
      ),
      fabric.util.addListener(
        this.hiddenTextarea,
        "keyup",
        this.onKeyUp.bind(this)
      ),
      fabric.util.addListener(
        this.hiddenTextarea,
        "input",
        this.onInput.bind(this)
      ),
      fabric.util.addListener(
        this.hiddenTextarea,
        "copy",
        this.copy.bind(this)
      ),
      fabric.util.addListener(this.hiddenTextarea, "cut", this.copy.bind(this)),
      fabric.util.addListener(
        this.hiddenTextarea,
        "paste",
        this.paste.bind(this)
      ),
      fabric.util.addListener(
        this.hiddenTextarea,
        "compositionstart",
        this.onCompositionStart.bind(this)
      ),
      fabric.util.addListener(
        this.hiddenTextarea,
        "compositionupdate",
        this.onCompositionUpdate.bind(this)
      ),
      fabric.util.addListener(
        this.hiddenTextarea,
        "compositionend",
        this.onCompositionEnd.bind(this)
      ),
      !this._clickHandlerInitialized &&
        this.canvas &&
        (fabric.util.addListener(
          this.canvas.upperCanvasEl,
          "click",
          this.onClick.bind(this)
        ),
        (this._clickHandlerInitialized = !0));
  },
  keysMap: {
    9: "exitEditing",
    27: "exitEditing",
    33: "moveCursorUp",
    34: "moveCursorDown",
    35: "moveCursorRight",
    36: "moveCursorLeft",
    37: "moveCursorLeft",
    38: "moveCursorUp",
    39: "moveCursorRight",
    40: "moveCursorDown",
  },
  keysMapRtl: {
    9: "exitEditing",
    27: "exitEditing",
    33: "moveCursorUp",
    34: "moveCursorDown",
    35: "moveCursorLeft",
    36: "moveCursorRight",
    37: "moveCursorRight",
    38: "moveCursorUp",
    39: "moveCursorLeft",
    40: "moveCursorDown",
  },
  ctrlKeysMapUp: { 67: "copy", 88: "cut" },
  ctrlKeysMapDown: { 65: "selectAll" },
  onClick: function () {
    this.hiddenTextarea && this.hiddenTextarea.focus();
  },
  onKeyDown: function (t) {
    if (this.isEditing) {
      var e = "rtl" === this.direction ? this.keysMapRtl : this.keysMap;
      if (t.keyCode in e) this[e[t.keyCode]](t);
      else {
        if (!(t.keyCode in this.ctrlKeysMapDown && (t.ctrlKey || t.metaKey)))
          return;
        this[this.ctrlKeysMapDown[t.keyCode]](t);
      }
      t.stopImmediatePropagation(),
        t.preventDefault(),
        t.keyCode >= 33 && t.keyCode <= 40
          ? ((this.inCompositionMode = !1),
            this.clearContextTop(),
            this.renderCursorOrSelection())
          : this.canvas && this.canvas.requestRenderAll();
    }
  },
  onKeyUp: function (t) {
    return !this.isEditing || this._copyDone || this.inCompositionMode
      ? void (this._copyDone = !1)
      : void (
          t.keyCode in this.ctrlKeysMapUp &&
          (t.ctrlKey || t.metaKey) &&
          (this[this.ctrlKeysMapUp[t.keyCode]](t),
          t.stopImmediatePropagation(),
          t.preventDefault(),
          this.canvas && this.canvas.requestRenderAll())
        );
  },
  onInput: function (t) {
    var e = this.fromPaste;
    if (((this.fromPaste = !1), t && t.stopPropagation(), this.isEditing)) {
      var i,
        r,
        n,
        o,
        s,
        a = this._splitTextIntoLines(this.hiddenTextarea.value).graphemeText,
        c = this._text.length,
        h = a.length,
        l = h - c,
        u = this.selectionStart,
        f = this.selectionEnd,
        d = u !== f;
      if ("" === this.hiddenTextarea.value)
        return (
          (this.styles = {}),
          this.updateFromTextArea(),
          this.fire("changed"),
          void (
            this.canvas &&
            (this.canvas.fire("text:changed", { target: this }),
            this.canvas.requestRenderAll())
          )
        );
      var g = this.fromStringToGraphemeSelection(
          this.hiddenTextarea.selectionStart,
          this.hiddenTextarea.selectionEnd,
          this.hiddenTextarea.value
        ),
        p = u > g.selectionStart;
      d
        ? ((i = this._text.slice(u, f)), (l += f - u))
        : c > h &&
          (i = p ? this._text.slice(f + l, f) : this._text.slice(u, u - l)),
        (r = a.slice(g.selectionEnd - l, g.selectionEnd)),
        i &&
          i.length &&
          (r.length &&
            ((n = this.getSelectionStyles(u, u + 1, !1)),
            (n = r.map(function () {
              return n[0];
            }))),
          d
            ? ((o = u), (s = f))
            : p
            ? ((o = f - i.length), (s = f))
            : ((o = f), (s = f + i.length)),
          this.removeStyleFromTo(o, s)),
        r.length &&
          (e &&
            r.join("") === fabric.copiedText &&
            !fabric.disableStyleCopyPaste &&
            (n = fabric.copiedTextStyle),
          this.insertNewStyleBlock(r, u, n)),
        this.updateFromTextArea(),
        this.fire("changed"),
        this.canvas &&
          (this.canvas.fire("text:changed", { target: this }),
          this.canvas.requestRenderAll());
    }
  },
  onCompositionStart: function () {
    this.inCompositionMode = !0;
  },
  onCompositionEnd: function () {
    this.inCompositionMode = !1;
  },
  onCompositionUpdate: function (t) {
    (this.compositionStart = t.target.selectionStart),
      (this.compositionEnd = t.target.selectionEnd),
      this.updateTextareaPosition();
  },
  copy: function () {
    this.selectionStart !== this.selectionEnd &&
      ((fabric.copiedText = this.getSelectedText()),
      (fabric.copiedTextStyle = fabric.disableStyleCopyPaste
        ? null
        : this.getSelectionStyles(this.selectionStart, this.selectionEnd, !0)),
      (this._copyDone = !0));
  },
  paste: function () {
    this.fromPaste = !0;
  },
  _getClipboardData: function (t) {
    return (t && t.clipboardData) || fabric.window.clipboardData;
  },
  _getWidthBeforeCursor: function (t, e) {
    var i,
      r = this._getLineLeftOffset(t);
    return (
      e > 0 && ((i = this.__charBounds[t][e - 1]), (r += i.left + i.width)), r
    );
  },
  getDownCursorOffset: function (t, e) {
    var i = this._getSelectionForOffset(t, e),
      r = this.get2DCursorLocation(i),
      n = r.lineIndex;
    if (n === this._textLines.length - 1 || t.metaKey || 34 === t.keyCode)
      return this._text.length - i;
    var o = r.charIndex,
      s = this._getWidthBeforeCursor(n, o),
      a = this._getIndexOnLine(n + 1, s),
      c = this._textLines[n].slice(o);
    return c.length + a + 1 + this.missingNewlineOffset(n);
  },
  _getSelectionForOffset: function (t, e) {
    return t.shiftKey && this.selectionStart !== this.selectionEnd && e
      ? this.selectionEnd
      : this.selectionStart;
  },
  getUpCursorOffset: function (t, e) {
    var i = this._getSelectionForOffset(t, e),
      r = this.get2DCursorLocation(i),
      n = r.lineIndex;
    if (0 === n || t.metaKey || 33 === t.keyCode) return -i;
    var o = r.charIndex,
      s = this._getWidthBeforeCursor(n, o),
      a = this._getIndexOnLine(n - 1, s),
      c = this._textLines[n].slice(0, o),
      h = this.missingNewlineOffset(n - 1);
    return -this._textLines[n - 1].length + a - c.length + (1 - h);
  },
  _getIndexOnLine: function (t, e) {
    for (
      var i,
        r,
        n = this._textLines[t],
        o = this._getLineLeftOffset(t),
        s = o,
        a = 0,
        c = 0,
        h = n.length;
      h > c;
      c++
    )
      if (((i = this.__charBounds[t][c].width), (s += i), s > e)) {
        r = !0;
        var l = s - i,
          u = s,
          f = Math.abs(l - e),
          d = Math.abs(u - e);
        a = f > d ? c : c - 1;
        break;
      }
    return r || (a = n.length - 1), a;
  },
  moveCursorDown: function (t) {
    (this.selectionStart >= this._text.length &&
      this.selectionEnd >= this._text.length) ||
      this._moveCursorUpOrDown("Down", t);
  },
  moveCursorUp: function (t) {
    (0 !== this.selectionStart || 0 !== this.selectionEnd) &&
      this._moveCursorUpOrDown("Up", t);
  },
  _moveCursorUpOrDown: function (t, e) {
    var i = "get" + t + "CursorOffset",
      r = this[i](e, "right" === this._selectionDirection);
    e.shiftKey ? this.moveCursorWithShift(r) : this.moveCursorWithoutShift(r),
      0 !== r &&
        (this.setSelectionInBoundaries(),
        this.abortCursorAnimation(),
        (this._currentCursorOpacity = 1),
        this.initDelayedCursor(),
        this._fireSelectionChanged(),
        this._updateTextarea());
  },
  moveCursorWithShift: function (t) {
    var e =
      "left" === this._selectionDirection
        ? this.selectionStart + t
        : this.selectionEnd + t;
    return (
      this.setSelectionStartEndWithShift(
        this.selectionStart,
        this.selectionEnd,
        e
      ),
      0 !== t
    );
  },
  moveCursorWithoutShift: function (t) {
    return (
      0 > t
        ? ((this.selectionStart += t),
          (this.selectionEnd = this.selectionStart))
        : ((this.selectionEnd += t), (this.selectionStart = this.selectionEnd)),
      0 !== t
    );
  },
  moveCursorLeft: function (t) {
    (0 !== this.selectionStart || 0 !== this.selectionEnd) &&
      this._moveCursorLeftOrRight("Left", t);
  },
  _move: function (t, e, i) {
    var r;
    if (t.altKey) r = this["findWordBoundary" + i](this[e]);
    else {
      if (!t.metaKey && 35 !== t.keyCode && 36 !== t.keyCode)
        return (this[e] += "Left" === i ? -1 : 1), !0;
      r = this["findLineBoundary" + i](this[e]);
    }
    return void 0 !== typeof r && this[e] !== r ? ((this[e] = r), !0) : void 0;
  },
  _moveLeft: function (t, e) {
    return this._move(t, e, "Left");
  },
  _moveRight: function (t, e) {
    return this._move(t, e, "Right");
  },
  moveCursorLeftWithoutShift: function (t) {
    var e = !0;
    return (
      (this._selectionDirection = "left"),
      this.selectionEnd === this.selectionStart &&
        0 !== this.selectionStart &&
        (e = this._moveLeft(t, "selectionStart")),
      (this.selectionEnd = this.selectionStart),
      e
    );
  },
  moveCursorLeftWithShift: function (t) {
    return "right" === this._selectionDirection &&
      this.selectionStart !== this.selectionEnd
      ? this._moveLeft(t, "selectionEnd")
      : 0 !== this.selectionStart
      ? ((this._selectionDirection = "left"),
        this._moveLeft(t, "selectionStart"))
      : void 0;
  },
  moveCursorRight: function (t) {
    (this.selectionStart >= this._text.length &&
      this.selectionEnd >= this._text.length) ||
      this._moveCursorLeftOrRight("Right", t);
  },
  _moveCursorLeftOrRight: function (t, e) {
    var i = "moveCursor" + t + "With";
    (this._currentCursorOpacity = 1),
      (i += e.shiftKey ? "Shift" : "outShift"),
      this[i](e) &&
        (this.abortCursorAnimation(),
        this.initDelayedCursor(),
        this._fireSelectionChanged(),
        this._updateTextarea());
  },
  moveCursorRightWithShift: function (t) {
    return "left" === this._selectionDirection &&
      this.selectionStart !== this.selectionEnd
      ? this._moveRight(t, "selectionStart")
      : this.selectionEnd !== this._text.length
      ? ((this._selectionDirection = "right"),
        this._moveRight(t, "selectionEnd"))
      : void 0;
  },
  moveCursorRightWithoutShift: function (t) {
    var e = !0;
    return (
      (this._selectionDirection = "right"),
      this.selectionStart === this.selectionEnd
        ? ((e = this._moveRight(t, "selectionStart")),
          (this.selectionEnd = this.selectionStart))
        : (this.selectionStart = this.selectionEnd),
      e
    );
  },
  removeChars: function (t, e) {
    "undefined" == typeof e && (e = t + 1),
      this.removeStyleFromTo(t, e),
      this._text.splice(t, e - t),
      (this.text = this._text.join("")),
      this.set("dirty", !0),
      this._shouldClearDimensionCache() &&
        (this.initDimensions(), this.setCoords()),
      this._removeExtraneousStyles();
  },
  insertChars: function (t, e, i, r) {
    "undefined" == typeof r && (r = i), r > i && this.removeStyleFromTo(i, r);
    var n = fabric.util.string.graphemeSplit(t);
    this.insertNewStyleBlock(n, i, e),
      (this._text = [].concat(this._text.slice(0, i), n, this._text.slice(r))),
      (this.text = this._text.join("")),
      this.set("dirty", !0),
      this._shouldClearDimensionCache() &&
        (this.initDimensions(), this.setCoords()),
      this._removeExtraneousStyles();
  },
});
!(function () {
  var t = fabric.util.toFixed,
    e = /  +/g;
  fabric.util.object.extend(fabric.Text.prototype, {
    _toSVG: function () {
      var t = this._getSVGLeftTopOffsets(),
        e = this._getSVGTextAndBg(t.textTop, t.textLeft);
      return this._wrapSVGTextAndBg(e);
    },
    toSVG: function (t) {
      return this._createBaseSVGMarkup(this._toSVG(), {
        reviver: t,
        noStyle: !0,
        withShadow: !0,
      });
    },
    _getSVGLeftTopOffsets: function () {
      return {
        textLeft: -this.width / 2,
        textTop: -this.height / 2,
        lineTop: this.getHeightOfLine(0),
      };
    },
    _wrapSVGTextAndBg: function (t) {
      var e = !0,
        i = this.getSvgTextDecoration(this);
      return [
        t.textBgRects.join(""),
        '		<text xml:space="preserve" ',
        this.fontFamily
          ? 'font-family="' + this.fontFamily.replace(/"/g, "'") + '" '
          : "",
        this.fontSize ? 'font-size="' + this.fontSize + '" ' : "",
        this.fontStyle ? 'font-style="' + this.fontStyle + '" ' : "",
        this.fontWeight ? 'font-weight="' + this.fontWeight + '" ' : "",
        i ? 'text-decoration="' + i + '" ' : "",
        'style="',
        this.getSvgStyles(e),
        '"',
        this.addPaintOrder(),
        " >",
        t.textSpans.join(""),
        "</text>\n",
      ];
    },
    _getSVGTextAndBg: function (t, e) {
      var i,
        r = [],
        n = [],
        o = t;
      this._setSVGBg(n);
      for (var s = 0, a = this._textLines.length; a > s; s++)
        (i = this._getLineLeftOffset(s)),
          (this.textBackgroundColor ||
            this.styleHas("textBackgroundColor", s)) &&
            this._setSVGTextLineBg(n, s, e + i, o),
          this._setSVGTextLineText(r, s, e + i, o),
          (o += this.getHeightOfLine(s));
      return { textSpans: r, textBgRects: n };
    },
    _createTextCharSpan: function (i, r, n, o) {
      var s = i !== i.trim() || i.match(e),
        a = this.getSvgSpanStyles(r, s),
        c = a ? 'style="' + a + '"' : "",
        h = r.deltaY,
        l = "",
        u = fabric.Object.NUM_FRACTION_DIGITS;
      return (
        h && (l = ' dy="' + t(h, u) + '" '),
        [
          '<tspan x="',
          t(n, u),
          '" y="',
          t(o, u),
          '" ',
          l,
          c,
          ">",
          fabric.util.string.escapeXml(i),
          "</tspan>",
        ].join("")
      );
    },
    _setSVGTextLineText: function (t, e, i, r) {
      var n,
        o,
        s,
        a,
        c,
        h = this.getHeightOfLine(e),
        l = -1 !== this.textAlign.indexOf("justify"),
        u = "",
        f = 0,
        d = this._textLines[e];
      r += (h * (1 - this._fontSizeFraction)) / this.lineHeight;
      for (var g = 0, p = d.length - 1; p >= g; g++)
        (c = g === p || this.charSpacing),
          (u += d[g]),
          (s = this.__charBounds[e][g]),
          0 === f
            ? ((i += s.kernedWidth - s.width), (f += s.width))
            : (f += s.kernedWidth),
          l && !c && this._reSpaceAndTab.test(d[g]) && (c = !0),
          c ||
            ((n = n || this.getCompleteStyleDeclaration(e, g)),
            (o = this.getCompleteStyleDeclaration(e, g + 1)),
            (c = fabric.util.hasStyleChanged(n, o, !0))),
          c &&
            ((a = this._getStyleDeclaration(e, g) || {}),
            t.push(this._createTextCharSpan(u, a, i, r)),
            (u = ""),
            (n = o),
            (i += f),
            (f = 0));
    },
    _pushTextBgRect: function (e, i, r, n, o, s) {
      var a = fabric.Object.NUM_FRACTION_DIGITS;
      e.push(
        "		<rect ",
        this._getFillAttributes(i),
        ' x="',
        t(r, a),
        '" y="',
        t(n, a),
        '" width="',
        t(o, a),
        '" height="',
        t(s, a),
        '"></rect>\n'
      );
    },
    _setSVGTextLineBg: function (t, e, i, r) {
      for (
        var n,
          o,
          s = this._textLines[e],
          a = this.getHeightOfLine(e) / this.lineHeight,
          c = 0,
          h = 0,
          l = this.getValueOfPropertyAt(e, 0, "textBackgroundColor"),
          u = 0,
          f = s.length;
        f > u;
        u++
      )
        (n = this.__charBounds[e][u]),
          (o = this.getValueOfPropertyAt(e, u, "textBackgroundColor")),
          o !== l
            ? (l && this._pushTextBgRect(t, l, i + h, r, c, a),
              (h = n.left),
              (c = n.width),
              (l = o))
            : (c += n.kernedWidth);
      o && this._pushTextBgRect(t, o, i + h, r, c, a);
    },
    _getFillAttributes: function (t) {
      var e = t && "string" == typeof t ? new fabric.Color(t) : "";
      return e && e.getSource() && 1 !== e.getAlpha()
        ? 'opacity="' + e.getAlpha() + '" fill="' + e.setAlpha(1).toRgb() + '"'
        : 'fill="' + t + '"';
    },
    _getSVGLineTopOffset: function (t) {
      for (var e = 0, i = 0, r = 0; t > r; r++) e += this.getHeightOfLine(r);
      return (
        (i = this.getHeightOfLine(r)),
        {
          lineTop: e,
          offset:
            ((this._fontSizeMult - this._fontSizeFraction) * i) /
            (this.lineHeight * this._fontSizeMult),
        }
      );
    },
    getSvgStyles: function (t) {
      var e = fabric.Object.prototype.getSvgStyles.call(this, t);
      return e + " white-space: pre;";
    },
  });
})();
!(function (t) {
  "use strict";
  var e = t.fabric || (t.fabric = {});
  (e.Textbox = e.util.createClass(e.IText, e.Observable, {
    type: "textbox",
    minWidth: 20,
    dynamicMinWidth: 2,
    __cachedLines: null,
    lockScalingFlip: !0,
    noScaleCache: !1,
    _dimensionAffectingProps:
      e.Text.prototype._dimensionAffectingProps.concat("width"),
    _wordJoiners: /[ \t\r]/,
    splitByGrapheme: !1,
    initDimensions: function () {
      this.__skipDimension ||
        (this.isEditing && this.initDelayedCursor(),
        this.clearContextTop(),
        this._clearCache(),
        (this.dynamicMinWidth = 0),
        (this._styleMap = this._generateStyleMap(this._splitText())),
        this.dynamicMinWidth > this.width &&
          this._set("width", this.dynamicMinWidth),
        -1 !== this.textAlign.indexOf("justify") && this.enlargeSpaces(),
        (this.height = this.calcTextHeight()),
        this.saveState({ propertySet: "_dimensionAffectingProps" }));
    },
    _generateStyleMap: function (t) {
      for (
        var e = 0, i = 0, r = 0, n = {}, s = 0;
        s < t.graphemeLines.length;
        s++
      )
        "\n" === t.graphemeText[r] && s > 0
          ? ((i = 0), r++, e++)
          : !this.splitByGrapheme &&
            this._reSpaceAndTab.test(t.graphemeText[r]) &&
            s > 0 &&
            (i++, r++),
          (n[s] = { line: e, offset: i }),
          (r += t.graphemeLines[s].length),
          (i += t.graphemeLines[s].length);
      return n;
    },
    styleHas: function (t, i) {
      if (this._styleMap && !this.isWrapping) {
        var r = this._styleMap[i];
        r && (i = r.line);
      }
      return e.Text.prototype.styleHas.call(this, t, i);
    },
    isEmptyStyles: function (t) {
      if (!this.styles) return !0;
      var e,
        i,
        r = 0,
        n = t + 1,
        s = !1,
        o = this._styleMap[t],
        a = this._styleMap[t + 1];
      o && ((t = o.line), (r = o.offset)),
        a && ((n = a.line), (s = n === t), (e = a.offset)),
        (i = "undefined" == typeof t ? this.styles : { line: this.styles[t] });
      for (var c in i)
        for (var h in i[c])
          if (h >= r && (!s || e > h)) for (var l in i[c][h]) return !1;
      return !0;
    },
    _getStyleDeclaration: function (t, e) {
      if (this._styleMap && !this.isWrapping) {
        var i = this._styleMap[t];
        if (!i) return null;
        (t = i.line), (e = i.offset + e);
      }
      return this.callSuper("_getStyleDeclaration", t, e);
    },
    _setStyleDeclaration: function (t, e, i) {
      var r = this._styleMap[t];
      (t = r.line), (e = r.offset + e), (this.styles[t][e] = i);
    },
    _deleteStyleDeclaration: function (t, e) {
      var i = this._styleMap[t];
      (t = i.line), (e = i.offset + e), delete this.styles[t][e];
    },
    _getLineStyle: function (t) {
      var e = this._styleMap[t];
      return !!this.styles[e.line];
    },
    _setLineStyle: function (t) {
      var e = this._styleMap[t];
      this.styles[e.line] = {};
    },
    _wrapText: function (t, e) {
      var i,
        r = [];
      for (this.isWrapping = !0, i = 0; i < t.length; i++)
        r = r.concat(this._wrapLine(t[i], i, e));
      return (this.isWrapping = !1), r;
    },
    _measureWord: function (t, e, i) {
      var r,
        n = 0,
        s = !0;
      i = i || 0;
      for (var o = 0, a = t.length; a > o; o++) {
        var c = this._getGraphemeBox(t[o], e, o + i, r, s);
        (n += c.kernedWidth), (r = t[o]);
      }
      return n;
    },
    _wrapLine: function (t, i, r, n) {
      var s = 0,
        o = this.splitByGrapheme,
        a = [],
        c = [],
        h = o ? e.util.string.graphemeSplit(t) : t.split(this._wordJoiners),
        l = "",
        u = 0,
        f = o ? "" : " ",
        d = 0,
        g = 0,
        p = 0,
        v = !0,
        m = this._getWidthOfCharSpacing(),
        n = n || 0;
      0 === h.length && h.push([]), (r -= n);
      for (var b = 0; b < h.length; b++)
        (l = o ? h[b] : e.util.string.graphemeSplit(h[b])),
          (d = this._measureWord(l, i, u)),
          (u += l.length),
          (s += g + d - m),
          s > r && !v ? (a.push(c), (c = []), (s = d), (v = !0)) : (s += m),
          v || o || c.push(f),
          (c = c.concat(l)),
          (g = o ? 0 : this._measureWord([f], i, u)),
          u++,
          (v = !1),
          d > p && (p = d);
      return (
        b && a.push(c),
        p + n > this.dynamicMinWidth && (this.dynamicMinWidth = p - m + n),
        a
      );
    },
    isEndOfWrapping: function (t) {
      return this._styleMap[t + 1]
        ? this._styleMap[t + 1].line !== this._styleMap[t].line
          ? !0
          : !1
        : !0;
    },
    missingNewlineOffset: function (t) {
      return this.splitByGrapheme ? (this.isEndOfWrapping(t) ? 1 : 0) : 1;
    },
    _splitTextIntoLines: function (t) {
      for (
        var i = e.Text.prototype._splitTextIntoLines.call(this, t),
          r = this._wrapText(i.lines, this.width),
          n = new Array(r.length),
          s = 0;
        s < r.length;
        s++
      )
        n[s] = r[s].join("");
      return (i.lines = n), (i.graphemeLines = r), i;
    },
    getMinWidth: function () {
      return Math.max(this.minWidth, this.dynamicMinWidth);
    },
    _removeExtraneousStyles: function () {
      var t = {};
      for (var e in this._styleMap)
        this._textLines[e] && (t[this._styleMap[e].line] = 1);
      for (var e in this.styles) t[e] || delete this.styles[e];
    },
    toObject: function (t) {
      return this.callSuper(
        "toObject",
        ["minWidth", "splitByGrapheme"].concat(t)
      );
    },
  })),
    (e.Textbox.fromObject = function (t, i) {
      return (
        (t.styles = e.util.stylesFromArray(t.styles, t.text)),
        e.Object._fromObject("Textbox", t, i, "text")
      );
    });
})("undefined" != typeof exports ? exports : this);
!(function () {
  var t = fabric.controlsUtils,
    e = t.scaleSkewCursorStyleHandler,
    i = t.scaleCursorStyleHandler,
    r = t.scalingEqually,
    n = t.scalingYOrSkewingX,
    s = t.scalingXOrSkewingY,
    o = t.scaleOrSkewActionName,
    a = fabric.Object.prototype.controls;
  if (
    ((a.ml = new fabric.Control({
      x: -0.5,
      y: 0,
      cursorStyleHandler: e,
      actionHandler: s,
      getActionName: o,
    })),
    (a.mr = new fabric.Control({
      x: 0.5,
      y: 0,
      cursorStyleHandler: e,
      actionHandler: s,
      getActionName: o,
    })),
    (a.mb = new fabric.Control({
      x: 0,
      y: 0.5,
      cursorStyleHandler: e,
      actionHandler: n,
      getActionName: o,
    })),
    (a.mt = new fabric.Control({
      x: 0,
      y: -0.5,
      cursorStyleHandler: e,
      actionHandler: n,
      getActionName: o,
    })),
    (a.tl = new fabric.Control({
      x: -0.5,
      y: -0.5,
      cursorStyleHandler: i,
      actionHandler: r,
    })),
    (a.tr = new fabric.Control({
      x: 0.5,
      y: -0.5,
      cursorStyleHandler: i,
      actionHandler: r,
    })),
    (a.bl = new fabric.Control({
      x: -0.5,
      y: 0.5,
      cursorStyleHandler: i,
      actionHandler: r,
    })),
    (a.br = new fabric.Control({
      x: 0.5,
      y: 0.5,
      cursorStyleHandler: i,
      actionHandler: r,
    })),
    (a.mtr = new fabric.Control({
      x: 0,
      y: -0.5,
      actionHandler: t.rotationWithSnapping,
      cursorStyleHandler: t.rotationStyleHandler,
      offsetY: -40,
      withConnection: !0,
      actionName: "rotate",
    })),
    fabric.Textbox)
  ) {
    var c = (fabric.Textbox.prototype.controls = {});
    (c.mtr = a.mtr),
      (c.tr = a.tr),
      (c.br = a.br),
      (c.tl = a.tl),
      (c.bl = a.bl),
      (c.mt = a.mt),
      (c.mb = a.mb),
      (c.mr = new fabric.Control({
        x: 0.5,
        y: 0,
        actionHandler: t.changeWidth,
        cursorStyleHandler: e,
        actionName: "resizing",
      })),
      (c.ml = new fabric.Control({
        x: -0.5,
        y: 0,
        actionHandler: t.changeWidth,
        cursorStyleHandler: e,
        actionName: "resizing",
      }));
  }
})();
!(function () {
  fabric.Object.ENLIVEN_PROPS.push("eraser");
  var t = fabric.Object.prototype._drawClipPath,
    e = fabric.Object.prototype.needsItsOwnCache,
    i = fabric.Object.prototype.toObject,
    r = fabric.Object.prototype.getSvgCommons,
    n = fabric.Object.prototype._createBaseClipPathSVGMarkup,
    s = fabric.Object.prototype._createBaseSVGMarkup;
  fabric.Object.prototype.cacheProperties.push("eraser"),
    fabric.Object.prototype.stateProperties.push("eraser"),
    fabric.util.object.extend(fabric.Object.prototype, {
      erasable: !0,
      eraser: void 0,
      needsItsOwnCache: function () {
        return e.call(this) || !!this.eraser;
      },
      _drawClipPath: function (e, i) {
        if ((t.call(this, e, i), this.eraser)) {
          var r = this._getNonTransformedDimensions();
          this.eraser.isType("eraser") &&
            this.eraser.set({ width: r.x, height: r.y }),
            t.call(this, e, this.eraser);
        }
      },
      toObject: function (t) {
        var e = i.call(this, ["erasable"].concat(t));
        return (
          this.eraser &&
            !this.eraser.excludeFromExport &&
            (e.eraser = this.eraser.toObject(t)),
          e
        );
      },
      getSvgCommons: function () {
        return (
          r.call(this) +
          (this.eraser ? 'mask="url(#' + this.eraser.clipPathId + ')" ' : "")
        );
      },
      _createEraserSVGMarkup: function (t) {
        return this.eraser
          ? ((this.eraser.clipPathId = "MASK_" + fabric.Object.__uid++),
            [
              '<mask id="',
              this.eraser.clipPathId,
              '" >',
              this.eraser.toSVG(t),
              "</mask>",
              "\n",
            ].join(""))
          : "";
      },
      _createBaseClipPathSVGMarkup: function (t, e) {
        return [
          this._createEraserSVGMarkup(e && e.reviver),
          n.call(this, t, e),
        ].join("");
      },
      _createBaseSVGMarkup: function (t, e) {
        return [
          this._createEraserSVGMarkup(e && e.reviver),
          s.call(this, t, e),
        ].join("");
      },
    });
  var o = fabric.Group.prototype._restoreObjectsState;
  fabric.util.object.extend(fabric.Group.prototype, {
    _addEraserPathToObjects: function (t) {
      this._objects.forEach(function (e) {
        fabric.EraserBrush.prototype._addPathToObjectEraser.call(
          fabric.EraserBrush.prototype,
          e,
          t
        );
      });
    },
    applyEraserToObjects: function () {
      var t = this,
        e = this.eraser;
      if (e) {
        delete this.eraser;
        var i = t.calcTransformMatrix();
        e.clone(function (e) {
          var r = t.clipPath;
          e.getObjects("path").forEach(function (e) {
            var n = fabric.util.multiplyTransformMatrices(
              i,
              e.calcTransformMatrix()
            );
            fabric.util.applyTransformToObject(e, n),
              r
                ? r.clone(
                    function (r) {
                      var n =
                        fabric.EraserBrush.prototype.applyClipPathToPath.call(
                          fabric.EraserBrush.prototype,
                          e,
                          r,
                          i
                        );
                      t._addEraserPathToObjects(n);
                    },
                    ["absolutePositioned", "inverted"]
                  )
                : t._addEraserPathToObjects(e);
          });
        });
      }
    },
    _restoreObjectsState: function () {
      return this.erasable === !0 && this.applyEraserToObjects(), o.call(this);
    },
  }),
    (fabric.Eraser = fabric.util.createClass(fabric.Group, {
      type: "eraser",
      originX: "center",
      originY: "center",
      drawObject: function (t) {
        t.save(),
          (t.fillStyle = "black"),
          t.fillRect(
            -this.width / 2,
            -this.height / 2,
            this.width,
            this.height
          ),
          t.restore(),
          this.callSuper("drawObject", t);
      },
      _getBounds: function () {},
      _toSVG: function (t) {
        var e = ["<g ", "COMMON_PARTS", " >\n"],
          i = -this.width / 2,
          r = -this.height / 2,
          n = [
            "<rect ",
            'fill="white" ',
            'x="',
            i,
            '" y="',
            r,
            '" width="',
            this.width,
            '" height="',
            this.height,
            '" />\n',
          ].join("");
        e.push("		", n);
        for (var s = 0, o = this._objects.length; o > s; s++)
          e.push("		", this._objects[s].toSVG(t));
        return e.push("</g>\n"), e;
      },
    })),
    (fabric.Eraser.fromObject = function (t, e) {
      var i = t.objects;
      fabric.util.enlivenObjects(i, function (i) {
        var r = fabric.util.object.clone(t, !0);
        delete r.objects,
          fabric.util.enlivenObjectEnlivables(t, r, function () {
            e && e(new fabric.Eraser(i, r, !0));
          });
      });
    });
  var a = fabric.Canvas.prototype._renderOverlay;
  fabric.util.object.extend(fabric.Canvas.prototype, {
    isErasing: function () {
      return (
        this.isDrawingMode &&
        this.freeDrawingBrush &&
        "eraser" === this.freeDrawingBrush.type &&
        this.freeDrawingBrush._isErasing
      );
    },
    _renderOverlay: function (t) {
      a.call(this, t),
        this.isErasing() &&
          !this.freeDrawingBrush.inverted &&
          this.freeDrawingBrush._render();
    },
  }),
    (fabric.EraserBrush = fabric.util.createClass(fabric.PencilBrush, {
      type: "eraser",
      inverted: !1,
      _isErasing: !1,
      _isErasable: function (t) {
        return t.erasable !== !1;
      },
      _prepareCollectionTraversal: function (t, e, i) {
        t.forEachObject(function (r) {
          r.forEachObject && "deep" === r.erasable
            ? this._prepareCollectionTraversal(r, e, i)
            : !this.inverted && r.erasable && r.visible
            ? ((r.visible = !1),
              (t.dirty = !0),
              i.visibility.push(r),
              i.collection.push(t))
            : this.inverted &&
              r.visible &&
              (r.erasable && r.eraser
                ? ((r.eraser.inverted = !0),
                  (r.dirty = !0),
                  (t.dirty = !0),
                  i.eraser.push(r),
                  i.collection.push(t))
                : ((r.visible = !1),
                  (t.dirty = !0),
                  i.visibility.push(r),
                  i.collection.push(t)));
        }, this);
      },
      preparePattern: function () {
        this._patternCanvas ||
          (this._patternCanvas = fabric.util.createCanvasElement());
        var t = this._patternCanvas;
        (t.width = this.canvas.width), (t.height = this.canvas.height);
        var e = t.getContext("2d");
        if (this.canvas._isRetinaScaling()) {
          var i = this.canvas.getRetinaScaling();
          this.canvas.__initRetinaScaling(i, t, e);
        }
        var r = this.canvas.backgroundImage,
          n = r && this._isErasable(r),
          s = this.canvas.overlayImage,
          o = s && this._isErasable(s);
        if (!this.inverted && ((r && !n) || this.canvas.backgroundColor))
          n && (this.canvas.backgroundImage = void 0),
            this.canvas._renderBackground(e),
            n && (this.canvas.backgroundImage = r);
        else if (this.inverted && r && n) {
          var c = this.canvas.backgroundColor;
          (this.canvas.backgroundColor = void 0),
            this.canvas._renderBackground(e),
            (this.canvas.backgroundColor = c);
        }
        e.save(), e.transform.apply(e, this.canvas.viewportTransform);
        var h = { visibility: [], eraser: [], collection: [] };
        if (
          (this._prepareCollectionTraversal(this.canvas, e, h),
          this.canvas._renderObjects(e, this.canvas._objects),
          h.visibility.forEach(function (t) {
            t.visible = !0;
          }),
          h.eraser.forEach(function (t) {
            (t.eraser.inverted = !1), (t.dirty = !0);
          }),
          h.collection.forEach(function (t) {
            t.dirty = !0;
          }),
          e.restore(),
          !this.inverted && ((s && !o) || this.canvas.overlayColor))
        )
          o && (this.canvas.overlayImage = void 0),
            a.call(this.canvas, e),
            o && (this.canvas.overlayImage = s);
        else if (this.inverted && s && o) {
          var c = this.canvas.overlayColor;
          (this.canvas.overlayColor = void 0),
            a.call(this.canvas, e),
            (this.canvas.overlayColor = c);
        }
      },
      _setBrushStyles: function (t) {
        this.callSuper("_setBrushStyles", t), (t.strokeStyle = "black");
      },
      _saveAndTransform: function (t) {
        this.callSuper("_saveAndTransform", t),
          this._setBrushStyles(t),
          (t.globalCompositeOperation =
            t === this.canvas.getContext() ? "destination-out" : "source-over");
      },
      needsFullRender: function () {
        return !0;
      },
      onMouseDown: function (t, e) {
        this.canvas._isMainEvent(e.e) &&
          (this._prepareForDrawing(t),
          this._captureDrawingPath(t),
          this.preparePattern(),
          (this._isErasing = !0),
          this.canvas.fire("erasing:start"),
          this._render());
      },
      _render: function () {
        var t;
        this.inverted ||
          ((t = this.canvas.getContext()), this.callSuper("_render", t)),
          (t = this.canvas.contextTop),
          this.canvas.clearContext(t),
          this.callSuper("_render", t),
          t.save();
        var e = this.canvas.getRetinaScaling(),
          i = 1 / e;
        t.scale(i, i),
          (t.globalCompositeOperation = "source-in"),
          t.drawImage(this._patternCanvas, 0, 0),
          t.restore();
      },
      createPath: function (t) {
        var e = this.callSuper("createPath", t);
        return (
          (e.globalCompositeOperation = this.inverted
            ? "source-over"
            : "destination-out"),
          (e.stroke = this.inverted ? "white" : "black"),
          e
        );
      },
      applyClipPathToPath: function (t, e, i) {
        var r = fabric.util.invertTransform(t.calcTransformMatrix()),
          n = e.calcTransformMatrix(),
          s = e.absolutePositioned
            ? r
            : fabric.util.multiplyTransformMatrices(r, i);
        return (
          (e.absolutePositioned = !1),
          fabric.util.applyTransformToObject(
            e,
            fabric.util.multiplyTransformMatrices(s, n)
          ),
          (t.clipPath = t.clipPath
            ? fabric.util.mergeClipPaths(e, t.clipPath)
            : e),
          t
        );
      },
      clonePathWithClipPath: function (t, e, i) {
        var r = e.calcTransformMatrix(),
          n = e.clipPath,
          s = this;
        t.clone(function (t) {
          n.clone(
            function (e) {
              i(s.applyClipPathToPath(t, e, r));
            },
            ["absolutePositioned", "inverted"]
          );
        });
      },
      _addPathToObjectEraser: function (t, e) {
        var i = this;
        if (t.forEachObject && "deep" === t.erasable) {
          var r = t._objects.filter(function (t) {
            return t.erasable;
          });
          return void (r.length > 0 && t.clipPath
            ? this.clonePathWithClipPath(e, t, function (t) {
                r.forEach(function (e) {
                  i._addPathToObjectEraser(e, t);
                });
              })
            : r.length > 0 &&
              r.forEach(function (t) {
                i._addPathToObjectEraser(t, e);
              }));
        }
        var n = t.eraser;
        n || ((n = new fabric.Eraser()), (t.eraser = n)),
          e.clone(function (e) {
            var r = fabric.util.multiplyTransformMatrices(
              fabric.util.invertTransform(t.calcTransformMatrix()),
              e.calcTransformMatrix()
            );
            fabric.util.applyTransformToObject(e, r),
              n.addWithUpdate(e),
              t.set("dirty", !0),
              t.fire("erasing:end", { path: e }),
              t.group &&
                Array.isArray(i.__subTargets) &&
                i.__subTargets.push(t);
          });
      },
      applyEraserToCanvas: function (t) {
        var e = this.canvas,
          i = {};
        return (
          ["backgroundImage", "overlayImage"].forEach(function (r) {
            var n = e[r];
            n && n.erasable && (this._addPathToObjectEraser(n, t), (i[r] = n));
          }, this),
          i
        );
      },
      _finalizeAndAddPath: function () {
        var t = this.canvas.contextTop,
          e = this.canvas;
        t.closePath(),
          this.decimate &&
            (this._points = this.decimatePoints(this._points, this.decimate)),
          e.clearContext(e.contextTop),
          (this._isErasing = !1);
        var i =
          this._points && this._points.length > 1
            ? this.convertPointsToSVGPath(this._points)
            : null;
        if (!i || this._isEmptySVGPath(i))
          return e.fire("erasing:end"), void e.requestRenderAll();
        var r = this.createPath(i);
        r.setCoords(), e.fire("before:path:created", { path: r });
        var n = this.applyEraserToCanvas(r),
          s = this;
        this.__subTargets = [];
        var o = [];
        e.forEachObject(function (t) {
          t.erasable &&
            t.intersectsWithObject(r, !0, !0) &&
            (s._addPathToObjectEraser(t, r), o.push(t));
        }),
          e.fire("erasing:end", {
            path: r,
            targets: o,
            subTargets: this.__subTargets,
            drawables: n,
          }),
          delete this.__subTargets,
          e.requestRenderAll(),
          this._resetShadow(),
          e.fire("path:created", { path: r });
      },
    }));
})();
