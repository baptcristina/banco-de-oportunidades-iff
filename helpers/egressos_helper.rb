module EgressosHelper



def mask_cpf(number)
	if number.to_f/10000000000 >= 1
		number = number.to_f/100
		number_to_currency( number ,unit: "", :delimiter => ".", :separator => "-")
	else
		number = number.to_f/100

		number_to_currency( number ,unit: "", :delimiter => ".", :separator => "-")
	end
end

end

