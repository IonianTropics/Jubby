-- Jubby.lua
-- io Bowie


SMODS.Atlas {
	key = "Jubby",
	path = "Jubby.png",
	px = 69,
	py = 93,
}


SMODS.Joker {
	key = "jubby",
	loc_txt = {
		name = "Jubby",
		text = {
			"Gains {C:mult}+#2#{} Mult",
			"at end of round",
			"{C:mult}-#3#{} Mult per hand played",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},

	atlas = "Jubby",
	pos = { x = 0, y = 0 },

	config = { extra = { mult = 0,  blind_add = 6, hand_sub = 1 } },

	rarity = 1, -- common
	cost = 5,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.blind_add, card.ability.extra.hand_sub } }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end

		if not context.blueprint then

			if context.end_of_round and context.cardarea == G.jokers then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.blind_add
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.blind_add } }
				}
			end

			if context.cardarea == G.jokers and context.before then
				local prev_mult = card.ability.extra.mult
				card.ability.mult = math.max(0, card.ability.extra.mult - card.ability.extra.hand_sub)
				if card.ability.extra.mult ~= prev_mult then
					return {
						message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.hand_sub } },
						colour = G.C.RED,
						card = card
					}
				end
			end
		end
	end
}
