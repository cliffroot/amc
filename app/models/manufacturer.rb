class Manufacturer < ActiveRecord::Base
  attr_accessible :name, :distributor_id, :last_price_update
  before_destroy :deleteProducts
  def deleteProducts
  	query = 'delete from products where manufacturer_id = ' + id.to_s + ';'  	
  	ActiveRecord::Base.connection.execute query 
  	return true
  end
end
