local alphabetTable
local printMyTable1 = function()
	for i=1,#alphabetTable do
		print(alphabetTable[i])
	end
	print("**********************")
end
local printMyTable2 = function(someTable)
	for i=1,#someTable do
		print(someTable[i])
	end
	print("**********************")
end
alphabetTable = {"a","b","c","d","e","f","g"}
printMyTable1()
printMyTable2(alphabetTable)

table.insert(alphabetTable,3,"just insert this")
printMyTable1()

table.remove(alphabetTable,3)
printMyTable2(alphabetTable)