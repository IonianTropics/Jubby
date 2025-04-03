-- Jubby.lua
-- io Bowie


SMODS.Atlas {
    key = "Jubby",
    path = "Jubby.png",
    px = 82,
    py = 119,
}


SMODS.Joker {
	key = "jubby",
	loc_txt = {
		name = "Jubby",
		text = {
			"Gains {C:mult}+#2#{} Mult",
			"when {C:attention}Boss Blind{} is defeated",
			"{C:mult}-#3#{} Mult per hand played",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	config = { mult = 0, extra = {  boss_add = 6, hand_sub = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card.ability.extra.boss_add, card.ability.extra.hand_sub } }
	end,
	rarity = 1, -- common
	atlas = "Jubby",
	pos = { x = 0, y = 0 },
	cost = 5,

	--[TODO:
	-- Make sure this card triggers as intended, watch for edge cases
	-- Make sure joker gets properly debuffed
	--]

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.mult } }
			}
		end

		if not context.blueprint then

			if context.end_of_round and G.GAME.blind.boss then
				card.ability.mult = card.ability.mult + card.ability.extra.boss_add
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.boss_add } }
				}
			end

			if context.cardarea == G.jokers and context.before then
				local prev_mult = card.ability.mult
				card.ability.mult = math.max(0, card.ability.mult - card.ability.extra.hand_sub)
				if card.ability.mult ~= prev_mult then
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
