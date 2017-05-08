require 'net/http'
require 'json'

cluster_id=ARGV[0]
abort("Enter cluster id") unless cluster_id.is_a?(String) && cluster_id.length > 0
base_uri='http://localhost:8080/'
uri = URI('http://localhost:8080/clusters/' + cluster_id)
net = Net::HTTP.new(uri.host, uri.port)
get_res = Net::HTTP.get_response(uri)
abort("Get clusters error") unless get_res.is_a?(Net::HTTPSuccess)
	
body=JSON.parse(get_res.body)
p body
nodes=body['nodes']
if nodes.length > 0 
	nodes.each do |node|
		node_uri = '/nodes/' + node
		get_node_res = net.get(node_uri)
		# abort("Get nodes error") unless get_node_res.is_a?(Net::HTTPSuccess)
		body = JSON.parse(get_node_res.body)
		p body
		if body['devices'].length > 0
			devices = body['devices']
			devices.each do |device|
				p "deleting device", device
				if device['bricks'].length > 0
					device['bricks'].each do |brick|
						p 'deleting volume', brick
						delete_uri = '/volumes/' + brick['volume'].to_s
						delete_res = net.delete(delete_uri)
						p delete_res, delete_res.body
						sleep(5)
					end
				end
				device_uri = '/devices/' + device['id'].to_s
				delete_res = net.delete(device_uri)
				p delete_res, delete_res.body
			end
		end
		delete_res = net.delete(node_uri)
		p delete_res, delete_res.body
	end
end
delete_res = net.delete(uri.path)
p delete_res, delete_res.body