local Config = {
ServiceId       = 26291,
PlatoSecret     = string.char(49, 101, 50, 99, 57, 99, 54, 48, 45, 98, 102, 53, 51, 45, 52, 99, 101, 98, 45, 56, 99, 98, 55, 45, 55, 98, 51, 102, 53, 55, 55, 98, 54, 99, 48, 56),
SecretVariable  = string.char(85, 110, 105, 118, 101, 114, 115, 97, 108, 83, 117, 110, 72, 117, 98, 65, 117, 116, 104, 84, 111, 107, 101, 110),
SecretValue     = string.char(53, 98, 56, 50, 56, 55, 100, 51, 100, 102, 97, 53, 51, 57, 99, 51, 54, 50, 57, 101, 52, 54, 97, 55, 56, 50, 98, 99, 102, 50, 101, 55),
MainScriptURL   = string.char(104, 116, 116, 112, 115, 58, 47, 47, 114, 97, 119, 46, 103, 105, 116, 104, 117, 98, 117, 115, 101, 114, 99, 111, 110, 116, 101, 110, 116, 46, 99, 111, 109, 47, 115, 97, 110, 106, 101, 101, 118, 116, 104, 97, 107, 117, 114, 49, 53, 52, 97, 45, 106, 112, 103, 47, 110, 101, 104, 104, 105, 110, 110, 106, 102, 105, 117, 101, 105, 111, 101, 114, 111, 107, 47, 114, 101, 102, 115, 47, 104, 101, 97, 100, 115, 47, 109, 97, 105, 110, 47, 108, 46, 108, 117, 97),
KeyFolder       = string.char(85, 110, 105, 118, 101, 114, 115, 97, 108, 83, 117, 110, 72, 117, 98),
KeyFileName     = string.char(85, 110, 105, 118, 101, 114, 115, 97, 108, 83, 117, 110, 72, 117, 98, 47, 107, 101, 121, 46, 116, 120, 116),
DiscordURL      = string.char(104, 116, 116, 112, 115, 58, 47, 47, 100, 105, 115, 99, 111, 114, 100, 46, 103, 103, 47, 50, 69, 119, 68, 55, 97, 85, 50, 66),
HubName         = string.char(85, 78, 73, 86, 69, 82, 83, 65, 76, 32, 83, 85, 78, 32, 72, 85, 66),
HubDescription  = string.char(80, 108, 101, 97, 115, 101, 32, 103, 101, 116, 32, 97, 32, 107, 101, 121, 32, 97, 110, 100, 32, 118, 101, 114, 105, 102, 121, 32, 105, 116, 32, 98, 101, 108, 111, 119, 32, 116, 111, 32, 101, 120, 101, 99, 117, 116, 101, 32, 116, 104, 101, 32, 104, 117, 98, 46)
}
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,string.char(46),function(l)return string.format(string.char(37, 48, 50, 120),string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F..string.char(92, 49, 50, 56)..string.rep(string.char(92, 48),H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={[string.char(92)]=string.char(92),[string.char(34)]=string.char(34),[string.char(92, 98)]=string.char(98),[string.char(92, 102)]=string.char(102),[string.char(10)]=string.char(110),[string.char(13)]=string.char(114),[string.char(9)]=string.char(116)}local P={[string.char(47)]=string.char(47)}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)returnstring.char(92)..(l[T]or string.format(string.char(117, 37, 48, 52, 120),T:byte()))end;local B=function(M)returnstring.char(110, 117, 108, 108)end;local v=function(M,z)local _={}z=z or{}if z[M]then error(string.char(99, 105, 114, 99, 117, 108, 97, 114, 32, 114, 101, 102, 101, 114, 101, 110, 99, 101))end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~=string.char(110, 117, 109, 98, 101, 114)then error(string.char(105, 110, 118, 97, 108, 105, 100, 32, 116, 97, 98, 108, 101, 58, 32, 109, 105, 120, 101, 100, 32, 111, 114, 32, 105, 110, 118, 97, 108, 105, 100, 32, 107, 101, 121, 32, 116, 121, 112, 101, 115))end;A=A+1 end;if A~=#M then error(string.char(105, 110, 118, 97, 108, 105, 100, 32, 116, 97, 98, 108, 101, 58, 32, 115, 112, 97, 114, 115, 101, 32, 97, 114, 114, 97, 121))end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;returnstring.char(91)..table.concat(_,string.char(44))..string.char(93)else for Q,R in pairs(M)do if type(Q)~=string.char(115, 116, 114, 105, 110, 103)then error(string.char(105, 110, 118, 97, 108, 105, 100, 32, 116, 97, 98, 108, 101, 58, 32, 109, 105, 120, 101, 100, 32, 111, 114, 32, 105, 110, 118, 97, 108, 105, 100, 32, 107, 101, 121, 32, 116, 121, 112, 101, 115))end;table.insert(_,e(Q,z)..string.char(58)..e(R,z))end;z[M]=nil;returnstring.char(123)..table.concat(_,string.char(44))..string.char(125)end end;local g=function(M)returnstring.char(34)..M:gsub(string.char(91, 37, 122, 92, 49, 45, 92, 51, 49, 92, 34, 93),S)..string.char(34)end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error(string.char(117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 110, 117, 109, 98, 101, 114, 32, 118, 97, 108, 117, 101, 32, 39)..tostring(M)..string.char(39))end;return string.format(string.char(37, 46, 49, 52, 103),M)end;local j={[string.char(110, 105, 108)]=B,[string.char(116, 97, 98, 108, 101)]=v,[string.char(115, 116, 114, 105, 110, 103)]=g,[string.char(110, 117, 109, 98, 101, 114)]=a1,[string.char(98, 111, 111, 108, 101, 97, 110)]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error(string.char(117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 116, 121, 112, 101, 32, 39)..x..string.char(39))end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select(string.char(35),...)do _[select(a0,...)]=true end;return _ end;local L=N(string.char(32),string.char(9),string.char(13),string.char(10))local p=N(string.char(32),string.char(9),string.char(13),string.char(10),string.char(93),string.char(125),string.char(44))local a5=N(string.char(92),string.char(47),string.char(34),string.char(98),string.char(102),string.char(110),string.char(114),string.char(116),string.char(117))local m=N(string.char(116, 114, 117, 101),string.char(102, 97, 108, 115, 101),string.char(110, 117, 108, 108))local a6={[string.char(116, 114, 117, 101)]=true,[string.char(102, 97, 108, 115, 101)]=false,[string.char(110, 117, 108, 108)]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)==string.char(10)then ad=ad+1;ae=1 end end;error(string.format(string.char(37, 115, 32, 97, 116, 32, 108, 105, 110, 101, 32, 37, 100, 32, 99, 111, 108, 32, 37, 100),J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format(string.char(105, 110, 118, 97, 108, 105, 100, 32, 117, 110, 105, 99, 111, 100, 101, 32, 99, 111, 100, 101, 112, 111, 105, 110, 116, 32, 39, 37, 120, 39),A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,string.char(99, 111, 110, 116, 114, 111, 108, 32, 99, 104, 97, 114, 97, 99, 116, 101, 114, 32, 105, 110, 32, 115, 116, 114, 105, 110, 103))elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T==string.char(117)then local an=a8:match(string.char(94, 91, 100, 68, 93, 91, 56, 57, 97, 65, 98, 66, 93, 37, 120, 37, 120, 92, 117, 37, 120, 37, 120, 37, 120, 37, 120),al+1)or a8:match(string.char(94, 37, 120, 37, 120, 37, 120, 37, 120),al+1)or ac(a8,al-1,string.char(105, 110, 118, 97, 108, 105, 100, 32, 117, 110, 105, 99, 111, 100, 101, 32, 101, 115, 99, 97, 112, 101, 32, 105, 110, 32, 115, 116, 114, 105, 110, 103))_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,string.char(105, 110, 118, 97, 108, 105, 100, 32, 101, 115, 99, 97, 112, 101, 32, 99, 104, 97, 114, 32, 39)..T..string.char(39, 32, 105, 110, 32, 115, 116, 114, 105, 110, 103))end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,string.char(101, 120, 112, 101, 99, 116, 101, 100, 32, 99, 108, 111, 115, 105, 110, 103, 32, 113, 117, 111, 116, 101, 32, 102, 111, 114, 32, 115, 116, 114, 105, 110, 103))end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,string.char(105, 110, 118, 97, 108, 105, 100, 32, 110, 117, 109, 98, 101, 114, 32, 39)..ah..string.char(39))end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,string.char(105, 110, 118, 97, 108, 105, 100, 32, 108, 105, 116, 101, 114, 97, 108, 32, 39)..aq..string.char(39))end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)==string.char(93)then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as==string.char(93)then break end;if as~=string.char(44)then ac(a8,a0,string.char(101, 120, 112, 101, 99, 116, 101, 100, 32, 39, 93, 39, 32, 111, 114, 32, 39, 44, 39))end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)==string.char(125)then a0=a0+1;break end;if a8:sub(a0,a0)~=string.char(34)then ac(a8,a0,string.char(101, 120, 112, 101, 99, 116, 101, 100, 32, 115, 116, 114, 105, 110, 103, 32, 102, 111, 114, 32, 107, 101, 121))end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=string.char(58)then ac(a8,a0,string.char(101, 120, 112, 101, 99, 116, 101, 100, 32, 39, 58, 39, 32, 97, 102, 116, 101, 114, 32, 107, 101, 121))end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as==string.char(125)then break end;if as~=string.char(44)then ac(a8,a0,string.char(101, 120, 112, 101, 99, 116, 101, 100, 32, 39, 125, 39, 32, 111, 114, 32, 39, 44, 39))end end;return _,a0 end;local av={[string.char(34)]=ak,[string.char(48)]=ao,[string.char(49)]=ao,[string.char(50)]=ao,[string.char(51)]=ao,[string.char(52)]=ao,[string.char(53)]=ao,[string.char(54)]=ao,[string.char(55)]=ao,[string.char(56)]=ao,[string.char(57)]=ao,[string.char(45)]=ao,[string.char(116)]=ap,[string.char(102)]=ap,[string.char(110)]=ap,[string.char(91)]=ar,[string.char(123)]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,string.char(117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 99, 104, 97, 114, 97, 99, 116, 101, 114, 32, 39)..as..string.char(39))end;local aw=function(a8)if type(a8)~=string.char(115, 116, 114, 105, 110, 103)then error(string.char(101, 120, 112, 101, 99, 116, 101, 100, 32, 97, 114, 103, 117, 109, 101, 110, 116, 32, 111, 102, 32, 116, 121, 112, 101, 32, 115, 116, 114, 105, 110, 103, 44, 32, 103, 111, 116, 32)..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,string.char(116, 114, 97, 105, 108, 105, 110, 103, 32, 103, 97, 114, 98, 97, 103, 101))end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
local useNonce = true
local fStringChar, fToString, fOsTime, fMathRandom, fMathFloor = string.char, tostring, os.time, math.random, math.floor
local fGetHwid = gethwid or function() return game:GetService(string.char(82, 98, 120, 65, 110, 97, 108, 121, 116, 105, 99, 115, 83, 101, 114, 118, 105, 99, 101)):GetClientId() end
local cachedLink, cachedTime = "", 0
local host = string.char(104, 116, 116, 112, 115, 58, 47, 47, 97, 112, 105, 46, 112, 108, 97, 116, 111, 98, 111, 111, 115, 116, 46, 99, 111, 109)
local function safeRequest(options)
local req = request or http_request or syn_request or (http and http.request)
if not req then return nil, string.char(69, 120, 101, 99, 117, 116, 111, 114, 32, 72, 84, 84, 80, 32, 114, 101, 113, 117, 101, 115, 116, 115, 32, 110, 111, 116, 32, 115, 117, 112, 112, 111, 114, 116, 101, 100) end
local success, response = pcall(function() return req(options) end)
if success and response then return response else return nil, string.char(72, 84, 84, 80, 32, 82, 101, 113, 117, 101, 115, 116, 32, 69, 114, 114, 111, 114) end
end
local function checkConnectivity()
local response = safeRequest({Url = host .. string.char(47, 112, 117, 98, 108, 105, 99, 47, 99, 111, 110, 110, 101, 99, 116, 105, 118, 105, 116, 121), Method = string.char(71, 69, 84)})
if not response or (response.StatusCode ~= 200 and response.StatusCode ~= 429) then
host = string.char(104, 116, 116, 112, 115, 58, 47, 47, 97, 112, 105, 46, 112, 108, 97, 116, 111, 98, 111, 111, 115, 116, 46, 110, 101, 116)
end
end
checkConnectivity()
local function generateNonce()
local str = ""
for _ = 1, 16 do str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97) end
return str
end
local function getPlatoLink()
if cachedTime + (10*60) < fOsTime() then
local response, err = safeRequest({
Url = host .. string.char(47, 112, 117, 98, 108, 105, 99, 47, 115, 116, 97, 114, 116),
Method = string.char(80, 79, 83, 84),
Body = lEncode({service = Config.ServiceId, identifier = lDigest(fGetHwid())}),
Headers = {[string.char(67, 111, 110, 116, 101, 110, 116, 45, 84, 121, 112, 101)] = string.char(97, 112, 112, 108, 105, 99, 97, 116, 105, 111, 110, 47, 106, 115, 111, 110)}
})
if response and response.StatusCode == 200 then
local decoded = lDecode(response.Body)
if decoded.success then
cachedLink = decoded.data.url
cachedTime = fOsTime()
return true, cachedLink
end
end
return false, err or string.char(80, 108, 97, 116, 111, 66, 111, 111, 115, 116, 32, 115, 101, 114, 118, 101, 114, 32, 117, 110, 114, 101, 97, 99, 104, 97, 98, 108, 101)
end
return true, cachedLink
end
local function redeemKey(key)
local nonce = generateNonce()
local body = {identifier = lDigest(fGetHwid()), key = key}
if useNonce then body.nonce = nonce end
local response, err = safeRequest({
Url = host .. string.char(47, 112, 117, 98, 108, 105, 99, 47, 114, 101, 100, 101, 101, 109, 47) .. fToString(Config.ServiceId),
Method = string.char(80, 79, 83, 84),
Body = lEncode(body),
Headers = {[string.char(67, 111, 110, 116, 101, 110, 116, 45, 84, 121, 112, 101)] = string.char(97, 112, 112, 108, 105, 99, 97, 116, 105, 111, 110, 47, 106, 115, 111, 110)}
})
if response and response.StatusCode == 200 then
local decoded = lDecode(response.Body)
if decoded.success and decoded.data.valid then
if useNonce then
if decoded.data.hash == lDigest(string.char(116, 114, 117, 101) .. string.char(45) .. nonce .. string.char(45) .. Config.PlatoSecret) then
if writefile then
if makefolder then
pcall(function() makefolder(Config.KeyFolder) end)
end
pcall(function() writefile(Config.KeyFileName, key) end)
end
return true, string.char(83, 117, 99, 99, 101, 115, 115)
end
return false, string.char(82, 101, 115, 112, 111, 110, 115, 101, 32, 73, 110, 116, 101, 103, 114, 105, 116, 121, 32, 67, 104, 101, 99, 107, 32, 70, 97, 105, 108, 101, 100)
end
if writefile then
if makefolder then
pcall(function() makefolder(Config.KeyFolder) end)
end
pcall(function() writefile(Config.KeyFileName, key) end)
end
return true, string.char(83, 117, 99, 99, 101, 115, 115)
end
return false, decoded.message or string.char(73, 110, 118, 97, 108, 105, 100, 32, 75, 101, 121)
end
return false, err or string.char(67, 111, 110, 110, 101, 99, 116, 105, 111, 110, 32, 69, 114, 114, 111, 114)
end
local function StartMainScript()
_G[Config.SecretVariable] = Config.SecretValue
task.spawn(function()
local success, err = pcall(function()
loadstring(game:HttpGet(Config.MainScriptURL))()
end)
if not success then
warn(string.char(70, 97, 105, 108, 101, 100, 32, 116, 111, 32, 108, 111, 97, 100, 32, 114, 101, 100, 105, 114, 101, 99, 116, 111, 114, 32, 115, 99, 114, 105, 112, 116, 58, 32) .. tostring(err))
end
end)
end
function LoadFluentUI(showExpiredNotice)
local Fluent = loadstring(game:HttpGet(string.char(104, 116, 116, 112, 115, 58, 47, 47, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109, 47, 100, 97, 119, 105, 100, 45, 115, 99, 114, 105, 112, 116, 115, 47, 70, 108, 117, 101, 110, 116, 47, 114, 101, 108, 101, 97, 115, 101, 115, 47, 108, 97, 116, 101, 115, 116, 47, 100, 111, 119, 110, 108, 111, 97, 100, 47, 109, 97, 105, 110, 46, 108, 117, 97)))()
local Window = Fluent:CreateWindow({
Title = Config.HubName,
SubTitle = string.char(75, 101, 121, 32, 83, 121, 115, 116, 101, 109),
TabWidth = 140,
Size = UDim2.fromOffset(450, 300),
Acrylic = true,
Theme = string.char(68, 97, 114, 107),
MinimizeKey = Enum.KeyCode.End
})
local Tab = Window:AddTab({ Title = string.char(75, 101, 121, 32, 86, 101, 114, 105, 102, 105, 99, 97, 116, 105, 111, 110), Icon = string.char(107, 101, 121) })
Tab:AddParagraph({
Title = Config.HubName,
Content = Config.HubDescription
})
local enteredKey = ""
Tab:AddInput(string.char(75, 101, 121, 73, 110, 112, 117, 116), {
Title = string.char(69, 110, 116, 101, 114, 32, 75, 101, 121),
Default = "",
Placeholder = string.char(80, 97, 115, 116, 101, 32, 121, 111, 117, 114, 32, 80, 108, 97, 116, 111, 66, 111, 111, 115, 116, 32, 107, 101, 121, 32, 104, 101, 114, 101, 46, 46, 46),
Numeric = false,
Finished = false,
Callback = function(Value)
enteredKey = Value
end
})
Tab:AddButton({
Title = string.char(86, 101, 114, 105, 102, 121, 32, 75, 101, 121),
Description = string.char(65, 117, 116, 104, 101, 110, 116, 105, 99, 97, 116, 101, 115, 32, 121, 111, 117, 114, 32, 107, 101, 121, 32, 97, 110, 100, 32, 108, 111, 97, 100, 115, 32, 116, 104, 101, 32, 115, 99, 114, 105, 112, 116),
Callback = function()
if enteredKey == "" then
Fluent:Notify({
Title = string.char(75, 101, 121, 32, 83, 121, 115, 116, 101, 109),
Content = string.char(80, 108, 101, 97, 115, 101, 32, 101, 110, 116, 101, 114, 32, 97, 32, 107, 101, 121, 32, 102, 105, 114, 115, 116, 33),
Duration = 5
})
return
end
Fluent:Notify({
Title = string.char(75, 101, 121, 32, 83, 121, 115, 116, 101, 109),
Content = string.char(86, 101, 114, 105, 102, 121, 105, 110, 103, 32, 107, 101, 121, 32, 119, 105, 116, 104, 32, 115, 101, 114, 118, 101, 114, 115, 46, 46, 46),
Duration = 3
})
task.spawn(function()
local success, msg = redeemKey(enteredKey)
if success then
Fluent:Notify({
Title = string.char(83, 117, 99, 99, 101, 115, 115),
Content = string.char(75, 101, 121, 32, 118, 101, 114, 105, 102, 105, 101, 100, 33, 32, 76, 111, 97, 100, 105, 110, 103, 32, 85, 110, 105, 118, 101, 114, 115, 97, 108, 32, 83, 117, 110, 32, 72, 117, 98, 46, 46, 46),
Duration = 5
})
task.wait(1)
Window:Destroy()
StartMainScript()
else
Fluent:Notify({
Title = string.char(86, 101, 114, 105, 102, 105, 99, 97, 116, 105, 111, 110, 32, 70, 97, 105, 108, 101, 100),
Content = string.char(69, 114, 114, 111, 114, 58, 32) .. tostring(msg),
Duration = 5
})
end
end)
end
})
Tab:AddButton({
Title = string.char(71, 101, 116, 32, 75, 101, 121, 32, 40, 76, 111, 111, 116, 76, 97, 98, 115, 41),
Description = string.char(67, 111, 112, 105, 101, 115, 32, 116, 104, 101, 32, 76, 111, 111, 116, 76, 97, 98, 115, 32, 108, 105, 110, 107, 32, 116, 111, 32, 99, 111, 109, 112, 108, 101, 116, 101, 32, 99, 104, 101, 99, 107, 112, 111, 105, 110, 116, 115, 32, 102, 111, 114, 32, 97, 32, 107, 101, 121),
Callback = function()
Fluent:Notify({
Title = string.char(75, 101, 121, 32, 83, 121, 115, 116, 101, 109),
Content = string.char(70, 101, 116, 99, 104, 105, 110, 103, 32, 108, 105, 110, 107, 46, 46, 46),
Duration = 3
})
task.spawn(function()
local success, link = getPlatoLink()
if success then
if setclipboard then
setclipboard(link)
Fluent:Notify({
Title = string.char(76, 105, 110, 107, 32, 67, 111, 112, 105, 101, 100),
Content = string.char(76, 111, 111, 116, 76, 97, 98, 115, 32, 107, 101, 121, 32, 108, 105, 110, 107, 32, 99, 111, 112, 105, 101, 100, 32, 116, 111, 32, 121, 111, 117, 114, 32, 99, 108, 105, 112, 98, 111, 97, 114, 100, 33),
Duration = 5
})
else
Fluent:Notify({
Title = string.char(76, 105, 110, 107, 32, 82, 101, 116, 114, 105, 101, 118, 101, 100),
Content = string.char(76, 105, 110, 107, 58, 32) .. tostring(link) .. string.char(32, 40, 67, 108, 105, 112, 98, 111, 97, 114, 100, 32, 110, 111, 116, 32, 115, 117, 112, 112, 111, 114, 116, 101, 100, 41),
Duration = 8
})
end
else
Fluent:Notify({
Title = string.char(69, 114, 114, 111, 114),
Content = string.char(70, 97, 105, 108, 101, 100, 32, 116, 111, 32, 114, 101, 116, 114, 105, 101, 118, 101, 32, 107, 101, 121, 32, 108, 105, 110, 107, 58, 32) .. tostring(link),
Duration = 5
})
end
end)
end
})
if Config.DiscordURL and Config.DiscordURL ~= "" then
Tab:AddButton({
Title = string.char(67, 111, 112, 121, 32, 68, 105, 115, 99, 111, 114, 100, 32, 76, 105, 110, 107),
Description = string.char(74, 111, 105, 110, 32, 116, 104, 101, 32, 99, 111, 109, 109, 117, 110, 105, 116, 121, 32, 68, 105, 115, 99, 111, 114, 100, 32, 115, 101, 114, 118, 101, 114),
Callback = function()
if setclipboard then
setclipboard(Config.DiscordURL)
Fluent:Notify({
Title = string.char(68, 105, 115, 99, 111, 114, 100, 32, 67, 111, 112, 105, 101, 100),
Content = string.char(68, 105, 115, 99, 111, 114, 100, 32, 115, 101, 114, 118, 101, 114, 32, 108, 105, 110, 107, 32, 99, 111, 112, 105, 101, 100, 32, 116, 111, 32, 121, 111, 117, 114, 32, 99, 108, 105, 112, 98, 111, 97, 114, 100, 33),
Duration = 5
})
else
Fluent:Notify({
Title = string.char(68, 105, 115, 99, 111, 114, 100, 32, 73, 110, 118, 105, 116, 101),
Content = Config.DiscordURL,
Duration = 8
})
end
end
})
end
if showExpiredNotice then
task.spawn(function()
task.wait(0.5)
Fluent:Notify({
Title = string.char(75, 101, 121, 32, 69, 120, 112, 105, 114, 101, 100),
Content = string.char(89, 111, 117, 114, 32, 115, 97, 118, 101, 100, 32, 107, 101, 121, 32, 104, 97, 115, 32, 101, 120, 112, 105, 114, 101, 100, 46, 32, 80, 108, 101, 97, 115, 101, 32, 103, 101, 116, 32, 97, 32, 110, 101, 119, 32, 111, 110, 101, 46),
Duration = 6
})
end)
end
end
local isAutoLoggingIn = false
if isfile and isfile(Config.KeyFileName) then
local savedKey = readfile(Config.KeyFileName)
if savedKey and savedKey ~= "" then
isAutoLoggingIn = true
task.spawn(function()
local success, msg = redeemKey(savedKey)
if success then
StartMainScript()
else
isAutoLoggingIn = false
LoadFluentUI(true)
end
end)
end
end
if not isAutoLoggingIn then
LoadFluentUI(false)
end
