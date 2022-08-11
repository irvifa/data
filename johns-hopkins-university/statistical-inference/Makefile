clean:
	@rm *.pdf

generate:
	@pandoc --from=markdown --output=$(OUTPUT) $(INPUT) --variable=geometry:"margin=0.5cm"
