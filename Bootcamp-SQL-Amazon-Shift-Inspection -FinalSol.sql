With NextWeekday As
(Select 
order_id,
order_date,
DATEADD(day,((3 - DATEPART(weekday, order_date) + 6)  % 7) + 1 , order_date) as next_tuesday,
DATEADD(day,((5 - DATEPART(weekday, order_date) + 6)  % 7) + 1 , order_date) as next_thursday
FROM Orders)

Select
w.order_id,
w.order_date,
MIN(v.candidate_date) as Inspection_Date
FROM NextWeekday w
CROSS APPLY
(VALUES (next_tuesday), (next_thursday)) v(candidate_date)

WHERE NOT EXISTS
(Select 1 from Holidays h
WHERE h.holiday_date = CAST(v.candidate_date as DATE))
GROUP BY w.order_id, w.order_date
ORDER BY w.order_id

