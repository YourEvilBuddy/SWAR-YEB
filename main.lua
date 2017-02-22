-- =========
-- Settings
-- =========
localPath = scriptPath()
--Language Detection
--language = detectLanguage("cancelWord.", {"en", "zh", "ko"})
--language = getLanguage()
language = "en"
imgPath = localPath.."images"
dofile(localPath.."lib/commonLib.lua")
dofile(localPath.."lib/images.lua")
appUsableSize = getAppUsableScreenSize()
toast ("CompareDimension" .. appUsableSize:getX() .. " x " .. appUsableSize:getY())
print ("CompareDimension" .. appUsableSize:getX() .. " x " .. appUsableSize:getY())
Settings:setScriptDimension(true, 2560)
Settings:setCompareDimension(true, appUsableSize:getX())
Settings:set("MinSimilarity", 0.90)
setImmersiveMode(false)

-- =========
-- Variables
-- =========
AMonMax = 0
filenamecount = 0
monsterRepCount = 0
arenaRepCount = 0
arenaLvlCount = 0
arenaEmptyCount = 0
arenaMain = 0
arenaExe = 1
swipeCount = 0
roundcount = 0
rstars = 0
rslot = 0
rrarity = 0
rprime = 0
rsub = 0
varRun = 0
varDeath = 0
varKeep = 0
levelSelect = ""

--Region Update Flags
battleFigRegFlag = 0
victoryDiamondRegFlag = 0
worldMapRegFlag = 0
bigFlashRegFlag = 0
arenaBigWingRegFlag = 0
arenaResultsRegFlag = 0
bigCancalRegFlag = 0

-- ========================
-- Graphical User Interface
-- ========================
-- == Resolution & StartScreen ==
dialogInit()
-- Spinners
spinnerRes = {"2560x1600", "2560x1440", "1920", "1280", "960"}
spinnerStartscreen = {"Arena Battle Start Screen","PvE Battle Start Screen", "Either Start Screen", "Arena Battle Selection Window"}
-- GUI
addTextView("  ") addTextView("Resolution: ") addSpinnerIndex("setRes", spinnerRes, "2560x1440")
newRow()
addTextView("  ") addTextView("StartScreen: ") addSpinnerIndex("startScreen", spinnerStartscreen, "PvE Battle Start Screem")
dialogShow("Dimension Search Reference")

-- Resolution of images and compareDimension
if (setRes) == 1 then
	dofile(localPath.."lib/regions_2560x1600.lua")
	imgPath = imgPath.."/2560x1600"
	setImagePath(imgPath)
elseif (setRes) == 2 then
	dofile(localPath.."lib/regions_2560x1440.lua")
	imgPath = imgPath.."/2560x1440"
	setImagePath(imgPath)
elseif (setRes) == 3 then
	dimension = math.floor(dimension*0.75)
	Settings:setCompareDimension(true, dimension)
	imgPath = imgPath.."/1920"
	setImagePath(imgPath)
elseif (setRes) == 3 then
	dimension = math.floor(dimension*0.5)
	Settings:setCompareDimension(true, dimension)
	imgPath = imgPath.."/1280"
	setImagePath(imgPath)
elseif (setRes) == 4 then
	dimension = math.floor(dimension*0.375)
	Settings:setCompareDimension(true, dimension)
	imgPath = imgPath.."/960"
	setImagePath(imgPath)
end

-- Search image for autoResize
if startScreen == 1 then
	searchImage = arenaBigWing
elseif startScreen == 2 then
	searchImage = bigFlash
elseif startScreen == 3 then
	searchImage = bigCancel
elseif startScreen == 4 then
	searchImage = cancelRefill
end

dimension = autoResize(Pattern(searchImage):similar(0.95), 2560, false)

if dimension < 0 then
	simpleDialog("Error", "cannot find correct compare dimension")
	return
end
toast (""..dimension)

-- == Configuration ==
dialogInit()
-- Spinners
spinnerStars = {"1 Star", "2 Star", "3 Star", "4 Star", "5 Star", "6 Star"}
spinnerRarity = {"Common", "Magic", "Rare", "Hero", "Legend" }
spinnerSubCent = {"25%", "33%", "50%", "66%", "75%", "100%" }
-- TODO: Complete the rest
spinnerAreaReturn = {
	"Giant's Keep",
	"Dragon's Lair",
	"Necropolis",
	"Hall of Light",
	"Hall of Dark",
	"Hall of Fire",
	"Hall of Water",
	"Hall of Wind",
	"Hall of Magic",
	"Trial of Ascension",
	"Rift of Worlds",
	"Arena",
	"World Boss",
	"Garen Forest",
	"Mt. Siz",
	"Mt. White Ragon",
	"Kabir Ruins",
	"Talain Forest",
	"Hydeni Ruins",
	"Tamor Desert",
	"Vrofagus Ruins",
	"Faimon Volcano",
	"Aiden Forest",
	"Ferun Castle",
	"Mt. Runar",
	"Chiruka Remains"}
spinnerLevel = {"1","2","3","4","5","6","7","8","9","10" }
spinnerDiff = {	"Normal","Hard","Hell"}

-- GUI
addTextView("------------------------------Area Farm Configuration---------------------------------")newRow()
addSpinnerIndex("AreaSelection", spinnerAreaReturn, "Garen Forest") addSpinnerIndex("diffSelection", spinnerDiff, "Hell") addTextView(" Lvl: ")  addSpinnerIndex("levelSelection", spinnerLevel, "1") newRow()
addTextView("-----------------------------Scenario Max Lv. Auto Swap---------------------------")newRow()
addCheckBox("SwapMaxTop","Top",false) addCheckBox("SwapMaxLeft","Left",false) addCheckBox("SwapMaxRight","Right",false) addCheckBox("SwapMaxBottom","Bottom",false)        newRow()newRow()
addTextView("-------------------------------------------------------------------------------------------------------")newRow()
addCheckBox("debugAll", "Debug ", false) addCheckBox("nextArea", "Next Area", false) addCheckBox("sellRune", "Sell Runes ", false)    newRow()

addTextView("-----------------------------------Arena Configuration-----------------------------------")newRow()
addCheckBox("arenaFarm", "Arena Farming", false)newRow()
addTextView("Arena Check Frequency [Mins]") addEditNumber("arenaTimeFreq", 60) newRow()
addTextView("Max # of Enemies") addEditNumber("ArenaMaxMon", 1) newRow()
addTextView("Max Avg Level of Enemies") addEditNumber("ArenaMaxAvgLvl", 40) newRow()
addTextView("--------------------------Rune Evaluation Configuration----------------------------")newRow()
addCheckBox("CBRuneEval", "Evalu Runes: ", false) addCheckBox("CBRuneEvalStar", "Stars", false) addCheckBox("CBRuneEvalRarity", "Rarity", false) addCheckBox("CBRuneEvalPrimary", "Prime", false) addCheckBox("CBRuneEvalSubCent", "SubS", false) newRow()
addTextView("---------------------------Primary Stat Configuration--------------------------------")newRow()
addCheckBox("runePrimeHP", "HP ", true) addCheckBox("runePrimeATK", "ATK ", true) addCheckBox("runePrimeDEF", "DEF ", true) addCheckBox("runePrimeSPD", "SPD ", true) addCheckBox("runePrimeCRIRate", "CRI Rate", true) newRow()
addCheckBox("runePrimeCRIDmg", "CRI Dmg ", true) addCheckBox("runePrimeRES", "RES ", true)addCheckBox("runePrimeACC", "ACC ", true) newRow()

addSpinnerIndex("runeStars", spinnerStars, "5 Star") addSpinnerIndex("runeRarity", spinnerRarity, "Rare") addSpinnerIndex("runeSubCentage", spinnerSubCent, "25%") addTextView("Sub Stats as %") newRow()
addTextView("-------------------------------------------------------------------------------------------------------")newRow()
addCheckBox("refillEnergy", "Refill Energy with Crystal", false) addCheckBox("refillWings", "Refill Wings with Crystal", false)       newRow()

addTextView("-------------------------------------------------------------------------------------------------------")newRow()

dimString = "Dim While Running"
addCheckBox("vibe", "Enable Vibrate", true) addCheckBox("dim", dimString, true) newRow()

dialogShowFullScreen("SWAR X v0.9 Configuration")
--Dim Screen
if (dim) then
	setBrightness(1)
end

-- =========================
-- SWAR-X specific Functions
-- =========================
function keyNum()
	local preMinSimilarity = Settings:get("MinSimilarity")
	Settings:set("MinSimilarity", 0.7)
	local anchor = bottomLeft:wait("slash.png")
	local numRegion = Region(anchor:getX() - 110, anchor:getY(), 110, anchor:getH())
	if debugAll == true then numRegion:highlight(1) end
	local num = numberOCRNoFindException(numRegion, "vFlash")
	Settings:set("MinSimilarity", preMinSimilarity)
end
function clickButton(target, num)
	if debugAll == true then toast("[Function] clickButton") end
	if (exists(target,4)) then
		if debugAll == true then toast("button found") end
		local allButton = findAll(target)
		local sortFunc = function(a, b) return (a:getX() < b:getX()) end
		table.sort(allButton, sortFunc)
		if debugAll == true then allButton[num]:highlight(1) end
		allButton[num]:setTargetOffset(37,0)
		click(allButton[num])
		--    else
		--        toast("sellButton not found")
	end
end
function refillEnergy()
	if debugAll == true then toast("[Function] refillEnergy") end

	clickButton(sellButton, 1)
	rechargeEnergy:waitClick(rechargeFlash, 3)
	wait(2)
	clickButton(sellButton, 1)
	upperRight:exists(cancelRefill, 5)
	wait(1)
	keyevent(4) -- back
	keyevent(4)
	wait(1)
end
function refillArena()
	if debugAll == true then toast("[Function] refillArena") end
	clickButton(sellButton, 1)
	rechargeEnergy:waitClick(rechargeWing, 3)
	wait(2)
	clickButton(sellButton, 1)--Yes button
	okenReg:existsClick(ok)
	upperRight:exists(bigCancel, 5)--the cancel is diffrent
	areaGoTo(areaArena)
end
function ripairs(t)
	if debugAll == true then toast("[Function] ripairs") end
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end

function multiCancel()
	if debugAll == true then toast("[Function] multiCancel") end
	local rewardEnd, match = waitMultiReg(cancelList,45, false ,cancelRegList)
	if (rewardEnd == nil) then
		toast("nil use BackUp [multiCancel]")
		local rewardEnd, match = waitMulti(cancelList,45,false)
	elseif (rewardEnd == -1) then
		toast("-1 use BackUp [multiCancel]")
		local rewardEnd, match = waitMulti(cancelList,45,false)
	end
	if (rewardEnd == nil) then
		toast("rewardEnd returned nil [multiCancel]")
	elseif (rewardEnd == -1) then
		toast("rewardEnd returned -1 [multiCancel]")
	elseif (rewardEnd == 1) then --Yes Button
		if debugAll == true then toast("Yes Button [multiCancel]") end
		click(match)
	elseif (rewardEnd == 2) then --Cancel2
		if debugAll == true then toast("Cancel2 [multiCancel]") end
		if debugAll == true then local CancelHigh = match:getCenter() local CancelHighlight = Region(CancelHigh:getX() + 4, CancelHigh:getY() - 106 , 5, 5) CancelHighlight:highlight(5) end
		click(match)
	elseif (rewardEnd == 3) then --Cancel Long
		if debugAll == true then toast("Cancel Long [multiCancel]") end
		if debugAll == true then local CancelHigh = match:getCenter() local CancelHighlight = Region(CancelHigh:getX() + 108, CancelHigh:getY() + 17 , 5, 5) CancelHighlight:highlight(5) end
		click(match)
	elseif (rewardEnd == 4) then --Cancel
		if debugAll == true then toast("Cancel Button[multiCancel]") end
		click(match)
	elseif (rewardEnd == 5) then --Cancel Refill Button
		if debugAll == true then toast("Cancel Button [multiCancel]") end
		click(match)
	elseif (rewardEnd == 6) then --Ok Button
		if debugAll == true then toast("Ok Button[multiCancel]") end
		click(match)
	else
		if debugAll == true then toast("Unknown [multiCancel]") end
	end
end
function arenaRefresh()
	if debugAll == true then toast("[Function] arenaRefresh") end
	arenaRefreshReg:existsClick(arenaRefresh, 0)
	arenaRefreshListReg:existsClick(arenaRefreshList, 0)
	wait(2)
	while true do
		if arenaRefreshWaitReg:exists(arenaRefreshWait, 0) then
		wait(2)
		arenaRefreshListReg:existsClick(arenaRefreshList, 0)
		else
			break
		end

	end
end
function checkPlayAndPause()
	if debugAll == true then toast("[Function] checkPlayAndPause") end
	if debugAll == true then playReg:highlight(1) end
	playReg:existsClick(play,0)
	if debugAll == true then pauseReg:highlight(1) end
	pauseReg:existsClick(pause, 0)
end
function checkIfMax()
	if debugAll == true then toast("[Function] checkIfMax") end
	for i, Reg in ipairs(RegionMatchEXP) do
		if (i == 1) then usePreviousSnap(false) else usePreviousSnap(true) end
		if AMonMax == 1 then click(Location(1320,720)) break end
		if debugAll == true then Reg:highlight(2) end
		if Reg:exists(expBarMax, 0) then
			getLastMatch():highlight(.25)
			AMonMax = 1
		else
			AMonMax = 2
		end
	end
	usePreviousSnap(false)
	click(Location(1320,720))
end
function freshFodderLevel(slot)
	if debugAll == true then toast("[Function] freshFodderLevel") end
	local pFood = Region(slot:getX() + 110, slot:getY() + 185 , 130, 100)                             					 if debugAll == true then pFood:highlight(2) end
	local pFoodClick = Location(pFood:getX(), pFood:getY())

	local preMinSimilarity = Settings:get("MinSimilarity")
	Settings:set("MinSimilarity", 0.65) --works with issues at .7, .75 misses many monsters
	local lv, lvfound = numberOCRNoFindException(pFood,"LowLv")                                      					  if debugAll == true then  pFood:highlight(tostring(lv),2) end
	Settings:set("MinSimilarity", preMinSimilarity)
	return lv, lvfound, pFoodClick
end
function monsterLevelCheck()
	if debugAll == true then toast("[Function] monsterLevelCheck") end
	for _, Reg in ipairs(RegionMatch) do
		if (i == 1) then usePreviousSnap(false) else usePreviousSnap(true) end
		local newReg = Region(Reg:getX() + 152,Reg:getY() + 184,Reg:getW() - 160,Reg:getH() - 184)
		-- local Stars = Region(Reg:getX(),Reg:getY(),90,90)
		local lv = numberOCRNoFindException(newReg,"lvl")
		if debugAll == true then newReg:highlight(tostring(lv),.5) end
		local numStar = existsMultiMaxSnap(Reg,{oneStar, twoStar, threeStar, fourStar, fiveStar, sixStar, emptyMon})
		if (numStar == -1) then toast("Unknown Error") elseif numStar == 7 then toast("Slot Empty Why Are we Testing This?") end
		if debugAll == true then toast(numStar.." Star Monster") end
		if debugAll == true then Reg:highlight(1) end
		if lv == 15 and numStar == 1  then click(Location(Reg:getX() + 145, Reg:getY() + 145)) monsterRepCount = monsterRepCount + 1
		elseif lv == 20 and numStar == 2 then click(Location(Reg:getX() + 145, Reg:getY() + 145)) monsterRepCount = monsterRepCount + 1
		elseif lv == 25 and numStar == 3 then click(Location(Reg:getX() + 145, Reg:getY() + 145)) monsterRepCount = monsterRepCount + 1
		elseif lv == 30 and numStar == 4 then click(Location(Reg:getX() + 145, Reg:getY() + 145)) monsterRepCount = monsterRepCount + 1
		elseif lv == 35 and numStar == 5 then click(Location(Reg:getX() + 145, Reg:getY() + 145)) monsterRepCount = monsterRepCount + 1
		elseif lv == 40 and numStar == 6 then click(Location(Reg:getX() + 145, Reg:getY() + 145)) monsterRepCount = monsterRepCount + 1
		elseif numStar == 7 then toast("Slot is empty fill with monster") monsterRepCount = monsterRepCount + 1
		else   toast("The Monster Is NOT Max Level Yet.")
		end
	end
	usePreviousSnap(false)
end
function arenaLevelCheck()
	if debugAll == true then toast("[Function] arenaLevelCheck") end
	arenaLvlCount = 0
	arenaRepCount = 0
	arenaEmptyCount = 0
	for _, Reg in ipairs(arenaRegionMatch) do
		if (i == 1) then usePreviousSnap(false) else usePreviousSnap(true) end
		local newReg = Region(Reg:getX() + 152,Reg:getY() + 184,Reg:getW() - 160,Reg:getH() - 184)
		-- local Stars = Region(Reg:getX(),Reg:getY(),90,90)
		local lv = numberOCRNoFindException(newReg,"lvl")
		if debugAll == true then newReg:highlight(tostring(lv),.5) end
		local numStar = existsMultiMaxSnap(Reg,{oneStar, twoStar, threeStar, fourStar, fiveStar, sixStar, arenaEmptyMon})
		if (numStar == -1) then toast("Unknown Error") elseif numStar == 7 then toast("Slot Empty") end
		if debugAll == true and numStar <= 6 then toast(numStar.." Star Monster") end
		if debugAll == true then Reg:highlight(1) end
		arenaLvlCount = arenaLvlCount + lv
		if numStar >= 1 and numStar <= 6 then arenaRepCount = arenaRepCount + 1
		elseif numStar == 7 then toast("Slot is empty") arenaEmptyCount = arenaEmptyCount + 1
		else   toast("Unknown Error(ArenaLevelCheck-Stars")
		end
	end
	usePreviousSnap(false)
end
function SwapMaxfood()
	if debugAll == true then toast("[Function] swapMaxFood") end
	if find(bigCancel) then
		if AMonMax == 1 then
			AMonMax = 0
			monsterLevelCheck()
			while not EndofMonL:exists(endOfMonList, 0) do
				swipe(Location(1660,1000),Location(120,1000))
			end
			wait(1)
		while monsterRepCount > 0 do
				local abort = 20
						if debugAll == true then NewFodder:highlight(1) end
						local FodderList = listToTable(NewFodder:findAll(fodderAnchor))
						local tCount = tableLength(FodderList)
						if debugAll == true then toast(tCount..": Archor's Found") end
						for i, slot in ripairs(FodderList) do
							if (i == 1) then usePreviousSnap(false) else usePreviousSnap(true) end
							local lv, lvfound, pFoodClick = freshFodderLevel(slot)
							if lv <= 14  and lvfound == true then click(pFoodClick) monsterRepCount = monsterRepCount - 1
								if monsterRepCount <= 0 then monsterLevelCheck() end
								if monsterRepCount <= 0 then break end
							elseif i >= tCount then
								swipe(Location(120,1000),Location(1660,1000))
								abort = abort - 1
								wait(1)
							end
						end
						usePreviousSnap(false)
						if abort <= 1 then
							break
						end
			end
		else
			toast("Called Outside of expected Time Frame!, XXXX")
		end
	end
end
function runeStarEval()
	if debugAll == true then toast("[Function] runeStarEval") end
	local starFind = listToTable(runeStarRegion:findAll(runeStar))
	local starCount = tableLength(starFind)
	if runeStarRegion:exists(Pattern(runeStarWord):similar(.9), 3) then
		rstars = starCount
		if debugAll == true then runeStarsRegionD:highlight(tostring(starCount), 2) end
		if starCount < minRuneStar then
			return false
		else
			return true
		end
	else
		local runeStarMatch = existsMultiMaxSnap(runeStarRegion,{
			runeStar6,
			runeStar5,
			runeStar4,
			runeStar3,
			runeStar2,
			runeStar1})
		if runeStarMatch < minRuneStar then
			return false
		else
			return true
		end
		toast("Found a "..toString(starCount).." star rune")
	end
end
function runeDim()
	if debugAll == true then toast("[Function] runeDim") end
	runeCompDim = ""
	local runeDimMatch = existsMultiMaxSnap(runeRarityRegion,{
		"runeWord.png","runeWord98.png","runeWord96.png","runeWord94.png","runeWord92.png","runeWord90.png","runeWord88.png","runeWord86.png","runeWord84.png","runeWord82.png","runeWord80.png","runeWord78.png","runeWord76.png","runeWord74.png","runeWord72.png","runeWord70.png","runeWord68.png","runeWord66.png","runeWord64.png"})
	if runeDimMatch == -1 then
		runeCompDim = "nil"
	elseif runeDimMatch == 1 then
		runeCompDim = ""
	else
		runeCompDim = tostring((100 - ((runeDimMatch -1) * 2)))
	end
end
function runeRarityEvaluation ()
	if debugAll == true then toast("[Function] runeRarityEvaluation") end
	local runeRarityMatch = existsMultiMaxSnap(runeRarityRegion,{
		"RuneRarityCommon"..runeCompDim..".png",
		"RuneRarityMagic"..runeCompDim..".png",
		"RuneRarityRare"..runeCompDim..".png",
		"RuneRarityHero"..runeCompDim..".png",
		"RuneRarityLegendary"..runeCompDim..".png"})

		if runeRarityMatch == -1 then
			rrarity = "Nil"
			varRuneRarity = runeRarityMatch
			return true
		end

	varRuneRarity = runeRarityMatch
	if debugAll == true then getLastMatch():highlight(RuneR, 3) end
	if runeRarityMatch == 1 then
		local RuneR = tostring("Common")
		rrarity = RuneR
	elseif runeRarityMatch == 2 then
		local RuneR = tostring("Magic")
		rrarity = RuneR
	elseif runeRarityMatch == 3 then
		local RuneR = tostring("Rare")
		rrarity = RuneR
	elseif runeRarityMatch == 4 then
		local RuneR = tostring("Hero")
		rrarity = RuneR
	elseif runeRarityMatch == 5 then
		local RuneR = tostring("Legend")
		rrarity = RuneR
	end

	if runeRarityMatch < minRuneRarity then
		return false
	else
		return true
	end

end
function runeSlotEvaluation()
	if debugAll == true then toast("[Function] runeSlotEvaluation") end
	local preMinSimilarity = Settings:get("MinSimilarity")
	Settings:set("MinSimilarity", 0.7)
	local runeSlotMatch = existsMultiMaxSnap(runeRarityRegion,{
		"runeSlot1"..runeCompDim..".png",
		"runeSlot2"..runeCompDim..".png",
		"runeSlot3"..runeCompDim..".png",
		"runeSlot4"..runeCompDim..".png",
		"runeSlot5"..runeCompDim..".png",
		"runeSlot6"..runeCompDim..".png"})

	if runeSlotMatch == -1 then
		rslot = runeSlotMatch
		return true
	end
	rslot = runeSlotMatch
	Settings:set("MinSimilarity", preMinSimilarity)
	if debugAll == true then getLastMatch():highlight(tostring(runeSlotMatch),2) end
	return runeSlotMatch
end
function runePrimaryEvaluation ()
	if debugAll == true then toast("[Function] runePrimaryEvaluation") end
	local slot = runeSlotEvaluation()
	if slot == -1 then
		rprime = "Nil"
		return true
	elseif slot == 1 or slot == 3 or slot == 5 then
		rprime = "N/A"
		return true
	end
	local runePrimeMatch = existsMultiMaxSnap(runePrimeRegion,{
		runePrimeHP,
		runePrimeATK,
		runePrimeDEF,
		runePrimeSPD,
		runePrimeCRIRate,
		runePrimeCRIDmg,
		runePrimeRES,
		runePrimeACC})
	if runePrimeMatch == 1 then
		local RuneP = tostring("HP")
		rprime = RuneP
	elseif runePrimeMatch == 2 then
		local RuneP = tostring("ATK")
		rprime = RuneP
	elseif runePrimeMatch == 3 then
		local RuneP = tostring("DEF")
		rprime = RuneP
	elseif runePrimeMatch == 4 then
		local RuneP = tostring("SPD")
		rprime = RuneP
	elseif runePrimeMatch == 5 then
		local RuneP = tostring("CRI Rate")
		rprime = RuneP
	elseif runePrimeMatch == 6 then
		local RuneP = tostring("CRI Dmg")
		rprime = RuneP
	elseif runePrimeMatch == 7 then
		local RuneP = tostring("Resistance")
		rprime = RuneP
	elseif runePrimeMatch == 8 then
		local RuneP = tostring("Accuracy")
		rprime = RuneP
	elseif runePrimeMatch == -1 then
		rprime = "Fail"
	end
	if debugAll == true then getLastMatch():highlight(RuneP, 3) end
	if  primeStatKeep[runePrimeMatch] == 0 then
		return false
	else
		if runePrimeRegion:exists(runePrimePercentage) then
			rprime = rprime.."%"
			return true
		else
			return false
		end
	end
end
function runeSubEvaluation ()
	if debugAll == true then toast("[Function] runeSubEvaluation") end
	if runeSubRegion:exists(runeSubPercentage) then
		subStatFind = listToTable(runeSubRegion:findAll(runeSubPercentage))
		subStatCent = tableLength(subStatFind)
	else
		subStatCent = 0
	end
	if runeSubRegion:exists(runeSubSPD, 3) then
		subStatCent = subStatCent + 1
	end

	if varRuneRarity == nil or CBRuneEvalRarity == false then runeRarityEvaluation() end
	if varRuneRarity == 1 then varRuneRarity = nil return true end
	if varRuneRarity == -1 then rsub = "Nil" return true end
	local subCent = ((subStatCent / (varRuneRarity - 1) ) * 100)
	rsub = subCent
	local wCount = 20
	if debugAll == true then
		while wCount > 0 do
			if debugAll == true then
				if vibe == true then vibrate(1) end
				toast(tostring(subCent).."% of %Subs on a "..varRuneRarity.." Rune")
			end
			wait(2)
			wCount = wCount - 1
		end
	end
	if subCent < minCentSubStat then
		varRuneRarity = nil
		return false
	else
		varRuneRarity = nil
		return true
	end
end
function runeEval()
	if debugAll == true then toast("[Function] runeEval") end
	rstars = 0
	rslot = 0
	rrarity = 0
	rprime = 0
	rsub = 0
	statsSection:highlightOff()
	local sellRune = 0
	--all called functions return false unless keep conditions meet where they return true
	if sellRune == 0 and CBRuneEvalStar == true and runeStarEval() == false then
		sellRune = 1
	end
	runeDim()
	if sellRune == 0 and CBRuneEvalRarity == true and runeRarityEvaluation() == false then
		sellRune = 1
	end
	if sellRune == 0 and CBRuneEvalPrimary == true and runePrimaryEvaluation() == false then
		sellRune = 1
	end
	if sellRune == 0 and CBRuneEvalSubCent == true and runeSubEvaluation() == false then
		sellRune = 1
	end

	runeEvalStats:highlight("Stars: "..tostring(rstars).."\n"..
							"Slot: "..tostring(rslot).."\n"..
							"Rarity: "..rrarity.."\n"..
							"Prime: "..rprime.."\n"..
							"Sub: "..tostring(rsub).."%\n"..
							"Dim: "..runeCompDim.."%")
	wait(.5)
	if sellRune == 1 then
		setImagePath(localPath.."Runes")
		runeSnap:save("Sell"..rrarity..filenamecount..".png")
		filenamecount = filenamecount + 1
		wait(.4)
		runeEvalStats:highlightOff()
		setImagePath(imgPath)
		return true
	else
		setImagePath(localPath.."Runes")
		runeSnap:save("Keep"..filenamecount..".png")
		filenamecount = filenamecount + 1
		wait(.4)
		runeEvalStats:highlightOff()
		setImagePath(imgPath)
		varKeep = varKeep + 1
		return false
	end
end
function runeSale()
	if debugAll == true then toast("[Function] runeSale") end
	--TODO: This is where to Modify for only selling 5 and 6 star runes.
	if (buttonRegion:exists(sell)) then
		if debugAll == true then toast("Found: Sell Rune Png") end
		if debugAll == true then getLastMatch():highlight(0.5) end
		wait(1)
		if CBRuneEval == true then
			if runeEval() == true then
				if debugAll == true then toast("This Rune Will be Sold!") wait(.75)end
				if debugAll == true then
					if vibe == true then vibrate(1) end
					wait(.5)
					if vibe == true then vibrate(1) end
				end
				if debugAll == true then toast("Selling Rune in 15!") wait(15) end
				buttonRegion:existsClick(sell, 0)
				if debugAll == true then toast("Rune Sold!") wait(.75) end
				existsClick(yes)
				local sellResponse, match = waitMulti({yes, worldMap}, 3)
				if (sellResponse == 1) then
					click(match)
					print("need confirming selling rune")
				end

			else
				if debugAll == true then toast("Keep Rune!") wait(.75) end
				if debugAll == true then toast("Keeping Rune!") wait(.75) end
				multiCancel()
			end
		else
			buttonRegion:existsClick(sell)
			wait(.5)
			yesWordPngReg:existsClick(yes)
		end

	elseif not (buttonRegion:exists(sell)) then
		if debugAll == true then toast(" NoSell Buttion Cancel") end
		multiCancel()
	end
end
function areaGoTo(areaOverride)
	if debugAll == true then toast("[Function] areaGoTo") end
	if AreaSelection <= 9 then
		destination = areaCairos
	end
	if areaOverride == arena then
		destination = areaCairos
	end

	if areaMapReg:exists(areaMap, 0) then

	elseif battleButtonReg:existsClick(battleButton, 0) then
	else
		local loopW = 10
		while loopW >= 1 do
		keyevent(4)
			if existsClick(cancelRefill, 0) then
				existsClick(yes)
			end
			if battleButtonReg:exists(battleButton, 0) then
				if exists(endNow, 0) then
				keyevent(4)
			end
				loopW = -2
				battleButtonReg:existsClick(battleButton, 0)
				break
			end
			loopW = loopW - 1
			if loopW == 0 then
			toast("Unknown Error{Area Return")
			end
		end
	end
	wait(.75)


	local loopVarG = 1
	if debugAll == true then toast(destination) end
	while loopVarG == 1 do
		if existsClick(Pattern(destination):similar(0.8), 2) then
			if debugAll == true then getLastMatch():highlight(2) end
			wait(.75)
			if existsClick(Pattern(destination):targetOffset(0,-80):similar(0.8), 0) then if debugAll == true then  getLastMatch():highlight(2) end end
			loopVarG = 0
			break
		end
		loopVarG = loopVarG + 1
		if loopVarG >= 10 then
			loopVarG = - 1
			simpleDialog("Error", "Failed to Select Stage")
		end
		swipe(Location(1900,900),Location(600,900))
	end
end
function stageSelect(stageOverride,difficultyOverride)
	if debugAll == true then toast("[Function] stageSelect") end
	local findLvl = ""
	local Stage = areaSelect
	if stageOverride then
		Stage = stageOverride
	end

	local Difficulty = diffSelection
	if difficultyOverride then
		Difficulty = difficultyOverride
	end


---TODO: difficulty Selection Should only occur where it exists -- Scenario --TOA( Normal & Hard)
	if exists(Pattern(Difficulty..".png"):similar(0.8), 0) then
	else
		local choice, diffMatch = waitMulti(difficultyList, 15, false)
		click(diffMatch)
		wait(.5)
		existsClick(Pattern(Difficulty.."Select.png"):similar(0.8), 0)
		wait(.5)
	end

---TODO: This Selects then level that should be executed and needs to be modified to account for the diffrent kinds of area
	if AreaSelection <= 9 then
		local loopVarX = 1
		while loopVarX == 1 do
			if exists(Pattern(Stage):similar(0.8), 0) then
				loopVarX = 0
				break
			end
			loopVarX = loopVarX + 1
			if loopVarX >= 10 then
				loopVarX = - 1
				simpleDialog("Error", "Failed to Select Stage")
			end
			swipe(Location(600,1250),Location(600,500))
		end
		dungeonStageReg:existsClick(Pattern(Stage):similar(0.8), 0)
		if debugAll == true then getLastMatch():highlight(2) end

		wait(1)

		local levelSelect = "B"..tostring(levelSelection)..".png" --this is for the dungeons
		local loopVar = 1

		while loopVar == 1 do
			findLvl = exists(Pattern(levelSelect):similar(0.8), 0)
			if findLvl ~= "" then
				loopVar = 0
				break
			end
			loopVar = loopVar + 1
			if loopVar >= 10 then
				loopVar = - 1
				simpleDialog("Error", "Failed to match level with selection")
			end
			swipe(Location(1700,1300),Location(1700,500))
		end
		local regLevel = Region(findLvl:getX() - 300, findLvl:getY() - 55 , 1150, 250)                             					 if debugAll == true then regLevel:highlight(2) end
		regLevel:existsClick(scenarioFlash, 0)
	elseif AreaSelection > 9 and AreaSelection < 14 then
	--- TODO: add the stuff to handle Arena, Rift, World Boss


		--World Boss Enter Confirmation
		existsClick(yes)

	elseif AreaSelection >= 14 then
		local levelSelect = "scenarioLevel"..tostring(levelSelection)..".png" --this should apply to the scenario
		local loopVar = 1

		while loopVar == 1 do
			if exists(Pattern(levelSelect):similar(0.8), 0) then
				findLvl = getLastMatch()
				loopVar = 0
				break
			end
			loopVar = loopVar + 1
			if loopVar >= 10 then
				loopVar = - 1
				simpleDialog("Error", "Failed to match level with selection")
			end
			swipe(Location(1900,1300),Location(1900,500))
		end
		local regLevel = Region(findLvl:getX() - 50, findLvl:getY() - 40 , 1165, 290)                             					 if debugAll == true then regLevel:highlight(2) end
		regLevel:existsClick(scenarioFlash, 0)
	end

end

function timeCheck(minutes)
	if debugAll == true then toast("[Function] timeCheck") end
	seconds = minutes * 60
	if (xTime:check() > seconds) then
		xTime = Timer()
		return true
	else
		return false
	end
end

-- =============================
-- Image Matching & Region Lists
-- =============================
stagelist = {
	battleGearWheel,
	victoryDiamond,
	worldMap,
	bigFlash
}
arenalist = {
	battleGearWheel,
	victoryDiamond,
	arenaResults,
	arenaBigWing
}
stagereglist = {
	battleFigReg,
	victoryDiamondReg,
	worldMapReg,
	bigFlashReg
}
arenareglist = {
	battleFigReg,
	victoryDiamondReg,
	arenaResultsReg,
	arenaBigWingReg
}
backList = {
	battleGearWheel,
	victoryDiamond,
	worldMap,
	bigFlash,
	bigCancel,
	defeatedDiamond,
	networkDelay,
	networkConnection,
	cancelRefill,
	areaMap,
	battleButton
}
arenabackList = {
	battleGearWheel,
	victoryDiamond,
	arenaResults,
	arenaBigWing,
	bigCancel,
	rechargeWing,
	networkDelay,
	networkConnection,
	cancelRefill,
	areaMap,
	battleButton
}
cancelList = {
	yes,
	ok,
	cancelCross,
	cancel2,
	cancelLong,
	cancelRefill
}

difficultyList = {
	Pattern("scenarioNormal.png"):similar(0.8),
	Pattern("scenarioHard.png"):similar(0.8),
	Pattern("scenarioHell.png"):similar(0.8)
}
cancelRegList = {
	yesWordPngReg, --yesWordPng
	okenReg,  --ok.en.png
	cancelCrossReg, --cancelCross.png
	cancel2Reg, --cancel2.png
	cancelLongReg, --cancelLong.png
	cancelRefillReg --cancelRefill.png
}
arenaRegionMatch = { eTopMon, eLeftMon, eBottomMon, eRightMon}
--Next Area
if (nextArea) then
	print("Goto Next Area")
else
	print("Same Area")
end
if (nextArea) then
	table.insert(stagelist, "ilin.png")
	table.insert(stagelist, "libia.png")
	table.insert(stagelist, "dulander.png")
end
if (nextArea) then flashRequireRegion = right else flashRequireRegion = left end
RegionMatch = {}
if (SwapMaxTop) then  table.insert(RegionMatch, TopMon) end
if (SwapMaxLeft) then  table.insert(RegionMatch, LeftMon) end
if (SwapMaxRight) then  table.insert(RegionMatch, RightMon) end
if (SwapMaxBottom) then  table.insert(RegionMatch, BottomMon) end
RegionMatchEXP = {}
if (SwapMaxTop) then  table.insert(RegionMatchEXP, TopMonEXP) end
if (SwapMaxLeft) then  table.insert(RegionMatchEXP, LeftMonEXP) end
if (SwapMaxRight) then  table.insert(RegionMatchEXP, RightMonEXP) end
if (SwapMaxBottom) then  table.insert(RegionMatchEXP, BottomMonEXP) end


if SwapMaxTop == true or SwapMaxLeft == true  or SwapMaxRight == true or SwapMaxBottom == true then  skip = false else skip = true end

minRuneStar = tonumber(runeStars)
minRuneRarity = tonumber(runeRarity)

if runeSubCentage == 1 then minCentSubStat = 25
elseif runeSubCentage == 2 then minCentSubStat = 33
elseif runeSubCentage == 3 then minCentSubStat = 50
elseif runeSubCentage == 4 then minCentSubStat = 66
elseif runeSubCentage == 5 then minCentSubStat = 75
elseif runeSubCentage == 6 then minCentSubStat = 100
end

if AreaSelection == 1 then areaSelect = dungeonGiants
elseif AreaSelection == 2 then areaSelect = dungeonDragons
elseif AreaSelection == 3 then areaSelect = dungeonNecros
elseif AreaSelection == 4 then areaSelect = dungeonLight
elseif AreaSelection == 5 then areaSelect = dungeonDark
elseif AreaSelection == 6 then areaSelect = dungeonFire
elseif AreaSelection == 7 then areaSelect = dungeonWater
elseif AreaSelection == 8 then areaSelect = dungeonWind
elseif AreaSelection == 9 then areaSelect = dungeonMagic
elseif AreaSelection == 10 then areaSelect = areaTrial
elseif AreaSelection == 11 then areaSelect = areaRift
elseif AreaSelection == 12 then areaSelect = areaArena
elseif AreaSelection == 13 then areaSelect = areaWorld
elseif AreaSelection == 14 then areaSelect = areaGaren
elseif AreaSelection == 15 then areaSelect = areaMtSiz
elseif AreaSelection == 16 then areaSelect = areaMtWhite
elseif AreaSelection == 17 then areaSelect = areaKabir
elseif AreaSelection == 18 then areaSelect = areaTalain
elseif AreaSelection == 19 then areaSelect = areaHydeni
elseif AreaSelection == 20 then areaSelect = areaTamor
elseif AreaSelection == 21 then areaSelect = areaVrofagus
elseif AreaSelection == 22 then areaSelect = areaAiden
elseif AreaSelection == 23 then areaSelect = areaFerun
elseif AreaSelection == 24 then areaSelect = areaMtRunar
elseif AreaSelection == 25 then areaSelect = areaChiruka
end

if diffSelection == 1 then diffSelection = "scenarioNormal"
elseif diffSelection == 2 then diffSelection = "scenarioHard"
elseif diffSelection == 3 then diffSelection = "scenarioHell"
end

primeStatKeep = {}
if (runePrimeHP) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeATK) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeDEF) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeSPD) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeCRIRate) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeCRIDmg) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeRES) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end
if (runePrimeACC) then  table.insert(primeStatKeep, 1) else table.insert(primeStatKeep, 0) end

-- ========================
-- Main Botting Application
-- ========================
currentIndex = 4
maxIndexStageList = 4
xTime = Timer()
ArenaOverRide = 0
while true do
	---Screen Stats
	statsSection:highlightOff()
	wait(.1)
	statsSection:highlight("Runs:"..tostring(varRun).." Deaths:"..tostring(varDeath).."\n".."Runes Kept:"..tostring(varKeep))


	if (AreaSelection == 12 or ArenaOverRide == 1) and currentIndex ~= 2 then
		toast("Arena Farm Should be Activated")
		areaGoTo(arena)
		arenaMain = 1
		wait(2)
	end
--	if arenaFarm == true and currentIndex ~= 2 then
--		if timeCheck(arenaTimeFreq) == true then
--			toast("Arena Farm Should be Activated")
--			areaGoTo(arena)
--			arenaMain = 1
--			wait(1)
--		end
--	end

	while arenaMain == 1 do
			ArenaOverRide = 0
			if not arenaOppReg:exists(arenaSmallWing, 0) then
				swipeCount = 0
				arenaExe = 0
				arenaRefresh()
				wait(1)
			end
			local opponentList = listToTable(arenaOppReg:findAll(arenaSmallWing))
			local tCount = tableLength(opponentList)
			if debugAll == true then toast(tCount..": Opponent's Found") end
			for i, opp in ipairs(opponentList) do
				if i <= tCount then
					wait(.2)
					click(opp)
					arenaExe = 1
				end
				--------------------------------------------------------------------------------------------------------
				--------------------------------------------------------------------------------------------------------
				---Code Needs to be inserted here to keep track of and control what happens if there are not enough wings
				---This is also where we can control the refill of wings if we are out of them or return to another area to
				---continue with out farming if refills for wings are not enabled.
				--------------------------------------------------------------------------------------------------------
				--------------------------------------------------------------------------------------------------------

				while arenaExe == 1 do
					--------------------------------------------------------------------------------------------------------
					local choice, stageMatch = waitMultiRegIndex(arenalist, 20, false, arenareglist, currentIndex, maxIndexStageList)
					if (choice == -1) then
						toast("Unknown Error [No StageMatch")
						choice, stageMatch = waitMulti(arenabackList, 20*60, false)
						toast("[Fault Search] Using Extensive Search List")

						if (choice == -1) then
							multiCancel()
							wait(1)
							toast("[multiCancel] Called as an end all")
						end
					end
					if debugAll == true then stageMatch:highlight(1) end
					--------------------------------------------------------------------------------------------------------
					---Starts the Fight

					if (choice == 4) then
						currentIndex = 4
						arenaLevelCheck() ---Obtains information regarding opponent
						if (arenaEmptyCount >= ArenaMaxMon) or ((arenaLvlCount / arenaRepCount) <= ArenaMaxAvgLvl) then
							arenaBigWingReg:existsClick(arenaBigWing)
							if arenaBigWingRegFlag == 0 then
								arenaBigWingReg = regionFinder(stageMatch, 2)
								arenaBigWingRegFlag = 1
							end
						else ---Cancel the fight and proceed to the next opponent
							arenaExe = 0
							if bigCancalRegFlag == 0 then
								bigCancalReg = regionFinder(exists(bigCancel, 0), 2) ---Does Last MatchWork Here?
								bigCancalRegFlag = 1
							end
							bigCancalReg:existsClick(bigCancel, 3)
							break
						end
					end
					--------------------------------------------------------------------------------------------------------
					---Events During the Actual Battle
					if (choice == 1) then
						currentIndex = 1
						if battleFigRegFlag == 0 then
							battleFigReg = regionFinder(stageMatch, 2)
							battleFigRegFlag = 1
						end
						if debugAll == true then toast("Arena - [Battle Routine]") end
						arenaDialogReg:existsClick(arenaDialog,0)
						checkPlayAndPause()
					end
					--------------------------------------------------------------------------------------------------------
					---At End of fight Contols What Happens
					if (choice == 2) then
						if debugAll == true then toast("Choice 2,5 [End of Battle Arena]") end
						if victoryDiamondRegFlag == 0 then
							victoryDiamondReg = regionFinder(stageMatch, 2)
							victoryDiamondRegFlag = 1
						end
						currentIndex = 2
						local randomInstance = math.random(0,2)
						local randomTime = math.random(0,90)
						continueClick(1800, 300, 15, 15, 2)
					end

					--------------------------------------------------------------------------------------------------------
					---Results of the Fight Check/Continue/Accept
					if choice == 3 then
					currentIndex = 3
					arenaExe = 0
						arenaResultsReg:existsClick(arenaResults, 0)
						if debugAll == true then stageMatch:highlight(0.75) end
						break
					end

					---Misc Checks
					--Network  Resubmit

					if (choice == 6) then
						if refillWings == true then
							refillArena()
						else
							keyevent(4)
										wait(.7)
							keyevent(4)
										wait(.7)
							keyevent(4)
										wait(.7)
							arenaMain = 0
							arenaExe = 0
							areaGoTo()
										wait(3)
							stageSelect()
										wait(2)
							break
						end
					end

					if (choice == 7) or (choice == 8) then
						existsClick(yes)
						wait(5)
					end

					--Cancel Max Monster and  Misc Menus
					if (choice == 9) then
						click(stageMatch)
						wait(5)
					end

					if choice == 10 or choice == 11 then
					areaGoTo(arena)
					end

				end

				if i >= tCount then
					swipeCount = swipeCount +1
					local swipeInt = swipeCount
					while swipeInt >= 1 do
						wait(.5)
						swipeInt = swipeInt -1
						swipe(Location(1700,1075),Location(1700,461))
					end
				end
				if i >= tCount and EndofArenaL:exists(endArenaList, 0) then
					swipeCount = 0
					arenaExe = 0
					arenaRefresh()
				end
				--Critria for refreshing the list.
			end
	end

-- ========== Scenario battles ==========
	--TODO: Code to return to here we need to.
	local choice, stageMatch = waitMultiRegIndex(stagelist, 15, false, stagereglist, currentIndex, maxIndexStageList)
	--If we didn't find a match on the stagelist, search the bigger list
	if (choice == -1) then
		toast("[stageList] No match found")
		choice, stageMatch = waitMulti(backList, 20*60, false)
		toast("[backList] Using Extensive Search List")

		--If we didn't find a match again try to end all actions
		if (choice == -1) then
			multiCancel()
			wait(1)
			toast("[multiCancel] Try cancelling all actions")
		end
	end
	if debugAll == true then stageMatch:highlight(1) end
	--Battle Preperation Routine
	if (choice == 4) or (choice == 6) then
		currentIndex = 4
		if debugAll == true then toast("[Battle Preperation]") end
		if AMonMax == 1 then swapMaxFood() end
		if AMonMax == 2 then AMonMax = 0 end
		if bigFlashRegFlag == 0 then
			bigFlashReg = regionFinder(stageMatch, 2)
			bigFlashRegFlag = 1
		end

		if bigFlashReg:existsClick(bigFlash) then
			existsClick(yes, 2) -- Click yes in "No Leadership skill" pop-up
			varRun = varRun + 1
		end
	end

	--Battle Routine
	if (choice == 1) then
		currentIndex = 1
		if battleFigRegFlag == 0 then
			battleFigReg = regionFinder(stageMatch, 2)
			battleFigRegFlag = 1
		end
		if debugAll == true then toast("[Battle Routine]") end
		if AMonMax == 2 then AMonMax = 0 end
		checkPlayAndPause()
	end

	--Victory Routine
	if (choice == 2) or (choice == 5) then
		if debugAll == true then toast("Choice 2 or 5 [Victory Routine]") end
		if victoryDiamondRegFlag == 0 then
			victoryDiamondReg = regionFinder(stageMatch, 2)
			victoryDiamondRegFlag = 1
		end
		currentIndex = 2
		local randomInstance = math.random(0,2)
		local randomTime = math.random(0,90)
	if skip == false then
		if AMonMax == 0 then checkIfMax() end
			setContinueClickTiming(10 + randomTime / 4, 65 + randomTime / 1)
		if AMonMax == 1 then continueClick(1800, 300, 15, 15, 2 + randomInstance) end
		if AMonMax == 2 then continueClick(1800, 300, 15, 15, 2 + randomInstance) end
	else
		continueClick(1800, 300, 15, 15, 2)
	end
	wait(.5)
		continueClick(1800, 300, 15, 15, 2)
		if debugAll == true then stageMatch:highlight(0.75) end
		  wait(0.75 )
		if (sellRune) then
			runeSale()
		else
			multiCancel()
		end
	end

	--Continue Repeat Routine
	if (choice == 3) then
		if worldMapRegFlag == 0 then
			worldMapReg = regionFinder(stageMatch, 2)
			worldMapRegFlag = 1
		end

		if debugAll == true then toast("Choice 7 [Continue Repeat Routine]") end
		currentIndex = 3
	--Next Area
		if (nextArea and (stagelist[choice] == "ilin.png" or stagelist[choice] == "libia.png" or stagelist[choice] == "dulander.png")) then
			while (existsClick(stagelist[choice], 0)) do
			   wait(1)
			end
		end
		if (nextArea and flashRequireRegion:exists(requireEnergy0,0)) then
			simpleDialog("Warning", "Reach end of curent area.")
			return
		end
		while true do
		if debugAll == true then toast("While true [Continue Repeat Routine]") end

		if (not flashRequireRegion:existsClick(smallFlash)) then
			if debugAll == true then toast("smallFlash not found [Continue Repeat Routine]") end
			flashRequireRegion:existsClick(smallFlash, 2)
		end

		wait(.5)
		choice, listMatch = waitMulti({bigFlash, sellButton}, 3)
		if (choice == 1) then break end
		if (choice == 2) then
			if (worldMapReg:exists(worldMap, 0) and refillEnergy) then
				if arenaFarm == true and timeCheck(arenaTimeFreq) == true then
					ArenaOverRide = 1
				else
					refillEnergy()
				end
				break
			elseif (worldMapReg:exists(worldMap, 0) and arenaFarm == true) then
				ArenaOverRide = 1
				break
			end
			keyevent(4)
			local requiredFlash = existsMultiMaxSnap(flashRequireRegion,{requireEnergy3, requireEnergy4, requireEnergy5, requireEnergy6, requireEnergy7, requireEnergy8})
			if (requiredFlash == -1) then requiredFlash = 9 else requiredFlash = requiredFlash + 2 end
			if debugAll == true then toast("Current Energy :"..tostring(keyNum()).." of "..tostring(requiredFlash).." Required") wait(.75) end
			wait(5*60)
		end
		if (choice == -1) then keyevent(4) end
		end
	end

	--Death Routine
	if (choice == 7) then
		varDeath = varDeath + 1
		toast("Defeated: [Death Routine] #"..tostring(varDeath))
		while true do
			Region(1600,1000,300,300):existsClick(defeatedNo)
			AMonMax = 0
			if victoryDiamondReg:exists(victoryDiamond, 5) then
				local randomInstance = math.random(0,1)
				continueClick(1800, 300, 50, 50, 1 + randomInstance)
			end
			wait(.5)
			if (not flashRequireRegion:existsClick(smallFlash)) then
				if debugAll == true then toast("smallFlash not found [Continue Repeat Routine]") end
				flashRequireRegion:existsClick(smallFlash, 2)
			end
		end
	end

	--Network Resubmit
	if (choice == 8) or (choice == 9) then
			existsClick(yes)
			wait(5)
	end

	--Cancel Max Monster and Misc Menus
	if (choice == 10) then
		click(stageMatch)
		wait(5)
	end

	if choice == 11 or choice == 12 then
		areaGoTo()
	end
end