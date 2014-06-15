local z
z=50
print("1st print, z = " .. z)

z=z+50
print("2nd print, z = " .. z)

local add = function(number1,number2)
	z = 30
	print ("3rd print, z = " ..z)
	return number1+number2+z
end

print("answer = " .. add(10,20))
print("4th print, z = " ..z)



