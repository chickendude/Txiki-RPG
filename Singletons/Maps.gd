extends Node

class_name Maps

const maps = {
	"Battle": "res://Maps/Battle.tscn",
	"HouseYuji": "res://Maps/HouseYuji.tscn",
	"TownYunien": "res://Maps/TownYunien.tscn",
	"Overworld": "res://Maps/Overworld.tscn",
}

# monsters

const m = {
	'demon_princess': "res://Enemies/DemonPrincess.tres",
	'ghost': "res://Enemies/Ghost.tres",
	'lost_soul': "res://Enemies/LostSoul.tres",
	'pink_globlin': "res://Enemies/PinkGloblin.tres",
	'sloblin': "res://Enemies/Sloblin.tres",
	'streaker': "res://Enemies/Streaker.tres"
}

# monsters at each location
const monsters_at = {
	'OverworldGrass': [
		[ m['sloblin'], m['sloblin'] ],
		[ m['sloblin'], m['lost_soul'] ],
		[ m['ghost'], m['lost_soul'], m['ghost'] ],
		[ m['pink_globlin'] ]
		],
	'OverworldMixed': [
		[ m['sloblin'], m['sloblin'], m['ghost'] ],
		[ m['sloblin'], m['lost_soul'], m['ghost'] ],
		[ m['ghost'], m['lost_soul'], m['ghost'] ],
		[ m['lost_soul'], m['lost_soul'] ],
		[ m['demon_princess'], m['demon_princess'] ],
		],
	'OverworldSnow': [
		[ m['sloblin'], m['sloblin'], m['ghost'], m['demon_princess'] ],
		[ m['sloblin'], m['lost_soul'], m['ghost'] ],
		[ m['ghost'], m['lost_soul'], m['ghost'], m['demon_princess'] ],
		[ m['lost_soul'], m['lost_soul'] ],
		[ m['demon_princess'], m['demon_princess'] ],
		],
}
