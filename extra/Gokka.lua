local Gokka = {}

getgenv().GokkaConnections = getgenv().GokkaConnections or {}

function Gokka:Connect(obj)
  local name, parent, signal, callback = obj.Name, obj.Parent, obj.Signal, obj.Callback
  signal = parent[signal]

	local connections = getgenv().GokkaConnections
	if connections[name] then connections[name]:Disconnect() end
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

	for _, conn in pairs(connections) do conn:Disconnect() end

	table.clear(connections)
end

return Gokka