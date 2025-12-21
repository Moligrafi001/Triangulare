local Gokka = {}

getgenv().GokkaConnections = getgenv().GokkaConnections or {}

function Gokka:Connect(name, signal, callback)
	assert(type(name) == "string", "Name inválido")
	assert(typeof(signal) == "RBXScriptSignal", "Signal inválido")
	assert(type(callback) == "function", "Callback inválido")

	local connections = getgenv().GokkaConnections

	if connections[name] then
		connections[name]:Disconnect()
	end

	connections[name] = signal:Connect(callback)

	return connections[name]
end

function Gokka:Disconnect(name)
	local connections = getgenv().GokkaConnections
	local conn = connections[name]

	if conn then
		conn:Disconnect()
		connections[name] = nil
	end
end

function Gokka:DisconnectAll()
	local connections = getgenv().GokkaConnections

	for _, conn in pairs(connections) do
		conn:Disconnect()
	end

	table.clear(connections)
end

return Gokka