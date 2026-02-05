With server_ranges AS 
(Select 
	server_id,
	weight,
	end_slot = SUM(weight) OVER (order by server_id),
	start_slot = SUM(weight) OVER (order by server_id) - weight + 1,
	total_weight = SUM(weight) OVER ()
FROM servers)
, requests_slots AS 
(SELECT
        request_id,
        request_time,
        user_id,
		slot = ((request_id -  1) % (Select MAX(total_weight) FROM server_ranges)) + 1 
FROM requests) 

SELECT
        request_id,
        request_time,
        user_id,
		slot ,
		s.server_id as routed_server 
FROM requests_slots r
INNER JOIN server_ranges s
ON r.slot BETWEEN s.start_slot and s.end_slot 
Order by request_id

