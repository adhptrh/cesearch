--// Base64
local a="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"function base64_encode(b)return(b:gsub(".",function(c)local d,a="",c:byte()for e=8,1,-1 do d=d..(a%2^e-a%2^(e-1)>0 and"1"or"0")end;return d end).."0000"):gsub("%d%d%d?%d?%d?%d?",function(c)if#c<6 then return""end;local f=0;for e=1,6 do f=f+(c:sub(e,e)=="1"and 2^(6-e)or 0)end;return a:sub(f+1,f+1)end)..({"","==","="})[#b%3+1]end;function base64_decode(b)b=string.gsub(b,"[^"..a.."=]","")return b:gsub(".",function(c)if c=="="then return""end;local d,g="",a:find(c)-1;for e=6,1,-1 do d=d..(g%2^e-g%2^(e-1)>0 and"1"or"0")end;return d end):gsub("%d%d%d?%d?%d?%d?%d?%d?",function(c)if#c~=8 then return""end;local f=0;for e=1,8 do f=f+(c:sub(e,e)=="1"and 2^(8-e)or 0)end;return string.char(f)end)end
--// JSON Library : https://github.com/rxi/json.lua
local a={_version="0.1.2"}local b;local c={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local d={["/"]="/"}for e,f in pairs(c)do d[f]=e end;local function g(h)return"\\"..(c[h]or string.format("u%04x",h:byte()))end;local function i(j)return"null"end;local function k(j,l)local m={}l=l or{}if l[j]then error("circular reference")end;l[j]=true;if rawget(j,1)~=nil or next(j)==nil then local n=0;for e in pairs(j)do if type(e)~="number"then error("invalid table: mixed or invalid key types")end;n=n+1 end;if n~=#j then error("invalid table: sparse array")end;for o,f in ipairs(j)do table.insert(m,b(f,l))end;l[j]=nil;return"["..table.concat(m,",").."]"else for e,f in pairs(j)do if type(e)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(m,b(e,l)..":"..b(f,l))end;l[j]=nil;return"{"..table.concat(m,",").."}"end end;local function p(j)return'"'..j:gsub('[%z\1-\31\\"]',g)..'"'end;local function q(j)if j~=j or j<=-math.huge or j>=math.huge then error("unexpected number value '"..tostring(j).."'")end;return string.format("%.14g",j)end;local r={["nil"]=i,["table"]=k,["string"]=p,["number"]=q,["boolean"]=tostring}b=function(j,l)local s=type(j)local t=r[s]if t then return t(j,l)end;error("unexpected type '"..s.."'")end;function a.encode(j)return b(j)end;local u;local function v(...)local m={}for o=1,select("#",...)do m[select(o,...)]=true end;return m end;local w=v(" ","\t","\r","\n")local x=v(" ","\t","\r","\n","]","}",",")local y=v("\\","/",'"',"b","f","n","r","t","u")local z=v("true","false","null")local A={["true"]=true,["false"]=false,["null"]=nil}local function B(C,D,E,F)for o=D,#C do if E[C:sub(o,o)]~=F then return o end end;return#C+1 end;local function G(C,D,H)local I=1;local J=1;for o=1,D-1 do J=J+1;if C:sub(o,o)=="\n"then I=I+1;J=1 end end;error(string.format("%s at line %d col %d",H,I,J))end;local function K(n)local t=math.floor;if n<=0x7f then return string.char(n)elseif n<=0x7ff then return string.char(t(n/64)+192,n%64+128)elseif n<=0xffff then return string.char(t(n/4096)+224,t(n%4096/64)+128,n%64+128)elseif n<=0x10ffff then return string.char(t(n/262144)+240,t(n%262144/4096)+128,t(n%4096/64)+128,n%64+128)end;error(string.format("invalid unicode codepoint '%x'",n))end;local function L(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return K((N-0xd800)*0x400+O-0xdc00+0x10000)else return K(N)end end;local function P(C,o)local m=""local Q=o+1;local e=Q;while Q<=#C do local R=C:byte(Q)if R<32 then G(C,Q,"control character in string")elseif R==92 then m=m..C:sub(e,Q-1)Q=Q+1;local h=C:sub(Q,Q)if h=="u"then local S=C:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or C:match("^%x%x%x%x",Q+1)or G(C,Q-1,"invalid unicode escape in string")m=m..L(S)Q=Q+#S else if not y[h]then G(C,Q-1,"invalid escape char '"..h.."' in string")end;m=m..d[h]end;e=Q+1 elseif R==34 then m=m..C:sub(e,Q-1)return m,Q+1 end;Q=Q+1 end;G(C,o,"expected closing quote for string")end;local function T(C,o)local R=B(C,o,x)local M=C:sub(o,R-1)local n=tonumber(M)if not n then G(C,o,"invalid number '"..M.."'")end;return n,R end;local function U(C,o)local R=B(C,o,x)local V=C:sub(o,R-1)if not z[V]then G(C,o,"invalid literal '"..V.."'")end;return A[V],R end;local function W(C,o)local m={}local n=1;o=o+1;while 1 do local R;o=B(C,o,w,true)if C:sub(o,o)=="]"then o=o+1;break end;R,o=u(C,o)m[n]=R;n=n+1;o=B(C,o,w,true)local X=C:sub(o,o)o=o+1;if X=="]"then break end;if X~=","then G(C,o,"expected ']' or ','")end end;return m,o end;local function Y(C,o)local m={}o=o+1;while 1 do local Z,j;o=B(C,o,w,true)if C:sub(o,o)=="}"then o=o+1;break end;if C:sub(o,o)~='"'then G(C,o,"expected string for key")end;Z,o=u(C,o)o=B(C,o,w,true)if C:sub(o,o)~=":"then G(C,o,"expected ':' after key")end;o=B(C,o+1,w,true)j,o=u(C,o)m[Z]=j;o=B(C,o,w,true)local X=C:sub(o,o)o=o+1;if X=="}"then break end;if X~=","then G(C,o,"expected '}' or ','")end end;return m,o end;local _={['"']=P,["0"]=T,["1"]=T,["2"]=T,["3"]=T,["4"]=T,["5"]=T,["6"]=T,["7"]=T,["8"]=T,["9"]=T,["-"]=T,["t"]=U,["f"]=U,["n"]=U,["["]=W,["{"]=Y}u=function(C,D)local X=C:sub(D,D)local t=_[X]if t then return t(C,D)end;G(C,D,"unexpected character '"..X.."'")end;function a.decode(C)if type(C)~="string"then error("expected argument of type string, got "..type(C))end;local m,D=u(C,B(C,1,w,true))D=B(C,D,w,true)if D<=#C then G(C,D,"trailing garbage")end;return m end local json = {} function json.encode(s) return a.encode(s) end function json.decode(s) return a.decode(s) end

local fdata = base64_decode('PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPEZvcm1EYXRhPgogIDxmcm1DRVNlYXJjaCBDbGFzcz0iVENFRm9ybSIgRW5jb2Rpbmc9IkFzY2lpODUiPnJCJXlyLGVROntqJCpBJVRbOjRZTW1ORSV2V3JtTFUzRiolYS03NzhncGkxVj0xdG47V0pTI2chLnZreUtzTm46WlZQMGF1Z2NGUGNsZVM9NkUlVylxan1WKGJNRC04dUslPVY/fTNDTm5aNyRkNkxSVXkva0I1XWpMSS42YUtVRCl3Om53V0VTYmx1W3JkNy1WJTdWSVtBWmwxI2w4UUchRCxnUjpbcUE5dlEzdyxSM2RvYXNAYSlFRyxfdVQpTjNfaWczJHFCUFUqUHZmLTVQfWdVMFNDTjVbSy1eSTQ3dzQ/KEhSMDZTRjQ3MUpUNj1iRTpFOEIvNStER3lASUdpUSUzLlFLeVo6cmtyO3l3ekRPeCo6JGkjMWRIJD9xJE5lZ1kqRz1Nb2VPYVldP0JNRTlFW2Z5OmZOcXd7SkZ5ai15MUcjWlJqZ2VBdVhEWDhiO0FHKHFBNzhNLTFCKWxvLyNsLHRpdlB4dmRnXlptX1hASEcrWzhpXUdMR01HXmNZLjo/JHQyV0RMOCxEIzoqcWhlXkwxSEV1cCskaWgkLEMvLzQzb3ArKURHUjdESm02NEhZW2d9cFFeLDdBRkZ0c3hYR3ErLys5QVQlO0ZESmk4TWxKLkNtc29HWC5Ld2RldlszN25ERUEqQX1zYyh4TzF4S2NebF9mXUBoVmZnbToxWVRvR2ZXOC5bUnBfOiE1I3JFVW9zVl4sUSFzcXRrSjA9X2tANSN2TXltPXE5WjpUbDR6ZVJ2V1hBQT96Y1lId3VtUmpYLFRRVSFHOk4lY3YxTDFjeU5fe0Zdd0ByK1RjUCxJSmhAfVZDS19WTnpGN25uXlRJJWsydzF5YU5TQm5DK1txMV82Xnh5ZXZSOzhpaVZlaShjL0p4YVAzQHtNZC5iNHEjVmdBNzNERUdHQj1rZE5mRVJHOG5wVjQ6K21dWmxsVmdXTTA7Ul4xQm94VlRXXVFCcW5MMnRBQmVENlJwWnA6YnB2dkpDMGE3WFIvOmlDMHJldlJYUjskWVVWMzB6eWlJLkk/eEo3TTVXcnA0eTpzSmJoZi0/OFBFTnJATUFhclF5MUpYO2lzZ3hpKlhiUDJoWkxEYkd7UyllfTVUN3BrWHprV2khK0wwKD9eNXMpXixIcFRuSXpGSlhxKTJvX3FBOT1xXSk3LXJWWjZNe0ZCKiM7O2MpLSxlKXk5OFlqc31NPW1XKU07djVobWhBW0t0MndTSVhDQV5RP1N2OFRYO2ZackxHN11wKERqMTtqZ2Zqd2FYRlArJWghUVltKS1xbD9IQXhldFFidk1Ba3J9WmsrNlExMGMvWHghVkBeLyFUYXJ3cVltR247LXBvNFthOm1PYyUpP2daeF9EUWZjVXRNQlJkbXNfVlgyN2d4X0R7PURiRXVYdVk6ayUoT0cwPzlNZEpmbFRQdXlFVFBdLXBuPyhBK3opTl5je195THMsUnVYPS8qPC9mcm1DRVNlYXJjaD4KPC9Gb3JtRGF0YT4K')
local formLoc = os.getenv("temp").."/cesearchform.FRM"

local menuitem = createMenuItem(MainForm.MainMenu1)
menuitem.caption = "CESearch"
menuitem.onclick = function()
  local w = io.open(formLoc,"w")
  w:write(fdata)
  w:close()
  createFormFromFile(formLoc)
  frmCESearch.show()
end
MainForm.MainMenu1.items.add(menuitem)

function CESearch(toSearch,page)
  local getUrl = getInternet().getURL
  page = page*10
  local data = getUrl("https://cse.google.com/cse/element/v1?rsz=filtered_cse&num=10&hl=en&source=gcsc&gss=.com&start="..page.."&cselibv=26b8d00a7c7a0812&cx=009081794347989224031:rrizk45lqzi&q="..toSearch.."&safe=off&cse_tok=AJvRUv13fN1UK10wFdI29w5WUig9:1604782274581&exp=csqr,cc&oq="..toSearch.."&gs_l=partner-generic.3...239409.239966.2.240083.0.0.0.0.0.0.0.0..0.0.csems%2Cnrl%3D13...0.239899j57300019903j5j1...1.34.partner-generic..0.0.0.&callback=google.search.cse.api8872")
  data = data:sub(35)
  data = data:sub(0,#data-2)
  data = json.decode(data)

  return data
end

local searching = ""
local boxes = {}
local page = 0

function buildBoxes(data)
  for k,v in pairs(boxes) do
    boxes[k].destroy()
  end
  local enter = -2
  for i=1,#data.results do
    boxes["box"..i] = createPanel(frmCESearch.ScrollBox1)
    boxes["box"..i].bevelColor = 0x808080
    boxes["box"..i].height = 90
    boxes["box"..i].width = frmCESearch.ScrollBox1.width
    boxes["box"..i].anchors = "[akTop,akLeft,akRight]"
    boxes["box"..i].top = enter
    boxes["box"..i].left = -2
    enter = enter + 90 -1
    local titl = createLabel(boxes["box"..i])
    titl.caption = data.results[i].title
    titl.font.color = 0xff0000
    titl.left = 6
    titl.top = 6
    titl.Cursor = -21
    titl.onclick = function()
      shellExecute(data.results[i].unescapedUrl)
    end
    titl.onmouseenter = function(sender)
      sender.font.style = "fsUnderline"
    end
    titl.onmouseleave = function(sender)
      sender.font.style = ""
    end
    local url = createLabel(boxes["box"..i])
    url.caption = data.results[i].unescapedUrl
    url.font.color = 0x008000
    url.left = 6
    url.top = 22
    local content = createLabel(boxes["box"..i])
    content.caption = data.results[i].contentNoFormatting
    content.font.color = 0x00
    content.left = 6
    content.top = 38
  end
end

function search(toSearch)
  frmCESearch.CELabel1.caption = "Current Page : "..page
  local data = CESearch(toSearch,page)
  if data.results == nil then showMessage("Not Found") return end
  buildBoxes(data)
end

function searchBoxKeyDown(sender, key)
  if key == VK_RETURN then
    page = 0
    searching = sender.text
    search(sender.text)
  end
end

function nextPageClick(sender)
  page = page + 1
  search(searching)
end

function prevPageClick(sender)
  page = page - 1
  search(searching)
end

function cbSOPChange(sender)
  if sender.checked == true then
    frmCESearch.formstyle = "fsSystemStayOnTop"
  else
    frmCESearch.formstyle = "fsNormal"
  end
end

function trackbarChange(sender)
  frmCESearch.alphablendvalue = sender.position
end

function githubClick(sender)
  shellExecute("https://github.com/adhptrh/cesearch")
end
