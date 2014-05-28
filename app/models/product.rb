class Product < ActiveRecord::Base
  attr_accessible :amount, :code, :date, :description, :manufacturer, :price, :weight, :route

def self.search(search)
  if search
    res = []
    lines = search.split(" ")
    unavailable = -1
    lines.each do |item|
    	item = item.gsub(/[^0-9a-zA-Z]/, '')
      result = find(:all, :conditions => ['code = ?', "\"#{item}\""])	
      if (result.length == 0)
        result = find(:all, :conditions => ['code = ?', "#{item}"])
      end
      if (result.length != 0)
        res << result 
      else
        p = Product.new :code => item 
        p.id = unavailable
        unavailable -= 1
        res << [p]
      end
    end
    #puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + res.to_s
    return res
  else
    find(:all)
  end
end

def self.save(upload)
	name = upload['datafile'].original_filename
	directory = "public/data"
	# create the file path
	path = File.join(directory, name)
	# write the file
	File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
end


end
