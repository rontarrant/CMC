extends Node

func format_currency(currency_amount : String) -> String:
	var i : int = currency_amount.length() - 3

	while i > 0:
		currency_amount = currency_amount.insert(i, ",")
		i = i - 3

	return currency_amount
