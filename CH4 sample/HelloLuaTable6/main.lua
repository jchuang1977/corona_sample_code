local fruitTable = {
	red = "apple",
	yellow = "banana",
	orange = "orange",
	green = "mango"
}
for key,value in pairs(fruitTable) do
	print(key,value)
	if key=="red" then
		print ("when key is red, the value is " .. value)
	end
end