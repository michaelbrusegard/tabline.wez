local M = {}

function M.deep_extend(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				M.deep_extend(t1[k], t2[k])
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

function M.insert_elements(dest, src)
	for _, v in ipairs(src) do
		table.insert(dest, v)
	end
end

return M
