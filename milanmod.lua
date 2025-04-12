SMODS.Atlas {
	-- Key for code to find it with
	key = "MilanMod",
	-- The name of the file, for the code to pull the atlas from
	path = "MilanJokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

-- Humble Joker
SMODS.Joker{
    key = 'humble_joker',

	loc_txt = {
		name = 'Humble Joker',
		text = {
			"{C:white,X:mult} X#1# {} Mult"
		}
	},

	config = { extra = { Xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize{type='variable', key='a_xmult', vars = {card.ability.extra.Xmult} }
			}
		end
	end
}

-- Circle Joker
SMODS.Joker{
	key = 'circle_joker',

	loc_txt = {
		name = 'Circle Joker',
		text = {
			"If hand contains 1 card",
			"this joker gains {C:mult}#2# {}Mult",
			"and {C:chips}#4# {}chips",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult & {C:chips}+#3# {C:inactive}Chips)"
		}
	},

	config = { extra = {mult = 0, mult_gain = 3, chips = 0, chip_gain = 14 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 1, y = 0},
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,



	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				chip_mod = card.ability.extra.chips,
				--TODO: currently only says +mult, add definition to dictionary for both mult and chips so it prints that correctly
				message = localize{type='variable', key='a_mult', vars = {card.ability.extra.mult} } 
			}
		end
		if context.before and #context.full_hand == 1 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain -- maybe change to self.extra? spare trousers does it like that
			return {
				message = 'Upgrade!',
				card = card
			}
		end
	end
}

-- Spectral Teller, change name PLS
SMODS.Joker {
	key = 'spectral_teller',
	loc_txt = {
		name = 'Spectral Teller',
		text = {
			"Gains {C:white,X:mult}X#1#{} Mult per",
			"unique Spectral card used this run",
			"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
		}
	},

	config = { extra = { Xmult_gain = 0.5, Xmult = 1}},


	loc_vars = function(self, info_queue, card)
		local spectral_used = 0
		for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectral_used = spectral_used + 1 end end
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain   } }
	end,

	rarity = 3,
	atlas = 'MilanMod',
	pos = {x = 2, y = 0},
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local spectral_used = 0
			for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectral_used = spectral_used + 1 end end
			return {
				Xmult_mod = card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain,
				message = localize{type='variable', key='a_xmult', vars = {card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain} }
			}
		end
	end
}

-- Red Joker
SMODS.Joker {
	key = 'red_joker',

	loc_txt = {
		name = 'Red Joker',
		text = {
			"Gains {C:chips}+#1# {}chips per discard",
			"{C:inactive}(Currently {C:chips}+#2# {C:inactive}chips)"
		}
	},

	config = { extra = { chips_gain = 15, chips = 0} },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 3, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize{type='variable', key='a_chips', vars = {card.ability.extra.chips}}
			}
		end
		if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand]then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
			return {
				message = '+15 chips',
				colour = G.C.CHIPS,
				card = card
			}
		end
	end
}

-- Rigged Wheel
SMODS.Joker{
	key = 'rigged_wheel',

	loc_txt = {
		name = 'Rigged Wheel',
		text = {
			"All chances Editions for additions",
			"are equally likely, including {C:dark_edition}Negative{}."
		}
	},

	config = { extra = {}},

	loc_vars = function(self, info_queue, card)
		-- This is the way to add an info_queue, which is extra information about other cards
		-- like Stone Cards on Marble/Stone Jokers, Steel Cards on Steel Joker, and
		-- in this case, information about negative editions on Perkeo.
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 4, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	-- TODO: fix this function for if there's multiple Rigged Wheels, cause that seems to break it????????????????????
	add_to_deck = function(self, card, from_debuff)
		local original_poll_edition = poll_edition --overwrite the poll_edition function
		function poll_edition(key, mod, no_neg, guaranteed)
			mod = mod or 1 --basically the code of the poll_edition function but i changed one number
			local edition_poll = pseudorandom(pseudoseed(key or 'edition_generic'))
			if guaranteed then
				if edition_poll > 1 - 0.01725*25 then
					return {negative = true}
				elseif edition_poll > 1 - 0.01725*25 then
					return {polychrome = true}
				elseif edition_poll > 1 - 0.01725*25 then
					return {holo = true}
				elseif edition_poll > 1 - 0.01725*25 then
					return {foil = true}
				end
			else
				if edition_poll > 1 - 0.01725*mod then
					return {negative = true}
				elseif edition_poll > 1 - 0.01725*G.GAME.edition_rate*mod then
					return {polychrome = true}
				elseif edition_poll > 1 - 0.01725*G.GAME.edition_rate*mod then
					return {holo = true}
				elseif edition_poll > 1 - 0.01725*G.GAME.edition_rate*mod then
					return {foil = true}
				end
			end
			return nil
		end
	end,

	remove_from_deck = function(self, card, from_debuff)
		local original_poll_edition = poll_edition
		function poll_edition(key, mod, no_neg, guaranteed)
			mod = mod or 1
			local edition_poll = pseudorandom(pseudoseed(key or 'edition_generic'))
			if guaranteed then
				if edition_poll > 1 - 0.003*25 and not _no_neg then
					return {negative = true}
				elseif edition_poll > 1 - 0.006*25 then
					return {polychrome = true}
				elseif edition_poll > 1 - 0.02*25 then
					return {holo = true}
				elseif edition_poll > 1 - 0.04*25 then
					return {foil = true}
				end
			else
				if edition_poll > 1 - 0.003*mod and not _no_neg then
					return {negative = true}
				elseif edition_poll > 1 - 0.006*G.GAME.edition_rate*mod then
					return {polychrome = true}
				elseif edition_poll > 1 - 0.02*G.GAME.edition_rate*mod then
					return {holo = true}
				elseif edition_poll > 1 - 0.04*G.GAME.edition_rate*mod then
					return {foil = true}
				end
			end
			return nil
		end
	end

}

-- Brick by brick
SMODS.Joker{
	key = 'brick_by_brick',

	loc_txt = {
		name = 'Brick by Brick',
		text = {
			"This Joker gains {C:mult}+#1# {}Mult",
			"for each scoring Stone card.",
			"{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)"
		}
	},

	config = { extra = { mult_gain = 3, mult = 0}},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 5, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize{type='variable', key='a_mult', vars = {card.ability.extra.mult}}
			}
		end
		if context.individual and context.cardarea == G.play and context.other_card:get_id() < 0 and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = '+3 Mult',
				colour = G.C.Mult,
				card = card
			}
		end
	end
}


-- Miner
SMODS.Joker{
	key = 'miner',

	loc_txt = {
		name = 'Miner',
		text = {
			"Retriggers all played Stone cards"
		}
	},

	config = { extra = { repetitions = 1 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions+1} }
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 6, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() < 0 then
				return {
					message = localize('k_again_ex'),
					-- repetitions = card.ability.extra.repetitions,
					-- card = context.other_card
					repetitions = card.ability.extra.repetitions,
					card = context.self
				}
			end
		end
	end
}
