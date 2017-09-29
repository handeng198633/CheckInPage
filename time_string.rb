def time_range(string)
	return time_change(string.split(' - ')[0]) + ' ' + time_change(string.split(' - ')[1]) + ' ' + string.split(' - ')[0].split(' ')[0]
end

def time_change(string)
	if string.split(' ')[2] == 'PM'
		i = string.split(' ')[1].split(':')[0].to_i + 12
	else
		i = string.split(' ')[1].split(':')[0].to_i
	end
	return i.to_s + ':' + string.split(' ')[1].split(':')[1] + ':00'
end

puts time_range('09/25/2017 3:45 AM - 09/25/2017 10:10 PM')
