#!/usr/bin/env python3
import urllib.request as request
import urllib.parse as parse
import os, urllib.error
import optparse, getpass, re

filetype, unknown_languages = {}, []
filetype["^.*[.]as$"] = ("as", "ActionScript")
filetype["^.*[.]as3$"] = ("as3", "ActionScript 3")
filetype["^httpd.conf$"] = ("apacheconf", "ApacheConf")
unknown_languages.append(("applescript", "AppleScript"))
unknown_languages.append(("bbcode", "BBCode"))
filetype["^.*[.]sh$"] = ("bash", "Bash")
filetype["^.*[.]bat$"] = ("bat", "Batchfile")
unknown_languages.append(("befunge", "Befunge"))
unknown_languages.append(("boo", "Boo"))
unknown_languages.append(("brainfuck", "Brainfuck"))
filetype["^.*.[ch]$"] = ("c", "C")
filetype["^.*[.]cs$"] = ("csharp", "C#")
filetype["^.*[.][ch]pp$"] = ("cpp", "C++")
filetype["^.*[.]css"] = ("css", "CSS")
unknown_languages.append(("css+django", "CSS+Django/Jinja"))
unknown_languages.append(("css+genshitext", "CSS+Genshi Text"))
unknown_languages.append(("css+mako", "CSS+Mako"))
unknown_languages.append(("css+myghty", "CSS+Myghty"))
unknown_languages.append(("css+php", "CSS+PHP"))
unknown_languages.append(("css+erb", "CSS+Ruby"))
unknown_languages.append(("css+smarty", "CSS+Smarty"))
unknown_languages.append(("cheetah", "Cheetah"))
unknown_languages.append(("clojure", "Clojure"))
filetype["^.*[.]lisp"] = ("common-lisp", "Common Lisp")
filetype["^.*[.]d"] = ("d", "D")
unknown_languages.append(("dpatch", "Darcs Patch"))
unknown_languages.append(("control", "Debian Control file"))
unknown_languages.append(("sourceslist", "Debian Sourcelist"))
filetype["^.*[.]pas$"] = ("delphi", "Delphi")
filetype["^.*[.](diff|patch)$"] = ("diff", "Diff")
unknown_languages.append(("django", "Django/Jinja"))
unknown_languages.append(("dylan", "Dylan"))
unknown_languages.append(("erb", "ERB"))
filetype["^.*[.]erl$"] = ("erlang", "Erlang")
unknown_languages.append(("fortran", "Fortran"))
unknown_languages.append(("gas", "GAS"))
unknown_languages.append(("genshi", "Genshi"))
unknown_languages.append(("genshitext", "Genshi Text"))
filetype["^.*[.]pot$"] = ("pot", "Gettext Catalog")
unknown_languages.append(("gnuplot", "Gnuplot"))
filetype["^.*[.]groff$"] = ("groff", "Groff")
filetype["^.*[.]html{0,1}$"] = ("html", "HTML")
unknown_languages.append(("html+cheetah", "HTML+Cheetah"))
filetype["^.*[.]dhtml$"] = ("html+django", "HTML+Django/Jinja")
unknown_languages.append(("html+genshi", "HTML+Genshi"))
unknown_languages.append(("html+mako", "HTML+Mako"))
unknown_languages.append(("html+myghty", "HTML+Myghty"))
filetype["^.*[.]php$"] = ("html+php", "HTML+PHP")
unknown_languages.append(("html+smarty", "HTML+Smarty"))
filetype["^.*[.]hs$"] = ("haskell", "Haskell")
filetype["^.*[.]ini$"] = ("ini", "INI")
unknown_languages.append(("irc", "IRC logs"))
unknown_languages.append(("io", "Io"))
filetype["^.*[.]java$"] = ("java", "Java")
filetype["^.*[.]jsp$"] = ("jsp", "Java Server Page")
filetype["^.*[.]js$"] = ("js", "JavaScript")
unknown_languages.append(("js+cheetah", "JavaScript+Cheetah"))
unknown_languages.append(("js+django", "JavaScript+Django/Jinja"))
unknown_languages.append(("js+genshitext", "JavaScript+Genshi Text"))
unknown_languages.append(("js+mako", "JavaScript+Mako"))
unknown_languages.append(("js+myghty", "JavaScript+Myghty"))
unknown_languages.append(("js+php", "JavaScript+PHP"))
unknown_languages.append(("js+erb", "JavaScript+Ruby"))
unknown_languages.append(("js+smarty", "JavaScript+Smarty"))
unknown_languages.append(("llvm", "LLVM"))
unknown_languages.append(("lighty", "Lighttpd configuration file"))
unknown_languages.append(("lhs", "Literate Haskell"))
unknown_languages.append(("logtalk", "Logtalk"))
filetype["^.*[.]lua$"] = ("lua", "Lua")
unknown_languages.append(("moocode", "MOOCode"))
filetype["^Makefile$"] = ("make", "Makefile")
unknown_languages.append(("basemake", "Makefile"))
unknown_languages.append(("mako", "Mako"))
unknown_languages.append(("matlab", "Matlab"))
unknown_languages.append(("matlabsession", "Matlab session"))
unknown_languages.append(("minid", "MiniD"))
unknown_languages.append(("trac-wiki", "MoinMoin/Trac Wiki markup"))
unknown_languages.append(("mupad", "MuPAD"))
unknown_languages.append(("mysql", "MySQL"))
unknown_languages.append(("myghty", "Myghty"))
unknown_languages.append(("nasm", "NASM"))
filetype["^nginx.conf$"] = ("nginx", "Nginx configuration file")
unknown_languages.append(("numpy", "NumPy"))
filetype["^.*[.]caml$"] = ("ocaml", "OCaml")
filetype["^.*[.]C$"] = ("objective-c", "Objective-C")
unknown_languages.append(("php", "PHP"))
unknown_languages.append(("pov", "POVRay"))
filetype["^.*[.]pl$"] = ("perl", "Perl")
filetype["^.*[.]py$"] = ("python", "Python")
unknown_languages.append(("python3", "Python 3"))
unknown_languages.append(("py3tb", "Python 3.0 Traceback"))
unknown_languages.append(("pytb", "Python Traceback"))
unknown_languages.append(("pycon", "Python console session"))
unknown_languages.append(("rhtml", "RHTML"))
unknown_languages.append(("raw", "Raw token data"))
unknown_languages.append(("redcode", "Redcode"))
filetype["^.*[.]rb$"] = ("rb", "Ruby")
unknown_languages.append(("rbcon", "Ruby irb session"))
unknown_languages.append(("splus", "S"))
filetype["^.*[.]sql$"] = ("sql", "SQL")
unknown_languages.append(("scala", "Scala"))
unknown_languages.append(("scheme", "Scheme"))
unknown_languages.append(("smalltalk", "Smalltalk"))
unknown_languages.append(("smarty", "Smarty"))
filetype["^squid.conf$"] = ("squidconf", "SquidConf")
filetype["^.*[.]tcl$"] = ("tcl", "Tcl")
unknown_languages.append(("tcsh", "Tcsh"))
filetype["^.*[.]tex$"] = ("tex", "TeX")
filetype["^.*[.]txt$"] = ("text", "Text only")
unknown_languages.append(("vb.net", "VB.net"))
unknown_languages.append(("vim", "VimL"))
filetype["^.*[.]xml$"] = ("xml", "XML")
unknown_languages.append(("xml+cheetah", "XML+Cheetah"))
unknown_languages.append(("xml+django", "XML+Django/Jinja"))
unknown_languages.append(("xml+mako", "XML+Mako"))
unknown_languages.append(("xml+myghty", "XML+Myghty"))
unknown_languages.append(("xml+php", "XML+PHP"))
unknown_languages.append(("xml+erb", "XML+Ruby"))
unknown_languages.append(("xml+smarty", "XML+Smarty"))
filetype["^.*[.]xslt$"] = ("xslt", "XSLT")
unknown_languages.append(("yaml", "YAML"))
unknown_languages.append(("c-objdump", "c-objdump"))
unknown_languages.append(("cpp-objdump", "cpp-objdump"))
unknown_languages.append(("d-objdump", "d-objdump"))
unknown_languages.append(("objdump", "objdump"))
unknown_languages.append(("rst", "reStructuredText"))
unknown_languages.append(("sqlite3", "sqlite3con"))


data = {
    'content': "",
    'author': getpass.getuser(),
    'title': "",
    'language': "text",
    'channel': "",
    'save': 'save',
}

oparser = optparse.OptionParser("Usage:  %prog [options] [file]")
oparser.add_option("-t", "--title", dest="title",
                   help="Title of your code. By default is filename.")
oparser.add_option("-u", "--user", dest="username",
                   help="Author of the code. By default is username.")
oparser.add_option("-l", "--lang", dest="language",
                   help="Language of your code. By default is selecting"
                   + " authomatically or `text' if cannot. "
                   + "Type `--lang list' to get all supported languages.")

(options, args) = oparser.parse_args()

if options.language == 'list':
    print("Languages that can be recognized by filename:")
    a = list(filetype.values())
    a.sort()
    print('\n'.join([' %s - %s' % i for i in a]))
    a = unknown_languages
    a.sort()
    print("\nLanguages that must be set manually:")
    print('\n'.join([' %s - %s' % i for i in a]))
    exit(0)

if len(args) == 0:
    import sys
    data['content'] = sys.stdin.read()
elif len(args) == 1:
    filename = args[0] 
    file = open(filename, 'r')
    data['content'] = file.read()
    file.close() 
    basename = os.path.basename(filename)
    for pattern, language in filetype.items():
        if re.search(pattern, basename):
            data['language'] = language[0]
            break 
    data['title'] = basename
else:
    oparser.print_help()
    exit(-1)

if options.username != None:
    data['author'] = options.username
if options.title != None:
    data['title'] = options.title
if options.language != None:
    data['language'] = options.language


endurl = None

def get_new_url(self, req, fp, code, msg, nurl):
    global endurl
    endurl = nurl

pasteurl = "http://hpaste.org/fastcgi/hpaste.fcgi/save"

handl = request.HTTPRedirectHandler()
handl.redirect_request = get_new_url
opener = request.build_opener(handl)
request.install_opener(opener)
try:
    request.urlopen(pasteurl, parse.urlencode(data))
except urllib.error.HTTPError:
    pass

print(endurl)
os.system('xdg-open ' + endurl)

