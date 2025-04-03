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
			"at end of round",
			"{C:mult}-#3#{} Mult per hand played",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	config = {  extra = { mult = 0,  boss_add = 6, hand_sub = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.boss_add, card.ability.extra.hand_sub } }
	end,
	rarity = 1, -- common
	atlas = "Jubby",
	pos = { x = 0, y = 0 },
	cost = 5,

	--[ TODO:
	-- Make sure joker buff isn't retriggered
	-- Make sure joker minus mult isn't retriggered
	-- Make sure joker gets properly debuffed
	-- Make sure this card triggers as intended
	--]

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end

		if not context.blueprint then

			if context.end_of_round and not context.repetition then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.boss_add
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.boss_add } }
				}
			end

			if context.cardarea == G.jokers and context.before then
				if card.ability.extra.mult > 0 then
					card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.hand_sub)
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
