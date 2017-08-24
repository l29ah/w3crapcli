    var n = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMN0PQRSTUVWXYZO123456789+/=",
        i = {
            v: function(e) {
                return e.split("").reverse().join("")
            },
            r: function(e, t) {
                e = e.split("");
                for (var i, a = n + n, o = e.length; o--;) i = a.indexOf(e[o]), ~i && (e[o] = a.substr(i - t, 1));
                return e.join("")
            },
            s: function(e, t) {
                var n = e.length;
                if (n) {
                    var i = s(e, t),
                        a = 0;
                    for (e = e.split(""); ++a < n;) e[a] = e.splice(i[n - 1 - a], 1, e[a])[0];
                    e = e.join("")
                }
                return e
            },
            x: function(e, t) {
                var n = [];
                return t = t.charCodeAt(0), each(e.split(""), function(e, i) {
                    n.push(String.fromCharCode(i.charCodeAt(0) ^ t))
                }), n.join("")
            }
        };

    function o(e) {
        if (~e.indexOf("audio_api_unavailable")) {
            var t = e.split("?extra=")[1].split("#"),
                n = "" === t[1] ? "" : r(t[1]);
            if (t = r(t[0]), "string" != typeof n || !t) return e;
            n = n ? n.split(String.fromCharCode(9)) : [];
            for (var o, s, l = n.length; l--;) {
                if (s = n[l].split(String.fromCharCode(11)), o = s.splice(0, 1, t)[0], !i[o]) return e;
                t = i[o].apply(null, s)
            }
            if (t && "http" === t.substr(0, 4)) return t
        }
        return e
    }

    function r(e) {
        if (!e || e.length % 4 == 1) return !1;
        for (var t, i, a = 0, o = 0, r = ""; i = e.charAt(o++);) i = n.indexOf(i), ~i && (t = a % 4 ? 64 * t + i : i, a++ % 4) && (r += String.fromCharCode(255 & t >> (-2 * a & 6)));
        return r
    }

    function s(e, t) {
        var n = e.length,
            i = [];
        if (n) {
            var a = n;
            for (t = Math.abs(t); a--;) i[a] = (t += t * (a + n) / t) % n | 0
        }
        return i
    }

    function unwrapFixAndWrap(str) {
        var indexOfFirstSpace = /\s/.exec(str).index;
        var url = str.slice(0, indexOfFirstSpace);
        return o(url) + str.slice(indexOfFirstSpace);
    }

    var str = readline();
    while (str !== null) {
        print(unwrapFixAndWrap(str));
        str = readline();
    }
