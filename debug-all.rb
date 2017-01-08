require 'Parallel'

# Get all devices
devices = %x[instruments -s devices].split("\n")

connected_iphones = devices.select do |device|
	device.include? "iPhone" and !(device.include? "Simulator")
end

uuids = connected_iphones.map { |a| a.match(/.*\[([\d\w]+)\]/).captures.first }

portMapping = {}

currPort = 8100
Parallel.map(uuids) do |uuid|
	system("env USE_PORT=8100 xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination 'id=#{uuid}' test &")
	system("iproxy 8100 #{currPort} #{uuid}")

	portMapping[uuid] = currPort
	currPort += 1
end

print(portMapping)