-- last.fm scrobbler for mpv
--
-- Usage:
-- put this file in ~/.config/mpv/scripts
-- put https://github.com/hauzer/scrobbler somewhere in your PATH
-- run `scrobbler add-user` and follow the instructions
-- create a file ~/.mpv/lua-settings/lastfm.conf with the following content:
-- username=<your last.fm user name>

local msg = require 'mp.msg'
require 'mp.options'

local options = {
	username = "change username in lua-settings/lastfm.conf"
}
read_options(options, 'lastfm')

function mkmetatable()
	local m = {}
	for i = 0, mp.get_property("metadata/list/count") - 1 do
		local p = "metadata/list/"..i.."/"
		m[mp.get_property(p.."key")] = mp.get_property(p.."value")
	end
	return m
end

function scrobble()
	mp.resume_all()
	-- Parameter escaping function. Works with POSIX shells; idk if there's a better way to call stuff portably in Lua.
	function esc(s)
		return string.gsub(s, "'", "'\\''")
	end

	msg.info(string.format("Scrobbling %s - %s", artist, title))

	optargs = ''
	if album then
		optargs = string.format("%s '--album=%s'", optargs, esc(album))
	end
	if length then
		optargs = string.format("%s '--duration=%d'", optargs, length)
	end
	args = string.format("scrobbler scrobble '%s' '%s' '%s' now > /dev/null", esc(options.username), esc(artist), esc(title))
	msg.debug(args)
	os.execute(args)
end

function enqueue()
	mp.resume_all()
	if artist and title then
		if tim then tim.kill(tim) end
		tim = mp.add_timeout(math.min(240, length / 2), scrobble)
	end
end

function on_metadata()
	local m = mkmetatable()
	local icy = m["icy-title"]
	if icy then
		-- TODO better magic
		artist, title = string.gmatch(icy, "(.+) %- (.+)")()
		album = nil
		length = nil
	else
		length = mp.get_property("duration")
		if length and tonumber(length) < 30 then return end	-- last.fm doesn't allow scrobbling short tracks
		artist = m["artist"]
		if not artist then
			artist = m["ARTIST"]
		end
		album = m["album"]
		if not album then
			album = m["ALBUM"]
		end
		title = m["title"]
		if not title then
			title = m["TITLE"]
		end
	end
	enqueue()
end

mp.register_event("metadata-update", on_metadata)
mp.register_event("file-loaded", on_metadata)
