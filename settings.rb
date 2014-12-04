class Settings
	@@data = {
		x_size: 	30, 
		y_size: 	30,
		cond_count:  1,
		field_str:   '',
	}
	def self.data
		@@data
	end
end


class Class 
	def [](name)
		self.data[name]
	end

	def []=(name, value)
		self.data[name] = value
	end
end

