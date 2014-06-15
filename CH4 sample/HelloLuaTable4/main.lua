local helloWorld = function ()
	print("just print hello world")
end

local testTable = {
	name = "CORONA Test", 
	func = helloWorld
}
testTable:func()
testTable.func()

testTable.add = function(Number1,Number2)
	return Number1+Number2
end
print(testTable.add(2,3))

testTable.printMyName1 = function(self)
	print(self.name)
end
testTable.printMyName1(testTable)
testTable:printMyName1()

function testTable:printMyName2()
	print(self.name)
end
testTable:printMyName2()


