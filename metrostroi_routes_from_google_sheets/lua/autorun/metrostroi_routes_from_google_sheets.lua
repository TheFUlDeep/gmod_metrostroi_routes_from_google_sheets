if CLIENT then	
	local Font = CreateClientConVar("metrostroi_routes_font", "Trebuchet24", true)--ScrW() default
	local font = Font:GetString()

	local ypos = CreateClientConVar("metrostroi_routes_ypos", 0, true)--ScrH() default
	local xpos = CreateClientConVar("metrostroi_routes_xpos", 0, true)--ScrW() default
	local xPos = xpos:GetInt()
	local yPos = ypos:GetInt()

	local Alph = CreateClientConVar("metrostroi_routes_alph", 30, true)
	local Alph2 = CreateClientConVar("metrostroi_routes_alph2", 0, true)
	local Alph3 = CreateClientConVar("metrostroi_routes_alph3", 0, true)
	local Alph4 = CreateClientConVar("metrostroi_routes_alph4", 0, true)
	local alph = 255-Alph:GetInt()
	local alph2 = 255-Alph2:GetInt()
	local alph3 = 255-Alph3:GetInt()
	local alph4 = 255-Alph4:GetInt()

	local r1ConVar = CreateClientConVar("metrostroi_routes_r1", 0, true)
	local r2ConVar = CreateClientConVar("metrostroi_routes_r2", 255, true)
	local r3ConVar = CreateClientConVar("metrostroi_routes_r3", 255, true)
	local r4ConVar = CreateClientConVar("metrostroi_routes_r4", 0, true)
	local g1ConVar = CreateClientConVar("metrostroi_routes_g1", 0, true)
	local g2ConVar = CreateClientConVar("metrostroi_routes_g2", 255, true)
	local g3ConVar = CreateClientConVar("metrostroi_routes_g3", 255, true)
	local g4ConVar = CreateClientConVar("metrostroi_routes_g4", 0, true)
	local b1ConVar = CreateClientConVar("metrostroi_routes_b1", 0, true)
	local b2ConVar = CreateClientConVar("metrostroi_routes_b2", 255, true)
	local b3ConVar = CreateClientConVar("metrostroi_routes_b3", 255, true)
	local b4ConVar = CreateClientConVar("metrostroi_routes_b4", 0, true)

	local r1 = r1ConVar:GetInt()
	local r2 = r2ConVar:GetInt()
	local r3 = r3ConVar:GetInt()
	local r4 = r4ConVar:GetInt()
	local g1 = g1ConVar:GetInt()
	local g2 = g2ConVar:GetInt()
	local g3 = g3ConVar:GetInt()
	local g4 = g4ConVar:GetInt()
	local b1 = b1ConVar:GetInt()
	local b2 = b2ConVar:GetInt()
	local b3 = b3ConVar:GetInt()
	local b4 = b4ConVar:GetInt()

	local SecretConVar = CreateClientConVar("metrostroi_routes_secret", 0, true)
	local Secret = SecretConVar:GetFloat()

	local RouteList
	local MaxCols = {}
	local Cols = {}

	local h1,w1
	local function GetW(RowNumber,ColNumber)
		local w = 0
		for i = 1,ColNumber do 
			if i == ColNumber then continue end
			w1,h1 = surface.GetTextSize(MaxCols[i] or "")
			w = w1 + w + 10
		end
		return w
	end

	local function GetH(RowNumber)
		local h2 = 0
		for i = 1, RowNumber do
			local w,h = surface.GetTextSize("")
			h2 = h2 + h
		end
		return h2
	end

	local Maxs = {}
	local Lines = {}
	local function MathLines()
		local sdvig = 5
		Lines = {}
		for i = 1,#RouteList-1 do
			Lines[#Lines+1] = {}
			Lines[#Lines].Start = {}
			Lines[#Lines].End = {}

			Lines[#Lines].Start.x = xPos+GetW(i,1) - sdvig
			Lines[#Lines].Start.y = yPos+GetH(i,1)

			Lines[#Lines].End.x = xPos+Maxs[3] -1 -- - sdvig
			Lines[#Lines].End.y = yPos+GetH(i,#Cols)
		end

		for i = 2,#Cols do
			Lines[#Lines+1] = {}
			Lines[#Lines].Start = {}
			Lines[#Lines].End = {}

			Lines[#Lines].Start.x = xPos+GetW(2,i) - sdvig
			if i == 2 then 
				Lines[#Lines].Start.y = yPos
			else
				Lines[#Lines].Start.y = yPos+GetH(2,i)
			end

			Lines[#Lines].End.x = xPos+GetW(#RouteList,i) - sdvig
			Lines[#Lines].End.y = yPos+GetH(#RouteList,i)
		end
	end

	local StringsPositions = {}
	local function MathStringsPositions()
		print("Math")
		if not RouteList then return end
		surface.SetFont(font)
		xPos = xpos:GetInt()
		yPos = ypos:GetInt()
		--[[alph = 255-Alph:GetInt()
		alph2 = 255-Alph2:GetInt()
		alph3 = 255-Alph3:GetInt()
		alph4 = 255-Alph4:GetInt()
		r1 = r1ConVar:GetInt()
		r2 = r2ConVar:GetInt()
		r3 = r3ConVar:GetInt()
		r4 = r4ConVar:GetInt()
		g1 = g1ConVar:GetInt()
		g2 = g2ConVar:GetInt()
		g3 = g3ConVar:GetInt()
		g4 = g4ConVar:GetInt()
		b1 = b1ConVar:GetInt()
		b2 = b2ConVar:GetInt()
		b3 = b3ConVar:GetInt()
		b4 = b4ConVar:GetInt()

		Secret = SecretConVar:GetFloat()]]
		StringsPositions = {}

		Cols = {}
		for RowNumber,Col in pairs(RouteList) do
			for k,v in pairs(Col) do
				if not Cols[k] then Cols[k] = {} end
				Cols[k][RowNumber] = v
			end
		end

		for RowNumber,Col in pairs(RouteList) do
			for ColNumber,val in pairs(Col) do
				if val == "-" then continue end
				if tonumber(val) and val/10 < 1 then val = "0"..val end
				local XPos = xPos+(GetW(RowNumber,ColNumber) or 0)
				local YPos = yPos+(h1 and h1*RowNumber or 0)-(h1 or 0)
				StringsPositions[#StringsPositions+1] = {}
				StringsPositions[#StringsPositions].val = val
				StringsPositions[#StringsPositions].xpos = XPos
				StringsPositions[#StringsPositions].ypos = YPos
				StringsPositions[#StringsPositions].col = ColNumber
				StringsPositions[#StringsPositions].row = RowNumber
				local w,h = surface.GetTextSize(val)
				StringsPositions[#StringsPositions].w = w
				StringsPositions[#StringsPositions].h = h
				StringsPositions[#StringsPositions].wB = math.abs(StringsPositions[#StringsPositions].xpos-xPos)+w
				StringsPositions[#StringsPositions].hB = math.abs(StringsPositions[#StringsPositions].ypos-yPos)+h
			end
		end

		local MaxX,MaxY
		for _,str in pairs(StringsPositions) do
			if not MaxX or MaxX < str.wB then MaxX = str.wB end
			if not MaxY or MaxY < str.hB then MaxY = str.hB end
		end
		Maxs = {MaxX,MaxY,MaxX,GetH(#RouteList)}

		MathLines()
		--PrintTable(StringsPositions)
	end

	net.Receive( "Metrostroi Routes From Google Sheets", function() 
		local IsChatMessage = net.ReadBool()
		local String = net.ReadString()
		if IsChatMessage then 
			chat.AddText(color_white,String) 
			return
		else
			RouteList = util.JSONToTable(String)
			if not RouteList then return end
		end

		-----FOR DEBUG---------------------------------------------
		--[[RouteList = {}
		RouteList[1] = {"П № 2","Время хода 08:02"}
		RouteList[2] = {"M № 1","Инт 02:00"}
		RouteList[3] = {nil,"Час","Мин","Cек"}
		RouteList[4] = {"Советская",17,27,04}
		RouteList[5] = {"Артемид-ая",17,28,55}
		RouteList[6] = {"Антиколлаб.",17,30,44}
		RouteList[7] = {"Индустриал.",17,32,34}
		RouteList[8] = {"Площадь Восстания",17,35,06}
		RouteList[9] = {"ОТПР."}
		RouteList[10] = {"П. № 12",17,38,06}]]
		-----FOR DEBUG---------------------------------------------

		--PrintTable(RouteList)

		for RowNumber,Col in pairs(RouteList) do
			for k,v in pairs(Col) do
				if not Cols[k] then Cols[k] = {} end
				Cols[k][RowNumber] = v
			end
		end

		Cols = {}
		for RowNumber,Col in pairs(RouteList) do
			for k,v in pairs(Col) do
				if not Cols[k] then Cols[k] = {} end
				Cols[k][RowNumber] = v
			end
		end

		MaxCols = {}
		surface.SetFont(font)
		for ColNumber,Row in pairs(Cols) do
			local Max,MaxStr
			for RowNumber,v in pairs(Row) do
				if RowNumber < 3 and ColNumber ~= 1 then continue end --отвязал первые две строки от сетки
				local v = tostring(v)
				if not Max or Max < surface.GetTextSize(v) then Max = surface.GetTextSize(v) MaxStr = v end
			end
			MaxCols[ColNumber] = MaxStr
		end
		MathStringsPositions()
	end)

	cvars.AddChangeCallback( "metrostroi_routes_font", function(convar,olval,newval)
		if newval:lower():find("%a") then
			font = newval
			MathStringsPositions()
		else
			chat.AddText(color_white,"Нельзя указать пустой шрифт")
		end
	end)

	cvars.AddChangeCallback( "metrostroi_routes_xpos", function(convar,olval,newval)MathStringsPositions()end)
	cvars.AddChangeCallback( "metrostroi_routes_ypos", function(convar,olval,newval)MathStringsPositions()end)
	cvars.AddChangeCallback( "metrostroi_routes_alph", function(convar,olval,newval)alph = 255-newval end)
	cvars.AddChangeCallback( "metrostroi_routes_alph2", function(convar,olval,newval)alph2 = 255-newval end)
	cvars.AddChangeCallback( "metrostroi_routes_alph3", function(convar,olval,newval)alph3 = 255-newval end)
	cvars.AddChangeCallback( "metrostroi_routes_alph4", function(convar,olval,newval)alph4 = 255-newval end)
	cvars.AddChangeCallback( "metrostroi_routes_r1", function(convar,olval,newval)r1 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_r2", function(convar,olval,newval)r2 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_r3", function(convar,olval,newval)r3 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_r4", function(convar,olval,newval)r4 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_g1", function(convar,olval,newval)g1 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_g2", function(convar,olval,newval)g2 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_g3", function(convar,olval,newval)g3 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_g4", function(convar,olval,newval)g4 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_b1", function(convar,olval,newval)b1 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_b2", function(convar,olval,newval)b2 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_b3", function(convar,olval,newval)b3 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_b4", function(convar,olval,newval)b4 = newval end)
	cvars.AddChangeCallback( "metrostroi_routes_secret", function(convar,olval,newval)Secret = newval end)

	hook.Add( "PopulateToolMenu", "Metrostroi Routes Control Panel", function()
		spawnmenu.AddToolMenuOption( "Utilities", "Metrostroi", "metrostroi_client_panel_routes", "Маршрутники", "", "", function(panel)
			panel:ClearControls()
			panel:NumSlider("Расположение по\nгоризонтали","metrostroi_routes_xpos",0, ScrW(),0)
			panel:NumSlider("Расположение по\nвертикали","metrostroi_routes_ypos",0, ScrH(),0)
			panel:TextEntry("Шрифт","metrostroi_routes_font")
			panel:Help("Простые шрифты можно найти здесь: https://wiki.garrysmod.com/page/Default_Fonts")
			panel:TextEntry("Айди таблицы","metrostroi_routes_setid")
			panel:Button("Загрузить таблицу на сервер","metrostroi_routes_load")
			panel:TextEntry("Выдать мрашрут","metrostroi_routes_setroutenumber")
			panel:TextEntry("Выдать \nмрашрутный лист","metrostroi_routes_setlistnumber")
			panel:Button("Выдать следующий мрашрутный лист","metrostroi_routes_next")
			panel:Button("Выдать предыдущий мрашрутный лист","metrostroi_routes_prev")
			panel:Help("\nЦвета:")
			panel:Help("Фон таблицы")
			panel:NumSlider("Красный","metrostroi_routes_r1",0, 255,0)
			panel:NumSlider("Зеленый","metrostroi_routes_g1",0, 255,0)
			panel:NumSlider("Синий","metrostroi_routes_b1",0, 255,0)
			panel:NumSlider("Прозрачность","metrostroi_routes_alph",0, 255,0)
			panel:Help("\nСетка")
			panel:NumSlider("Красный","metrostroi_routes_r2",0, 255,0)
			panel:NumSlider("Зеленый","metrostroi_routes_g2",0, 255,0)
			panel:NumSlider("Синий","metrostroi_routes_b2",0, 255,0)
			panel:NumSlider("Прозрачность","metrostroi_routes_alph2",0, 255,0)
			panel:Help("\nТекст")
			panel:NumSlider("Красный","metrostroi_routes_r3",0, 255,0)
			panel:NumSlider("Зеленый","metrostroi_routes_g3",0, 255,0)
			panel:NumSlider("Синий","metrostroi_routes_b3",0, 255,0)
			panel:NumSlider("Прозрачность","metrostroi_routes_alph3",0, 255,0)
			panel:Help('\nОбводка текста')
			panel:NumSlider("Красный","metrostroi_routes_r4",0, 255,0)
			panel:NumSlider("Зеленый","metrostroi_routes_g4",0, 255,0)
			panel:NumSlider("Синий","metrostroi_routes_b4",0, 255,0)
			panel:NumSlider("Прозрачность","metrostroi_routes_alph4",0, 255,0)
			panel:NumSlider("Секрет","metrostroi_routes_secret",0, 5)
		end)
	end)

	local LastColorUpdate = CurTime()
	hook.Add( "HUDPaint", "Draw Route List", function()
		if not RouteList then return end
		--[[--старый вариант отрисовки
		yPos = ypos:GetInt()
		xPos = xpos:GetInt()

		surface.SetFont(font)
		for RowNumber,Col in pairs(RouteList) do
			for ColNumber,val in pairs(Col) do
				if val == "-" then continue end
				if tonumber(val) and val/10 < 1 then val = "0"..val end
				local XPos = xPos+(GetW(RowNumber,ColNumber) or 0)
				local YPos = yPos+(h1 and h1*RowNumber or 0)-(h1 or 0)
				local w,h = surface.GetTextSize(val)
				draw.RoundedBox( 10, XPos-2, YPos-1,w+5,h, Color(0, 0, 0, 150))
				draw.SimpleText( val, font, XPos, YPos, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP )
			end
		end
		]]
		local Secret1 = tonumber(Secret)
		if Secret1 and Secret1 > 0 then
			if CurTime() - LastColorUpdate > Secret1 then
				LastColorUpdate = CurTime()
				Alph:SetInt(math.random(0,255))
				Alph2:SetInt(math.random(0,255))
				Alph3:SetInt(math.random(0,255))
				Alph4:SetInt(math.random(0,255))

				r1ConVar:SetInt(math.random(0,255))
				r2ConVar:SetInt(math.random(0,255))
				r3ConVar:SetInt(math.random(0,255))
				r4ConVar:SetInt(math.random(0,255))

				g1ConVar:SetInt(math.random(0,255))
				g2ConVar:SetInt(math.random(0,255))
				g3ConVar:SetInt(math.random(0,255))
				g4ConVar:SetInt(math.random(0,255))

				b1ConVar:SetInt(math.random(0,255))
				b2ConVar:SetInt(math.random(0,255))
				b3ConVar:SetInt(math.random(0,255))
				b4ConVar:SetInt(math.random(0,255))
			end
		end

		--1 - фон, 2 - сетка, 3 - текст, 4 - фон текста
		surface.SetFont(font)
		draw.RoundedBox( 0, xPos, yPos,Maxs[3] or 0,Maxs[4] or 0, Color(r1,g1,b1,alph))
		surface.SetDrawColor(Color(r2,g2,b2,alph2))
		for _,line in pairs(Lines) do
			surface.DrawLine( line.Start.x, line.Start.y, line.End.x , line.End.y )
		end
		for k,str in pairs(StringsPositions) do
			--print(xPos, yPos,StringsPositions[#StringsPositions].wB,StringsPositions[#StringsPositions].hB)
			--draw.SimpleText( str.val, font, str.xpos, str.ypos, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP )
			draw.SimpleTextOutlined( str.val, font, str.xpos, str.ypos, Color( r3, g3, b3, alph3), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(r4,g4,b4,alph4) )
		end
	end)
end

if CLIENT then return end
util.AddNetworkString("Metrostroi Routes From Google Sheets")

local function SendChatMessageOrTbl(ply,IsChatMessage,str)
	net.Start("Metrostroi Routes From Google Sheets")
		net.WriteBool(IsChatMessage)
		net.WriteString(str)
	if ply and ply:IsValid() then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

local id = file.Read("google_sheets_url_for_metrostroi_routes.txt") or ""
local url = "https://spreadsheets.google.com/feeds/worksheets/"..id.."/public/basic?alt=json"

if not Metrostroi then Metrostroi = {} end--сделал их глобальными, чтобы при перезапуске скрипта таблицы не очищались
if not Metrostroi.MetrostroiRoutes then Metrostroi.MetrostroiRoutes = {} end
if not Metrostroi.MetrostroiRoutes.RoutesTbl then Metrostroi.MetrostroiRoutes.RoutesTbl = {} end
if not Metrostroi.MetrostroiRoutes.DocTbl then Metrostroi.MetrostroiRoutes.DocTbl = {} end
if not Metrostroi.MetrostroiRoutes.SavedRoutes then Metrostroi.MetrostroiRoutes.SavedRoutes = {} end
--local Metrostroi.MetrostroiRoutes.RoutesTbl = {}
--local Metrostroi.MetrostroiRoutes.DocTbl = {}
--local Metrostroi.MetrostroiRoutes.SavedRoutes = {}

local function AllValuesIsEmpty(values)
	for _,v in pairs(values) do
		if v ~= "-" then return false end
	end
	return true
end

local function SendRouteList(ply,routenumber,listnumber,targetply)
	local SteamID = targetply:SteamID()
	local Nick = ply and ply:IsValid() and ply:Nick() or "Console"
	Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID] = {}
	if not Metrostroi.MetrostroiRoutes.RoutesTbl[routenumber] or not Metrostroi.MetrostroiRoutes.RoutesTbl[routenumber][listnumber] then
		SendChatMessageOrTbl(targetply,false,"")
		SendChatMessageOrTbl(nil,true,Nick.." забрал маршрутный лист у игрока "..targetply:Nick())
		Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber = routenumber
		return
	end
	SendChatMessageOrTbl(targetply,false,util.TableToJSON(Metrostroi.MetrostroiRoutes.RoutesTbl[routenumber][listnumber]))
	SendChatMessageOrTbl(nil,true,Nick.." выдал игроку "..targetply:Nick().." маршрутный лист номер "..listnumber)
	Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID] = {}
	Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber = routenumber
	Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber = listnumber
end

local function CreateRoutesTbl()
	Metrostroi.MetrostroiRoutes.RoutesTbl = {}
	--PrintTable(Metrostroi.MetrostroiRoutes.DocTbl)
	local Matrix = {}
	for RouteNumber,RouteTbl in pairs(Metrostroi.MetrostroiRoutes.DocTbl) do
		local RouteNumber = tonumber(RouteNumber)
		if not RouteNumber then continue end
		if not Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber] then Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber] = {} end
		if not RouteTbl.table or not RouteTbl.table.rows or not RouteTbl.table.cols then continue end
		if not Matrix[RouteNumber] then Matrix[RouteNumber] = {} end
		--[[if not Matrix[RouteNumber][1] then	--тут утсновка хедеров, но я от них избавился
			 Matrix[RouteNumber][1] = {}
		end
		for ColNumber,ColTbl in pairs(RouteTbl.table.cols) do
			if not ColTbl.label then continue end
			ColNumber = tonumber(ColNumber)
			if not ColNumber then continue end
			Matrix[RouteNumber][1][ColNumber] = ColTbl.label
		end]]

		for LineNumber,LineTbl in pairs(RouteTbl.table.rows) do
			if not LineTbl.c then continue end
			LineNumber = tonumber(LineNumber)
			if not LineNumber then continue end
			if not Matrix[RouteNumber][LineNumber--[[+1]]] then Matrix[RouteNumber][LineNumber--[[+1]]] = {} end
			for num,val in pairs(LineTbl.c) do
				num = tonumber(num)
				if not num then continue end	
				--print(val.v or val.f,LineNumber)
				Matrix[RouteNumber][LineNumber--[[+1]]][num] = val.v
			end
		end
	end
	
	local Lists = {}
	for RouteNumber,Row in pairs(Matrix) do
		for RowNumber,vals in pairs(Row) do
			if AllValuesIsEmpty(vals) and Row[RowNumber+1] and AllValuesIsEmpty(Row[RowNumber+1]) then
				if not Lists[RouteNumber] then Lists[RouteNumber] = {} end
				local ListsCount = #Lists[RouteNumber]+1
				if not Lists[RouteNumber][ListsCount] then Lists[RouteNumber][ListsCount] = {} end
				Lists[RouteNumber][ListsCount].End = RowNumber-1
				if not Lists[RouteNumber][ListsCount+1] then Lists[RouteNumber][ListsCount+1] = {} end
				Lists[RouteNumber][ListsCount+1].Start = Row[RowNumber+2] and RowNumber+2 or nil
			end
		end
	end
	--PrintTable(Matrix)

	for RouteNumber,matrix in pairs(Matrix) do
		if not istable(matrix) then continue end
		if not Lists[RouteNumber] then continue end
		if not Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber] then Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber] = {} end
		for i = 1,#Lists[RouteNumber] do
			if not Lists[RouteNumber][i] then continue end
			for k = Lists[RouteNumber][i].Start or 1,Lists[RouteNumber][i].End or #matrix do--k - номер строки, i - номер листа
				if not matrix[k] then continue end
				if not Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber][i] then Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber][i] = {} end
				Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber][i][#Metrostroi.MetrostroiRoutes.RoutesTbl[RouteNumber][i]+1] = matrix[k]
			end
		end
	end
	--PrintTable(Metrostroi.MetrostroiRoutes.RoutesTbl)
	--если кому-то уже выдан лист, то обновить его ( то есть завного отправить )
	for _,ply in pairs(player.GetHumans()) do
		local SteamID = ply:SteamID()
		if Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID] and Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber and Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber then
			SendRouteList(nil,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber,ply)
		end
	end

end

local function GetPage(url,listname,ply)
	http.Fetch( 
		url, 
		function(body,size,headers,number)
			if not body or not body:find("%a") then 
				if ply and ply:IsValid() then
					SendChatMessageOrTbl(ply,true,"Ошибка при получении страницы.")
				else
					print("Ошибка при получении страницы. Страница пуста.")
				end				
				
				return 
			end
			local start = body:find("{",1,true)
			if start then body = string.sub(body,start,-3) end
			body = util.JSONToTable(body)
			if not body then 
				if ply and ply:IsValid() then
					SendChatMessageOrTbl(ply,true,"Ошибка при получении страницы.")
				else
					print("Ошибка при получении страницы. Body is not json.")
				end				
				
				return 
			end
			Metrostroi.MetrostroiRoutes.DocTbl[listname] = body
			CreateRoutesTbl()
			--PrintTable(body)
		end,
		function(error)
			print("HTTP ERROR!")
			print(error)
		end
	)
end

local function GetDocInfo(url,ply)
	Metrostroi.MetrostroiRoutes.DocTbl = {}
	if not id or not id:lower():find("%a") then 
		if ply and ply:IsValid() then
			SendChatMessageOrTbl(ply,true,"Невозможно получить таблицу, так как не указан ID.")
		else
			print("Невозможно получить таблицу, так как не указан ID.")
		end
		return
	end
	http.Fetch( 
		url, 
		function(body,size,headers,number)
			if not body or not body:find("%a") then 
				if ply and ply:IsValid() then
					SendChatMessageOrTbl(ply,true,"Ошибка при получении страницы.")
				else
					print("Ошибка при получении страницы. Страница пуста.")
				end				
				
				return 
			end
			body = util.JSONToTable(body)
			if not body then 
				if ply and ply:IsValid() then
					SendChatMessageOrTbl(ply,true,"Ошибка при получении таблицы.")
				else
					print("Ошибка при получении таблицы. Body is not json.")
				end				
				
				return 
			end
			if body.feed and body.feed.entry and istable(body.feed.entry) then
				for k,v in pairs(body.feed.entry) do
					if v.link and v.link[3] and v.link[3].href and v.content and v.content["$t"] then
						GetPage(v.link[3].href,v.content["$t"],ply)
					end
				end
			end
			--PrintTable(body)
		end,
		function(error)
			print("HTTP ERROR!")
			print(error)
		end
	)
end

--FOR DEBUG START---------------------------------------------------------------------------------------------
--print(url)
--GetDocInfo(url)
--PrintTable(Metrostroi.MetrostroiRoutes.DocTbl["1"])
--CreateRoutesTbl()
--PrintTable(Metrostroi.MetrostroiRoutes.RoutesTbl)
--FOR DEBUG END------------------------------------------------------------------------------------------------

concommand.Add("metrostroi_routes_setid", 
	function(ply,cmd,args,argStr)
		if ply and ply:IsValid() then
			if ply.MetrostroiRouteLastUsage and os.time() - ply.MetrostroiRouteLastUsage < 1 then return end
			ply.MetrostroiRouteLastUsage = os.time()

			if not ply:IsSuperAdmin() then 
				net.Start("Metrostroi Routes From Google Sheets")
					net.WriteBool(true)--true, если сообщение в чат
					net.WriteString("Ты не суперадмин, поэтому не можешь пользоваться этой командой.")
				net.Send(ply)
				return 
			end
		end
		
		argStr = argStr:gsub(" ","")
		if argStr:sub(1,1) == '"' and argStr:sub(-1,-1) == '"' then argStr = argStr:sub(2,-2) end
		if id == argStr then 
			if ply and ply:IsValid() then
				SendChatMessageOrTbl(ply,true,"Данный ID уже указан.")
			else
				print("Данный ID уже указан.")
			end
			return 
		end
		id = argStr
		url = "https://spreadsheets.google.com/feeds/worksheets/"..argStr.."/public/basic?alt=json"
		file.Write("google_sheets_url_for_metrostroi_routes.txt",argStr)
	end
)

concommand.Add("metrostroi_routes_load", function(ply,cmd,args,argStr)
	if ply and  ply:IsValid() and not ply:IsSuperAdmin() then 
		SendChatMessageOrTbl(ply,true,"Ты не суперадмин, поэтому не можешь пользоваться этой командой.")
		return 
	end
	
	GetDocInfo(url,ply)
end)

local function GetNearPlayers(ply)
	local distlimit = 500
	local plypos = ply:GetPos()
	local plys = {}
	for _,v in pairs(player.GetHumans()) do
		if v == ply then continue end --пропуск самого себя
		if v:GetPos():DistToSqr(plypos) <= distlimit*distlimit then
		 plys[#plys+1] = v
		end
	end
	return plys
end

local function SetRouteNumber(ply,cmd,args,argStr,typ)
	if argStr and argStr:sub(1,1) == '"' and argStr:sub(-1,-1) == '"' then argStr = argStr:sub(2,-2) end
	if not ply or not ply:IsValid() then print("Эту команду можно выполнить только от игрока на клиенете.") return end

	if ply.MetrostroiRouteLastUsage and os.time() - ply.MetrostroiRouteLastUsage < 1 then return end
	ply.MetrostroiRouteLastUsage = os.time()

	local TargetPlys = GetNearPlayers(ply)
	if #TargetPlys < 1 then SendChatMessageOrTbl(ply,true,"Игроков по близости не найдено") return end
	
	if (typ == "route" or typ == "set") and not tonumber(argStr) then
		SendChatMessageOrTbl(ply,true,"Введено некорректное число.")
		return
	end
	
	if typ ~= "route" then
		for _,TargetPly in pairs(TargetPlys) do
			local SteamID = TargetPly:SteamID()
			if not Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID] or not Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber then
				local str = "У игрока "..TargetPly:Nick().." не установлен номер маршрута. Выдать маршрутный лист невозможно."
				SendChatMessageOrTbl(ply,true,str)
				SendChatMessageOrTbl(TargetPly,true,str)
				continue
			end
			
			if typ ~= "set" then
				if not Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber then
					local val
					if typ == "next" then val = 1 else val = #Metrostroi.MetrostroiRoutes.RoutesTbl[Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber] end
					SendRouteList(ply,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber,val,TargetPly)
				else
					local inc
					if typ == "next" then inc = 1 else inc = -1 end
					SendRouteList(ply,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber+inc,TargetPly)
				end
			else
				SendRouteList(ply,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber,tonumber(argStr),TargetPly)
			end
		end
	else
		for _,TargetPly in pairs(TargetPlys) do
			local SteamID = TargetPly:SteamID()
			SendChatMessageOrTbl(nil,true,ply:Nick().." установил игроку "..TargetPly:Nick().." маршрут номер "..tonumber(argStr))
			SendRouteList(ply,tonumber(argStr),0,TargetPly)
		end
	end
end

concommand.Add("metrostroi_routes_next", function(ply,cmd,args,argStr)
	SetRouteNumber(ply,cmd,args,argStr,"next")
end)

concommand.Add("metrostroi_routes_prev", function(ply,cmd,args,argStr)
	SetRouteNumber(ply,cmd,args,argStr,"prev")
end)

concommand.Add("metrostroi_routes_setlistnumber", function(ply,cmd,args,argStr)
	SetRouteNumber(ply,cmd,args,argStr,"set")	
end)

concommand.Add("metrostroi_routes_setroutenumber", function(ply,cmd,args,argStr)
	SetRouteNumber(ply,cmd,args,argStr,"route")
end)

hook.Add("PlayerInitialSpawn","Load Saved Metrostroi RouteList",function(ply)
	local SteamID = ply:SteamID()
	if Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID] and Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber and Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber then
		SendRouteList(nil,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].RouteNumber,Metrostroi.MetrostroiRoutes.SavedRoutes[SteamID].ListNumber,ply)
	end
end)

GetDocInfo(url)--маршрутники будут качаться сразу при запуске сервера